function zabsf_pp_conf_time .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(AREAID) TYPE  ZABSF_PP_E_AREAID OPTIONAL
*"     VALUE(ARBPL) TYPE  ARBPL
*"     VALUE(AUFNR) TYPE  AUFNR
*"     VALUE(VORNR) TYPE  VORNR
*"     VALUE(DATE) TYPE  DATUM
*"     VALUE(TIME) TYPE  ATIME
*"     VALUE(OPRID) TYPE  ZABSF_PP_E_OPRID OPTIONAL
*"     VALUE(RUECK) TYPE  CO_RUECK
*"     VALUE(AUFPL) TYPE  CO_AUFPL
*"     VALUE(APLZL) TYPE  CO_APLZL
*"     VALUE(ACTV_ID) TYPE  ZABSF_PP_E_ACTV
*"     VALUE(STPRSNID) TYPE  ZABSF_PP_E_STPRSNID OPTIONAL
*"     VALUE(STPTY) TYPE  ZABSF_PP_E_STPTY OPTIONAL
*"     VALUE(ACTIONID) TYPE  ZABSF_PP_E_ACTION
*"     VALUE(SCHEDULE_ID) TYPE  ZABSF_PP_E_SCHEDULE_ID OPTIONAL
*"     VALUE(REGIME_ID) TYPE  ZABSF_PP_E_REGIME_ID OPTIONAL
*"     VALUE(COUNT_INI) TYPE  ZABSF_PP_E_COUNT_INI OPTIONAL
*"     VALUE(COUNT_FIN) TYPE  ZABSF_PP_E_COUNT_FIN OPTIONAL
*"     VALUE(BACKOFFICE) TYPE  FLAG OPTIONAL
*"     VALUE(SHIFTID) TYPE  ZABSF_PP_E_SHIFTID OPTIONAL
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"     VALUE(CONF) TYPE  FLAG OPTIONAL
*"     VALUE(KAPID) TYPE  KAPID OPTIONAL
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
*References
  data lref_sf_event_act type ref to zif_absf_pp_event_act.

*Variables
  data: l_gname  type seqg3-gname,
        l_garg   type seqg3-garg,
        l_guname type seqg3-guname,
        l_subrc  type sy-subrc,
        l_wait   type i.
  field-symbols: <ls_oper_str> type zabsf_pp014.

*Constants
  constants: c_wait type zabsf_pp_e_parid value 'WAIT'.

*Get time wait
  select single parva
    from zabsf_pp032
    into (@data(l_wait_param))
   where parid eq @c_wait.

  if l_wait_param is not initial.
    l_wait = l_wait_param.
  endif.

   time = time - l_wait_param.

*Get class of interface
  select single imp_clname, methodname
      from zabsf_pp003
      into (@data(l_class),@data(l_method) )
     where werks    eq @inputobj-werks
       and id_class eq '2'
       and endda    ge @refdt
       and begda    le @refdt.

  try .
      create object lref_sf_event_act type (l_class)
        exporting
          initial_refdt = refdt
          input_object  = inputobj.

    catch cx_sy_create_object_error.
*
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = 'E'
          msgno      = '019'
          msgv1      = l_class
        changing
          return_tab = return_tab.
      exit.
  endtry.


*Check blocks
  call method zabsf_pp_cl_wait_enqueue=>wait_for_dequeue_res
    exporting
      i_aufnr    = aufnr
      i_max_time = l_wait
    importing
      e_gname    = l_gname
      e_garg     = l_garg
      e_guname   = l_guname
      e_return   = l_subrc.

  if l_subrc ne 0.
    call method zabsf_pp_cl_log=>add_message
      exporting
        msgty      = 'E'
        msgno      = '093'
        msgv1      = l_guname
        msgv2      = l_gname
        msgv3      = l_guname
      changing
        return_tab = return_tab.
    exit.
  endif.

*Save confirmation time
  call method lref_sf_event_act->(l_method)
    exporting
      arbpl       = arbpl
      werks       = inputobj-werks
      aufnr       = aufnr
      vornr       = vornr
      date        = date
      time        = time
      oprid       = oprid
      rueck       = rueck
      aufpl       = aufpl
      aplzl       = aplzl
      actv_id     = actv_id
      stprsnid    = stprsnid
      schedule_id = schedule_id
      regime_id   = regime_id
      count_ini   = count_ini
      count_fin   = count_fin
      backoffice  = backoffice
      shiftid     = shiftid
      kapid       = kapid
    changing
      actionid    = actionid
      return_tab  = return_tab.

  delete adjacent duplicates from return_tab.

  loop at return_tab transporting no fields
    where type ca 'AEX'.
    "sair do processamento
    return.
  endloop.

  "actualizar tabela de utilizadores com postos de trabalho
  if kapid is not initial.
    select *
      from zabsf_pp014
      into table @data(lt_operas_tab)
        where aufnr eq @aufnr
          and vornr eq @vornr
          and arbpl eq @arbpl.
    if sy-subrc eq 0.

*      update zabsf_pp014 from table @( VALUE #(
*     for <ls_oper_str> in lt_operas_tab
*      ( value #(
*               base <ls_oper_str>
*               kapid =  kapid ) ) ) ).

      loop at lt_operas_tab assigning <ls_oper_str>.
        <ls_oper_str>-kapid = kapid.
      endloop.
    endif.
    update zabsf_pp014 from table @lt_operas_tab.
  endif.

  if actv_id eq 'END_PROD'
    and actionid eq 'CONC'.
    "verificar se é para fazer TECO - última operção
    select max( aplzl )
      into @data(lv_finalste_var)
      from afvc
        where aufpl eq @aufpl
          and loekz eq @abap_false.

    "contador da operação actual
    select single aplzl
      from afvc
      into @data(lv_operatio_var)
      where aufpl eq @aufpl
        and vornr eq @vornr
        and loekz eq @abap_false.
    if lv_finalste_var eq lv_operatio_var
      and conf eq abap_true.
      "activar flag de confirmação final
      data(lv_teco_var) = abap_true.
    endif.
    "alterar status da operação/ordem
    call function 'ZABSF_PP_ORDER_STATUS'
      exporting
        aufnr      = aufnr
        inputobj   = inputobj
        aufpl      = aufpl
        vornr      = vornr
        conf       = cond #( when conf eq abap_true
                             then abap_true
                             else abap_false )
        no_conf    = cond #( when conf eq abap_false
                            then abap_true
                            else abap_false )
        teco       = cond #( when lv_teco_var eq abap_true
                             then abap_true
                             else abap_false )
      importing
        return_tab = return_tab.
  endif.

  check actv_id = 'END_PARC'.
  delete from zabsf_pp069 where werks = inputobj-werks
                             and aufnr = aufnr
                             and vornr = vornr
                             and flag_shift = abap_true.
  if sy-subrc = 0.
    commit work and wait.
  endif.

  wait up to l_wait_param seconds.

endfunction.
