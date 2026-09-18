class_name Player
extends Node2D


const RECOVERY_RADIUS: float = 32.0
const RECOVERY_RING_WIDTH: float = 7.0
const RECOVERY_Y_OFFSET: float = -158.0
const RECOVERY_START_ANGLE: float = -PI / 2.0
const RECOVERY_BACKGROUND_COLOR: Color = Color(0.12, 0.14, 0.17, 0.75)
const RECOVERY_PROGRESS_COLOR: Color = Color("d7a449")

const WALK_SPEED: float = 520.0
const RUN_SPEED: float = 820.0
const MIN_X: float = -1200.0
const MAX_X: float = 3200.0
const GROUND_Y: float = 1584.0
const JUMP_SPEED: float = -760.0
const GRAVITY: float = 2500.0
const MOVEMENT_WOBBLE_ANGLE: float = 0.045
const MOVEMENT_WOBBLE_SPEED: float = 10.0

const GROUND_ACCEL: float = 4200.0
const GROUND_DECEL: float = 5200.0
const AIR_ACCEL: float = 2600.0
const AIR_DECEL: float = 2200.0

const COYOTE_TIME: float = 0.1
const JUMP_BUFFER_TIME: float = 0.12
const JUMP_CUT_MULTIPLIER: float = 0.45
const FALL_GRAVITY_MULTIPLIER: float = 1.6
const LOW_JUMP_GRAVITY_MULTIPLIER: float = 1.15
const SHOT_COOLDOWN: float = 1.0
const QUICK_SHOT_DRAW_RATIO: float = 0.80
const QUICK_SHOT_SPREAD: float = 0.38
const FAST_DRAW_RATIO: float = 0.80
const FAST_DRAW_SPEED_MULTIPLIER: float = 4.0
const FINAL_DRAW_SPEED_MULTIPLIER: float = 1.30
const SLOW_DRAW_SPEED_MULTIPLIER: float = 0.80
const FULL_DRAW_WOBBLE_DELAY: float = 0.35
const FULL_DRAW_AUTO_RELEASE_TIME: float = 2.0
const FULL_DRAW_WOBBLE_MAX_ANGLE: float = 0.14
const FULL_DRAW_WOBBLE_SPEED: float = 18.0
const MIN_PROJECTILE_SPEED_MULTIPLIER: float = 1.0
const MAX_PROJECTILE_SPEED_MULTIPLIER: float = 10.0
const MIN_EFFECTIVE_DRAW_RATIO: float = 0.05

signal shot_requested(direction: Vector2, launch_speed: float, is_quick_shot: bool)
signal draw_changed(ratio: float, drawing: bool)
signal reload_changed(progress: float)

@onready var bow: Bow = $Bow

var recovery_progress: float = 0.0
var velocity: Vector2 = Vector2.ZERO
var movement_wobble: float = 0.0
var is_crouching: bool = false
var facing_right: bool = true
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var jump_held: bool = false
var bow_inventory: BowInventory = BowInventory.new()
var draw_strength: float = 0.0
var is_drawing: bool = false
var left_mouse_held: bool = false
var slow_draw_held: bool = false
var full_draw_timer: float = 0.0
var shot_cooldown_timer: float = 0.0
var aim_angle: float = 0.0
var input_enabled: bool = true

func _ready() -> void:
	refresh_equipped_bow()

func _process(delta: float) -> void:
	if input_enabled:
		_update_facing_and_bow()
		_update_drawing(delta)
	_update_reload(delta)
	_emit_draw_state()

func _physics_process(delta: float) -> void:
	var move_input: float = Input.get_axis("move_left", "move_right")
	var move_speed: float = RUN_SPEED if Input.is_action_pressed("run") else WALK_SPEED
	var target_velocity_x: float = move_input * move_speed

	var grounded: bool = is_on_ground()
	var accel: float = GROUND_ACCEL if grounded else AIR_ACCEL
	var decel: float = GROUND_DECEL if grounded else AIR_DECEL
	if abs(target_velocity_x) > 0.01:
		velocity.x = move_toward(velocity.x, target_velocity_x, accel * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, decel * delta)

	_update_jump_timers(delta, grounded)
	jump_held = Input.is_action_pressed("jump")

	if Input.is_action_just_released("jump") and velocity.y < 0.0:
		velocity.y *= JUMP_CUT_MULTIPLIER

	if jump_buffer_timer > 0.0 and coyote_timer > 0.0:
		velocity.y = JUMP_SPEED
		jump_buffer_timer = 0.0
		coyote_timer = 0.0

	var gravity_scale: float = 1.0
	if velocity.y > 0.0:
		gravity_scale = FALL_GRAVITY_MULTIPLIER
	elif velocity.y < 0.0 and not jump_held:
		gravity_scale = LOW_JUMP_GRAVITY_MULTIPLIER

	if not grounded or velocity.y < 0.0:
		velocity.y += GRAVITY * gravity_scale * delta
	else:
		velocity.y = 0.0

	position.x = clamp(position.x + velocity.x * delta, MIN_X, MAX_X)
	position.y += velocity.y * delta
	if position.y >= GROUND_Y:
		position.y = GROUND_Y
		velocity.y = 0.0

	is_crouching = Input.is_action_pressed("crouch") and is_on_ground()

	if abs(move_input) > 0.01 and is_on_ground():
		movement_wobble += delta * MOVEMENT_WOBBLE_SPEED
	else:
		movement_wobble = 0.0

	queue_redraw()

