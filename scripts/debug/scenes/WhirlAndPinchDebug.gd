@tool

extends Node2D

class_name WhirlAndPinchDebug

@export var source: Node2D
@export var target: Node2D
@export var canvas_item: CanvasItem

@export var target_size: Vector2 = Vector2(256, 256)

@export var radius: float = 100.0
@export var whirl: float = 1.0:
    set(value):
        whirl = value
        if canvas_item:
            canvas_item.material.set_shader_parameter("whirl", value)
@export var pinch: float = 1.0:
    set(value):
        pinch = value
        if canvas_item:
            canvas_item.material.set_shader_parameter("pinch", value)

func _ready() -> void:
    var screen_radius = radius / source.get_viewport().get_final_transform().get_scale().x
    canvas_item.material.set_shader_parameter("radius", screen_radius)
    canvas_item.material.set_shader_parameter("whirl", whirl)
    canvas_item.material.set_shader_parameter("pinch", pinch)

func _process(_delta: float) -> void:
    canvas_item.material.set_shader_parameter("source_screen_position", source.get_viewport().get_final_transform() * source.get_global_transform_with_canvas().origin)
    canvas_item.material.set_shader_parameter("target_screen_size", target.get_viewport().size)
    var s_transform = source.get_viewport().get_final_transform() * source.get_canvas_transform()
    var screen_radius = radius * s_transform.get_scale().x
    canvas_item.material.set_shader_parameter("radius", screen_radius)
