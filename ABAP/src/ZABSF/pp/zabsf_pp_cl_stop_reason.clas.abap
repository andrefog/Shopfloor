class ZABSF_PP_CL_STOP_REASON definition
  public
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !INITIAL_REFDT type VVDATUM
      !INPUT_OBJECT type ZABSF_PP_S_INPUTOBJECT .
  methods SET_REFDT
    importing
      !NEW_REFDT type VVDATUM optional .
  methods GET_STOP_REASON_OPR
    importing
      !ARBPL type ARBPL
      !WERKS type WERKS_D
    changing
      !STOP_REASON_TAB type ZABSF_PP_T_STOP_REASON
      !RETURN_TAB type BAPIRET2_T .
  methods GET_STOP_REASON_WRK
    importing
      !ARBPL type ARBPL
      !WERKS type WERKS_D
    changing
      !STOP_REASON_TAB type ZABSF_PP_T_STOP_REASON
      !RETURN_TAB type BAPIRET2_T .
  methods SET_STOP_REASON_OPR
    importing
      !ARBPL type ARBPL
      !AUFNR type AUFNR
      !VORNR type VORNR
      !DATESR type ZABSF_PP_E_DATE
      !TIME type PR_TIME
      !OPRID type ZABSF_PP_E_OPRID
      !STPTY type ZABSF_PP_E_STPTY
      !STPRSNID type ZABSF_PP_E_STPRSNID
    changing
      !RETURN_TAB type BAPIRET2_T .
  methods SET_STOP_REASON_WRK
    importing
      !ARBPL type ARBPL
      !WERKS type WERKS_D
      !DATESR type ZABSF_PP_E_DATE
      !TIME type ATIME
      !STPRSNID type ZABSF_PP_E_STPRSNID
      !COUNT_FIN_TAB type ZABSF_PP_T_COUNTERS optional
    changing
      !ACTIONID type ZABSF_PP_E_ACTION optional
      !RETURN_TAB type BAPIRET2_T .
protected section.
private section.

  data REFDT type VVDATUM .
  data INPUTOBJ type ZABSF_PP_S_INPUTOBJECT .
  constants STATUS type J_STATUS value '0003' ##NO_TEXT.
  constants STSMA type J_STSMA value 'ZCT02' ##NO_TEXT.
  constants C_MIN type ZABSF_PP_E_STOPUNIT value 'MIN' ##NO_TEXT.
ENDCLASS.



CLASS ZABSF_PP_CL_STOP_REASON IMPLEMENTATION.


METHOD CONSTRUCTOR.
*Ref. Date
  refdt    = initial_refdt.

*App input data
  inputobj = input_object.
ENDMETHOD.


METHOD get_stop_reason_opr.
*Range
  DATA r_arbpl TYPE RANGE OF arbpl.

*Structure for range
  DATA ls_r_arbpl LIKE LINE OF r_arbpl.

*Variables
  DATA: l_langu TYPE spras.

*Set language local for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

*Create ranges of workcenter
  CLEAR ls_r_arbpl.
  ls_r_arbpl-option = 'EQ'.
  ls_r_arbpl-sign = 'I'.
  ls_r_arbpl-low = space.

  APPEND ls_r_arbpl TO r_arbpl.

  CLEAR ls_r_arbpl.
  ls_r_arbpl-option = 'EQ'.
  ls_r_arbpl-sign = 'I'.
  ls_r_arbpl-low = arbpl.

  APPEND ls_r_arbpl TO r_arbpl.

* Get stop reason
  SELECT *
    FROM zabsf_pp015_t
    INTO CORRESPONDING FIELDS OF TABLE stop_reason_tab
    WHERE areaid EQ inputobj-areaid
      AND arbpl  IN r_arbpl
      AND werks  EQ werks
      AND spras  EQ sy-langu.

  IF stop_reason_tab[] IS INITIAL.
    CLEAR l_langu.

*  Get alternative language
    SELECT SINGLE spras
      FROM zabsf_pp061
      INTO @l_langu
     WHERE werks      EQ @werks
       AND is_default NE @space.

    IF sy-subrc EQ 0.
