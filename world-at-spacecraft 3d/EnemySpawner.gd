extends Node3D

@onready var main = get_tree().current_scene
var Enemy = load("res://enemy.tscn")

# Function to spawn the enemy
func spawn():
	var enemy = Enemy.instantiate()
	main.add_child(enemy)
	# Set the spawn position with random X and Y offsets
	enemy.transform.origin = transform.origin + Vector3(randf_range(-15, 15), randf_range(-10, 10), 0)

func _on_Timer_timeout():
	spawn()  # Call the spawn function when the timer times out
