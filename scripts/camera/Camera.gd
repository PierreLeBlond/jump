extends Camera2D

@export var target: Node2D

var left_limit: float = 512
var dead_zone: Vector2 = Vector2(64, 256)
var target_offset: Vector2 = Vector2(0, 128)

func _process(_delta: float) -> void:
    assert(target != null, "Target is null")
    var horizontal_distance = target.position.x - position.x
    if abs(horizontal_distance) > dead_zone.x:
        position.x = max(target.position.x - sign(horizontal_distance) * dead_zone.x, left_limit)

    var vertical_distance = target.position.y - position.y
    if abs(vertical_distance) > dead_zone.y:
        position.y = target.position.y - target_offset.y - sign(vertical_distance) * dead_zone.y
