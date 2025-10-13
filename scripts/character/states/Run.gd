extends ProjectileState

class_name Run

var last_direction: int = 1

func check_direction() -> void:
    if (last_direction != parent.direction):
        last_direction = parent.direction
        parent.animation_player.play("idleturn")
        parent.animation_player.queue("run")

func enter(previous_state: State, delta: float) -> void:
    super (previous_state, delta)
    final_velocity = parent.projectile_parameters.final_velocity

    check_direction()

    acceleration_distance = parent.projectile_parameters.acceleration_distance
    deceleration_distance = parent.projectile_parameters.deceleration_distance

func update(_delta: float) -> void:
    super (_delta)

    check_direction()
