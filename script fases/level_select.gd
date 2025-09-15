extends Control

@onready var _levels := $Levels
var _btns: Array[BaseButton] = []
var _locks: Array[CanvasItem] = []

func _ready():
    collect_refs()
    connect_signals()
    _refresh_ui()

func collect_refs() -> void:
    _btns.clear()
    _locks.clear()
    
    for n in _levels.get_children():
        if n is TextureButton:
            _btns.append(n)
            # 🔥 AGORA: Busca o TextureRect que é o cadeado
            # Os cadeados são os TextureRect dentro dos TextureButton
            var texture_rect = null
            
            # Verifica TODOS os filhos do TextureButton
            for child in n.get_children():
                if child is TextureRect:
                    texture_rect = child
                    break  # Pega o primeiro TextureRect encontrado
            
            _locks.append(texture_rect)
            print("Botão: ", n.name, " - Cadeado: ", texture_rect)

func connect_signals() -> void:
    for i in _btns.size():
        var btn := _btns[i]
        if btn and btn.is_inside_tree():
            if not btn.pressed.is_connected(_on_level_pressed.bind(i)):
                btn.pressed.connect(_on_level_pressed.bind(i))

func _on_level_pressed(idx: int) -> void:
    var pm = get_node("/root/ProgressManager")
    if pm and idx < pm.unlocked.size() and pm.unlocked[idx]:
        print("Abrindo fase ", idx + 1)
    else:
        print("Fase ", idx + 1, " está bloqueada!")

func _refresh_ui() -> void:
    var pm = get_node("/root/ProgressManager")
    
    if not pm:
        print("ProgressManager não encontrado!")
        return
    
    print("Atualizando UI. Fases desbloqueadas: ", pm.unlocked)
    
    for i in _btns.size():
        var aberto := false
        if i < pm.unlocked.size():
            aberto = pm.unlocked[i]
        else:
            aberto = false
        
        _btns[i].disabled = not aberto
        
        # CONTROLE DO TextureRect (cadeado)
        if i < _locks.size() and _locks[i] != null:
            _locks[i].visible = not aberto  # Cadeado SOME quando aberto
            print("Botão ", i, " - Cadeado visible: ", _locks[i].visible)
        else:
            print("Botão ", i, " - TextureRect não encontrado")
        
        # Aparência visual do botão
        if aberto:
            _btns[i].modulate = Color(1, 1, 1, 1)  # Colorido
        else:
            _btns[i].modulate = Color(0.5, 0.5, 0.5, 0.5)  # Cinza

# 🔥 DEBUG: Tecla R para recarregar e verificar
func _input(event):
    if event.is_action_pressed("ui_accept"):  # Tecla ESPAÇO
        print("Recarregando UI...")
        _refresh_ui()
