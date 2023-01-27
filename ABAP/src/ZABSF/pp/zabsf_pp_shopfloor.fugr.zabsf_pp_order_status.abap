function zabsf_pp_order_status .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(AUFNR) TYPE  AUFNR
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"     VALUE(TECO) TYPE  FLAG OPTIONAL
*"     VALUE(CONF) TYPE  FLAG OPTIONAL
*"     VALUE(NO_CONF) TYPE  FLAG OPTIONAL
*"     VALUE(AUFPL) TYPE  CO_AUFPL OPTIONAL
*"     VALUE(VORNR) TYPE  VORNR OPTIONAL
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  "varáveis locais
  data: lv_prodordr_var  type aufnr,
        lt_prodordr_tab  type table of bapi_order_key,
        ls_return_str    type bapiret2,
        lt_return_tab    type table of bapi_order_return,
        lt_bdcdata_tab   type table of bdcdata,
        lt_messages_tab  type table of bdcmsgcoll,
        lv_oldstatus_var type j_status,
        lv_aufnr         type aufnr.
  "conversão de formatos
  lv_prodordr_var = |{ aufnr alpha = in }|.
  append value #( order_number = lv_prodordr_var ) to lt_prodordr_tab.
  "obter objecto id da ordem
  select single objnr
    from aufk
    into @data(lv_objnr)
      where aufnr eq @lv_prodordr_var.
  "obter os status da ordem
  select *
    from jest
    into table @data(lt_ordersta_tab)
     where objnr eq @lv_objnr
       and inact eq @abap_false.

  "obter objnr da operação
  select single *
    from afvc
    into @data(ls_operation_str)
      where aufpl eq @aufpl
        and vornr eq @vornr
        and loekz eq @abap_false.
  if sy-subrc eq 0.
    "obter status da operação
    select *
      from jest
      into table @data(lt_operstat_tab)
       where objnr eq @ls_operation_str-objnr
         and inact eq @abap_false.
  endif.

  "verificar se o status já está activo
  if line_exists( lt_ordersta_tab[ stat = 'I0045' ] ).

    call function 'CONVERSION_EXIT_AUFNR_INPUT'
      exporting
        input  = aufnr
      importing
        output = lv_aufnr
      .  "  CONVERSION_EXIT_AUFNR_INPUT

    if sy-subrc eq 0.

      call method zabsf_pp_cl_log=>add_message
        exporting
          msgno      = '139'
          msgty      = 'E'
*         msgv1      = conv #( aufnr )
          msgv1      = lv_aufnr
        changing
          return_tab = return_tab.
      return.
    endif.
  endif.

  "verificar operação se não for para encerrar
  if teco is not initial.
    if conf eq abap_true.
      "Conforme
      if line_exists( lt_operstat_tab[ stat = 'E0002' ] ).
        call method zabsf_pp_cl_log=>add_message
          exporting
            msgno      = '151'
            msgty      = 'E'
          changing
            return_tab = return_tab.
        return.
      endif.
    endif.
    if no_conf eq abap_true.
      "Não conforme
      if line_exists( lt_operstat_tab[ stat = 'E0001' ] ).
        call method zabsf_pp_cl_log=>add_message
          exporting
            msgno      = '151'
            msgty      = 'E'
          changing
            return_tab = return_tab.
        return.
      endif.
    endif.
  endif.

  "ZBYSTEEL E0001 PT  NC  Não conforme
  "ZBYSTEEL E0002 PT  CONF  Conforme

  "status actual
  if no_conf eq abap_true.
    if line_exists( lt_operstat_tab[ stat = 'E0002' ] ).
      lv_oldstatus_var = 'E0002'.
    endif.
  endif.

  if conf eq abap_true.
    if line_exists( lt_operstat_tab[ stat = 'E0001' ] ).
      lv_oldstatus_var = 'E0001'.
    endif.
  endif.

  "alterar status da operação
  call function 'ZABSF_PP_SET_USER_STATUS_VORNR'
    exporting
      objnr      = ls_operation_str-objnr
      old_status = cond #( when lv_oldstatus_var is not initial
                           then lv_oldstatus_var )
      new_status = cond #( when conf eq abap_true
                           then 'E0002'
                           when no_conf eq abap_true
                           then 'E0001' )
    importing
      return_tab = return_tab
      return     = ls_return_str.

  append ls_return_str to return_tab.
*  if lock eq abap_true.
  "criar batch input
