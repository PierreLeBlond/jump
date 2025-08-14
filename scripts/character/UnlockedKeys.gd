class_name UnlockedKeys

var keys: Dictionary = {
  Globals.JUMP_UNLOCKED_KEY: true,
  Globals.RUN_UNLOCKED_KEY: true,
  Globals.MOVE_UNLOCKED_KEY: true,
  Globals.PAUSE_UNLOCKED_KEY: true,
  Globals.PHYSICS_UNLOCKED_KEY: true,
}

func has_unlocked_jump() -> bool:
    return keys[Globals.JUMP_UNLOCKED_KEY]

func has_unlocked_run() -> bool:
    return keys[Globals.RUN_UNLOCKED_KEY]

func has_unlocked_move() -> bool:
    return keys[Globals.MOVE_UNLOCKED_KEY]

func has_unlocked_pause() -> bool:
    return keys[Globals.PAUSE_UNLOCKED_KEY]

# Allows external control of the player by deactivating the physics process
func has_unlocked_physics() -> bool:
    return keys[Globals.PHYSICS_UNLOCKED_KEY]