*    Get stop reason
      SELECT *
        FROM zabsf_pp015_t
        INTO CORRESPONDING FIELDS OF TABLE stop_reason_tab
        WHERE areaid EQ inputobj-areaid
          AND arbpl  IN r_arbpl
          AND werks  EQ werks
          AND spras  EQ l_langu.
    ENDIF.
*  No stop reason found for work center and operation
    IF stop_reason_tab[] IS INITIAL.
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '010'
        CHANGING
          return_tab = return_tab.
    ENDIF.
  ENDIF.
ENDMETHOD.


METHOD get_stop_reason_wrk.
*Ranges
  DATA: r_arbpl  TYPE RANGE OF arbpl,
        ls_arbpl LIKE LINE OF r_arbpl.

*Variables
  DATA: l_langu.

  DATA: lt_sf011 TYPE TABLE OF zabsf_pp011,
        ls_sf011 LIKE LINE OF lt_sf011.
  DATA: l_tabix TYPE sytabix.

* Field Symbols
  FIELD-SYMBOLS: <fs_stop_reason> TYPE zabsf_pp_s_stop_reason.


*Set language local for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

*Create ranges of workcenter
  ls_arbpl-option = 'EQ'.
  ls_arbpl-sign = 'I'.
  ls_arbpl-low = space.

  APPEND ls_arbpl TO r_arbpl.

  ls_arbpl-option = 'EQ'.
  ls_arbpl-sign = 'I'.
  ls_arbpl-low = arbpl.

  APPEND ls_arbpl TO r_arbpl.

*Get stop reasons
  SELECT *
    FROM zabsf_pp011_t
    INTO CORRESPONDING FIELDS OF TABLE stop_reason_tab
   WHERE areaid EQ inputobj-areaid
     AND arbpl  IN r_arbpl
     AND werks  EQ werks
     AND spras  EQ sy-langu.

  IF sy-subrc NE 0.
    CLEAR l_langu.

*  Get alternative language
    SELECT SINGLE spras
      FROM zabsf_pp061
      INTO l_langu
     WHERE werks      EQ werks
       AND is_default NE space.

    IF sy-subrc EQ 0.
*    Get stop reasons
      SELECT *
        FROM zabsf_pp011_t
        INTO CORRESPONDING FIELDS OF TABLE stop_reason_tab
       WHERE areaid EQ inputobj-areaid
         AND arbpl  IN r_arbpl
         AND werks  EQ werks
         AND spras  EQ l_langu.
    ENDIF.
  ENDIF.

*No stop reason found for this work center
  IF stop_reason_tab[] IS INITIAL.
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '009'
      CHANGING
        return_tab = return_tab.

  ELSE.

* BMR INSERT 26.08.2016 - get notify type for stop reason
    SELECT * FROM zabsf_pp011 INTO CORRESPONDING FIELDS OF TABLE lt_sf011
      FOR ALL ENTRIES IN stop_reason_tab
        WHERE areaid = inputobj-areaid
        AND werks = werks
        AND arbpl = stop_reason_tab-arbpl
        AND stprsnid  = stop_reason_tab-stprsnid
        AND inact = space.

    IF lt_sf011 IS NOT INITIAL.

      LOOP AT stop_reason_tab ASSIGNING <fs_stop_reason>.
        l_tabix = sy-tabix.
        READ TABLE lt_sf011 INTO ls_sf011 WITH KEY arbpl = <fs_stop_reason>-arbpl
                                                   stprsnid = <fs_stop_reason>-stprsnid.
        IF sy-subrc EQ 0.
          <fs_stop_reason>-notif_type = ls_sf011-notif_type.
        ELSE.
          DELETE stop_reason_tab INDEX l_tabix.
        ENDIF.

        CLEAR ls_sf011.
      ENDLOOP.
    ENDIF.

* BMR END INSERT 26.08.2016.
  ENDIF.
ENDMETHOD.


METHOD SET_REFDT.
*Set new reference date
  refdt = new_refdt.
ENDMETHOD.


