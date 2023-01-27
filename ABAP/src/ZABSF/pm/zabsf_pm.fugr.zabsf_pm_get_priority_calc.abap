FUNCTION ZABSF_PM_GET_PRIORITY_CALC.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(I_ARTPR) TYPE  ARTPR
*"     VALUE(I_PRIOK) TYPE  PRIOK
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"     VALUE(E_PRIORITY_DATES) TYPE  ZABSF_PM_S_PRIORITY_CALC
*"----------------------------------------------------------------------

  DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.


  CALL METHOD ZCL_ABSF_PM=>get_priority_calc
    EXPORTING
      i_inputobj    = inputobj
      i_refdt       = refdt
      i_artpr       = i_artpr
      i_priok       = i_priok
    IMPORTING
      e_priority_dates = e_priority_dates.



ENDFUNCTION.
