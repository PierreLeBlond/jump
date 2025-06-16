extends CharacterBody2D

class_name ProjectileCharacter

@export var corner_corrector: CornerCorrector

@export var state_machine: StateMachine

@export var movement_controller: MovementController

@export var projectile_parameters: ProjectileParameters

@export var left_ray_cast_2d: RayCast2D

@export var right_ray_cast_2d: RayCast2D

func _ready() -> void:
    corner_corrector.init(self)
    state_machine.init(self)

func _physics_process(delta: float) -> void:
    corner_corrector.apply_corner_correction()
    state_machine.handle_physics(delta)