method SET_STOP_REASON_OPR.
*  DATA wa_zlp_pp_sf016 TYPE zlp_pp_sf016.
*
*  CLEAR wa_zlp_pp_sf016.
*
**Save data of stop reason
**Work Center
*  wa_zlp_pp_sf016-arbpl = arbpl.
**Order
*  wa_zlp_pp_sf016-aufnr = aufnr.
**Operation
*  wa_zlp_pp_sf016-vornr = vornr.
**Date of stop reason
*  wa_zlp_pp_sf016-datesr = datesr.
**Start time of stop reason
*  wa_zlp_pp_sf016-time = time.
**Operator
*  wa_zlp_pp_sf016-operador = oprid.
**Type of stop - Stop or restart
*  wa_zlp_pp_sf016-stpty = stpty.
**Cause of stop
*  wa_zlp_pp_sf016-stprsnid = stprsnid.
*
**Save in Database
*  INSERT INTO zlp_pp_sf016 VALUES wa_zlp_pp_sf016.
*
*  IF sy-subrc EQ 0.
**  Operation completes successfully
*    CALL METHOD zcl_lp_pp_sf_log=>add_message
*      EXPORTING
*        msgty      = 'S'
*        msgno      = '013'
*      CHANGING
*        return_tab = return_tab.
*  ELSE.
**  Operation not completed
*    CALL METHOD zcl_lp_pp_sf_log=>add_message
*      EXPORTING
*        msgty      = 'E'
*        msgno      = '012'
*      CHANGING
*        return_tab = return_tab.
*  ENDIF.
endmethod.


method set_stop_reason_wrk.
*Reference
  data: lref_sf_status    type ref to zabsf_pp_cl_status,
        lref_sf_event_act type ref to zif_absf_pp_event_act,
        lref_sf_calc_min  type ref to zabsf_pp_cl_event_act.

*Variables
  data: l_time         type atime,
        l_time_off     type atime,
        l_time_act     type atime,
        l_time_calc    type pr_time,
        l_date_calc    type datum,
        l_status_out   type j_status,
        l_status_desc  type j_txt30,
        l_stsma_out    type jsto-stsma,
        l_activity     type ru_ismng,
        l_actionid     type zabsf_pp_e_action value 'INIT',
        l_flag_stop    type c, "Operation stop
        l_gname        type seqg3-gname,
        l_garg         type seqg3-garg,
        l_guname       type seqg3-guname,
        l_subrc        type sy-subrc,
        l_wait         type i,
        ls_zabsf_pp010 type zabsf_pp010.


*Constants
  constants: c_objty       type cr_objty          value 'A',    "Work center
             c_at03        type zabsf_pp_e_tarea_id value 'AT03', "Repetitive production functionalities
             c_obart_ov    type j_obart           value 'OV',   "Operation
             c_obart_ca    type j_obart           value 'CA',   "Work center
             c_time_offset type zabsf_pp_e_parid    value 'TIME_OFFSET',
             c_wait        type zabsf_pp_e_parid value 'WAIT'.

  clear: l_time.

*Check lenght of time
  data(l_lengh) = strlen( time ).

  if l_lengh lt 6.
    concatenate '0' time into l_time.
  else.
    l_time = time.
  endif.


*Upper case operator
  translate inputobj-oprid to upper case.

*Update User number
  if inputobj-pernr is initial.
    inputobj-pernr = inputobj-oprid.
  endif.

*Get time wait
  select single parva
    from zabsf_pp032
    into (@data(l_wait_param))
   where parid eq @c_wait.

  if l_wait_param is not initial.
    l_wait = l_wait_param.
  endif.

  l_time = l_time - l_wait.

*Get shift witch operator is associated
  select single shiftid
    from zabsf_pp052
    into (@data(l_shiftid))
   where areaid eq @inputobj-areaid
     and oprid  eq @inputobj-oprid.

  if sy-subrc ne 0.
*  Operator is not associated with shift
    call method zabsf_pp_cl_log=>add_message
      exporting
        msgty      = 'E'
        msgno      = '061'
        msgv1      = inputobj-oprid
      changing
        return_tab = return_tab.

    exit.
  endif.

*Get id of workcenter
  select single objid
    from crhd
    into (@data(l_arbpl_id))
   where arbpl eq @arbpl
     and werks eq @inputobj-werks.

*Get hierarchy of workcenter
  select single objty_hy, objid_hy
    from crhs
    into (@data(l_hname_ty), @data(l_hname_id))
   where objty_ho eq @c_objty     "Workcenter
     and objid_ho eq @l_arbpl_id.

*Get name of hierarchy
  select single name
    from crhh
    into (@data(l_hname))
   where objty eq @l_hname_ty
     and objid eq @l_hname_id.

