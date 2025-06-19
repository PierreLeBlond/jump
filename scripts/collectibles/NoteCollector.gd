extends Area2D

class_name NoteCollector

func _ready() -> void:
    area_entered.connect(on_area_entered)

func on_area_entered(collectible_area: Area2D) -> void:
    collectible_area.queue_free()

func _on_area_entered(area: Area2D) -> void:
    print("Area entered: ", area)
