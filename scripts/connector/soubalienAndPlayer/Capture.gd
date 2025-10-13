extends ProjectileState

class_name Capture

const FINAL_WHIRL = 0.3
const FINAL_PINCH = 0.2

const TWEEN_DURATION = 0.5

var tween: Tween

@export var whirl_and_pinch: WhirlAndPinch

func enter(previous_state: State, delta: float) -> void:
    super (previous_state, delta)

    parent.lock_key(Globals.PHYSICS_UNLOCKED_KEY)
    parent.set_collision_mask_value(1, false)
    parent.scale = Vector2(0.8, 0.8)

    whirl_and_pinch.whirl = 0.0
    whirl_and_pinch.pinch = 0.1

    tween = create_tween()
    tween.tween_property(whirl_and_pinch, "whirl", FINAL_WHIRL, TWEEN_DURATION)
    tween.parallel().tween_property(whirl_and_pinch, "pinch", FINAL_PINCH, TWEEN_DURATION)

    acceleration_distance = parent.projectile_parameters.air_acceleration_distance
    deceleration_distance = parent.projectile_parameters.air_deceleration_distance

    jump_time = parent.projectile_parameters.fall_time

func update(_delta: float) -> void:
    whirl_and_pinch.update_shader_source_position()

func exit() -> void:
    if tween:
        tween.kill()
        tween = null
    parent.set_collision_mask_value(1, true)
    parent.scale = Vector2(1, 1)
    parent.unlock_key(Globals.PHYSICS_UNLOCKED_KEY)

    whirl_and_pinch.whirl = 0.0
    whirl_and_pinch.pinch = 0.1
