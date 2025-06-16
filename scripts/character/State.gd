extends Node

class_name State

@export var animation: String

var maximum_lateral_velocity: float = 0

var parent: ProjectileCharacter

var wall_sign: int = 1

func init(projectile_character: ProjectileCharacter) -> void:
    self.parent = projectile_character

func is_on_wall() -> bool:
    if (parent.left_ray_cast_2d.is_colliding()):
        wall_sign = 1
        return true

    if (parent.right_ray_cast_2d.is_colliding()):
        wall_sign = -1
        return true

    return false

func flip_sprite(direction: int) -> void:
    parent.get_node("Sprite2D").scale = Vector2(
        direction * abs(parent.get_node("Sprite2D").scale.x) if direction != 0 else parent.get_node("Sprite2D").scale.x,
        parent.get_node("Sprite2D").scale.y
    )

func get_lateral_velocity(delta: float, current_velocity: float, maximum_velocity: float, acceleration_time: float, deceleration_time: float) -> float:
    var direction = parent.movement_controller.get_direction()

    var acceleration_factor = maximum_velocity / acceleration_time
    var acceleration = direction * acceleration_factor
    var velocity = current_velocity + acceleration * delta
    velocity = clamp(velocity, -maximum_velocity, maximum_velocity)

    if (direction != 0):
        return velocity

    # No new acceleration, let's decelerate
    var deceleration_factor = maximum_velocity / deceleration_time
    var deceleration = - deceleration_factor if velocity > 0 else deceleration_factor

    velocity += deceleration * delta

    # Avoid going back in the other direction
    if (deceleration > 0):
        velocity = min(velocity, 0)

    if (deceleration < 0):
        velocity = max(velocity, 0)

    return velocity

func get_vertical_velocity(delta: float, current_velocity: float, jump_height: float, jump_time: float) -> float:
    var gravity = 2 * jump_height / (jump_time * jump_time)

    if (is_on_wall()):
        gravity *= parent.projectile_parameters.wall_friction_factor

    return current_velocity + gravity * delta

func enter(_previous_state: State, _delta: float) -> void:
    var animation_player = parent.get_node("AnimationPlayer")
    animation_player.current_animation = animation
    animation_player.play()

func get_next_state(_delta: float) -> State:
    return null

func update(_delta: float) -> void:
    pass

func get_velocity(_delta: float) -> Vector2:
    return Vector2.ZERO

func update_sprite() -> void:
    flip_sprite(parent.movement_controller.get_direction())

func exit() -> void:
    pass
