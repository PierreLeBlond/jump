extends CharacterBody2D

class_name ProjectileCharacter

@onready var corner_corrector: CornerCorrector = $CornerCorrector

@onready var state_machine: StateMachine = $StateMachine

@onready var movement_controller: MovementController = $MovementController

@onready var projectile_parameters: ProjectileParameters = $ProjectileParameters

@onready var left_ray_cast_2d: RayCast2D = $LeftRayCast2D

@onready var right_ray_cast_2d: RayCast2D = $RightRayCast2D

var unlocked_keys: UnlockedKeys = UnlockedKeys.new()

func _ready() -> void:
    corner_corrector.init(self)
    state_machine.init(self)

func _physics_process(delta: float) -> void:
    corner_corrector.apply_corner_correction()
    state_machine.handle_physics(delta)
