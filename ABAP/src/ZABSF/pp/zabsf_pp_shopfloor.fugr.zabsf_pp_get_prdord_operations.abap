FUNCTION zabsf_pp_get_prdord_operations.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_AUFNR) TYPE  AUFNR
*"     VALUE(IV_REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(IS_INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(ET_ORDEROPERATIONS) TYPE  ZABSF_PP_T_PRODORD_OPERATIONS
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
*Reference
  DATA: lref_sf_prdord  TYPE REF TO zabsf_pp_cl_prdord.

*Create object of class
  CREATE OBJECT lref_sf_prdord
    EXPORTING
      initial_refdt = iv_refdt
      input_object  = is_inputobj.

*Get method of class to get production order unassign
  SELECT SINGLE methodname
    FROM zabsf_pp003
    INTO (@DATA(l_method))
   WHERE werks    EQ @is_inputobj-werks
     AND id_class EQ '27'
     AND endda    GE @iv_refdt
     AND begda    LE @iv_refdt.

*Get production order unassign
  CALL METHOD lref_sf_prdord->(l_method)
    EXPORTING
      iv_aufnr           = iv_aufnr
    "CHANGING
    IMPORTING
      et_orderoperations = et_orderoperations
      et_return          = et_return.

  DELETE ADJACENT DUPLICATES FROM et_return.
ENDFUNCTION.
