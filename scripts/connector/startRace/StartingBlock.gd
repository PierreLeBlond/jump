extends ProjectileState

class_name StartingBlock

func enter(previous_state: State, delta: float) -> void:
    super (previous_state, delta)

    parent.lock_key(Globals.MOVE_UNLOCKED_KEY)
    parent.lock_key(Globals.JUMP_UNLOCKED_KEY)

    final_velocity = 0

func update(_delta: float) -> void:
    super (_delta)

    if parent.movement_controller.get_direction() != 0:
        parent.animation_player.play("startingblockrun")
    else:
        parent.animation_player.play("startingblock")

func exit() -> void:
    parent.unlock_key(Globals.MOVE_UNLOCKED_KEY)
    parent.unlock_key(Globals.JUMP_UNLOCKED_KEY)