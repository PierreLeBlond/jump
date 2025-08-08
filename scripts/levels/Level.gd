extends Node

class_name Level

signal wants_to_load_level(level_name: String)
signal wants_to_quit_to_main_menu()
signal wants_to_start_new_game()

signal game_over()
signal victory()
signal score_added(value: int)
signal life_added(value: int)

@export var player: ProjectileCharacter
@export var player_camera: Camera
@export var camera_manager: CameraManager

@export var checkpoint_manager: CheckpointManager

var hud: HUD

var game_run: GameRun
        
func _init() -> void:
    hud = load("res://scenes/ui/hud/HUD.tscn").instantiate()

func _ready() -> void:
    if !game_run:
        game_run = GameRun.new()
        add_child(game_run)

    game_run.life_changed.connect(hud.life_counter.update_counter)
    game_run.score_changed.connect(hud.score_counter.update_counter)
    game_run.time_changed.connect(hud.time_counter.update_time_counter)

    hud.life_counter.update_counter(game_run.life)
    hud.score_counter.update_counter(game_run.score)
    hud.time_counter.update_time_counter(game_run.accumulated_time)

    checkpoint_manager.activate_checkpoints(self, game_run)

    player.collector.note_collected.connect(add_score)
    player.collector.life_collected.connect(add_life)


func load_level(level_name: String) -> void:
    wants_to_load_level.emit(level_name)

func load_checkpoint() -> void:
    checkpoint_manager.load()
    await camera_manager.jump_to(player_camera)
    var release = await Transition.create_circle_transition_in(get_tree().root, checkpoint_manager.current_checkpoint.portal)
    release.call_deferred()

func quit_to_main_menu() -> void:
    wants_to_quit_to_main_menu.emit()

func start_new_game() -> void:
    wants_to_start_new_game.emit()

func show_hud() -> void:
    if hud.get_parent():
        return

    add_child(hud)

func hide_hud() -> void:
    if !hud.get_parent():
        return

    remove_child(hud)

func die() -> void:
    if game_run.life > 0:
        game_run.add_life(-1)
        load_checkpoint()
    else:
        game_over.emit()

func finish() -> void:
    victory.emit()

func add_score(value: int) -> void:
    score_added.emit(value)

func add_life(value: int) -> void:
    life_added.emit(value)
