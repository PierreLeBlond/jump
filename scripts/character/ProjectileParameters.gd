extends Node

class_name ProjectileParameters

@export var jump_height: float = 128

@export var jump_time: float = 0.4

@export var fall_time: float = 0.3

@export var jump_distance: float = 64

var maximum_velocity: float = jump_distance / (jump_time + fall_time)

@export var max_double_jumps: int = 1

@export var double_jump_height: float = 32

@export var double_jump_time: float = 0.3

@export var double_jump_distance: float = 96

var double_jump_maximum_velocity: float = double_jump_distance / (double_jump_time + fall_time)

@export var acceleration_time: float = 0.1

@export var deceleration_time: float = 0.1

@export var air_acceleration_time: float = 0.25

@export var air_deceleration_time: float = 0.15


# We don't want the player to be able to move back to the wall after the wall jump, hence less air controls

@export var wall_jump_acceleration_time: float = 0.45

@export var wall_jump_deceleration_time: float = 0.35

@export var run_factor: float = 3

@export var wall_friction_factor: float = 0.5

@export var minimum_jump_pressed_time: float = 0.05

@export var maximum_jump_pressed_time: float = 0.5

@export var buffered_jump_frames: int = 6

@export var coyote_jump_frames: int = 6
