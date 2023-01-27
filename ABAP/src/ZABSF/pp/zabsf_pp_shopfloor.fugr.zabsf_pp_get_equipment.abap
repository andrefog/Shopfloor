FUNCTION zabsf_pp_get_equipment .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(ARBPL) TYPE  ARBPL
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"     VALUE(EQUIPMENT_TAB) TYPE  ZABSF_PP_T_EQUIPMENT
*"----------------------------------------------------------------------


  DATA: lref_sf_maintenance TYPE REF TO zabsf_pp_cl_maintenance.

  CREATE OBJECT lref_sf_maintenance
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

  CALL METHOD lref_sf_maintenance->get_equipments_list
    EXPORTING
      arbpl      = arbpl
    IMPORTING
      equipments = equipment_tab
      return_tab = return_tab.
ENDFUNCTION.
