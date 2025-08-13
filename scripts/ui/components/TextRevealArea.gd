extends Area2D

class_name TextRevealArea

@export var canvas_item: CanvasItem
@export var mobile_canvas_item: CanvasItem

func _ready() -> void:
    canvas_item.modulate.a = 0.0
    if mobile_canvas_item != null:
        mobile_canvas_item.modulate.a = 0.0
    body_entered.connect(on_body_entered)

func on_body_entered(_body: Node) -> void:
    var tween = create_tween()

    if OS.has_feature("mobile") && mobile_canvas_item != null:
        tween.tween_property(mobile_canvas_item, "modulate:a", 1.0, 0.5)
    else:
        tween.tween_property(canvas_item, "modulate:a", 1.0, 0.5)
