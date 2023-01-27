function zabsf_mob_get_delivery_data.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(INPUTOBJ) TYPE  ZABSF_MOB_S_INPUTOBJECT
*"     VALUE(IV_DELIVERY_VAR) TYPE  VBELN
*"     VALUE(IV_GET_ITEMS_VAR) TYPE  BOOLE_D OPTIONAL
*"  EXPORTING
*"     VALUE(ES_DELIVERY_STR) TYPE  ZABSF_MOB_S_DELIVERY_DATA
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  "variáveis locais
  data lv_delivery_var type vbeln.

  "nº remessa
  lv_delivery_var = |{ iv_delivery_var alpha = in }|.
  "ler dados da remessa
  select single likp~*, kna1~name1
    from likp as likp
    inner join kna1 as kna1
    on kna1~kunnr eq likp~kunnr
    into corresponding fields of @es_delivery_str
      where vbeln eq @lv_delivery_var.
  if sy-subrc ne 0.
    "Remessa inválida!
    call method zabsf_mob_cl_log=>add_message
      exporting
        msgty      = 'E'
        msgno      = 005
      changing
        return_tab = return_tab.
    "sair do processamento
    return.
  endif.
  "verificar se é para obter items
  if iv_get_items_var eq abap_true.
    "obter items da dilvery
    call function 'ZABSF_MOB_GET_DELIVERY_ITEMS'
      exporting
        inputobj        = inputobj
        iv_delivery_var = lv_delivery_var
      importing
        et_delivitm_tab = es_delivery_str-deliv_items.
  endif.
endfunction.
