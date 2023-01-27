function zabsf_mob_create_reception.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(INPUTOBJ) TYPE  ZABSF_MOB_S_INPUTOBJECT
*"     VALUE(IS_PO_ITEM) TYPE  ZABSF_MOB_S_ITEM_DETAIL
*"     VALUE(IV_DELIVERY_NOTE) TYPE  LFSNR1 OPTIONAL
*"     VALUE(IV_DOC_DATE) TYPE  CHAR8 OPTIONAL
*"     VALUE(IV_GM_DATE) TYPE  CHAR8 OPTIONAL
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  "constantes
  constants: lc_movecode_cst type bapi2017_gm_code value '01',
             lc_mvmtrecp_cst type bwart value '101',
             lc_mvmtranf_cst type bwart value '311',
             lc_localizt_cst type ps_stort value 'BYS0000001'.
  "variáveis locais
  data: ls_headerst_str   type bapi2017_gm_head_01,
        lv_document_var   type mblnr,
        lv_docmyear_var   type mjahr,
        lt_docitems_tab   type table of bapi2017_gm_item_create,
        lv_wbselemt_var   type ps_posid,
        lv_wbsdestn_var   type ps_posid,
        lv_charseqn_var   type atnam,
        lv_orginalb_var   type atnam,
        lr_sequencopy_rng type range of klasse_d.

  data:lt_allocchar       type table of bapi1003_alloc_values_char,
       ls_allocchar       type bapi1003_alloc_values_char,
       lt_tbobject_tab    type table of  bapi1003_object_keys,
       lt_aloclist_tab    type table of  bapi1003_alloc_list,
       lt_tbreturn_tab    type table of bapiret2,
       lv_objeckey_var    type objnum,
       lt_allocvaluesnum  type table of  bapi1003_alloc_values_num,
       lt_allocvaluescurr type table of  bapi1003_alloc_values_curr,
       lr_lbacthes_rng    type range of charg_d.

  "verificar se material é gerido a lote e se é para fazer split
  select single xchpf, kzwsm "08.09.2020 _ flag indicadora de splitagem de lote na recepção
    from mara
    into (@data(lv_batchmgm_var), @data(lv_splitctr_var) )
      where matnr eq @is_po_item-matnr.

  "obter impressora
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
        msgv2      =  is_po_item-lgort
      changing
        return_tab = return_tab.
    "sair do processamento
    return.
  endif.

  "activar flag global - "from shopfloor" - usado em EXITS/Badis
  gv_fromshop_var = abap_true.

  "verificar se é entrada de subcontratação
  if is_po_item-subitems is not initial.
    call function 'ZABSF_MOB_SUBCONTRACT_RECPTION'
      exporting
        inputobj         = inputobj
        is_po_item       = is_po_item
        iv_delivery_note = iv_delivery_note
      importing
        return_tab       = return_tab.
    "sair do processamento
    return.
  endif.

  if lv_batchmgm_var eq abap_true and is_po_item-charg is not initial
    and is_po_item-vbeln is initial and lv_splitctr_var eq 'B'.
    "obter configuração
    try.
        "sequenciador
        call method zcl_bc_fixed_values=>get_single_value
          exporting
            im_paramter_var = zcl_bc_fixed_values=>gc_charseq_cst
            im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
          importing
            ex_prmvalue_var = data(lv_charseq_var).
        lv_charseqn_var = lv_charseq_var.

        "lote original
        call method zcl_bc_fixed_values=>get_single_value
          exporting
            im_paramter_var = zcl_bc_fixed_values=>gc_charorgbatch_cst
            im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
          importing
            ex_prmvalue_var = data(lv_charname_var).
        lv_orginalb_var = lv_charname_var.
        "classes para inserir na tabela o nº do sequenciador
        call method zcl_bc_fixed_values=>get_ranges_value
          exporting
            im_paramter_var = zcl_bc_fixed_values=>gc_updatesequence_cst
            im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
          importing
            ex_valrange_tab = lr_sequencopy_rng.

      catch zcx_bc_exceptions into data(lo_bcexceptions_obj).
        "falta configuração
        call method zabsf_mob_cl_log=>add_message
          exporting
            msgty      = lo_bcexceptions_obj->msgty
            msgno      = lo_bcexceptions_obj->msgno
            msgid      = lo_bcexceptions_obj->msgid
            msgv1      = lo_bcexceptions_obj->msgv1
            msgv2      = lo_bcexceptions_obj->msgv2
            msgv3      = lo_bcexceptions_obj->msgv3
            msgv4      = lo_bcexceptions_obj->msgv4
          changing
            return_tab = return_tab.
        "sair do processamento
        return.
    endtry.
    "validar valor das caracteristicas
    loop at is_po_item-characteristics into data(ls_inputchr_str).
      "verificar valor da caracteristica
      zabsf_pp_cl_tracking=>convert_char_value_to_internal( exporting
                                                              im_atnam_var   = ls_inputchr_str-atnam
                                                              im_atwrt_var   = ls_inputchr_str-atwrt
                                                            importing
                                                              et_return_tab  = data(lt_return_tab) ).
      "verificar se ocorreram erros
      if lt_return_tab is not initial.
        append lines of lt_return_tab to return_tab.
        "sair do processamento
        return.
      endif.
    endloop.
    "validações iniciais
    zabsf_pp_cl_tracking=>calculate_number_of_batches( exporting
                                                         im_quantity_var = is_po_item-menge
                                                         im_qttyunit_var = is_po_item-meins
                                                         im_bacthnum_var = is_po_item-charg
                                                         im_material_var = is_po_item-matnr
                                                       importing
                                                         et_return_tab   = lt_return_tab
                                                         ex_number_batches_var = data(lv_counter_var) ).
    "verificar se determinou nº de lotes a criar
    if lv_counter_var is initial.
      append lines of lt_return_tab to return_tab.
      "sair do processamento
      return.
    endif.
    "obter nº dos novos lotes
    zabsf_pp_cl_tracking=>get_next_batch_numbers( exporting
                                                    im_quantity_var  = conv #( lv_counter_var )
                                                  importing
                                                    ex_batchnum_tab  = data(lt_newbatchs_tab)
                                                    ex_errorflag_var = data(lv_errorflg_var)
                                                    et_return_tab    = lt_return_tab ).
    if lv_errorflg_var eq abap_true.
      append lines of lt_return_tab to return_tab.
      "sair do processamento
      return.
    endif.
    "criar chave do objecto
    append value #( key_field = 'MATNR'
                    value_int = is_po_item-matnr ) to lt_tbobject_tab.
    "criar chave do objecto
    append value #( key_field = 'CHARG'
                    value_int = is_po_item-charg ) to lt_tbobject_tab.
    "verificar se é para inserir sequenciador na tabela
    call function 'BAPI_OBJCL_CONCATENATEKEY'
      exporting
        objecttable    = 'MCH1'
      importing
        objectkey_conc = lv_objeckey_var
      tables
        objectkeytable = lt_tbobject_tab
        return         = lt_tbreturn_tab.
