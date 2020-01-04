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
var Elementar = ["Idle_Normal","Run_Normal","Jump_Normal","Jump_Normal","Die_Normal",200,20,-500,3,"Normal","Absorver_Normal"]
var _Elementar = "Idle_Normal"
var jump = false
var lado = 1
var prox_elemental = "Terra"
var auxiliar_elemental = 0
var aux = true
var anime_transformar = false

var reflexao = false

var ativar_absorver = false
var cdr_absorver = 0
var anima_absorver = false
const CDR_ABSORVER = 3

const TEMPO_ELEMENTAL = 3
var ativar_elemental = false
var s = 0

signal life_changed(life)
signal timer_changed(S)

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
	move.y += GRAVIDADE
	if Input.is_action_pressed("ui_home"):
		_absorver()
	else:
		_lancar_fire_ball()
		_andar()
		_pular()
		_skill_absorver()
	$Sprite.play(anime)
	move = move_and_slide(move,UP)

func _absorver():
	if anime_transformar:
		anime = "Transformando"
	_Elementar = Elementar[0]
	print("Absorver")
	if not is_on_floor():
		Elementar  = ["Idle_Ar","Run_Ar","Jump_Ar","Fall_Ar","Die_Ar",200,20,-500,3,"Ar","Absorver_Ar"]
	elif prox_elemental == "Terra":
		Elementar  = ["Idle_Terra","Run_Terra","Jump_Terra","Fall_Terra","Die_Terra",200,20,-500,3,"Terra","Absorver_Terra"]
	elif prox_elemental == "Fogo":
		Elementar  = ["Idle_Fogo","Run_Fogo","Jump_Fogo","Fall_Fogo","Die_Fogo",200,20,-500,3,"Fogo","Absorver_Fogo"]
	elif prox_elemental == "Agua":
		Elementar  = ["Idle_Agua","Run_Agua","Jump_Agua","Fall_Agua","Die_Agua",200,20,-500,3, "Agua","Absorver_Agua"]
	Caracteristicas(Elementar[5],Elementar[6],Elementar[7],Elementar[8])
	if _Elementar != Elementar[0]:
		print(ativar_elemental)
		$Transformacao.play("Transfomacao")
		anime_transformar = true
		ativar_elemental = true

func _lancar_fire_ball():
	if Input.is_action_just_pressed("ui_focus_next") and reflexao:
		reflexao = false
		var fireball = FIREBALL.instance()
		if lado == 1:
			fireball.position.x = $Origem_Reflexao.global_position.x
			fireball.set_fireball_direction(1)
		else:
			fireball.position.x = $Origem_Reflexao.global_position.x - 54
			fireball.set_fireball_direction(-1)
		fireball.position.y = $Origem_Reflexao.global_position.y
		get_parent().add_child(fireball)

func _skill_absorver():
	if anima_absorver:
		anime = Elementar[10]
	if !cdr_absorver:
		if Input.is_action_pressed("ui_skill_absorver"):
			ativar_absorver = true
			anima_absorver = true
			$Skill_Absorver.play("Skill_Absorver")

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
		jump = true
		if Input.is_action_just_pressed("ui_up"):
			move.y = JUMP_HEIGHT
	else:
		if jump == true and Input.is_action_just_pressed("ui_up") and Elementar[9] == "Ar":
			move.y = JUMP_HEIGHT
			jump = false
		if move.y < 0:
			anime = Elementar[2]
		else:
			anime = Elementar[3]

func _on_Dano_body_entered(body):
	VIDA-=1
	setlifes(VIDA)
	if !VIDA:
		Vida()
		
func Vida():
	queue_free()
	get_tree().change_scene("res://TitleScreen.tscn")

func dano_fireball():
	Vida()
	#print("Fire Friend")

func _tempo_elemental():
	s+=1
	if s > TEMPO_ELEMENTAL:
		ativar_elemental = false
		s = 0
		Elementar = ["Idle_Normal","Run_Normal","Jump_Normal","Jump_Normal","Die_Normal",200,20,-500,3,"Normal","Absorver_Normal"]
	
	emit_signal("timer_changed",s)

func _cdr_absorver():
	cdr_absorver+=1
	if cdr_absorver > CDR_ABSORVER:
		ativar_absorver = false
		cdr_absorver = 0

func _on_Timer_timeout():
	if ativar_elemental:
		_tempo_elemental()
	if ativar_absorver:
		_cdr_absorver()
		print(cdr_absorver)


func _on_Pe_body_entered(body):
	var elemento = int(str(body).substr(9,4))
	var next = -elemento + auxiliar_elemental
	if  next == - 2:
		prox_elemental = 'Fogo'
	elif next == - 1:
		prox_elemental = 'Agua'
	elif next == 0:
		prox_elemental = 'Terra'
	else:
		if aux:
			auxiliar_elemental = int(str(body).substr(9,4))
			aux = false
	print(-elemento + auxiliar_elemental)


func _on_Skill_Absorver_animation_finished(anim_name):
	anima_absorver = false


func _on_Skill_Absorver_animation_started(anim_name):
	anima_absorver = true


func _on_Transformacao_animation_finished(anim_name):
	anime_transformar = false