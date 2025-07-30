extends Node

class_name CheckpointManager

@export var transition_mask: TransitionMask

signal checkpoint_saved()
signal checkpoint_loaded()

var checkpoints: Array[Checkpoint] = []
var current_checkpoint: Checkpoint = null

func _ready() -> void:
    for child in get_tree().current_scene.find_children("*", "Checkpoint"):
      if child is Checkpoint:
        checkpoints.append(child)

    for checkpoint in checkpoints:
        checkpoint.checkpoint_saved.connect(on_checkpoint_saved)

func on_checkpoint_saved(checkpoint: Checkpoint) -> void:
    current_checkpoint = checkpoint
    checkpoint_saved.emit()

func load() -> void:
    if (current_checkpoint == null):
      return

    await current_checkpoint.load()
    checkpoint_loaded.emit()
