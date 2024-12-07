extends CharacterBody3D

const MAXSPEED = 30
const ACCELERATION = 0.75
var inputVector = Vector3()
var velo = Vector3()
var cooldown = 0

const COOLDOWN = 8
@onready var guns = [$Gun0, $Gun1]
@onready var main = get_tree().current_scene
var Bullet = load("res://Bullet.tscn")

var health = 1  # Health of the player
var is_invincible = false  # To prevent multiple damage instances in quick succession

# Function to reduce health when the player takes damage
func take_damage(amount: int):
	if not is_invincible:  # Prevents taking damage during invincibility
		health -= amount
		print("Player Health: ", health)

		# Add an invincibility period to prevent taking damage too fast
		is_invincible = true
		# Temporarily make the player invincible for 1 second
		await get_tree().create_timer(1).timeout
		is_invincible = false

		if health <= 0:
			# Handle player death (e.g., restart the level or show game over)
			print("Player has died.")
			queue_free()  # Remove the player node, or implement your own death logic

func _physics_process(delta):
	inputVector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	inputVector.y = Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
	inputVector = inputVector.normalized()
	velo.x = move_toward(velo.x, inputVector.x * MAXSPEED, ACCELERATION)
	velo.y = move_toward(velo.y, inputVector.y * MAXSPEED, ACCELERATION)
	rotation_degrees.z = velo.x * -2
	rotation_degrees.x = velo.y / 2
	rotation_degrees.y = -velo.x / 2
	set_velocity(velo)
	move_and_slide()
	transform.origin.x = clamp(transform.origin.x, -15, 15)
	transform.origin.y = clamp(transform.origin.y, -10, 10)
	
	# Shooting logic
	if Input.is_action_pressed("ui_accept") and cooldown <= 0:
		cooldown = COOLDOWN * delta
		for i in guns:
			var bullet = Bullet.instantiate()
			main.add_child(bullet)
			bullet.transform = i.global_transform
			bullet.velo = bullet.transform.basis.z * -600
			
	# Cooldown logic
	if cooldown > 0:
		cooldown -= delta

# Detect when the player collides with an enemy
func _on_Player_body_entered(body: Node3D) -> void:
	if body.name == "Enemy":
		# Assuming the enemy has a 'damage' property
		var enemy = body as Node3D
		var damage = enemy.damage
		take_damage(damage) 
