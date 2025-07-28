extends Area2D

class_name Checkpoint

signal checkpoint_saved(checkpoint: Checkpoint)
signal checkpoint_loaded(checkpoint: Checkpoint)

@export var player: ProjectileCharacter
@export var portal: Portal

func _ready() -> void:
  body_entered.connect(on_body_entered)

func on_body_entered(_body: Node2D):
  save()

func save():
  body_entered.disconnect(on_body_entered)
  checkpoint_saved.emit(self)

func load():
  checkpoint_loaded.emit(self)
  await portal.release_player()
