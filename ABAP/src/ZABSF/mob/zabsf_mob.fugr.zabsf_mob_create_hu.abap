function zabsf_mob_create_hu.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IT_ITEMPROPOSAL_TAB) TYPE  ZABSF_MOB_T_CHARG
*"     VALUE(IV_MAT_PACK_VAR) TYPE  MATNR
*"     VALUE(INPUTOBJ) TYPE  ZABSF_MOB_S_INPUTOBJECT
*"     VALUE(IV_LENGTH_VAR) TYPE  LAENG
*"     VALUE(IV_WIDTH_VAR) TYPE  BREIT
*"     VALUE(IV_HEIGHT_VAR) TYPE  HOEHE
*"  EXPORTING
*"     VALUE(EV_HU_NUMBER) TYPE  BAPIHUKEY-HU_EXID
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  "constantes locais
  constants: lc_centitmr_cst type msehi value 'CM'.
  "variáveis locais
  data: lt_itemsproposal  type standard table of bapihuitmproposal, "Tables Param
        ls_items_mob      like line of it_itemproposal_tab,
        ls_itemsproposal  like line of lt_itemsproposal,
        ls_headerproposal type bapihuhdrproposal,
        lv_hu             type bapihukey-hu_exid,
        lv_huheader       type bapihuheader,
        lv_mat_pack_var   type matnr,
        lt_retpack_tab    type bapiret2_t,
        lv_huitem         type bapihuitem,
        lv_pepelemnt_var  type ps_psp_pnr,
        lt_movitems_tab   type hum_data_move_to_t,
        lt_hum_venum      type hum_venum_t,
        lt_hum_extern     type hum_exidv_t,
        lt_humess         type huitem_messages_t,
        lv_storage_var    type lgort_d.

  if it_itemproposal_tab is initial.
    "sair do processamento
    return.
  endif.
  try.
      "obter armazém destino
      call method zcl_bc_fixed_values=>get_single_value
        exporting
          im_paramter_var = zcl_bc_fixed_values=>gc_hustorage_cst
          im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
          im_werksval_var = inputobj-werks
        importing
          ex_prmvalue_var = data(lv_conf_var).
      lv_storage_var = lv_conf_var.
    catch zcx_bc_exceptions into data(lo_exception_obj).
      "mensagem de erro
      call method zabsf_mob_cl_log=>add_message
        exporting
          msgid      = lo_exception_obj->msgid
          msgty      = lo_exception_obj->msgty
          msgno      = lo_exception_obj->msgno
          msgv1      = lo_exception_obj->msgv1
          msgv2      = lo_exception_obj->msgv2
          msgv3      = lo_exception_obj->msgv3
          msgv4      = lo_exception_obj->msgv4
        changing
          return_tab = return_tab.
      "sair do processamento
      return.
  endtry.
  "conversão alpha do material de embalagem
  lv_mat_pack_var = |{ iv_mat_pack_var alpha = in }|.
  "cabeçalho da HU
  ls_headerproposal = value #( pack_mat     = lv_mat_pack_var
                               hu_exid_type = 'C'
                               width        = iv_width_var
                               height       = iv_height_var
                               length       = iv_length_var
                               unit_dim     = lc_centitmr_cst
                               plant        = inputobj-werks
                               stge_loc     = it_itemproposal_tab[ 1 ]-lgort ) .
  "criar tabela de items da HU
  loop at it_itemproposal_tab into ls_items_mob.
    "conversão de formatos
    call function 'CONVERSION_EXIT_ABPSP_INPUT'
      exporting
        input     = ls_items_mob-wbs_element
      importing
        output    = lv_pepelemnt_var
      exceptions
        not_found = 1
        others    = 2.
    if sy-subrc <> 0.
    endif.

    append value #( hu_item_type    = '1'                                  " Type Item
                    batch           = ls_items_mob-charg                   " Lote
                    material        = |{ ls_items_mob-matnr alpha = in }|  " Material
                    plant           = ls_items_mob-werks                   " Plant
                    stge_loc        = ls_items_mob-lgort                   " Deposito
                    pack_qty        = ls_items_mob-clabs                   " Quantity
                    sp_stck_no      = lv_pepelemnt_var                     " Stock Especial - Elemento PEP
                    spec_stock      = 'Q'                                  " Stock Type
                    number_pack_mat = lv_mat_pack_var                      " Packing Material
                   ) to lt_itemsproposal.
    "limpar variávies
    clear: lv_pepelemnt_var.
  endloop.


  "Criar HU
  call function 'BAPI_HU_CREATE'
    exporting
      headerproposal = ls_headerproposal
    importing
      huheader       = lv_huheader
      hukey          = ev_hu_number
    tables
      itemsproposal  = lt_itemsproposal
      return         = return_tab.
  "Hu Creation Successful
  if ev_hu_number is initial.
    "rollback.
    call function 'BAPI_TRANSACTION_ROLLBACK'.
    "sair do processamento
    return.
  endif.
  "copia valor
  lv_hu = ev_hu_number.
  "commit da base de dados
  call function 'BAPI_TRANSACTION_COMMIT'
    exporting
      wait = 'X'.
  "refresh packing
  call function 'HU_PACKING_REFRESH'.
  "tabela de movimenots
  append value #( huwbevent = '0006'
                  lgort     = lv_storage_var ) to lt_movitems_tab.

*  append value #( venum = lv_huint ) to lt_hum_venum.
  append value #( exidv = lv_hu ) to lt_hum_extern.
  "transferir HU
  call function 'HU_CREATE_GOODS_MOVEMENT'
    exporting
      if_event       = '0006'
      if_commit      = abap_true
      it_move_to     = lt_movitems_tab
"     it_internal_id = lt_hum_venum
      it_external_id = lt_hum_extern
    importing
      et_messages    = lt_humess.

  loop at lt_humess into data(ls_humess)
    where msgty ca 'AEX'.
    "mensagens
    call method zabsf_mob_cl_log=>add_message
      exporting
        msgid      = ls_humess-msgid
        msgty      = ls_humess-msgty
        msgno      = ls_humess-msgno
        msgv1      = ls_humess-msgv1
        msgv2      = ls_humess-msgv2
        msgv3      = ls_humess-msgv3
        msgv4      = ls_humess-msgv4
      changing
        return_tab = return_tab.
    "rollback da operação
    call function 'BAPI_TRANSACTION_ROLLBACK'.
    "sair do processamento
    return.
  endloop.
*  "commit da operação de packing
  call function 'BAPI_TRANSACTION_COMMIT'
    exporting
      wait = 'X'.
endfunction.
