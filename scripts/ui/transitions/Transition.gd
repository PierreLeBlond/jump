extends Node

class_name Transition

static func create_circle_transition_in(parent: Node, target: Node2D) -> Callable:
    var resource = load("res://scenes/ui/transitions/scenes/CircleTransition.tscn")
    var transition = resource.instantiate()
    parent.add_child(transition)
    await transition.transition_in(target)
    return func():
        transition.queue_free()

static func create_circle_transition_out(parent: Node, target: Node2D) -> Callable:
    var resource = load("res://scenes/ui/transitions/scenes/CircleTransition.tscn")
    var transition = resource.instantiate()
    parent.add_child(transition)
    await transition.transition_out(target)
    return func():
        transition.queue_free()

static func create_left_bar_transition_out(parent: Node) -> Callable:
    var resource = load("res://scenes/ui/transitions/scenes/BarTransition.tscn")
    var transition = resource.instantiate()
    parent.add_child(transition)
    await transition.transition_left_out()
    return func():
        transition.queue_free()

static func create_right_bar_transition_in(parent: Node) -> Callable:
    var resource = load("res://scenes/ui/transitions/scenes/BarTransition.tscn")
    var transition = resource.instantiate()
    parent.add_child(transition)
    await transition.transition_right_in()
    return func():
        transition.queue_free()

static func create_left_bar_transition_in(parent: Node) -> Callable:
    var resource = load("res://scenes/ui/transitions/scenes/BarTransition.tscn")
    var transition = resource.instantiate()
    parent.add_child(transition)
    await transition.transition_left_in()
    return func():
        transition.queue_free()

static func create_right_bar_transition_out(parent: Node) -> Callable:
    var resource = load("res://scenes/ui/transitions/scenes/BarTransition.tscn")
    var transition = resource.instantiate()
    parent.add_child(transition)
    await transition.transition_right_out()
    return func():
        transition.queue_free()

static func create_fall_transition_in(parent: Node) -> Callable:
    var resource = load("res://scenes/ui/transitions/scenes/FallTransition.tscn")
    var transition = resource.instantiate()
    parent.add_child(transition)
    await transition.transition_in()
    return func():
        transition.queue_free()

static func create_fall_transition_out(parent: Node) -> Callable:
    var resource = load("res://scenes/ui/transitions/scenes/FallTransition.tscn")
    var transition = resource.instantiate()
    parent.add_child(transition)
    await transition.transition_out()
    return func():
        transition.queue_free()

static func create_loading_transition_in(parent: Node) -> Callable:
    var resource = load("res://scenes/ui/transitions/scenes/LoadingTransition.tscn")
    var transition = resource.instantiate()
    parent.add_child(transition)
    await transition.transition_in()
    return func():
        transition.queue_free()

static func create_loading_transition_out(parent: Node) -> Callable:
    var resource = load("res://scenes/ui/transitions/scenes/LoadingTransition.tscn")
    var transition = resource.instantiate()
    parent.add_child(transition)
    await transition.transition_out()
    return func():
        transition.queue_free()
