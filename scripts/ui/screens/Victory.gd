extends Screen

class_name Victory

@export var start_new_game_button: Button
@export var quit_to_main_menu_button: Button

@export var on_screen_keyboard: OnScreenKeyboard
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
    start_new_game_button.pressed.connect(start_new_game)
    quit_to_main_menu_button.pressed.connect(quit_to_main_menu)

    score_submit.submitted.connect(quit_to_main_menu)

    start_new_game_button.grab_focus()

func disable() -> void:
    start_new_game_button.disabled = true
    quit_to_main_menu_button.disabled = true

func enable() -> void:
    start_new_game_button.disabled = false
    quit_to_main_menu_button.disabled = false