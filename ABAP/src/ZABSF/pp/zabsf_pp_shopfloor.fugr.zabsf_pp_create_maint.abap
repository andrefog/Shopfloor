FUNCTION zabsf_pp_create_maint.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(ARBPL) TYPE  ARBPL
*"     VALUE(DESCRIPTION) TYPE  MATNR
*"     VALUE(EQUIPMENT) TYPE  EQUNR
*"     VALUE(BREAKDOWN) TYPE  BOOLE_D
*"     VALUE(COMMENTARY) TYPE  STRING
*"     VALUE(NOTIF_TYPE) TYPE  QMART OPTIONAL
*"     VALUE(REFDT) TYPE  VVDATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA: lref_sf_maintenance    TYPE REF TO zabsf_pp_cl_maintenance.

  CREATE OBJECT lref_sf_maintenance
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

  CALL METHOD lref_sf_maintenance->create_maintenance_notif
    EXPORTING
      notif_type  = notif_type
      arbpl       = arbpl
      description = description
      equipment   = equipment
      breakdown   = breakdown
      commentary  = commentary
    IMPORTING
      return_tab  = return_tab.

ENDFUNCTION.
