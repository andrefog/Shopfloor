class ZABSF_PP_CL_SHIFT definition
  public
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !INITIAL_REFDT type VVDATUM
      !INITIAL_REFHR type ADUHR
      !INPUT_OBJECT type ZABSF_PP_S_INPUTOBJECT .
  methods GET_SHIFT_DETAIL
    importing
      !AREAID type ZABSF_PP_E_AREAID optional
      !WERKS type WERKS_D optional
      !SHIFTID type ZABSF_PP_E_SHIFTID
    changing
      value(SHIFT_DETAIL) type ZABSF_PP_S_SHIFT_DETAIL
      !RETURN_TAB type BAPIRET2_T
    exceptions
      NOT_FOUND .
  methods GET_SHIFTS
    importing
      !AREAID type ZABSF_PP_E_AREAID optional
      !WERKS type WERKS_D optional
      !ALL_SHIFT type FLAG optional
      !TIME type ATIME optional
    changing
      !SHIFT_TAB type ZABSF_PP_T_SHIFT
      !RETURN_TAB type BAPIRET2_T optional .
  methods SET_REFDT
    importing
      !NEW_REFDT type VVDATUM .
protected section.
private section.

  data REFDT type VVDATUM .
  data REFHR type ADUHR .
  data INPUTOBJ type ZABSF_PP_S_INPUTOBJECT .
ENDCLASS.



CLASS ZABSF_PP_CL_SHIFT IMPLEMENTATION.


METHOD CONSTRUCTOR.

*Ref. Date
  refdt    = initial_refdt.

*Ref. Time
  refhr    = initial_refhr.

*App input data
  inputobj = input_object.

ENDMETHOD.


method get_shifts.
*Internal tables
  data: lt_shifts_tmp type standard table of ty_s_shift_tmp,
        lt_shifts_aux type standard table of ty_s_shift_tmp,
        lt_sf001_t    type standard table of zabsf_pp001_t,
        lt_sf007      type standard table of zabsf_pp007.

*Structures
  data: ls_sf001_t type zabsf_pp001_t.

*Variables
  data: l_shift_start    type i,
        l_shift_end      type i,
        l_wotnr_packed   type p,
        l_wotnr          type wotnr,
        l_index          type sy-tabix,
        l_fieldname      type fieldname,
        l_langu          type sy-langu,
        l_tstmp_ini      type timestamp,
        l_tstmp_end      type timestamp,
        l_tstmp_act      type timestamp,
        l_tstmp_temp(15) type c,
        l_tstmp_sub      type tzntstmpl,
        l_time           type atime.

*Field symbols
  field-symbols: <shift>      type zabsf_pp_s_shift,
                 <sf007>      type zabsf_pp007,
                 <shift_tmp>  type ty_s_shift_tmp,
                 <active_day> type arbtag,
                 <return>     type bapiret2.

*Constants
  constants c_sec type i value '60'.

*Set local language for user
  l_langu = inputobj-language.

  set locale language l_langu.

*Get basic shift data with a reference date/time and logon language
  select areaid werks shiftid fcalid shift_down shift_up shift_start shift_end
    from zabsf_pp001
    into corresponding fields of table lt_shifts_tmp
   where areaid eq inputobj-areaid "Areaid
     and werks  eq inputobj-werks  "Werks
     and begda  le refdt
     and endda  ge refdt.

*Get shift description
  select areaid werks shiftid shift_desc
    from zabsf_pp001_t
    into corresponding fields of table lt_sf001_t
     for all entries in lt_shifts_tmp
   where areaid  eq lt_shifts_tmp-areaid
     and werks   eq lt_shifts_tmp-werks
     and shiftid eq lt_shifts_tmp-shiftid
     and spras   eq sy-langu.

  if lt_sf001_t[] is initial.
    clear l_langu.

*  Get alternative language
    select single spras
      from zabsf_pp061
      into l_langu
     where werks      eq inputobj-werks
       and is_default ne space.

*  Get shift description
    select areaid werks shiftid shift_desc
      from zabsf_pp001_t
      into corresponding fields of table lt_sf001_t
       for all entries in lt_shifts_tmp
     where areaid  eq lt_shifts_tmp-areaid
       and werks   eq lt_shifts_tmp-werks
       and shiftid eq lt_shifts_tmp-shiftid
       and spras   eq l_langu.
  endif.

  if all_shift is initial.
*  Move data to auxiliary table
    move lt_shifts_tmp[] to lt_shifts_aux[].

    refresh lt_shifts_tmp.

