class ZABSF_PP_CL_USER definition
  public
  final
  create public .

public section.

  class-methods DEL_USERWORKCENTERS
    importing
      !IV_USERNAME type ZABSF_E_USERNAME .
  class-methods GET_USERSWORKCENTERS
    importing
      !IR_USERNAMES type ZABSF_PP_R_USERNAMES
    returning
      value(RT_WORKCENTERS) type ZABSF_PP_TT_FNCWRK .
  class-methods GET_USERWORKCENTERS
    importing
      !IV_USERNAME type ZABSF_E_USERNAME
    returning
      value(RT_WORKCENTERS) type ZABSF_PP_TT_FNCWRK .
  class-methods UPD_USERWORKCENTERS
    importing
      !IV_USERNAME type ZABSF_PPRHFNCWRK-USERNAME
      value(IT_WORKCENTERS) type ZABSF_PP_TT_USER_WORKCENTERS optional .
  methods CONSTRUCTOR
    importing
      !INITIAL_REFDT type VVDATUM
      !INPUT_OBJECT type ZABSF_PP_S_INPUTOBJECT .
  methods SET_REFDT
    importing
      !NEW_REFDT type VVDATUM .
  methods SET_USER_SHIFT
    importing
      !SHIFTID type ZABSF_PP_E_SHIFTID
    changing
      !RETURN_TAB type BAPIRET2_T .
  methods UNSET_USER_SHIFT
    importing
      !SHIFTID type ZABSF_PP_E_SHIFTID
    changing
      !RETURN_TAB type BAPIRET2_T .
protected section.
private section.

  data REFDT type VVDATUM .
  data INPUTOBJ type ZABSF_PP_S_INPUTOBJECT .
  constants C_ALL type ZABSF_PP_E_SHIFTID value 'ALL' ##NO_TEXT.
ENDCLASS.



CLASS ZABSF_PP_CL_USER IMPLEMENTATION.


METHOD CONSTRUCTOR.

*Ref. Date
  refdt    = initial_refdt.

*App input data
  inputobj = input_object.

ENDMETHOD.


  METHOD del_userworkcenters.
    DELETE FROM zabsf_pprhfncwrk
      WHERE username EQ iv_username.

    COMMIT WORK AND WAIT.
  ENDMETHOD.


  METHOD get_usersworkcenters.
    TYPES: BEGIN OF ty_crtx,
             name  TYPE cr_hname,
             ktext TYPE cr_ktext,
           END OF ty_crtx.

    DATA: l_langu TYPE sy-langu,
          lt_crtx TYPE TABLE OF ty_crtx.

    SELECT f~username, c~objty, f~hname, f~arbpl, x~ktext
      FROM zabsf_pprhfncwrk AS f
      LEFT OUTER JOIN crhd AS c
        ON c~arbpl EQ f~arbpl
      LEFT OUTER JOIN crtx AS x
        ON x~objty EQ c~objty AND
           x~objid EQ c~objid
      INTO TABLE @rt_workcenters
      WHERE f~username IN @ir_usernames
        AND f~begda LE @sy-datum
        AND f~endda GE @sy-datum.

    " Create node for the hierarchies.
    DATA(lt_hierarchies) = rt_workcenters[].
    MODIFY lt_hierarchies
      FROM VALUE #( objty = 'H' arbpl = '' ktext = '' )
      TRANSPORTING objty arbpl ktext
      WHERE username NE space.

*BEG - João Lopes - 23.11.2022 - sort hierarchies and work centers by "KTEXT" field
    DELETE ADJACENT DUPLICATES FROM lt_hierarchies COMPARING username hname objty.

*  Get hierarchy description
    SELECT crhh~name crtx~ktext
      INTO CORRESPONDING FIELDS OF TABLE lt_crtx
      FROM crtx AS crtx
     INNER JOIN crhh AS crhh
        ON crhh~objty EQ crtx~objty
       AND crhh~objid EQ crtx~objid
       FOR ALL ENTRIES IN lt_hierarchies
     WHERE crhh~name  EQ lt_hierarchies-hname
*       AND crhh~werks EQ in inputobj-werks
       AND crhh~objty EQ 'H'.
*       AND crtx~spras EQ sy-langu.

    IF lt_crtx[] IS INITIAL.
*    Get alternative language
      SELECT SINGLE spras
        FROM zabsf_pp061
        INTO l_langu
*       WHERE werks EQ inputobj-werks
         WHERE is_default NE space.

*    Get hierarchy description
      SELECT crhh~name crtx~ktext
        INTO CORRESPONDING FIELDS OF TABLE lt_crtx
        FROM crtx AS crtx
       INNER JOIN crhh AS crhh
          ON crhh~objty EQ crtx~objty
         AND crhh~objid EQ crtx~objid
         FOR ALL ENTRIES IN lt_hierarchies
       WHERE crhh~name  EQ lt_hierarchies-hname
*         AND crhh~werks EQ inputobj-werks
         AND crhh~objty EQ 'H'
         AND crtx~spras EQ l_langu.
    ENDIF.

    LOOP AT lt_hierarchies ASSIGNING FIELD-SYMBOL(<fs_hrchy>).
*    Read hierarchy description
      READ TABLE lt_crtx INTO data(ls_crtx) WITH KEY name = <fs_hrchy>-hname.

      IF sy-subrc EQ 0.
*      Hierarchy description
        <fs_hrchy>-ktext = ls_crtx-ktext.
      ENDIF.
    ENDLOOP.

    sort lt_hierarchies by ktext.
    sort rt_workcenters by hname ktext.
