extends Resource

class_name ProjectileParameters

@export var jump_height: float = 256

@export var jump_time: float = 0.4

@export var fall_time: float = 0.35

@export var jump_distance: float = 420

var final_velocity: float = jump_distance / (jump_time + fall_time)

@export var acceleration_distance: float = 256

@export var deceleration_distance: float = 64

@export var walk_factor: float = 0.2

@export var cancel_jump_factor: float = 0.3

@export var cancel_jump_minimum_frames: int = 6

@export var max_double_jumps: int = 0

@export var double_jump_height: float = 74

@export var double_jump_time: float = 0.3

@export var double_jump_distance: float = 128

@export var air_acceleration_distance: float = 64

@export var air_deceleration_distance: float = 12

# We don't want the player to be able to move back higher on the wall after the a wall jump, hence less air controls
@export var wall_jump_acceleration_distance: float = 256

@export var wall_jump_deceleration_distance: float = 128

@export var wall_friction_factor: float = 0.5

@export var buffered_jump_frames: int = 6

@export var coyote_jump_frames: int = 6