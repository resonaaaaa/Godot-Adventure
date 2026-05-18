extends RigidBody2D

@export var initial_velocity = -100.0
var is_active = false

func _ready() -> void:
	# 完全冻结在空中
	freeze = true
	freeze_mode = RigidBody2D.FREEZE_MODE_STATIC
	
func _physics_process(delta: float) -> void:
	pass

func _on_sensor_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		# 护盾判定，当护盾激活时摧毁滚石
		if body.get("is_shield_active") == true:
			destroy_stone()
			return
		# 否则调用玩家死亡方法
		if body.has_method("player_dead"):
			body.player_dead()

func destroy_stone():
	# 停止物理模拟
	set_deferred("freeze", true)
	linear_velocity = Vector2.ZERO
	
	# 隐藏贴图
	$Sprite2D.hide()
	
	# 禁用碰撞检测
	$CollisionShape.set_deferred("disabled", true)
	$Sensor.set_deferred("monitoring", false)
	$Trigger.set_deferred("monitoring", false)
	
	# 激活已被配好的粒子特效
	if $GPUParticles2D:
		$GPUParticles2D.emitting = true
		await get_tree().create_timer($GPUParticles2D.lifetime).timeout
	
	# 彻底销毁节点
	queue_free()

func set_stone_active(body: Node2D):
	if body.is_in_group("player") and not is_active:
		is_active = true
		# 在 Godot 中，在碰撞回调（body_entered）期间直接修改物理状态（如 freeze）会失败，必须延迟调用
		call_deferred("_unfreeze_and_start")

func _unfreeze_and_start():
	freeze = false
	sleeping = false
	linear_velocity.x = initial_velocity

	
	
