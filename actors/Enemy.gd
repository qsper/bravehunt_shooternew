extends KinematicBody2D
class_name Enemy

signal enemy_died()

onready var health_stat = $Health
onready var ai = $AI
onready var weapon = $Weapon
var blood = load("res://Blood_particles.tscn")


export (int) var speed = 200

func _ready():
	ai.initialize(self, weapon)
	
func _physics_process(delta):
	if health_stat.health <= 0:
		var  blood_instance = blood.instance()
		get_tree().current_scene.add_child(blood_instance)
		blood_instance.global_position = global_position
		blood_instance.rotation = global_position.angle_to_point(Global.player.global_position)
	
	
func rotate_toward(location: Vector2):
	rotation = lerp(rotation, global_position.direction_to(location).angle(), 0.1)

func velocity_toward(location: Vector2) -> Vector2:
	return global_position.direction_to(location) * speed

func handle_hit():
	health_stat.health -= 20
	if health_stat.health <= 0:
		
		queue_free()
		emit_EnemyDie()
		
		
func emit_EnemyDie():
	emit_signal("enemy_died")
	


