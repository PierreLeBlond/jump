extends CanvasLayer

class_name PauseMenu

signal wants_to_resume()
signal wants_to_load_checkpoint()
signal wants_to_restart()
signal wants_to_quit_to_main_menu()

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

func on_resume_button_pressed() -> void:
    wants_to_resume.emit()

func on_load_checkpoint_button_pressed() -> void:
    wants_to_load_checkpoint.emit()

func on_restart_button_pressed() -> void:
    wants_to_restart.emit()

func on_quit_to_main_menu_button_pressed() -> void:
    wants_to_quit_to_main_menu.emit()

func disable() -> void:
    resume_button.disabled = true
    load_checkpoint_button.disabled = true
    restart_button.disabled = true
    quit_to_main_menu_button.disabled = true

func enable() -> void:
    resume_button.disabled = false
    load_checkpoint_button.disabled = false
    restart_button.disabled = false
    quit_to_main_menu_button.disabled = false