*  "obter classe 23 do objecto
    call function 'BAPI_OBJCL_GETCLASSES'
      exporting
        objectkey_imp   = lv_objeckey_var
        objecttable_imp = 'MCH1'
        classtype_imp   = '023'
        read_valuations = abap_true
      tables
        alloclist       = lt_aloclist_tab
        return          = lt_tbreturn_tab.
    "ler primeira linha da tabela
    read table lt_aloclist_tab into data(ls_aloclist_str) index 1.
    if ls_aloclist_str-classnum in lr_sequencopy_rng.
      "activar flag inserção de sequenciador
      data(lv_insertseq_var) = abap_true.
    endif.
    clear: lv_objeckey_var.
    refresh: lt_aloclist_tab, lt_tbreturn_tab, lt_tbobject_tab, lt_tbreturn_tab.
  endif.

  "data de lançamento do documento
  ls_headerst_str-pstng_date = iv_gm_date.
  "data do documento
  ls_headerst_str-doc_date = iv_doc_date.
  "nota da guia
  ls_headerst_str-ref_doc_no = iv_delivery_note.
  "converter para maiúsculas
  translate ls_headerst_str-ref_doc_no to upper case.
  "adicionar item à tabela de items
  append value #( move_type   = lc_mvmtrecp_cst
                  material    = is_po_item-matnr
                  plant       = is_po_item-werks
                  stge_loc    = is_po_item-lgort
                  entry_qnt   = is_po_item-menge
                  entry_uom   = is_po_item-meins
                  batch       = is_po_item-charg
                  po_number   = is_po_item-ebeln
                  po_item     = is_po_item-ebelp
                  val_type    = cond #( when is_po_item-vbeln is not initial
                                        then is_po_item-charg )
                  deliv_numb  = cond #( when is_po_item-vbeln is not initial
                                        then is_po_item-vbeln )
                  deliv_item  = cond #( when is_po_item-posnr is not initial
                                        then is_po_item-posnr )
                  quantity    = cond #( when is_po_item-vbeln is not initial
                                        then is_po_item-menge )
                  base_uom    = cond #( when is_po_item-vbeln is not initial
                                        then is_po_item-meins )
                  mvt_ind     = 'B' ) to lt_docitems_tab.
  "criar documento material para 101
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
    "gravar documento
    ls_headerst_str-header_txt = |{ lv_document_var }{ lv_docmyear_var }|.
    "commit da operação
    call function 'BAPI_TRANSACTION_COMMIT'
      exporting
        wait = abap_true.
  endif.

  "split de lote? imprime etiqueta 101 caso n seja
  if lv_splitctr_var ne 'B'.
    "imprimir etiqueta do 101
    append value #( sign   = 'I'
                    option = 'EQ'
                    low    = is_po_item-charg ) to lr_lbacthes_rng.
    "despoltar a impressão do 101
    zcl_absf_mob=>print_movements_label( exporting
                                            im_rc_trans_var  = abap_true
                                            im_docnumber_var = lv_document_var
                                            im_docyear_var   = lv_docmyear_var
                                            im_batch_rng     = lr_lbacthes_rng[]
                                            im_printer_var   = lv_printer_var
                                          changing
                                            ch_return_tab    = return_tab ).
    "sair do processamento
    return.
  endif.
  "verificar se 101 foi criado com referência a PEP
  do 25 times.
    "obter dados do item do documento
    select single *
      from mseg
      into @data(ls_mseg_str)
        where mblnr eq @lv_document_var
          and mjahr eq @lv_docmyear_var.
    if sy-subrc ne 0.
      wait up to '0.2' seconds.
    else.
      "sair do DO
      exit.
    endif.
  enddo.

  "limpar variáveis
  clear: lv_document_var, lv_docmyear_var.
  refresh lt_docitems_tab.

  "criar items do documento de transferência
  loop at lt_newbatchs_tab assigning field-symbol(<fs_newbatchs_str>).
    "obter pep do item
    select single ps_psp_pnr
      from ekkn
      into @data(lv_pepelemt_var)
        where ebeln eq @is_po_item-ebeln
          and ebelp eq @is_po_item-ebelp.
    "convsersão de formatos
    call function 'CONVERSION_EXIT_ABPSP_OUTPUT'
      exporting
        input  = lv_pepelemt_var
      importing
        output = lv_wbselemt_var.
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
            output = lv_wbsdestn_var.
        "verificar se os PEPs sao diferentes
        if lv_wbsdestn_var ne lv_wbselemt_var.
          "activar flag de mudança de pep
          data(lv_switchpep_var) = abap_true.
        endif.
      endif.
    endif.

    "item de transferência
    append value #( material      = is_po_item-matnr
                    plant         = is_po_item-werks
                    batch         = is_po_item-charg
                    val_type      = is_po_item-charg
                    entry_qnt     = '1'
                    entry_uom     = 'UN'
                    val_wbs_elem  = lv_wbselemt_var
                    move_type     = lc_mvmtranf_cst
                    spec_stock    = ls_mseg_str-sobkz "Tipo de stock especial do 101
                    stge_loc      = is_po_item-lgort
                    move_mat      = is_po_item-matnr
                    wbs_elem      = cond #( when lv_wbsdestn_var is not initial
                                            then lv_wbsdestn_var
                                            else lv_wbselemt_var )
                    move_plant    = is_po_item-werks
                    move_stloc    = is_po_item-lgort
                    move_val_type = is_po_item-charg
                    move_batch    = <fs_newbatchs_str>-charg
                    item_text     = <fs_newbatchs_str>-sequenciador ) to lt_docitems_tab.
    "limpar variáveis
    clear: lv_pepelemt_var, lv_wbselemt_var, lv_pepprojc_var, lv_wbsdestn_var, lv_pepdest_var.
  endloop.

  "verificar se os peps são iguais
  if lv_switchpep_var eq abap_true.
    "executar bapi se forem pepes diferentes
    call function 'MB_SET_BAPI_FLAG'
      exporting
        action = '3'.
  endif.
  "verificar se existem items para transferir
  if lt_docitems_tab is initial.
    "sair do processamento
    return.
  endif.

  "criar documento material
  call function 'BAPI_GOODSMVT_CREATE'
    exporting
      goodsmvt_header  = ls_headerst_str
      goodsmvt_code    = '04'
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
    if lv_insertseq_var eq abap_true.
      "actualizar tabela de sequenciadores
      zabsf_pp_cl_tracking=>update_sequence_table( exporting
                                                     im_document_var = lv_document_var
                                                     im_newbatch_tab = lt_newbatchs_tab
                                                     im_opridval_var = inputobj-oprid ).
    endif.
    "commit da operação
    call function 'BAPI_TRANSACTION_COMMIT'
      exporting
        wait = abap_true.
  endif.
  "timer até 5 segundos de espera para criação do 311
  do 25 times.
    "obter dados do item do documento
    select single *
      from mseg
      into @data(ls_mseg311_str)
        where mblnr eq @lv_document_var
          and mjahr eq @lv_docmyear_var.
    if sy-subrc ne 0.
      wait up to '0.2' seconds.
    else.
      "sair do DO
      exit.
    endif.
  enddo.

  "caracterização do lote
  "percorrer todos os novos lotes
  loop at lt_newbatchs_tab assigning <fs_newbatchs_str>.
    "criar chave do objecto
    append value #( key_field = 'MATNR'
                    value_int = is_po_item-matnr ) to lt_tbobject_tab.
    "criar chave do objecto
    append value #( key_field = 'CHARG'
                    value_int = <fs_newbatchs_str>-charg ) to lt_tbobject_tab.
    "obter chave do objecto
    call function 'BAPI_OBJCL_CONCATENATEKEY'
      exporting
        objecttable    = 'MCH1'
      importing
        objectkey_conc = lv_objeckey_var
      tables
        objectkeytable = lt_tbobject_tab
        return         = lt_tbreturn_tab.
