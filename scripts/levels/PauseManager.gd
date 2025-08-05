extends Node

class_name PauseManager

signal paused()
signal resumed()

var pause_menu: PauseMenu

var level: Level:
    set(value):
        level = value
        if !level && get_tree().paused:
            close_pause_menu()

func _ready() -> void:
    process_mode = Node.PROCESS_MODE_ALWAYS

    pause_menu = load("res://scenes/ui/hud/PauseMenu.tscn").instantiate()

    pause_menu.wants_to_resume.connect(close_pause_menu)
    pause_menu.wants_to_load_checkpoint.connect(load_checkpoint)
    pause_menu.wants_to_restart.connect(start_new_game)
    pause_menu.wants_to_quit_to_main_menu.connect(quit_to_main_menu)

func _input(event: InputEvent) -> void:
    if !level || !event.is_action_pressed("pause"):
        return

    if get_tree().paused:
        print("close_pause_menu")
        close_pause_menu()
    else:
        print("open_pause_menu")
        open_pause_menu()

func open_pause_menu() -> void:
    paused.emit()
    get_tree().paused = true
    add_child(pause_menu)
    pause_menu.focus()

func close_pause_menu() -> void:
    remove_child(pause_menu)
    get_tree().paused = false
    resumed.emit()

func load_checkpoint() -> void:
    if !level:
        return

    if get_tree().paused:
        close_pause_menu()

    level.load_checkpoint()

func start_new_game() -> void:
    if !level:
        return

    if get_tree().paused:
        close_pause_menu()

    level.start_new_game()

func quit_to_main_menu() -> void:
    if !level:
        return

    level.quit_to_main_menu()
