function zabsf_mob_stock_transfer.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_MATERIAL_VAR) TYPE  MATNR
*"     VALUE(IV_CENTRO_DEST_VAR) TYPE  WERKS_D OPTIONAL
*"     VALUE(IV_LOTE_DEST_VAR) TYPE  CHARG_D OPTIONAL
*"     VALUE(IV_QUANTIDADE_VAR) TYPE  ERFMG
*"     VALUE(IV_BASE_UOM_VAR) TYPE  MEINS
*"     VALUE(IV_PEP_ORIG_VAR) TYPE  CHAR30 OPTIONAL
*"     VALUE(IV_PEP_DEST_VAR) TYPE  CHAR30 OPTIONAL
*"     VALUE(IV_DEPOS_ORIG_VAR) TYPE  LGORT_D OPTIONAL
*"     VALUE(IV_DEPOS_DEST_VAR) TYPE  LGORT_D OPTIONAL
*"     VALUE(IV_ID_OPERATION_VAR) TYPE  ZABSF_MOB_OPERATION_ID
*"     VALUE(IV_STOCK_ESP_VAR) TYPE  SOBKZ OPTIONAL
*"     VALUE(IV_GMCODE_VAR) TYPE  GM_CODE
*"     VALUE(INPUTOBJ) TYPE  ZABSF_MOB_S_INPUTOBJECT
*"     VALUE(IV_MOVEMENT_VAR) TYPE  BWART OPTIONAL
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  "constantes locais
  constants: lc_localizt_cst type ps_stort value 'BYS0000002'.
  "variáveis locais
  data: lt_goodsmvt_item_tab   type standard table of bapi2017_gm_item_create,
        ls_goodsmvt_header_str type bapi2017_gm_head_01,
        ls_goodsmvt_code_str   type bapi2017_gm_code,
        lv_material_var        type matnr,
        lv_document_var        type mblnr,
        lv_docuyear_var        type mjahr,
        lt_lablerec_tab        type zpp_return_rec_label_tt,
        lr_lbacthes_rng        type range of charg_d,
        lv_pepelemt_var type ps_psp_pnr.
  "verificar se é para imprimir etiqueta
  select single *
    from zabsf_mob_config
    into @data(ls_mobconfg_str)
      where werks        eq @inputobj-werks
        and operation_id eq @iv_id_operation_var.

  "verificar se é para limpar PEP destino
  if ls_mobconfg_str-clear_pep_dest eq abap_true.
    "limpar PEP destino
    clear iv_pep_dest_var.
  endif.

  "determinação automática de PEP
  if ls_mobconfg_str-automatic_pep eq abap_true.
    "convsersão de formatos
    call function 'CONVERSION_EXIT_ABPSP_INPUT'
      exporting
        input  = iv_pep_dest_var
      importing
        output = lv_pepelemt_var.

    "obter PEP do projecto
    select single psphi
      from prps
      into @data(lv_pepprojc_var)
        where pspnr eq @lv_pepelemt_var.
    if lv_pepprojc_var is not initial.
      "obter PEP destino em todos os PEPS do projecto
      select single pspnr
        from prps
        into @data(lv_pepdest_var)
          where psphi eq @lv_pepprojc_var
            and stort eq @lc_localizt_cst.
      if sy-subrc eq 0.
        "convsersão de formatos
        call function 'CONVERSION_EXIT_ABPSP_OUTPUT'
          exporting
            input  = lv_pepdest_var
          importing
            output = iv_pep_dest_var.
      endif.
    endif.
  endif.
  "flag a verdadeiro
  if ls_mobconfg_str-print_label eq abap_true.
    "verificar se é possivel alterar o pep
    if ls_mobconfg_str-edit_pep eq abap_true.
      if iv_pep_dest_var ne iv_pep_orig_var.
        "imprimir apenas se os peps forem diferentes
        data(lv_callprint_var) = abap_true.
      endif.
    else.
      "set da flag de activação
      lv_callprint_var = abap_true.
    endif.
  endif.

  if lv_callprint_var eq abap_true.
    "obter impressora
    select single printer
      from zabsf_mob_trfprt
      into @data(lv_printer_var)
        where werks eq @inputobj-werks
          and lgort eq @iv_depos_dest_var.
    if sy-subrc ne 0.
      "Nenhuma impressora configurada para &1 &2
      call method zabsf_mob_cl_log=>add_message
        exporting
          msgty      = 'E'
          msgno      = 004
          msgv1      = inputobj-werks
          msgv2      = iv_depos_dest_var
        changing
          return_tab = return_tab.
      "sair do processamento
      return.
    endif.
  endif.

  "movimento apenas 1 PEP ( destino ) - trocar depósito origem por destino
  if ls_mobconfg_str-one_pep eq abap_true.
    "trocar PEP destino por PEP Orgigem no preenchimento da BAPI
    iv_pep_orig_var = iv_pep_dest_var.
    "variável auxiliar
    data(lv_storage_var) = iv_depos_dest_var.
    "trocar depósito
    iv_depos_dest_var = iv_depos_orig_var.
    iv_depos_orig_var = lv_storage_var.
    "limpar destino origem
    clear iv_pep_dest_var.
  endif.

  "data de lançamento do documento
  ls_goodsmvt_header_str-pstng_date = sy-datum.
  "data do documento
  ls_goodsmvt_header_str-doc_date = sy-datum.
  "conversão de valores
  lv_material_var = |{ iv_material_var alpha = in }|.
  "criar linha com item a transferir
  append value #( material     = lv_material_var
                  plant        = iv_centro_dest_var
                  batch        = iv_lote_dest_var
             "     val_type     = iv_lote_dest_var
                  entry_qnt    = iv_quantidade_var
                  entry_uom    = iv_base_uom_var
                  base_uom     = iv_base_uom_var
                  val_wbs_elem = iv_pep_orig_var
                  move_type    = iv_movement_var
                  spec_stock   = iv_stock_esp_var
                  stge_loc     = iv_depos_orig_var
                  move_mat     = lv_material_var
                  wbs_elem     = iv_pep_dest_var
                  move_plant   = iv_centro_dest_var
                  move_stloc   = iv_depos_dest_var
                  move_batch   = iv_lote_dest_var ) to lt_goodsmvt_item_tab.
  "obter GM code
  ls_goodsmvt_code_str-gm_code = iv_gmcode_var.
  "verificar se os peps são iguais
  if iv_pep_orig_var ne iv_pep_dest_var.
    "executar bapi se forem pepes diferentes
    call function 'MB_SET_BAPI_FLAG'
      exporting
        action = '3'.
  endif.
  "executar bapi de criação de documento material
  call function 'BAPI_GOODSMVT_CREATE'
    exporting
      goodsmvt_header  = ls_goodsmvt_header_str
      goodsmvt_code    = ls_goodsmvt_code_str
    importing
      materialdocument = lv_document_var
      matdocumentyear  = lv_docuyear_var
    tables
      goodsmvt_item    = lt_goodsmvt_item_tab
      return           = return_tab.
  "verificar se documento foi criado
  if lv_document_var is not initial.
    "commit da base de dados
    call function 'BAPI_TRANSACTION_COMMIT'.
  else.
    "rollback da operação
    call function 'BAPI_TRANSACTION_ROLLBACK'.
    "sair do processamento
    return.
  endif.
  "verificar se é para imprimir etiqueta
  if lv_callprint_var eq abap_true.
    do 20 times.
      "obter dados do item do documento
      select single *
        from mseg
        into @data(ls_mseg_str)
          where mblnr eq @lv_document_var
            and mjahr eq @lv_docuyear_var
            and xauto eq @abap_false
            and charg ne @space.
      if sy-subrc ne 0.
        wait up to '0.2' seconds.
      else.
        "sair do DO
        exit.
      endif.
    enddo.
    "criar range de lotes
    append value #( sign   = 'I'
                    option = 'EQ'
                    low    = ls_mseg_str-charg ) to lr_lbacthes_rng.
    "despoltar a impressão de etiquetas
    zcl_absf_mob=>print_movements_label( exporting
                                            im_rc_trans_var  = abap_true
                                            im_docnumber_var = lv_document_var
                                            im_docyear_var   = lv_docuyear_var
                                            im_batch_rng     = lr_lbacthes_rng[]
                                            im_printer_var   = lv_printer_var
                                          changing
                                            ch_return_tab    = return_tab ).
  endif.
endfunction.
