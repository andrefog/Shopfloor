FUNCTION ZABSF_PP_CHECK_MAT_AVAIL_ORDER.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(AUFNR) TYPE  AUFNR
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(ET_MISSING_MATS_TAB) TYPE  ZBAPI_ORDER_RETURN_TT
*"--------------------------------------------------------------------
"variávis locais
  data:lv_reset_avail_data_var   type bapi_order_func_cntrl-reset_avail_data,
       lt_orders_tab             type standard table of bapi_order_key,
       ls_orders_str             type bapi_order_key,
       lv_scope_avail_var        type bapi_order_func_cntrl-scope_avail,
       lv_fix_planned_orders_var type bapi_order_func_cntrl-fix_planned_orders,
       lv_aufnr_var              like aufk-aufnr,
       lv_description_var        type char50.

  "conversão de formatos
  lv_aufnr_var = |{ aufnr alpha = in }|.
  "preencher campos da estrutura  e anexar 'lt_orders_tab'
  append value #( order_number = lv_aufnr_var ) to lt_orders_tab.

  "settings de execução da BAPI
  lv_reset_avail_data_var = abap_true.
  "Verificação ATP de todos os materiais
  lv_scope_avail_var = 'A'.
  lv_fix_planned_orders_var = abap_true.

  "verificar disponibilidade dos materiais para a ordem
  call function 'BAPI_PRODORD_CHECK_MAT_AVAIL'
    exporting
      reset_avail_data   = lv_reset_avail_data_var
      scope_avail        = lv_scope_avail_var
      fix_planned_orders = lv_fix_planned_orders_var
    tables
      orders             = lt_orders_tab
      detail_return      = et_missing_mats_tab.

  "alterar na mensagem o nome do material pelo valor da caracteristica do descritivo do material
  call method zcl_mm_classification=>switch_material_description
    exporting
      im_missing_mats_tab         = et_missing_mats_tab
      im_aufnr_var                = lv_aufnr_var
    importing
      ex_mssing_mats_descript_tab = et_missing_mats_tab.





ENDFUNCTION.
