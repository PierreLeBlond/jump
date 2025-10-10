extends State

class_name ProjectileState

@export var animation: String

var state_machine: StateMachine
var parent: ProjectileCharacter

var maximum_velocity: float
var final_velocity: float

var acceleration_distance: float
var deceleration_distance: float

var jump_height: float
var jump_time: float

func init(projectile_character: ProjectileCharacter) -> void:
    self.parent = projectile_character
    self.state_machine = projectile_character.state_machine

    self.final_velocity = projectile_character.projectile_parameters.final_velocity
    self.maximum_velocity = projectile_character.projectile_parameters.final_velocity
    self.acceleration_distance = projectile_character.projectile_parameters.acceleration_distance
    self.deceleration_distance = projectile_character.projectile_parameters.deceleration_distance

    self.jump_height = projectile_character.projectile_parameters.jump_height
    self.jump_time = projectile_character.projectile_parameters.jump_time

func enter(_previous_state: State, _delta: float) -> void:
    if animation:
        parent.animation_player.play(animation)

func update(_delta: float) -> void:
    pass