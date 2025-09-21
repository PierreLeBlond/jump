extends Node

class_name WhirlAndPinch

const DEFAULT_RADIUS = 128

@export var source: Node2D

@export var canvas_group: CanvasGroup
@export var canvas_group_parent: Node2D

@export var sprite: Sprite2D
@export var sprite_parent: Node2D

@export var radius: float = DEFAULT_RADIUS:
    set(value):
        radius = value
        if !source:
            return
        update_shader_parameters()
        
@export var whirl: float = 0.0:
    set(value):
        whirl = value
        if !canvas_group:
            return
        update_shader_parameters()

@export var pinch: float = 0.0:
    set(value):
        pinch = value
        if !canvas_group:
            return
        update_shader_parameters()

func setup() -> void:
    canvas_group.visible = true
    canvas_group.get_viewport().size_changed.connect(update_shader_parameters)
    setup_tree()

func cleanup() -> void:
    cleanup_tree()
    canvas_group.get_viewport().size_changed.disconnect(update_shader_parameters)
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
    var s_transform = source.get_viewport().get_final_transform() * source.get_canvas_transform()
    var screen_radius = radius * s_transform.get_scale().x
    canvas_group.material.set_shader_parameter("radius", screen_radius)

func update_shader_source_position() -> void:
    canvas_group.material.set_shader_parameter("source_position", source.global_position)