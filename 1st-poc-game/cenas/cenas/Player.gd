extends KinematicBody2D

const FIREBALL = preload("res://cenas/Player/FireBall.tscn") 
const UP = Vector2(0,-1)
var GRAVIDADE = 20
var SPEED = 200
var JUMP_HEIGHT = -500
var VIDA = 3  setget setlifes
var MANA =  200 
var move = Vector2()
var anime
var Elementar = ["Idle_Normal","Run_Normal","Jump_Normal","Jump_Normal","Die_Normal",200,20,-500,3]
var _Elementar = "Idle_Normal"
var jump = false
var lado = 1
var regen_mana = 0
var cont = false

var ms = 0
var s = 0
var m = 0

signal life_changed(life)
signal timer_changed(M,S,MS)

func setlifes(val):
	VIDA = val
	emit_signal("life_changed",val)
	print(VIDA)

func Caracteristicas(Speed,Peso,Jump,Vida):
	GRAVIDADE = Peso
	SPEED = Speed
	JUMP_HEIGHT = Jump
	VIDA = Vida
	
func _physics_process(delta):
	if Elementar[0] != _Elementar:
		cont  = true
		s = 0
	
	if cont:
		Tempo()
	move.y += GRAVIDADE
	if Input.is_action_pressed("ui_home"):
		_absorver()
	else:
		if Input.is_action_just_pressed("ui_focus_next"):
			_lancar_fire_ball()
		_andar()
		_pular()
	$Sprite.play(anime)
	move = move_and_slide(move,UP)

func _absorver():
	_Elementar = Elementar[0]
	#Criar uma matriz referente aos elementos e suas respectivas animações sendok armazenadas na forma de string
	if Input.is_action_pressed("ui_left"):
		Elementar  = ["Idle_Fogo","Run_Fogo","Jump_Fogo","Fall_Fogo","Die_Fogo",200,20,-500,3]
	elif Input.is_action_pressed("ui_right"):
		Elementar  = ["Idle_Agua","Run_Agua","Jump_Agua","Fall_Agua","Die_Agua",200,20,-500,3]
	elif Input.is_action_pressed("ui_up"):
		Elementar  = ["Idle_Ar","Run_Ar","Jump_Ar","Fall_Ar","Die_Ar",200,20,-500,3]
	elif Input.is_action_pressed("ui_down"):
		Elementar  = ["Idle_Terra","Run_Terra","Jump_Terra","Fall_Terra","Die_Terra",200,20,-500,3]
	else:
		move.x = 0
	Caracteristicas(Elementar[5],Elementar[6],Elementar[7],Elementar[8])


func _lancar_fire_ball():
		var fireball = FIREBALL.instance()
		if lado == 1:
			fireball.position = $FireDir.global_position
			fireball.set_fireball_direction(1)
		else:
			fireball.position = $FireEsq.global_position
			fireball.set_fireball_direction(-1)
		get_parent().add_child(fireball)

func _andar():
	if Input.is_action_pressed("ui_right"):
		move.x = SPEED
		anime = Elementar[1]
		lado = 1
		$Sprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		move.x = -SPEED
		anime = Elementar[1]
		lado = -1
		$Sprite.flip_h = true
	else:
		move.x = 0
		anime = Elementar[0]

func _pular():
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			move.y = JUMP_HEIGHT
			jump = true
	else:
		if jump == true and Input.is_action_just_pressed("ui_up"):
			move.y = JUMP_HEIGHT
			jump = false
		if move.y < 0:
			anime = Elementar[2]
		else:
			anime = Elementar[3]

func Agachar():
	$Sprite2.play("Die")
	get_node("Animate").play("Die")

func _on_Dano_body_entered(body):
	#Vida()
	VIDA-=1
	setlifes(VIDA)
	if !VIDA:
		Vida()
	
func Vida():
	queue_free()
	get_tree().change_scene("res://Menu.tscn")

func dano_fireball():
	Vida()
	print("Fire Friend")

func Regen_Mana():
	if MANA < 200:
		Tempo()
		if s == 2:
			s = 0
			ms = 0
			if (200 - MANA) < 50:
				MANA = 200
			else:
				MANA += 50

func Tempo():
	if ms > 9:
		s+=1
		ms=0
	
	if s > 59:
		m+=1
		s=0
	
	if m>59:
		m=0
		s=0
	
	if s > 120:
		cont = false
		s = 0
		Elementar = ["Idle_Normal","Run","Jump","Fall","Die",200,20,-500,3]
		
	emit_signal("timer_changed",m,s,ms)

func _on_Timer_timeout():
	ms+= 1
