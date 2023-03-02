FUNCTION ZABSF_PP_SET_BOX_QUANTITY.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(AUFNR) TYPE  AUFNR
*"     VALUE(VORNR) TYPE  VORNR
*"     VALUE(AUFPL) TYPE  CO_AUFPL
*"     VALUE(APLZL) TYPE  CO_APLZL
*"     VALUE(BOXQTY) TYPE  ZABSF_PP_E_BOXQTY
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"--------------------------------------------------------------------
*Reference
  DATA lref_sf_prdord TYPE REF TO zabsf_pp_cl_prdord.

*Create object of class
  CREATE OBJECT lref_sf_prdord
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

*Get method of class to set box quantity
  SELECT SINGLE methodname
    FROM zabsf_pp003
    INTO (@DATA(l_method))
   WHERE werks    EQ @inputobj-werks
     AND id_class EQ '15'
     AND endda    GE @refdt
     AND begda    LE @refdt.

*Change box quantity
  CALL METHOD lref_sf_prdord->(l_method)
    EXPORTING
      aufnr      = aufnr
      vornr      = vornr
      aufpl      = aufpl
      aplzl      = aplzl
      boxqty     = boxqty
    IMPORTING
      return_tab = return_tab.

  DELETE ADJACENT DUPLICATES FROM return_tab.





ENDFUNCTION.
