FUNCTION ZABSF_PM_SET_OPERATOR.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(AUFNR) TYPE  AUFNR
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(OPERATOR_TAB) TYPE  ZABSF_PM_T_OPERADOR
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
*Variables
  DATA: l_langu TYPE spras.

*Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

*Check operator
  IF inputobj-pernr IS INITIAL.
    inputobj-pernr = inputobj-oprid.
  ENDIF.

*Assign or unassign operator to order PM
  CALL METHOD ZCL_ABSF_PM=>set_operator
    EXPORTING
      werks        = inputobj-werks
      aufnr        = aufnr
      pernr        = inputobj-pernr
      operator_tab = operator_tab
    CHANGING
      return_tab   = return_tab.
ENDFUNCTION.