*  Check lenght of time
    data(l_lengh) = strlen( time ).

    if l_lengh lt 6.
      concatenate '0' time into l_time.
    else.
      l_time = time.
    endif.

    types: begin of ty_date,
             date type datum,
           end of ty_date.

    data: lt_date type table of ty_date,
          ls_date type ty_date.

    clear ls_date.
    ls_date-date = refdt - 1.
    append ls_date to lt_date.

    clear ls_date.
    ls_date-date = refdt.
    append ls_date to lt_date.

    clear ls_date.
    ls_date-date = refdt + 1.
    append ls_date to lt_date.

    loop at lt_shifts_aux assigning <shift_tmp>.
*      CLEAR: l_shift_start,
*             l_shift_end.
*
*      IF <shift_tmp>-shift_down IS NOT INITIAL OR <shift_tmp>-shift_up IS NOT INITIAL.
*        l_shift_start = <shift_tmp>-shift_down * c_sec.
*        l_shift_end = <shift_tmp>-shift_up * c_sec.
*
*        SUBTRACT l_shift_start FROM <shift_tmp>-shift_start.
*        ADD l_shift_end TO <shift_tmp>-shift_end.
*      ENDIF.
*
*      IF ( <shift_tmp>-shift_start <= refhr AND <shift_tmp>-shift_end >= refhr ).
*        APPEND <shift_tmp> TO lt_shifts_tmp.
*      ENDIF.
*    Actual time
      clear l_tstmp_temp.
      concatenate refdt l_time into l_tstmp_temp.
      l_tstmp_act = l_tstmp_temp.

      clear ls_date.

      loop at lt_date into ls_date.
        clear: l_shift_start,
               l_shift_end,
*               l_tstmp_act,
               l_tstmp_ini,
               l_tstmp_end.

*    Start shift
        clear l_tstmp_temp.
        concatenate ls_date-date <shift_tmp>-shift_start into l_tstmp_temp.
        l_tstmp_ini = l_tstmp_temp.

*    End shift
        clear l_tstmp_temp.
        "BMR EDIT 20.07.2020 - Turnos que terminam no dia seguinte
        if <shift_tmp>-shift_end lt <shift_tmp>-shift_start.
          data(lv_aux) = ls_date-date.
          "adicionar um dia
          lv_aux = lv_aux + 1.
          concatenate lv_aux <shift_tmp>-shift_end into l_tstmp_temp.
        else.
          concatenate ls_date-date <shift_tmp>-shift_end into l_tstmp_temp.
        endif.
        l_tstmp_end = l_tstmp_temp.

        if <shift_tmp>-shift_down is not initial or <shift_tmp>-shift_up is not initial.
          l_shift_start = <shift_tmp>-shift_down * c_sec.
          l_shift_end = <shift_tmp>-shift_up * c_sec.

          clear l_tstmp_sub.
*      Start shift with tolerance
          call method cl_abap_tstmp=>subtractsecs
            exporting
              tstmp   = l_tstmp_ini
              secs    = l_shift_start
            receiving
              r_tstmp = l_tstmp_sub.

          clear l_tstmp_ini.
          l_tstmp_ini = l_tstmp_sub.

          clear l_tstmp_sub.

*      End shift with tolerance
          call method cl_abap_tstmp=>add
            exporting
              tstmp   = l_tstmp_end
              secs    = l_shift_end
            receiving
              r_tstmp = l_tstmp_sub.

          clear l_tstmp_end.
          l_tstmp_end = l_tstmp_sub.
        endif.

        if ( l_tstmp_ini le l_tstmp_act and l_tstmp_end ge l_tstmp_act ).
          append <shift_tmp> to lt_shifts_tmp.
        endif.
      endloop.
    endloop.
  endif.

  if lt_shifts_tmp[] is not initial.
    sort lt_shifts_tmp by  areaid ascending werks ascending shiftid ascending.

    delete adjacent duplicates from lt_shifts_tmp.

*  Get shift description
    loop at lt_shifts_tmp assigning <shift_tmp>.
      clear ls_sf001_t.

*    Read shift description
      read table lt_sf001_t into ls_sf001_t with key shiftid = <shift_tmp>-shiftid.

      if sy-subrc eq 0.
*      Shift description
        <shift_tmp>-shift_desc = ls_sf001_t-shift_desc.
      endif.
    endloop.

*  Get the shift week day association
    select *
      from zabsf_pp007
      into table lt_sf007
       for all entries in lt_shifts_tmp
     where shiftid eq lt_shifts_tmp-shiftid
       and areaid  eq lt_shifts_tmp-areaid
       and werks   eq lt_shifts_tmp-werks
       and begda   le refdt
       and endda   ge refdt.

    if sy-subrc = 0.
*    Get weekday to be checked against customizing
      call function 'DAY_IN_WEEK'
        exporting
          datum = refdt
        importing
          wotnr = l_wotnr_packed.

      l_wotnr = l_wotnr_packed.

      loop at lt_shifts_tmp assigning <shift_tmp>.

        l_index = sy-tabix.

        if <shift_tmp>-fcalid is not initial.

