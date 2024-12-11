extends Node2D

@export var resource_scenes = [
	preload("res://collectibles/resources/resource_1.tscn"),
	preload("res://collectibles/resources/resource_2.tscn"),
	preload("res://collectibles/resources/resource_3.tscn"),
	preload("res://collectibles/resources/resource_4.tscn"),
	preload("res://collectibles/resources/resource_5.tscn"),
	preload("res://collectibles/resources/resource_6.tscn"),
	preload("res://collectibles/resources/resource_7.tscn"),
	preload("res://collectibles/resources/resource_8.tscn"),
	preload("res://collectibles/resources/health_shot.tscn")
]

@export var spawn_area_min = Vector2(20, 100) #top left, change later !!
@export var spawn_area_max = Vector2(1120, 450) #bottom right, change later !!


func _on_spawn_timer_timeout() -> void:
	spawn_resource()


func spawn_resource():
	var resource_scene = resource_scenes[randi() % resource_scenes.size()]
	var resource_instance = resource_scene.instantiate()
	
	var rand_x = randf_range(spawn_area_min.x, spawn_area_max.x)
	var rand_y = randf_range(spawn_area_min.y, spawn_area_max.y)
	resource_instance.position = Vector2(rand_x, rand_y)
	
	get_parent().add_child(resource_instance)
	
