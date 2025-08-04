extends CanvasLayer

class_name PauseMenu

signal wants_to_resume()
signal wants_to_load_checkpoint()
signal wants_to_restart()
signal wants_to_quit_to_main_menu()

signal closed()

@export var resume_button: Button
@export var load_checkpoint_button: Button
@export var restart_button: Button
@export var quit_to_main_menu_button: Button

func _ready() -> void:
    resume_button.pressed.connect(on_resume_button_pressed)
    load_checkpoint_button.pressed.connect(on_load_checkpoint_button_pressed)
    restart_button.pressed.connect(on_restart_button_pressed)
    quit_to_main_menu_button.pressed.connect(on_quit_to_main_menu_button_pressed)

func focus() -> void:
    resume_button.grab_focus()

func close() -> void:
    var parent = get_parent()

    if parent:
        parent.remove_child(self)

    closed.emit()

func on_resume_button_pressed() -> void:
    wants_to_resume.emit()
    close()

func on_load_checkpoint_button_pressed() -> void:
    wants_to_load_checkpoint.emit()
    close()

func on_restart_button_pressed() -> void:
    wants_to_restart.emit()
    close()

func on_quit_to_main_menu_button_pressed() -> void:
    wants_to_quit_to_main_menu.emit()
    close()
