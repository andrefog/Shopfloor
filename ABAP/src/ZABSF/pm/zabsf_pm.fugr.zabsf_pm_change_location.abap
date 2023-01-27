FUNCTION ZABSF_PM_CHANGE_LOCATION.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM OPTIONAL
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(IT_MOULDES) TYPE  ZABSF_PM_T_MOULDE_LOCATION
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
*  Variables
  DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

  CALL METHOD ZCL_ABSF_PM=>change_moulde_location
    EXPORTING
      i_inputobj = inputobj
      it_mouldes = it_mouldes
    IMPORTING
      return_tab = return_tab.

ENDFUNCTION.