*Get class of interface for Time confirmation
  select single imp_clname, methodname
      from zabsf_pp003
      into (@data(l_class),@data(l_method))
     where werks    eq @inputobj-werks
       and id_class eq '2'
       and endda    ge @refdt
       and begda    le @refdt.

  try.
*    Create object of class
      create object lref_sf_event_act type (l_class)
        exporting
          initial_refdt = refdt
          input_object  = inputobj.

    catch cx_sy_create_object_error.
*    Send message erro
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = 'E'
          msgno      = '019'
          msgv1      = l_class
        changing
          return_tab = return_tab.
      exit.
  endtry.

*Create object of class - Calculate time in minutes
  create object lref_sf_calc_min
    exporting
      initial_refdt = sy-datum
      input_object  = inputobj.

*Create object of class - Status
  create object lref_sf_status
    exporting
      initial_refdt = sy-datum
      input_object  = inputobj.

  if stprsnid is not initial.
*  Save data of stop reason
*    INSERT INTO zabsf_pp010 VALUES @( VALUE #( areaid   = inputobj-areaid "Area
*                                                hname    = l_hname         "Hierarchy
*                                                werks    = inputobj-werks  "Plant
*                                                arbpl    = arbpl           "Work Center
*                                                datesr   = datesr          "Date of stop reason
*                                                time     = l_time          "Start time of stop reason
*                                                operador = inputobj-oprid  "Operator
*                                                shiftid  = l_shiftid       "Shift
*                                                stprsnid = stprsnid        "Cause of stop
*                                                stopunit = c_min ) ).      "Unit

    ls_zabsf_pp010-areaid   = inputobj-areaid.
    ls_zabsf_pp010-hname    = l_hname.
    ls_zabsf_pp010-werks    = inputobj-werks.
    ls_zabsf_pp010-arbpl    = arbpl.
    ls_zabsf_pp010-datesr   = datesr.
    ls_zabsf_pp010-time     = l_time.
    ls_zabsf_pp010-operador = inputobj-oprid.
    ls_zabsf_pp010-shiftid  = l_shiftid.
    ls_zabsf_pp010-stprsnid = stprsnid.
    ls_zabsf_pp010-stopunit = c_min.

    insert into zabsf_pp010 values ls_zabsf_pp010.
    if sy-subrc eq 0.
      commit work and wait.

*    Operation completed successfully
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = 'S'
          msgno      = '013'
        changing
          return_tab = return_tab.

*    Get area type
      select single tarea_id
        from zabsf_pp008
        into (@data(l_tarea_id))
       where areaid eq @inputobj-areaid
         and werks  eq @inputobj-werks
         and endda  gt @sy-datum
         and begda  lt @sy-datum.

*    Check if area isn't equal to Assembly (Montagem)
      if l_tarea_id ne c_at03.
*      Get next status for operation
        select single status_next
          from zabsf_pp022
          into (@data(l_status_next))
         where objty       eq @c_obart_ov
           and status_last eq @space
           and status_next ne @space.

*      Change status of all operation of workcenter
        select *
          from zabsf_pp021
          into table @data(lt_pp_sf021)
         where arbpl       eq @arbpl
           and status_oper ne @l_status_next.

*      Get confirmations
        select distinct arbpl, aufnr, vornr, rueck, rmzhl, aufpl, aplzl, stprsnid
          from zabsf_pp016
          into table @data(lt_pp_sf016)
           for all entries in @lt_pp_sf021
         where areaid  eq @inputobj-areaid
           and hname   eq @l_hname
           and werks   eq @inputobj-werks
           and arbpl   eq @lt_pp_sf021-arbpl
           and aufnr   eq @lt_pp_sf021-aufnr
           and vornr   eq @lt_pp_sf021-vornr.
*           AND shiftid EQ @l_shiftid.

        loop at lt_pp_sf021 into data(ls_pp_sf021).
          if ls_pp_sf021-status_oper ne 'AGU' and ls_pp_sf021-status_oper ne 'CONC' and
             ls_pp_sf021-status_oper ne 'STOP'.

*          Get aufpl, aplzl and rueck
            read table lt_pp_sf016 into data(ls_pp_sf016) with key arbpl = ls_pp_sf021-arbpl
                                                                   aufnr = ls_pp_sf021-aufnr
                                                                   vornr = ls_pp_sf021-vornr.
            if sy-subrc eq 0.
