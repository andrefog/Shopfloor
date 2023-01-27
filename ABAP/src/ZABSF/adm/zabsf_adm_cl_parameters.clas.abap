class ZABSF_ADM_CL_PARAMETERS definition
  public
  final
  create public .

public section.

  interfaces ZIF_ABSF_ADM_PARAMETERS .

  methods CONSTRUCTOR
    importing
      !INITIAL_REFDT type VVDATUM
      !INPUT_OBJECT type ZABSF_PP_S_INPUTOBJECT .
protected section.
private section.

  data REFDT type VVDATUM .
  data INPUTOBJ type ZABSF_PP_S_INPUTOBJECT .
ENDCLASS.



CLASS ZABSF_ADM_CL_PARAMETERS IMPLEMENTATION.


method CONSTRUCTOR.
*Ref. Date
  refdt = initial_refdt.

*App input data
  inputobj = input_object.
endmethod.


  METHOD zif_absf_adm_parameters~get_parameters.
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


  METHOD zif_absf_adm_parameters~set_refdt.
  ENDMETHOD.
ENDCLASS.
