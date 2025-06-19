extends Control

class_name PlayerTestingUi

@export var player: ProjectileCharacter

@onready var jump_height_slider: TestingSlider = $JumpHeightSlider

@onready var jump_time_slider: TestingSlider = $JumpTimeSlider

@onready var fall_time_slider: TestingSlider = $FallTimeSlider

@onready var jump_distance_slider: TestingSlider = $JumpDistanceSlider

@onready var run_factor_slider: TestingSlider = $RunFactorSlider

@onready var jump_curve: JumpCurve = $JumpCurve

func _ready() -> void:
    jump_height_slider.init(player.projectile_parameters.jump_height)
    jump_height_slider.value_changed.connect(func(value: float):
        player.projectile_parameters.jump_height = value
    )

    jump_time_slider.init(player.projectile_parameters.jump_time)
    jump_time_slider.value_changed.connect(func(value: float):
        player.projectile_parameters.jump_time = value
    )

    fall_time_slider.init(player.projectile_parameters.fall_time)
    fall_time_slider.value_changed.connect(func(value: float):
        player.projectile_parameters.fall_time = value
    )

    jump_distance_slider.init(player.projectile_parameters.jump_distance)
    jump_distance_slider.value_changed.connect(func(value: float):
        player.projectile_parameters.jump_distance = value
    )

    run_factor_slider.init(player.projectile_parameters.run_factor)
    run_factor_slider.value_changed.connect(func(value: float):
        player.projectile_parameters.run_factor = value
    )

    jump_curve.origin_node = player

    jump_curve.projectile_parameters = player.projectile_parameters
