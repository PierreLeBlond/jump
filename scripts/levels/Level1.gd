extends Node

class_name Level1

@export var player: ProjectileCharacter

@export var camera: Camera

@export var camera_manager: CameraManager

@export var soubalien: Soubalien
@export var soubalien_introduce_path: Path
@export var soubalien_chase_path: Path

@export var transition_mask: TransitionMask

@export var end_portal: Portal

@export var checkpoint: Checkpoint

@export var countdown_animation_player: AnimationPlayer

@export var cinematic_bars: CinematicBars

@export var hud: Control

@export var race_introduction_area: Area2D
@export var race_introduction_camera: Camera

func _ready() -> void:
	transition_mask.transition_out()

	end_portal.spawn()
	end_portal.player_captured.connect(on_player_captured)

	soubalien.visible = false
	soubalien.process_mode = Node.PROCESS_MODE_DISABLED
	race_introduction_area.body_entered.connect(introduce_race)

func show_hud() -> void:
	var tween = create_tween()
	tween.tween_property(hud, "modulate:a", 1.0, 0.5)

func hide_hud() -> void:
	var tween = create_tween()
	tween.tween_property(hud, "modulate:a", 0.0, 0.5)

func introduce_race(_body: Node2D) -> void:
	race_introduction_area.body_entered.disconnect(introduce_race)

	player.unlocked_keys.keys[Globals.MOVE_UNLOCKED_KEY] = false
	# TODO : Play surprise animation
	await get_tree().create_timer(1.0).timeout

	hide_hud()
	cinematic_bars.reveal()
	await camera.zoom_to(Vector2(0.9, 0.9), 0.5)

	soubalien.visible = true
	soubalien.process_mode = Node.PROCESS_MODE_INHERIT

	camera_manager.jump_to(race_introduction_camera)
	soubalien_introduce_path.call_deferred("set_child", soubalien)
	await soubalien_introduce_path.start()

	camera.zoom_to(Vector2(1, 1), 0.5)

	start_chase()

func start_chase() -> void:
	camera.restore_target()
	soubalien_chase_path.call_deferred("set_child", soubalien)
	soubalien_chase_path.reset()

	await get_tree().create_timer(1.5).timeout

	soubalien.captured_player.connect(on_player_captured)
	soubalien.ray_captured_player.connect(on_ray_captured_player)

	cinematic_bars.unreveal()

	countdown_animation_player.play("countdown")
	await countdown_animation_player.animation_finished

	show_hud()

	player.unlocked_keys.keys[Globals.MOVE_UNLOCKED_KEY] = true

	soubalien_chase_path.start()


func end_game() -> void:
	var tree = get_tree()
	tree.change_scene_to_file("res://scenes/ui/TitleScreen.tscn")

func load_checkpoint():
	soubalien.restore_player()
	checkpoint.load()
	camera.unfocus(0.0)
	camera.jump_to_target()
	start_chase()
	await transition_mask.transition_out()

func play_death_transition() -> void:
	await transition_mask.transition_in()
	load_checkpoint()
	# end_game()

func on_player_captured() -> void:
	soubalien.captured_player.disconnect(on_player_captured)
	soubalien.ray_captured_player.disconnect(on_ray_captured_player)
	play_death_transition()

func on_ray_captured_player() -> void:
	cinematic_bars.reveal()
	player.unlocked_keys.keys[Globals.MOVE_UNLOCKED_KEY] = false
	soubalien_chase_path.stop()
	camera.restore_target()
	camera.focus(1.0)
