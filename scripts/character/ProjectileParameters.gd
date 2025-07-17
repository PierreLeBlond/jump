extends Node

class_name ProjectileParameters

@export var jump_height: float = 256

@export var jump_time: float = 0.4

@export var fall_time: float = 0.3

@export var jump_distance: float = 70

var maximum_velocity: float = jump_distance / (jump_time + fall_time)

@export var max_double_jumps: int = 1

@export var double_jump_height: float = 74

@export var double_jump_time: float = 0.3

@export var double_jump_distance: float = 128

var double_jump_maximum_velocity: float = double_jump_distance / (double_jump_time + fall_time)

@export var acceleration_factor: float = 1000

@export var deceleration_factor: float = 2000

# Should allow the player to come to a stop quickly when releasing controls
@export var idle_deceleration_factor: float = 600

@export var air_acceleration_factor: float = 1600

@export var air_deceleration_factor: float = 800

# We don't want the player to be able to move back higher on the wall after the a wall jump, hence less air controls
@export var wall_jump_acceleration_factor: float = 900

@export var wall_jump_deceleration_factor: float = 700

@export var run_factor: float = 6

@export var wall_friction_factor: float = 0.5

@export var minimum_jump_pressed_time: float = 0.1

@export var buffered_jump_frames: int = 6

@export var coyote_jump_frames: int = 6
