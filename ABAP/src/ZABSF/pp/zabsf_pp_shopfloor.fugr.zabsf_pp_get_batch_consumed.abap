FUNCTION zabsf_pp_get_batch_consumed .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(AUFNR) TYPE  AUFNR
*"     VALUE(VORNR) TYPE  VORNR
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(FICHA) TYPE  ZABSF_PP_E_FICHA
*"     VALUE(TIME) TYPE  RU_ISDZ
*"     VALUE(BATCH_CONSUMED_TAB) TYPE  ZABSF_PP_T_BATCH_CONSUMED
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
*References
  DATA: lref_sf_consum TYPE REF TO zif_absf_pp_consumptions.



*Get class of interface
  SELECT SINGLE imp_clname, methodname
      FROM zabsf_pp003
      INTO (@DATA(l_class), @DATA(l_method))
     WHERE werks    EQ @inputobj-werks
       AND id_class EQ '24'
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
*Get batch consumed
    CALL METHOD lref_sf_consum->(l_method)
      EXPORTING
        aufnr              = aufnr
        vornr              = vornr
      IMPORTING
        ficha              = ficha
        time               = time
        batch_consumed_tab = batch_consumed_tab
      CHANGING
        return_tab         = return_tab.

    DELETE ADJACENT DUPLICATES FROM return_tab.
ENDFUNCTION.
