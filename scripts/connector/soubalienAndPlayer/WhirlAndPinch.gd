extends Node

class_name WhirlAndPinch

const DEFAULT_RADIUS = 256

@export var source: Node2D

@export var canvas_group: CanvasGroup
@export var canvas_group_parent: Node2D

@export var sprite: Sprite2D
@export var sprite_parent: Node2D

@export var radius: float = DEFAULT_RADIUS:
    set(value):
        radius = value
        var s_transform = source.get_viewport().get_final_transform() * source.get_canvas_transform()
        var screen_radius = radius * s_transform.get_scale().x
        canvas_group.material.set_shader_parameter("radius", screen_radius)

@export var whirl: float = 0.0:
    set(value):
        whirl = value
        canvas_group.material.set_shader_parameter("whirl", whirl)

@export var pinch: float = 0.0:
    set(value):
        pinch = value
        canvas_group.material.set_shader_parameter("pinch", pinch)

func setup() -> void:
    canvas_group.visible = true
    setup_tree()

func cleanup() -> void:
    cleanup_tree()
    canvas_group.visible = false

func setup_tree() -> void:
    canvas_group_parent.remove_child(canvas_group)
    sprite_parent.add_child(canvas_group)
    sprite_parent.remove_child(sprite)
    canvas_group.add_child(sprite)

func cleanup_tree() -> void:
    canvas_group.remove_child(sprite)
    sprite_parent.add_child(sprite)
    sprite_parent.remove_child(canvas_group)
    canvas_group_parent.add_child(canvas_group)

func update_shader_parameters() -> void:
    canvas_group.material.set_shader_parameter("source_screen_position", source.get_viewport().get_screen_transform() * source.get_global_transform_with_canvas().origin)
    canvas_group.material.set_shader_parameter("target_screen_size", canvas_group.get_viewport().size)