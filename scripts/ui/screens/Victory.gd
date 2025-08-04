extends CanvasLayer

class_name Victory

signal wants_to_restart()
signal wants_to_quit_to_main_menu()

signal closed()

@export var restart_button: Button
@export var quit_to_main_menu_button: Button

@export var score_submit: ScoreSubmit

var score: int = 0:
    set(value):
        score = value
        score_submit.score = value

var time: float = 0:
    set(value):
        time = value
        score_submit.time = value

func _ready() -> void:
    restart_button.pressed.connect(on_restart_button_pressed)
    quit_to_main_menu_button.pressed.connect(quit_to_main_menu)

    score_submit.submitted.connect(quit_to_main_menu)

func focus() -> void:
    restart_button.grab_focus()

func close() -> void:
    var parent = get_parent()

    if parent:
        parent.remove_child(self)

    closed.emit()

func on_restart_button_pressed() -> void:
    wants_to_restart.emit()
    close()

func quit_to_main_menu() -> void:
    wants_to_quit_to_main_menu.emit()
    close()
