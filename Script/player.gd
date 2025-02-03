extends CharacterBody3D

@onready var animation = $"Root Scene/AnimationPlayer"
@onready var head = $Camera/Camera3D
@onready var body = $"Root Scene"

const SPEED = 5.0
const RUN_SPEED = 10.0
const JUMP_VELOCITY = 4.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var sensitivity = 0.02
var rotation_speed = 3.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("Left", "Right", "Up", "Down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	

	var current_speed = SPEED
	if Input.is_action_pressed("Run"):
		current_speed = RUN_SPEED
		animation.play("Armature|anim_run")
	else:
		animation.play("Armature|anim_walk")

	if direction.length() > 0.1:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
		#rotate_body_towards_direction(direction, delta)
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
		

	if direction.length() == 0:
		animation.play("Armature|anim_idle")

	move_and_slide()

#func rotate_body_towards_direction(direction: Vector3, delta):
	#var target_rotation = atan2(direction.x, direction.z)
	#body.rotation.y = lerp_angle(body.rotation.y, target_rotation, rotation_speed * delta)

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(deg_to_rad(event.relative.x * -1) * sensitivity)
		head.rotate_x(deg_to_rad(-event.relative.y * sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-70), deg_to_rad(70))
