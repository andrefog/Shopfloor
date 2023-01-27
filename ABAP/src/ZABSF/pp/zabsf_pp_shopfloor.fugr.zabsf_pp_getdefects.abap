FUNCTION zabsf_pp_getdefects .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(ARBPL) TYPE  ARBPL
*"     VALUE(MATNR) TYPE  MATNR OPTIONAL
*"     VALUE(AUFNR) TYPE  AUFNR OPTIONAL
*"     VALUE(VORNR) TYPE  VORNR OPTIONAL
*"     VALUE(REASONTYP) TYPE  ZABSF_PP_E_REASONTYP
*"     VALUE(FLAG_SCRAP_LIST) TYPE  FLAG OPTIONAL
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(DEFECTS_TAB) TYPE  ZABSF_PP_T_DEFECTS
*"     VALUE(REASON_TAB) TYPE  ZABSF_PP_T_REASON
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  DATA lref_sf_rework TYPE REF TO zabsf_pp_cl_rework.

*Create object for class - Rework
  CREATE OBJECT lref_sf_rework
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

*Get class of interface
  SELECT SINGLE methodname
    FROM zabsf_pp003
    INTO (@DATA(l_method))
   WHERE werks    EQ @inputobj-werks
     AND id_class EQ '14'
     AND endda    GE @refdt
     AND begda    LE @refdt.

*Get scrap list and defects list
  CALL METHOD lref_sf_rework->(l_method)
    EXPORTING
      arbpl           = arbpl
      matnr           = matnr
      aufnr           = aufnr
      vornr           = vornr
      reasontyp       = reasontyp
      flag_scrap_list = flag_scrap_list
    CHANGING
      defects_tab     = defects_tab
      reason_tab      = reason_tab
      return_tab      = return_tab.

  DELETE ADJACENT DUPLICATES FROM return_tab.
ENDFUNCTION.
