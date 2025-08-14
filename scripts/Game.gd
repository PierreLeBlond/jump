extends Node

class_name Game

@export var pause_manager: PauseManager
@export var game_run: GameRun
@export var level_wrapper: Node

var current_scene: Node = null
var current_level: Level = null
var current_screen: Screen = null

func _ready() -> void:
    pause_manager.paused.connect(pause)
    pause_manager.resumed.connect(resume)

    call_deferred("load_screen", "MainMenu")

func unload_current_scene() -> void:
    if !current_scene:
        return

    current_scene.queue_free()
    current_scene = null

func load_scene(scene_name: String) -> Node:
    unload_current_scene()

    var scene_resource = load(scene_name)
    if !scene_resource:
        push_error("Scene resource not found: ", scene_name)
        return

    current_scene = scene_resource.instantiate()

    return current_scene

func load_screen(screen_name: String) -> Screen:
    if current_screen:
        var release_out = await Transition.create_left_bar_transition_out(get_tree().root)
        release_out.call_deferred()

    current_screen = load_scene("res://scenes/ui/screens/" + screen_name + ".tscn")

    add_child(current_screen)

    current_screen.wants_to_load_level.connect(load_level)
    current_screen.wants_to_start_new_game.connect(start_new_game)
    current_screen.wants_to_quit_to_main_menu.connect(quit_to_main_menu)
    current_screen.wants_to_open_leaderboard.connect(open_leaderboard)

    current_screen.focus()

    pause_manager.level = null

    var release_in = await Transition.create_right_bar_transition_in(get_tree().root)
    release_in.call_deferred()

    return current_screen

func load_level(level_name: String) -> Level:
    var release = await Transition.create_right_bar_transition_out(get_tree().root)

    current_level = load_scene("res://scenes/levels/" + level_name + ".tscn")

    current_level.game_run = game_run

    level_wrapper.add_child(current_level)

    current_level.wants_to_load_level.connect(load_level)
    current_level.wants_to_start_new_game.connect(start_new_game)
    current_level.wants_to_quit_to_main_menu.connect(quit_to_main_menu)

    current_level.game_over.connect(open_game_over)
    current_level.victory.connect(open_victory)

    pause_manager.level = current_level

    Events.player_unlocked_keys_changed.emit(current_level.player.unlocked_keys)

    resume()

    release.call_deferred()

    return current_level

func start_new_game() -> void:
    game_run.reset()
    load_level("Level1")

func quit_to_main_menu() -> void:
    game_run.reset()
    load_screen("MainMenu")

func open_victory() -> void:
    pause()
    var victory_screen = await load_screen("Victory")
    victory_screen.score = game_run.score
    victory_screen.time = game_run.accumulated_time
    victory_screen.focus()

func open_game_over() -> void:
    var game_over_screen = await load_screen("GameOver")
    game_over_screen.focus()

func open_leaderboard() -> void:
    var leaderboard_screen = await load_screen("Leaderboard")
    leaderboard_screen.update()
    leaderboard_screen.focus()

func pause() -> void:
    game_run.pause()

func resume() -> void:
    game_run.play()
