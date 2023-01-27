function zabsf_pp_set_oprid_and_restart .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(ARBPL) TYPE  ARBPL
*"     VALUE(AUFNR) TYPE  AUFNR
*"     VALUE(VORNR) TYPE  VORNR
*"     VALUE(OPERATOR_TAB) TYPE  ZABSF_PP_T_OPERADOR
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"     VALUE(TIPO) TYPE  I
*"     VALUE(AREAID) TYPE  ZABSF_PP_E_AREAID OPTIONAL
*"     VALUE(DATE) TYPE  DATUM
*"     VALUE(TIME) TYPE  ATIME
*"     VALUE(RUECK) TYPE  CO_RUECK
*"     VALUE(AUFPL) TYPE  CO_AUFPL
*"     VALUE(APLZL) TYPE  CO_APLZL
*"     VALUE(ACTV_ID) TYPE  ZABSF_PP_E_ACTV OPTIONAL
*"     VALUE(STPRSNID) TYPE  ZABSF_PP_E_STPRSNID OPTIONAL
*"     VALUE(STPTY) TYPE  ZABSF_PP_E_STPTY OPTIONAL
*"     VALUE(ACTIONID) TYPE  ZABSF_PP_E_ACTION OPTIONAL
*"     VALUE(SCHEDULE_ID) TYPE  ZABSF_PP_E_SCHEDULE_ID OPTIONAL
*"     VALUE(REGIME_ID) TYPE  ZABSF_PP_E_REGIME_ID OPTIONAL
*"     VALUE(COUNT_INI) TYPE  ZABSF_PP_E_COUNT_INI OPTIONAL
*"     VALUE(COUNT_FIN) TYPE  ZABSF_PP_E_COUNT_FIN OPTIONAL
*"     VALUE(BACKOFFICE) TYPE  FLAG OPTIONAL
*"     VALUE(SHIFTID) TYPE  ZABSF_PP_E_SHIFTID OPTIONAL
*"     VALUE(OPRID) TYPE  ZABSF_PP_E_OPRID OPTIONAL
*"     VALUE(KAPID) TYPE  KAPID OPTIONAL
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
*>> Modo de Funcionamento -
  "- Validações inciais
  "- Pára a ordem de produção ("END_PARC")
  "- adiciona ou remove o utilizador da ordem de produção
  "- Arranca a produção.

*References
  data: lref_sf_event_act type ref to zif_absf_pp_event_act,
        lref_sf_operator  type ref to zif_absf_pp_operator.

  data: ld_class  type recaimplclname,
        ld_method type seocmpname.

*Variables
  data: l_gname       type seqg3-gname,
        l_garg        type seqg3-garg,
        l_guname      type seqg3-guname,
        l_subrc       type sy-subrc,
        l_wait        type i,
        lf_error      type flag,
        lv_pernr      type pernr_d,
        lv_no_restart type flag,
        lv_error      type flag.

*Structures
  data: ls_return type bapireturn.

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

*Get class of interface
  select single imp_clname methodname
      from zabsf_pp003
      into (ld_class, ld_method)
     where werks eq inputobj-werks
       and id_class eq '3'
       and endda ge refdt
       and begda le refdt.

  try .
      create object lref_sf_operator type (ld_class)
        exporting
          initial_refdt = refdt
          input_object  = inputobj.

    catch cx_sy_create_object_error.
*    No data for object in customizing table
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = 'E'
          msgno      = '019'
          msgv1      = ld_class
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
*>> Validar se o utilizador existe
  read table operator_tab into data(ls_operator) index 1.

  move ls_operator-oprid to lv_pernr.
  translate ls_operator-oprid to upper case.
*  CALL FUNCTION 'BAPI_EMPLOYEE_CHECKEXISTENCE'
*    EXPORTING
*      number = lv_pernr
*    IMPORTING
*      return = ls_return.

  if ls_return is initial.
* Check if user is allready on the selected state.
    select single * from zabsf_pp014 into @data(ls_pp014)
        where arbpl  eq @arbpl
          and aufnr  eq @aufnr
          and vornr  eq @vornr
          and status eq @ls_operator-status
          and tipord eq 'N' "@tipord.
          and oprid  eq @ls_operator-oprid
          and kapid  eq @kapid.

    if sy-subrc eq 0.
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = 'E'
          msgno      = '113'
          msgv1      = ls_operator-oprid
        changing
          return_tab = return_tab.
      exit.
    endif.

