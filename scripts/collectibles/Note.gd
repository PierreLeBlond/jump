extends Area2D

class_name Note

const note_layer = 4

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
  # Should offset animation based on horizontal position, for a wave effect
  var offset = floori(global_position.x / 32.0) % 20
  var time = float(offset) / 20.0
  animation_player.play("bounce")
  animation_player.seek(time)

func capture():
  set_collision_layer_value(note_layer, false)
  animation_player.play("fly")

func restore():
  set_collision_layer_value(note_layer, true)
  animation_player.play_backwards("fly")
  await animation_player.animation_finished
  animation_player.play_backwards("bounce")
