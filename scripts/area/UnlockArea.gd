class_name UnlockArea

extends Area2D

@export_enum(Globals.JUMP_UNLOCKED_KEY, Globals.RUN_UNLOCKED_KEY, Globals.MOVE_UNLOCKED_KEY, Globals.PAUSE_UNLOCKED_KEY) var unlocked_keys: Array[String]
@export_enum(Globals.JUMP_UNLOCKED_KEY, Globals.RUN_UNLOCKED_KEY, Globals.MOVE_UNLOCKED_KEY, Globals.PAUSE_UNLOCKED_KEY) var locked_keys: Array[String]

func _ready() -> void:
  body_entered.connect(on_body_entered)

func on_body_entered(body: Node) -> void:
  if (body is not ProjectileCharacter):
    return

  for key in unlocked_keys:
    body.unlock_key(key)

  for key in locked_keys:
    body.lock_key(key)
