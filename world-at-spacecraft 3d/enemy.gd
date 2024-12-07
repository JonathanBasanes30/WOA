extends CharacterBody3D

var spd = randf_range(20, 50)
@onready var hitbox = $Hitbox  # Reference the Hitbox node (Area3D)

# Function that will be triggered when the player enters the hitbox
func _ready():
	# Connect the 'body_entered' signal of the hitbox to the handler function
	hitbox.body_entered.connect(_on_Hitbox_body_entered)  # Use a Callable

func _physics_process(_delta):
	set_velocity(Vector3(0, 0, spd))  # Moving the enemy in the Z direction
	move_and_slide()

	# If the enemy passes the boundary, remove it
	if transform.origin.z > 10:
		queue_free()

# Function that handles the collision when the player enters the hitbox
func _on_Hitbox_body_entered(body: Node3D):
	if body.is_in_group("Player"):  # Check if the body is the player
		body.take_damage(1)  # Assuming the player has a 'take_damage' method that handles damage
		queue_free()  # Destroy the enemy after it hits the player (optional)
