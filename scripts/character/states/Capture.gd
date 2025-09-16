extends State

class_name Capture

const TWEEN_DURATION = 0.5
const FINAL_WHIRL = 1.0
const FINAL_PINCH = 1.0

@export var fall: State

@export var canvas_group: CanvasGroup
@export var sprite: Sprite2D

@export var radius: float = 128.0

var tween: Tween

func enter(previous_state: State, delta: float) -> void:
    super (previous_state, delta)

    parent.lock_key(Globals.PHYSICS_UNLOCKED_KEY)
    parent.set_collision_mask_value(1, false)
    canvas_group.visible = true

    parent.remove_child(sprite)
    canvas_group.add_child(sprite)

    canvas_group.material.set_shader_parameter("whirl", 0.0)
    canvas_group.material.set_shader_parameter("pinch", 0.0)

    tween = create_tween()
    tween.tween_property(canvas_group.material, "shader_parameter/whirl", FINAL_WHIRL, TWEEN_DURATION)
    tween.parallel().tween_property(canvas_group.material, "shader_parameter/pinch", FINAL_PINCH, TWEEN_DURATION)

func clear() -> void:
    if tween:
        tween.kill()
        tween = null
    parent.set_collision_mask_value(1, true)
    parent.unlock_key(Globals.PHYSICS_UNLOCKED_KEY)
    canvas_group.visible = false
    canvas_group.remove_child(sprite)
    parent.add_child(sprite)

func get_next_state(_delta: float) -> State:
    if (!parent.soubalien || !parent.soubalien.has_player_captured()):
        clear()
        return fall

    return null

func get_parameters() -> Dictionary:
    return {
        "jump_height": parent.projectile_parameters.jump_height,
        "jump_time": parent.projectile_parameters.fall_time,
        "maximum_lateral_velocity": maximum_lateral_velocity,
        "acceleration_factor": parent.projectile_parameters.air_acceleration_factor,
        "deceleration_factor": parent.projectile_parameters.air_deceleration_factor
    }

func update(_delta: float) -> void:
    var source = parent.soubalien.area
    canvas_group.material.set_shader_parameter("source_screen_position", source.get_viewport().get_screen_transform() * source.get_global_transform_with_canvas().origin)
    canvas_group.material.set_shader_parameter("target_screen_size", canvas_group.get_viewport().size)
    var s_transform = source.get_viewport().get_final_transform() * source.get_canvas_transform()
    var screen_radius = radius * s_transform.get_scale().x
    canvas_group.material.set_shader_parameter("radius", screen_radius)