func _update_facing_and_bow() -> void:
	if bow == null:
		return
	var mouse_world_position: Vector2 = get_global_mouse_position()
	set_facing_from_mouse(mouse_world_position)
	var aim_vector: Vector2 = mouse_world_position - bow.global_position
	if aim_vector.length_squared() > 0.001:
		var world_aim_angle: float = aim_vector.angle()
		aim_angle = world_aim_angle
		bow.set_aim(get_bow_aim_angle(world_aim_angle))

func _update_jump_timers(delta: float, grounded: bool) -> void:
	coyote_timer = COYOTE_TIME if grounded else max(coyote_timer - delta, 0.0)
	jump_buffer_timer = JUMP_BUFFER_TIME if Input.is_action_just_pressed("jump") else max(jump_buffer_timer - delta, 0.0)

func is_on_ground() -> bool:
	return position.y >= GROUND_Y - 0.5

func is_airborne() -> bool:
	return not is_on_ground()

func is_crouched() -> bool:
	return is_crouching

func get_aim_wobble() -> float:
	if abs(velocity.x) <= 0.01 or not is_on_ground():
		return 0.0
	return sin(movement_wobble) * MOVEMENT_WOBBLE_ANGLE

func set_facing_from_mouse(mouse_world_position: Vector2) -> void:
	var should_face_right: bool = mouse_world_position.x >= global_position.x
	if should_face_right == facing_right:
		return
	facing_right = should_face_right
	scale.x = 1.0 if facing_right else -1.0

func get_bow_aim_angle(world_angle: float) -> float:
	return world_angle if facing_right else PI - world_angle

func get_bow() -> Bow:
	return bow

func get_bow_data() -> BowData:
	return bow_inventory.get_equipped()

func get_bow_max_draw_strength() -> float:
	var data: BowData = get_bow_data()
	return data.max_draw_strength if data != null else 0.0

func get_bow_draw_speed() -> float:
	var data: BowData = get_bow_data()
	return data.draw_speed if data != null else 0.0

func get_bow_min_launch_speed() -> float:
	var data: BowData = get_bow_data()
	return data.min_launch_speed if data != null else 0.0

func get_bow_max_launch_speed() -> float:
	var data: BowData = get_bow_data()
	return data.max_launch_speed if data != null else 0.0

func set_recovery_progress(progress: float) -> void:
	recovery_progress = clamp(progress, 0.0, 1.0)
	queue_redraw()

func _draw() -> void:
	if recovery_progress <= 0.0:
		return
	var center: Vector2 = Vector2(0.0, RECOVERY_Y_OFFSET)
	draw_arc(center, RECOVERY_RADIUS, 0.0, TAU, 32, RECOVERY_BACKGROUND_COLOR, RECOVERY_RING_WIDTH, true)
	var end_angle: float = RECOVERY_START_ANGLE + TAU * recovery_progress
	draw_arc(center, RECOVERY_RADIUS, RECOVERY_START_ANGLE, end_angle, 32, RECOVERY_PROGRESS_COLOR, RECOVERY_RING_WIDTH, true)


func _unhandled_input(event: InputEvent) -> void:
	if not input_enabled:
		return
	if event is InputEventKey and event.keycode == KEY_CTRL:
		slow_draw_held = event.pressed
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		left_mouse_held = event.pressed
		if event.pressed:
			_start_drawing()
		elif is_drawing:
			_fire_arrow()
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		if shot_cooldown_timer > 0.0:
			return
		_start_drawing()
		if is_drawing:
			draw_strength = get_bow_max_draw_strength() * QUICK_SHOT_DRAW_RATIO
			_fire_arrow(true)

