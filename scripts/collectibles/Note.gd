extends Area2D

class_name Note

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
  var offset = floori(global_position.x / 32.0) % 20
  var time = float(offset) / 20.0
  animation_player.play("bounce")
  animation_player.seek(time)
