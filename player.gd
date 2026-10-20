extends CharacterBody3D

const SPEED = 8.0
const JUMP_VELOCITY = 6.0

const SENSIVILITY = 0.005

@onready
var camera := $Camera3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _unhandled_input(event: InputEvent) -> void:
	if event is not InputEventMouseMotion:
		return
		
	camera.rotate_x(-event.relative.y * SENSIVILITY)
	rotate_y(-event.relative.x * SENSIVILITY)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("left", "right", "forward", "backwards")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var horizontal_velocity = velocity.slide(Vector3.UP)
	var acceleration = 6 * (direction * SPEED - horizontal_velocity)
	velocity += acceleration * delta

	move_and_slide()
