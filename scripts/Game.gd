extends Node

class_name Game

@export var level_wrapper: Node

var current_scene: Node = null
var current_level: Level = null
var current_screen: Screen = null

func _ready() -> void:
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

    var release_in = await Transition.create_right_bar_transition_in(get_tree().root)
    release_in.call_deferred()

    return current_screen

func load_level(level_name: String) -> Level:
    var release = await Transition.create_right_bar_transition_out(get_tree().root)

    var release_loading = await Transition.create_loading_transition_in(get_tree().root)

    current_level = load_scene("res://scenes/levels/" + level_name + ".tscn")

    level_wrapper.add_child(current_level)

    release_loading.call_deferred()

    current_level.wants_to_quit.connect(quit_to_main_menu)
    current_level.wants_to_restart.connect(start_new_game)

    current_level.has_run_out_of_lives.connect(open_game_over)
    current_level.has_finished.connect(open_victory)

    release.call_deferred()

    get_tree().paused = false

    return current_level

func start_new_game() -> void:
    load_level("Level1")

func quit_to_main_menu() -> void:
    load_screen("MainMenu")

func open_victory(game_run: GameRun) -> void:
    var score = game_run.score
    var time = game_run.elapsed_time
    var victory_screen = await load_screen("Victory")
    victory_screen.score = score
    victory_screen.time = time
    victory_screen.focus()

func open_game_over() -> void:
    var game_over_screen = await load_screen("GameOver")
    game_over_screen.focus()

func open_leaderboard() -> void:
    var leaderboard_screen = await load_screen("Leaderboard")
    leaderboard_screen.update()
    leaderboard_screen.focus()
