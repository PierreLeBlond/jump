extends Node

class_name Game

@export var hud: HUD
@export var pause_menu: PauseMenu
@export var game_run: GameRun

var current_level: Node = null

func _ready() -> void:
    load_level("MainMenu")

    game_run.life_changed.connect(func(value: int): hud.life_counter.update_counter(value))
    game_run.score_changed.connect(func(value: int): hud.score_counter.update_counter(value))
    game_run.time_changed.connect(func(value: int): hud.time_counter.update_counter(value))

    pause_menu.opened.connect(pause)
    pause_menu.closed.connect(resume)

    pause_menu.wants_to_resume.connect(resume)
    pause_menu.wants_to_load_checkpoint.connect(load_checkpoint)
    pause_menu.wants_to_restart.connect(start_new_game)
    pause_menu.wants_to_quit_to_main_menu.connect(quit_to_main_menu)
    pause_menu.hide()

func unload_current_level() -> void:
    if !current_level:
        return

    current_level.queue_free()
    current_level = null

func load_level(level_name: String) -> void:
    unload_current_level()

    var level_resource = load("res://scenes/levels/" + level_name + ".tscn")

    if !level_resource:
        print("Level resource not found: ", level_name)
        return

    current_level = level_resource.instantiate()
    current_level.initialize(hud)
    add_child(current_level)

    current_level.wants_to_load_level.connect(load_level)
    current_level.wants_to_start_new_game.connect(start_new_game)
    current_level.wants_to_quit_to_main_menu.connect(quit_to_main_menu)

    current_level.score_added.connect(func(value: int): game_run.add_score(value))
    current_level.life_added.connect(func(value: int): game_run.add_life(value))

func load_checkpoint() -> void:
    current_level.load_checkpoint()

func start_new_game() -> void:
    game_run.reset()
    load_level("Level1")

func quit_to_main_menu() -> void:
    game_run.reset()
    load_level("MainMenu")

func pause() -> void:
    get_tree().paused = true

func resume() -> void:
    get_tree().paused = false

func _input(event: InputEvent) -> void:
    if !event.is_action_pressed("pause") || !current_level.process_mode == Node.PROCESS_MODE_PAUSABLE:
        return

    if get_tree().paused:
        pause_menu.close()
    else:
        pause_menu.open()