*  "obter classe 23 do objecto
    call function 'BAPI_OBJCL_GETCLASSES'
      exporting
        objectkey_imp   = lv_objeckey_var
        objecttable_imp = 'MCH1'
        classtype_imp   = '023'
        read_valuations = abap_true
      tables
        alloclist       = lt_aloclist_tab
        return          = lt_tbreturn_tab.
    if lt_aloclist_tab is initial.
      "sair do processamento
      return.
    endif.
    "ler primeira linha da tabela
    read table lt_aloclist_tab into ls_aloclist_str index 1.
    "ler caracteristicas
    call function 'BAPI_OBJCL_GETDETAIL'
      exporting
        objectkey        = lv_objeckey_var
        objecttable      = 'MCH1'
        classnum         = ls_aloclist_str-classnum
        classtype        = '023'
        unvaluated_chars = abap_true
      tables
        allocvaluesnum   = lt_allocvaluesnum
        allocvalueschar  = lt_allocchar
        allocvaluescurr  = lt_allocvaluescurr
        return           = lt_tbreturn_tab.

    loop at is_po_item-characteristics into data(ls_charcteristic_str).
      "caracteristicas alfanuméricas
      read table lt_allocchar assigning field-symbol(<fs_allochar>) with key charact = ls_charcteristic_str-atnam.
      if <fs_allochar> is assigned.
        <fs_allochar>-value_char = ls_charcteristic_str-atwrt.
      endif.
      "caracteristicas númericas
      read table lt_allocvaluesnum assigning field-symbol(<fs_allocharnum>) with key charact = ls_charcteristic_str-atnam.
      if <fs_allocharnum> is assigned.
        "converter para formato interno
        zabsf_pp_cl_tracking=>convert_char_value_to_internal( exporting
                                                                im_atnam_var   = <fs_allochar>-charact
                                                                im_atwrt_var   = ls_charcteristic_str-atwrt
                                                              importing
                                                                ex_valfrom_var = <fs_allocharnum>-value_from
                                                                ex_valueto_var = <fs_allocharnum>-value_to
                                                                ex_valuerl_var = <fs_allocharnum>-value_relation ).
      endif.
    endloop.
    "adcionar caracteritica sequenciador
    read table lt_allocchar assigning <fs_allochar> with key charact = lv_charseqn_var.
    if <fs_allochar> is assigned.
      <fs_allochar>-value_char = <fs_newbatchs_str>-sequenciador.
    endif.
    "adcionar caracteritica lote original
    read table lt_allocchar assigning <fs_allochar> with key charact = lv_orginalb_var.
    if <fs_allochar> is assigned.
      <fs_allochar>-value_char = is_po_item-charg.
    endif.
    "actualizar caracteristicas do lote
    call function 'BAPI_OBJCL_CHANGE'
      exporting
        objectkey          = lv_objeckey_var
        objecttable        = 'MCH1'
        classnum           = ls_aloclist_str-classnum
        classtype          = '023'
      tables
        return             = lt_tbreturn_tab
        allocvaluesnumnew  = lt_allocvaluesnum
        allocvaluescharnew = lt_allocchar
        allocvaluescurrnew = lt_allocvaluescurr.
    "commit da operação
    call function 'BAPI_TRANSACTION_COMMIT'.
    "mensagens da bapi
    append lines of lt_tbreturn_tab to return_tab.
    "limpar variáveis
    clear: lv_objeckey_var, ls_aloclist_str.
    refresh:  lt_tbobject_tab, lt_allocvaluescurr, lt_allocchar, lt_tbreturn_tab,
              lt_allocvaluesnum.
  endloop.
  "criar range de lotes a imprimir
  loop at lt_newbatchs_tab assigning <fs_newbatchs_str>.
    "adicionar lote à tabela
    append value #( sign   = 'I'
                    option = 'EQ'
                    low    = <fs_newbatchs_str>-charg ) to lr_lbacthes_rng.
  endloop.
  "imprimir etiqueta do 311
  zcl_absf_mob=>print_movements_label( exporting
                                          im_rc_trans_var  = abap_true
                                          im_docnumber_var = lv_document_var
                                          im_docyear_var   = lv_docmyear_var
                                          im_batch_rng     = lr_lbacthes_rng[]
                                          im_printer_var   = lv_printer_var
                                        changing
                                          ch_return_tab    = return_tab ).
endfunction.
