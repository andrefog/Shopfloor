FUNCTION ZABSF_ADM_GETPARAMETERS.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(PARAMETERS_TAB) TYPE  ZABSF_PP_T_PARAMETERS
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

DATA lref_sf_parameters TYPE REF TO zif_absf_adm_parameters.

  DATA: ld_class  TYPE recaimplclname,
        ld_method TYPE seocmpname.

*Get class of interface
  SELECT SINGLE imp_clname methodname
      FROM zabsf_pp003
      INTO (ld_class, ld_method)
     WHERE werks EQ inputobj-werks
       AND id_class EQ '4'
       AND endda GE refdt
       AND begda LE refdt.

  TRY .
      CREATE OBJECT lref_sf_parameters TYPE (ld_class)
        EXPORTING
          initial_refdt = refdt
          input_object  = inputobj.

    CATCH cx_sy_create_object_error.
*
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '019'
          msgv1      = ld_class
        CHANGING
          return_tab = return_tab.

      EXIT.
  ENDTRY.

  CALL METHOD lref_sf_parameters->(ld_method)
    CHANGING
      parameters_tab = parameters_tab
      return_tab     = return_tab.

  DELETE ADJACENT DUPLICATES FROM return_tab.

ENDFUNCTION.
