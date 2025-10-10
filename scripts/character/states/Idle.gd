extends ProjectileState

class_name Idle

func enter(previous_state: State, delta: float) -> void:
    super (previous_state, delta)

    var animation_player = parent.animation_player
    if (previous_state.animation == "run" || previous_state.animation == "walk"):
        animation_player.play("stop")
        animation_player.queue("idle")
    elif (previous_state.animation == "fall"):
        animation_player.play("land")
        animation_player.queue("idle")
    else:
        animation_player.play("idle")

    final_velocity = 0
