FUNCTION ZABSF_PM_GET_MOULDES.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM OPTIONAL
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(IS_FILTERS) TYPE  ZABSF_PM_S_PM_MOULDES_FILTER
*"  EXPORTING
*"     VALUE(ET_MOULDES) TYPE  ZABSF_PM_T_PM_MOULDES
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

*  Variables
    DATA: l_langu TYPE spras.

*  Set local language for user
    l_langu = inputobj-language.

    SET LOCALE LANGUAGE l_langu.

  CALL METHOD ZCL_ABSF_PM=>get_mouldes
    EXPORTING
      i_inputobj = inputobj
      is_filters = is_filters
    IMPORTING
      et_mouldes = et_mouldes.


ENDFUNCTION.