*FLA 05-10-2016 retirada validação working day
**       Check if it's a working day according to Factory Calendar
*          CALL FUNCTION 'DATE_CHECK_WORKINGDAY'
*            EXPORTING
*              date                       = refdt
*              factory_calendar_id        = <shift_tmp>-fcalid
*              message_type               = 'W'
*            EXCEPTIONS
*              date_after_range           = 1
*              date_before_range          = 2
*              date_invalid               = 3
*              date_no_workingday         = 4
*              factory_calendar_not_found = 5
*              message_type_invalid       = 6
*              OTHERS                     = 7.
*
*          IF sy-subrc = 0. "It's a working day
*         Check if the shift is scheduled to be active
          read table lt_sf007 assigning <sf007>
          with key shiftid  = <shift_tmp>-shiftid
                   areaid   = <shift_tmp>-areaid
                   werks    = <shift_tmp>-werks.

          if sy-subrc = 0.
            concatenate 'DAY' l_wotnr into l_fieldname.

*           Get corresponding day of the week in customizing and check it against
            assign component l_fieldname of structure <sf007> to <active_day>.
            if sy-subrc = 0.
              if <active_day> = abap_false."Not active => delete
                delete lt_shifts_tmp index l_index.
                continue.
              endif.
            endif.

          else."If not found, delete from list
            delete lt_shifts_tmp index l_index.
            continue.
          endif.

*          ELSE."Not a working day, delete from the available shifts
*            DELETE lt_shifts_tmp INDEX l_index.
*            CONTINUE.
*          ENDIF.

        else. "No factory calender set for shift & / &
          call method zabsf_pp_cl_log=>add_message
            exporting
              msgty      = 'E'
              msgno      = '003'
            changing
              return_tab = return_tab.
        endif.

*      If all OK append to output table
        append initial line to shift_tab assigning <shift>.

        move-corresponding <shift_tmp> to <shift>.

      endloop.
    else."No shift week day associations found
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = 'E'
          msgno      = '002'
        changing
          return_tab = return_tab.
    endif.
  else. "No shifts for the inputs
    call method zabsf_pp_cl_log=>add_message
      exporting
        msgty      = 'E'
        msgno      = '001'
      changing
        return_tab = return_tab.
  endif.

*No shifts, return warning message
  if shift_tab[] is initial.
    call method zabsf_pp_cl_log=>add_message
      exporting
        msgty      = 'W'
        msgno      = '004'
      changing
        return_tab = return_tab.
  endif.
endmethod.


METHOD get_shift_detail.
*Reference
  DATA lref_sf_hrchy TYPE REF TO zabsf_pp_cl_hrchy.

*Variables
  DATA: l_langu TYPE sy-langu.

*Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

*Get shift detail
  SELECT SINGLE *
    INTO CORRESPONDING FIELDS OF shift_detail
    FROM zabsf_pp001
   WHERE areaid  EQ inputobj-areaid "Areaid
     AND werks   EQ inputobj-werks  "Werks
     AND shiftid EQ shiftid
     AND begda   LE refdt
     AND endda   GE refdt.

  IF shift_detail IS NOT INITIAL.
*  Get shift description
    SELECT SINGLE shift_desc
      FROM zabsf_pp001_t
      INTO shift_detail-shift_desc
     WHERE areaid  EQ shift_detail-areaid
       AND werks   EQ shift_detail-werks
       AND shiftid EQ shift_detail-shiftid
       AND spras   EQ sy-langu.

    IF shift_detail-shift_desc IS INITIAL.
      CLEAR l_langu.

*    Get alternative language
      SELECT SINGLE spras
        FROM zabsf_pp061
        INTO l_langu
       WHERE werks      EQ inputobj-werks
         AND is_default NE space.

*    Get shift description
      SELECT SINGLE shift_desc
        FROM zabsf_pp001_t
        INTO shift_detail-shift_desc
       WHERE areaid  EQ shift_detail-areaid
         AND werks   EQ shift_detail-werks
         AND shiftid EQ shift_detail-shiftid
         AND spras   EQ l_langu.
    ENDIF.

*  Get hierarchies
    CREATE OBJECT lref_sf_hrchy
      EXPORTING
        initial_refdt = refdt
        input_object  = inputobj.


    CALL METHOD lref_sf_hrchy->get_hierarchies
      EXPORTING
        areaid     = inputobj-areaid "Areaid
        werks      = inputobj-werks  "Werks
        shiftid    = shiftid
      CHANGING
        hrchy_tab  = shift_detail-hrchy_tab
        return_tab = return_tab.

  ELSE.
*  No Shift detail found
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '007'
      CHANGING
        return_tab = return_tab.
  ENDIF.

ENDMETHOD.


METHOD SET_REFDT.

*Set new reference date
  refdt = new_refdt.

  ENDMETHOD.
ENDCLASS.
