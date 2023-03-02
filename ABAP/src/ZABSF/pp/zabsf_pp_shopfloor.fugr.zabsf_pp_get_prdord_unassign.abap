FUNCTION zabsf_pp_get_prdord_unassign.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(ARBPL) TYPE  ARBPL
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"     VALUE(IT_STEUS_FILTERS) TYPE  STRING_TABLE OPTIONAL
*"  EXPORTING
*"     VALUE(PRDORD_UNASSIGN) TYPE  ZABSF_PP_T_PRODORD_UNASSIGN
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
*Reference
  DATA: lref_sf_prdord  TYPE REF TO zabsf_pp_cl_prdord.

*Create object of class
  CREATE OBJECT lref_sf_prdord
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

*Get method of class to get production order unassign
  SELECT SINGLE methodname
    FROM zabsf_pp003
    INTO (@DATA(l_method))
   WHERE werks    EQ @inputobj-werks
     AND id_class EQ '19'
     AND endda    GE @refdt
     AND begda    LE @refdt.

*Get production order unassign
  CALL METHOD lref_sf_prdord->(l_method)
    EXPORTING
      arbpl           = arbpl
      IT_STEUS_FILTERS = IT_STEUS_FILTERS
    CHANGING
      prdord_unassign = prdord_unassign
      return_tab      = return_tab.

  DELETE ADJACENT DUPLICATES FROM return_tab.
ENDFUNCTION.
