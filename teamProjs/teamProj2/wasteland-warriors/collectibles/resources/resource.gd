extends Area2D

signal item_picked_up(body)



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		emit_signal("item_picked_up", body)
		body.pick_up_resource()
		queue_free()
