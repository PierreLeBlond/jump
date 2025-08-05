extends Screen

class_name Victory

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
    restart_button.pressed.connect(restart)
    quit_to_main_menu_button.pressed.connect(quit_to_main_menu)

    score_submit.submitted.connect(quit_to_main_menu)

func focus() -> void:
    restart_button.grab_focus()