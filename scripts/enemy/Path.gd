extends Path2D

class_name Path

signal finished

@onready var path_follow: PathFollow2D = $PathFollow2D

@export_range(0.0, 1024.0, 1.0) var speed: float = 512.0

var child: Node2D

var started: bool = false

func set_child(node: Node2D) -> void:
    self.child = node
    if child.get_parent():
        child.get_parent().remove_child(child)

    path_follow.add_child(child)

func start() -> void:
    started = true
    await finished

func stop() -> void:
    started = false

func reset():
    path_follow.progress_ratio = 0

func _process(delta: float) -> void:
    if started:
      path_follow.progress_ratio += speed * delta / curve.get_baked_length()

    if path_follow.progress_ratio >= 1:
      started = false
      finished.emit()