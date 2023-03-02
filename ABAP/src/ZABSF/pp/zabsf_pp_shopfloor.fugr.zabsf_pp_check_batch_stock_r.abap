FUNCTION ZABSF_PP_CHECK_BATCH_STOCK_R.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(ARBPL) TYPE  ARBPL
*"     VALUE(AUFNR) TYPE  AUFNR
*"     VALUE(VORNR) TYPE  VORNR
*"     VALUE(CHARG_T) TYPE  ZABSF_PP_T_BATCH_CONSUMPTION
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"--------------------------------------------------------------------
*Reference
  DATA: lref_sf_batch  TYPE REF TO zabsf_pp_cl_batch_operations.

*Create object of class
  CREATE OBJECT lref_sf_batch
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

*Get method of class to check stock batch
  SELECT SINGLE methodname
    FROM zabsf_pp003
    INTO (@DATA(l_method))
   WHERE werks    EQ @inputobj-werks
     AND id_class EQ '22'
     AND endda    GE @refdt
     AND begda    LE @refdt.

*Check stock batch
  CALL METHOD lref_sf_batch->(l_method)
    EXPORTING
      arbpl      = arbpl
      aufnr      = aufnr
      vornr      = vornr
      charg_t    = charg_t
    IMPORTING
      return_tab = return_tab.

  DELETE ADJACENT DUPLICATES FROM return_tab.





ENDFUNCTION.
