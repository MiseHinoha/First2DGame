extends Area2D
signal hit # 定义一个hit信号

@export var speed = 400
var screen_size

# 初始化
func _ready():
	screen_size = get_viewport_rect().size
	hide()

# 移动逻辑
func movement(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	
	# 有输入就播放画，否则停止
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	# position表示位置
	position += velocity * delta
	# clamp 方法防止该对象超出屏幕范围
	position = position.clamp(Vector2.ZERO,screen_size)
	
	# 选择播放的动画
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false # 水平翻转
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

# 每个delta时间执行一次
func _process(delta):
	movement(delta)


func _on_body_exited(body):
	hide()# 隐藏玩家
	hit.emit()
	$CollisionShape2D.set_deferred("disabled",true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
