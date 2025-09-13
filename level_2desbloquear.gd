# level2.gd  (anexe no nó raiz da Fase 2)
extends Node2D

# ajuste se o caminho da tela de seleção for diferente
const LEVEL_SELECT_SCENE := "res://level_select.tscn"

func _ready() -> void:
	# Fase 2 é índice 1 (zero-based). Se a fase 1 não foi concluída, volta pro select.
	if not Global.is_unlocked_zero_based(1):
		get_tree().change_scene_to_file(LEVEL_SELECT_SCENE)
		return

	# (opcional) aqui você pode iniciar timers, inimigos, objetivos etc.

# CHAME ESTA FUNÇÃO QUANDO O JOGADOR COMPLETAR A FASE 2
func win_level() -> void:
	# desbloqueia a fase 3 (índice 2 zero-based) se ainda não estiver
	var precisa_desbloquear_3 := Global.get_unlocked_count() < 3
	if precisa_desbloquear_3:
		Global.set_unlocked_count(3)  # agora 3 fases ficam acessíveis: 0,1,2
		Global.save_progress()

	# volta para a tela de seleção
	get_tree().change_scene_to_file(LEVEL_SELECT_SCENE)
