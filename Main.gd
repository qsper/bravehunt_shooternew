extends Node2D

onready var bullet_manager = $BulletManager
onready var player: Player = $Player
onready var enemy: Enemy = $Enemy
onready var gui = $GUI

func _ready() -> void:
	randomize()
	setupSignals()
	initGui()

func setupSignals():
	# obsluga wystrzalu
	GlobalSignals.connect("bullet_fired", bullet_manager, "handle_bullet_spawned")
	
	# aktualizacja paska zycia
	GlobalSignals.connect("gui_player_health_changed", gui, "set_new_health_value")
	
	# aktualizacja paska broni
	GlobalSignals.connect("gui_ammo_changed", gui, "set_ammo_info")
	
	#aktualizacja fragów
	enemy.connect("enemy_died", player, "on_enemyDied")
	GlobalSignals.connect("gui_kill_stat", gui, "set_kills_stat")
	
func initGui():
	# inicjacja paska zycia
	gui.set_new_health_value(player.health_stat.health)
	var weapon = player.get_current_weapon()
	gui.set_ammo_info(weapon.current_ammo, weapon.max_ammo)
	gui.set_kills_stat(player.kills)