*            Get counter final
              read table count_fin_tab into data(ls_count_fin) with key aufnr = ls_pp_sf021-aufnr
                                                                        vornr = ls_pp_sf021-vornr.


*            Check blocks
              call method zabsf_pp_cl_wait_enqueue=>wait_for_dequeue_res
                exporting
                  i_aufnr    = ls_pp_sf021-aufnr
                  i_max_time = l_wait
                importing
                  e_gname    = l_gname
                  e_garg     = l_garg
                  e_guname   = l_guname
                  e_return   = l_subrc.

              if l_subrc ne 0.
                exit.
              endif.

*            Save stop time - Confirm times
              call method lref_sf_event_act->(l_method)
                exporting
                  arbpl      = arbpl
                  werks      = werks
                  aufnr      = ls_pp_sf021-aufnr
                  vornr      = ls_pp_sf021-vornr
                  date       = datesr
                  time       = l_time
                  oprid      = inputobj-oprid
                  rueck      = ls_pp_sf016-rueck
                  aufpl      = ls_pp_sf016-aufpl
                  aplzl      = ls_pp_sf016-aplzl
                  actv_id    = 'STOP_PRO'
                  stprsnid   = stprsnid
                  count_fin  = ls_count_fin-count_fin
                changing
                  actionid   = actionid
                  return_tab = return_tab.
            endif.
          endif.
        endloop.

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

* BMR INSERT 26.09.2016 -change WC status even if  lt_pp_sf021 is empty
        call method lref_sf_status->status_object
          exporting
            arbpl       = arbpl
            werks       = inputobj-werks
            objty       = c_obart_ca
            method      = 'G'
          changing
            status_out  = l_status_out
            status_desc = l_status_desc
            stsma_out   = l_stsma_out
            return_tab  = return_tab.

*      Get next  status for workcenter
        select single status_next
          from zabsf_pp022
          into @l_status_next
         where objty       eq @c_obart_ca
           and status_last eq @l_status_out
           and stsma       eq @l_stsma_out
           and actionid    eq @actionid.

*      Change status
        call method lref_sf_status->status_object
          exporting
            arbpl      = arbpl
            werks      = werks
            objty      = c_obart_ca
            status     = l_status_next
            stsma      = l_stsma_out
            method     = 'S'
            actionid   = actionid
          changing
            return_tab = return_tab.

      else.
*      For other types areas
*      Get current status of workcenter
        call method lref_sf_status->status_object
          exporting
            arbpl       = arbpl
            werks       = inputobj-werks
            objty       = c_obart_ca
            method      = 'G'
          changing
            status_out  = l_status_out
            status_desc = l_status_desc
            stsma_out   = l_stsma_out
            return_tab  = return_tab.

*      Get next  status for workcenter
        select single status_next
          from zabsf_pp022
          into @l_status_next
         where objty       eq @c_obart_ca
           and status_last eq @l_status_out
           and stsma       eq @l_stsma_out
           and actionid    eq @actionid.

*      Change status
        call method lref_sf_status->status_object
          exporting
            arbpl      = arbpl
            werks      = werks
            objty      = c_obart_ca
            status     = l_status_next
            stsma      = l_stsma_out
            method     = 'S'
            actionid   = actionid
          changing
            return_tab = return_tab.
      endif.
    else.
*    Operation not completed
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = 'E'
          msgno      = '012'
        changing
          return_tab = return_tab.
    endif.
  else.
*  Check if exist stop reason saved
    select single *
      from zabsf_pp010
      into @data(ls_pp_sf010)
     where areaid   eq @inputobj-areaid
       and hname    eq @l_hname
       and werks    eq @inputobj-werks
       and arbpl    eq @arbpl
       and timeend  eq '000000'.

    if sy-subrc eq 0.
      clear l_activity.

*    Time
      l_time_calc = l_time.
*    Date
      l_date_calc = datesr.

*    Calculate stop time in minutes
      call method lref_sf_calc_min->calc_minutes
        exporting
          date       = ls_pp_sf010-datesr
          time       = ls_pp_sf010-time
          proc_date  = l_date_calc
          proc_time  = l_time_calc
        changing
          activity   = l_activity
          return_tab = return_tab.

