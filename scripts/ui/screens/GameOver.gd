extends CanvasLayer

class_name GameOver

signal wants_to_restart()
signal wants_to_quit_to_main_menu()

signal closed()

@export var restart_button: Button
@export var quit_to_main_menu_button: Button

func _ready() -> void:
    restart_button.pressed.connect(on_restart_button_pressed)
    quit_to_main_menu_button.pressed.connect(on_quit_to_main_menu_button_pressed)

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

func on_quit_to_main_menu_button_pressed() -> void:
    wants_to_quit_to_main_menu.emit()
    close()
