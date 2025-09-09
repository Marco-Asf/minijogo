extends Control

@onready var _levels := $Levels
var _btns: Array[BaseButton] = []
var _locks: Array[CanvasItem] = []

func _ready() -> void:
	_collect_refs()
	_connect_signals()
	_refresh_ui()

func _collect_refs() -> void:
	_btns.clear()
	_locks.clear()
	# pega todos os filhos de Levels que sejam botões
	for n in _levels.get_children():
		if n is BaseButton:
			_btns.append(n)
			# se existir um filho chamado "Lock" dentro do botão, guardamos
			_locks.append(n.get_node_or_null("Lock"))

func _connect_signals() -> void:
	for i in _btns.size():
		var btn := _btns[i]
		if btn and btn.is_inside_tree():
			# evita conectar duas vezes
			if not btn.pressed.is_connected(_on_level_pressed.bind(i)):
				btn.pressed.connect(_on_level_pressed.bind(i))

func _on_level_pressed(idx: int) -> void:
	# TODO: sua lógica de abrir fase idx
	print("Clicou na fase ", idx)

func _refresh_ui() -> void:
	for i in _btns.size():
		var aberto := Global.is_unlocked_zero_based(i)
		_btns[i].disabled = not aberto
		# lock opcional (só se existir)
		var lock := _locks[i]
		if lock:
			lock.visible = not aberto
		_btns[i].modulate = Color(1, 1, 1, 1.0 if aberto else 0.6)
