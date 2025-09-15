
extends Node

var itens_coletados = 0
var total_itens = 4  # Ajuste para o número de itens da fase

func _ready():
    # Esperar a cena carregar e depois conectar os itens
    call_deferred("conectar_itens")

func conectar_itens():
    # Buscar todos os itens coletáveis da cena
    var itens = get_tree().get_nodes_in_group("itens_coletaveis")
    total_itens = itens.size()  # Total automático baseado na cena
    
    for item in itens:
        # Conectar ao sinal de coleta de cada item
        if item.has_method("item_coletado"):
            item.item_coletado.connect(_on_item_coletado)
        print("Conectado ao item: ", item.name)

func _on_item_coletado():
    itens_coletados += 1
    print("Itens coletados: ", itens_coletados, "/", total_itens)
    
    if itens_coletados >= total_itens:
        mostrar_vitoria()

func mostrar_vitoria():
    print("🎉 Todos os itens coletados!")
    
    # Criar popup de vitória
    var popup = AcceptDialog.new()
    popup.title = "Vitória!"
    popup.dialog_text = "PARABÉNS! Todos os itens coletados!\nPróxima fase desbloqueada!"
    popup.size = Vector2(400, 200)
    get_tree().root.add_child(popup)
    popup.popup_centered()
    
    # Conectar o fechamento do popup
    popup.confirmed.connect(
        func():
            # Salvar progresso no ProgressManager
            var pm = get_node("/root/ProgressManager")
            if pm:
                pm.on_level_completed(1, 100)  # Fase 1 concluída com score 100
            get_tree().change_scene_to_file("res://fases/tela_selecao.tscn")
    )

# Função para resetar quando mudar de cena
func resetar():
    itens_coletados = 0
    total_itens = 4
