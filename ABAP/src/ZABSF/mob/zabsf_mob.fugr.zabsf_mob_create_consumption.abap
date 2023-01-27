function zabsf_mob_create_consumption.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(INPUTOBJ) TYPE  ZABSF_MOB_S_INPUTOBJECT
*"     VALUE(IS_CONSUMPTIONS_STR) TYPE  ZABSF_MOB_S_CONSUMPTION
*"     VALUE(IV_PEPELEMENT_VAR) TYPE  PS_POSID OPTIONAL
*"     VALUE(IV_COSTCENTER_VAR) TYPE  KOSTL OPTIONAL
*"     VALUE(IV_PRODOERDER_VAR) TYPE  AUFNR OPTIONAL
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  constants: lc_forpepel_cst type bwart value '221',
             lc_forcostc_cst type bwart value '201',
             lc_forprodo_cst type bwart value '261'.

  data: ls_headerst_str type bapi2017_gm_head_01,
        lv_document_var type mblnr,
        lv_docmyear_var type mjahr,
        lt_docitems_tab type table of bapi2017_gm_item_create.
  "data de lançamento do documento
  ls_headerst_str-pstng_date = sy-datum.
  "data do documento
  ls_headerst_str-doc_date = sy-datum.
  "adicionar item à tabela de items
  append value #( move_type    = cond #( when iv_costcenter_var is not initial
                                         then lc_forcostc_cst
                                         when iv_pepelement_var is not initial
                                         then lc_forpepel_cst
                                         when iv_prodoerder_var is not initial
                                         then lc_forprodo_cst  )
                  material     = |{ is_consumptions_str-matnr ALPHA = in }|
                  plant        = inputobj-werks
                  stge_loc     = is_consumptions_str-lgort
                  entry_qnt    = is_consumptions_str-menge
                  entry_uom    = is_consumptions_str-meins
                  batch        = is_consumptions_str-charg
                  wbs_elem     = iv_pepelement_var
                  costcenter   = iv_costcenter_var
                  val_wbs_elem = iv_pepelement_var
                  spec_stock   = cond #( when iv_pepelement_var is not initial
                                         then 'Q' )
                  mvt_ind      = '' ) to lt_docitems_tab.
  "criar documento material
  call function 'BAPI_GOODSMVT_CREATE'
    exporting
      goodsmvt_header  = ls_headerst_str
      goodsmvt_code    = '03'
    importing
      materialdocument = lv_document_var
      matdocumentyear  = lv_docmyear_var
    tables
      goodsmvt_item    = lt_docitems_tab
      return           = return_tab.
  "verificar se documento material foi criado
  if lv_document_var is initial.
    "rollback
    call function 'BAPI_TRANSACTION_ROLLBACK'.
    "sair do processamento
    return.
  else.
    "commit da operação
    call function 'BAPI_TRANSACTION_COMMIT'
      exporting
        wait = abap_true.
  endif.
endfunction.
