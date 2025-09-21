extends Node2D

class_name WhirlAndPinchDebug

@export var source: Node2D

@export var whirl_and_pinch: WhirlAndPinch
@export var sprite_parent: Node2D
@export var sprite: Sprite2D

func _ready() -> void:
    whirl_and_pinch.sprite = sprite
    whirl_and_pinch.sprite_parent = sprite_parent
    init.call_deferred()

func init() -> void:
    whirl_and_pinch.setup()
    whirl_and_pinch.update_shader_parameters()
    whirl_and_pinch.update_shader_source_position()

func _process(_delta: float) -> void:
    whirl_and_pinch.update_shader_source_position()

# Move source with arrows
func _input(event: InputEvent) -> void:
    if event is InputEventKey and event.pressed:
        if event.keycode == KEY_UP:
            source.position.y -= 10
        elif event.keycode == KEY_DOWN:
            source.position.y += 10
        elif event.keycode == KEY_LEFT:
            source.position.x -= 10
        elif event.keycode == KEY_RIGHT:
            source.position.x += 10