*END - João Lopes - 23.11.2022 - sort hierarchies and work centers by "KTEXT" field

    " add hierarchies node to return
    APPEND LINES OF lt_hierarchies TO rt_workcenters.
    DELETE ADJACENT DUPLICATES FROM rt_workcenters COMPARING username hname arbpl objty.
  ENDMETHOD.


  METHOD get_userworkcenters.
    rt_workcenters = get_usersworkcenters( VALUE #( ( sign = 'I' option = 'EQ' low = iv_username ) ) ).
  ENDMETHOD.


METHOD SET_REFDT.

*Set new reference date
  refdt = new_refdt.

  ENDMETHOD.


METHOD set_user_shift.
  DATA ls_users TYPE zabsf_pp052.

  TRANSLATE inputobj-oprid TO UPPER CASE.
*Check if user was associated to another shift
  SELECT SINGLE *
    FROM zabsf_pp052
    INTO CORRESPONDING FIELDS OF ls_users
   WHERE areaid EQ inputobj-areaid
     AND oprid EQ inputobj-oprid.

  IF ls_users IS NOT INITIAL.
    IF ls_users-shiftid EQ shiftid.
*    User associated to same shift
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'I'
          msgno      = '051'
          msgv1      = inputobj-oprid
          msgv2      = shiftid
        CHANGING
          return_tab = return_tab.
    ELSE.
**    Users associated to another shift
*      CALL METHOD ZABSF_PP_cl_log=>add_message
*        EXPORTING
*          msgty      = 'E'
*          msgno      = '050'
*          msgv1      = inputobj-oprid
*          msgv2      = ls_users-shiftid
*        CHANGING
*          return_tab = return_tab.

      DELETE zabsf_pp052 FROM ls_users.

      CLEAR ls_users.
      ls_users-areaid = inputobj-areaid.
      ls_users-shiftid = shiftid.
      ls_users-oprid = inputobj-oprid.
      INSERT INTO zabsf_pp052 VALUES ls_users.

      IF sy-subrc EQ 0.
*       Associated user to shift
        CALL METHOD zabsf_pp_cl_log=>add_message
          EXPORTING
            msgty      = 'S'
            msgno      = '013'
          CHANGING
            return_tab = return_tab.
      ELSE.
*      Operation not completed successfully
        CALL METHOD zabsf_pp_cl_log=>add_message
          EXPORTING
            msgty      = 'E'
            msgno      = '012'
          CHANGING
            return_tab = return_tab.
      ENDIF.

    ENDIF.
  ELSE.
    CLEAR ls_users.

    ls_users-areaid = inputobj-areaid.
    ls_users-shiftid = shiftid.
    ls_users-oprid = inputobj-oprid.

    TRANSLATE ls_users-oprid TO UPPER CASE. "CLS 16.06.2015
    INSERT INTO zabsf_pp052 VALUES ls_users.

    IF sy-subrc EQ 0.
*    Associated user to shift
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'S'
          msgno      = '013'
        CHANGING
          return_tab = return_tab.
    ELSE.
*   Operation not completed successfully
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '012'
        CHANGING
          return_tab = return_tab.
    ENDIF.
  ENDIF.
ENDMETHOD.


METHOD unset_user_shift.
  DATA ls_users TYPE zabsf_pp052.

  TRANSLATE inputobj-oprid TO UPPER CASE. "CLS 16.06.2015

  IF shiftid EQ c_all.
*  Check if user was associated to another shift
    SELECT SINGLE *
      FROM zabsf_pp052
      INTO CORRESPONDING FIELDS OF ls_users
     WHERE areaid  EQ inputobj-areaid
       AND oprid   EQ inputobj-oprid.
  ELSE.
*  Check if user was associated to another shift
    SELECT SINGLE *
      FROM zabsf_pp052
      INTO CORRESPONDING FIELDS OF ls_users
     WHERE areaid  EQ inputobj-areaid
       AND oprid   EQ inputobj-oprid
       AND shiftid EQ shiftid.
  ENDIF.

  IF ls_users IS NOT INITIAL.
    DELETE zabsf_pp052 FROM ls_users.

    IF sy-subrc EQ 0.
*    Associated user to shift
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'S'
          msgno      = '013'
        CHANGING
          return_tab = return_tab.
    ELSE.
*   Operation not completed successfully
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '012'
        CHANGING
          return_tab = return_tab.
    ENDIF.
  ENDIF.
ENDMETHOD.


  METHOD upd_userworkcenters.
    DELETE it_workcenters WHERE objty EQ 'H'.

    " By the fact we don't have de time from the change, all changes in the same day need to be removed
    DELETE FROM zabsf_pprhfncwrk
      WHERE username EQ iv_username
        AND begda    EQ sy-datum.

    " Get old authorizations.
    SELECT *
      FROM zabsf_pprhfncwrk
      INTO TABLE @DATA(lt_fncwrk)
      WHERE username EQ @iv_username
        AND begda LT @sy-datum
        AND endda GE @sy-datum.

    IF sy-subrc IS INITIAL.
      " If found any, delimit to day before today
      MODIFY lt_fncwrk
        FROM VALUE #( endda = sy-datum - 1 )
        TRANSPORTING endda
        WHERE username EQ iv_username.
    ENDIF.

    LOOP AT it_workcenters ASSIGNING FIELD-SYMBOL(<ls_workcenters>).
      " Add new authorizations
      APPEND
        VALUE #(
          username = iv_username
          arbpl    = <ls_workcenters>-id
          begda    = sy-datum
          endda    = '99991231'
          shiftid  = ''
          hname    = <ls_workcenters>-parentid )
        TO lt_fncwrk.
    ENDLOOP.

    " Modify table
    MODIFY zabsf_pprhfncwrk FROM TABLE lt_fncwrk.
    COMMIT WORK AND WAIT.
  ENDMETHOD.
ENDCLASS.
