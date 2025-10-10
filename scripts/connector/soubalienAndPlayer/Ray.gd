extends ProjectileState

class_name Ray

const DEFAULT_RADIUS = 256

const CONE_ACCELERATION_DISTANCE = 512
const CONE_DECELERATION_DISTANCE = 8

@export var whirl_and_pinch: WhirlAndPinch

var tween: Tween

func enter(previous_state: State, delta: float) -> void:
    super (previous_state, delta)

    parent.velocity = Vector2.ZERO
    parent.set_collision_mask_value(1, false)

    whirl_and_pinch.setup()

    whirl_and_pinch.whirl = 0.0
    whirl_and_pinch.pinch = 0.1

    tween = create_tween()
    tween.tween_property(parent, "scale", Vector2(0.8, 0.8), 0.3)

    whirl_and_pinch.update_shader_source_position()

    acceleration_distance = CONE_ACCELERATION_DISTANCE
    deceleration_distance = CONE_DECELERATION_DISTANCE

    jump_time = parent.projectile_parameters.fall_time

func update(_delta: float) -> void:
    whirl_and_pinch.update_shader_source_position()

func exit() -> void:
    if tween:
        tween.kill()
        tween = null
    parent.set_collision_mask_value(1, true)
    parent.scale = Vector2(1, 1)
    whirl_and_pinch.cleanup()