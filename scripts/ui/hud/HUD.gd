extends CanvasLayer

class_name HUD

@export var life_counter: LifeCounter
@export var score_counter: Counter
@export var time_counter: TimeCounter

func show_life_counter() -> void:
    life_counter.show()

func hide_life_counter() -> void:
    life_counter.hide()

func reveal_life_counter() -> void:
    life_counter.reveal()

func unreveal_life_counter() -> void:
    life_counter.unreveal()

func show_time_counter() -> void:
    time_counter.show()

func hide_time_counter() -> void:
    time_counter.hide()

func reveal_time_counter() -> void:
    time_counter.reveal()

func unreveal_time_counter() -> void:
    time_counter.unreveal()

func show_score_counter() -> void:
    score_counter.show()

func hide_score_counter() -> void:
    score_counter.hide()

func reveal_score_counter() -> void:
    score_counter.reveal()

func unreveal_score_counter() -> void:
    score_counter.unreveal()
