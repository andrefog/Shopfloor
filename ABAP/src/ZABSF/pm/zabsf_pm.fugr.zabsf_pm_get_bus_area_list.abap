FUNCTION ZABSF_PM_GET_BUS_AREA_LIST.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT OPTIONAL
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"     VALUE(ET_BUSINESS_AREAS) TYPE  ZABSF_PM_T_BUSINESS_AREA_LIST
*"----------------------------------------------------------------------

*  Variables
  DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

  CALL METHOD ZCL_ABSF_PM=>get_business_area_list
    EXPORTING
      i_refdt           = refdt
      i_inputobj        = inputobj
    IMPORTING
      et_return_tab        = return_tab
      et_business_areas = et_business_areas.




ENDFUNCTION.
