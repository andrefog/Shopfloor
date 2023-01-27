function zabsf_mob_subcontract_recption.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(INPUTOBJ) TYPE  ZABSF_MOB_S_INPUTOBJECT
*"     VALUE(IS_PO_ITEM) TYPE  ZABSF_MOB_S_ITEM_DETAIL
*"     VALUE(IV_DELIVERY_NOTE) TYPE  LFSNR1
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  "constantes
  constants: lc_movecode_cst type bapi2017_gm_code value '01',
             lc_mvmtrecp_cst type bwart value '101',
             lc_mvmsubct_cst type bwart value '543'.
  "variáveis locais
  data: ls_headerst_str type bapi2017_gm_head_01,
        lv_document_var type mblnr,
        lv_docmyear_var type mjahr,
        lt_docitems_tab type table of bapi2017_gm_item_create,
        lr_lbacthes_rng type range of charg_d.

*  "obter impressora
  select single printer
    from zabsf_mob_trfprt
    into @data(lv_printer_var)
      where werks eq @inputobj-werks
        and lgort eq @is_po_item-lgort.
  if sy-subrc ne 0.
    "Nenhuma impressora configurada para &1 &2
    call method zabsf_mob_cl_log=>add_message
      exporting
        msgty      = 'E'
        msgno      = 004
        msgv1      =  inputobj-werks
        msgv2      = is_po_item-lgort
      changing
        return_tab = return_tab.
    "sair do processamento
    return.
  endif.

  "data de lançamento do documento
  ls_headerst_str-pstng_date = sy-datum.
  "data do documento
  ls_headerst_str-doc_date = sy-datum.
  "nota da guia
  ls_headerst_str-ref_doc_no = iv_delivery_note.
  "converter para maiusculas
  translate ls_headerst_str-ref_doc_no to upper case.
  "obter diagrama de rede e actividade
  select single ekkn~nplnr,
                afvc~vornr
    from ekkn as ekkn
    inner join caufv as caufv
    on caufv~aufnr eq ekkn~nplnr
    inner join afvc as afvc
    on afvc~aufpl eq caufv~aufpl and afvc~aplzl eq ekkn~aplzl
    into ( @data(lv_network_var), @data(lv_activity_var) )
    where ekkn~ebeln eq @is_po_item-ebeln
      and ekkn~ebelp eq @is_po_item-ebelp.

  "item principal
  append value #( move_type   = lc_mvmtrecp_cst
                  material    = is_po_item-matnr
                  plant       = is_po_item-werks
                  stge_loc    = is_po_item-lgort
                  entry_qnt   = is_po_item-menge
                  entry_uom   = is_po_item-meins
                  batch       = is_po_item-charg
                  po_number   = is_po_item-ebeln
                  po_item     = is_po_item-ebelp
                  line_id     = is_po_item-line_id
                  network	    = lv_network_var
                  activity    = lv_activity_var
                  mvt_ind     = 'B' ) to lt_docitems_tab.
  "subitems
  loop at is_po_item-subitems into data(ls_subitem_str).
    "adicionar item à tabela de items
    append value #( move_type   = lc_mvmsubct_cst
                    material    = ls_subitem_str-matnr
                    plant       = is_po_item-werks
                    stge_loc    = ls_subitem_str-lgort
                    entry_qnt   = ls_subitem_str-menge
                    entry_uom   = ls_subitem_str-meins
                    batch       = ls_subitem_str-charg
                    po_number   = ls_subitem_str-ebeln
                    po_item     = ls_subitem_str-ebelp
                    line_id     = ls_subitem_str-line_id
                    network     = lv_network_var
                    activity    = lv_activity_var
                    parent_id   = ls_subitem_str-parent_id
                    mvt_ind     = 'O' ) to lt_docitems_tab.
  endloop.
  "criar documento material
  call function 'BAPI_GOODSMVT_CREATE'
    exporting
      goodsmvt_header  = ls_headerst_str
      goodsmvt_code    = lc_movecode_cst
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

    "adicionar lote à tabela
    append value #( sign   = 'I'
                    option = 'EQ'
                    low    = ls_subitem_str-charg ) to lr_lbacthes_rng.
    "imprimir etiqueta do 101
    zcl_absf_mob=>print_movements_label( exporting
                                            im_rc_trans_var  = abap_true
                                            im_docnumber_var = lv_document_var
                                            im_docyear_var   = lv_docmyear_var
                                            im_batch_rng     = lr_lbacthes_rng[]
                                            im_printer_var   = lv_printer_var
                                          changing
                                            ch_return_tab    = return_tab ).
  endif.
endfunction.
