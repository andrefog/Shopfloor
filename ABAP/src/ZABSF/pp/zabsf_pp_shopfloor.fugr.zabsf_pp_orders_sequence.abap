function zabsf_pp_orders_sequence.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IT_ORDERS_TAB) TYPE  ZABSF_PP_ORDER_SEQ_TT
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  "variáveis locais
  data: lv_sequence_var type posnr,
        ls_sequerow_str type zabsf_pp084,
        lt_sequerow_tab type table of zabsf_pp084.

  "limpar variáveis de exportação
  refresh return_tab.
  "ordernar tabela por sequência
  sort it_orders_tab by sequence ascending.
  "percorrer ordes de produção
  loop at it_orders_tab assigning field-symbol(<fs_orders_str>).
    "actualizar contador
    add 1 to lv_sequence_var.
    "nova posição
    <fs_orders_str>-sequence = lv_sequence_var.
    move-corresponding <fs_orders_str> to ls_sequerow_str.
    "adicionar linha actualizar
    append ls_sequerow_str to lt_sequerow_tab.
    "limpar variáveis
    clear ls_sequerow_str.
  endloop.

  "actualizar tabela
  modify zabsf_pp084 from table @lt_sequerow_tab.
  if sy-subrc eq 0.
    "commit operação
    commit work.
  else.
    "rollback operação
    rollback work.
    "mensagem de erro
    call method zabsf_pp_cl_log=>add_message
      exporting
        msgid      = 'ZABSF_PP'
        msgty      = 'E'
        msgno      = '163'
      changing
        return_tab = return_tab.
  endif.
endfunction.
