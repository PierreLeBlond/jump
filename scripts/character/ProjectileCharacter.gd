extends CharacterBody2D

class_name ProjectileCharacter

@export var corner_corrector: CornerCorrector

@export var cliff_detector: CliffDetector

@export var wall_detector: WallDetector

@export var state_machine: StateMachine

@export var lateral_accelerator: LateralAccelerator
@export var horizontal_accelerator: HorizontalAccelerator

@export var movement_controller: MovementController

@export var projectile_parameters: ProjectileParameters

@export var view: Node2D

@export var animation_player: AnimationPlayer
@export var sprite_2d: Sprite2D

@export var collector: Collector

var unlocked_keys: UnlockedKeys = UnlockedKeys.new()

var external_accelerations: Dictionary[String, Vector2] = {}

# 1 or -1
var direction: int = 1

func _ready() -> void:
    corner_corrector.init(self)

func _physics_process(delta: float) -> void:
    var controller_direction = movement_controller.get_direction()
    if (controller_direction != 0 && direction != controller_direction):
        direction = controller_direction
        sprite_2d.scale.x = direction * abs(sprite_2d.scale.x)

    corner_corrector.apply_corner_correction()

    state_machine.update(delta)

    if !unlocked_keys.has_unlocked_physics():
        return

    lateral_accelerator.maximum_velocity = state_machine.current_state.maximum_velocity
    lateral_accelerator.final_velocity = state_machine.current_state.final_velocity * controller_direction
    lateral_accelerator.acceleration_distance = state_machine.current_state.acceleration_distance
    lateral_accelerator.deceleration_distance = state_machine.current_state.deceleration_distance

    horizontal_accelerator.jump_height = state_machine.current_state.jump_height
    horizontal_accelerator.jump_time = state_machine.current_state.jump_time

    var controlled_acceleration = Vector2(lateral_accelerator.get_acceleration(delta), horizontal_accelerator.get_acceleration())

    # second part of the simplified velocity verlet with constant acceleration
    position += 0.5 * controlled_acceleration * delta * delta

    # The first part will be handled by move_and_slide
    # BUT in comparison to simply updating the position, not handling the collision, we have a half pixel error on jump height
    # if (velocity.y < 0):
        # position += velocity * delta
    # else:
    # velocity.x = 0.9481
    move_and_slide()

    # Final part of the simplified velocity verlet with constant acceleration
    velocity += controlled_acceleration * delta

    var external_velocity = Vector2.ZERO

    for external_acceleration in external_accelerations.values():
        external_velocity += external_acceleration * delta

    velocity += external_velocity


func wants_to_move() -> bool:
    return movement_controller.wants_to_move() && unlocked_keys.has_unlocked_move()

func wants_to_jump() -> bool:
    return movement_controller.wants_to_jump() && unlocked_keys.has_unlocked_jump()

func wants_to_walk() -> bool:
    return movement_controller.wants_to_walk()

func cancel_jump() -> bool:
    return movement_controller.cancel_jump()

func lock_key(key: String) -> void:
    unlocked_keys.keys[key] = false
    Events.emit_player_unlocked_keys_changed(unlocked_keys)

func unlock_key(key: String) -> void:
    unlocked_keys.keys[key] = true
    Events.emit_player_unlocked_keys_changed(unlocked_keys)
