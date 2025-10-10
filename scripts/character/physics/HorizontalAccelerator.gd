extends Node

class_name HorizontalAccelerator

@export var character_body: CharacterBody2D

var jump_height: float = 0
var jump_time: float = 0

func get_acceleration() -> float:
    return 2 * jump_height / (jump_time * jump_time)