FUNCTION ZABSF_PP_CHECKMATNR.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(MATNR) TYPE  MATNR
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(MAKTX) TYPE  MAKTX
*"     VALUE(MEINS) TYPE  MEINS
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"     VALUE(XCHPF) TYPE  XCHPF
*"     VALUE(MEINS_OUTPUT) TYPE  MEINS
*"--------------------------------------------------------------------
DATA lref_sf_prdord TYPE REF TO zabsf_pp_cl_prdord.

  CREATE OBJECT lref_sf_prdord
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

  CALL METHOD lref_sf_prdord->check_material
    EXPORTING
      matnr        = matnr
    CHANGING
      maktx        = maktx
      meins        = meins
      xchpf        = xchpf
      meins_output = meins_output
      return_tab   = return_tab.





ENDFUNCTION.
