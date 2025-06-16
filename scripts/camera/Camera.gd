extends Camera2D

@export var target: Node2D
var left_limit: float = 512
var dead_zone: float = 64

func _process(_delta: float) -> void:
	assert(target != null, "Target is null")
	var distance = target.position.x - position.x
	if abs(distance) > dead_zone:
		position.x = max(target.position.x - sign(distance) * dead_zone, left_limit)
