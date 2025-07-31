extends Node

class_name PauseMenu

@export var animation_player: AnimationPlayer

signal wants_to_resume()
signal wants_to_load_checkpoint()
signal wants_to_restart()
signal wants_to_quit_to_main_menu()

signal opened()
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

func hide() -> void:
    animation_player.play_backwards("open")
    animation_player.seek(0.0)

func open() -> void:
    resume_button.grab_focus()
    animation_player.play("open")
    opened.emit()
    process_mode = Node.PROCESS_MODE_ALWAYS
    await animation_player.animation_finished

func close() -> void:
    animation_player.play_backwards("open")
    await animation_player.animation_finished
    closed.emit()
    process_mode = Node.PROCESS_MODE_DISABLED

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
