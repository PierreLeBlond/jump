extends State

class_name Capture

@export var fall: State

var tween: Tween

func enter(previous_state: State, delta: float) -> void:
    super (previous_state, delta)

    parent.lock_key(Globals.PHYSICS_UNLOCKED_KEY)
    parent.set_collision_mask_value(1, false)
    tween = create_tween()
    tween.tween_property(parent, "scale", Vector2(0, 0), 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
    tween.parallel().tween_property(parent, "modulate:a", 0.0, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func clear() -> void:
    if tween:
        tween.kill()
        tween = null
    parent.set_collision_mask_value(1, true)
    parent.unlock_key(Globals.PHYSICS_UNLOCKED_KEY)
    parent.scale = Vector2(1, 1)
    parent.modulate.a = 1

func get_next_state(_delta: float) -> State:
    if (!parent.soubalien.has_player_captured()):
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