*    call method zcl_sf_bdc=>bdc_dynpro
*      exporting
*     iv_program_var = 'SAPLCOKO1'
*     iv_dynpro_var  = '0110'
*      changing
*     ch_bdcdata_tab = lt_bdcdata_tab.
*
*    call method zcl_sf_bdc=>bdc_field
*      exporting
*     iv_fnam_var    = 'BDC_CURSOR'
*     iv_fval_var    = 'CAUFVD-AUFNR'
*      changing
*     ch_bdcdata_tab = lt_bdcdata_tab.
*
*    call method zcl_sf_bdc=>bdc_field
*      exporting
*     iv_fnam_var    = 'BDC_OKCODE'
*     iv_fval_var    = '/00'
*      changing
*     ch_bdcdata_tab = lt_bdcdata_tab.
*
*    call method zcl_sf_bdc=>bdc_field
*      exporting
*     iv_fnam_var    = 'CAUFVD-AUFNR'
*     iv_fval_var    = conv #( aufnr )
*      changing
*     ch_bdcdata_tab = lt_bdcdata_tab.
*
*    call method zcl_sf_bdc=>bdc_field
*      exporting
*     iv_fnam_var    = 'R62CLORD-FLG_OVIEW'
*     iv_fval_var    = 'X'
*      changing
*     ch_bdcdata_tab = lt_bdcdata_tab.
*
*    call method zcl_sf_bdc=>bdc_dynpro
*      exporting
*     iv_program_var = 'SAPLCOKO1'
*     iv_dynpro_var  = '0115'
*      changing
*     ch_bdcdata_tab = lt_bdcdata_tab.
*
*    call method zcl_sf_bdc=>bdc_field
*      exporting
*     iv_fnam_var    = 'BDC_OKCODE'
*     iv_fval_var    = '=SPER'
*      changing
*     ch_bdcdata_tab = lt_bdcdata_tab.
*
*    call method zcl_sf_bdc=>bdc_field
*      exporting
*     iv_fnam_var    = 'BDC_SUBSCR'
*     iv_fval_var    = 'SAPLCOKO1                               0120SUBSCR_0115'
*      changing
*     ch_bdcdata_tab = lt_bdcdata_tab.
*
*    call method zcl_sf_bdc=>bdc_dynpro
*      exporting
*     iv_program_var = 'SAPLCOKO1'
*     iv_dynpro_var  = '0115'
*      changing
*     ch_bdcdata_tab = lt_bdcdata_tab.
*
*    call method zcl_sf_bdc=>bdc_field
*      exporting
*     iv_fnam_var    = 'BDC_OKCODE'
*     iv_fval_var    = '=BU'
*      changing
*     ch_bdcdata_tab = lt_bdcdata_tab.
*
*    call method zcl_sf_bdc=>bdc_field
*      exporting
*     iv_fnam_var    = 'BDC_SUBSCR'
*     iv_fval_var    = 'SAPLCOKO1                               0120SUBSCR_0115'
*      changing
*     ch_bdcdata_tab = lt_bdcdata_tab.
*
*    "chamar transacção
*    call transaction 'CO02' using lt_bdcdata_tab
*                     mode   'N'
*                     update 'S'
*                     messages into lt_messages_tab.
*
*    loop at lt_messages_tab into data(ls_message_str)
*      where msgtyp ca 'AEX'.
*      call method zabsf_pp_cl_log=>add_message
*        exporting
*     msgid      = ls_message_str-msgid
*     msgty      = ls_message_str-msgtyp
*     msgno      = conv #( ls_message_str-msgnr )
*     msgv1      = ls_message_str-msgv1
*     msgv2      = ls_message_str-msgv2
*     msgv3      = ls_message_str-msgv3
*     msgv4      = ls_message_str-msgv4
*        changing
*     return_tab = return_tab.
*    endloop.
*  endif.
  if teco eq abap_true.
    "I0045
    call function 'BAPI_PRODORD_COMPLETE_TECH'
      importing
        return        = ls_return_str
      tables
        orders        = lt_prodordr_tab
        detail_return = lt_return_tab.

    loop at lt_return_tab transporting no fields
      where type ca 'AEX'.
      "flag de erro
      data(lv_errorflag_var) = abap_true.
      exit.
    endloop.
    "mensagens de erro
    return_tab = corresponding #( lt_return_tab ).

    if lv_errorflag_var eq abap_true.
      "rollback da operação
      call function 'BAPI_TRANSACTION_ROLLBACK'.
    else.
      "commit na base de dados
      call function 'BAPI_TRANSACTION_COMMIT'.
    endif.
  endif.

  "obter centro de trabalho a partir do ID
  select single arbpl
    from crhd
    into @data(lv_arbpl_var)
      where objid eq @ls_operation_str-arbid
        and objty eq 'A'. "centro de trabalho

  "eliminar ordem da tabela de sequência de ordens
  delete from zabsf_pp084
    where werks eq inputobj-werks
      and aufnr eq aufnr
      and vornr eq vornr
      and arbpl eq lv_arbpl_var.
  "commit base de dados
  commit work.
endfunction.
