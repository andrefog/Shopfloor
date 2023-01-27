FUNCTION zabsf_pm_get_order_detail.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM OPTIONAL
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(I_AUFNR) TYPE  AUFNR
*"     VALUE(I_IS_MOULD_EXCH) TYPE  BOOLE_D OPTIONAL
*"  EXPORTING
*"     VALUE(E_ORDER_DETAIL) TYPE  ZABSF_PM_S_ORDER_PM
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA: ls_order_header TYPE zabsf_pm_s_order_list.

*  Variables
  DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

  CALL METHOD zcl_absf_pm=>get_order_detail
    EXPORTING
      i_refdt          = refdt
      i_inputobj       = inputobj
      i_aufnr          = i_aufnr
      i_is_mould_exch  = i_is_mould_exch
    IMPORTING
      e_order_header   = ls_order_header
      et_consumptions  = e_order_detail-consumptions
      e_notification   = e_order_detail-notification
      et_causes        = e_order_detail-causes
      et_subcauses     = e_order_detail-subcauses
      et_subequip      = e_order_detail-subequipments
      et_checklist     = e_order_detail-checklist
      et_stages        = e_order_detail-stages
      et_operator      = e_order_detail-operator_tab
      et_maint_history = e_order_detail-maint_history
      et_attach_list   = e_order_detail-attach_list
      e_equipment      = e_order_detail-equipment
      return_tab       = return_tab.

  MOVE-CORRESPONDING ls_order_header TO e_order_detail.

ENDFUNCTION.
