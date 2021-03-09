extends KinematicBody2D
class_name Enemy
signal enemy_died()
onready var health_stat = $Health
onready var ai = $AI
onready var health_bar = $Health/HealthBar
onready var weapon = $Weapon
var blood = load("res://Blood_particles.tscn")


export (int) var speed = 200

func _ready():
	ai.initialize(self, weapon)
	setHealthBar(100)
	
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
	var newHealth = getHealth() - 20
	setHealth(newHealth)

func getHealth() -> int:
	return health_stat.health

func setHealth(value: int):
	health_stat.health -= 20
	on_HealthChanged(value)

func on_HealthChanged(value):
	setHealthBar(value)
	if value <= 0:
		on_EnemyDied()

func setHealthBar(value):
	health_bar.value = value

func on_EnemyDied():
	queue_free()
	emit_EnemyDie()
	
func emit_EnemyDie():
	emit_signal("enemy_died")
