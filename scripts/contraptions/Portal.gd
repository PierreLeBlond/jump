extends Node2D

class_name Portal

signal player_captured

@export var player: ProjectileCharacter
@export var area: Area2D
@export var animationPlayer: AnimationPlayer

var is_player_captured: bool = false

func on_body_entered(body: Node2D) -> void:
  if (body is not ProjectileCharacter):
    return

  await capture_player()
  player_captured.emit()

func spawn() -> void:
  area.body_entered.connect(on_body_entered)
  await appear()
  animationPlayer.play("Float")

func appear() -> void:
  animationPlayer.play("Appear")
  await animationPlayer.animation_finished

func disappear() -> void:
  animationPlayer.play("Disappear")
  await animationPlayer.animation_finished

func capture_player() -> void:
  player.is_externally_controlled = true
  var tween = create_tween()
  tween.tween_property(player, "scale", Vector2(0, 0), 0.5)
  is_player_captured = true
  area.body_entered.disconnect(on_body_entered)
  await disappear()

func release_player() -> void:
  player.is_externally_controlled = true
  player.global_position = global_position
  player.scale = Vector2(1, 1)
  player.modulate.a = 0
  await appear()
  var tween = create_tween()
  tween.tween_property(player, "modulate:a", 1, 0.5)
  player.velocity = Vector2.UP * 700
  player.is_externally_controlled = false
  is_player_captured = false
  disappear()


func _physics_process(delta: float) -> void:
  if (is_player_captured):
    player.global_position = lerp(player.global_position, global_position, delta * 10)