*    Update stop time of Work center
*      update zabsf_pp010 from @( value #( base ls_pp_sf010 stoptime = l_activity
*                                                            stopunit = c_min
*                                                            endda    = datesr "BMR INSERT
*                                                            timeend  = l_time ) ).

      ls_pp_sf010-stoptime = l_activity.
      ls_pp_sf010-stopunit = c_min.
      ls_pp_sf010-endda    = datesr.
      ls_pp_sf010-timeend  = l_time.
      update zabsf_pp010 from  ls_pp_sf010.
      if sy-subrc eq 0.
        clear: l_status_next,
               l_flag_stop.

        refresh: lt_pp_sf021,
                 lt_pp_sf016.


        commit work and wait.

*      Get next status for operation
        select single status_next
          from zabsf_pp022
          into @l_status_next
         where objty       eq @c_obart_ov
           and status_last eq @space
           and status_next ne @space.

*      Change status of all operation of workcenter
        select *
          from zabsf_pp021
          into table @lt_pp_sf021
         where arbpl       eq @arbpl
           and status_oper ne @l_status_next.

*      Get confirmations
        select distinct arbpl, aufnr, vornr, rueck, rmzhl, aufpl, aplzl, stprsnid
          from zabsf_pp016
          into table @lt_pp_sf016
           for all entries in @lt_pp_sf021
         where areaid  eq @inputobj-areaid
           and hname   eq @l_hname
           and werks   eq @inputobj-werks
           and arbpl   eq @lt_pp_sf021-arbpl
           and aufnr   eq @lt_pp_sf021-aufnr
           and vornr   eq @lt_pp_sf021-vornr.
*           AND shiftid EQ @l_shiftid.

        clear ls_pp_sf021.

        loop at lt_pp_sf021 into ls_pp_sf021 where status_oper eq 'STOP'.
          clear ls_pp_sf016.

*        Get aufpl, aplzl and rueck
          read table lt_pp_sf016 into ls_pp_sf016 with key arbpl = ls_pp_sf021-arbpl
                                                           aufnr = ls_pp_sf021-aufnr
                                                           vornr = ls_pp_sf021-vornr.

*        Save stop time
          call method lref_sf_event_act->(l_method)
            exporting
              arbpl      = arbpl
              werks      = werks
              aufnr      = ls_pp_sf021-aufnr
              vornr      = ls_pp_sf021-vornr
              date       = datesr
              time       = l_time
              oprid      = inputobj-oprid
              rueck      = ls_pp_sf016-rueck
              aufpl      = ls_pp_sf016-aufpl
              aplzl      = ls_pp_sf016-aplzl
              actv_id    = 'END_PARC' "'INIT_PRO'
            changing
              actionid   = l_actionid
              return_tab = return_tab.

          l_flag_stop = 'X'.
        endloop.

*        if l_flag_stop is not initial.
*        Get current status of Workcenter
          call method lref_sf_status->status_object
            exporting
              arbpl       = arbpl
              werks       = inputobj-werks
              objty       = c_obart_ca
              method      = 'G'
            changing
              status_out  = l_status_out
              status_desc = l_status_desc
              stsma_out   = l_stsma_out
              return_tab  = return_tab.

*        Get next  status for workcenter
          select single status_next
            from zabsf_pp022
            into @l_status_next
           where objty       eq @c_obart_ca
             and status_last eq @l_status_out
             and stsma       eq @l_stsma_out
             and actionid    eq @actionid.

*        Change status
          call method lref_sf_status->status_object
            exporting
              arbpl      = arbpl
              werks      = werks
              objty      = c_obart_ca
              status     = l_status_next
              stsma      = l_stsma_out
              method     = 'S'
              actionid   = actionid
            changing
              return_tab = return_tab.
*        endif.
      endif.
    endif.
  endif.

  check actionid = 'STOP'.

  loop at lt_pp_sf021 into data(ls_sf021).
    delete from zabsf_pp069 where werks = werks
                               and aufnr = ls_sf021-aufnr
                               and vornr = ls_sf021-vornr
                               and flag_shift = abap_true.
  endloop.
  check sy-subrc = 0.
  commit work.

endmethod.
ENDCLASS.
