FUNCTION ZABSF_PM_GET_PRIORITIES_LIST.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(I_ARTPR) TYPE  ARTPR
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"     VALUE(ET_PRIORITIES) TYPE  ZABSF_PM_T_PRIORITIES_LIST
*"----------------------------------------------------------------------

  DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.


  CALL METHOD ZCL_ABSF_PM=>get_priorities
    EXPORTING
      i_inputobj         = inputobj
      i_artpr            = i_artpr
      i_refdt            = refdt
    IMPORTING
      et_priorities = et_priorities.






ENDFUNCTION.
