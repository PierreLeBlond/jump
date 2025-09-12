extends Node

class_name CheckpointManager

signal checkpoint_saved()
signal checkpoint_pre_loaded()
signal checkpoint_loaded()

var checkpoints: Array[Checkpoint] = []
var last_checkpoint_index: int = 0

func activate_checkpoints(node: Node) -> void:
    checkpoints.clear()

    for child in node.find_children("*"):
        if child is Checkpoint:
            checkpoints.append(child)

    for checkpoint in checkpoints:
        checkpoint.checkpoint_saved.connect(on_checkpoint_saved)
        checkpoint.checkpoint_pre_loaded.connect(on_checkpoint_pre_loaded)
        checkpoint.checkpoint_loaded.connect(on_checkpoint_loaded)
    
func on_checkpoint_saved(checkpoint: Checkpoint) -> void:
    last_checkpoint_index = checkpoints.find(checkpoint)
    checkpoint_saved.emit()

func on_checkpoint_pre_loaded() -> void:
    checkpoint_pre_loaded.emit()

func on_checkpoint_loaded() -> void:
    checkpoint_loaded.emit()

func load(checkpoint_index: int = 0) -> void:
    last_checkpoint_index = checkpoint_index

    var checkpoint = checkpoints[last_checkpoint_index]

    if checkpoint == null:
        push_error("Checkpoint not found: ", checkpoint_index)

    await checkpoint.load()

func load_last_checkpoint() -> void:
    var checkpoint = checkpoints[last_checkpoint_index]
    await checkpoint.load()