*>>BMR INSERT 11.06.2018 - Check if user is working on another workcenter/order/operation.
*    CALL METHOD zabsf_pp_cl_operator=>check_if_operator_is_assgined
*      EXPORTING
*        arbpl        = arbpl
*        aufnr        = aufnr
*        vornr        = vornr
*        operator_tab = operator_tab
*      IMPORTING
*        e_error      = lv_error
*      CHANGING
*        return_tab   = return_tab.
*
*    CHECK lv_error IS INITIAL.
*<<BMR INSERT 11.06.2018 - Check if user is working on another workcenter/order/operation.


    "Get all active Operators in this order type
    select *
      from zabsf_pp014
      into table @data(lt_zabsf_pp014)
      where arbpl  eq @arbpl
        and aufnr  eq @aufnr
        and vornr  eq @vornr
        and status eq 'A'
        and tipord eq 'N'. "@tipord.
*    Read information from database, that we put above and the id of operator be the same that return in the Loop.
    read table lt_zabsf_pp014 into data(ls_zabsf_pp014) with key oprid = ls_operator-oprid.

    "sy-subrc is component of the system, if everything ok so return 0 in sy-subrc. Then see  if the status of the operator is equal to inactive
    if sy-subrc eq 0 and ls_operator-status eq 'I'."Inactive

*      Get number operators assigned to Production Order
      describe table lt_zabsf_pp014 lines data(l_nr_operator).

*      Get first operator assigned to Production Order
      select oprid up to 1 rows
        from zabsf_pp014
        into (@data(l_first_operator))
       where arbpl  eq @arbpl
         and aufnr  eq @aufnr
         and vornr  eq @vornr
         and status eq 'A'
         and tipord eq 'N' "@tipord
       order by udate ascending, utime ascending.
      endselect.

      if l_first_operator eq ls_operator-oprid and l_nr_operator gt 1.
*        Operd. principal não pode dissociar-se enquanto houver outros associados.
*        CALL METHOD zabsf_pp_cl_log=>add_message
*          EXPORTING
*            msgty      = 'E'
*            msgno      = '084'
*          CHANGING
*            return_tab = return_tab.
*        EXIT.
      endif.

      if l_nr_operator eq 1.
        "Ultimo operador da ordem. Não reenicia!
        lv_no_restart = abap_true.
*        CALL METHOD zabsf_pp_cl_log=>add_message
*          EXPORTING
*            msgty      = 'E'
*            msgno      = '112'
*          CHANGING
*            return_tab = return_tab.
*          EXIT.
      endif.

    endif.
  else.
*    Não foi encontrado o utilizador & no sistema
    call method zabsf_pp_cl_log=>add_message
      exporting
        msgty      = 'E'
        msgno      = '024'
        msgv1      = ls_operator-oprid
      changing
        return_tab = return_tab.
    return.
  endif.


*Save confirmation time
  actv_id = 'END_PARC'.
  actionid = 'NEXT'.
  "ZABSF_PP_CL_EVENT_ACT=>SET_CONF_EVENT_TIME
  call method lref_sf_event_act->(l_method)
    exporting
      arbpl                         = arbpl
      werks                         = inputobj-werks
      aufnr                         = aufnr
      vornr                         = vornr
      date                          = date
      time                          = time
      oprid                         = oprid
      rueck                         = rueck
      aufpl                         = aufpl
      aplzl                         = aplzl
      actv_id                       = actv_id
      stprsnid                      = stprsnid
      schedule_id                   = schedule_id
      regime_id                     = regime_id
      count_ini                     = count_ini
      count_fin                     = count_fin
      backoffice                    = backoffice
      shiftid                       = shiftid
      no_clear_operators_from_order = abap_true "dont remove operators from order on partial close.
      kapid                         = kapid
    changing
      actionid                      = actionid
      return_tab                    = return_tab.

  delete adjacent duplicates from return_tab.

  loop at return_tab transporting no fields
    where type ca 'AEX'.

    lf_error = abap_true.
    exit.
  endloop.

  check lf_error eq abap_false.

* Clear Batchs.
  delete from zabsf_pp069 where werks = inputobj-werks
                             and aufnr = aufnr
                             and vornr = vornr
                             and flag_shift = abap_true.
  if sy-subrc = 0.
    commit work.
  endif.
* Remove / Add operator
  " ZABSF_PP_CL_OPERATOR->SET_OPERATOR
  call method lref_sf_operator->(ld_method)
    exporting
      arbpl        = arbpl
      aufnr        = aufnr
      vornr        = vornr
      operator_tab = operator_tab
      kapid        = kapid
    changing
      return_tab   = return_tab.

  delete adjacent duplicates from return_tab.

* Look for errors.
  loop at return_tab transporting no fields
  where type ca 'AEX'.

    lf_error = abap_true.
    exit.
  endloop.

  check lf_error eq abap_false and lv_no_restart eq abap_false.

  "Re-Start production
  actv_id = 'INIT_PRO'.
  actionid = 'PROD'.
  "ZABSF_PP_CL_EVENT_ACT=>SET_CONF_EVENT_TIME
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

endfunction.
