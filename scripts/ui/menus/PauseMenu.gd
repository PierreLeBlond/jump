extends CanvasLayer

class_name PauseMenu

signal wants_to_resume()
signal wants_to_load_checkpoint()
signal wants_to_restart()
signal wants_to_quit_to_title_screen()

@export var resume_button: Button
@export var load_checkpoint_button: Button
@export var restart_button: Button
@export var quit_to_title_screen_button: Button
@export var options_button: Button

@export var options_manager: OptionsManager

func _ready() -> void:
    resume_button.pressed.connect(on_resume_button_pressed)
    load_checkpoint_button.pressed.connect(on_load_checkpoint_button_pressed)
    restart_button.pressed.connect(on_restart_button_pressed)
    quit_to_title_screen_button.pressed.connect(on_quit_to_title_screen_button_pressed)

    options_button.pressed.connect(options_manager.open_options)
    options_manager.options_closed.connect(func(): options_button.grab_focus())

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("pause") || event.is_action_pressed("ui_cancel"):
        get_viewport().set_input_as_handled()
        wants_to_resume.emit()

func focus() -> void:
    resume_button.grab_focus()

func on_resume_button_pressed() -> void:
    wants_to_resume.emit()

func on_load_checkpoint_button_pressed() -> void:
    wants_to_load_checkpoint.emit()

func on_restart_button_pressed() -> void:
    wants_to_restart.emit()

func on_quit_to_title_screen_button_pressed() -> void:
    wants_to_quit_to_title_screen.emit()

func disable() -> void:
    resume_button.disabled = true
    load_checkpoint_button.disabled = true
    restart_button.disabled = true
    quit_to_title_screen_button.disabled = true

func enable() -> void:
    resume_button.disabled = false
    load_checkpoint_button.disabled = false
    restart_button.disabled = false
    quit_to_title_screen_button.disabled = false
