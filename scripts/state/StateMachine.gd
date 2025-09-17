extends Node

class_name StateMachine

@export var initial_state: State

var current_state: State

var states: Array[State]
var states_transitions: Dictionary = {}

func _ready() -> void:
    current_state = initial_state

func add_state(state: State) -> void:
    states.append(state)

func add_transition(from_state: State, to_state: State, condition: Callable) -> void:
    if !states_transitions.has(from_state):
        states_transitions[from_state] = []
    states_transitions[from_state].append({"to_state": to_state, "condition": condition})

func get_next_state() -> State:
  var transitions = states_transitions.get(current_state)
  for transition in transitions:
    if transition["condition"].call():
      return transition["to_state"]

  return null

func change_state(new_state: State, delta: float) -> void:
    current_state.exit()

    var previous_state = current_state
    current_state = new_state

    current_state.enter(previous_state, delta)

func update(delta: float) -> void:
    current_state.update(delta)

    var new_state = get_next_state()

    if (new_state != null):
        change_state(new_state, delta)
