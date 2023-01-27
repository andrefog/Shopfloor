class ZABSF_PP_CL_PARAMETERS definition
  public
  final
  create public .

public section.

  interfaces ZIF_ABSF_PP_PARAMETERS .

  constants C_QUALIFICATIONS type ZABSF_PP_E_PARID value 'QUALIFICATIONS' ##NO_TEXT.
  constants C_SCHEDULE type ZABSF_PP_E_PARID value 'SCHEDULE_AND_REGIMES' ##NO_TEXT.
  constants C_CONSUMPTIONS type ZABSF_PP_E_PARID value 'CONSUMPTIONS' ##NO_TEXT.
  constants C_BT_START_LAUNCH type ZABSF_PP_E_PARID value 'BT_START_LAUNCH' ##NO_TEXT.
  constants C_BATCH_GENERATION type ZABSF_PP_E_PARID value 'BATCH_GENERATION' ##NO_TEXT.
  constants C_BATCH_VALIDATION type ZABSF_PP_E_PARID value 'BATCH_VALIDATION' ##NO_TEXT.
  constants C_BT_START_1ST_CYCLE type ZABSF_PP_E_PARID value 'BT_START_1ST_CYCLE' ##NO_TEXT.
  constants C_PROD_INFO type ZABSF_PP_E_PARID value 'PROD_INFO' ##NO_TEXT.
  constants C_MARCO_ONLY type ZABSF_PP_E_PARID value 'ONLY_MARCO_OPS' ##NO_TEXT.
  constants C_SCRAP_QTT_MARCO type ZABSF_PP_E_PARID value 'SCRAP_QTT_MARCO' ##NO_TEXT.
  constants C_GOOD_QTT_MARCO type ZABSF_PP_E_PARID value 'GOOD_QTT_MARCO' ##NO_TEXT.
  constants C_USE_CWM type ZABSF_PP_E_PARID value 'USE_CWM' ##NO_TEXT.

  methods CONSTRUCTOR
    importing
      !INITIAL_REFDT type VVDATUM
      !INPUT_OBJECT type ZABSF_PP_S_INPUTOBJECT .
  methods GET_OUTPUT_SETTINGS
    importing
      value(PARID) type ZABSF_PP_E_PARID optional
      value(GET_ALL) type FLAG optional
    exporting
      value(PARAMETER_VALUE) type FLAG
      value(ALL_PARAMETERS) type ZABSF_PP_S_VISUAL_SETTINGS
    changing
      value(RETURN_TAB) type BAPIRET2_T .
protected section.
private section.

  data REFDT type VVDATUM .
  data INPUTOBJ type ZABSF_PP_S_INPUTOBJECT .
ENDCLASS.



CLASS ZABSF_PP_CL_PARAMETERS IMPLEMENTATION.


method CONSTRUCTOR.
*Ref. Date
  refdt = initial_refdt.

*App input data
  inputobj = input_object.
endmethod.


  METHOD get_output_settings.

    FIELD-SYMBOLS <fs_field> TYPE any.

    IF get_all EQ abap_true.

      SELECT * FROM zabsf_pp079 INTO TABLE @DATA(lt_pp079)
        WHERE werks EQ @me->inputobj-werks
        AND areaid EQ @me->inputobj-areaid.

      IF sy-subrc NE 0.
* Send Error message!
        CALL METHOD zabsf_pp_cl_log=>add_message
          EXPORTING
            msgty      = 'E'
            msgno      = '106'
          CHANGING
            return_tab = return_tab.
      ELSE.

        LOOP AT lt_pp079 INTO DATA(ls_pp079).

          ASSIGN COMPONENT ls_pp079-parid OF STRUCTURE all_parameters TO <fs_field>.
          IF <fs_field> IS ASSIGNED AND sy-subrc EQ 0.
            <fs_field> = ls_pp079-status.
          ENDIF.
        ENDLOOP.
      ENDIF.

    ELSE.
      SELECT SINGLE status FROM zabsf_pp079 INTO parameter_value
        WHERE werks EQ me->inputobj-werks
        AND parid EQ parid
        AND areaid EQ me->inputobj-areaid.

      IF sy-subrc NE 0.
* Send Error message!
        CALL METHOD zabsf_pp_cl_log=>add_message
          EXPORTING
            msgty      = 'E'
            msgno      = '107'
            msgv1      = parid
          CHANGING
            return_tab = return_tab.

      ENDIF.
    ENDIF.

  ENDMETHOD.


METHOD zif_absf_pp_parameters~get_parameters.
*Internal tables
  DATA: lt_pp_sf032_t TYPE TABLE OF zabsf_pp032_t.

*Structures
  DATA: ls_pp_sf032_t TYPE zabsf_pp032_t.

*Variables
  DATA: l_langu TYPE sy-langu.

*Field symbols
  FIELD-SYMBOLS: <fs_parameters> TYPE zabsf_pp_s_parameters.

*Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

*Get parameters
  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE parameters_tab
    FROM zabsf_pp032 AS zabsf_pp032
   INNER JOIN zabsf_pp032_t AS zabsf_pp032_t
      ON zabsf_pp032_t~parid EQ zabsf_pp032~parid
   WHERE zabsf_pp032~werks   EQ inputobj-werks
     AND zabsf_pp032_t~spras EQ sy-langu.

  SELECT *
    FROM zabsf_pp032
    INTO CORRESPONDING FIELDS OF TABLE parameters_tab
   WHERE werks EQ inputobj-werks.

  IF parameters_tab[] IS NOT INITIAL.
*  Get parameters description
    SELECT *
      FROM zabsf_pp032_t
      INTO CORRESPONDING FIELDS OF TABLE lt_pp_sf032_t
       FOR ALL ENTRIES IN parameters_tab
     WHERE parid EQ parameters_tab-parid
       AND spras EQ sy-langu.

    IF sy-subrc NE 0.
      CLEAR l_langu.

*    Get alternative language
      SELECT SINGLE spras
        FROM zabsf_pp061
        INTO l_langu
       WHERE werks      EQ inputobj-werks
         AND is_default NE space.

      IF sy-subrc EQ 0.
*      Get parameters description
        SELECT *
          FROM zabsf_pp032_t
          INTO CORRESPONDING FIELDS OF TABLE lt_pp_sf032_t
           FOR ALL ENTRIES IN parameters_tab
         WHERE parid EQ parameters_tab-parid
           AND spras EQ l_langu.
      ENDIF.
    ENDIF.

    LOOP AT parameters_tab ASSIGNING <fs_parameters>.
*      Read parameters description
      READ TABLE lt_pp_sf032_t INTO ls_pp_sf032_t WITH KEY parid = <fs_parameters>-parid.

      IF sy-subrc EQ 0.
        <fs_parameters>-partxt = ls_pp_sf032_t-partxt.
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF parameters_tab[] IS NOT INITIAL.
*  Operation completed successuflly
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'S'
        msgno      = '013'
      CHANGING
        return_tab = return_tab.
  ELSE.
*  No data found in customizing table
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'I'
        msgno      = '028'
        msgv1      = inputobj-werks
      CHANGING
        return_tab = return_tab.
  ENDIF.
ENDMETHOD.


  method ZIF_ABSF_PP_PARAMETERS~SET_REFDT.
  endmethod.
ENDCLASS.
