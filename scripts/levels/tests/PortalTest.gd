class_name PortalTest

extends Node2D

@export var portal: Portal

func _ready() -> void:
  portal.spawn()
  portal.player_captured.connect(on_player_captured)

func on_player_captured() -> void:
  portal.global_position.x += 200
  await portal.release_player()
  portal.global_position.x += 200
  portal.spawn()