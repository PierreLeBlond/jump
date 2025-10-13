extends ProjectileState

class_name Trip

var recovered: bool = false

const TRIP_DECELERATION_DISTANCE = 256

func enter(previous_state: State, delta: float) -> void:
    super (previous_state, delta)

    parent.lock_key(Globals.MOVE_UNLOCKED_KEY)
    parent.lock_key(Globals.JUMP_UNLOCKED_KEY)

    parent.animation_player.play("trip")
    parent.animation_player.queue("standup")
    parent.animation_player.animation_finished.connect(on_standup_finished)

    deceleration_distance = TRIP_DECELERATION_DISTANCE

    final_velocity = 0

    recovered = false

func on_standup_finished(_animation_name: String) -> void:
    recovered = true

func exit() -> void:
    parent.animation_player.animation_finished.disconnect(on_standup_finished)
    parent.unlock_key(Globals.MOVE_UNLOCKED_KEY)
    parent.unlock_key(Globals.JUMP_UNLOCKED_KEY)

func has_recovered() -> bool:
    return recovered