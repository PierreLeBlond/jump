extends ProjectileState

class_name Capture

const TWEEN_DURATION = 0.5
const FINAL_WHIRL = 0.1
const FINAL_PINCH = 0.2

const DEFAULT_RADIUS = 256

@export var source: Node2D

@export var canvas_group: CanvasGroup
@export var canvas_group_parent: Node2D

@export var sprite: Sprite2D

@export var radius: float = DEFAULT_RADIUS

var tween: Tween

func enter(previous_state: State, delta: float) -> void:
    super (previous_state, delta)

    parent.lock_key(Globals.PHYSICS_UNLOCKED_KEY)
    parent.set_collision_mask_value(1, false)
    parent.scale = Vector2(0.8, 0.8)
    canvas_group.visible = true

    add_canvas_group()

    canvas_group.material.set_shader_parameter("whirl", 0.0)
    canvas_group.material.set_shader_parameter("pinch", 0.0)

    tween = create_tween()
    tween.tween_property(canvas_group.material, "shader_parameter/whirl", FINAL_WHIRL, TWEEN_DURATION)
    tween.parallel().tween_property(canvas_group.material, "shader_parameter/pinch", FINAL_PINCH, TWEEN_DURATION)

    update_shader_parameters()

func get_parameters() -> Dictionary:
    return {
        "jump_height": parent.projectile_parameters.jump_height,
        "jump_time": parent.projectile_parameters.fall_time,
        "maximum_lateral_velocity": maximum_lateral_velocity,
        "acceleration_factor": parent.projectile_parameters.air_acceleration_factor,
        "deceleration_factor": parent.projectile_parameters.air_deceleration_factor
    }

func update(_delta: float) -> void:
    update_shader_parameters()

func exit() -> void:
    if tween:
        tween.kill()
        tween = null
    parent.set_collision_mask_value(1, true)
    parent.scale = Vector2(1, 1)
    parent.unlock_key(Globals.PHYSICS_UNLOCKED_KEY)
    canvas_group.visible = false
    remove_canvas_group.call_deferred()

func add_canvas_group() -> void:
    canvas_group_parent.remove_child(canvas_group)
    parent.add_child(canvas_group)
    parent.remove_child(sprite)
    canvas_group.add_child(sprite)

func remove_canvas_group() -> void:
    canvas_group.remove_child(sprite)
    parent.add_child(sprite)
    parent.remove_child(canvas_group)
    canvas_group_parent.add_child(canvas_group)

func update_shader_parameters() -> void:
    canvas_group.material.set_shader_parameter("source_screen_position", source.get_viewport().get_screen_transform() * source.get_global_transform_with_canvas().origin)
    canvas_group.material.set_shader_parameter("target_screen_size", canvas_group.get_viewport().size)
    var s_transform = source.get_viewport().get_final_transform() * source.get_canvas_transform()
    var screen_radius = radius * s_transform.get_scale().x
    canvas_group.material.set_shader_parameter("radius", screen_radius)