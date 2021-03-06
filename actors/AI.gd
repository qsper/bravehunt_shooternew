extends Node2D

signal state_changed(new_state)

#stany przeciwnika
enum State {
	PATROL,
	ENGAGE
}

onready var player_detection_zone = $PlayerDetectionZone
onready var patrol_timer = $PatrolTimer

var current_state: int = -1 setget set_state
var actor: KinematicBody2D = null
var player: Player = null
var weapon: Weapon = null 

#PATROL STATE
var origin: Vector2 = Vector2.ZERO 
var patrol_location: Vector2 = Vector2.ZERO
var patrol_location_reached: bool = false
var actor_velocity: Vector2 = Vector2.ZERO

func _ready():
	set_state(State.PATROL)
	
func _physics_process(delta):
	match current_state:
		State.PATROL:
			if not patrol_location_reached:
				on_patrol_state()
		State.ENGAGE:
			if player != null and weapon != null:
				on_engage_state()
			else:
				print("In the engage state, but no weapon/player")
		_:
			print("Error: found a state for our enemy")

func initialize(actor, weapon: Weapon):
	self.actor = actor
	self.weapon = weapon
	
	weapon.connect("weapon_out_of_ammo", self, "handle_reload")

func set_state(new_state: int):
	if new_state == current_state:
		return
	if new_state == State.PATROL:
		origin = global_position
		patrol_timer.start()
		patrol_location_reached = true
	current_state = new_state
	emit_signal("state_changed", current_state)

func _on_PlayerDetectionZone_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		set_state(State.ENGAGE)
		player = body


func _on_PlayerDetectionZone_body_exited(body: Node) -> void:
	if player and body == player:
		set_state(State.PATROL)
		player = null

func handle_reload():
	weapon.start_reload()

func _on_PatrolTimer_timeout():
	var patrol_range = 50
	var random_x = rand_range(-patrol_range, patrol_range)
	var random_y = rand_range(-patrol_range, patrol_range)
	patrol_location = Vector2(random_x, random_y) + origin
	patrol_location_reached = false
	actor_velocity = actor.velocity_toward(patrol_location)
	
func on_patrol_state():
	actor.move_and_slide(actor_velocity)
	actor.rotate_toward(patrol_location)
	if actor.global_position.distance_to(patrol_location) < 5:
		patrol_location_reached = true
		actor_velocity = Vector2.ZERO
		patrol_timer.start()
	
func on_engage_state():
	actor_velocity = actor.position.direction_to(player.position) * 150
	actor.move_and_slide(actor_velocity)
	actor.rotate_toward(player.global_position)
	var angle_to_player = actor.global_position.direction_to(player.global_position).angle()
	if abs(actor.rotation - angle_to_player) < 0.1:
		weapon.shoot()
