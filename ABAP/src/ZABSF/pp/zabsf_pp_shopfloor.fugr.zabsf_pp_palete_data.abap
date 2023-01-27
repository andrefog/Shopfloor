FUNCTION zabsf_pp_palete_data.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(MATNR) TYPE  MATNR
*"     VALUE(BATCH) TYPE  CHARG_D
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(PALETE_DATA) TYPE  ZABSF_PALETE_DATA_TAB
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
*Reference
  DATA: lref_sf_prdord  TYPE REF TO zabsf_pp_cl_prdord.


*Create object of class
  CREATE OBJECT lref_sf_prdord
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

*Palete Data

CALL METHOD lref_sf_prdord->palete_data
  EXPORTING
    matnr       = matnr
    batch       = batch
  IMPORTING
    palete_data = palete_data
  CHANGING
    return_tab  = return_tab.


ENDFUNCTION.
