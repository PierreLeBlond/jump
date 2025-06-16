extends Node

class_name StateMachine

@export var initial_state: State

var parent: ProjectileCharacter

var current_state: State

func init(projectile_character: ProjectileCharacter) -> void:
    parent = projectile_character
    for state in get_children():
        state.init(parent)

func change_state(new_state: State, delta: float) -> void:
    new_state.exit()

    var previous_state = current_state
    current_state = new_state

    current_state.enter(previous_state, delta)

func _ready() -> void:
    current_state = initial_state

func handle_physics(delta: float) -> void:
    var new_state = current_state.get_next_state(delta)

    if (new_state != null):
        change_state(new_state, delta)

    current_state.update(delta)

    var velocity = current_state.get_velocity(delta)
    parent.velocity = velocity

    parent.move_and_slide()

    current_state.update_sprite()
