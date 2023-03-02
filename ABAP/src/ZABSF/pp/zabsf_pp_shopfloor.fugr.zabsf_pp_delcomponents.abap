FUNCTION ZABSF_PP_DELCOMPONENTS.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(AUFNR) TYPE  AUFNR
*"     VALUE(VORNR) TYPE  VORNR OPTIONAL
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"  CHANGING
*"     VALUE(COMPONENTS_TAB) TYPE  ZABSF_PP_T_COMPONENTS OPTIONAL
*"--------------------------------------------------------------------
*References
  DATA: lref_sf_consum TYPE REF TO zif_absf_pp_consumptions.

*>SETUP
  DATA: lref_sf_parameters  TYPE REF TO zabsf_pp_cl_parameters,
        lv_get_consumptions TYPE flag.

  CREATE OBJECT lref_sf_parameters
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

  CALL METHOD lref_sf_parameters->get_output_settings
    EXPORTING
      parid           = lref_sf_parameters->c_consumptions
    IMPORTING
      parameter_value = lv_get_consumptions
    CHANGING
      return_tab      = return_tab.

  IF lv_get_consumptions EQ abap_true.
*Get class of interface
    SELECT SINGLE imp_clname, methodname
        FROM zabsf_pp003
        INTO (@DATA(l_class), @DATA(l_method))
       WHERE werks    EQ @inputobj-werks
         AND id_class EQ '21'
         AND endda    GE @refdt
         AND begda    LE @refdt.

    TRY .
        CREATE OBJECT lref_sf_consum TYPE (l_class)
          EXPORTING
            initial_refdt = refdt
            input_object  = inputobj.

      CATCH cx_sy_create_object_error.
*
        CALL METHOD zabsf_pp_cl_log=>add_message
          EXPORTING
            msgty      = 'E'
            msgno      = '019'
            msgv1      = l_class
          CHANGING
            return_tab = return_tab.

        EXIT.
    ENDTRY.

    CALL METHOD lref_sf_consum->(l_method)
      EXPORTING
        aufnr          = aufnr
        vornr          = vornr
      CHANGING
        components_tab = components_tab
        return_tab     = return_tab.


    DELETE ADJACENT DUPLICATES FROM return_tab.
  ENDIF.





ENDFUNCTION.
