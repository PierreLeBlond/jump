extends Node2D

class_name StartRaceConnector

@export var player: Player

@export var trip_state: Trip
@export var starting_block_state: StartingBlock

func _ready() -> void:
    trip_state.init(player)
    starting_block_state.init(player)

func trip() -> void:
    player.state_machine.add_transition(player.idle_state, trip_state, func(): return player.is_on_floor(), 0)
    player.state_machine.add_transition(player.fall_state, trip_state, func(): return player.is_on_floor(), 0)
    player.state_machine.add_transition(player.run_state, trip_state, func(): return player.is_on_floor(), 0)
    player.state_machine.add_transition(player.walk_state, trip_state, func(): return player.is_on_floor(), 0)

    player.state_machine.add_transition(trip_state, starting_block_state, func(): return trip_state.has_recovered())

func starting_block() -> void:
    player.state_machine.add_transition(player.idle_state, starting_block_state, func(): return player.is_on_floor(), 0)
    player.state_machine.add_transition(player.fall_state, starting_block_state, func(): return player.is_on_floor(), 0)
    player.state_machine.add_transition(player.run_state, starting_block_state, func(): return player.is_on_floor(), 0)
    player.state_machine.add_transition(player.walk_state, starting_block_state, func(): return player.is_on_floor(), 0)

func start() -> void:
    player.state_machine.remove_transition(player.idle_state, starting_block_state)
    player.state_machine.remove_transition(player.fall_state, starting_block_state)
    player.state_machine.remove_transition(player.run_state, starting_block_state)
    player.state_machine.remove_transition(player.walk_state, starting_block_state)

    player.state_machine.remove_transition(player.idle_state, trip_state)
    player.state_machine.remove_transition(player.fall_state, trip_state)
    player.state_machine.remove_transition(player.run_state, trip_state)
    player.state_machine.remove_transition(player.walk_state, trip_state)

    player.state_machine.add_transition(starting_block_state, player.idle_state, func(): return true)
