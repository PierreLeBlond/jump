extends CharacterBody2D

class_name LateralMovement

@export var lateral_accelerator: LateralAccelerator

var jump_time: float = 0.4
var jump_distance: float = 420
var fall_time: float = 0.35

var final_velocity: float = jump_distance / (jump_time + fall_time)

var acceleration_distance: float = 256
var deceleration_distance: float = 64

var movement_factor: float = 1.0

func update_direction() -> void:
    var direction = 0
    if (Input.is_action_pressed("move_right")):
        direction += 1
    if (Input.is_action_pressed("move_left")):
        direction -= 1

    lateral_accelerator.acceleration_distance = acceleration_distance * movement_factor
    lateral_accelerator.deceleration_distance = deceleration_distance * movement_factor
    lateral_accelerator.final_velocity = final_velocity * direction * movement_factor

func _physics_process(delta: float) -> void:
    update_direction()

    var acceleration = Vector2(lateral_accelerator.get_acceleration(delta), 0)

    position += 0.5 * acceleration * delta * delta

    move_and_slide()

    velocity += acceleration * delta

func _input(_event: InputEvent) -> void:
    if Input.is_action_just_pressed("jump"):
        movement_factor = 0.1
    elif Input.is_action_just_released("jump"):
        movement_factor = 1.0
