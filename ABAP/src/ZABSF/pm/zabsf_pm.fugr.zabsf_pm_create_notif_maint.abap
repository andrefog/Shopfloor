FUNCTION zabsf_pm_create_notif_maint.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(ARBPL) TYPE  ARBPL OPTIONAL
*"     VALUE(DESCRIPTION) TYPE  QMTXT
*"     VALUE(EQUIPMENT) TYPE  EQUNR OPTIONAL
*"     VALUE(BREAKDOWN) TYPE  BOOLE_D OPTIONAL
*"     VALUE(COMMENTARY) TYPE  STRING
*"     VALUE(NOTIF_TYPE) TYPE  QMART OPTIONAL
*"     VALUE(FUNC_LOC) TYPE  TPLNR OPTIONAL
*"     VALUE(REFDT) TYPE  VVDATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(SERV_TYPE) TYPE  ZABSF_PM_SERV_TYPE OPTIONAL
*"     VALUE(CODING_GRP) TYPE  QMGRP OPTIONAL
*"     VALUE(CODING_COD) TYPE  QMCOD OPTIONAL
*"     VALUE(CLIENT_ID) TYPE  QKUNUM OPTIONAL
*"     VALUE(SALESDOC_ID) TYPE  KDAUF OPTIONAL
*"     VALUE(SALESDOC_ITEM) TYPE  POSNR OPTIONAL
*"     VALUE(RSP_USER_RESP) TYPE  I_PARNR OPTIONAL
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  CALL METHOD zcl_absf_pm=>create_maintenance_notif
    EXPORTING
      i_inputobj      = inputobj
      i_refdt         = refdt
      i_notif_type    = notif_type
      i_arbpl         = arbpl
      i_description   = description
      i_equipment     = equipment
      i_breakdown     = breakdown
      i_func_loc      = func_loc
      i_commentary    = commentary
      i_serv_type     = serv_type
      i_coding_grp    = coding_grp
      i_coding_cod    = coding_cod
      i_client_id     = client_id
      i_salesdoc_id   = salesdoc_id
      i_salesdoc_item = salesdoc_item
      i_rsp_user_resp = rsp_user_resp
    CHANGING
      return_tab      = return_tab.

ENDFUNCTION.
