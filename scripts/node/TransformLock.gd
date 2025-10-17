extends Node2D

class_name TransformLock

@export var target: Node2D

@export var vertical: bool = true
@export var horizontal: bool = true

func lock() -> void:
    if vertical:
        global_position.y = target.global_position.y

    if horizontal:
        global_position.x = target.global_position.x

func _ready() -> void:
    lock()

func _physics_process(_delta: float) -> void:
    lock()