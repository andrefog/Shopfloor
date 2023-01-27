FUNCTION ZABSF_PM_GET_EQUIPMENTS_LIST.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(I_EQUNR) TYPE  EQUNR OPTIONAL
*"  EXPORTING
*"     VALUE(ET_EQUIPMENTS_LIST) TYPE  ZABSF_PM_T_EQUIPMENTS_LIST
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.


  CALL METHOD zcl_absf_pm=>get_equipment_list
    EXPORTING
      i_inputobj         = inputobj
      i_equnr            = i_equnr
      i_refdt            = refdt
    IMPORTING
      et_equipments_list = et_equipments_list.

ENDFUNCTION.
