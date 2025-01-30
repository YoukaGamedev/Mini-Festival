extends CharacterBody3D

@onready var animation = $"Root Scene/AnimationPlayer"
@onready var head = $Camera/Camera3D
@onready var body = $"Root Scene"

const SPEED = 5.0
const RUN_SPEED = 10.0  # Kecepatan berlari
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var sensitivity = 0.02  # Sensitivitas rotasi mouse

func _ready():
	# Set mouse mode to captured to lock the cursor during gameplay.
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	# Add gravity if not on the floor.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump action.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the direction of movement based on input.
	var input_dir = Input.get_vector("Left", "Right", "Up", "Down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# Determine the current movement speed, either walking or running.
	var current_speed = SPEED
	if Input.is_action_pressed("Run"):  # Shift to run
		current_speed = RUN_SPEED
		animation.play("Armature|anim_run")
	else:
		animation.play("Armature|anim_walk")

	# Apply movement based on the direction.
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
		rotate_body_towards_direction(direction)  # Smooth rotation of body
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	# Idle animation when not moving.
	if direction.length() == 0:
		animation.play("Armature|anim_idle")

	# Apply the movement.
	move_and_slide()

# Rotates the body smoothly to face the movement direction using look_at.
func rotate_body_towards_direction(direction: Vector3):
	var target_position = position + direction * 10  # This moves the target a bit in front of the player.
	body.look_at(target_position, Vector3.UP)
	body.rotation.y = lerp_angle(body.rotation.y, body.rotation.y, 0.1)


func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# Rotate the player on the Y-axis (horizontal) based on mouse movement in the X direction.
		rotate_y(deg_to_rad(event.relative.x * -1) * sensitivity)

		# Rotate the head (camera) on the X-axis (vertical) based on mouse movement in the Y direction.
		head.rotate_x(deg_to_rad(-event.relative.y * sensitivity))

		# Clamp the camera's vertical rotation to prevent it from going beyond a certain range.
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-70), deg_to_rad(70))
