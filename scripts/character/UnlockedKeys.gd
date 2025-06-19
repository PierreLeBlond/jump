class_name UnlockedKeys

var keys: Dictionary = {
  Globals.JUMP_UNLOCKED_KEY: true,
  Globals.RUN_UNLOCKED_KEY: true
}

func has_unlocked_jump() -> bool:
    return keys[Globals.JUMP_UNLOCKED_KEY]

func has_unlocked_run() -> bool:
    return keys[Globals.RUN_UNLOCKED_KEY]