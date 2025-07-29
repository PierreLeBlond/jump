extends Button

class_name AnimatedButton

@export var animation_player: AnimationPlayer

func _ready() -> void:
    focus_entered.connect(on_focus_entered)
    focus_exited.connect(on_focus_exited)

    pressed.connect(on_pressed)

func on_focus_entered() -> void:
    animation_player.play("focus")

func on_focus_exited() -> void:
    animation_player.play_backwards("focus")

func on_pressed() -> void:
    animation_player.play("pressed")