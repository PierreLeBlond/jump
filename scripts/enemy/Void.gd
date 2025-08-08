extends Node2D

class_name Void

signal target_entered(target: Node2D)

@export var target: Node2D

var inside: bool = false

func _process(_delta: float) -> void:
    if target.global_position.y > global_position.y && !inside:
        inside = true
        target_entered.emit(target)
    elif target.global_position.y < global_position.y && inside:
        inside = false
