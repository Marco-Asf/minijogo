extends Node

var num_stage: int = 1
var unlocked: Array = []

func _ready():
    # Inicializar com 3 fases: [true, false, false]
    unlocked = [true]   # Fase 1 desbloqueada (índice 0)
    unlocked.append(false)  # Fase 2 bloqueada (índice 1)
    unlocked.append(false)  # Fase 3 bloqueada (índice 2)
    print("ProgressManager iniciado. Fases: ", unlocked)

func on_level_completed(stage: int, score: int) -> void:
    print("🎯 Fase ", stage, " completada com score: ", score)
    
    # Converter número da fase para índice do array
    var indice_fase_atual = stage - 1  # Fase 1 → índice 0, Fase 2 → índice 1, etc.
    
    # Verificar se o índice é válido
    if indice_fase_atual >= unlocked.size():
        print("❌ Erro: Índice da fase inválido!")
        return
    
    # Marcar fase atual como concluída (se já não estiver)
    if !unlocked[indice_fase_atual]:
        unlocked[indice_fase_atual] = true
        print("✅ Fase ", stage, " marcada como concluída")
    else:
        print("📝 Fase ", stage, " já estava concluída")
    
    # Desbloquear APENAS a próxima fase se existir e não estiver desbloqueada
    var indice_proxima_fase = indice_fase_atual + 1
    if indice_proxima_fase < unlocked.size():
        if !unlocked[indice_proxima_fase]:
            unlocked[indice_proxima_fase] = true
            print("🚀 Fase ", indice_proxima_fase + 1, " DESBLOQUEADA!")
        else:
            print("⏭️  Fase ", indice_proxima_fase + 1, " já estava desbloqueada")
    else:
        print("🏆 Todas as fases já estão desbloqueadas!")
    
    num_stage = stage
    save_progress()
    
    # DEBUG: Mostrar status atual
    print("📊 Status atual das fases: ", unlocked)

func save_progress():
    var save_data = {
        "unlocked": unlocked,
        "num_stage": num_stage
    }
    print("💾 Progresso salvo: ", save_data)

func load_progress():
    # Implementar carregamento de arquivo se quiser
    pass

# Função para debug (opcional)
func _input(event):
    if event.is_action_pressed("ui_select"):  # Tecla Espaço
        print("=== DEBUG ProgressManager ===")
        print("Fases desbloqueadas: ", unlocked)
        print("Número do estágio: ", num_stage)
