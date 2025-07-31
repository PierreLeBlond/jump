extends CanvasLayer

class_name GameOver

@export var animation_player: AnimationPlayer

signal wants_to_restart()
signal wants_to_quit_to_main_menu()

signal opened()
signal closed()

@export var restart_button: Button
@export var quit_to_main_menu_button: Button

func _ready() -> void:
    restart_button.pressed.connect(on_restart_button_pressed)
    quit_to_main_menu_button.pressed.connect(on_quit_to_main_menu_button_pressed)

func immediately_close() -> void:
    animation_player.play_backwards("open")
    animation_player.seek(0.0)
    visible = false

func open() -> void:
    visible = true
    restart_button.grab_focus()
    animation_player.play("open")
    opened.emit()
    process_mode = Node.PROCESS_MODE_ALWAYS
    await animation_player.animation_finished

func close() -> void:
    animation_player.play_backwards("open")
    await animation_player.animation_finished
    closed.emit()
    process_mode = Node.PROCESS_MODE_DISABLED
    visible = false

func on_restart_button_pressed() -> void:
    wants_to_restart.emit()
    close()

func on_quit_to_main_menu_button_pressed() -> void:
    wants_to_quit_to_main_menu.emit()
    close()
