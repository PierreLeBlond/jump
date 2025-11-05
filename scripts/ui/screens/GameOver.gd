extends Screen

class_name GameOver

@export var start_new_game_button: Button
@export var quit_to_title_screen_button: Button

func _ready() -> void:
    start_new_game_button.pressed.connect(start_new_game)
    quit_to_title_screen_button.pressed.connect(quit_to_title_screen)

func focus() -> void:
    start_new_game_button.grab_focus()

func disable() -> void:
    start_new_game_button.disabled = true
    quit_to_title_screen_button.disabled = true

func enable() -> void:
    start_new_game_button.disabled = false
    quit_to_title_screen_button.disabled = false
