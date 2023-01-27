FUNCTION ZABSF_PM_CHANGE_ORDER_EQUIPMNT.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM OPTIONAL
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(I_AUFNR) TYPE  AUFNR
*"     VALUE(I_EQUNR) TYPE  EQUNR
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
*  Variables
  DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

  CALL METHOD ZCL_ABSF_PM=>change_order_equipment
    EXPORTING
      i_inputobj = inputobj
      i_aufnr    = i_aufnr
      i_equnr    = i_equnr
    IMPORTING
      et_return  = return_tab.

ENDFUNCTION.
