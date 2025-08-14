extends CanvasLayer

class_name MobileControls

@export var left_button: Node2D
@export var right_button: Node2D
@export var jump_button: Node2D
@export var pause_button: Node2D

func _ready() -> void:
    left_button.visible = false
    right_button.visible = false
    jump_button.visible = false
    pause_button.visible = false

    Events.player_unlocked_keys_changed.connect(on_player_unlocked_keys_changed)

func on_player_unlocked_keys_changed(unlocked_keys: UnlockedKeys) -> void:
    check_button(left_button, unlocked_keys.has_unlocked_move() && unlocked_keys.has_unlocked_physics())
    check_button(right_button, unlocked_keys.has_unlocked_move() && unlocked_keys.has_unlocked_physics())
    check_button(jump_button, unlocked_keys.has_unlocked_jump() && unlocked_keys.has_unlocked_physics())
    check_button(pause_button, unlocked_keys.has_unlocked_pause())

func check_button(button: Node2D, unlocked: bool) -> void:
    if unlocked && !button.visible:
        reveal_button(button)
    elif !unlocked && button.visible:
        unreveal_button(button)

func reveal_button(button: Node2D) -> void:
    button.scale = Vector2(0.0, 0.0)
    var tween = create_tween()
    tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
    button.visible = true

func unreveal_button(button: Node2D) -> void:
    button.scale = Vector2(1.0, 1.0)
    var tween = create_tween()
    tween.tween_property(button, "scale", Vector2(0.0, 0.0), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
    await tween.finished
    button.visible = false
