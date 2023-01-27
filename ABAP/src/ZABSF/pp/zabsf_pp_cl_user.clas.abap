class ZABSF_PP_CL_USER definition
  public
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !INITIAL_REFDT type VVDATUM
      !INPUT_OBJECT type ZABSF_PP_S_INPUTOBJECT .
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
  methods SET_REFDT
    importing
      !NEW_REFDT type VVDATUM .
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
ENDCLASS.
