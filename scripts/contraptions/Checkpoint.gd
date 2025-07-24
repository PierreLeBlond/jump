extends Area2D

class_name Checkpoint

@export var player: ProjectileCharacter
@export var portal: Portal
@export var note_collector: NoteCollector

var player_position: Vector2
var collected_notes_index: int

func _ready() -> void:
  body_entered.connect(on_body_entered)

func on_body_entered(_body: Node2D):
  save()

func save():
  collected_notes_index = note_collector.collected_notes.size()
  body_entered.disconnect(on_body_entered)

func load():
  await portal.release_player()
  note_collector.restore(collected_notes_index)
