extends Node

class_name LateralAccelerator

@export var character_body: CharacterBody2D

var absolute_acceleration: float = 0
var absolute_deceleration: float = 0

func update_absolute_acceleration() -> void:
    absolute_acceleration = maximum_velocity * maximum_velocity / (2 * acceleration_distance)
    absolute_deceleration = maximum_velocity * maximum_velocity / (2 * deceleration_distance)

# Should be specific to the medium the projectile is in, e.g. ground, air, water, etc.
# if starting from rest, it will take acceleration_distance to reach maximum_velocity
# if starting from maximum_velocity, it will take deceleration_distance to reach rest
var maximum_velocity: float = 0:
    get:
        return maximum_velocity
    set(value):
        maximum_velocity = value
        update_absolute_acceleration()

var acceleration_distance: float = 0:
    get:
        return acceleration_distance
    set(value):
        acceleration_distance = value
        update_absolute_acceleration()

var deceleration_distance: float = 0:
    get:
        return deceleration_distance
    set(value):
        deceleration_distance = value
        update_absolute_acceleration()

var final_velocity: float = 0:
    get:
        return final_velocity
    set(value):
        if value == final_velocity:
            return

        final_velocity = value

var acceleration = 0;
var acceleration_direction: int = 0

func update() -> void:
    acceleration_direction = sign(final_velocity - character_body.velocity.x)

    # acceleration is increasing the velocity
    var is_accelerating = final_velocity != 0 && (character_body.velocity.x == 0 || sign(character_body.velocity.x) == acceleration_direction)

    if is_accelerating:
        acceleration = acceleration_direction * absolute_acceleration
    else:
        acceleration = acceleration_direction * absolute_deceleration

func get_acceleration(delta: float) -> float:
    if character_body.velocity.x == final_velocity:
        return 0

    update()

    # prevent overshoot
    if acceleration_direction * (character_body.velocity.x + acceleration * delta) > acceleration_direction * final_velocity:
        return (final_velocity - character_body.velocity.x) / delta

    return acceleration
