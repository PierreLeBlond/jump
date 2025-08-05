extends Screen

class_name GameOver

@export var restart_button: Button
@export var quit_to_main_menu_button: Button

func _ready() -> void:
    restart_button.pressed.connect(restart)
    quit_to_main_menu_button.pressed.connect(quit_to_main_menu)

func focus() -> void:
    restart_button.grab_focus()
