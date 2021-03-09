extends KinematicBody2D
class_name Player

export (int) var speed = 300
export (int) var kills = 0

onready var weapon_menager = $WeaponManager
onready var health_stat = $Health

func _ready():
	print('Player._ready call')
	Global.player = self
	
func _exit_tree():
	Global.player = null

func _physics_process(delta: float) -> void:
	var movement_direction := Vector2.ZERO
	
	if Input.is_action_pressed("up"):
		movement_direction.y = -1
	if Input.is_action_pressed("down"):
		movement_direction.y = 1
	if Input.is_action_pressed("left"):
		movement_direction.x = -1
	if Input.is_action_pressed("right"):
		movement_direction.x = 1
	
	movement_direction = movement_direction.normalized()
	move_and_slide(movement_direction * speed)
	
	look_at(get_global_mouse_position())
	
func handle_hit():
	print("handle_hit call")
	health_stat.health -= 20
	GlobalSignals.emit_signal("gui_player_health_changed", health_stat.health)
	print("player hit! ", health_stat.health)
	if health_stat.health <= 0:
		print("Zdechłeś")
	
func get_current_weapon() -> Weapon:
	return weapon_menager.current_weapon
	
func healing():
	health_stat.health += 20
	GlobalSignals.emit_signal("gui_player_health_changed", health_stat.health)

func on_enemyDied():
	kills += 1
	GlobalSignals.emit_signal("gui_kill_stat", kills)
	print(kills)
