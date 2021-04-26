extends "res://scripts/Event.gd"


onready var Player = preload("res://scenes/Player.tscn")
var two_players = false
var player_count = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()
	randomize()


func _on_EnemySpawnTimer_timeout():
	
	var temp=randi()
	var temp2=randi()
	if temp2%2==0:
		if temp%4==0:
			self.spawn_V_group()
			$EnemySpawnTimer.wait_time = rand_range(4.0, 5.0)
		elif temp%4==1:
			self.spawn_Random_enemy()
			$EnemySpawnTimer.wait_time = rand_range(2.0, 3.0)
		elif temp%4==2:
			self.spawn_Square_group()
			$EnemySpawnTimer.wait_time = rand_range(4.0, 5.0)
		else:
			self.spawn_line_group()
			$EnemySpawnTimer.wait_time = rand_range(3.0, 4.0)
	else:
		self.spawn_Random_enemy()
		$EnemySpawnTimer.wait_time = rand_range(2.0, 3.0)
	
	#self.spawn_V_group()
	#self.spawn_line_group()
	#self.spawn_Square_group()
	
func tmep():
	var type= randi()
	$EnemySpawnPath/EnemySpawn.offset = randi()
	var enemy
	var temp
	if type%3==0 and temp==0:
		enemy = EnemyBig.instance()
		temp=1
	elif type%3==1:
		enemy = Enemy2.instance()
	else:
		enemy = Enemy.instance()

	add_child(enemy)
	
	enemy.connect("death", self, "_on_Enemy_death")
	enemy.position = $EnemySpawnPath/EnemySpawn.position
	
	var direction = $EnemySpawnPath/EnemySpawn.rotation + PI / 2
	direction += rand_range(-PI / 4, PI / 4)
	
	enemy.linear_velocity = Vector2(rand_range(enemy.min_speed, enemy.max_speed), 0).rotated(direction)
	
	

func _on_Player_health_updated(health):
	$HUD.update_health(health, 0)

func _on_Enemy_death(score_value):
	$HUD.add_score(score_value)


func _on_Player_weapon_changed(weapon):
	$HUD.change_weapon(weapon, 0)


func _on_Player2_health_updated(health):
	$HUD.update_health(health, 1)


func _on_Player2_weapon_changed(weapon):
	$HUD.change_weapon(weapon, 1)


func new_game():
	$Player.start($StartPosition.position, $outside.position)
	$StartTimer.start()
	$HUD.reset_score()
	$HUD.show_message('Get Ready')


func _on_StartTimer_timeout():
	$EnemySpawnTimer.start()


func game_over():
	player_count -= 1
	if player_count == 0:
		$EnemySpawnTimer.stop()
		$HUD.show_game_over()
		get_tree().call_group('Enemies', 'queue_free')
		

func _process(delta):
	if Input.is_action_pressed("p2_fire") and not two_players:
		$Player2.start($StartPositionP2.position, $outside.position, 1)
		two_players = true
		player_count = 2
		$HUD.show_p2()



