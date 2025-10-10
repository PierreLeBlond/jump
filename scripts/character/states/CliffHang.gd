extends ProjectileState

class_name CliffHang

func enter(previous_state: State, delta: float) -> void:
    super (previous_state, delta)
    var cliff_sign = parent.cliff_detector.get_cliff_sign()
    var direction = parent.direction * cliff_sign

    var animation_name = "frontcliffhang" if direction == 1 else "backcliffhang"
    parent.animation_player.play(animation_name)