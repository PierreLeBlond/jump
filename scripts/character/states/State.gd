extends Node

class_name State

@export var animation: String

var maximum_lateral_velocity: float

var state_machine: StateMachine
var parent: ProjectileCharacter

var wall_sign: int = 1

func init(projectile_character: ProjectileCharacter) -> void:
    self.parent = projectile_character
    self.state_machine = projectile_character.state_machine
    self.maximum_lateral_velocity = parent.projectile_parameters.maximum_velocity

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

func get_lateral_velocity(delta: float, current_velocity: float, maximum_velocity: float, acceleration_factor: float, deceleration_factor: float) -> float:
    var direction = parent.movement_controller.get_direction()

    # Deceleration
    if (direction == 0):
        var deceleration_drag = - sign(current_velocity) * (deceleration_factor / (maximum_velocity * maximum_velocity)) * current_velocity * current_velocity

        # Arbitrary stop velocity if the character is moving less than 0.5 units per frame, should avoid jittering
        var epsilon = 0.5 / delta
        if abs(current_velocity) < abs(deceleration_drag * delta) || abs(current_velocity + deceleration_drag * delta) < epsilon:
            return 0

        return current_velocity + deceleration_drag * delta

    # Acceleration
    var acceleration = direction * acceleration_factor

    var drag = - sign(current_velocity) * (acceleration_factor / (maximum_velocity * maximum_velocity)) * current_velocity * current_velocity

    var velocity = current_velocity + acceleration * delta + drag * delta

    return velocity

func get_vertical_velocity(delta: float, current_velocity: float, jump_height: float, jump_time: float) -> float:
    var gravity = 2 * jump_height / (jump_time * jump_time)

    if (is_on_wall()):
        gravity *= parent.projectile_parameters.wall_friction_factor

    return current_velocity + gravity * delta

func get_parameters() -> Dictionary:
    return {
        "jump_height": parent.projectile_parameters.jump_height,
        "jump_time": parent.projectile_parameters.jump_time,
        "maximum_lateral_velocity": parent.projectile_parameters.maximum_lateral_velocity,
        "acceleration_factor": parent.projectile_parameters.acceleration_factor,
        "deceleration_factor": parent.projectile_parameters.deceleration_factor
    }

func get_velocity(delta: float) -> Vector2:
    var parameters = get_parameters()

    return Vector2(
        get_lateral_velocity(
            delta,
            parent.velocity.x,
            parameters.maximum_lateral_velocity,
            parameters.acceleration_factor,
            parameters.deceleration_factor
        ),
        get_vertical_velocity(
            delta,
            parent.velocity.y,
            parameters.jump_height,
            parameters.jump_time
        )
    )

func enter(_previous_state: State, _delta: float) -> void:
    var animation_player = parent.get_node("AnimationPlayer")
    animation_player.current_animation = animation
    animation_player.play()

func get_next_state(_delta: float) -> State:
    return null

func update(_delta: float) -> void:
    pass

func update_sprite() -> void:
    flip_sprite(parent.movement_controller.get_direction())

func exit() -> void:
    pass
