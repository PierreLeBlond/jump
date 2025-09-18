extends Node

class_name Level

signal wants_to_quit()
signal wants_to_restart()

signal has_run_out_of_lives()
signal has_finished(game_run: GameRun)

@export var pause_manager: PauseManager
@export var checkpoint_manager: CheckpointManager

@export var initial_checkpoint_index: int = 0

@export var world_wrapper: Node

var game_state: GameState = GameState.new()

@export var world_name: String

var world: World = null

func _ready() -> void:
    pause_manager.paused.connect(pause)
    pause_manager.resumed.connect(resume)

    pause_manager.wants_to_load_checkpoint.connect(load_last_checkpoint)
    pause_manager.wants_to_restart.connect(restart)
    pause_manager.wants_to_quit.connect(quit)

    checkpoint_manager.checkpoint_saved.connect(on_checkpoint_saved)
    checkpoint_manager.checkpoint_pre_loaded.connect(on_checkpoint_pre_loaded)
    checkpoint_manager.checkpoint_loaded.connect(on_checkpoint_loaded)

    load_checkpoint.call_deferred(initial_checkpoint_index)

func on_checkpoint_saved() -> void:
    game_state.score = world.game_run.score
    game_state.time = world.game_run.elapsed_time

    for note in world.player.collector.collected_notes:
        game_state.notes.append(world.notes.find(note))

func on_checkpoint_pre_loaded() -> void:
    world.open_on_player()

func on_checkpoint_loaded() -> void:
    world.game_run.score = game_state.score
    world.game_run.elapsed_time = game_state.time
    world.game_run.life = game_state.life

    for index in game_state.notes:
        var note = world.notes[index]
        note.capture()
        world.player.collector.collected_notes.append(note)

func pause() -> void:
    world.pause()

func resume() -> void:
    world.resume()

func unload_world() -> void:
    if world:
        world.free()
        world = null

func load_world() -> void:
    # Life does persist through level loading
    if world:
        game_state.life = world.game_run.life

    var release_loading = await Transition.create_loading_transition_in(get_tree().root)
    unload_world()

    world = load("res://scenes/levels/worlds/" + world_name + ".tscn").instantiate()
    world_wrapper.add_child(world)
    checkpoint_manager.activate_checkpoints(world)
    world.has_died.connect(die)
    world.has_finished.connect(finish)
    release_loading.call_deferred()

func load_checkpoint(checkpoint_index: int = 0) -> void:
    await load_world()
    checkpoint_manager.load(checkpoint_index)

func load_last_checkpoint() -> void:
    await load_world()
    checkpoint_manager.load_last_checkpoint()

func quit() -> void:
    wants_to_quit.emit()

func restart() -> void:
    wants_to_restart.emit()

func die() -> void:
    # We'll need to also update game state life when life can be collected
    if world.game_run.life > 0:
        load_last_checkpoint.call_deferred()
    else:
        has_run_out_of_lives.emit()

func finish() -> void:
    has_finished.emit(world.game_run)
