extends Control

class_name ComboNote

@export var offset: Vector2 = Vector2.ZERO

@export var combo_label: Label

@export var combo_score_scene: PackedScene
@export var combo_score_spawn: Node2D

@export var texture_range: Range

var _combo_tween: Tween

func _ready() -> void:
    hide()

func update_position(target: Node2D) -> void:
    global_position = target.get_global_transform().origin + offset

func update(duration: float, count: int) -> void:
    if _combo_tween:
        _combo_tween.stop()
        _combo_tween = null

    texture_range.value = 100.0
    _combo_tween = create_tween()
    _combo_tween.tween_property(texture_range, "value", 0.0, duration)
    _combo_tween.finished.connect(on_tween_finished)
    show()

    combo_label.text = str(count)

    spawn_score(count)

func on_tween_finished() -> void:
    combo_label.text = str(0)
    hide()

func spawn_score(count: int) -> void:
    var combo_score = combo_score_scene.instantiate()
    combo_score_spawn.add_child(combo_score)

    combo_score.get_node("Label").text = "+" + str(count)
    combo_score.modulate.a = 0.0

    var angle = randf_range(PI / 4, 3 * PI / 4)
    var distance = 128.0

    var target_position = Vector2(distance * cos(angle), -distance * sin(angle))

    var tween = create_tween()
    tween.tween_property(combo_score, "position:x", target_position.x, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
    tween.parallel().tween_property(combo_score, "position:y", target_position.y, 1.0).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
    tween.parallel().tween_property(combo_score, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

    await tween.finished

    combo_score.queue_free()
