FUNCTION zabsf_pm_get_catalog_codes.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(I_NOTIFICATION_TYPE) TYPE  QMART
*"     VALUE(I_CATALOG_TYPE) TYPE  QKATART
*"     VALUE(I_CODE_GROUP) TYPE  QPGR-CODEGRUPPE OPTIONAL
*"     VALUE(I_CODE) TYPE  QPCD-CODE OPTIONAL
*"     VALUE(I_EQUNR) TYPE  EQUI-EQUNR OPTIONAL
*"  EXPORTING
*"     VALUE(ET_CODE_TAB) TYPE  ZABSF_PM_T_CATALOG_CODE_LIST
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

**  Variables
*  DATA:
*    lt_code_group_t TYPE TABLE OF qpk1codegrp,
*    lt_codes_t      TYPE TABLE OF qpk1cd.
**

  CALL METHOD zcl_absf_pm=>get_catalog_codes_list
    EXPORTING
      i_refdt             = refdt
      i_inputobj          = inputobj
      i_notification_type = i_notification_type
      i_catalog_type      = i_catalog_type
      i_code_group        = i_code_group
      i_code              = i_code
      i_equnr             = i_equnr
    IMPORTING
      et_code_tab         = et_code_tab
      et_returntab        = return_tab.

ENDFUNCTION.
