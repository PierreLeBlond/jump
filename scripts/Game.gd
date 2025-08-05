extends Node

class_name Game

var left_bar_transition: SceneTransition
var right_bar_transition: SceneTransition

@export var pause_manager: PauseManager
@export var game_run: GameRun
@export var level_wrapper: Node

var current_scene: Node = null
var current_level: Level = null
var current_screen: Screen = null

func _ready() -> void:
    left_bar_transition = load("res://scenes/ui/transitions/scenes/LeftBarTransition.tscn").instantiate()
    add_child(left_bar_transition)
    left_bar_transition.hide()
    right_bar_transition = load("res://scenes/ui/transitions/scenes/RightBarTransition.tscn").instantiate()
    add_child(right_bar_transition)
    right_bar_transition.hide()

    pause_manager.paused.connect(pause)
    pause_manager.resumed.connect(resume)

    load_screen("MainMenu")

func unload_current_scene() -> void:
    if !current_scene:
        return

    current_scene.queue_free()
    current_scene = null

func load_scene(scene_name: String) -> Node:
    unload_current_scene()

    var scene_resource = load(scene_name)
    if !scene_resource:
        print("Scene resource not found: ", scene_name)
        return

    current_scene = scene_resource.instantiate()
    level_wrapper.add_child(current_scene)

    return current_scene

func load_screen(screen_name: String) -> Screen:
    if current_scene:
        await left_bar_transition.transition_out()

    current_screen = load_scene("res://scenes/ui/screens/" + screen_name + ".tscn")

    current_screen.wants_to_load_level.connect(load_level)
    current_screen.wants_to_start_new_game.connect(start_new_game)
    current_screen.wants_to_quit_to_main_menu.connect(quit_to_main_menu)
    current_screen.wants_to_open_leaderboard.connect(open_leaderboard)

    current_screen.focus()

    pause_manager.level = null

    left_bar_transition.hide()
    await right_bar_transition.transition_in()
    return current_screen

func load_level(level_name: String) -> Level:
    await right_bar_transition.transition_out()

    current_level = load_scene("res://scenes/levels/" + level_name + ".tscn")

    current_level.wants_to_load_level.connect(load_level)
    current_level.wants_to_start_new_game.connect(start_new_game)
    current_level.wants_to_quit_to_main_menu.connect(quit_to_main_menu)

    current_level.died.connect(die)
    current_level.finished.connect(finish)
    current_level.score_added.connect(func(value: int): game_run.add_score(value))
    current_level.life_added.connect(func(value: int): game_run.add_life(value))

    current_level.game_run = game_run

    pause_manager.level = current_level

    resume()

    right_bar_transition.hide()
    await left_bar_transition.transition_in()

    return current_level

func load_checkpoint() -> void:
    current_level.load_checkpoint()

func die() -> void:
    if (game_run.life > 0):
        game_run.add_life(-1)
        load_checkpoint()
    else:
        open_game_over()

func finish() -> void:
    pause()
    var victory_screen = await load_screen("Victory")
    victory_screen.score = game_run.score
    victory_screen.time = game_run.accumulated_time
    victory_screen.focus()

func start_new_game() -> void:
    game_run.reset()
    load_level("Level1")

func quit_to_main_menu() -> void:
    game_run.reset()
    load_screen("MainMenu")

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
