extends Control

class_name LifeCounter

@export var lifes: Array[Control]
var visible_lifes: int = 0

func _ready() -> void:
    visible_lifes = lifes.size()

func update_counter(value: int) -> void:
    var previous_visible_lifes = visible_lifes
    visible_lifes = value
    if previous_visible_lifes < visible_lifes:
        for i in range(previous_visible_lifes, visible_lifes):
            reveal_life(i - 1)
    elif previous_visible_lifes > visible_lifes:
        for i in range(previous_visible_lifes, visible_lifes, -1):
            unreveal_life(i - 1)

func reveal_life(index: int) -> void:
    lifes[index].scale = Vector2(0.0, 0.0)
    lifes[index].show()
    var tween = create_tween()
    tween.tween_property(lifes[index], "scale", Vector2(1.0, 1.0), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).set_delay(0.1 * index)

func unreveal_life(index: int) -> void:
    var tween = create_tween()
    tween.tween_property(lifes[index], "scale", Vector2(0.0, 0.0), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN).set_delay(0.1 * (lifes.size() - index - 1))
    await tween.finished
    lifes[index].hide()

func reveal() -> void:
    show()
    for i in range(visible_lifes):
        reveal_life(i)

func unreveal() -> void:
    for i in range(visible_lifes):
        unreveal_life(i)
