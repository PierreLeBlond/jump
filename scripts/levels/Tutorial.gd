extends Level

class_name Tutorial

func die() -> void:
    load_last_checkpoint()

func finish() -> void:
    wants_to_quit.emit()

func restart() -> void:
    load_checkpoint(initial_checkpoint_index)