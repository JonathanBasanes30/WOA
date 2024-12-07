extends CharacterBody3D

var velo = Vector3()
var KillParticles = load("res://KillParticles.tscn")
@onready var main = get_tree().current_scene
@onready var explodeSound = $EnemyExplode

# Initialize bullet velocity (if not already set elsewhere)
func _ready():
	# Ensure velocity is set correctly if it's not passed as a parameter
	if velo == Vector3.ZERO:
		velo = transform.basis.z * -600  # This sets the bullet velocity (can adjust this value)

@warning_ignore("unused_parameter")
func _physics_process(delta):
	set_velocity(velo)
	move_and_slide()

# Collision detection when the bullet hits an enemy
func _on_Area_body_entered(body):
	if body.is_in_group("Enemies"):
		var particles = KillParticles.instantiate()  # Create kill particles
		main.add_child(particles)
		particles.transform.origin = transform.origin  # Place the particles at the bullet's position

		body.queue_free()  # Destroy the enemy
		explodeSound.play()  # Play the explosion sound
		queue_free()  # Destroy the bullet itself

		# Disable the bullet's collision detection after the hit (optional)
		visible = false
		$Area3D/CollisionShape3D.disabled = true

# Optional: Handle light effects or other timed events
func _on_LightTimer_timeout():
	$OmniLight3D.visible = false
