extends Screen

class_name GameOver

@export var start_new_game_button: Button
@export var quit_to_main_menu_button: Button

func _ready() -> void:
    start_new_game_button.pressed.connect(start_new_game)
    quit_to_main_menu_button.pressed.connect(quit_to_main_menu)

func focus() -> void:
    start_new_game_button.grab_focus()
