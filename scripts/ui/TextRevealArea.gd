extends Area2D

class_name TextRevealArea

@onready var text: Node = $Text

func _ready() -> void:
    text.modulate.a = 0.0
    body_entered.connect(on_body_entered)

func on_body_entered(_body: Node) -> void:
    var tween = create_tween()
    tween.tween_property(text, "modulate:a", 1.0, 0.5)
