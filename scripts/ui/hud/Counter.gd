extends Control

class_name Counter

const FLASH_SCALE: Vector2 = Vector2(1.3, 1.3)

@export var control: Control

@export var counter_sprite: Control
@export var counter_label: Control

@export var flashed_sprite: ColorRect
@export var flashed_label: ColorRect

func flash_sprite() -> void:
    flashed_sprite.show()
    flashed_sprite.modulate.a = 1.0
    counter_sprite.scale = FLASH_SCALE
    var tween = create_tween()
    tween.tween_property(flashed_sprite, "modulate:a", 0.0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
    tween.parallel().tween_property(counter_sprite, "scale", Vector2(1.0, 1.0), 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
    await tween.finished
    flashed_sprite.hide()

func flash_label() -> void:
    flashed_label.show()
    flashed_label.modulate.a = 1.0
    counter_label.scale = FLASH_SCALE
    var tween = create_tween()
    tween.tween_property(flashed_label, "modulate:a", 0.0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
    tween.parallel().tween_property(counter_label, "scale", Vector2(1.0, 1.0), 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
    await tween.finished
    flashed_label.hide()

func update_counter(value: int) -> void:
    await get_tree().create_timer(0.1).timeout

    flash_sprite()

    await get_tree().create_timer(0.1).timeout

    flash_label()

    if value < 10:
        counter_label.text = "0" + str(value)
    else:
        counter_label.text = str(value)

func reveal() -> void:
    show()
    control.scale = Vector2(0.0, 0.0)
    var tween = create_tween()
    tween.tween_property(control, "scale", Vector2(1.0, 1.0), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func unreveal() -> void:
    var tween = create_tween()
    tween.tween_property(control, "scale", Vector2(0.0, 0.0), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
    await tween.finished
    hide()