func _update_drawing(delta: float) -> void:
	if not is_drawing or not left_mouse_held:
		return
	var max_draw_strength: float = get_bow_max_draw_strength()
	if max_draw_strength <= 0.0:
		return
	var ratio: float = draw_strength / max_draw_strength
	var multiplier: float = SLOW_DRAW_SPEED_MULTIPLIER if slow_draw_held else (FAST_DRAW_SPEED_MULTIPLIER if ratio < FAST_DRAW_RATIO else FINAL_DRAW_SPEED_MULTIPLIER)
	draw_strength = minf(draw_strength + get_bow_draw_speed() * multiplier * delta, max_draw_strength)
	if draw_strength / max_draw_strength >= 1.0:
		full_draw_timer += delta
	else:
		full_draw_timer = 0.0
	if full_draw_timer >= FULL_DRAW_AUTO_RELEASE_TIME:
		_fire_arrow()

func _update_reload(delta: float) -> void:
	if shot_cooldown_timer > 0.0:
		shot_cooldown_timer = max(shot_cooldown_timer - delta, 0.0)
	if shot_cooldown_timer <= 0.0 and left_mouse_held and not is_drawing and input_enabled:
		_start_drawing()
	reload_changed.emit(1.0 - shot_cooldown_timer / SHOT_COOLDOWN)

func _start_drawing() -> void:
	if is_drawing or shot_cooldown_timer > 0.0:
		return
	is_drawing = true
	draw_strength = 0.0
	full_draw_timer = 0.0

func get_launch_speed_for_draw_ratio(strength_ratio: float) -> float:
	var clamped_ratio: float = clampf(strength_ratio, 0.0, 1.0)
	var base_speed: float = lerpf(get_bow_min_launch_speed(), get_bow_max_launch_speed(), clamped_ratio)
	var stat_adjusted_speed: float = Stats.get_max_launch_speed(base_speed)
	var effective_ratio: float = clampf((clamped_ratio - MIN_EFFECTIVE_DRAW_RATIO) / (1.0 - MIN_EFFECTIVE_DRAW_RATIO), 0.0, 1.0)
	return stat_adjusted_speed * lerpf(MIN_PROJECTILE_SPEED_MULTIPLIER, MAX_PROJECTILE_SPEED_MULTIPLIER, effective_ratio)

func _fire_arrow(is_quick_shot: bool = false) -> void:
	if not is_drawing or shot_cooldown_timer > 0.0:
		return
	is_drawing = false
	left_mouse_held = false
	full_draw_timer = 0.0
	var max_draw_strength: float = get_bow_max_draw_strength()
	if max_draw_strength <= 0.0:
		return
	var strength_ratio: float = clampf(draw_strength / max_draw_strength, 0.0, 1.0)
	var shot_angle: float = aim_angle
	if is_quick_shot:
		strength_ratio = QUICK_SHOT_DRAW_RATIO
		var spread: float = QUICK_SHOT_SPREAD * (1.0 - Skills.get_quick_shot_accuracy())
		shot_angle += randf_range(-spread, spread)
	var launch_speed: float = get_launch_speed_for_draw_ratio(strength_ratio)
	if not is_quick_shot:
		Stats.award_strength_release_xp(strength_ratio, Skills.get_xp_multiplier())
	shot_cooldown_timer = SHOT_COOLDOWN
	draw_strength = 0.0
	bow.play_release_recoil()
	shot_requested.emit(Vector2.RIGHT.rotated(shot_angle), launch_speed, is_quick_shot)

func _emit_draw_state() -> void:
	var max_draw_strength: float = get_bow_max_draw_strength()
	var ratio: float = 0.0 if max_draw_strength <= 0.0 else draw_strength / max_draw_strength
	bow.set_draw_ratio(ratio)
	draw_changed.emit(ratio, is_drawing)
	set_recovery_progress(ratio)

func _cancel_drawing() -> void:
	is_drawing = false
	left_mouse_held = false
	draw_strength = 0.0
	full_draw_timer = 0.0

func refresh_equipped_bow() -> void:
	var equipped: BowData = bow_inventory.get_equipped()
	if equipped != null:
		bow.set_data(equipped)

func equip_bow(bow_id: String) -> bool:
	if not bow_inventory.equip(bow_id, Stats.strength_level):
		return false
	refresh_equipped_bow()
	return true

func get_equipped_bow() -> BowData:
	return bow_inventory.get_equipped()

func set_input_enabled(enabled: bool) -> void:
	input_enabled = enabled
	if not enabled:
		_cancel_drawing()

func get_draw_ratio() -> float:
	var max_draw_strength: float = get_bow_max_draw_strength()
	return 0.0 if max_draw_strength <= 0.0 else draw_strength / max_draw_strength

func get_reload_progress() -> float:
	return 1.0 - shot_cooldown_timer / SHOT_COOLDOWN

func get_aim_angle() -> float:
	return aim_angle

func get_aim_direction() -> Vector2:
	return Vector2.RIGHT.rotated(aim_angle)
