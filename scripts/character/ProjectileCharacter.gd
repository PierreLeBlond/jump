extends CharacterBody2D

class_name ProjectileCharacter

signal direction_changed(direction: int)

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

var is_in_gravity_field: bool = false

var direction: int = 1

func _ready() -> void:
    corner_corrector.init(self)
    state_machine.init(self)

func _physics_process(delta: float) -> void:
    if !unlocked_keys.has_unlocked_physics():
        return

    if (velocity.y < 0):
        corner_corrector.apply_corner_correction()

    state_machine.handle_physics(delta)

    var controller_direction = movement_controller.get_direction()
    if (controller_direction == 0 || direction == controller_direction):
        return

    direction = controller_direction
    direction_changed.emit(direction)

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
    Events.player_unlocked_keys_changed.emit(unlocked_keys)

func unlock_key(key: String) -> void:
    unlocked_keys.keys[key] = true
    Events.player_unlocked_keys_changed.emit(unlocked_keys)