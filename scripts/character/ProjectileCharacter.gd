extends CharacterBody2D

class_name ProjectileCharacter

@export var corner_corrector: CornerCorrector

@export var cliff_detector: CliffDetector

@export var wall_detector: WallDetector

@export var state_machine: StateMachine

@export var movement_controller: MovementController

@export var projectile_parameters: ProjectileParameters

@export var animation_player: AnimationPlayer

@export var sprite_2d: Sprite2D

@export var collector: Collector

var unlocked_keys: UnlockedKeys = UnlockedKeys.new()

var external_accelerations: Dictionary[String, Vector2] = {}

var direction: int = 1

func _ready() -> void:
    corner_corrector.init(self)

func _physics_process(delta: float) -> void:
    if (velocity.y < 0):
        corner_corrector.apply_corner_correction()

    state_machine.update(delta)

    if !unlocked_keys.has_unlocked_physics():
        return

    # TODO: current_state is not correctly typed has a projectile state
    var controlled_velocity = state_machine.current_state.get_velocity(delta)
    var external_velocity = Vector2.ZERO

    for acceleration in external_accelerations.values():
        external_velocity += acceleration * delta
    velocity = controlled_velocity + external_velocity

    move_and_slide()

    var controller_direction = movement_controller.get_direction()
    if (controller_direction == 0 || direction == controller_direction):
        return

    direction = controller_direction
    sprite_2d.scale.x = direction * abs(sprite_2d.scale.x)

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
