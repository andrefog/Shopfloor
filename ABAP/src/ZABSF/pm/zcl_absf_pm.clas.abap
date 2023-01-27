class ZCL_ABSF_PM definition
  public
  final
  create public .

public section.

  types:
    ty_notok_texts_table TYPE TABLE OF bapi2080_notfulltxti .

  class-methods ADD_CAUSE_TO_NOTITEM
    importing
      !I_NOT_ITEM type ZABSF_PM_S_NOT_ITEM
    exporting
      !ET_RETURNTAB type BAPIRET2_T .
  class-methods GET_PRIORITY_CALC
    importing
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT optional
      !I_REFDT type VVDATUM default SY-DATUM
      !I_ARTPR type ARTPR
      !I_PRIOK type PRIOK
    exporting
      !E_PRIORITY_DATES type ZABSF_PM_S_PRIORITY_CALC .
  class-methods DELETE_CAUSE_OF_NOTITEM
    importing
      !I_NOT_ITEM type ZABSF_PM_S_NOT_ITEM
    exporting
      !ET_RETURNTAB type BAPIRET2_T .
  class-methods CHANGE_ORDER
    importing
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT
      !I_REFDT type VVDATUM default SY-DATUM
      !I_AUFNR type AUFNR
      !I_PERNR type CO_PERNR optional
      !I_RSP_USER type CO_PERNR optional
    exporting
      !ET_RETURNTAB type BAPIRET2_T .
  class-methods GET_ORDERS_STATUS
    importing
      value(I_WERKS) type WERKS_D
      value(I_STAT_BLOCKED) type BOOLE_D optional
      value(I_STAT_CLOSED) type BOOLE_D optional
      value(I_STAT_PROCESSING) type BOOLE_D optional
      value(I_STAT_RELEASED) type BOOLE_D optional
      value(I_STAT_OPEN) type BOOLE_D optional
      value(I_STAT_STOPED) type BOOLE_D optional
      value(I_STAT_OTHERS) type BOOLE_D optional
      value(IT_ORDERS_LIST) type ZABSF_PM_ORDERS_STATUS_T
    exporting
      value(ET_ORDERS_LIST) type ZABSF_PM_ORDERS_STATUS_T .
  class-methods GET_NOTIFS_STATUS
    importing
      value(I_WERKS) type WERKS_D
      value(I_STAT_BLOCKED) type BOOLE_D optional
      value(I_STAT_CLOSED) type BOOLE_D optional
      value(I_STAT_PROCESSING) type BOOLE_D optional
      value(I_STAT_RELEASED) type BOOLE_D optional
      value(I_STAT_OPEN) type BOOLE_D optional
      value(I_STAT_STOPED) type BOOLE_D optional
      value(I_STAT_OTHERS) type BOOLE_D optional
      value(IT_NOTIFS_LIST) type ZABSF_PM_NOTIFS_STATUS_T
    exporting
      value(ET_NOTIFS_LIST) type ZABSF_PM_NOTIFS_STATUS_T .
  class-methods GET_ORDERS_TO_ASSOCIATE
    importing
      !I_REFDT type VVDATUM optional
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT optional
      !I_AUFNR type AUFNR optional
      !I_QMNUM type QMNUM
    exporting
      !ET_RETURN_TAB type BAPIRET2_T
      !ET_ORDERS type ZABSF_PM_T_ORDERS_TO_ASSOCIATE .
  class-methods GET_MAINTENANCE_HISTORY
    importing
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT optional
      !I_EQUNR type EQUNR optional
      !I_TPLNR type TPLNR optional
    exporting
      !ET_MAINT_HISTORY type ZABSF_PM_T_MAINT_HISTORY_LIST .
  class-methods GET_HR_USERLIST
    importing
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT optional
      !I_REFDT type VVDATUM default SY-DATUM
      !I_PERNR type PERSNO optional
      !I_ARBPL type ARBPL optional
    exporting
      !ET_USERSLIST type ZABSF_PM_T_HR_USER_LIST .
  class-methods GET_FUNC_LOCATIONS_TREE
    importing
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT optional
      !I_STEXT type CHAR30 optional
      !I_REFDT type VDATUM default SY-DATUM
    exporting
      !ET_FUNC_LOC_TREE type ZABSF_PM_T_FUN_LOC_EQU_LIST .
  class-methods GET_EQUIPMENT_TREE
    importing
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT optional
      !I_REFDT type VVDATUM default SY-DATUM
      !I_TPLNR type TPLNR optional
      !I_EQUNR type EQUNR optional
    exporting
      !ET_EQUIPMENTS_TREE type ZABSF_PM_T_FUN_LOC_EQU_LIST .
  class-methods GET_EQUIPMENT_LIST
    importing
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT optional
      !I_REFDT type VVDATUM default SY-DATUM
      !I_EQUNR type EQUNR optional
    exporting
      !ET_EQUIPMENTS_LIST type ZABSF_PM_T_EQUIPMENTS_LIST .
  class-methods GET_CONTRACTS
    importing
      !I_REFDT type VDATUM default SY-DATUM
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT optional
      !I_EQUNR type EQUNR optional
      !I_TPLNR type TPLNR optional
      !I_QMART type QMART optional
    exporting
      !ET_CUSTOMER_INFO type ZABSF_PM_T_CUSTOMER_INFO .
  class-methods GET_CATALOG_CODES_LIST
    importing
      !I_NOTIFICATION_TYPE type QMART
      !I_CATALOG_TYPE type QKATART
      !I_REFDT type VVDATUM
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT optional
      !I_CODE_GROUP type QPGR-CODEGRUPPE optional
      !I_CODE type QPCD-CODE optional
      !I_EQUNR type EQUI-EQUNR optional
    exporting
      !ET_CODE_TAB type ZABSF_PM_T_CATALOG_CODE_LIST
      !ET_RETURNTAB type BAPIRET2_T .
  class-methods GET_BUSINESS_AREA_LIST
    importing
      !I_REFDT type VVDATUM optional
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT optional
    exporting
      !ET_RETURN_TAB type BAPIRET2_T
      !ET_BUSINESS_AREAS type ZABSF_PM_T_BUSINESS_AREA_LIST .
  class-methods GET_ATTACHMENT_FILE
    importing
      value(I_GUID) type CHAR40 optional
      value(I_ATTA_ID) type GOS_ATTA_ID optional
      value(I_ATTA_CAT) type GOS_ATTA_CAT optional
    exporting
      value(E_FILE_EXTENSION) type CHAR10
      value(E_FILE_BASE64) type XSTRING
      value(E_FILE_MIMETYPE) type W3CONTTYPE .
  class-methods GET_ATTACHMENTS_LIST
    importing
      value(I_GOS_OBJ) type SIBFLPORB
    exporting
      value(ET_ATTACHMENTS) type ZABSF_PM_T_ATTACHMENT_LIST .
  class-methods DELETE_NOTIF_ITEM
    importing
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT optional
      !I_NOT_ITEM type ZABSF_PM_S_NOT_ITEM
    exporting
      !ET_RETURNTAB type BAPIRET2_T .
  class-methods ADD_NOTIF_ITEM
    importing
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT optional
      !I_NOT_ITEM type ZABSF_PM_S_NOT_ITEM
    exporting
      !ET_RETURNTAB type BAPIRET2_T .
  class-methods SET_ORDER_IN_NOTIFICATION
    importing
      !I_REFDT type VVDATUM default SY-DATUM
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT optional
      !I_AUFNR type AUFNR
      !I_QMNUM type QMNUM
    exporting
      !ET_RETURN_TAB type BAPIRET2_T .
  class-methods GET_SALES_DOCS_LIST
    importing
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT optional
      !I_VBELN type VBELN_VA optional
      !I_REFDT type VDATUM default SY-DATUM
    exporting
      !ET_SALESDOC type ZABSF_PM_T_SALESDOC_LIST .
  class-methods CHANGE_NOTIF_ITEM
    importing
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT optional
      !I_NOT_ITEM type ZABSF_PM_S_NOT_ITEM
      !I_CLEAR_FIELDS type ZABSF_PM_S_NOITEM_CLEAR_FIELDS optional
    exporting
      !ET_RETURNTAB type BAPIRET2_T .
  class-methods GET_RESP_USERLIST
    importing
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT optional
      !I_REFDT type VVDATUM default SY-DATUM
      !I_USERN type XUBNAME optional
      !I_ARBPL type ARBPL optional
    exporting
      !ET_USERSLIST type ZABSF_PM_T_RESP_USER_LIST .
  class-methods GET_PRIORITIES
    importing
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT optional
      !I_REFDT type VDATUM default SY-DATUM
      !I_ARTPR type ARTPR
    exporting
      !ET_PRIORITIES type ZABSF_PM_T_PRIORITIES_LIST .
  class-methods GET_PM_PLANNER_GROUPS
    importing
      !I_REFDT type VVDATUM default SY-DATUM
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT optional
      !I_IWERK type IWERK optional
      !I_INGRP type INGRP optional
    exporting
      !ET_RETURN_TAB type BAPIRET2_T
      !ET_PLANNER_GROUPS type ZABSF_PM_T_PM_PLANNER_GROUPS .
  class-methods CONV_SPOOL_LIST_2_TABLE
    importing
      !I_SPOOLN type BTCLISTID
      !I_KEEP_SUM_LINE type BOOLEAN default 'X'
      !I_START_TABLE type INT4 default 1
    changing
      !ET_SPOOL_TABLE type ANY TABLE .
  class-methods CREATE_PM_ORDER
    importing
      !I_AUART type AUFART
      !I_ILART type ILA optional
      !I_QMNUM type QMNUM
      !I_ARBPL type ARBPL
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT
      !I_ARBPL_PLANT type WERKS_D
      !I_GSBER type GSBER optional
      !I_RSP_USER_RESP type I_PARNR optional
    exporting
      !ET_RETURN_TAB type BAPIRET2_T .
  class-methods ADD_MESSAGE
    importing
      !MSGID type SYMSGID default 'ZABSF_PM'
      !MSGTY type SYMSGTY
      !MSGNO type SYMSGNO
      !MSGV1 type ANY optional
      !MSGV2 type ANY optional
      !MSGV3 type ANY optional
      !MSGV4 type ANY optional
    changing
      !RETURN_TAB type BAPIRET2_T .
  class-methods GET_EQUIPMENTS
    importing
      !I_WERKS type WERKS_D
      !I_ONLY_MOULDS type BOOLE_D
      !I_EQUNR type EQUNR optional
      !I_EQKTX type KTX01 optional
      !I_ARBPL type ARBPL optional
    exporting
      !ET_EQUIPMENT type ZABSF_PM_T_EQUIPMENTS_LIST .
  class-methods GET_FUNC_LOCATIONS
    importing
      !I_WERKS type WERKS_D
    exporting
      !ET_FUNC_LOCATION type ZABSF_PM_T_WCT_FUNC_LOC .
  class-methods GET_VARIANTS
    importing
      !I_WERKS type WERKS_D
      !I_PERNR type PERNR_D optional
      !I_LANGU type SPRAS
      !I_PROG type RSVAR-REPORT
    exporting
      !E_VAR_INFO type ZABSF_PM_T_VARIANT
      !ET_RETURN type BAPIRET2_T .
  class-methods GET_PM_ORDERS
    importing
      value(I_FILTERS) type ZABSF_PM_S_ORDERFILTER_OPTIONS optional
      value(I_AUFNR) type AUFNR optional
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT optional
      value(I_VARIANT) type VARIANT optional
    changing
      value(ET_ORDERS_LIST) type ZABSF_PM_T_ORDER_LIST
      value(ET_RETURNTAB) type BAPIRET2_T optional .
  class-methods GET_PM_ORDERS_MOULD_EXCHANGE
    importing
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT optional
      !I_DATE_START type DATS optional
      !I_DATE_END type DATS optional
    changing
      value(ET_ORDERS_LIST) type ZABSF_PM_T_ORDER_LIST .
  class-methods GET_ORDER_DETAIL
    importing
      !I_REFDT type VVDATUM
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT
      !I_AUFNR type AUFNR
      !I_IS_MOULD_EXCH type BOOLE_D
    exporting
      !E_ORDER_HEADER type ZABSF_PM_S_ORDER_LIST
      !ET_CONSUMPTIONS type ZABSF_PM_T_CONSUMPTIONS_LIST
      !E_NOTIFICATION type ZABSF_PM_S_NOTIFICATIONS
      !ET_CAUSES type ZABSF_PM_T_NOT_CAUSES_LIST
      !ET_SUBCAUSES type ZABSF_PM_T_NOT_SUBCAUSES_LIST
      !ET_SUBEQUIP type ZABSF_PM_T_SUB_EQUIPMENTS_LIST
      !ET_CHECKLIST type ZABSF_PM_T_CHECKLIST
      !ET_STAGES type ZABSF_PM_T_STAGES_LIST
      !ET_OPERATOR type ZABSF_PM_T_OPERADOR
      !ET_MAINT_HISTORY type ZABSF_PM_T_MAINT_HISTORY_LIST
      !ET_ATTACH_LIST type ZABSF_PM_T_ATTACHMENT_LIST
      !E_EQUIPMENT type ZABSF_PM_S_EQUIPMENT
      !RETURN_TAB type BAPIRET2_T .
  class-methods GET_PARAMETER
    importing
      !I_WERKS type WERKS_D
      !I_PARAMETER type PARAM_ID
    exporting
      !ET_RANGE type TABLE .
  class-methods GET_ORDER_TYPES
    importing
      !I_WERKS type WERKS_D
      !I_SERV_TYPE type ZABSF_PM_SERV_TYPE optional
      !I_FOR_CREATION type BOOLE_D optional
    exporting
      !ET_ORDER_TYPE type ZABSF_PM_T_ORDER_TYPES_LIST .
  class-methods GET_CONSUMPTIONS
    importing
      !I_WERKS type WERKS_D
      !I_AUFNR type AUFNR
    exporting
      !ET_CONSUMPTIONS type ZABSF_PM_T_CONSUMPTIONS_LIST .
  class-methods GET_NOTIFICATION
    importing
      !I_WERKS type WERKS_D optional
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT optional
      !I_REFDT type VDATUM default SY-DATUM
      !I_AUFNR type AUFNR optional
      !I_QMNUM type QMNUM optional
    exporting
      !E_NOTIFICATION type ZABSF_PM_S_NOTIFICATIONS .
  class-methods GET_NOTIF_CAUSES
    importing
      !I_WERKS type WERKS_D
    exporting
      !ET_CAUSES type ZABSF_PM_T_NOT_CAUSES_LIST
      !ET_SUBCAUSES type ZABSF_PM_T_NOT_SUBCAUSES_LIST .
  class-methods GET_NOTIF_TYPES
    importing
      !I_WERKS type WERKS_D
      !I_SERV_TYPE type CHAR2
    exporting
      !ET_NOTIF_TYPES type ZABSF_PM_T_NOTIF_TYPES .
  class-methods GET_ORDER_HEADER
    importing
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT
      !I_AUFNR type AUFNR
      !I_IS_MOULD_EXCH type BOOLE_D optional
    exporting
      !E_ORDER_HEADER type ZABSF_PM_S_ORDER_LIST .
  class-methods GET_MACHINE_SUBEQUIP
    importing
      !I_WERKS type WERKS_D
      !I_EQUNR type EQUNR
    exporting
      !ET_SUBEQUIP type ZABSF_PM_T_SUB_EQUIPMENTS_LIST .
  class-methods GET_STAGES_MOULDEXCH
    importing
      !I_REFDT type VVDATUM optional
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT
      !I_EQUNR type EQUNR
      !I_MACH_EQUNR type EQUNR
      !I_AUFNR type AUFNR
    exporting
      !ET_STAGES type ZABSF_PM_T_STAGES_LIST
      !E_CURRENT_STAGE type LTXA1 .
  class-methods GET_MATERIALS
    importing
      !I_WERKS type WERKS_D
      !I_MATNR type MATNR optional
      !I_MAKTX type MAKTX optional
    exporting
      !ET_MATERIALS type ZABSF_PM_T_MATERIALS_LIST .
  class-methods CHANGE_NOTIF
    importing
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT optional
      !I_NOTIF_ID type QMNUM
      !I_DESCRIP type QMTXT optional
      !I_CAUSE type URGRP optional
      !I_SUBCAUSE type URCOD optional
      !IT_LONGTEXTS type ZABSF_PM_T_NOTE_TEXT_LONG optional
      !I_CAUSE_TEXT type URSTX optional
      !I_CLOSE_NOTIF type BOOLE_D optional
      value(I_SERV_TYPE) type ZABSF_PM_SERV_TYPE optional
      value(I_CODING_GRP) type QMGRP optional
      value(I_CODING_COD) type QMCOD optional
      value(I_EQUIPMENT) type EQUNR optional
      value(I_FUNC_LOC) type TPLNR optional
      value(I_PLAN_GRP) type INGRP optional
      value(I_PLAN_DIV) type IWERK optional
      value(I_MAIN_WKCTR) type GEWRK optional
      value(I_RESP_DIV) type WERKS_D optional
      value(I_USER_RESP) type I_PARNR optional
      value(I_REQDATE_START) type STRMN optional
      value(I_REQTIME_START) type STRUR optional
      value(I_REQDATE_END) type LTRMN optional
      value(I_REQTIME_END) type LTRUR optional
      value(I_PRIOK) type PRIOK optional
      value(I_CLIENT_ID) type QKUNUM optional
      value(I_SALESDOC_ID) type KDAUF optional
      value(I_SALESDOC_ITEM) type POSNR optional
      value(I_BREAKDOWN) type MSAUS optional
      value(I_MALF_END_DATE) type AUSBS optional
      value(I_MALF_END_TIME) type AUZTB optional
      value(I_MALF_START_DATE) type AUSVN optional
      value(I_MALF_START_TIME) type AUZTV optional
      value(I_CLEAR_FIELDS) type ZABSF_PM_NOTIF_CLEAR_FIELDS optional
    exporting
      !ET_RETURNTAB type BAPIRET2_T .
  class-methods CREATE_CONSUMPTIONS
    importing
      !I_AUFNR type AUFNR
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT
      !IT_CONSUMPTIONS type ZABSF_PM_T_CONSUMPTIONS_LIST
    exporting
      !RETURN_TAB type BAPIRET2_T .
  class-methods GET_LOCATIONS
    importing
      !I_REFDT type VVDATUM optional
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT
    exporting
      !ET_LOCATIONS type ZABSF_PM_T_LOCATIONS .
  class-methods GET_NOTIFICATIONS_LIST
    importing
      !I_REFDT type VVDATUM optional
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT
      !IS_FILTERS type ZABSF_PM_S_NOTIFFILTER_OPTIONS
      !I_VARIANT type VARIANT optional
    changing
      !ET_NOTIFICATIONS type ZABSF_PM_T_NOTIF_LIST
      !ET_RETURNTAB type BAPIRET2_T .
  class-methods GET_WORKCENTERS
    importing
      !I_REFDT type VVDATUM optional
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT
      !I_VERWE type AP_VERWE optional
      !I_IWERK type IWERK optional
      !I_ARBPL type ARBPL optional
    exporting
      !ET_WORKCENTER type ZABSF_PM_T_WRKCTR .
  class-methods GET_PM_ACTIVITIES
    importing
      !I_REFDT type VVDATUM optional
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT
    exporting
      !ET_ACTIVITIES type ZABSF_PM_T_PM_ACTIVITIES .
  class-methods GET_MOULDES
    importing
      !I_REFDT type VVDATUM optional
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT
      !IS_FILTERS type ZABSF_PM_S_PM_MOULDES_FILTER
    exporting
      !ET_MOULDES type ZABSF_PM_T_PM_MOULDES .
  class-methods CHANGE_ORDER_EQUIPMENT
    importing
      !I_REFDT type VVDATUM optional
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT
      !I_AUFNR type AUFNR
      !I_EQUNR type EQUNR
    exporting
      !ET_RETURN type BAPIRET2_T .
  class-methods CHANGE_MOULDE_LOCATION
    importing
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT
      !IT_MOULDES type ZABSF_PM_T_MOULDE_LOCATION
    exporting
      !RETURN_TAB type BAPIRET2_T .
  class-methods INSTALL_EQUIPMENT_ON_MACHINE
    importing
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT
      !I_EQUIPMENT type EQUNR
      !I_MACHINE type EQUNR
    exporting
      !ET_RETURN type BAPIRET2_T .
  class-methods UNINSTALL_EQPMT_FROM_MACHINE
    importing
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT
      !I_EQUIPMENT type EQUNR
      !I_MACHINE type EQUNR
    exporting
      !ET_RETURN type BAPIRET2_T .
  class-methods GET_CHECKLIST
    importing
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT optional
      !PM_ORDER type AUFNR
      !CHECKLIST_STEP type VORNR
    changing
      !CHECKLIST type ZABSF_PM_T_CHECKLIST
      !RETURN_TAB type BAPIRET2_T .
  class-methods SET_CHECKLIST
    importing
      value(I_INPUTOBJ) type ZABSF_PM_S_INPUTOBJECT
      value(PM_ORDER) type AUFNR
      value(OBSERVATIONS) type STRING optional
    changing
      value(CHECKLIST) type ZABSF_PM_T_CHECKLIST
      !RETURN_TAB type BAPIRET2_T .
  class-methods SET_ZMLD_CHECKLIST
    importing
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT
      !IT_CHECKLIST type ZABSF_PM_T_CHECKLIST optional
      !I_AUFNR type AUFNR
      !I_MAIN_STEP type VORNR
      !I_EQUIPMENT type EQUNR optional
      !I_MACHINE type EQUNR optional
      !IS_LOCATION type ZABSF_PM_S_MOULDE_LOCATION optional
      !I_STATUS type CHAR4
    exporting
      !RETURN_TAB type BAPIRET2_T .
  class-methods GET_MOULDE_LOCATION
    importing
      !I_EQUNR type EQUNR
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT
    exporting
      !E_STORT type PMLOC
      !E_KTEXT type TEXT40
      !E_EQFNR type EQFNR .
  class-methods CHANGE_EQUIPMENT_STATUS
    importing
      !I_EQUNR type EQUNR
      !I_STATUS type J_STATUS
    exporting
      !RETURN_TAB type BAPIRET2_T .
  class-methods SET_OPERATOR
    importing
      !WERKS type WERKS_D
      !AUFNR type AUFNR
      !PERNR type PERNR_D
      !OPERATOR_TAB type ZABSF_PM_T_OPERADOR
    changing
      !RETURN_TAB type BAPIRET2_T .
  class-methods GET_OPERATOR
    importing
      !WERKS type WERKS_D
      !AUFNR type AUFNR
    exporting
      !OPERATOR_TAB type ZABSF_PM_T_OPERADOR .
  class-methods SET_REG_TIME
    importing
      !I_AUFNR type AUFNR
      !I_DATE type DATUM
      !I_TIME type ATIME
      !I_ACTV_ID type ZABSF_PM_E_ACTV
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT
    exporting
      !RETURN_TAB type BAPIRET2_T .
  class-methods CALC_MINUTES
    importing
      !DATE type DATUM
      !TIME type PR_TIME
      !PROC_DATE type DATUM
      !PROC_TIME type PR_TIME
    changing
      !ACTIVITY type RU_ISMNG
      !RETURN_TAB type BAPIRET2_T .
  class-methods CREATE_MAINTENANCE_NOTIF
    importing
      value(I_INPUTOBJ) type ZABSF_PM_S_INPUTOBJECT
      value(I_ARBPL) type ARBPL optional
      value(I_REFDT) type VVDATUM optional
      value(I_DESCRIPTION) type QMTXT
      value(I_EQUIPMENT) type EQUNR
      value(I_BREAKDOWN) type BOOLE_D optional
      value(I_NOTIF_TYPE) type QMART optional
      value(I_COMMENTARY) type STRING optional
      value(I_FUNC_LOC) type TPLNR optional
      value(IT_NOT_OK_TEXTS) type TY_NOTOK_TEXTS_TABLE optional
      value(I_SERV_TYPE) type ZABSF_PM_SERV_TYPE optional
      value(I_CODING_GRP) type QMGRP optional
      value(I_CODING_COD) type QMCOD optional
      value(I_CLIENT_ID) type QKUNUM optional
      value(I_SALESDOC_ID) type KDAUF optional
      value(I_SALESDOC_ITEM) type POSNR optional
      value(I_RSP_USER_RESP) type I_PARNR optional
    changing
      value(RETURN_TAB) type BAPIRET2_T .
  class-methods CHECK_ORDER_PM_ACTIVITY
    importing
      value(I_AUFNR) type AUFNR
    exporting
      value(E_UPDATE) type BOOLE_D .
  class-methods CHECK_IF_MOULDE_IS_CLEAN
    importing
      value(I_AUFNR) type AUFNR
    exporting
      value(E_ERROR) type BOOLE_D .
  class-methods CHECK_MOULDE_CHARACTS_EQUIP
    importing
      value(I_AUFNR) type AUFNR
      value(I_EQUIPMENT) type EQUNR
      value(I_MACHINE) type EQUNR optional
      value(I_WERKS) type WERKS_D
    changing
      value(RETURN_TAB) type BAPIRET2_T .
  class-methods GET_MATERIALS_STOCK
    importing
      !I_WERKS type WERKS_D
      !I_MATNR type MATNR optional
      !I_MAKTX type MAKTX optional
    exporting
      !ET_MATERIAL_STOCK type ZABSF_PM_T_MATERIALS_STCK .
  class-methods CHANGE_EQUI_STATUS
    importing
      value(I_EQUNR) type EQUNR
      value(I_OPERATION) type CHAR3
      value(I_WERKS) type WERKS_D .
  class-methods CREATE_PR
    importing
      !I_AUFNR type AUFNR
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT
      !IT_CONSUMPTIONS type ZABSF_PM_T_CONSUMPTIONS_LIST
    exporting
      !RETURN_TAB type BAPIRET2_T .
  class-methods PRINT_PM_ORDER
    importing
      !I_AUFNR type AUFNR
      !I_INPUTOBJ type ZABSF_PM_S_INPUTOBJECT
    exporting
      !ET_RETURN_TAB type BAPIRET2_T .
protected section.

  constants OPRID_STATUS_INACTIVE type ZABSF_PM_E_STATUS value 'I' ##NO_TEXT.
  constants OPRID_STATUS_ACTIVE type ZABSF_PM_E_STATUS value 'A' ##NO_TEXT.
private section.

  constants GC_START type ZABSF_PM_E_ACTV value 'START' ##NO_TEXT.
  constants GC_CONC_PARC type ZABSF_PM_E_ACTV value 'END_PARC' ##NO_TEXT.
  constants GC_CONC type ZABSF_PM_E_ACTV value 'CONC' ##NO_TEXT.
ENDCLASS.



CLASS ZCL_ABSF_PM IMPLEMENTATION.


  METHOD add_cause_to_notitem.

    DATA : lf_no_commit TYPE flag.

    DATA : lt_notifcaus_i TYPE TABLE OF bapi2080_notcausi,
           ls_notifcaus_i TYPE bapi2080_notcausi.

    DATA: lt_return TYPE bapiret2_t,
          ls_return LIKE LINE OF lt_return.

    SELECT MAX( urnum ) INTO @DATA(lv_causekey)
      FROM qmur WHERE qmnum EQ @i_not_item-notif_no
      AND fenum EQ @i_not_item-item_key.

    lv_causekey = lv_causekey + 1.


    "Causas
    ls_notifcaus_i-item_key = i_not_item-item_key.
    ls_notifcaus_i-item_sort_no = i_not_item-item_sort_no.

    ls_notifcaus_i-cause_key = lv_causekey.
    ls_notifcaus_i-cause_sort_no = lv_causekey.

    ls_notifcaus_i-causetext = i_not_item-causetext.
    ls_notifcaus_i-cause_code = i_not_item-cause_code.
    ls_notifcaus_i-cause_codegrp = i_not_item-cause_codegrp.

    APPEND ls_notifcaus_i TO lt_notifcaus_i.

    CALL FUNCTION 'BAPI_ALM_NOTIF_DATA_ADD'
      EXPORTING
        number    = i_not_item-notif_no
      TABLES
        notifcaus = lt_notifcaus_i
        return    = lt_return.

    LOOP AT lt_return INTO ls_return
       WHERE type CA 'AEX'.

      CALL METHOD zcl_absf_pm=>add_message
        EXPORTING
          msgid      = ls_return-id
          msgty      = ls_return-type
          msgno      = ls_return-number
          msgv1      = ls_return-message_v1
          msgv2      = ls_return-message_v2
          msgv3      = ls_return-message_v3
          msgv4      = ls_return-message_v4
        CHANGING
          return_tab = et_returntab.

      CLEAR ls_return.
      lf_no_commit = abap_true.

    ENDLOOP.

    "if error don´t go further
    CHECK lf_no_commit EQ abap_false.

    CALL FUNCTION 'BAPI_ALM_NOTIF_SAVE'
      EXPORTING
        number = i_not_item-notif_no
      TABLES
        return = lt_return.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.

*Send Message : Item added to notification nº &1!
    CALL METHOD zcl_absf_pm=>add_message
      EXPORTING
        msgty      = 'S'
        msgno      = '033'
        msgv1      = i_not_item-item_sort_no
      CHANGING
        return_tab = et_returntab.


  ENDMETHOD.


  METHOD add_message.

*  FIELD-SYMBOLS <return> TYPE bapiret2.
*
    DATA: l_msgv1 TYPE symsgv,
          l_msgv2 TYPE symsgv,
          l_msgv3 TYPE symsgv,
          l_msgv4 TYPE symsgv.

*For conversion purposes
    l_msgv1 = msgv1.
    l_msgv2 = msgv2.
    l_msgv3 = msgv3.
    l_msgv4 = msgv4.

*Append line to return table
    APPEND INITIAL LINE TO return_tab ASSIGNING FIELD-SYMBOL(<return>).

*Convert the
    CALL FUNCTION 'BALW_BAPIRETURN_GET2'
      EXPORTING
        type   = msgty
        cl     = msgid
        number = msgno
        par1   = l_msgv1
        par2   = l_msgv2
        par3   = l_msgv3
        par4   = l_msgv4
      IMPORTING
        return = <return>.


    CALL FUNCTION 'FORMAT_MESSAGE'
      EXPORTING
        id        = msgid
        lang      = sy-langu
        no        = msgno
        v1        = msgv1
        v2        = msgv2
        v3        = msgv3
        v4        = msgv4
      IMPORTING
        msg       = <return>-message
      EXCEPTIONS
        not_found = 1
        OTHERS    = 2.
  ENDMETHOD.


  METHOD add_notif_item.

    DATA : lf_no_commit TYPE flag.

    DATA : lt_notitem_i TYPE TABLE OF bapi2080_notitemi,
           ls_notitem_i TYPE bapi2080_notitemi.

    DATA : lt_notifcaus_i TYPE TABLE OF bapi2080_notcausi,
           ls_notifcaus_i TYPE bapi2080_notcausi.

    DATA: lt_return TYPE bapiret2_t,
          ls_return LIKE LINE OF lt_return.

    MOVE-CORRESPONDING i_not_item TO ls_notitem_i.

    SELECT MAX( posnr ) INTO @DATA(lv_itemkey)
      FROM qmfe WHERE qmnum EQ @i_not_item-notif_no.

    lv_itemkey = lv_itemkey + 1.

    ls_notitem_i-item_sort_no = lv_itemkey.
    "ls_notitem_i-item_key = lv_itemkey.

    APPEND ls_notitem_i TO lt_notitem_i.

    "Causas
    "verify if there is a need to insert cause
    IF i_not_item-cause_codegrp IS NOT INITIAL OR
       i_not_item-causetext IS NOT INITIAL.

      "ls_notifcaus_i-item_key = lv_itemkey.
      ls_notifcaus_i-item_sort_no = lv_itemkey.

      ls_notifcaus_i-cause_key = '0001'.
      ls_notifcaus_i-cause_sort_no = '0001'.
      ls_notifcaus_i-causetext = i_not_item-causetext.
      ls_notifcaus_i-cause_code = i_not_item-cause_code.
      ls_notifcaus_i-cause_codegrp = i_not_item-cause_codegrp.

      APPEND ls_notifcaus_i TO lt_notifcaus_i.

    ELSE."theres no need to insert cause, because there are no data grom shopfloor

      CLEAR : ls_notifcaus_i, lt_notifcaus_i.

    ENDIF.


    CALL FUNCTION 'BAPI_ALM_NOTIF_DATA_ADD'
      EXPORTING
        number    = i_not_item-notif_no
      TABLES
        notitem   = lt_notitem_i
        notifcaus = lt_notifcaus_i
        return    = lt_return.

    LOOP AT lt_return INTO ls_return
       WHERE type CA 'AEX'.

      CALL METHOD zcl_absf_pm=>add_message
        EXPORTING
          msgid      = ls_return-id
          msgty      = ls_return-type
          msgno      = ls_return-number
          msgv1      = ls_return-message_v1
          msgv2      = ls_return-message_v2
          msgv3      = ls_return-message_v3
          msgv4      = ls_return-message_v4
        CHANGING
          return_tab = et_returntab.

      CLEAR ls_return.
      lf_no_commit = abap_true.

    ENDLOOP.

    "if error don´t go further
    CHECK lf_no_commit EQ abap_false.

    CALL FUNCTION 'BAPI_ALM_NOTIF_SAVE'
      EXPORTING
        number = i_not_item-notif_no
      TABLES
        return = lt_return.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.

*Send Message : Item added to notification nº &1!
    CALL METHOD zcl_absf_pm=>add_message
      EXPORTING
        msgty      = 'S'
        msgno      = '027'
        msgv1      = i_not_item-notif_no
      CHANGING
        return_tab = et_returntab.

  ENDMETHOD.


  METHOD calc_minutes.
*Variables
    DATA: l_date1      TYPE cva_date,
          l_date2      TYPE cva_date,
          l_time1      TYPE cva_time,
          l_time2      TYPE cva_time,
          l_days       TYPE i,
          l_time       TYPE cva_time,
          l_time_c(10).

*Dates and time to calculate
    l_date1 = date.
    l_date2 = proc_date.
    l_time1 = time.
    l_time2 = proc_time.

*Validar se a hora indicada não é anterior ao último registo, apenas no caso
*da hora estar a ser introduzida pelo utilizador
    IF l_date1 EQ l_date2 AND l_time2+4(2) EQ '00'.
      IF l_time1 > l_time2.

        CONCATENATE l_time1(2) l_time1+2(2) l_time1+4(2) INTO l_time_c SEPARATED BY ':'.

        CALL METHOD zcl_absf_pm=>add_message
          EXPORTING
            msgty      = 'E'
            msgno      = '015'
            msgv1      = l_time_c
          CHANGING
            return_tab = return_tab.

        EXIT.
      ENDIF.
    ENDIF.

*  Calculated time difference
    CALL FUNCTION 'SCOV_TIME_DIFF'
      EXPORTING
        im_date1              = l_date1
        im_date2              = l_date2
        im_time1              = l_time1
        im_time2              = l_time2
      IMPORTING
        ex_days               = l_days
        ex_time               = l_time
      EXCEPTIONS
        start_larger_than_end = 1
        OTHERS                = 2.

    IF sy-subrc <> 0.
*   Implement suitable error handling here
      CALL METHOD zcl_absf_pm=>add_message
        EXPORTING
          msgid      = sy-msgid
          msgty      = sy-msgty
          msgno      = sy-msgno
          msgv1      = sy-msgv1
          msgv2      = sy-msgv2
          msgv3      = sy-msgv3
          msgv4      = sy-msgv4
        CHANGING
          return_tab = return_tab.

    ELSE.
*    Calculated time of activity in minutes ( 1440 min for day, 60 sec for minute)
      activity = ( l_days * 1440 ) + ( l_time / 60 ).
    ENDIF.
  ENDMETHOD.


  METHOD change_equipment_status.

    CONSTANTS: c_aseq(5) VALUE 'I0116'.

    DATA: lt_system_status TYPE TABLE OF bapi_itob_status,
          ls_system_status TYPE bapi_itob_status,
          lt_status        TYPE TABLE OF jstat,
          ls_status        LIKE LINE OF lt_status,
          lt_user_status   TYPE TABLE OF asttx.

    DATA: lv_objnr  TYPE j_objnr.

    CALL FUNCTION 'BAPI_EQUI_GETSTATUS'
      EXPORTING
        equipment     = i_equnr
        language      = sy-langu
      TABLES
        system_status = lt_system_status
        user_status   = lt_user_status.

    READ TABLE lt_system_status INTO ls_system_status WITH KEY status = c_aseq.
    IF sy-subrc EQ 0.
* send error message!

      CALL METHOD zcl_absf_pm=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '007'
          msgv1      = i_equnr
        CHANGING
          return_tab = return_tab.

      EXIT.
    ELSE.
* change status

      CONCATENATE 'IE' i_equnr INTO lv_objnr.
      ls_status-stat = i_status.
      APPEND ls_status TO lt_status.

      CALL FUNCTION 'STATUS_CHANGE_INTERN_VB'
        EXPORTING
          objnr  = lv_objnr
        TABLES
          status = lt_status.

    ENDIF.


  ENDMETHOD.


  METHOD change_equi_status.

    DATA: lv_status_disp   TYPE tj30-estat,
          lv_status_ofic   TYPE tj30-estat,

          lv_status_inactive type tj30-estat,
          lv_status_active type tj30-estat,

          lv_status_schema TYPE tj30-stsma,
          lv_parva         TYPE zabsf_pm_param-parva.



* get value from parameter USER_STAT_CHKIN
    SELECT SINGLE parva
      INTO lv_parva
      FROM zabsf_pm_param
      WHERE werks = i_werks AND
            parid = 'USER_STAT_CHKIN'.

    MOVE lv_parva TO lv_status_disp.

* get value from parameter USER_STAT_CHKOUT
    SELECT SINGLE parva
      INTO lv_parva
      FROM zabsf_pm_param
      WHERE werks = i_werks AND
            parid = 'USER_STAT_CHKOUT'.

    MOVE lv_parva TO lv_status_ofic.

* get value from parameter USER_STAT_PROFILE
    SELECT SINGLE parva
      INTO lv_parva
      FROM zabsf_pm_param
      WHERE werks = i_werks AND
            parid = 'USER_STAT_PROFILE'.

    MOVE lv_parva TO lv_status_schema.


    SELECT SINGLE equi~objnr, equi~eqtyp
      FROM equi

      INTO ( @DATA(lv_equi_objnr), @DATA(lv_eqtyp) )
      WHERE equi~equnr = @i_equnr.

    IF lv_eqtyp = 'F'.

      CASE i_operation.
        WHEN 'IN'. " checkin equipment to status OFIC

          lv_status_inactive = lv_status_disp.
          lv_status_active = lv_status_ofic.

        WHEN 'OUT'." checkout equipemnt to status DISP

          lv_status_inactive = lv_status_ofic.
          lv_status_active = lv_status_disp.

        WHEN OTHERS.
      ENDCASE.

      CALL FUNCTION 'I_CHANGE_STATUS'
        EXPORTING
          objnr          = lv_equi_objnr
          estat_inactive = lv_status_inactive
          estat_active   = lv_status_active
          stsma          = lv_status_schema
        EXCEPTIONS
          cannot_update  = 1
          OTHERS         = 2.

      IF sy-subrc <> 0.
*        * Implement suitable error handling here
      ENDIF.

    ENDIF.


  ENDMETHOD.


  METHOD change_moulde_location.

    DATA: ls_mouldes    LIKE LINE OF it_mouldes,
          ls_location   TYPE bapi_iloa,
          ls_location_x TYPE bapi_iloa_x,
          ls_return     TYPE bapireturn,
          ls_return_tab LIKE LINE OF return_tab.


    LOOP AT it_mouldes INTO ls_mouldes.

      ls_location_x-maintloc = abap_true.
      ls_location_x-sortfield = abap_true.

      IF ls_mouldes-stort IS NOT INITIAL.
        ls_location-maintloc = ls_mouldes-stort.
      ENDIF.

      IF ls_mouldes-eqfnr IS NOT INITIAL.
        ls_location-sortfield = ls_mouldes-eqfnr.
      ENDIF.

      CALL FUNCTION 'BAPI_EQMT_MODIFY'
        EXPORTING
          equipment      = ls_mouldes-equnr
          equilocation   = ls_location
          equilocation_x = ls_location_x
        IMPORTING
          return         = ls_return.

      IF ls_return-type CA 'AEX'.

        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

        ls_return_tab-message = ls_return-message.
        ls_return_tab-type = ls_return-type.
        APPEND ls_return_tab TO return_tab.
        CLEAR: ls_return, ls_return_tab.

      ELSE.

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = abap_true.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            input  = ls_mouldes-equnr
          IMPORTING
            output = ls_mouldes-equnr.

        CALL METHOD zcl_absf_pm=>add_message
          EXPORTING
            msgty      = 'S'
            msgno      = '002'
            msgv1      = ls_mouldes-equnr
          CHANGING
            return_tab = return_tab.

      ENDIF.

      CLEAR: ls_mouldes, ls_location, ls_location_x.
    ENDLOOP.


  ENDMETHOD.


  method change_notif.

    constants: lv_part_soldto  type parvw   value 'AG', "Partner: Sold-to Party
               lv_part_useresp type parvw   value 'VU', "Partner: User Responsable
               lv_werks        type werks_d value 'CIMO'.

    data: lv_objkey         type objkey,
          lf_no_commit      type flag,
          lv_changes_exists type flag value abap_false,
          from_shopfloor    type boole_d.

    data: ls_notif_header   type bapi2080_nothdri,
          ls_notif_header_x type bapi2080_nothdri_x,
          lt_notpartnr_i    type standard table of bapi2080_notpartnri,
          ls_notpartnr_i    like line of lt_notpartnr_i,
          lt_notpartnr_ix   type standard table of bapi2080_notpartnri_x,
          ls_notpartnr_ix   like line of lt_notpartnr_ix,
          lt_notitem        type standard table of bapi2080_notitemi,
          lt_notifcaus      type standard table of bapi2080_notcause,
          ls_notifcaus      like line of lt_notifcaus,
          lt_notifcaus_i    type table of bapi2080_notcausi,
          ls_notifcaus_i    type bapi2080_notcausi,
          lt_notifcaus_ix   type standard table of bapi2080_notcausi_x,
          ls_notifcaus_ix   type bapi2080_notcausi_x,
          ls_longtexts      like line of it_longtexts,
          lt_longtext_i     type table of bapi2080_notfulltxti,
          ls_longtext_i     type bapi2080_notfulltxti,
          lt_old_partner    type table of bapi2080_notpartnre,
          ls_old_partner    type bapi2080_notpartnre.

    data: lt_return type bapiret2_t,
          ls_return like line of lt_return.

    data: ls_syst     type bapi2080_notsti,
          lv_name     type vornamc,
          lv_lastname type nachnmc.

    data: ls_notif_header_export type bapi2080_nothdre.


** -> NOTIFICATION HEADER
    if i_descrip is not initial.
      ls_notif_header-short_text   = i_descrip.
      ls_notif_header_x-short_text = abap_true.
    endif.

    if i_coding_grp is not initial.
      ls_notif_header-code_group   = i_coding_grp.
      ls_notif_header_x-code_group = abap_true.
    endif.

    if i_coding_cod is not initial.
      ls_notif_header-coding   = i_coding_cod.
      ls_notif_header_x-coding = abap_true.
    endif.

    if i_func_loc is not initial.

      if i_equipment is not initial or i_equipment = ''.
        ls_notif_header-equipment   = i_equipment.
        ls_notif_header_x-equipment = abap_true.
      endif.

      "Check if Func. Loc. exists since BAPI doesn't perform that check
      select single iloan into @data(lv_iloan)
        from iloa
        where tplnr = @i_func_loc.
      if sy-subrc <> 0.
*      MESSAGE e030(ZABSF_PM).
        call method zcl_absf_pm=>add_message
          exporting
            msgty      = 'E'
            msgno      = '30'
          changing
            return_tab = et_returntab.
        return.
      else.
        ls_notif_header-funct_loc   = i_func_loc.
        ls_notif_header_x-funct_loc = abap_true.
      endif.
    endif.

    if i_plan_grp is not initial or i_clear_fields-plan_grp = abap_true.
      ls_notif_header-plangroup   = i_plan_grp.
      ls_notif_header_x-plangroup = abap_true.
    endif.

    "Planification plan
    if i_plan_div is not initial or i_clear_fields-plan_div = abap_true.
      ls_notif_header-planplant   = i_plan_div.
      ls_notif_header_x-planplant = abap_true.

      if i_clear_fields-plan_div = abap_true.
        ls_notif_header-plangroup   = ''.
        ls_notif_header_x-plangroup = abap_true.
      endif.
    endif.

    "Maintenance plant
    if i_resp_div is not initial.
      ls_notif_header-maintplant   = i_resp_div.
      ls_notif_header_x-maintplant = abap_true.
    endif.

    "ID Poste de trav.responsable / ID Main work center for maintenance tasks
    if i_main_wkctr is not initial.
      call function 'CR_WORKSTATION_CHECK'
        exporting
          arbpl     = i_main_wkctr
          werks     = i_plan_div
*         werks     = lv_werks
        importing
          id        = ls_notif_header-pm_wkctr
        exceptions
          not_found = 1
          others    = 2.
      ls_notif_header_x-pm_wkctr = abap_true.
    endif.


    if i_reqdate_start is not initial or i_clear_fields-reqdate_start = abap_true.
      ls_notif_header-desstdate	  = i_reqdate_start.
      ls_notif_header_x-desstdate	= abap_true.
    endif.

    if i_reqtime_start is not initial or i_clear_fields-reqtime_start = abap_true.
      ls_notif_header-dessttime   = i_reqtime_start.
      ls_notif_header_x-dessttime = abap_true.
    endif.

    if i_reqdate_end is not initial or i_clear_fields-reqdate_end = abap_true.
      ls_notif_header-desenddate   = i_reqdate_end.
      ls_notif_header_x-desenddate = abap_true.
    endif.

    if i_reqtime_end is not initial or i_clear_fields-reqtime_end = abap_true.
      ls_notif_header-desendtm   = i_reqtime_end.
      ls_notif_header_x-desendtm = abap_true.
    endif.

    if i_priok is not initial or i_clear_fields-priok = abap_true.
      ls_notif_header-priority   = i_priok.
      ls_notif_header_x-priority = abap_true.
    endif.

    if i_salesdoc_id is not initial.
      ls_notif_header-doc_number   = i_salesdoc_id.
      ls_notif_header_x-doc_number = abap_true.
    endif.

    if i_salesdoc_item is not initial.
      ls_notif_header-itm_number   = i_salesdoc_item.
      ls_notif_header_x-itm_number = abap_true.
    endif.

*   CFB 11.10.2018 - Get equipment from QMIH using i_notif_id for use on checkIn/ checkOut of Equipment
    select single qmih~equnr
      into @data(lv_equnr)
     from qmih as qmih
     where qmnum = @i_notif_id.

    "breakdown indicator

    if i_breakdown is not initial.
      ls_notif_header_x-breakdown = abap_true.
      ls_notif_header-breakdown = i_breakdown.


*     >>> CFB 11.10.2018 Check-in of equipment - change status to OFIC
      call method zcl_absf_pm=>change_equi_status
        exporting
          i_equnr     = lv_equnr
          i_operation = 'IN'
          i_werks     = i_inputobj-werks.
*     <<< CFB 11.10.2018 Check-in of equipment - change status to OFIC
    else.
      if i_clear_fields-breakdown = abap_true.

        ls_notif_header_x-breakdown = abap_true.
        ls_notif_header_x-endmlfndate = abap_true.
        ls_notif_header_x-endmlfntime = abap_true.


        ls_notif_header-endmlfndate = '00000000'.
        ls_notif_header-endmlfntime = '000000'.

        ls_notif_header-breakdown = abap_false.

*     >>> CFB 11.10.2018 Check-out of equipment - change status to DISP
        call method zcl_absf_pm=>change_equi_status
          exporting
            i_equnr     = lv_equnr
            i_operation = 'OUT'
            i_werks     = i_inputobj-werks.
*     <<< CFB 11.10.2018 Check-out of equipment - change status to disp

      endif.
    endif.

    if i_malf_end_date is not initial.
      ls_notif_header_x-endmlfndate = abap_true.
      ls_notif_header-endmlfndate = i_malf_end_date.
      ls_notif_header_x-endmlfntime = abap_true.
      ls_notif_header-endmlfntime = i_malf_end_time.

*     >>> CFB 11.10.2018 Check-out of equipment - change status to DISP
      call method zcl_absf_pm=>change_equi_status
        exporting
          i_equnr     = lv_equnr
          i_operation = 'OUT'
          i_werks     = i_inputobj-werks.
*     <<< CFB 11.10.2018 Check-out of equipment - change status to DISP

    endif.


    if i_malf_start_date is not initial.
      ls_notif_header_x-strmlfndate = abap_true.
      ls_notif_header-strmlfndate = i_malf_start_date.
      ls_notif_header_x-strmlfntime = abap_true.
      ls_notif_header-strmlfntime = i_malf_start_time.

    endif.


    if ls_notif_header_x is not initial.
      call function 'BAPI_ALM_NOTIF_DATA_MODIFY'
        exporting
          number        = i_notif_id
          notifheader   = ls_notif_header
          notifheader_x = ls_notif_header_x
        tables
          return        = lt_return.
      lv_changes_exists = abap_true.
    endif.
** <- NOTIFICATION HEADER


** -> PARTNERS
    clear: ls_notpartnr_i, ls_notpartnr_ix, ls_old_partner.
    refresh: lt_notpartnr_i, lt_notpartnr_ix, lt_old_partner.

    call function 'BAPI_ALM_NOTIF_GET_DETAIL'
      exporting
        number      = i_notif_id
      tables
        notifpartnr = lt_old_partner.


** --> SOLD-TO PARTY ( Partner Function: AG = Sold-to Party)
    if i_client_id is not initial.
* Check if a Sold-to Party already exists.
      read table lt_old_partner
        into ls_old_partner
        with key partn_role = lv_part_soldto
        transporting all fields.

      if sy-subrc = 0 and ls_old_partner-partner ne i_client_id.
        ls_notpartnr_i-partn_role_old = ls_old_partner-partn_role.
        ls_notpartnr_ix-partn_role_old = ls_old_partner-partn_role.
        ls_notpartnr_i-partner_old = ls_old_partner-partner.
        ls_notpartnr_ix-partner_old = ls_old_partner-partner.
      endif.

      ls_notpartnr_i-partn_role = lv_part_soldto.
      ls_notpartnr_ix-partn_role = abap_true.
      ls_notpartnr_i-partner = i_client_id.
      ls_notpartnr_ix-partner = abap_true.

      append ls_notpartnr_i to lt_notpartnr_i.
      append ls_notpartnr_ix to lt_notpartnr_ix.

    endif.
** <-- SOLD-TO PARTY ( Partner Function: AG = Sold-to Party)

** -> USER RESPONSABLE ( Partner Function: VU = User Resp.)
    if i_user_resp is not initial or i_clear_fields-user_resp = abap_true.

* Remove current Partner - User Responsable
      if i_clear_fields-user_resp = abap_true.

* Read Partner info for delete
        read table lt_old_partner
          into ls_old_partner
          with key partn_role = lv_part_useresp
          transporting all fields.

        ls_notpartnr_i-partn_role = lv_part_useresp.
        ls_notpartnr_i-partner = ls_old_partner-partner.
        append ls_notpartnr_i to lt_notpartnr_i.

        call function 'BAPI_ALM_NOTIF_DATA_DELETE'
          exporting
            number      = i_notif_id
          tables
            notifpartnr = lt_notpartnr_i
            return      = lt_return.
        lv_changes_exists = abap_true.

      else.

* Check if a user resp. already exists.
        read table lt_old_partner
          into ls_old_partner
          with key partn_role = lv_part_useresp
          transporting all fields.

        if sy-subrc = 0 and ls_old_partner-partner ne i_user_resp.
          ls_notpartnr_i-partn_role_old = ls_old_partner-partn_role.
          ls_notpartnr_ix-partn_role_old = ls_old_partner-partn_role.
          ls_notpartnr_i-partner_old = ls_old_partner-partner.
          ls_notpartnr_ix-partner_old = ls_old_partner-partner.
        endif.

        ls_notpartnr_i-partn_role = lv_part_useresp.
        ls_notpartnr_ix-partn_role = abap_true.
        ls_notpartnr_i-partner = i_user_resp.
        ls_notpartnr_ix-partner = abap_true.

        append ls_notpartnr_i to lt_notpartnr_i.
        append ls_notpartnr_ix to lt_notpartnr_ix.

*        IF    ls_old_partner-partner <> i_user_resp
*          AND ls_old_partner-partner IS NOT INITIAL.
*
*          CALL FUNCTION 'BAPI_ALM_NOTIF_DATA_MODIFY'
*            EXPORTING
*              number        = i_notif_id
*            TABLES
*              notifpartnr   = lt_notpartnr_i
*              notifpartnr_x = lt_notpartnr_ix
*              return        = lt_return.
*          lv_changes_exists = abap_true.
*
*        ELSE.
*          IF lt_old_partner IS INITIAL.
*            CALL FUNCTION 'BAPI_ALM_NOTIF_DATA_ADD'
*              EXPORTING
*                number      = i_notif_id
*              TABLES
*                notifpartnr = lt_notpartnr_i
*                return      = lt_return.
*            lv_changes_exists = abap_true.
*          ENDIF.
*        ENDIF.
      endif.
    endif.
** <-- USER RESPONSABLE ( Partner Function: VU = User Resp.)


    if ( ls_old_partner-partner <> i_client_id and ls_old_partner-partner is not initial )
      or ( ls_old_partner-partner <> i_user_resp and ls_old_partner-partner is not initial ).

      call function 'BAPI_ALM_NOTIF_DATA_MODIFY'
        exporting
          number        = i_notif_id
        tables
          notifpartnr   = lt_notpartnr_i
          notifpartnr_x = lt_notpartnr_ix
          return        = lt_return.
      lv_changes_exists = abap_true.

    else.
      if lt_old_partner is initial and lt_notpartnr_i is not initial.
        call function 'BAPI_ALM_NOTIF_DATA_ADD'
          exporting
            number      = i_notif_id
          tables
            notifpartnr = lt_notpartnr_i
            return      = lt_return.
        lv_changes_exists = abap_true.
      endif.
    endif.
** <- PARTNERS


** -> LONG TEXTS
    if it_longtexts[] is not initial.

* get operator information.
      select single nchmc vnamc from pa0002
        into (lv_name, lv_lastname)
        where pernr = i_inputobj-pernr.

      concatenate i_inputobj-pernr lv_name lv_lastname into ls_longtext_i-text_line separated by space.
      ls_longtext_i-objtype = 'QMEL'.
      ls_longtext_i-format_col = '/'.
      append ls_longtext_i to lt_longtext_i.
      clear ls_longtext_i.

      loop at it_longtexts into ls_longtexts.

        ls_longtext_i-text_line  = ls_longtexts-text_line.
        ls_longtext_i-objtype = 'QMEL'.
        ls_longtext_i-format_col = '/'.
        add 1 to lv_objkey.
        ls_longtext_i-objkey = lv_objkey.
        append ls_longtext_i to lt_longtext_i.

        clear: ls_longtexts, ls_longtext_i.
      endloop.
    endif.
** <- LONG TEXTS

** -> CAUSES
    call function 'BAPI_ALM_NOTIF_GET_DETAIL'
      exporting
        number             = i_notif_id
      importing
        notifheader_export = ls_notif_header_export
      tables
        notifcaus          = lt_notifcaus
        return             = lt_return.

*>> get first item
    read table lt_notifcaus into ls_notifcaus index 1.
    if sy-subrc eq 0.

*>> modify
      ls_notifcaus_i-refobjectkey = '1'.
      ls_notifcaus_i-cause_codegrp = i_cause.
      ls_notifcaus_i-cause_code = i_subcause.
      ls_notifcaus_i-causetext = i_cause_text.
      ls_notifcaus_i-item_key = ls_notifcaus-item_key.
      ls_notifcaus_i-cause_key = ls_notifcaus-cause_key.

      ls_notifcaus_ix-cause_key = ls_notifcaus-cause_key.
      ls_notifcaus_ix-item_key = ls_notifcaus-item_key.
      ls_notifcaus_ix-cause_codegrp = abap_true.
      ls_notifcaus_ix-cause_code = abap_true.
      ls_notifcaus_ix-causetext = abap_true.

      append ls_notifcaus_i to lt_notifcaus_i.
      append ls_notifcaus_ix to lt_notifcaus_ix.

      if i_cause is not initial or i_subcause is not initial or i_cause_text is not initial.
        call function 'BAPI_ALM_NOTIF_DATA_MODIFY'
          exporting
            number      = i_notif_id
          tables
            notifcaus   = lt_notifcaus_i
            notifcaus_x = lt_notifcaus_ix
            return      = lt_return.
        lv_changes_exists = abap_true.
      endif.
** <- CAUSES

      if lt_longtext_i is not initial.

        call function 'BAPI_ALM_NOTIF_DATA_ADD'
          exporting
            number     = i_notif_id
          tables
            notfulltxt = lt_longtext_i
            return     = lt_return.
        lv_changes_exists = abap_true.
      endif.
    else.

*>>   add cause
      if i_cause is not initial and i_subcause is not initial.
        ls_notifcaus_i-refobjectkey = '1'.
        ls_notifcaus_i-cause_codegrp = i_cause.
        ls_notifcaus_i-cause_code = i_subcause.
        ls_notifcaus_i-causetext = i_cause_text.
        ls_notifcaus_i-item_key = '0001'.
        ls_notifcaus_i-cause_sort_no = '0001'.
        ls_notifcaus_i-item_sort_no = '0001'.
        append ls_notifcaus_i to lt_notifcaus_i.

        call function 'BAPI_ALM_NOTIF_DATA_ADD'
          exporting
            number     = i_notif_id
          tables
            notfulltxt = lt_longtext_i
            notifcaus  = lt_notifcaus_i
            return     = lt_return.
        lv_changes_exists = abap_true.

      else.
        if i_cause_text is not initial.
          ls_notifcaus_i-refobjectkey = '1'.
          ls_notifcaus_i-item_key = '0001'.
          ls_notifcaus_i-cause_sort_no = '0001'.
          ls_notifcaus_i-item_sort_no = '0001'.
          ls_notifcaus_i-causetext = i_cause_text.
          append ls_notifcaus_i to lt_notifcaus_i.

        endif.

        if lt_notifcaus_i is not initial or lt_longtext_i is not initial.

          call function 'BAPI_ALM_NOTIF_DATA_ADD'
            exporting
              number     = i_notif_id
            tables
              notfulltxt = lt_longtext_i
              notifcaus  = lt_notifcaus_i
              return     = lt_return.
          lv_changes_exists = abap_true.
        endif.

      endif.
    endif.



**  Check Errors
    loop at lt_return into ls_return
       where type ca 'AEX'.

      call method zcl_absf_pm=>add_message
        exporting
          msgid      = ls_return-id
          msgty      = ls_return-type
          msgno      = ls_return-number
          msgv1      = ls_return-message_v1
          msgv2      = ls_return-message_v2
          msgv3      = ls_return-message_v3
          msgv4      = ls_return-message_v4
        changing
          return_tab = et_returntab.

      clear ls_return.
      lf_no_commit = abap_true.

    endloop.

    check lf_no_commit eq abap_false.


    call function 'BAPI_ALM_NOTIF_SAVE'
      exporting
        number = i_notif_id
      tables
        return = lt_return.

    call function 'BAPI_TRANSACTION_COMMIT'
      exporting
        wait = abap_true.

    call method zcl_absf_pm=>add_message
      exporting
        msgty      = 'S'
        msgno      = '001'
      changing
        return_tab = et_returntab.


    if i_close_notif eq abap_true. " AND it_longtexts[] IS NOT INITIAL.

      clear lf_no_commit.

* verify if malfunction end date is initial if so we must set it to actual date and time
* if not initial we maintain the data and time.

      ls_notif_header_x-endmlfndate = abap_true.
      ls_notif_header_x-endmlfntime = abap_true.

      if ls_notif_header_export-endmlfndate is initial.
        ls_notif_header-endmlfndate = sy-datlo.
        ls_notif_header-endmlfntime = sy-timlo.
      else.
        ls_notif_header-endmlfndate = ls_notif_header_export-endmlfndate.
        ls_notif_header-endmlfntime = ls_notif_header_export-endmlfntime.
      endif.

*>>> for BADI ZABSF_PM_BREAKDOWN_CALC sap note - 1619709 - Notification breakdown duration not populated by BAPI call
      from_shopfloor = abap_true.
      export from_shopfloor from from_shopfloor to memory id 'SHOPFLOOR_NOTE_CLOSE'.
*<<<
      call function 'BAPI_ALM_NOTIF_DATA_MODIFY'
        exporting
          number        = i_notif_id
          notifheader   = ls_notif_header
          notifheader_x = ls_notif_header_x
        tables
          return        = lt_return.

      loop at lt_return into ls_return
         where type ca 'AEX'.

        call method zcl_absf_pm=>add_message
          exporting
            msgid      = ls_return-id
            msgty      = ls_return-type
            msgno      = ls_return-number
            msgv1      = ls_return-message_v1
            msgv2      = ls_return-message_v2
            msgv3      = ls_return-message_v3
            msgv4      = ls_return-message_v4
          changing
            return_tab = et_returntab.

        lf_no_commit = abap_true.

        clear ls_return.
      endloop.

      check lf_no_commit ne abap_true.

      call function 'BAPI_ALM_NOTIF_SAVE'
        exporting
          number = i_notif_id
        tables
          return = lt_return.

      call function 'BAPI_TRANSACTION_COMMIT'
        exporting
          wait = abap_true.

      call function 'BAPI_ALM_NOTIF_CLOSE'
        exporting
          number   = i_notif_id
          syststat = ls_syst
        tables
          return   = lt_return.

      loop at lt_return into ls_return
        where type ca 'AEX'.

        call method zcl_absf_pm=>add_message
          exporting
            msgid      = ls_return-id
            msgty      = ls_return-type
            msgno      = ls_return-number
            msgv1      = ls_return-message_v1
            msgv2      = ls_return-message_v2
            msgv3      = ls_return-message_v3
            msgv4      = ls_return-message_v4
          changing
            return_tab = et_returntab.

        lf_no_commit = abap_true.

        clear ls_return.
      endloop.

      check lf_no_commit ne abap_true.

      call function 'BAPI_TRANSACTION_COMMIT'
        exporting
          wait = abap_true.


*      CALL FUNCTION 'BAPI_ALM_NOTIF_CLOSE'
*        EXPORTING
*          number   = i_notif_id
*          syststat = ls_syst
*        TABLES
*          return   = lt_return.
*
*      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
*        EXPORTING
*          wait = abap_true.
*
*      lv_changes_exists = abap_true.
*
*      REFRESH et_returntab.
*
*      CALL METHOD ZCL_ABSF_PM=>add_message
*        EXPORTING
*          msgty      = 'S'
*          msgno      = '005'
*        CHANGING
*          return_tab = et_returntab.
    endif.

    if lv_changes_exists = abap_false.
*      MESSAGE e029(ZABSF_PM).
      call method zcl_absf_pm=>add_message
        exporting
          msgty      = 'S'
          msgno      = '29'
        changing
          return_tab = et_returntab.
    endif.

  endmethod.


  METHOD change_notif_item.

    DATA : lf_no_commit TYPE flag.

    DATA : lt_notitemi   TYPE TABLE OF bapi2080_notitemi,
           ls_notitemi   TYPE bapi2080_notitemi,
           lt_notitemi_x TYPE TABLE OF bapi2080_notitemi_x,
           ls_notitemi_x TYPE bapi2080_notitemi_x.

    DATA : lt_notifcausi   TYPE TABLE OF bapi2080_notcausi,
           ls_notifcausi   TYPE bapi2080_notcausi,
           lt_notifcausi_x TYPE TABLE OF bapi2080_notcausi_x,
           ls_notifcausi_x TYPE bapi2080_notcausi_x.

    DATA: lt_return TYPE bapiret2_t,
          ls_return LIKE LINE OF lt_return.

    MOVE-CORRESPONDING i_not_item TO ls_notitemi.



*   set updatable fields of notitem

    IF i_not_item-descript IS NOT INITIAL.
      ls_notitemi_x-descript = abap_true.
    ENDIF.
    IF i_not_item-d_codegrp IS NOT INITIAL.
      ls_notitemi_x-d_codegrp = abap_true.
    ENDIF.
    IF i_not_item-d_code IS NOT INITIAL.
      ls_notitemi_x-d_code = abap_true.
    ENDIF.

    IF i_not_item-dl_codegrp IS NOT INITIAL.
      ls_notitemi_x-dl_codegrp = abap_true.
    ENDIF.
    IF i_not_item-dl_code IS NOT INITIAL.
      ls_notitemi_x-dl_code = abap_true.
    ENDIF.

*   verify if there are some fields above to remove

    IF i_clear_fields-descript = abap_true.
      ls_notitemi_x-descript = abap_true.
      ls_notitemi-descript = ''.
    ENDIF.
    IF i_clear_fields-d_codegrp = abap_true.
      ls_notitemi_x-d_codegrp = abap_true.
      ls_notitemi-d_codegrp = ''.
    ENDIF.
    IF i_clear_fields-d_code = abap_true.
      ls_notitemi_x-d_code = abap_true.
      ls_notitemi-d_code = ''.
    ENDIF.

    IF i_clear_fields-dl_codegrp = abap_true.
      ls_notitemi_x-dl_codegrp = abap_true.
      ls_notitemi-dl_codegrp = ''.
    ENDIF.
    IF i_clear_fields-dl_code = abap_true.
      ls_notitemi_x-dl_code = abap_true.
      ls_notitemi-dl_code = ''.
    ENDIF.

    APPEND ls_notitemi TO lt_notitemi.



    ls_notitemi_x-item_key = i_not_item-item_key.

    APPEND ls_notitemi_x TO lt_notitemi_x.


*>>>>    Causes
    "verify if there is a need to insert cause or update cause or delete cause
    IF i_not_item-cause_codegrp IS NOT INITIAL OR i_not_item-causetext IS NOT INITIAL
      OR i_clear_fields-cause_codegrp = abap_true OR i_clear_fields-cause_code = abap_true
      OR i_clear_fields-causetext = abap_true.

      " we have to verify if cause exists
      SELECT COUNT(*) INTO @DATA(exist_cause)
        FROM qmur
        WHERE qmur~qmnum EQ @i_not_item-notif_no
              AND qmur~fenum EQ @i_not_item-item_key AND kzloesch EQ @space.

      IF exist_cause = 0. "there is no cause we have to creat it

        "call method to add a cause to an existem item
        CALL METHOD zcl_absf_pm=>add_cause_to_notitem
          EXPORTING
            i_not_item   = i_not_item
          IMPORTING
            et_returntab = et_returntab.

      ELSE. " there is a cause so let´s update it

        ls_notifcausi-item_key = i_not_item-item_key.
        "ls_notifcausi-item_sort_no = i_not_item-item_sort_no.

        "get causekey from cause active
        SELECT SINGLE urnum INTO @DATA(lv_causekey)
         FROM qmur WHERE qmnum EQ @i_not_item-notif_no
         AND fenum EQ @i_not_item-item_key AND kzloesch EQ @space.

        ls_notifcausi-cause_key = lv_causekey.
        ls_notifcausi-cause_sort_no = lv_causekey.

*        ls_notifcausi-cause_key = '0001'." i_not_item-cause_key.
*        ls_notifcausi-cause_sort_no = '0001'. "i_not_item-cause_sort_no.

        ls_notifcausi-causetext = i_not_item-causetext.
        ls_notifcausi-cause_code = i_not_item-cause_code.
        ls_notifcausi-cause_codegrp = i_not_item-cause_codegrp.

        APPEND ls_notifcausi TO lt_notifcausi.

*   set updatable fields of notifcauses

        IF i_not_item-cause_codegrp IS NOT INITIAL.
          ls_notifcausi_x-cause_codegrp = abap_true.
        ENDIF.
        IF i_not_item-cause_code IS NOT INITIAL.
          ls_notifcausi_x-cause_code = abap_true.
        ENDIF.
        IF i_not_item-causetext IS NOT INITIAL.
          ls_notifcausi_x-causetext = abap_true.
        ENDIF.

*   verify if there are some fields above to remove


        IF i_clear_fields-cause_codegrp = abap_true.
          ls_notifcausi_x-cause_codegrp = abap_true.
          ls_notifcausi-cause_codegrp = ''.
        ENDIF.
        IF i_clear_fields-cause_code = abap_true.
          ls_notifcausi_x-cause_code = abap_true.
          ls_notifcausi-cause_code = ''.
        ENDIF.
        IF i_clear_fields-causetext = abap_true.
          ls_notifcausi_x-causetext = abap_true.
          ls_notifcausi-causetext = ''.
        ENDIF.

        ls_notifcausi_x-item_key = i_not_item-item_key.
        ls_notifcausi_x-cause_key = lv_causekey.

        APPEND ls_notifcausi_x TO lt_notifcausi_x.

        " verify if all 3 fields of cause are to remove if so we have to delete the cause

        "verify if cause has no data if so we have to delete the cause
        IF  i_clear_fields-cause_code = abap_true AND i_clear_fields-cause_codegrp = abap_true
           AND i_clear_fields-causetext = abap_true.

          "call method to add a cause to an existem item
          CALL METHOD zcl_absf_pm=>delete_cause_of_notitem
            EXPORTING
              i_not_item   = i_not_item
            IMPORTING
              et_returntab = et_returntab.

          "we have delete the cause so we cannot update the cause
          CLEAR : ls_notifcausi, ls_notifcausi_x,
             lt_notifcausi_x, lt_notifcausi.

        ENDIF.

      ENDIF.

    ELSE. "there's no need to update cause

      CLEAR : ls_notifcausi, ls_notifcausi_x,
             lt_notifcausi_x, lt_notifcausi.

    ENDIF.

* call bapi to change the data
    CALL FUNCTION 'BAPI_ALM_NOTIF_DATA_MODIFY'
      EXPORTING
        number      = i_not_item-notif_no
      TABLES
        notifitem   = lt_notitemi
        notifitem_x = lt_notitemi_x
        notifcaus   = lt_notifcausi
        notifcaus_x = lt_notifcausi_x
        return      = lt_return.

    LOOP AT lt_return INTO ls_return
       WHERE type CA 'AEX'.

      CALL METHOD zcl_absf_pm=>add_message
        EXPORTING
          msgid      = ls_return-id
          msgty      = ls_return-type
          msgno      = ls_return-number
          msgv1      = ls_return-message_v1
          msgv2      = ls_return-message_v2
          msgv3      = ls_return-message_v3
          msgv4      = ls_return-message_v4
        CHANGING
          return_tab = et_returntab.

      CLEAR ls_return.
      lf_no_commit = abap_true.

    ENDLOOP.

    IF lf_no_commit EQ abap_true.

      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

    ELSE.

      CALL FUNCTION 'BAPI_ALM_NOTIF_SAVE'
        EXPORTING
          number = i_not_item-notif_no
        TABLES
          return = lt_return.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.

*Send Message : Item &1 from notification nº &2 modified successfully!
      CALL METHOD zcl_absf_pm=>add_message
        EXPORTING
          msgty      = 'S'
          msgno      = '031'
          msgv1      = i_not_item-item_key
          msgv2      = i_not_item-notif_no
        CHANGING
          return_tab = et_returntab.

    ENDIF.

  ENDMETHOD.


  METHOD change_order.

    DATA: lv_first_operation(4) VALUE '0010'.

    DATA:lt_bapi_methods       TYPE TABLE OF bapi_alm_order_method,
         ls_bapi_methods       LIKE LINE OF lt_bapi_methods,
         lt_maint_header       TYPE TABLE OF bapi_alm_order_headers_i,
         ls_maint_header       LIKE LINE OF lt_maint_header,

         lt_maint_operation    TYPE TABLE OF bapi_alm_order_operation,
         ls_maint_operation    LIKE LINE OF lt_maint_operation,
         lt_maint_operation_up TYPE TABLE OF bapi_alm_order_operation_up,
         ls_maint_operation_up LIKE LINE OF lt_maint_operation_up,

         "lt_maint_header_update TYPE TABLE OF bapi_alm_order_headers_up,
         "ls_maint_header_update LIKE LINE OF lt_maint_header_update,
         lt_ordmaint_ret       TYPE bapiret2_t,
         ls_ordmaint_ret       LIKE LINE OF lt_ordmaint_ret,


         lt_partner            TYPE TABLE OF bapi_alm_order_partn_mul,
         ls_partner            TYPE bapi_alm_order_partn_mul,
         lt_partner_up         TYPE TABLE OF bapi_alm_order_partn_mul_up,
         ls_partner_up         TYPE bapi_alm_order_partn_mul_up.

    DATA: lv_parnr TYPE i_parnr.


    ls_bapi_methods-refnumber = 1.
    ls_bapi_methods-objecttype = 'HEADER'.
    ls_bapi_methods-method = 'CHANGE'.
    ls_bapi_methods-objectkey = i_aufnr.
    APPEND ls_bapi_methods TO lt_bapi_methods.
    CLEAR ls_bapi_methods.



*    ls_bapi_methods-refnumber = 1.
*    ls_bapi_methods-method = 'SAVE'.
*    APPEND ls_bapi_methods TO lt_bapi_methods.

    ls_maint_header-orderid = i_aufnr.
    APPEND ls_maint_header TO lt_maint_header.


*  Check if exist start work or stop
    SELECT SINGLE *
      FROM zabsf_pm_reg_pm
      INTO @DATA(ls_sf_reg_pm_tmp)
     WHERE werks EQ @i_inputobj-werks
       AND aufnr EQ @i_aufnr
       AND iedd  EQ '00000000'
       AND iedz  EQ '000000'.

    IF NOT ls_sf_reg_pm_tmp IS INITIAL.
*      Send error message: There is already a start work record
          CALL METHOD zcl_absf_pm=>add_message
            EXPORTING
              msgty      = 'E'
              msgno      = '042'
            CHANGING
              return_tab = et_returntab.
          EXIT.
    ENDIF.

    IF NOT i_pernr IS INITIAL.

      CLEAR ls_bapi_methods.
      ls_bapi_methods-refnumber = 1.
      ls_bapi_methods-objecttype = 'OPERATION'.
      ls_bapi_methods-method = 'CHANGE'.
      CONCATENATE i_aufnr lv_first_operation INTO ls_bapi_methods-objectkey.
      APPEND ls_bapi_methods TO lt_bapi_methods.

      CLEAR ls_bapi_methods.
      ls_maint_operation-activity = lv_first_operation.

      ls_maint_operation-pers_no = i_pernr.
      APPEND ls_maint_operation TO lt_maint_operation.

      ls_maint_operation_up-pers_no = COND #( WHEN i_pernr IS NOT INITIAL THEN abap_true ELSE abap_false ).
      APPEND ls_maint_operation_up TO lt_maint_operation_up.

    ENDIF.

    IF NOT i_rsp_user IS INITIAL.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = i_rsp_user
        IMPORTING
          output = lv_parnr.

*     verify current ZB partner, if its the same no need to update partners
      SELECT SINGLE ihpa~parnr
        INTO @DATA(lv_parnr_old)
        FROM ihpa
        INNER JOIN aufk AS aufk ON aufk~objnr = ihpa~objnr
        WHERE  ihpa~parvw = 'VW' AND
               ihpa~counter = '0' AND
               aufk~aufnr = @i_aufnr.

      IF lv_parnr <> lv_parnr_old.

        CLEAR ls_bapi_methods.
        ls_bapi_methods-refnumber = 1..
        ls_bapi_methods-objecttype = 'PARTNER'.
        ls_bapi_methods-method = 'CHANGE'.
        ls_bapi_methods-objectkey = i_aufnr. "order no
        APPEND ls_bapi_methods TO lt_bapi_methods.


        CLEAR ls_partner.
        ls_partner-orderid = i_aufnr.

        ls_partner-partn_role = 'VW'.
        ls_partner-partner = lv_parnr.

        ls_partner-partn_role_old = 'VW'.
        ls_partner-partner_old = lv_parnr_old.

        APPEND ls_partner TO lt_partner.

        CLEAR ls_partner_up.
        ls_partner_up-orderid = i_aufnr.
        ls_partner_up-partn_role = 'X'.
        ls_partner_up-partner = 'X'.
        ls_partner_up-partn_role_old = 'VW'.
        ls_partner_up-partner_old =  lv_parnr_old.

        APPEND ls_partner_up TO lt_partner_up.

      ENDIF.
    ENDIF.

    CLEAR ls_bapi_methods.
    ls_bapi_methods-refnumber = 1.
    ls_bapi_methods-method = 'SAVE'.
    APPEND ls_bapi_methods TO lt_bapi_methods.


*    IF i_pernr IS INITIAL. "there is no need to update order
*
*      CLEAR lt_maint_header.
*      CLEAR : lt_maint_operation, lt_maint_operation_up.
*    ENDIF.

    CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
      TABLES
        it_methods      = lt_bapi_methods
        it_header       = lt_maint_header
        "it_header_up = lt_maint_header_update
        it_operation    = lt_maint_operation
        it_operation_up = lt_maint_operation_up
        it_partner      = lt_partner
        it_partner_up   = lt_partner_up
        return          = lt_ordmaint_ret.

    LOOP AT lt_ordmaint_ret INTO ls_ordmaint_ret
      WHERE type CA 'AEX'.

      CALL METHOD zcl_absf_pm=>add_message
        EXPORTING
          msgid      = ls_ordmaint_ret-id
          msgty      = ls_ordmaint_ret-type
          msgno      = ls_ordmaint_ret-number
          msgv1      = ls_ordmaint_ret-message_v1
          msgv2      = ls_ordmaint_ret-message_v2
          msgv3      = ls_ordmaint_ret-message_v3
          msgv4      = ls_ordmaint_ret-message_v4
        CHANGING
          return_tab = et_returntab.
    ENDLOOP.

    IF et_returntab IS INITIAL.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.

      CALL METHOD zcl_absf_pm=>add_message
        EXPORTING
          msgty      = 'S'
          msgno      = '034'
          msgv1      = i_aufnr
        CHANGING
          return_tab = et_returntab.

    ENDIF.




  ENDMETHOD.


  METHOD change_order_equipment.


    DATA: lt_bapi_methods        TYPE TABLE OF bapi_alm_order_method,
          ls_bapi_methods        LIKE LINE OF lt_bapi_methods,
          lt_maint_header        TYPE TABLE OF bapi_alm_order_headers_i,
          ls_maint_header        LIKE LINE OF lt_maint_header,
          lt_maint_header_update TYPE TABLE OF bapi_alm_order_headers_up,
          ls_maint_header_update LIKE LINE OF lt_maint_header_update,
          lt_ordmaint_ret        TYPE bapiret2_t,
          ls_ordmaint_ret        LIKE LINE OF lt_ordmaint_ret.


    ls_bapi_methods-refnumber = 1.
    ls_bapi_methods-objecttype = 'HEADER'.
    ls_bapi_methods-method = 'CHANGE'.
    ls_bapi_methods-objectkey = i_aufnr.
    APPEND ls_bapi_methods TO lt_bapi_methods.
    CLEAR ls_bapi_methods.

    ls_bapi_methods-refnumber = 1.
    ls_bapi_methods-method = 'SAVE'.
    APPEND ls_bapi_methods TO lt_bapi_methods.

    ls_maint_header-orderid = i_aufnr.
    ls_maint_header-equipment = i_equnr.
    APPEND ls_maint_header TO lt_maint_header.

    ls_maint_header_update-orderid = i_aufnr.
    ls_maint_header_update-equipment = abap_true.
    APPEND ls_maint_header_update TO lt_maint_header_update.

    CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
      TABLES
        it_methods   = lt_bapi_methods
        it_header    = lt_maint_header
        it_header_up = lt_maint_header_update
        return       = lt_ordmaint_ret.

    LOOP AT lt_ordmaint_ret INTO ls_ordmaint_ret
      WHERE type CA 'AEX'.

      CALL METHOD zcl_absf_pm=>add_message
        EXPORTING
          msgid      = ls_ordmaint_ret-id
          msgty      = ls_ordmaint_ret-type
          msgno      = ls_ordmaint_ret-number
          msgv1      = ls_ordmaint_ret-message_v1
          msgv2      = ls_ordmaint_ret-message_v2
          msgv3      = ls_ordmaint_ret-message_v3
          msgv4      = ls_ordmaint_ret-message_v4
        CHANGING
          return_tab = et_return.
    ENDLOOP.

    IF et_return IS INITIAL.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.

      CALL METHOD zcl_absf_pm=>add_message
        EXPORTING
          msgty      = 'S'
          msgno      = '000'
        CHANGING
          return_tab = et_return.

    ENDIF.


  ENDMETHOD.


  METHOD check_if_moulde_is_clean.

    CONSTANTS: lc_nprt(5) VALUE 'I0180',
               lc_zmld(4) VALUE 'ZMLD'.


    DATA: lt_system_status TYPE TABLE OF  bapi_itob_status,
          lt_user_status   TYPE TABLE OF  bapi_itob_status.

    DATA: lv_auart TYPE auart,
          lv_equnr TYPE equnr.

*1) Get order type
    SELECT SINGLE aufk~auart afih~equnr INTO (lv_auart ,lv_equnr)
      FROM aufk AS aufk
      INNER JOIN afih AS afih
      ON aufk~aufnr EQ afih~aufnr
    WHERE aufk~aufnr EQ i_aufnr.

    IF lv_auart EQ lc_zmld AND lv_equnr IS NOT INITIAL.
*2) Check equipment status

      CALL FUNCTION 'BAPI_EQUI_GETSTATUS'
        EXPORTING
          equipment     = lv_equnr
          language      = sy-langu
        TABLES
          system_status = lt_system_status
          user_status   = lt_user_status.

      READ TABLE lt_system_status TRANSPORTING NO FIELDS WITH KEY status = lc_nprt.
      IF sy-subrc EQ 0.

        e_error = abap_true.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD check_moulde_characts_equip.

* Types:
    TYPES: BEGIN OF ty_equipments,
             equnr TYPE equnr,
             eqart TYPE eqart,
           END OF ty_equipments.

*  Constants
    CONSTANTS: c_min(3)         TYPE c        VALUE 'MIN',
               c_stat_proc      TYPE j_status VALUE 'PROC',
               c_stat_agu       TYPE j_status VALUE 'AGU',
               c_stat_conc      TYPE j_status VALUE 'CONC',
               c_stat_checklist TYPE j_status VALUE 'E0001',
               c_aufart         TYPE aufart   VALUE 'ZMLD',
               c_obj_equi       TYPE tabelle  VALUE 'EQUI',
               c_mafid          TYPE klmaf    VALUE 'O', "Indicator: Object/Class
               c_crb            TYPE atnam    VALUE 'CRB',
               c_vacuum         TYPE atnam    VALUE 'VACUUM',
               c_yes            TYPE atwtb    VALUE 'YES'.

    DATA: l_objek     TYPE cuobn,
          lt_object   TYPE TABLE OF bapi1003_object_keys,
          ls_object   TYPE bapi1003_object_keys,
          l_objectkey TYPE objnum,
          l_atnam     TYPE atnam,
          l_atnam_val TYPE atwtb.

    DATA: lt_return     TYPE TABLE OF bapiret2,
          lt_chatab     TYPE TABLE OF bapi1003_alloc_values_char,
          lt_numtab     TYPE TABLE OF bapi1003_alloc_values_num,
          lt_curtab     TYPE TABLE OF bapi1003_alloc_values_curr,
          lt_subequip   TYPE zabsf_pm_t_sub_equipments_list,
          lt_equipments TYPE TABLE OF ty_equipments.


*        Get equipment of order
    SELECT SINGLE equnr, obknr
      FROM afih
      INTO (@DATA(l_equnr), @DATA(l_obknr))
     WHERE aufnr EQ @i_aufnr.

*        Key of Object to be Classified
    l_objek = l_equnr.

*        Get characteristic class
    SELECT SINGLE klart
      FROM tcla
     WHERE obtab    EQ @c_obj_equi
       AND intklart EQ @space
       AND multobj  EQ @space
      INTO (@DATA(l_klart)).

    IF l_klart IS NOT INITIAL.
*          Get object of Class
      SELECT SINGLE clint
        FROM kssk
        INTO (@DATA(l_clint))
       WHERE objek EQ @l_objek
         AND mafid EQ @c_mafid
         AND klart EQ @l_klart.

      IF l_clint IS NOT INITIAL.
*            Get name of Class
        SELECT SINGLE class
          FROM klah
          INTO (@DATA(l_class))
         WHERE clint EQ @l_clint.
      ENDIF.
    ENDIF.

    ls_object-key_field = 'EQUNR'.
    ls_object-value_int = l_equnr.
    APPEND ls_object TO lt_object.

    CALL FUNCTION 'BAPI_OBJCL_CONCATENATEKEY'
      EXPORTING
        objecttable    = c_obj_equi
      IMPORTING
        objectkey_conc = l_objectkey
      TABLES
        objectkeytable = lt_object
        return         = lt_return.

*        Get equipment detail
    CALL FUNCTION 'BAPI_OBJCL_GETDETAIL'
      EXPORTING
        objectkey       = l_objectkey
        objecttable     = c_obj_equi
        classnum        = l_class
        classtype       = l_klart
      TABLES
        allocvaluesnum  = lt_numtab
        allocvalueschar = lt_chatab
        allocvaluescurr = lt_curtab
        return          = lt_return.


*        Char characteristics
    IF lt_chatab[] IS NOT INITIAL.

      DATA: lf_check_crb    TYPE boole_d,
            lf_check_vacuum TYPE boole_d.

      READ TABLE lt_chatab INTO DATA(ls_chatab) WITH KEY charact = c_crb.
      IF sy-subrc EQ 0 AND ls_chatab-value_neutral = c_yes.

        lf_check_crb = abap_true.
      ENDIF.

      READ TABLE lt_chatab INTO ls_chatab WITH KEY charact = c_vacuum.
      IF sy-subrc EQ 0 AND ls_chatab-value_neutral = c_yes.

        lf_check_vacuum = abap_true.
      ENDIF.
    ENDIF.

    IF lf_check_crb EQ abap_true OR lf_check_vacuum EQ abap_true.

      IF i_machine IS NOT INITIAL.
*            Get all equipements
        CALL METHOD zcl_absf_pm=>get_machine_subequip
          EXPORTING
            i_werks     = i_werks
            i_equnr     = i_machine
          IMPORTING
            et_subequip = lt_subequip.

        DELETE lt_subequip WHERE equnr = l_equnr. "remove moulde from list
*validate CRB.
        IF lf_check_crb EQ abap_true.

          SELECT SINGLE *
            FROM zabsf_pm_charact
            INTO @DATA(ls_sf_charact)
           WHERE werks EQ @i_werks
             AND atnam EQ @c_crb.

          IF sy-subrc EQ 0.

            IF lt_subequip IS NOT INITIAL.

              SELECT equnr eqart FROM equi INTO TABLE lt_equipments
                FOR ALL ENTRIES IN lt_subequip
                WHERE equnr EQ lt_subequip-equnr
                AND eqart EQ ls_sf_charact-eqart.

              IF sy-subrc NE 0.
                "send error message!
                CALL METHOD zcl_absf_pm=>add_message
                  EXPORTING
                    msgty      = 'E'
                    msgno      = '022'
                  CHANGING
                    return_tab = return_tab.

                EXIT.
              ENDIF.

            ELSE.
              " send error message!
              CALL METHOD zcl_absf_pm=>add_message
                EXPORTING
                  msgty      = 'E'
                  msgno      = '022'
                CHANGING
                  return_tab = return_tab.
              EXIT.

            ENDIF.
          ENDIF.
        ENDIF.

*validate VACCUM.
        IF lf_check_vacuum EQ abap_true.

          SELECT SINGLE *
            FROM zabsf_pm_charact
            INTO @ls_sf_charact
           WHERE werks EQ @i_werks
             AND atnam EQ @c_vacuum.

          IF sy-subrc EQ 0.

            IF lt_subequip IS NOT INITIAL.

              SELECT equnr eqart FROM equi INTO TABLE lt_equipments
                FOR ALL ENTRIES IN lt_subequip
                WHERE equnr EQ lt_subequip-equnr
                AND eqart EQ ls_sf_charact-eqart.

              IF sy-subrc NE 0.
                "send error message!
                CALL METHOD zcl_absf_pm=>add_message
                  EXPORTING
                    msgty      = 'E'
                    msgno      = '023'
                  CHANGING
                    return_tab = return_tab.

                EXIT.
              ENDIF.

            ELSE.
              " send error message!
              CALL METHOD zcl_absf_pm=>add_message
                EXPORTING
                  msgty      = 'E'
                  msgno      = '023'
                CHANGING
                  return_tab = return_tab.
              EXIT.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.


  ENDMETHOD.


  METHOD check_order_pm_activity.

    CONSTANTS: lc_threshold TYPE i VALUE '240'.

    DATA: ls_aufk TYPE aufk,
          ls_jcds TYPE jcds,
          ls_afko TYPE afko,
          ls_afih TYPE afih.

    DATA: lv_days            TYPE i,
          lv_time            TYPE cva_time,
          lv_time_difference TYPE menge13,
          lv_date1(8),
          lv_time1(6),
          lv_timestamp1(14),
          lv_timestamp2(14),
          lv_timestampa      TYPE timestamp,
          lv_timestampb      TYPE timestamp.

    SELECT SINGLE * FROM aufk INTO ls_aufk
      WHERE aufnr EQ i_aufnr.

    CHECK ls_aufk-auart EQ 'ZMLD'.

    IF ls_aufk-objnr IS NOT INITIAL.

      SELECT SINGLE * FROM jcds INTO ls_jcds "data liberada
        WHERE objnr EQ ls_aufk-objnr
        AND stat EQ 'I0002'
        AND chgnr EQ '1'.

      IF sy-subrc EQ 0.

        SELECT SINGLE * FROM afih INTO ls_afih
          WHERE aufnr EQ i_aufnr.

        IF ls_afih-ilart EQ '018'.

          SELECT SINGLE * FROM afko INTO ls_afko " data planeada
            WHERE aufnr EQ i_aufnr.

          CONCATENATE ls_jcds-udate ls_jcds-utime INTO lv_timestamp1.
          CONCATENATE ls_afko-gstrs ls_afko-gsups INTO lv_timestamp2.

          MOVE lv_timestamp1 TO lv_timestampa.
          MOVE lv_timestamp2 TO lv_timestampb.

* update order if dates are wrong
          IF lv_timestampa GT lv_timestampb.

            e_update = abap_true.
            EXIT.
          ENDIF.

          "D2 > D1
          CALL FUNCTION 'SCOV_TIME_DIFF'
            EXPORTING
              im_date1              = ls_jcds-udate
              im_date2              = ls_afko-gstrs
              im_time1              = ls_jcds-utime
              im_time2              = ls_afko-gsups
            IMPORTING
              ex_days               = lv_days
              ex_time               = lv_time
            EXCEPTIONS
              start_larger_than_end = 1
              OTHERS                = 2.

          lv_time_difference =  ( lv_days * 1440 ) + ( lv_time / 60 ). ">>minutes

          IF lv_time_difference LE lc_threshold.

            e_update = abap_true.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD conv_spool_list_2_table.

    TYPE-POOLS: slis.

    DATA: BEGIN OF gstbl_data,
            data(2048) TYPE c,
          END OF gstbl_data.
    DATA: gtbl_data LIKE TABLE OF gstbl_data.

    DATA: BEGIN OF gstbl_col,
            col(255) TYPE c,
          END OF gstbl_col.
    DATA: gtbl_col LIKE TABLE OF gstbl_col.

    DATA: BEGIN OF gs_return,
            number(12) TYPE c,
          END OF gs_return.
    DATA: gt_return LIKE TABLE OF gs_return.



    DATA gv_line TYPE i.
    DATA gv_length TYPE i.
    DATA gv_cnt TYPE i.
    DATA gv_dec TYPE i.
    DATA gv_row(2048) TYPE c. "string.
    DATA gv_row_d(2048) TYPE c. "string.
    DATA gv_spoolnum TYPE tsp01-rqident.

    DATA gtbl_fieldcat TYPE  slis_t_fieldcat_alv.
    DATA gstr_fieldcat LIKE LINE OF gtbl_fieldcat.
    DATA gstr_data LIKE LINE OF gtbl_data.
    DATA gstr_data_d LIKE LINE OF gtbl_data.
    DATA gtbl_match TYPE match_result_tab.
    DATA gtbl_match_last TYPE match_result_tab.
    DATA gtbl_fcat TYPE lvc_t_fcat.
    DATA gstr_fcat LIKE LINE OF gtbl_fcat.

    DATA gref_data TYPE REF TO data.
    DATA gref_new_line TYPE REF TO data.

    FIELD-SYMBOLS: <fs_data> TYPE REF TO data.
    FIELD-SYMBOLS: <fs_dyntable> TYPE STANDARD TABLE.
    FIELD-SYMBOLS: <fs_match> LIKE LINE OF gtbl_match.
    FIELD-SYMBOLS: <fs_dynline> TYPE any.
    FIELD-SYMBOLS: <fs_dynstruct> TYPE any.

*******************************************************************************
    " Read the spool
    gv_spoolnum = i_spooln.
    CALL FUNCTION 'RSPO_RETURN_ABAP_SPOOLJOB'
      EXPORTING
        rqident = gv_spoolnum
      TABLES
        buffer  = gtbl_data.

*******************************************************************************
    " Pre-check to make sure we have a list
    " simply checking the first char of the
    " first and the last line
    READ TABLE gtbl_data INTO gstr_data INDEX 1.
    IF sy-subrc = 0.
      IF gstr_data-data(1) <> '-'.
        MESSAGE 'Spool does not contain any ALV list' TYPE 'E'.
      ELSE.
        " Number of rows
        gv_line = lines( gtbl_data ).

        " Read the last line
        READ TABLE gtbl_data INTO gstr_data INDEX gv_line.
        IF sy-subrc = 0.
          IF gstr_data-data(1) <> '-'.
            MESSAGE 'Spool does not contain any ALV list' TYPE 'E'.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

*******************************************************************************
    " Start with the N table in the spool.
    IF i_start_table > 1.
      FREE gv_line.

      gv_dec = i_start_table.
      SUBTRACT 1 FROM gv_dec.
      gv_dec = gv_dec * 2.

      " Find the end of the table N - 1
      LOOP AT gtbl_data INTO gstr_data WHERE data(1) = '-'.
        ADD 1 TO gv_line.

        IF gv_line = gv_dec.
          gv_dec = sy-tabix.

          EXIT.
        ENDIF.
      ENDLOOP.

      " Delete the rows up table N
      DELETE gtbl_data FROM 1 TO gv_dec.
    ENDIF.

*******************************************************************************
    " Check how many ALV list are in the spool
    " and make sure if more than one the # of columns are matching
    FREE gv_line .
    LOOP AT gtbl_data INTO gstr_data WHERE data(1) = '-'.
      ADD 1 TO gv_line.
      gv_cnt = gv_line MOD 2.

      " The column headings are on odd number in our find counter
      IF gv_cnt <> 0.
        " Save the find counter value
        gv_cnt = gv_line.

        " Update index to point to column heading row and read
        gv_line = sy-tabix + 1.
        READ TABLE gtbl_data INDEX gv_line INTO gstr_data.
        gv_row = gstr_data-data.

        " Find the columns: position and length
        FIND ALL OCCURRENCES OF '|' IN gv_row RESULTS gtbl_match.

        " Compare the previous heading w/ current
        IF gtbl_match[] <> gtbl_match_last[] AND sy-tabix > 2.
          MESSAGE 'Spool contains more than one ALV list where column headings are different.' TYPE 'E'.
        ENDIF.

        FREE: gtbl_match_last, gv_row.
        gtbl_match_last[] = gtbl_match[].
        FREE gtbl_match.

        " Get back the find counter value
        gv_line = gv_cnt.
      ENDIF.
    ENDLOOP.

*******************************************************************************
    " Read column heading row
    READ TABLE gtbl_data INDEX 2 INTO gstr_data.
    gv_row = gstr_data-data.

    " Read also the first data row
    " Here we are assuming tha the first row all fields
    " filled in; will use this to determine mumeric or char
    READ TABLE gtbl_data INDEX 4 INTO gstr_data_d.
    gv_row_d = gstr_data_d-data.

    " Find out the columns
    FIND ALL OCCURRENCES OF '|' IN gv_row RESULTS gtbl_match.

    FREE: gv_cnt, gv_line.

    " Setup the field catalog for itab
    LOOP AT gtbl_match ASSIGNING <fs_match>.
      IF sy-tabix > 1.
        " Field length
        gv_length = <fs_match>-offset - gv_line - 1.

        " Update counter used for column heading
        ADD 1 TO gv_cnt.

        " Used for dynamic itab
        gstr_fcat-datatype = 'C'.
        gstr_fcat-fieldname = gv_cnt.
        gstr_fcat-intlen = gv_length.
        gstr_fcat-tabname = ''.
        CONDENSE gstr_fcat-fieldname.
        " Debug and you will see why...
        SUBTRACT 1 FROM gv_length.

        " Used for ALV grid
        gstr_fieldcat-reptext_ddic = gv_row+gv_line(gv_length).
        gstr_fieldcat-tabname = ''.
        gstr_fieldcat-fieldname = gv_cnt.
        gstr_fieldcat-just = 'L'.
        gstr_fieldcat-outputlen = gv_length.
        CONDENSE gstr_fieldcat-fieldname.
        APPEND gstr_fcat TO gtbl_fcat.
        APPEND gstr_fieldcat TO gtbl_fieldcat.

        FREE: gstr_fcat, gstr_fieldcat, gv_dec.
      ENDIF.

      " Start position of next column
      gv_line = <fs_match>-offset + 1.
    ENDLOOP.

    ASSIGN gref_data TO <fs_data>.

*******************************************************************************
    " Create a dynamic table based on the number of columns above
    CALL METHOD cl_alv_table_create=>create_dynamic_table
      EXPORTING
        it_fieldcatalog           = gtbl_fcat
      IMPORTING
        ep_table                  = <fs_data>
      EXCEPTIONS
        generate_subpool_dir_full = 1
        OTHERS                    = 2.

    ASSIGN <fs_data>->* TO <fs_dyntable>.

    " Create a new mem area
    CREATE DATA gref_new_line LIKE LINE OF <fs_dyntable>.

    " Now point our <FS_*> to the mem area
    ASSIGN gref_new_line->* TO <fs_dynstruct>.
    ASSIGN gref_new_line->* TO <fs_dynline>.

*******************************************************************************
    " Remove column headings that appears in the middle
    " which are caused due to spool page-break
    LOOP AT gtbl_data INTO gstr_data_d FROM 4 WHERE data = gstr_data-data.
      DELETE gtbl_data.
    ENDLOOP.

*******************************************************************************
    " Push data to itab
    LOOP AT gtbl_data INTO gstr_data.
      " The first 3 rows are col heading related
      IF sy-tabix > 3 AND (
      gstr_data-data(2) <> '|-' AND " Column heading row
      gstr_data-data(2) <> '--'     " End of list row
            ).

        REPLACE FIRST OCCURRENCE OF '|' IN gstr_data-data WITH space.
        SPLIT gstr_data AT '|' INTO TABLE gtbl_col.

        gv_cnt = 0.

        " Split above makes each column to a row
        " Get each column
        LOOP AT gtbl_col INTO gstbl_col.
          ADD 1 TO gv_cnt.
          ASSIGN COMPONENT gv_cnt OF STRUCTURE <fs_dynstruct> TO <fs_dynline>.

          " Remove space front/end
          CONDENSE gstbl_col-col.

          MOVE gstbl_col-col TO <fs_dynline>.
          CLEAR gstbl_col.
        ENDLOOP.

        APPEND <fs_dynstruct> TO <fs_dyntable>.

        gv_cnt = 0.
        FREE: gtbl_col.
      ENDIF.

      FREE gstr_data.
    ENDLOOP.

*******************************************************************************
    " Sum line flag, keep or delete
    IF i_keep_sum_line IS INITIAL.

      LOOP AT <fs_dyntable> ASSIGNING <fs_dynline>.
        IF <fs_dynline>(1) = '*'.
          DELETE <fs_dyntable>.
        ENDIF.
      ENDLOOP.
    ENDIF.


    et_spool_table[] = <fs_dyntable>[].

*******************************************************************************
    " Display
*  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
*    EXPORTING
*      it_fieldcat = gtbl_fieldcat
*    TABLES
*      t_outtab    = <fs_dyntable>.





  ENDMETHOD.


  METHOD create_consumptions.

*Internal tables
    DATA lt_goodsmvt_item TYPE TABLE OF bapi2017_gm_item_create.

*Structures
    DATA: ls_goodsmvt_header  TYPE bapi2017_gm_head_01,
          ls_goodsmvt_code    TYPE bapi2017_gm_code,
          ls_goodsmvt_item    TYPE bapi2017_gm_item_create,
          ls_goodsmvt_headret TYPE bapi2017_gm_head_ret,
          ls_return           LIKE LINE OF return_tab,
          lt_return_tab       TYPE bapiret2_t.

*Variables
    DATA: lv_materialdocument TYPE bapi2017_gm_head_ret-mat_doc,
          lv_matdocumentyear  TYPE bapi2017_gm_head_ret-doc_year,
          lf_no_commit        TYPE boole_d.

    DATA: ra_lgort TYPE RANGE OF lgort_d.

    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_inputobj-werks
        i_parameter = 'LGORT_CONSUM'
      IMPORTING
        et_range    = ra_lgort.

    READ TABLE ra_lgort INTO DATA(ls_lgort) INDEX 1.

*Header of material document
    ls_goodsmvt_header-pstng_date = sy-datlo.
    ls_goodsmvt_header-doc_date = sy-datlo.


*Movement type
    ls_goodsmvt_code-gm_code = '03'.

*Data to create movement
*Plant
    ls_goodsmvt_item-plant = i_inputobj-werks.
*Movement Type
    ls_goodsmvt_item-move_type = '261'.
*Production Order
    ls_goodsmvt_item-orderid = i_aufnr.

* Storage Location
    move ls_lgort-low to ls_goodsmvt_item-stge_loc.


    LOOP AT it_consumptions INTO DATA(ls_consumptions).
*  Material - Component
      ls_goodsmvt_item-material = ls_consumptions-matnr.
*  Quantity
      ls_goodsmvt_item-entry_qnt = ls_consumptions-bdmng.
*  Unit
      ls_goodsmvt_item-entry_uom = ls_consumptions-meins.
**  Storage Location from material master data
*      SELECT SINGLE lgpro FROM marc INTO ls_goodsmvt_item-stge_loc
*        WHERE matnr = ls_consumptions-matnr
*        AND werks = i_inputobj-werks.

      APPEND ls_goodsmvt_item TO lt_goodsmvt_item.
    ENDLOOP.

*Create consumption of the Production Order
    CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
      EXPORTING
        goodsmvt_header  = ls_goodsmvt_header
        goodsmvt_code    = ls_goodsmvt_code
      IMPORTING
        goodsmvt_headret = ls_goodsmvt_headret
        materialdocument = lv_materialdocument
        matdocumentyear  = lv_matdocumentyear
      TABLES
        goodsmvt_item    = lt_goodsmvt_item
        return           = lt_return_tab.

    LOOP AT lt_return_tab INTO ls_return
       WHERE type CA 'AEX'.

      CALL METHOD zcl_absf_pm=>add_message
        EXPORTING
          msgid      = ls_return-id
          msgty      = ls_return-type
          msgno      = ls_return-number
          msgv1      = ls_return-message_v1
          msgv2      = ls_return-message_v2
          msgv3      = ls_return-message_v3
          msgv4      = ls_return-message_v4
        CHANGING
          return_tab = return_tab.

      lf_no_commit = abap_true.
    ENDLOOP.

    CHECK lf_no_commit EQ abap_false.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.

*  Send message sucess.
    CALL METHOD zcl_absf_pm=>add_message
      EXPORTING
        msgty      = 'S'
        msgno      = '008'
        msgv1      = lv_materialdocument
      CHANGING
        return_tab = return_tab.


  ENDMETHOD.


  METHOD create_maintenance_notif.

    CONSTANTS: gc_param_id TYPE param_id VALUE 'NOTIFY_TYPE'. "BMR: not used - user must allways select notif type

    DATA: lv_taskdetermination type xfeld value ''.

    DATA: ls_notif_header  TYPE bapi2080_nothdri,
          ls_header_export TYPE bapi2080_nothdre,
          ls_header_save   TYPE bapi2080_nothdre,
          lt_return        TYPE TABLE OF bapiret2,
          lt_return_save   TYPE TABLE OF bapiret2.

*   >>> CFB : alteraçoes para incluir o parceiro
    DATA: ls_notif_partner TYPE bapi2080_notpartnri,
          lt_notif_partner TYPE TABLE OF bapi2080_notpartnri.

    DATA: lv_objnr TYPE equi-objnr.

    DATA: lt_textline TYPE TABLE OF tdline,
          ls_textline LIKE LINE OF lt_textline,
          lt_longtext TYPE TABLE OF bapi2080_notfulltxti,
          ls_longtext LIKE LINE OF lt_longtext,
          lv_name     TYPE vornamc,
          lv_lastname TYPE nachnmc.

    DATA lv_objkey TYPE objkey.

    FIELD-SYMBOLS <fs_longtext> TYPE bapi2080_notfulltxti.


    ls_notif_header-equipment   = i_equipment.
    ls_notif_header-short_text  = i_description.
    ls_notif_header-breakdown   = i_breakdown.
    ls_notif_header-reportedby  = i_inputobj-pernr.
    ls_notif_header-funct_loc   = i_func_loc.

    ls_notif_header-code_group  = i_coding_grp.
    ls_notif_header-coding      = i_coding_cod.
    ls_notif_header-doc_number  = i_salesdoc_id.
    ls_notif_header-itm_number  = i_salesdoc_item.


    SELECT SINGLE objid INTO @DATA(lv_pm_wkcenter)
      FROM crhd
      WHERE werks EQ @i_inputobj-werks
        AND objty EQ 'A'
        AND verwe EQ '0001'
        AND arbpl EQ @i_arbpl
        AND begda LE @sy-datlo
        AND endda GE @sy-datlo.

    EXPORT pm_wkcenter = lv_pm_wkcenter TO MEMORY ID 'Z_PM_SHOPFLOOR_CREATE_NOTIF'.

    IF i_notif_type IS INITIAL.

      IF sy-subrc NE 0.
* missing customization - throw error message and leave.
*        MESSAGE e016(ZABSF_PM).
        CALL METHOD zcl_absf_pm=>add_message
          EXPORTING
            msgty      = 'E'
            msgno      = '016'
          CHANGING
            return_tab = return_tab.

        EXIT.
      ENDIF.

    ENDIF.

    CASE i_breakdown.

      WHEN abap_true.
        ls_notif_header-priority = '1'.

      WHEN   abap_false.
        ls_notif_header-priority = '3'.

      WHEN OTHERS.
        ls_notif_header-priority = '3'.

    ENDCASE.

    CALL FUNCTION 'SOTR_SERV_STRING_TO_TABLE'
      EXPORTING
        text     = i_commentary
*       FLAG_NO_LINE_BREAKS       = 'X'
*       line_length = 132
*       LANGU    = SY-LANGU
      TABLES
        text_tab = lt_textline.

    APPEND LINES OF it_not_ok_texts TO lt_longtext.

* get operator information.
    SELECT SINGLE nchmc vnamc FROM pa0002
      INTO (lv_name, lv_lastname)
      WHERE pernr = i_inputobj-pernr.

    CONCATENATE i_inputobj-pernr lv_name lv_lastname INTO ls_longtext-text_line SEPARATED BY space.
    ls_longtext-objtype = 'QMEL'.
    ls_longtext-format_col = '/'.
    APPEND ls_longtext TO lt_longtext.
    CLEAR ls_longtext.

    LOOP AT lt_textline INTO ls_textline.

      ls_longtext-text_line  =  ls_textline.
      ls_longtext-objtype = 'QMEL'.
      ls_longtext-format_col = '/'.
      APPEND ls_longtext TO lt_longtext.
      CLEAR ls_textline.
    ENDLOOP.

    LOOP AT lt_longtext ASSIGNING <fs_longtext>.
      ADD 1 TO lv_objkey.
      <fs_longtext>-objkey = lv_objkey.

    ENDLOOP.

*  >>> CFB - 02.10.2018 alteraçao para incluir parceiro ao criar a notificacao
*   preencher estrutura de parceiro para incluir o parceiro com a funcao (ZA) na criacao da nota de PM
    IF NOT i_rsp_user_resp IS INITIAL.

      ls_notif_partner-partn_role = 'ZA'.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = i_rsp_user_resp
        IMPORTING
          output = ls_notif_partner-partner.

      APPEND ls_notif_partner TO lt_notif_partner.
    ENDIF.


    CALL FUNCTION 'BAPI_ALM_NOTIF_CREATE'
      EXPORTING
        notif_type         = i_notif_type
        notifheader        = ls_notif_header
        task_determination = lv_taskdetermination
      IMPORTING
        notifheader_export = ls_header_export
      TABLES
        notifpartnr        = lt_notif_partner
        longtexts          = lt_longtext
        return             = lt_return.

    LOOP AT lt_return TRANSPORTING NO FIELDS
                WHERE ( type CA 'AEX' ).  " Abort, Error, or Dump
      EXIT.
    ENDLOOP.

    IF sy-subrc EQ 0.

      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      return_tab = lt_return.

    ELSE.

      CALL FUNCTION 'BAPI_ALM_NOTIF_SAVE'
        EXPORTING
          number      = ls_header_export-notif_no
        IMPORTING
          notifheader = ls_header_save
        TABLES
          return      = lt_return_save.

      IF ls_header_save-notif_no IS NOT INITIAL.

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = abap_true.

* add success message
        CALL METHOD zcl_absf_pm=>add_message
          EXPORTING
            msgty      = 'S'
            msgno      = '017'
            msgv1      = ls_header_save-notif_no
          CHANGING
            return_tab = return_tab.

      ELSE.
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

        LOOP AT lt_return_save TRANSPORTING NO FIELDS
               WHERE ( type CA 'AEX' ).  " Abort, Error, or Dump
          EXIT.
        ENDLOOP.

        IF sy-subrc EQ 0.
          return_tab = lt_return_save.
        ELSE.

* add error message
          CALL METHOD zcl_absf_pm=>add_message
            EXPORTING
              msgty      = 'E'
              msgno      = '018'
            CHANGING
              return_tab = return_tab.
        ENDIF.
      ENDIF.

    ENDIF.



  ENDMETHOD.


  METHOD create_pm_order.
*  Internal table
    DATA: lt_methods     TYPE TABLE OF bapi_alm_order_method,
          lt_header      TYPE TABLE OF bapi_alm_order_headers_i,
          lt_return      TYPE TABLE OF bapiret2,
          lt_return_rel  TYPE TABLE OF bapiret2,
          lt_numbers     TYPE TABLE OF bapi_alm_numbers,
          lt_numbers_rel TYPE TABLE OF bapi_alm_numbers.

    DATA: it_operation TYPE TABLE OF bapi_alm_order_operation,
          wa_operation LIKE LINE OF it_operation.

*   >>> CFB : alteraçoes para incluir o parceiro
    DATA: ls_order_partner TYPE bapi_alm_order_partn_mul,
          lt_order_partner TYPE TABLE OF bapi_alm_order_partn_mul.


*    DATA: lv_status_disp   TYPE tj30-estat,
*          lv_status_ofic   TYPE tj30-estat,
*          lv_status_schema TYPE tj30-stsma,
*          lv_parva         TYPE zabsf_pm_param-parva.


*  Structures
    DATA: ls_methods TYPE bapi_alm_order_method,
          ls_header  TYPE bapi_alm_order_headers_i.

*  Variables
    DATA: l_objectkey TYPE objidext,
          l_temp      TYPE char12 VALUE '%00000000001',
          l_flag      TYPE char1,
          l_flag_rel  TYPE char1,
          l_msgv1     TYPE symsgv.

    DATA: ra_pm_key_control TYPE RANGE OF steus,
          ra_cs_key_control TYPE RANGE OF steus,
          ra_pm_types       TYPE RANGE OF auart,
          ra_cs_types       TYPE RANGE OF auart.


** get value from parameter USER_STAT_CHKIN
*    SELECT SINGLE parva
*      INTO lv_parva
*      FROM zabsf_pm_param
*      WHERE werks = i_inputobj-werks AND
*            parid = 'USER_STAT_CHKIN'.
*
*    MOVE lv_parva TO lv_status_disp.
*
** get value from parameter USER_STAT_CHKOUT
*    SELECT SINGLE parva
*      INTO lv_parva
*      FROM zabsf_pm_param
*      WHERE werks = i_inputobj-werks AND
*            parid = 'USER_STAT_CHKOUT'.
*
*    MOVE lv_parva TO lv_status_ofic.
*
** get value from parameter USER_STAT_PROFILE
*    SELECT SINGLE parva
*      INTO lv_parva
*      FROM zabsf_pm_param
*      WHERE werks = i_inputobj-werks AND
*            parid = 'USER_STAT_PROFILE'.
*
*    MOVE lv_parva TO lv_status_schema.



    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_inputobj-werks
        i_parameter = 'PM_KEY_CONTROL'
      IMPORTING
        et_range    = ra_pm_key_control.

    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_inputobj-werks
        i_parameter = 'CS_KEY_CONTROL'
      IMPORTING
        et_range    = ra_cs_key_control.

    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_inputobj-werks
        i_parameter = 'AUFART_PM_CREATION'
      IMPORTING
        et_range    = ra_pm_types.

    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_inputobj-werks
        i_parameter = 'AUFART_CS_CREATION'
      IMPORTING
        et_range    = ra_cs_types.

    CLEAR l_objectkey.

*  Method - Create Order from notification
    CLEAR ls_methods.
    ls_methods-refnumber = '000001'.
    ls_methods-objecttype = 'HEADER'.
    ls_methods-method = 'CREATETONOTIF'.

*  Create object key
    CONCATENATE l_temp i_qmnum INTO l_objectkey.

    ls_methods-objectkey = l_objectkey  . "Notification number

    APPEND ls_methods TO lt_methods.

    ls_methods-refnumber = '000001'.
    ls_methods-objecttype = 'OPERATION'.
    ls_methods-method = 'CREATE'.
    ls_methods-objectkey = '%00000000001'.
    APPEND ls_methods TO lt_methods.

*   partner method
    ls_methods-refnumber = '000001'.
    ls_methods-objecttype = 'PARTNER'.
    ls_methods-method = 'CREATE'.
    ls_methods-objectkey = '%00000000001'.
    APPEND ls_methods TO lt_methods.

*  Save method
    CLEAR ls_methods.

    ls_methods-refnumber = '000001'.
    ls_methods-objecttype = ''.
    ls_methods-method = 'SAVE'.
    APPEND ls_methods TO lt_methods.

*OPERATION
    wa_operation-activity = '10'.
*get control key
    IF i_auart IN ra_pm_types.
      DATA(ls_key) = ra_pm_key_control[ 1 ].
      wa_operation-control_key = ls_key-low.

    ENDIF.

    IF i_auart IN ra_cs_types.
      ls_key = ra_cs_key_control[ 1 ].
      wa_operation-control_key = ls_key-low.
    ENDIF.

    wa_operation-work_cntr = i_arbpl.
    wa_operation-plant = i_inputobj-werks.

    SELECT SINGLE qmtxt FROM qmel INTO wa_operation-description
      WHERE qmnum EQ i_qmnum.
    wa_operation-langu = sy-langu.

    APPEND wa_operation TO it_operation.


*  Data for header
    CLEAR ls_header.
    ls_header-orderid = l_temp.
    ls_header-order_type = i_auart.
    ls_header-planplant = i_inputobj-werks.
    ls_header-plant = i_arbpl_plant.
    ls_header-notif_no = i_qmnum.
    ls_header-pmacttype = i_ilart.
    ls_header-mn_wk_ctr = i_arbpl.

    IF i_gsber IS NOT INITIAL.
      ls_header-bus_area = i_gsber.
    ENDIF.



*  Check if notification ha breakdown and get Equipment
    SELECT SINGLE msaus, equnr
      FROM qmih
      INTO (@DATA(l_msaus), @DATA(lv_equnr))
     WHERE qmnum EQ @i_qmnum.


    IF l_msaus IS NOT INITIAL.
      ls_header-priority = 1.
    ELSE.
      ls_header-priority = 3.
    ENDIF.

    ls_header-start_date  = sy-datum.
    ls_header-finish_date = sy-datum.
    ls_header-basic_fin = sy-uzeit.
    ls_header-basicstart = sy-uzeit.

    APPEND ls_header TO lt_header.


*  >>> CFB - 08.10.2018 alteraçao para incluir parceiro ao criar a ordem
* preencher estrutura de parceiro para incluir o parceiro com a funcao (ZB) na criacao da ordem
    IF NOT i_rsp_user_resp IS INITIAL.

      ls_order_partner-partn_role = 'VW'.
      ls_order_partner-orderid = l_temp.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = i_rsp_user_resp
        IMPORTING
          output = ls_order_partner-partner.

      APPEND ls_order_partner TO lt_order_partner.
    ENDIF.

*>>>> CFB 12.10.2018 Envio das garantias na mensagem de sucesso da criacao da ordem

    DATA: lv_msgno     TYPE symsgno,
          lv_msg_start TYPE symsgv,
          lv_msg_end   TYPE symsgv.


    SELECT SINGLE objnr FROM equi
      INTO @DATA(lv_objnr_equi)
     WHERE equnr = @lv_equnr.

    SELECT * FROM bgmkobj
      INTO TABLE @DATA(lt_bgmkobj)
      WHERE j_objnr = @lv_objnr_equi.

*   ler a tabela de garantias para cada um dos equipamentos encontrados
    LOOP AT lt_bgmkobj INTO DATA(ls_bgmkobj).

      IF sy-subrc EQ 0.

        CASE ls_bgmkobj-gaart. "case ao tipo de garantia

          WHEN '2'. "garantia do tipo 2 Fornecedor

            IF sy-datum BETWEEN ls_bgmkobj-gwldt AND ls_bgmkobj-gwlen.

              lv_msgno = '038'.
              lv_msg_start = ls_bgmkobj-gwldt.
              lv_msg_end   = ls_bgmkobj-gwlen.

*              CONCATENATE ls_bgmkobj-gwldt 'a' ls_bgmkobj-gwlen INTO lv_str_warranty SEPARATED BY space.

            ENDIF.
          WHEN '3'. "garantia do tipo 3 Fabricante

            IF sy-datum BETWEEN ls_bgmkobj-gwldt AND ls_bgmkobj-gwlen.

              lv_msgno = '039'.
              lv_msg_start = ls_bgmkobj-gwldt.
              lv_msg_end   = ls_bgmkobj-gwlen.

*              CONCATENATE ls_bgmkobj-gwldt 'a' ls_bgmkobj-gwlen INTO lv_str_warranty SEPARATED BY space.
            ENDIF.
          WHEN OTHERS. " só vamos tratar as do tipo 2 e 3

        ENDCASE.

      ENDIF.
    ENDLOOP.

*<<<< CFB 12.10.2018 Envio das garantias na mensagem de sucesso da criacao da ordem

*  Create order from notification
    CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
      TABLES
        it_methods   = lt_methods
        it_header    = lt_header
        return       = lt_return
        et_numbers   = lt_numbers
        it_operation = it_operation
        it_partner   = lt_order_partner. " funcao de Parceiro Obrigatória


    CLEAR l_flag.

    LOOP AT lt_return INTO DATA(ls_return) WHERE type EQ 'E'.
*    Send error message
      CALL METHOD zcl_absf_pm=>add_message
        EXPORTING
          msgid      = ls_return-id
          msgty      = ls_return-type
          msgno      = ls_return-number
          msgv1      = ls_return-message_v1
          msgv2      = ls_return-message_v2
          msgv3      = ls_return-message_v3
          msgv4      = ls_return-message_v4
        CHANGING
          return_tab = et_return_tab.

      l_flag = abap_true.
    ENDLOOP.

    IF l_flag IS INITIAL.
*    Save order

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.

      WAIT UP TO 1 SECONDS.

*       verificar se a criacaoda notificacao pretende uma paragem
      IF l_msaus = 'X'.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lv_equnr
          IMPORTING
            output = lv_equnr.

        CALL METHOD zcl_absf_pm=>change_equi_status
          EXPORTING
            i_equnr     = lv_equnr
            i_operation = 'IN'
            i_werks     = i_inputobj-werks.


*        SELECT SINGLE eqtyp, objnr
*          FROM equi
*          INTO (@DATA(lv_eqtyp) , @DATA(lv_objnr) )
*        WHERE equnr = @lv_equnr.
*
*
*        IF lv_eqtyp = 'F'.
*
**           >>> CFB 08.10.2018 Check-in of equipment - change status to OFIC
*
**            DATA OBJNR          TYPE JEST-OBJNR.
**            DATA ESTAT_INACTIVE TYPE TJ30-ESTAT.
**            DATA ESTAT_ACTIVE   TYPE TJ30-ESTAT.
**            DATA STSMA          TYPE JSTO-STSMA.
*
*          CALL FUNCTION 'I_CHANGE_STATUS'
*            EXPORTING
*              objnr          = lv_objnr
*              estat_inactive = lv_status_disp
*              estat_active   = lv_status_ofic
*              stsma          = lv_status_schema
*            EXCEPTIONS
*              cannot_update  = 1
*              OTHERS         = 2.
*          IF sy-subrc <> 0.
**    * Implement suitable error handling here
*          ENDIF.
**      <<< CFB 08.10.2018 Check-in of equipment - change status to OFIC
*
*        ENDIF.
      ENDIF.


*    Maintenance order created
      READ TABLE lt_numbers INTO DATA(ls_numbers) INDEX 1.

      IF sy-subrc EQ 0.
        REFRESH: lt_methods,
                 lt_return_rel,
                 lt_numbers_rel.

*      New Order created
        l_msgv1 = ls_numbers-aufnr_new.

*      IT_METHODS - header
        CLEAR ls_methods.
        ls_methods-refnumber = 1.
        ls_methods-objecttype = 'HEADER'.
        ls_methods-method = 'RELEASE'.
        ls_methods-objectkey = ls_numbers-aufnr_new.
        APPEND ls_methods TO lt_methods.

*      IT_METHODS - SAVE
        CLEAR ls_methods.
        ls_methods-refnumber = 1.
        ls_methods-method = 'SAVE'.
        ls_methods-objectkey = ls_numbers-aufnr_new.
        APPEND ls_methods TO lt_methods.

        l_msgv1 = ls_numbers-aufnr_new.

        REFRESH lt_return_rel.

*      Release order from notification
*        CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
*          TABLES
*            it_methods = lt_methods
*            return     = lt_return_rel
*            et_numbers = lt_numbers_rel.

        IF lt_return_rel[] IS NOT INITIAL.
          LOOP AT lt_return_rel INTO DATA(ls_return_rel) WHERE type EQ 'E'.
*          Send error message
            CALL METHOD zcl_absf_pm=>add_message
              EXPORTING
                msgid      = ls_return_rel-id
                msgty      = ls_return_rel-type
                msgno      = ls_return_rel-number
                msgv1      = ls_return_rel-message_v1
                msgv2      = ls_return_rel-message_v2
                msgv3      = ls_return_rel-message_v3
                msgv4      = ls_return_rel-message_v4
              CHANGING
                return_tab = et_return_tab.

            l_flag_rel = abap_true.
          ENDLOOP.

          IF l_flag_rel IS NOT INITIAL.
            EXIT.
          ELSE.
*          Save order
            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
              EXPORTING
                wait = abap_true.


          ENDIF.
        ENDIF.
      ENDIF.

*    Send message: Maintenance order & created successfully.
      CALL METHOD zcl_absf_pm=>add_message
        EXPORTING
          msgty      = 'S'
          msgno      = '006'
          msgv1      = l_msgv1
        CHANGING
          return_tab = et_return_tab.

*    CFB - 12.10.2018 Send Warranty Dates if exist on message
      IF NOT lv_msgno IS INITIAL.

        CALL METHOD zcl_absf_pm=>add_message
          EXPORTING
            msgty      = 'S'
            msgno      = lv_msgno
            msgv1      = lv_msg_start
            msgv2      = lv_msg_end
          CHANGING
            return_tab = et_return_tab.
      ENDIF.


    ELSE.

      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

    ENDIF.
  ENDMETHOD.


  METHOD create_pr.


    DATA: lt_bapi_methods TYPE TABLE OF bapi_alm_order_method,
          ls_bapi_methods LIKE LINE OF lt_bapi_methods,

          lt_ordmaint_ret TYPE bapiret2_t,
          ls_ordmaint_ret LIKE LINE OF lt_ordmaint_ret,

          lt_comp         TYPE TABLE OF bapi_alm_order_component,
          ls_comp         LIKE LINE OF lt_comp,
          lt_numbers      TYPE TABLE OF bapi_alm_numbers.

    DATA: lv_aufnr        TYPE aufnr.

    DATA: BEGIN OF ls_resb_aux.
    DATA: banfn TYPE banfn,
          bnfpo TYPE bnfpo.
    DATA: END OF ls_resb_aux.
    DATA: lt_resb         LIKE TABLE OF ls_resb_aux.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = i_aufnr
      IMPORTING
        output = lv_aufnr.


*   bapi methods
    ls_bapi_methods-refnumber = 1.
    ls_bapi_methods-objecttype = 'COMPONENT'.
    ls_bapi_methods-method = 'CREATE'.
    ls_bapi_methods-objectkey = lv_aufnr.
    APPEND ls_bapi_methods TO lt_bapi_methods.
    CLEAR ls_bapi_methods.


    ls_bapi_methods-refnumber = 1.
    ls_bapi_methods-method = 'SAVE'.
    APPEND ls_bapi_methods TO lt_bapi_methods.

*   get ekorg from TPEXT Profile for external procurement
    SELECT SINGLE ekorg
      INTO @DATA(lv_ekorg)
     FROM tpext
      WHERE profil = '0000001'.

    DATA: ra_lgort TYPE RANGE OF lgort_d.

    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_inputobj-werks
        i_parameter = 'LGORT_CONSUM'
      IMPORTING
        et_range    = ra_lgort.

    READ TABLE ra_lgort INTO DATA(ls_lgort) INDEX 1.

*   components
    LOOP AT it_consumptions INTO DATA(ls_consumption).

      CLEAR: ls_comp.
      ls_comp-plant = i_inputobj-werks.
      ls_comp-item_cat = 'N'.
*      ls_comp-preq_name = 'ReqUser'.
      ls_comp-material = ls_consumption-matnr.
*      ls_comp-matl_desc = ls_consumption-maktx.
      ls_comp-requirement_quantity = ls_consumption-bdmng.

      ls_comp-purch_org = lv_ekorg.

      ls_comp-activity = '0010'.

      IF ls_consumption-preis IS NOT INITIAL.
        ls_comp-price = ls_consumption-preis.
      ENDIF.

      IF ls_consumption-lifnr IS NOT INITIAL.
        ls_comp-vendor_no = ls_consumption-lifnr.
      ENDIF.

*   Storage Location
    move ls_lgort-low to ls_comp-stge_loc.

***************************************

*      ls_comp-requirement_quantity_unit = ls_consumption-meins.
      ls_comp-mrp_relevant = '3'.  " create pr imediately
      APPEND ls_comp TO lt_comp.

    ENDLOOP.


    CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
      TABLES
        it_methods   = lt_bapi_methods
        it_component = lt_comp
        et_numbers   = lt_numbers
        return       = lt_ordmaint_ret.

    LOOP AT lt_ordmaint_ret INTO ls_ordmaint_ret
      WHERE type CA 'AEX'.

      CALL METHOD zcl_absf_pm=>add_message
        EXPORTING
          msgid      = ls_ordmaint_ret-id
          msgty      = ls_ordmaint_ret-type
          msgno      = ls_ordmaint_ret-number
          msgv1      = ls_ordmaint_ret-message_v1
          msgv2      = ls_ordmaint_ret-message_v2
          msgv3      = ls_ordmaint_ret-message_v3
          msgv4      = ls_ordmaint_ret-message_v4
        CHANGING
          return_tab = return_tab.
    ENDLOOP.

    IF return_tab IS INITIAL.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.

      CALL METHOD zcl_absf_pm=>add_message
        EXPORTING
          msgty      = 'S'
          msgno      = '041'
          msgv1      = i_aufnr
        CHANGING
          return_tab = return_tab.

      IF ls_consumption-obs IS NOT INITIAL.
*     INSERT TEXT INTO PURCHASE REQUISITION
        SELECT eban~banfn eban~bnfpo
        FROM resb
        JOIN rsdb
          ON resb~rsnum = rsdb~rsnum AND resb~rspos = rsdb~rspos
        JOIN eban
          ON rsdb~banfn = eban~banfn AND rsdb~bnfpo = eban~bnfpo
        INTO CORRESPONDING FIELDS OF TABLE lt_resb
       WHERE resb~aufnr = lv_aufnr
          ORDER BY eban~bnfpo DESCENDING.

        READ TABLE lt_resb INDEX 1 ASSIGNING FIELD-SYMBOL(<data>).

        IF sy-subrc = 0.
          DATA: ls_header TYPE thead.
          DATA: ls_lines TYPE tline.
          DATA: lt_lines TYPE STANDARD TABLE OF tline.

          DATA: sname TYPE thead-tdname.
          CONCATENATE <data>-banfn <data>-bnfpo INTO sname.

          CLEAR: ls_header, ls_lines.
          REFRESH lt_lines.

          ls_header-tdobject = 'EBAN'.
          ls_header-tdname = sname.
          ls_header-tdid ='B01'.
          ls_header-tdspras = sy-langu.

          ls_lines-tdline = ls_consumption-obs.
          ls_lines-tdformat = '*'.
          APPEND ls_lines TO lt_lines.
          CLEAR ls_lines.

          CALL FUNCTION 'SAVE_TEXT'
            EXPORTING
              header          = ls_header
              insert          = 'X'
              savemode_direct = 'X'
            TABLES
              lines           = lt_lines
            EXCEPTIONS
              id              = 1
              language        = 2
              name            = 3
              object          = 4
              OTHERS          = 5.
        ENDIF.

      ENDIF.

    ENDIF.



  ENDMETHOD.


  METHOD delete_cause_of_notitem.


    DATA : lf_no_commit TYPE flag.

    DATA : lt_notifcaus_i TYPE TABLE OF bapi2080_notcausi,
           ls_notifcaus_i TYPE bapi2080_notcausi.

    DATA: lt_return TYPE bapiret2_t,
          ls_return LIKE LINE OF lt_return.

*   pass the id's to delete the correct
    ls_notifcaus_i-item_sort_no = i_not_item-item_sort_no.
    ls_notifcaus_i-item_key = i_not_item-item_key.

    "get causekey active
    SELECT SINGLE urnum INTO @DATA(lv_causekey)
     FROM qmur WHERE qmnum EQ @i_not_item-notif_no
     AND fenum EQ @i_not_item-item_key AND kzloesch EQ @space.

    ls_notifcaus_i-cause_key = lv_causekey.
    ls_notifcaus_i-cause_sort_no = lv_causekey.

    APPEND ls_notifcaus_i TO lt_notifcaus_i.

*   call bapi to delete notification item
    CALL FUNCTION 'BAPI_ALM_NOTIF_DATA_DELETE'
      EXPORTING
        number    = i_not_item-notif_no
      TABLES
        notifcaus = lt_notifcaus_i
        return    = lt_return.

    LOOP AT lt_return INTO ls_return
       WHERE type CA 'AEX'.

      CALL METHOD zcl_absf_pm=>add_message
        EXPORTING
          msgid      = ls_return-id
          msgty      = ls_return-type
          msgno      = ls_return-number
          msgv1      = ls_return-message_v1
          msgv2      = ls_return-message_v2
          msgv3      = ls_return-message_v3
          msgv4      = ls_return-message_v4
        CHANGING
          return_tab = et_returntab.

      CLEAR ls_return.
      lf_no_commit = abap_true.

    ENDLOOP.

    CHECK lf_no_commit EQ abap_false.

    CALL FUNCTION 'BAPI_ALM_NOTIF_SAVE'
      EXPORTING
        number = i_not_item-notif_no
      TABLES
        return = lt_return.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.

*Send Message : Item &1 from notification nº &2 deleted successfully!
*    CALL METHOD ZCL_ABSF_PM=>add_message
*      EXPORTING
*        msgty      = 'S'
*        msgno      = '028'
*        msgv1      = lv_itemkey
*        msgv2      = i_not_item-notif_no
*      CHANGING
*        return_tab = et_returntab.
  ENDMETHOD.


  METHOD delete_notif_item.

    DATA : lf_no_commit TYPE flag, lv_itemkey TYPE felfd.

    DATA : lt_notitem_i TYPE TABLE OF bapi2080_notitemi,
           ls_notitem_i TYPE bapi2080_notitemi.

    DATA : lt_notifcaus_i TYPE TABLE OF bapi2080_notcausi,
           ls_notifcaus_i TYPE bapi2080_notcausi.

    DATA: lt_return TYPE bapiret2_t,
          ls_return LIKE LINE OF lt_return.

    CLEAR : ls_notitem_i, ls_notifcaus_i.

    "verify is exists notification number if not code stops here
    "CHECK i_not_item-notif_no IS NOT INITIAL.

    MOVE-CORRESPONDING i_not_item TO ls_notitem_i.

    "verify is exists itemkey if not code stops here
    "CHECK ls_notitem_i-item_key IS NOT INITIAL.

    lv_itemkey = ls_notitem_i-item_key.

    APPEND ls_notitem_i TO lt_notitem_i.

*   pass the id's to delete the correct
    ls_notifcaus_i-item_sort_no = ls_notitem_i-item_sort_no.
    ls_notifcaus_i-item_key = ls_notitem_i-item_key.

    "get causekey active
    SELECT SINGLE urnum INTO @DATA(lv_causekey)
     FROM qmur WHERE qmnum EQ @i_not_item-notif_no
     AND fenum EQ @i_not_item-item_key AND kzloesch EQ @space.

    ls_notifcaus_i-cause_key = lv_causekey.
    ls_notifcaus_i-cause_sort_no = lv_causekey.

    APPEND ls_notifcaus_i TO lt_notifcaus_i.

    IF lv_causekey IS INITIAL.
      CLEAR : ls_notifcaus_i, lt_notifcaus_i.
    ENDIF.

*   call bapi to delete notification item
    CALL FUNCTION 'BAPI_ALM_NOTIF_DATA_DELETE'
      EXPORTING
        number    = i_not_item-notif_no
      TABLES
        notitem   = lt_notitem_i
        notifcaus = lt_notifcaus_i
        return    = lt_return.

    LOOP AT lt_return INTO ls_return
       WHERE type CA 'AEX'.

      CALL METHOD zcl_absf_pm=>add_message
        EXPORTING
          msgid      = ls_return-id
          msgty      = ls_return-type
          msgno      = ls_return-number
          msgv1      = ls_return-message_v1
          msgv2      = ls_return-message_v2
          msgv3      = ls_return-message_v3
          msgv4      = ls_return-message_v4
        CHANGING
          return_tab = et_returntab.

      CLEAR ls_return.
      lf_no_commit = abap_true.

    ENDLOOP.

    CHECK lf_no_commit EQ abap_false.

    CALL FUNCTION 'BAPI_ALM_NOTIF_SAVE'
      EXPORTING
        number = i_not_item-notif_no
      TABLES
        return = lt_return.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.

*Send Message : Item &1 from notification nº &2 deleted successfully!
    CALL METHOD zcl_absf_pm=>add_message
      EXPORTING
        msgty      = 'S'
        msgno      = '028'
        msgv1      = lv_itemkey
        msgv2      = i_not_item-notif_no
      CHANGING
        return_tab = et_returntab.

  ENDMETHOD.


  METHOD get_attachments_list.

    DATA ls_appl_object     TYPE gos_s_obj.
    DATA lo_gos_api         TYPE REF TO cl_gos_api.
    DATA lt_attachment_list TYPE gos_t_atta.

    DATA lv_guid TYPE os_guid.

    DATA lt_role_filter     TYPE gos_t_rol.

    DATA ls_attachment      TYPE gos_s_atta.
    DATA ls_attachm_cont    TYPE gos_s_attcont.
    DATA ls_atta_key        TYPE gos_s_attkey.

    DATA l_path             TYPE string VALUE 'C:\Temp\'.
    DATA l_filename         TYPE string.

    DATA gt_content         TYPE STANDARD TABLE OF tdline.
    DATA l_len              TYPE i.
    DATA l_rc               TYPE i.


    DATA : lt_toa01 TYPE TABLE OF toa01,
           ls_toa01 LIKE LINE OF  lt_toa01.

    DATA : lt_toaat TYPE TABLE OF toaat,
           ls_toaat LIKE LINE OF  lt_toaat.

    DATA ls_et_attachment TYPE LINE OF zabsf_pm_t_attachment_list.

    DATA: ls_attachments TYPE gos_s_atta,
          lv_mimetype    TYPE w3conttype.

    TRY.
        lo_gos_api = cl_gos_api=>create_instance( i_gos_obj ).


        APPEND cl_gos_api=>c_attachment TO lt_role_filter.

        lt_attachment_list = lo_gos_api->get_atta_list( lt_role_filter ).



      CATCH cx_gos_api.
    ENDTRY.


    SORT lt_attachment_list BY cr_date DESCENDING.

* delete attachments that are of type ArchivedLink , because we will get them below

    DELETE lt_attachment_list WHERE atta_cat = 'ARL'.

    MOVE-CORRESPONDING lt_attachment_list TO et_attachments.


    FIELD-SYMBOLS <fs_et_attachments> LIKE LINE OF et_attachments.


    LOOP AT et_attachments ASSIGNING <fs_et_attachments>.

      SELECT SINGLE brelguid FROM srgbtbrel INTO lv_guid
        WHERE instid_b EQ <fs_et_attachments>-atta_id.

      "conversion from raw 16 to char
      WRITE lv_guid TO <fs_et_attachments>-brelguid.

    ENDLOOP.


*>>>CFB - modification to get archived link documents, for the equipement and for functional location

* verify if exists Archived documents for equipment

    IF i_gos_obj-typeid = 'EQUI'.

      CLEAR : lt_toa01, lt_toa01, ls_toa01, ls_toaat.

      SELECT * INTO TABLE lt_toa01
        FROM  toa01
        WHERE sap_object = i_gos_obj-typeid
              AND object_id = i_gos_obj-instid.

      SELECT * INTO TABLE lt_toaat
        FROM toaat

        FOR ALL ENTRIES IN lt_toa01
          WHERE arc_doc_id = lt_toa01-arc_doc_id.

      IF lt_toa01 IS NOT INITIAL.

        CLEAR ls_attachment.

        LOOP AT lt_toa01 INTO ls_toa01.

          ls_et_attachment-atta_cat = 'ARL'.
          ls_et_attachment-brelguid = ls_toa01-arc_doc_id.

          ls_et_attachment-cr_date = ls_toa01-ar_date.
          ls_et_attachment-atta_id = ls_toa01-object_id.
          ls_et_attachment-tech_type = ls_toa01-ar_object.

          READ TABLE lt_toaat INTO ls_toaat WITH KEY arc_doc_id = ls_toa01-arc_doc_id.

          ls_et_attachment-descr = ls_toaat-descr.

          ls_et_attachment-cr_time = ls_toaat-creatime.
          ls_et_attachment-cr_user = ls_toaat-creator.
          ls_et_attachment-filename = ls_toaat-filename.

          APPEND ls_et_attachment TO et_attachments.


        ENDLOOP.

      ENDIF.

    ENDIF.


* verify if exists Archived documents for function location
    IF i_gos_obj-typeid = 'BUS0010'.

      CLEAR : lt_toa01, lt_toa01, ls_toa01, ls_toaat.

      SELECT * INTO TABLE lt_toa01
        FROM  toa01
        WHERE sap_object = i_gos_obj-typeid
              AND object_id = i_gos_obj-instid.


      SELECT * INTO TABLE lt_toaat
        FROM toaat

        FOR ALL ENTRIES IN lt_toa01
          WHERE arc_doc_id = lt_toa01-arc_doc_id.


      IF lt_toa01 IS NOT INITIAL.

        CLEAR ls_attachment.

        LOOP AT lt_toa01 INTO ls_toa01.

          ls_et_attachment-atta_cat = 'ARL'.
          ls_et_attachment-brelguid = ls_toa01-arc_doc_id.

          ls_et_attachment-cr_date = ls_toa01-ar_date.
          ls_et_attachment-atta_id = ls_toa01-object_id.
          ls_et_attachment-tech_type = ls_toa01-ar_object.

          READ TABLE lt_toaat INTO ls_toaat WITH KEY arc_doc_id = ls_toa01-arc_doc_id.

          ls_et_attachment-descr = ls_toaat-descr.

          ls_et_attachment-cr_time = ls_toaat-creatime.
          ls_et_attachment-cr_user = ls_toaat-creator.
          ls_et_attachment-filename = ls_toaat-filename.

          APPEND ls_et_attachment TO et_attachments.


        ENDLOOP.

      ENDIF.

    ENDIF.

*<<<CFB - modification to get archived link documents, for the equipement and for functional location



    SORT et_attachments BY cr_date DESCENDING.


  ENDMETHOD.


  METHOD get_attachment_file.

    DATA lo_gos_api         TYPE REF TO cl_gos_api.
    DATA ls_attachm_cont    TYPE gos_s_attcont.
    DATA : l_len        TYPE i,
           ls_srgbtbrel TYPE srgbtbrel.

    DATA ls_atta_key TYPE gos_s_attkey.

    DATA lt_content         TYPE STANDARD TABLE OF tdline.

    DATA : lt_toa01 TYPE TABLE OF toa01,
           ls_toa01 LIKE LINE OF  lt_toa01.

    DATA : lt_toaat TYPE TABLE OF toaat,
           ls_toaat LIKE LINE OF  lt_toaat.

    DATA : lt_binarchivobject TYPE TABLE OF tbl1024,
           ls_binarchivobject TYPE tbl1024.

    DATA : lt_archivobject TYPE TABLE OF docs,
           ls_archivobject TYPE docs.

    DATA : lv_temp_string   TYPE string,
           lv_binlength(12) TYPE n,
           lv_length        TYPE i.

    IF i_atta_cat = 'ARL'.

      " get info from toa01
      SELECT SINGLE * INTO ls_toa01
        FROM toa01
        WHERE arc_doc_id = i_guid.

      "get info from toaat
      SELECT SINGLE * INTO  ls_toaat
      FROM toaat
     " FOR ALL ENTRIES IN lt_toa01
        WHERE arc_doc_id = i_guid.


      CALL FUNCTION 'ARCHIVOBJECT_GET_TABLE'
        EXPORTING
          archiv_doc_id   = ls_toa01-arc_doc_id
          archiv_id       = ls_toa01-archiv_id
          document_type   = ''
          compid          = 'data'
          signature       = 'X'
        IMPORTING
          binlength       = lv_binlength
        TABLES
          archivobject    = lt_archivobject
          binarchivobject = lt_binarchivobject.


      MOVE lv_binlength TO lv_length.


*get xstring
      CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
        EXPORTING
          input_length = lv_length
        IMPORTING
          buffer       = e_file_base64
        TABLES
          binary_tab   = lt_binarchivobject[].
      IF sy-subrc <> 0.
*        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.


      CALL FUNCTION 'SDOK_MIMETYPE_GET'
        EXPORTING
          extension = ls_toa01-reserve
        IMPORTING
          mimetype  = e_file_mimetype.

* get file Extension

      CALL METHOD cl_bcs_utilities=>split_name
        EXPORTING
          iv_name      = ls_toaat-filename
          iv_delimiter = '.'
        IMPORTING
          ev_extension = e_file_extension.



    ELSE.



      IF  i_atta_cat IS NOT INITIAL AND i_atta_id IS NOT INITIAL.

        ls_atta_key-atta_id = i_atta_id.
        ls_atta_key-atta_cat = i_atta_cat.

      ELSE.

        CHECK i_guid IS NOT INITIAL.

        SELECT SINGLE * FROM srgbtbrel INTO ls_srgbtbrel
        WHERE brelguid = i_guid.

        IF sy-subrc EQ 0.
          ls_atta_key-atta_id = ls_srgbtbrel-instid_b.
          ls_atta_key-atta_cat = 'MSG'.

        ENDIF.


      ENDIF.

      DATA ls_object TYPE sibflporb.

      TRY.
          lo_gos_api = cl_gos_api=>create_instance( ls_object ).

        CATCH cx_gos_api.
      ENDTRY.

*Obtém conteúdo do anexo
      TRY.
          ls_attachm_cont = lo_gos_api->get_al_item( ls_atta_key ).
        CATCH cx_gos_api.

      ENDTRY.

*Caso o ficheiro não ser XSTRING, converte
      IF ls_attachm_cont-content_x IS INITIAL.

        CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
          EXPORTING
            text   = ls_attachm_cont-content
          IMPORTING
            buffer = ls_attachm_cont-content_x
          EXCEPTIONS
            failed = 1
            OTHERS = 2.
        IF sy-subrc <> 0.

        ENDIF.

      ENDIF.

      CALL FUNCTION 'SDOK_MIMETYPE_GET'
        EXPORTING
          extension = ls_attachm_cont-tech_type
        IMPORTING
          mimetype  = e_file_mimetype.


      e_file_base64 = ls_attachm_cont-content_x.

* get file Extension

      CALL METHOD cl_bcs_utilities=>split_name
        EXPORTING
          iv_name      = ls_attachm_cont-filename
          iv_delimiter = '.'
        IMPORTING
          ev_extension = e_file_extension.

    ENDIF.


  ENDMETHOD.


  METHOD get_business_area_list.

    DATA: lt_bus_areas TYPE TABLE OF tgsbt,
          ls_bus_areas TYPE tgsbt.

*>> get default language
    SELECT SINGLE spras
      FROM zabsf_languages
      INTO (@DATA(l_alt_spras))
     WHERE werks      EQ @i_inputobj-werks
       AND is_default EQ @abap_true.

    SELECT *
    INTO CORRESPONDING FIELDS OF TABLE et_business_areas
    FROM tgsbt
      WHERE spras EQ sy-langu.

    IF sy-subrc NE 0 AND l_alt_spras NE sy-langu.
      SELECT *
    FROM tgsbt
    INTO CORRESPONDING FIELDS OF TABLE  lt_bus_areas
        WHERE spras EQ l_alt_spras.
    ENDIF.

  ENDMETHOD.


  METHOD get_catalog_codes_list.

    DATA: lv_catalog_profile TYPE rbnr,
          ls_code            TYPE qpcd-code,
          lt_codes_t         TYPE TABLE OF qpk1cd,
          lt_group_code      TYPE TABLE OF qcodegrp,
          ls_group_code      TYPE qcodegrp,
          lt_code_tab        TYPE zabsf_pm_t_catalog_code_list,
          ls_code_tab        TYPE qpk1cd,
          l_alt_spras        TYPE spras.

    DATA: lv_where   TYPE char50.

    DATA ls_return LIKE LINE OF et_returntab.

    IF i_inputobj-language IS INITIAL.
*>> get default language
      SELECT SINGLE spras
        FROM zabsf_languages
        INTO @l_alt_spras
       WHERE werks      EQ @i_inputobj-werks
         AND is_default EQ @abap_true.
    ELSE.
*  Set local language for user
      l_alt_spras = i_inputobj-language.

      SET LOCALE LANGUAGE l_alt_spras.
    ENDIF.


*  CFB - change to get the catalog profile from the eqipment ( EQUZ-RBNR )
    IF NOT i_equnr IS INITIAL.

*    GET CATALOG PROFILE FROM EQUIPMENT MASTER
      SELECT SINGLE rbnr INTO lv_catalog_profile
        FROM equz
          WHERE equnr = i_equnr AND
                datbi GE  i_refdt.

      IF sy-subrc EQ 0.

*    GET CODEGROUPS FOR CATALOG PROFILE
        SELECT qcodegrp INTO TABLE lt_group_code
          FROM t352c
          WHERE rbnr EQ lv_catalog_profile
            AND qkatart EQ i_catalog_type.

      ENDIF.

    ENDIF.

    IF lt_group_code IS INITIAL.

*      GET CATALOG PROFILE FOR NOTIFICATION TYPE
      SELECT SINGLE rbnr INTO lv_catalog_profile
        FROM tq80
          WHERE qmart = i_notification_type.

*      GET CODEGROUPS FOR CATALOG PROFILE
      SELECT qcodegrp INTO TABLE lt_group_code
        FROM t352c
        WHERE rbnr EQ lv_catalog_profile
          AND qkatart EQ i_catalog_type.

    ENDIF.


    LOOP AT lt_group_code INTO ls_group_code.
      CALL FUNCTION 'BAPI_CODEGROUP_CODE_GETLIST' "Read Code List from Check Catalog QPCD
        EXPORTING
          cat_type   = i_catalog_type        " qpgr-katalogart  Catalog type
          code_group = ls_group_code         " qpgr-codegruppe  Code Group (Masking with *, +)
          code       = '*'                   " qpcd-code     Code (Masking with *, +)
          langu      = l_alt_spras                 " qpgt-sprache  Language for Texts
*         no_usageindication = 'X'                  " qm00-qkz      X = Do Not Set Usage Indicator
*         no_authority_check = SPACE                " qm00-qkz      X = Without Authorization Check
        IMPORTING
          return     = ls_return             " bapiret2      Return parameter
        TABLES
*         code_group_seltab = et_code_group_tab     " qpk1codegrp   CODE_GROUP as Table
          code_tab   = lt_codes_t            " qpk1cd        Results Table: Codes with Texts
        .  "  BAPI_CODEGROUP_CODE_GETLIST

*      APPEND ls_return TO et_returntab.


      APPEND LINES OF lt_codes_t TO lt_code_tab.
      DELETE lt_code_tab
        WHERE inaktiv = 'X'.

    ENDLOOP.


    IF i_code_group IS NOT INITIAL.
      lv_where = 'codegruppe CS i_code_group'.
    ENDIF.

    IF i_code IS NOT INITIAL.
      CONCATENATE lv_where ' AND code CS i_code' INTO lv_where.
    ENDIF.

    LOOP AT lt_code_tab INTO ls_code_tab
      WHERE (lv_where).

      APPEND ls_code_tab TO et_code_tab.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_checklist.

    CONSTANTS: gc_ok(5)        VALUE '[OK.]:',
               gc_nok(5)       VALUE '[NOK]:',
               gc_ne(5)        VALUE '[N/E]:',
               gc_istat_ok(5)  VALUE 'E0002',
               gc_istat_nok(5) VALUE 'E0003',
               gc_istat_ne(5)  VALUE 'E0004',
               gc_istat_del(5) VALUE 'I0013'.


    DATA: ls_checklist TYPE zabsf_pm_s_checklist,
          ls_v_equi    TYPE v_equi,
          ls_aufk      TYPE aufk,
          ls_afru      TYPE afru,
          ls_afvc      TYPE afvc.

    DATA: ls_main_step      TYPE afvc,
          lt_sub_operations TYPE TABLE OF afvc,
          lt_operations     TYPE TABLE OF afvc,
          ls_operations     TYPE afvc,
          ls_sub_operations LIKE LINE OF lt_sub_operations.

    DATA: lv_objid TYPE cr_objid,
          lv_aufpl TYPE co_aufpl,
          lv_sumnr TYPE sumkntnr VALUE IS INITIAL,
          lv_objnr TYPE j_objnr.

    DATA: t_table  TYPE TABLE OF tline,
          l_tdname TYPE thead-tdname.

* get routing of PM order
    SELECT SINGLE aufpl FROM afko INTO lv_aufpl
      WHERE aufnr = pm_order.

* check order type
    SELECT SINGLE * FROM aufk INTO ls_aufk
      WHERE aufnr = pm_order.

    IF ls_aufk-auart NE 'ZMLD'.

* get all main routing operation
      SELECT * FROM afvc INTO TABLE lt_operations
        WHERE aufpl = lv_aufpl
        AND sumnr = lv_sumnr. "no sub-operations

* get confirmations
      IF lt_operations IS NOT INITIAL.

        SELECT *
          FROM afru
        INTO TABLE @DATA(lt_afru)
          FOR ALL ENTRIES IN @lt_operations
          WHERE aufnr    EQ @pm_order
            AND werks    EQ @i_inputobj-werks
            AND stokz    EQ @space
            AND stzhl    EQ @space
            AND vornr    EQ @lt_operations-vornr
            AND aueru    EQ @abap_true.

      ENDIF.

      LOOP AT lt_operations INTO ls_operations.

        CALL FUNCTION 'CHAR_NUMC_CONVERSION'
          EXPORTING
            input   = ls_operations-vornr
          IMPORTING
            numcstr = ls_checklist-index_id.
        ls_checklist-stepid = ls_operations-vornr.
        ls_checklist-substepid = ls_operations-vornr. "copy stepid to substepid
        ls_checklist-stepdesc = ls_operations-ltxa1.

*  GET tdname key for READ_TEXT of Operation (MANDT+AUFPL+APLZL)
        CALL FUNCTION 'CO_ZK_TEXTKEY_AFVG'
          EXPORTING
            aufpl = ls_operations-aufpl
            aplzl = ls_operations-aplzl
          IMPORTING
            ltsch = l_tdname.

*  GET long text
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = 'AVOT'
            language                = sy-langu
            name                    = l_tdname
            object                  = 'AUFK'
          TABLES
            lines                   = t_table
          EXCEPTIONS
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            OTHERS                  = 8.

*  if null, do the same with configuration language
        IF sy-subrc NE 0.
          SELECT SINGLE spras
            FROM zabsf_languages
            INTO @DATA(lv_alt_spras)
            WHERE werks    EQ @i_inputobj-werks
             AND is_default EQ @abap_true.

          CALL FUNCTION 'READ_TEXT'
            EXPORTING
              client                  = sy-mandt
              id                      = 'AVOT'
              language                = lv_alt_spras
              name                    = l_tdname
              object                  = 'AUFK'
            TABLES
              lines                   = t_table
            EXCEPTIONS
              id                      = 1
              language                = 2
              name                    = 3
              not_found               = 4
              object                  = 5
              reference_check         = 6
              wrong_access_to_archive = 7
              OTHERS                  = 8.

        ENDIF.

*   Copy results and clear
        MOVE t_table TO ls_checklist-ltext.
        CLEAR l_tdname.
        CLEAR t_table.


* check if confirmations exists.
        READ TABLE lt_afru INTO ls_afru WITH KEY aufnr = pm_order
                                                 vornr = ls_operations-vornr.
        IF sy-subrc EQ 0.
          ls_checklist-no_edit = abap_true.

          CASE ls_afru-ltxa1(5).
            WHEN  gc_ne.
              ls_checklist-ne = abap_true.

            WHEN gc_nok.
              ls_checklist-nok = abap_true.

            WHEN gc_ok.
              ls_checklist-ok = abap_true.

            WHEN OTHERS.
* get OK, NOK, NE from JEST Table
              SELECT SINGLE * FROM afvc INTO ls_afvc
                WHERE aufpl = lv_aufpl
                AND vornr = ls_sub_operations-vornr.

              IF sy-subrc EQ 0.

                CONCATENATE 'OV' ls_afvc-aufpl ls_afvc-aplzl INTO lv_objnr.

                SELECT * FROM jest INTO TABLE @DATA(lt_jest)
                  WHERE objnr = @lv_objnr
                  AND inact = @space.

                IF sy-subrc EQ 0.

                  READ TABLE lt_jest TRANSPORTING NO FIELDS WITH KEY stat = gc_istat_ok.
                  IF sy-subrc EQ 0.

                    ls_checklist-ok = abap_true.
                  ENDIF.

                  READ TABLE lt_jest TRANSPORTING NO FIELDS WITH KEY stat = gc_istat_nok.
                  IF sy-subrc EQ 0.

                    ls_checklist-nok = abap_true.
                  ENDIF.

                  READ TABLE lt_jest TRANSPORTING NO FIELDS WITH KEY stat = gc_istat_ne.
                  IF sy-subrc EQ 0.

                    ls_checklist-ne = abap_true.
                  ENDIF.

                ENDIF.
              ENDIF.

          ENDCASE.

          ls_checklist-observations = ls_afru-ltxa1.
        ENDIF.

        APPEND ls_checklist TO checklist.
        CLEAR: ls_operations, ls_checklist, ls_afru.
      ENDLOOP.

    ELSE.
* sort table by sub-operation number.

* get main routing operation
      SELECT SINGLE *  FROM afvc INTO ls_main_step
        WHERE aufpl = lv_aufpl
        AND vornr = checklist_step
        AND sumnr = lv_sumnr.

* get all suboperation
      SELECT * FROM afvc INTO TABLE lt_sub_operations
        WHERE  aufpl = lv_aufpl
        AND sumnr = ls_main_step-aplzl.

* get confirmations
      IF lt_sub_operations IS NOT INITIAL.

        SELECT *
          FROM afru
        INTO TABLE @lt_afru
          FOR ALL ENTRIES IN @lt_sub_operations
          WHERE aufnr    EQ @pm_order
            AND werks    EQ @i_inputobj-werks
            AND stokz    EQ @space
            AND stzhl    EQ @space
            AND vornr    EQ @lt_sub_operations-vornr
            AND aueru    EQ @abap_true.

      ENDIF.

      LOOP AT lt_sub_operations INTO ls_sub_operations.
** INI AMP 2017.06.09
** 9000008672
** Do not condider deleted operations.
        "Read operation objnr
        SELECT SINGLE objnr INTO lv_objnr
          FROM afvc
         WHERE aufpl = lv_aufpl
           AND vornr = ls_sub_operations-vornr.
        IF sy-subrc EQ 0.
          SELECT COUNT( * )
            FROM jest
           WHERE objnr = @lv_objnr
             AND stat  = @gc_istat_del
             AND inact = @space.
          IF sy-dbcnt <> 0.
            CONTINUE.
          ENDIF.
        ENDIF.

** END AMP 2017.06.09
        CALL FUNCTION 'CHAR_NUMC_CONVERSION'
          EXPORTING
            input   = ls_sub_operations-vornr
          IMPORTING
            numcstr = ls_checklist-index_id.

        ls_checklist-stepid = ls_main_step-vornr.
        ls_checklist-substepid = ls_sub_operations-vornr.
        ls_checklist-stepdesc = ls_sub_operations-ltxa1.

* check if confirmations exists.
        READ TABLE lt_afru INTO ls_afru WITH KEY aufnr = pm_order
                                                 vornr = ls_sub_operations-vornr.
        IF sy-subrc EQ 0.
          ls_checklist-no_edit = abap_true.

          CASE ls_afru-ltxa1(5).
            WHEN  gc_ne.
              ls_checklist-ne = abap_true.

            WHEN gc_nok.
              ls_checklist-nok = abap_true.

            WHEN gc_ok.
              ls_checklist-ok = abap_true.

            WHEN OTHERS.
* get OK, NOK, NE from JEST Table
              SELECT SINGLE * FROM afvc INTO ls_afvc
                WHERE aufpl = lv_aufpl
                AND vornr = ls_sub_operations-vornr.

              IF sy-subrc EQ 0.

                CONCATENATE 'OV' ls_afvc-aufpl ls_afvc-aplzl INTO lv_objnr.

                SELECT * FROM jest INTO TABLE @lt_jest
                  WHERE objnr = @lv_objnr
                  AND inact = @space.

                IF sy-subrc EQ 0.

                  READ TABLE lt_jest TRANSPORTING NO FIELDS WITH KEY stat = gc_istat_ok.
                  IF sy-subrc EQ 0.

                    ls_checklist-ok = abap_true.
                  ENDIF.

                  READ TABLE lt_jest TRANSPORTING NO FIELDS WITH KEY stat = gc_istat_nok.
                  IF sy-subrc EQ 0.

                    ls_checklist-nok = abap_true.
                  ENDIF.

                  READ TABLE lt_jest TRANSPORTING NO FIELDS WITH KEY stat = gc_istat_ne.
                  IF sy-subrc EQ 0.

                    ls_checklist-ne = abap_true.
                  ENDIF.

                ENDIF.
              ENDIF.
          ENDCASE.

          ls_checklist-observations = ls_afru-ltxa1.
        ENDIF.

        APPEND ls_checklist TO checklist.
        CLEAR: ls_sub_operations, ls_checklist, ls_afru, ls_afvc,
               lv_objnr.
      ENDLOOP.
    ENDIF.

    SORT checklist BY index_id ASCENDING.

  ENDMETHOD.


  method get_consumptions.

    data: "lt_resb         TYPE ZABSF_PM_t_consumptions_list,
      "lt_mseg         TYPE ZABSF_PM_t_consumptions_list,
      ls_consumptions_final type zabsf_pm_s_consumptions,
      ls_makt               type makt,
      lv_rspos              type rspos.

    data: begin of ls_resb_aux.
    data: rspos type rspos,
          bwart type bwart.
            include type zabsf_pm_s_consumptions.
    data: end of ls_resb_aux.
    data: lt_resb         like table of ls_resb_aux,
          lt_mseg         like table of ls_resb_aux,
          lt_consumptions like table of ls_resb_aux.
    data: lt_dd07t type standard table of dd07t.

    data: ls_textheader type thead.

*    DATA: BEGIN OF textheader.
*    DATA: client  TYPE sy-mandt,
*          id TYPE THEAD-TDID,
*          language TYPE THEAD-TDSPRAS,
*          name TYPE THEAD-TDNAME,
*          object TYPE THEAD-TDOBJECT,
*          archive_handle TYPE SY-TABIX.
*    DATA: END OF textheader.

*    TYPES: BEGIN OF ty_table,
*             tdformat TYPE tdformat,
*             tdline   TYPE tdline,
*           END OF ty_table.
*
    data: lt_textlines type standard table of tline.

    clear ls_textheader.

    field-symbols: <fs_consumptions> like ls_resb_aux. "LINE OF et_consumptions.

**>> get default language
    select single spras
      from zabsf_pp061
      into @data(lv_alt_spras)
     where werks      eq @i_werks
       and is_default eq @abap_true.

    select *
      into table lt_dd07t
      from dd07t
      where domname    = 'BANST'
        and ddlanguage = lv_alt_spras
        and as4local   = 'A'
        and as4vers    = space.

*>> get order reservation information
*    select resb~rspos resb~matnr resb~meins bdmng enmng potx1 as maktx postp eban~statu eban~lifnr eban~preis eban~waers lfa1~name1 eban~banfn eban~bnfpo eban~loekz
**    SELECT matnr meins bdmng enmng
*      from resb
*      join rsdb
*        on resb~rsnum = rsdb~rsnum and resb~rspos = rsdb~rspos
*      join eban
*        on rsdb~banfn = eban~banfn and rsdb~bnfpo = eban~bnfpo
*      left join lfa1
*        on eban~lifnr = lfa1~lifnr
***      LEFT JOIN tj02t
***        ON eban~statu = tj02t~istat AND tj02t~spras = lv_alt_spras
*      into corresponding fields of table lt_resb
*     where resb~aufnr = i_aufnr.
**      AND xwaok = abap_true.

    select resb~rspos resb~matnr resb~meins resb~bdmng resb~enmng resb~postp
      from resb
      into corresponding fields of table lt_resb
      where resb~aufnr = i_aufnr.



    loop at lt_resb assigning field-symbol(<data>).
      " Set status description
      if <data>-statu is not initial.
        read table lt_dd07t assigning field-symbol(<dd07t>)
                            with key domvalue_l = <data>-statu.
        if sy-subrc = 0.
          <data>-statu_text = <dd07t>-ddtext.
        endif.
      endif.

      data: sname type thead-tdname.
      concatenate <data>-banfn <data>-bnfpo into sname.

      clear ls_textheader.
      clear lt_textlines.

*>>  Get Item Text
      call function 'READ_TEXT'
        exporting
          client                  = sy-mandt
          id                      = 'B01'
          language                = lv_alt_spras
          name                    = sname
          object                  = 'EBAN'
          archive_handle          = 0
        importing
          header                  = ls_textheader
        tables
          lines                   = lt_textlines
        exceptions
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          others                  = 8.

      clear <data>-obs.

      loop at lt_textlines assigning field-symbol(<data1>).
        if <data>-obs is initial.
          <data>-obs = <data1>-tdline.
        else.
          concatenate <data>-obs <data1>-tdline into <data>-obs separated by space.
        endif.
      endloop.

    endloop.

*    MOVE-CORRESPONDING lt_resb_aux TO lt_resb.

*>> get order consumption information not with reservation
    select matnr
*      menge AS bdmng
      menge as enmng
      meins
      bwart
      into corresponding fields of table lt_mseg
      from mseg
     where aufnr = i_aufnr
       and rsnum = space
       and matnr ne space
       and bwart in ('261', '262')
       and werks = i_werks
      %_hints mssqlnt 'INDEX("MSEG" "MSEG~z04")'.

    loop at lt_mseg assigning field-symbol(<mseg>).
      if <mseg> is assigned.
        <mseg>-postp = 'L'.
      endif.
    endloop.

    append lines of lt_resb to lt_mseg.

    sort lt_mseg by matnr.

    loop at lt_mseg into data(ls_consumptions) where matnr is not initial.

      if ls_consumptions-bwart eq '262'.
        multiply ls_consumptions-enmng by -1.
      endif.

      collect ls_consumptions into lt_consumptions. "et_consumptions.
      clear ls_consumptions.
    endloop.

    loop at lt_mseg into ls_consumptions where matnr is initial.
      append ls_consumptions to lt_consumptions.
    endloop.


    check lt_consumptions is not initial.

* get material descriptions.
    select * from makt into table @data(lt_makt)
      for all entries in @lt_consumptions
      where matnr eq @lt_consumptions-matnr
      and spras eq @sy-langu.

    if sy-subrc ne 0  and lv_alt_spras is not initial and lv_alt_spras <> sy-langu.
      select * from makt into table @lt_makt
        for all entries in @lt_consumptions
        where matnr eq @lt_consumptions-matnr
        and spras eq @lv_alt_spras.
    endif.


    sort lt_consumptions by rspos.

    loop at lt_consumptions into ls_consumptions. " ASSIGNING <fs_consumptions>.

      move-corresponding ls_consumptions to ls_consumptions_final.
      add 10 to lv_rspos.
      ls_consumptions_final-matnr = ls_consumptions-matnr. "lv_rspos.

      if ls_consumptions-matnr is not initial.
        read table lt_makt into ls_makt with key matnr = ls_consumptions-matnr.
        if sy-subrc eq 0.
          ls_consumptions_final-maktx = ls_makt-maktx.
        endif.
      endif.

      append ls_consumptions_final to et_consumptions.

    endloop.

  endmethod.


  METHOD get_contracts.

    DATA: lv_equnr TYPE equnr,
          lv_kunnr TYPE kunnr.

*>> get default language
    SELECT SINGLE spras
      FROM zabsf_languages
      INTO (@DATA(lv_alt_spras))
     WHERE werks      EQ @i_inputobj-werks
       AND is_default EQ @abap_true.

*   get customer from function partner SP associated with the equipment
    IF NOT i_equnr IS INITIAL.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = i_equnr
        IMPORTING
          output = lv_equnr.

      SELECT  k~kunnr, k~name1
          INTO CORRESPONDING FIELDS OF TABLE @et_customer_info
          FROM equi AS equi
          INNER JOIN ihpa AS ihpa ON ihpa~objnr = equi~objnr AND ihpa~parvw = 'AG'
          INNER JOIN kna1 AS k ON k~kunnr = ihpa~parnr
          WHERE equi~equnr = @lv_equnr.

    ELSEIF NOT i_tplnr IS INITIAL.

* with notification type we will determine the types of docs that we could get
      SELECT SINGLE tq80~sdauart, tq80~autom_cont
        FROM tq80 AS tq80
         INTO ( @DATA(lv_sdauart) , @DATA(lv_autom_cont) )
        WHERE tq80~qmart = @i_qmart.

* get partner number from IHPA
* Get IHPA-PARNR with IHPA-OBJNR = IFLOT-OBJNR and IHPA-PARVW = AG
* Get from VBAK with VBAK-KUNNR = IHPA-PARNR and VBAK-AUART = ZCV2 and VBAK-GUEEN equal or greater today's date.

      SELECT  k~kunnr, k~name1, vbap~vbeln AS kdauf, vbap~posnr AS kdpos
          INTO CORRESPONDING FIELDS OF TABLE @et_customer_info
          FROM vbap AS vbap

          INNER JOIN vbak AS vbak ON vbak~vbeln = vbap~vbeln
          INNER JOIN ihpa AS ihpa ON ihpa~parnr = vbak~kunnr AND ihpa~parvw = 'AG'
          INNER JOIN iflot AS iflot ON ihpa~objnr = iflot~objnr
          INNER JOIN kna1 AS k ON k~kunnr = vbak~kunnr

          WHERE vbak~auart = @lv_sdauart
          AND vbak~gueen GE @sy-datum
          AND iflot~tplnr EQ @i_tplnr.

    ENDIF.


  ENDMETHOD.


  METHOD get_equipments.

    DATA: ra_eqtyp         TYPE RANGE OF eqtyp,
          ra_eqart         TYPE RANGE OF eqart,
          lr_deleted_equnr TYPE rsis_t_range,
          ls_deleted_equnr TYPE rsis_s_range,
          lt_deleted_equnr TYPE zabsf_pm_t_equipments_list,
          ls_deleted       LIKE LINE OF lt_deleted_equnr.

    DATA:ra_equnr TYPE rsis_t_range,
         ls_equnr TYPE rsis_s_range,
         ra_eqktx TYPE rsis_t_range,
         ls_eqktx TYPE rsis_s_range,
         lr_spras TYPE rsis_t_range,
         ls_spras TYPE rsis_s_range.

    DATA: lt_eqkt TYPE TABLE OF eqkt,
          ls_eqkt TYPE eqkt.

    FIELD-SYMBOLS <fs_equipment> LIKE LINE OF et_equipment.

    SELECT SINGLE spras
      FROM zabsf_languages
      INTO @DATA(lv_alt_spras)
     WHERE werks      EQ @i_werks
       AND is_default EQ @abap_true.

* get marked for deleted equipments.
    SELECT equi~equnr ", eqkt~eqktx
      FROM equi "INNER JOIN eqkt ON  eqkt~equnr = equi~equnr
        INNER JOIN equz ON equz~equnr = equi~equnr
        INNER JOIN jest ON equi~objnr = jest~objnr
        INTO TABLE @lt_deleted_equnr
      WHERE eqtyp IN @ra_eqtyp
        AND equz~iwerk = @i_werks
        AND equz~datbi GE @sy-datlo
        AND jest~stat EQ 'I0076' AND jest~inact EQ @space.

* create range for excluded equipments.
    LOOP AT lt_deleted_equnr INTO ls_deleted.

      ls_deleted_equnr-sign = 'E'.
      ls_deleted_equnr-option = 'EQ'.
      ls_deleted_equnr-low = ls_deleted-equnr.

      APPEND ls_deleted_equnr TO lr_deleted_equnr.
      CLEAR: ls_deleted_equnr, ls_deleted.
    ENDLOOP.

    IF i_only_moulds = abap_true.
      CALL METHOD get_parameter
        EXPORTING
          i_werks     = i_werks
          i_parameter = 'EQTYP_MOULD'
        IMPORTING
          et_range    = ra_eqtyp.
    ENDIF.

    IF i_equnr IS NOT INITIAL.
      ls_equnr-sign = 'I'.
      ls_equnr-option = 'CP'.
      CONCATENATE '*' i_equnr '*' INTO ls_equnr-low.
      APPEND ls_equnr TO lr_deleted_equnr.
    ENDIF.

    IF i_eqktx IS NOT INITIAL.

      ls_eqktx-sign = 'I'.
      ls_eqktx-option = 'CP'.
      CONCATENATE '*' i_eqktx '*' INTO ls_eqktx-low.
      TRANSLATE ls_eqktx-low TO UPPER CASE.
      APPEND ls_eqktx TO ra_eqktx.

      ls_spras-sign = 'I'.
      ls_spras-option = 'EQ'.
      ls_spras-low = sy-langu.
      APPEND ls_spras TO lr_spras.

      ls_spras-low = lv_alt_spras.
      APPEND ls_spras TO lr_spras.
    ENDIF.

*>>> CBC - CR13.4 - 04.04.2017

    " MOVED inside IF below in order to consider exlusion for cases not in CR13.4
*      CALL METHOD get_parameter
*      EXPORTING
*        i_werks     = i_werks
*        i_parameter = 'MOULDE_EQART_EXCLUDE'
*      IMPORTING
*        et_range    = ra_eqart.

    IF i_arbpl IS INITIAL.

      CALL METHOD get_parameter
        EXPORTING
          i_werks     = i_werks
          i_parameter = 'MOULDE_EQART_EXCLUDE'
        IMPORTING
          et_range    = ra_eqart.

*<<< CBC - CR13.4 - 04.04.2017
      SELECT equi~equnr, equi~eqtyp
        FROM equi INNER JOIN eqkt ON  eqkt~equnr = equi~equnr
          INNER JOIN equz ON equz~equnr = equi~equnr
        INTO CORRESPONDING FIELDS OF TABLE @et_equipment
        WHERE eqtyp IN @ra_eqtyp
          AND equz~iwerk = @i_werks
          AND equz~datbi GT @sy-datlo
          AND equi~equnr IN @lr_deleted_equnr
          AND eqkt~spras IN @lr_spras
          AND eqkt~eqktu IN @ra_eqktx
          AND equi~eqart IN @ra_eqart.
*>>> CBC - CR13.4 - 04.04.2017
    ELSE.
      SELECT equi~equnr, equi~eqtyp
        FROM equi INNER JOIN eqkt ON  eqkt~equnr = equi~equnr
          INNER JOIN equz ON equz~equnr = equi~equnr
          INNER JOIN crhd  ON equz~gewrk = crhd~objid
        INTO CORRESPONDING FIELDS OF TABLE @et_equipment
        WHERE eqtyp IN @ra_eqtyp
          AND equz~iwerk = @i_werks
          AND equz~datbi GT @sy-datlo
          AND equi~equnr IN @lr_deleted_equnr
          AND eqkt~spras IN @lr_spras
          AND eqkt~eqktu IN @ra_eqktx
          AND equi~eqart IN @ra_eqart
          AND crhd~objty EQ 'A'
          AND crhd~verwe EQ '0005'
          AND crhd~arbpl = @i_arbpl. "Main Work Center
      .
    ENDIF.
*<<< CBC - CR13.4 - 04.04.2017


    SORT et_equipment BY equnr ASCENDING.
    DELETE ADJACENT DUPLICATES FROM et_equipment COMPARING equnr.

* equipment and category description.
    CHECK et_equipment IS NOT INITIAL.

    SELECT * FROM eqkt INTO TABLE lt_eqkt
      FOR ALL ENTRIES IN et_equipment
      WHERE equnr = et_equipment-equnr
      AND spras = sy-langu.

*>>> CBC - CR13.4 - 04.04.2017
    SELECT * FROM t370u INTO TABLE @DATA(lt_eqtyptx)
      FOR ALL ENTRIES IN @et_equipment
      WHERE eqtyp = @et_equipment-eqtyp
      AND spras = @sy-langu.
*<<< CBC - CR13.4 - 04.04.2017

    IF sy-subrc NE 0.
      SELECT * FROM eqkt INTO TABLE lt_eqkt
        FOR ALL ENTRIES IN et_equipment
        WHERE equnr = et_equipment-equnr
        AND spras = lv_alt_spras.

*>>> CBC - CR13.4 - 04.04.2017
      SELECT * FROM t370u INTO TABLE lt_eqtyptx
       FOR ALL ENTRIES IN et_equipment
       WHERE eqtyp = et_equipment-eqtyp
       AND spras = lv_alt_spras.
*<<< CBC - CR13.4 - 04.04.2017

    ENDIF.

    LOOP AT et_equipment ASSIGNING <fs_equipment>.
      READ TABLE lt_eqkt INTO ls_eqkt WITH KEY equnr = <fs_equipment>-equnr.
      IF sy-subrc EQ 0.
        <fs_equipment>-eqktx = ls_eqkt-eqktx.
      ENDIF.

*>>> CBC - CR13.4 - 04.04.2017
      READ TABLE lt_eqtyptx INTO DATA(ls_eqtyptx) WITH KEY eqtyp = <fs_equipment>-eqtyp.
      IF sy-subrc EQ 0.
        <fs_equipment>-eqtyptx = ls_eqtyptx-typtx.
      ENDIF.
*<<< CBC - CR13.4 - 04.04.2017

      CLEAR: ls_eqkt, ls_eqtyptx.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_equipment_list.

    TYPES: BEGIN OF ty_equipment.
        INCLUDE TYPE zabsf_pm_s_equipment.
    TYPES: objnr TYPE equi-objnr,
           END OF ty_equipment.


    DATA: lt_equipment TYPE TABLE OF ty_equipment,
          ls_equipment TYPE ty_equipment.

    DATA: lt_bgmkobj TYPE TABLE OF bgmkobj,
          lv_equnr   TYPE equnr.


    DATA: lt_descr   TYPE RANGE OF eqkt-eqktx,
          lr_descr   LIKE LINE OF lt_descr,
          lt_licence TYPE RANGE OF fleet-license_num,
          lr_licence LIKE LINE OF lt_licence.

    DATA: lt_equipment_list TYPE TABLE OF bapi_itob_eq_sel_result.


    SELECT SINGLE spras
     FROM zabsf_languages
     INTO @DATA(lv_alt_spras)
    WHERE werks      EQ @i_inputobj-werks
      AND is_default EQ @abap_true.


*   verifica se existe search string neste caso utilizamos o equnr
    CHECK i_equnr IS NOT INITIAL.


    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = i_equnr
      IMPORTING
        output = lv_equnr.

*   1º - vamos pesquisar primeiramente pela matricula, que estará em fleet~LICENSE_NUM
    lr_licence-sign = 'I'.
    CONCATENATE '*' i_equnr '*' INTO lr_licence-low.
    TRANSLATE lr_licence-low TO UPPER CASE.
    lr_licence-option = 'CP'.
    APPEND lr_licence TO lt_licence.

    SELECT iflot~tplnr,
        equi~equnr AS equnr,
        equi~eqtyp AS eqtyp,
        eqkt~eqktx AS eqktx,
        equi~objnr AS objnr,
        fleet~license_num AS license_num


        INTO CORRESPONDING FIELDS OF TABLE @lt_equipment
      FROM equi
        INNER JOIN equz AS equz ON equz~equnr = equi~equnr
        INNER JOIN jest ON equi~objnr = jest~objnr
        INNER JOIN iloa AS iloa ON iloa~iloan = equz~iloan
        INNER JOIN iflot AS iflot ON iflot~tplnr = iloa~tplnr
        LEFT JOIN eqkt AS eqkt ON eqkt~equnr = equi~equnr AND eqkt~spras = @lv_alt_spras
        LEFT JOIN fleet AS fleet ON fleet~objnr = equi~objnr
      WHERE equz~iwerk = @i_inputobj-werks AND
            equz~datbi GE @sy-datlo AND
            ( jest~stat <> 'I0076' AND jest~inact EQ @space ) AND
            ( fleet~license_num IN @lt_licence OR equi~equnr = @lv_equnr ).

    IF sy-subrc EQ 0.

      DELETE ADJACENT DUPLICATES FROM lt_equipment COMPARING equnr. "tplnr.

      CLEAR lt_bgmkobj.

      SELECT * FROM bgmkobj
        INTO TABLE lt_bgmkobj
        FOR ALL ENTRIES IN lt_equipment
      WHERE j_objnr = lt_equipment-objnr.

    ENDIF.


    IF lt_equipment IS INITIAL.

      lr_descr-sign = 'I'.
      CONCATENATE '*' i_equnr '*' INTO lr_descr-low.
      TRANSLATE lr_descr-low TO UPPER CASE.

      lr_descr-option = 'CP'.
      APPEND lr_descr TO lt_descr.

      SELECT iflot~tplnr,
        equi~equnr AS equnr,
        equi~eqtyp AS eqtyp,
        eqkt~eqktx AS eqktx,
        equi~objnr AS objnr,
        fleet~license_num AS license_num

        INTO CORRESPONDING FIELDS OF TABLE @lt_equipment
      FROM equi
        INNER JOIN equz AS equz ON equz~equnr = equi~equnr
        INNER JOIN jest ON equi~objnr = jest~objnr
        INNER JOIN iloa AS iloa ON iloa~iloan = equz~iloan
        INNER JOIN iflot AS iflot ON iflot~tplnr = iloa~tplnr
        LEFT JOIN eqkt AS eqkt ON eqkt~equnr = equi~equnr AND eqkt~spras = @lv_alt_spras
        LEFT JOIN fleet AS fleet ON fleet~objnr = equi~objnr

      WHERE equz~iwerk = @i_inputobj-werks AND
            equz~datbi GE @sy-datlo AND
            ( jest~stat <> 'I0076' AND jest~inact EQ @space ) AND
            eqkt~eqktu IN @lt_descr.

      IF sy-subrc EQ 0.

        DELETE ADJACENT DUPLICATES FROM lt_equipment COMPARING equnr. "tplnr.

        CLEAR lt_bgmkobj.

        SELECT * FROM bgmkobj
          INTO TABLE lt_bgmkobj
          FOR ALL ENTRIES IN lt_equipment
        WHERE j_objnr = lt_equipment-objnr.


      ENDIF.

    ENDIF.


* verificar se equipamento esta dentro do periodo de garantia e marcar in_guarantee da estrutura de saida
    LOOP AT lt_equipment ASSIGNING FIELD-SYMBOL(<fs_equipment>).

      IF <fs_equipment> IS ASSIGNED.

*       ler a tabela de garantias para cada um dos equipamentos encontrados
        LOOP AT lt_bgmkobj INTO DATA(ls_bgmkobj) WHERE j_objnr = <fs_equipment>-objnr.

          IF sy-subrc EQ 0.

            CASE ls_bgmkobj-gaart. "case ao tipo de garantia

              WHEN '2'. "garantia do tipo 2 Fornecedor

                <fs_equipment>-vendor_gwldt = ls_bgmkobj-gwldt.
                <fs_equipment>-vendor_gwlen = ls_bgmkobj-gwlen.

                IF sy-datum BETWEEN ls_bgmkobj-gwldt AND ls_bgmkobj-gwlen.
                  <fs_equipment>-in_guarantee_vendor = 'X'.

                ENDIF.


              WHEN '3'. "garantia do tipo 3 Fabricante

                <fs_equipment>-manuf_gwldt = ls_bgmkobj-gwldt.
                <fs_equipment>-manuf_gwlen = ls_bgmkobj-gwlen.

                IF sy-datum BETWEEN ls_bgmkobj-gwldt AND ls_bgmkobj-gwlen.
                  <fs_equipment>-in_guarantee_manuf = 'X'.

                ENDIF.

              WHEN OTHERS. " só vamos tratar as do tipo 2 e 3

            ENDCASE.

          ENDIF.
        ENDLOOP.

      ENDIF.
    ENDLOOP.


    MOVE-CORRESPONDING lt_equipment TO et_equipments_list.

  ENDMETHOD.


  method get_equipment_tree.

*>>CFB
    "DATA : et_hier TYPE  ihie_t_hier.

    data : et_iflo_tab type table of rihiflo,
           is_iflo_tab like line of et_iflo_tab.

*    DATA : et_equi_tab TYPE TABLE OF rihequi,
*           is_equi_tab LIKE LINE OF et_equi_tab.

    data : lv_i_tplnr type tplnr,
           lv_i_equnr type equnr.


    data : wa_equipments_tree like line of et_equipments_tree,
           is_equipments_tree like line of et_equipments_tree.

    data: it_equipment type table of zabsf_pm_s_equipment,
          is_equipment type zabsf_pm_s_equipment.

    field-symbols : <fs_equipments_tree> like line of et_equipments_tree,
                    <fs_it_equipment>    like line of it_equipment.

    data : lv_levdo type numc2, lv_tplma type tplma.


    select single spras
     from zabsf_languages
     into @data(lv_alt_spras)
    where werks      eq @i_inputobj-werks
      and is_default eq @abap_true.

    lv_i_tplnr = i_tplnr.
    lv_i_equnr = i_equnr.
    data(lv_werks) = i_inputobj-werks.


*    IF i_equnr IS NOT INITIAL.

      call function 'CONVERSION_EXIT_ALPHA_INPUT'
        exporting
          input  = lv_i_equnr
        importing
          output = lv_i_equnr.

      select single iflot~tplnr into lv_i_tplnr
        from equi
          inner join equz as equz on equz~equnr = equi~equnr
          inner join iloa as iloa on iloa~iloan = equz~iloan
          inner join iflot as iflot on iflot~tplnr = iloa~tplnr
*         WHERE equz~equnr EQ lv_i_equnr AND equz~datbi GT i_refdt.
          where equz~datbi gt i_refdt and equz~iwerk = lv_werks.

*    endif.

    check lv_i_tplnr is not initial.

*       >>CFB Verify if functional locations is root
*       if so set levdo = 1
*       if not set levdo = 99

    select single tplma from iflot
      into lv_tplma
      where tplnr = lv_i_tplnr.

    if lv_tplma eq space.
      lv_levdo = 1.
    else.
      lv_levdo = 99.
    endif.

    call function 'PM_HIERARCHY_CALL'
      exporting
        werks          = i_inputobj-werks
        tplnr          = lv_i_tplnr
        selmod         = 'D'
        levdo          = lv_levdo
        datum          = i_refdt
        with_iflo_hier = 'X'
        with_equi_hier = 'X'
        with_equi      = 'X'
        with_btyp      = 'X'
        " IMPORTING
      " et_hier        = et_hier
      tables
        iflo_tab       = et_iflo_tab.



    loop at et_iflo_tab into  is_iflo_tab.

      move-corresponding is_iflo_tab to is_equipments_tree.
      append is_equipments_tree to et_equipments_tree.
    endloop.


* >>> ABACO-CBC - 12.10.2017 - Return Func. Loc. even when no equipament under
*    CHECK et_equipments_tree IS NOT INITIAL.
    if et_equipments_tree is not initial.
* <<< ABACO-CBC - 12.10.2017

      select iflot~tplnr,
        equi~equnr as equnr,
        equi~eqtyp as eqtyp,
        eqkt~eqktx as eqktx,
        equi~gwlen as gwlen,
        equi~gwldt as gwldt

        into corresponding fields of table @it_equipment
      from equi
        inner join equz as equz on equz~equnr = equi~equnr
        inner join iloa as iloa on iloa~iloan = equz~iloan
        inner join iflot as iflot on iflot~tplnr = iloa~tplnr
        left join eqkt as eqkt on eqkt~equnr = equi~equnr and eqkt~spras = @lv_alt_spras
      for all entries in @et_equipments_tree
        where iflot~tplnr eq @et_equipments_tree-tplnr.


      delete adjacent duplicates from it_equipment comparing equnr.

      if lv_i_equnr is not initial.
        delete it_equipment where equnr ne lv_i_equnr.
      endif.

      data: it_equipments_aux type table of zabsf_pm_s_equipment,
            ls_equipment      like line of it_equipments_aux.


      loop at et_equipments_tree assigning <fs_equipments_tree>.

        wa_equipments_tree = <fs_equipments_tree>.

        loop at it_equipment into ls_equipment
          where tplnr = <fs_equipments_tree>-tplnr.

          call function 'CONVERSION_EXIT_ALPHA_OUTPUT'
            exporting
              input  = ls_equipment-equnr
            importing
              output = ls_equipment-equnr.

          append ls_equipment to it_equipments_aux.
        endloop.

        append lines of it_equipments_aux to <fs_equipments_tree>-et_equipment.
        refresh it_equipments_aux.

        clear :  wa_equipments_tree.


      endloop.

* >>> ABACO-CBC - 12.10.2017 - Return Func. Loc. even when no equipament under
    else.

      clear wa_equipments_tree.

      select single pltxt into wa_equipments_tree-pltxt
        from iflotx
        where tplnr = lv_i_tplnr.

      wa_equipments_tree-tplma = lv_tplma.
      wa_equipments_tree-tplnr = lv_i_tplnr.
      append wa_equipments_tree to et_equipments_tree.

    endif.
* <<< ABACO-CBC - 12.10.2017

  endmethod.


  METHOD get_func_locations.

    DATA: lv_where TYPE char40.

    SELECT SINGLE spras
      FROM zabsf_languages
      INTO @DATA(lv_alt_spras)
     WHERE werks      EQ @i_werks
       AND is_default EQ @abap_true.


    IF i_werks IS NOT INITIAL.
      lv_where = 'iflot~iwerk EQ @i_werks'.
    ENDIF.

    " GET FUNCTIONAL LOCATION
    SELECT iflot~tplnr AS func_loc, ix~pltxt AS func_loc_tx
      INTO TABLE @et_func_location
      FROM iflot
        INNER JOIN iflotx AS ix ON ix~tplnr = iflot~tplnr
      WHERE (lv_where)
        AND ix~spras = @sy-langu.

    IF sy-subrc NE 0.
      SELECT iflot~tplnr AS func_loc, ix~pltxt AS func_loc_tx
        INTO TABLE @et_func_location
        FROM iflot
          INNER JOIN iflotx AS ix ON ix~tplnr = iflot~tplnr
        WHERE (lv_where)
          AND ix~spras = @lv_alt_spras.
    ENDIF.

    SORT et_func_location BY func_loc ASCENDING.
    DELETE ADJACENT DUPLICATES FROM et_func_location COMPARING func_loc.

  ENDMETHOD.


  METHOD get_func_locations_tree.

    DATA: lv_where      TYPE char40, lv_where_text TYPE char80.

    DATA : stext_wild_card TYPE char40.
    DATA : ra_tplnr TYPE rsis_t_range,
           ls_tplnr TYPE rsis_s_range.


    DATA wa_func_loc_tree LIKE LINE OF et_func_loc_tree.
    DATA: it_equipment TYPE TABLE OF zabsf_pm_s_equipment,
          is_equipment TYPE zabsf_pm_s_equipment.

    FIELD-SYMBOLS <fs_et_func_loc_tree> LIKE LINE OF et_func_loc_tree.

    FIELD-SYMBOLS <fs_it_equipment> LIKE LINE OF it_equipment.


    SELECT SINGLE spras
      FROM zabsf_languages
      INTO @DATA(lv_alt_spras)
     WHERE werks      EQ @i_inputobj-werks
       AND is_default EQ @abap_true.

    IF i_inputobj-werks IS NOT INITIAL.
      lv_where = 'iflot~iwerk EQ @i_inputobj-werks'.
    ENDIF.

*>>> Defining range
    IF i_stext IS NOT INITIAL.
      ls_tplnr-sign = 'I'.
      ls_tplnr-option = 'CP'.
      CONCATENATE '*' i_stext '*' INTO ls_tplnr-low.
      TRANSLATE ls_tplnr-low TO UPPER CASE.
      APPEND ls_tplnr TO ra_tplnr.
    ENDIF.

*    IF i_stext IS NOT INITIAL.
*      CONCATENATE i_stext '%' INTO stext_wild_card.
*      lv_where_text = 'iflot~tplnr like @stext_wild_card'.
*
*    ENDIF.

    SELECT iflot~tplma AS tplma, iflot~tplnr AS tplnr, ix~pltxt AS pltxt
      "iflot~tplnr AS func_loc, ix~pltxt AS func_loc_tx
       INTO CORRESPONDING FIELDS OF TABLE @et_func_loc_tree
       FROM iflot
         INNER JOIN iflotx AS ix ON ix~tplnr = iflot~tplnr
       WHERE  (lv_where)
       AND  iflot~tplnr IN @ra_tplnr
      " AND (lv_where_text)
       AND ix~spras = @sy-langu.


    " GET FUNCTIONAL LOCATION
    IF sy-subrc NE 0.
      SELECT iflot~tplma AS tplma, iflot~tplnr AS tplnr, ix~pltxt AS pltxt

        INTO CORRESPONDING FIELDS OF TABLE @et_func_loc_tree

        FROM iflot
          INNER JOIN iflotx AS ix ON ix~tplnr = iflot~tplnr
        WHERE (lv_where)
           "AND (lv_where_text)
           AND  iflot~tplnr IN @ra_tplnr
          AND ix~spras = @lv_alt_spras.
    ENDIF.

    SORT et_func_loc_tree BY tplnr ASCENDING.
    DELETE ADJACENT DUPLICATES FROM et_func_loc_tree COMPARING tplnr.


  ENDMETHOD.


  METHOD get_hr_userlist.

    DATA lv_pernr TYPE persno.

    DATA : ra_pernr TYPE rsis_t_range,
           ls_pernr TYPE rsis_s_range.

    DATA : ra_endda TYPE rsis_t_range,
           ls_endda TYPE rsis_s_range.

    DATA: lt_out_persons     TYPE TABLE OF object_person_assignment.


*>>> Defining range for enddate, if enddate greater than reference
*     date means user is active.
    IF i_refdt IS NOT INITIAL.

      ls_endda-sign = 'I'.
      ls_endda-option = 'GT'.
      MOVE i_refdt TO ls_endda-low.
      APPEND ls_endda TO ra_endda.

    ENDIF.


    IF NOT i_arbpl IS INITIAL.


*      DATA ARBPL       TYPE CRHD-ARBPL.
*      DATA WERKS       TYPE CRHD-WERKS.
*      DATA DATE        TYPE TIMELIST-DATE.
*      DATA OUT_PERSONS TYPE STANDARD TABLE OF OBJECT_PERSON_ASSIGNMENT.

      CALL FUNCTION 'CR_PERSONS_OF_WORKCENTER'
        EXPORTING
          arbpl                       = i_arbpl
          werks                       = i_inputobj-werks
          date                        = i_refdt
        TABLES
          out_persons                 = lt_out_persons
        EXCEPTIONS
          invalid_object              = 1
          invalid_hr_planning_variant = 2
          other_error                 = 3
          OTHERS                      = 4.
      IF sy-subrc <> 0.
*       Implement suitable error handling here
      ENDIF.


      IF NOT lt_out_persons IS INITIAL.

        MOVE-CORRESPONDING lt_out_persons TO et_userslist.

        SELECT p~pernr, p~vorna, p~nachn
         INTO CORRESPONDING FIELDS OF TABLE @et_userslist

         FROM pa0002 AS p
          FOR ALL ENTRIES IN @lt_out_persons
          WHERE p~pernr = @lt_out_persons-pernr AND
                p~endda IN @ra_endda.

      ENDIF.

    ELSE.

*>>> Defining range for personnel number
      IF i_pernr IS NOT INITIAL.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            input  = i_pernr
          IMPORTING
            output = lv_pernr.

        ls_pernr-sign = 'I'.
        ls_pernr-option = 'CP'.
        CONCATENATE '*' lv_pernr '*' INTO ls_pernr-low.
        APPEND ls_pernr TO ra_pernr.

      ENDIF.

      SELECT p~pernr, p~vorna, p~nachn
         INTO CORRESPONDING FIELDS OF TABLE @et_userslist
         FROM pa0002 AS p

         WHERE  p~pernr IN @ra_pernr
         AND ( p~endda IN @ra_endda ).


    ENDIF.

  ENDMETHOD.


  METHOD get_locations.

    SELECT * FROM t499s INTO CORRESPONDING FIELDS OF TABLE et_locations
      WHERE werks = i_inputobj-werks.


  ENDMETHOD.


  METHOD get_machine_subequip.

    DATA: lr_deleted_equnr TYPE rsis_t_range,
          ls_deleted_equnr TYPE rsis_s_range,
          lt_deleted_equnr TYPE zabsf_pm_t_equipments_list,
          ls_deleted       LIKE LINE OF lt_deleted_equnr,
          lt_eqkt          TYPE TABLE OF eqkt,
          ls_eqkt          TYPE eqkt.

    FIELD-SYMBOLS: <fs_subequipment> LIKE LINE OF et_subequip.

* get alternative language
    SELECT SINGLE spras
      FROM zabsf_languages
      INTO @DATA(lv_alt_spras)
     WHERE werks      EQ @i_werks
       AND is_default EQ @abap_true.

* get marked for deleted equipments.
    SELECT equi~equnr, eqkt~eqktx
          FROM equi INNER JOIN eqkt ON  eqkt~equnr = equi~equnr
                                    "AND eqkt~spras = @sy-langu
          INNER JOIN equz ON equz~equnr = equi~equnr
          INNER JOIN jest ON equi~objnr = jest~objnr
          INTO TABLE @lt_deleted_equnr
          WHERE equz~iwerk = @i_werks
          AND equz~datbi GE @sy-datlo
          AND jest~stat EQ 'I0076' AND jest~inact EQ @space.

* create range for excluded equipments.
    LOOP AT lt_deleted_equnr INTO ls_deleted.

      ls_deleted_equnr-sign = 'E'.
      ls_deleted_equnr-option = 'EQ'.
      ls_deleted_equnr-low = ls_deleted-equnr.

      APPEND ls_deleted_equnr TO lr_deleted_equnr.
      CLEAR: ls_deleted_equnr, ls_deleted.
    ENDLOOP.

    SELECT equz~equnr, equi~eqtyp, t370u~typtx
      INTO TABLE @et_subequip
      FROM equz "INNER JOIN eqkt ON  eqkt~equnr = equz~equnr
                           "     AND eqkt~spras = @sy-langu
                INNER JOIN equi ON  equi~equnr = equz~equnr
                INNER JOIN t370u ON t370u~eqtyp = equi~eqtyp
                                AND t370u~spras = @sy-langu
     WHERE hequi = @i_equnr
      AND equz~datbi GT @sy-datlo
      AND equz~iwerk = @i_werks
      AND equi~equnr IN @lr_deleted_equnr.

*    IF et_subequip[] IS INITIAL.
*      SELECT SINGLE spras
*        FROM zabsf_languages
*        INTO @DATA(lv_alt_spras)
*       WHERE werks      EQ @i_werks
*         AND is_default EQ @abap_true.
*
*      IF sy-subrc = 0 AND lv_alt_spras <> sy-langu.
*        SELECT equz~equnr, eqkt~eqktx, equi~eqtyp, t370u~typtx
*          INTO TABLE @et_subequip
*          FROM equz INNER JOIN eqkt ON  eqkt~equnr = equz~equnr
*                                    AND eqkt~spras = @lv_alt_spras
*                    INNER JOIN equi ON  equi~equnr = equz~equnr
*                    INNER JOIN t370u ON t370u~eqtyp = equi~eqtyp
*                                    AND t370u~spras = @lv_alt_spras
*         WHERE hequi = @i_equnr
*         AND equz~datbi GT @sy-datlo
*         AND equz~iwerk = @i_werks
*         AND equi~equnr IN @lr_deleted_equnr.
*      ENDIF.
*    ENDIF.

    CHECK et_subequip IS NOT INITIAL.

    SELECT * FROM eqkt INTO TABLE lt_eqkt
      FOR ALL ENTRIES IN et_subequip
      WHERE equnr = et_subequip-equnr
      AND spras = sy-langu.

    IF lt_eqkt IS INITIAL.

      SELECT * FROM eqkt INTO TABLE lt_eqkt
        FOR ALL ENTRIES IN et_subequip
        WHERE equnr = et_subequip-equnr
        AND spras = lv_alt_spras.
    ENDIF.

    SORT et_subequip BY equnr.
    DELETE ADJACENT DUPLICATES FROM et_subequip COMPARING equnr.

* set equipment description
    LOOP AT et_subequip ASSIGNING <fs_subequipment>.

      READ TABLE lt_eqkt INTO ls_eqkt WITH KEY equnr = <fs_subequipment>-equnr.
      IF sy-subrc EQ 0.

        <fs_subequipment>-eqktx = ls_eqkt-eqktx.
      ENDIF.

      CLEAR ls_eqkt.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_maintenance_history.

    DATA: lv_where       TYPE char80.

*>> get default language
    SELECT SINGLE spras
      FROM zabsf_languages
      INTO (@DATA(lv_alt_spras))
     WHERE werks      EQ @i_inputobj-werks
       AND is_default EQ @abap_true.


    IF i_equnr IS NOT INITIAL AND i_tplnr IS NOT INITIAL.
      lv_where = 'b~equnr EQ @i_equnr and ix~tplnr EQ @i_tplnr'.
    ELSEIF i_equnr IS NOT INITIAL AND i_tplnr IS INITIAL.
      lv_where = ' b~equnr EQ @i_equnr and ix~tplnr EQ @space'.
    ELSEIF i_equnr IS INITIAL AND i_tplnr IS NOT INITIAL.
      lv_where = ' ix~tplnr EQ @i_tplnr and b~equnr EQ @space'.
    ENDIF.

    SELECT a~aufnr   AS aufnr,
       b~addat      AS addat,
       a~ktext       AS ktext

     INTO CORRESPONDING FIELDS OF TABLE @et_maint_history
     UP TO 11 ROWS
     FROM aufk AS a
      INNER JOIN afih                 AS b ON a~aufnr = b~aufnr
      LEFT JOIN iloa            AS i ON i~iloan = b~iloan
      LEFT JOIN iflotx          AS ix ON ix~tplnr = i~tplnr
      LEFT JOIN afko AS o ON a~aufnr = o~aufnr
     WHERE a~werks = @i_inputobj-werks
        AND ix~spras = @lv_alt_spras
        AND (lv_where)
        AND o~gstrp LE @sy-datum

     ORDER BY a~aufnr DESCENDING.

    SORT et_maint_history BY addat DESCENDING.



  ENDMETHOD.


  METHOD get_materials.

    DATA: ra_mtart TYPE RANGE OF mtart,
          ra_lgort TYPE RANGE OF lgort_d,
          ra_matnr TYPE rsis_t_range,
          ls_matnr TYPE rsis_s_range,
          ra_maktx TYPE rsis_t_range,
          ls_maktx TYPE rsis_s_range,
          ra_spras TYPE rsis_t_range,
          ls_spras TYPE rsis_s_range.

    DATA: lt_makt TYPE TABLE OF makt,
          ls_makt TYPE makt.


    DATA: lt_supplier TYPE TABLE OF ZABSF_PM_S_SUPPLIERS.
*          lt_supplier TYPE ZABSF_PM_S_SUPPLIERS.

    FIELD-SYMBOLS <fs_materials> TYPE zabsf_pm_s_materials.

    SELECT SINGLE spras
      FROM zabsf_languages
      INTO @DATA(lv_alt_spras)
     WHERE werks      EQ @i_werks
       AND is_default EQ @abap_true.


    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_werks
        i_parameter = 'MTART_CONSUM'
      IMPORTING
        et_range    = ra_mtart.

    IF i_matnr IS NOT INITIAL.
      ls_matnr-sign = 'I'.
      ls_matnr-option = 'CP'.
      CONCATENATE '*' i_matnr '*' INTO ls_matnr-low.
      APPEND ls_matnr TO ra_matnr.
    ENDIF.

    IF i_maktx IS NOT INITIAL.

      ls_maktx-sign = 'I'.
      ls_maktx-option = 'CP'.
      CONCATENATE '*' i_maktx '*' INTO ls_maktx-low.
      TRANSLATE ls_maktx-low TO UPPER CASE.
      APPEND ls_maktx TO ra_maktx.

      ls_spras-sign = 'I'.
      ls_spras-option = 'EQ'.
      ls_spras-low = sy-langu.
      APPEND ls_spras TO ra_spras.

      ls_spras-low = lv_alt_spras.
      APPEND ls_spras TO ra_spras.
    ENDIF.

    SELECT mara~matnr AS matne, mara~meins
      FROM mara INNER JOIN makt ON  makt~matnr = mara~matnr
      INTO CORRESPONDING FIELDS OF TABLE @et_materials   UP TO 500 ROWS
     WHERE mtart IN @ra_mtart
       AND lvorm = @space
       AND mstae = @space
       AND mara~matnr IN @ra_matnr
       AND makt~maktg IN @ra_maktx
       AND makt~spras IN @ra_spras
       AND EXISTS ( SELECT matnr
                      FROM marc
                     WHERE matnr = mara~matnr
                       AND werks = @i_werks
                       AND lvorm = @space
                       AND mmsta = @space )
       AND EXISTS ( SELECT matnr
                      FROM mard
                     WHERE matnr = mara~matnr
                       AND werks = @i_werks
                       AND lgort IN @ra_lgort
                       AND lvorm = @space ).


*    IF et_materials[] IS INITIAL.

*
*      IF sy-subrc = 0 AND lv_alt_spras <> sy-langu.
*        SELECT mara~matnr, makt~maktx, mara~meins
*          FROM mara INNER JOIN makt ON  makt~matnr = mara~matnr
*                                    AND makt~spras = @lv_alt_spras
*          INTO TABLE @et_materials  UP TO 500 ROWS
*         WHERE mtart IN @ra_mtart
*           AND lvorm = @space
*           AND mstae = @space
*           AND mara~matnr IN @ra_matnr
*           AND makt~maktg IN @ra_maktx
*           AND EXISTS ( SELECT matnr
*                          FROM marc
*                         WHERE matnr = mara~matnr
*                           AND werks = @i_werks
*                           AND lvorm = @space
*                           AND mmsta = @space )
*           AND EXISTS ( SELECT matnr
*                          FROM mard
*                         WHERE matnr = mara~matnr
*                           AND werks = @i_werks
*                           AND lgort IN @ra_lgort
*                           AND lvorm = @space ).
*
*      ENDIF.
*    ENDIF.

    CHECK et_materials IS NOT INITIAL.

    SORT et_materials BY matne ASCENDING.
    DELETE ADJACENT DUPLICATES FROM et_materials COMPARING matne.

* Material description
    SELECT * FROM makt INTO TABLE lt_makt
      FOR ALL ENTRIES IN et_materials
      WHERE matnr = et_materials-matne
      AND spras = sy-langu.

    IF sy-subrc NE 0.

      SELECT * FROM makt INTO TABLE lt_makt
       FOR ALL ENTRIES IN et_materials
       WHERE matnr = et_materials-matne
       AND spras = lv_alt_spras.
    ENDIF.

    LOOP AT et_materials ASSIGNING <fs_materials>.

      CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
        EXPORTING
          input          = <fs_materials>-meins
          language       = sy-langu
        IMPORTING
          output         = <fs_materials>-meins
        EXCEPTIONS
          unit_not_found = 1
          OTHERS         = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

      READ TABLE lt_makt INTO ls_makt WITH KEY matnr = <fs_materials>-matne.
      IF sy-subrc EQ 0.
        <fs_materials>-maktx = ls_makt-maktx.
      ENDIF.

*     Get Supliers
      SELECT eina~lifnr lfa1~name1
      FROM eina
        LEFT JOIN lfa1
          ON eina~lifnr = lfa1~lifnr
        INTO CORRESPONDING FIELDS OF TABLE lt_supplier
     WHERE eina~matnr = <fs_materials>-matne.

      <fs_materials>-suppliers = lt_supplier.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_materials_stock.

    DATA: ra_mtart TYPE RANGE OF mtart,
          ra_lgort TYPE RANGE OF lgort_d,
          ra_bestq TYPE RANGE OF bestq,
          ls_bestq TYPE rsis_s_range,
          ra_matnr TYPE rsis_t_range,
          ls_matnr TYPE rsis_s_range,
          ra_maktx TYPE rsis_t_range,
          ls_maktx TYPE rsis_s_range,
          ra_spras TYPE rsis_t_range,
          ls_spras TYPE rsis_s_range.

    DATA: lt_makt TYPE TABLE OF makt,
          ls_makt TYPE makt.

    DATA: wa_stock TYPE char01.

    SELECT SINGLE spras
      FROM zabsf_languages
      INTO @DATA(lv_alt_spras)
     WHERE werks      EQ @i_werks
       AND is_default EQ @abap_true.


    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_werks
        i_parameter = 'MTART_STOCK'
      IMPORTING
        et_range    = ra_mtart.

    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_werks
        i_parameter = 'LGORT_STOCK'
      IMPORTING
        et_range    = ra_lgort.


    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_werks
        i_parameter = 'BESTQ_STOCK'
      IMPORTING
        et_range    = ra_bestq.


    IF i_matnr IS NOT INITIAL.
      ls_matnr-sign = 'I'.
      ls_matnr-option = 'CP'.
      CONCATENATE '*' i_matnr '*' INTO ls_matnr-low.
      APPEND ls_matnr TO ra_matnr.
    ENDIF.

    IF i_maktx IS NOT INITIAL.

      ls_maktx-sign = 'I'.
      ls_maktx-option = 'CP'.
      CONCATENATE '*' i_maktx '*' INTO ls_maktx-low.
      TRANSLATE ls_maktx-low TO UPPER CASE.
      APPEND ls_maktx TO ra_maktx.

      ls_spras-sign = 'I'.
      ls_spras-option = 'EQ'.
      ls_spras-low = sy-langu.
      APPEND ls_spras TO ra_spras.

      ls_spras-low = lv_alt_spras.
      APPEND ls_spras TO ra_spras.
    ENDIF.

    LOOP AT ra_bestq INTO ls_bestq.
*Estoque em depósito libre
*Q  Estoque em depósito no controle de qualidade
*R  Estoque de devoluções
*S  Estoque bloqueado
      MOVE ls_bestq-low TO wa_stock.
    ENDLOOP.

*    By Default get Estoque em utilização depósito livre
    CASE wa_stock.
      WHEN ''.

        SELECT mard~matnr, mara~meins, makt~maktx,
*>>>>> CBC 07.06.2017 - Correct Stock Duplicates
          makt~spras,
*<<<<< CBC 07.06.2017
               SUM( mard~labst ) AS labst
          FROM mard
            INNER JOIN marc ON mard~matnr = marc~matnr AND mard~werks = marc~werks
            INNER JOIN mara ON mard~matnr = mara~matnr
            INNER JOIN t001w ON mard~werks = t001w~werks
            INNER JOIN makt ON  makt~matnr = mara~matnr
          INTO CORRESPONDING FIELDS OF TABLE @et_material_stock
          WHERE mard~matnr IN @ra_matnr
            AND mard~werks EQ @i_werks
            AND mard~lvorm EQ @space
            AND lgort IN @ra_lgort
*            AND xchar EQ @space
            AND mara~mtart IN @ra_mtart
            AND makt~maktg IN @ra_maktx
            AND makt~spras IN @ra_spras
            GROUP BY mard~mandt, mard~matnr, mara~meins, makt~maktx,
*>>>>> CBC 07.06.2017 - Correct Stock Duplicates
          makt~spras.
*>>>>> CBC 07.06.2017 - Correct Stock Duplicates

      WHEN 'Q'.

        SELECT mard~matnr, mara~meins, makt~maktx,
*>>>>> CBC 07.06.2017 - Correct Stock Duplicates
          makt~spras,
*<<<<< CBC 07.06.2017
             SUM( mard~insme ) AS labst
        FROM mard
          INNER JOIN marc ON mard~matnr = marc~matnr AND mard~werks = marc~werks
          INNER JOIN mara ON mard~matnr = mara~matnr
          INNER JOIN t001w ON mard~werks = t001w~werks
          INNER JOIN makt ON  makt~matnr = mara~matnr
        INTO CORRESPONDING FIELDS OF TABLE @et_material_stock
        WHERE mard~matnr IN @ra_matnr
          AND mard~werks EQ @i_werks
          AND mard~lvorm EQ @space
          AND lgort IN @ra_lgort
*          AND xchar EQ @space
          AND mara~mtart IN @ra_mtart
          AND makt~maktg IN @ra_maktx
          AND makt~spras IN @ra_spras
          GROUP BY mard~mandt, mard~matnr, mara~meins, makt~maktx,
*>>>>> CBC 07.06.2017 - Correct Stock Duplicates
          makt~spras.
*>>>>> CBC 07.06.2017 - Correct Stock Duplicates

      WHEN 'R'.

        SELECT mard~matnr, mara~meins, makt~maktx,
*>>>>> CBC 07.06.2017 - Correct Stock Duplicates
          makt~spras,
*<<<<< CBC 07.06.2017
               SUM( mard~retme ) AS labst
          FROM mard
            INNER JOIN marc ON mard~matnr = marc~matnr AND mard~werks = marc~werks
            INNER JOIN mara ON mard~matnr = mara~matnr
            INNER JOIN t001w ON mard~werks = t001w~werks
            INNER JOIN makt ON  makt~matnr = mara~matnr
          INTO CORRESPONDING FIELDS OF TABLE @et_material_stock
          WHERE mard~matnr IN @ra_matnr
            AND mard~werks EQ @i_werks
            AND mard~lvorm EQ @space
            AND lgort IN @ra_lgort
*            AND xchar EQ @space
            AND mara~mtart IN @ra_mtart
            AND makt~maktg IN @ra_maktx
            AND makt~spras IN @ra_spras
            GROUP BY mard~mandt, mard~matnr, mara~meins, makt~maktx,
*>>>>> CBC 07.06.2017 - Correct Stock Duplicates
          makt~spras.
*>>>>> CBC 07.06.2017 - Correct Stock Duplicates

      WHEN 'S'.

        SELECT mard~matnr, mara~meins, makt~maktx,
*>>>>> CBC 07.06.2017 - Correct Stock Duplicates
          makt~spras,
*<<<<< CBC 07.06.2017
         SUM( mard~speme ) AS labst
    FROM mard
      INNER JOIN marc ON mard~matnr = marc~matnr AND mard~werks = marc~werks
      INNER JOIN mara ON mard~matnr = mara~matnr
      INNER JOIN t001w ON mard~werks = t001w~werks
      INNER JOIN makt ON  makt~matnr = mara~matnr
    INTO CORRESPONDING FIELDS OF TABLE @et_material_stock
    WHERE mard~matnr IN @ra_matnr
      AND mard~werks EQ @i_werks
      AND mard~lvorm EQ @space
      AND lgort IN @ra_lgort
*      AND xchar EQ @space
      AND mara~mtart IN @ra_mtart
      AND makt~maktg IN @ra_maktx
      AND makt~spras IN @ra_spras
      GROUP BY mard~mandt, mard~matnr, mara~meins, makt~maktx,
*>>>>> CBC 07.06.2017 - Correct Stock Duplicates
          makt~spras.
*>>>>> CBC 07.06.2017 - Correct Stock Duplicates

    ENDCASE.


    SORT et_material_stock BY matnr.
    DELETE ADJACENT DUPLICATES FROM et_material_stock
      COMPARING matnr.

    DELETE et_material_stock WHERE labst = 0.

  ENDMETHOD.


  METHOD get_mouldes.

    TYPES: BEGIN OF ty_machines,
             equnr TYPE equnr,
             eqktx TYPE ktx01,
           END OF ty_machines.

    DATA: lr_deleted_equnr TYPE rsis_t_range,
          ls_deleted_equnr TYPE rsis_s_range,
          lt_deleted_equnr TYPE zabsf_pm_t_equipments_list,
          ls_deleted       LIKE LINE OF lt_deleted_equnr.

    DATA: ra_eqtyp TYPE RANGE OF eqtyp,
          l_langu  TYPE sy-langu.

    DATA: lr_range_equnr   TYPE rsis_t_range,
          ls_range_equnr   TYPE rsis_s_range,
          lr_range_desc    TYPE rsis_t_range,
          ls_range_desc    TYPE rsis_s_range,
          lr_range_stort   TYPE rsis_t_range,
          ls_range_stort   TYPE rsis_s_range,
          lr_range_machine TYPE rsis_t_range,
          ls_range_machine TYPE rsis_s_range,
          lr_machine_desc  TYPE rsis_t_range,
          ls_machine_desc  TYPE rsis_s_range,
          lr_spras         TYPE rsis_t_range,
          ls_spras         TYPE rsis_s_range.

    DATA: lt_eqkt     TYPE TABLE OF eqkt,
          ls_eqkt     TYPE eqkt,
          lt_machines TYPE TABLE OF ty_machines,
          ls_machines LIKE LINE OF lt_machines.

    FIELD-SYMBOLS <fs_mouldes> LIKE LINE OF et_mouldes.

**    Get alternative language
    SELECT SINGLE spras
      FROM zabsf_languages
      INTO l_langu
     WHERE werks      EQ i_inputobj-werks
       AND is_default NE space.


* get marked for deleted equipments.
    SELECT equi~equnr, eqkt~eqktx
          FROM equi INNER JOIN eqkt ON  eqkt~equnr = equi~equnr
                                  "  AND eqkt~spras = @sy-langu
          INNER JOIN equz ON equz~equnr = equi~equnr
          INNER JOIN jest ON equi~objnr = jest~objnr
          INTO TABLE @lt_deleted_equnr
          WHERE eqtyp IN @ra_eqtyp
          AND equz~iwerk = @i_inputobj-werks
          AND equz~datbi GE @sy-datlo
          AND jest~stat EQ 'I0076' AND jest~inact EQ @space.

* create range for excluded equipments.
    LOOP AT lt_deleted_equnr INTO ls_deleted.

      ls_deleted_equnr-sign = 'E'.
      ls_deleted_equnr-option = 'EQ'.
      ls_deleted_equnr-low = ls_deleted-equnr.

      APPEND ls_deleted_equnr TO lr_deleted_equnr.
      CLEAR: ls_deleted_equnr, ls_deleted.
    ENDLOOP.

    APPEND LINES OF lr_deleted_equnr TO lr_range_equnr.

* create ranges from UI
    IF is_filters-on_machine EQ abap_true.
      ls_range_machine-sign = 'E'.
      ls_range_machine-option = 'EQ'.
      ls_range_machine-low = space.

      APPEND ls_range_machine TO lr_range_machine.
    ENDIF.

    IF is_filters-eqktx IS NOT INITIAL.

      ls_range_desc-sign = 'I'.
      ls_range_desc-option = 'CP'.
      CONCATENATE '*' is_filters-eqktx '*' INTO ls_range_desc-low.

      APPEND ls_range_desc TO lr_range_desc.

      ls_spras-sign = 'I'.
      ls_spras-option = 'EQ'.
      ls_spras-low = sy-langu.
      APPEND ls_spras TO lr_spras.

      ls_spras-low =  l_langu.
      APPEND ls_spras TO lr_spras.

    ENDIF.

    IF is_filters-equnr IS NOT INITIAL.

      ls_range_equnr-sign = 'I'.
      ls_range_equnr-option = 'CP'.
      CONCATENATE '*' is_filters-equnr '*' INTO ls_range_equnr-low.

      APPEND ls_range_equnr TO lr_range_equnr.
    ENDIF.

    IF is_filters-stort IS NOT INITIAL.

      ls_range_stort-sign = 'I'.
      ls_range_stort-option = 'CP'.
      CONCATENATE '*' is_filters-stort '*' INTO ls_range_stort-low.

      APPEND ls_range_stort TO lr_range_stort.
    ENDIF.

* search by machine description.
    IF is_filters-machine_txt IS NOT INITIAL.

      ls_machine_desc-sign = 'I'.
      ls_machine_desc-option = 'CP'.
      CONCATENATE '*' is_filters-machine_txt '*' INTO ls_machine_desc-low.
      TRANSLATE ls_machine_desc-low TO UPPER CASE.
      APPEND ls_machine_desc TO lr_machine_desc.

      SELECT equi~equnr eqkt~eqktx
        FROM equi AS equi
        INNER JOIN eqkt AS eqkt
        ON equi~equnr EQ eqkt~equnr
        INNER JOIN equz AS equz
        ON equi~equnr EQ equz~equnr
      INTO TABLE lt_machines
        WHERE eqkt~eqktu IN lr_machine_desc
        AND ( eqkt~spras EQ sy-langu OR eqkt~spras EQ l_langu )
        AND equi~eqtyp EQ 'P' "machines
        AND equz~iwerk EQ i_inputobj-werks
        AND equz~datbi EQ '99991231'.  "centro de planejamento = centro de manutenção

      SORT lt_machines BY equnr.
      DELETE ADJACENT DUPLICATES FROM lt_machines COMPARING equnr.

* set machines ranges on main selection
      LOOP AT lt_machines INTO ls_machines.

        ls_range_machine-sign = 'I'.
        ls_range_machine-option = 'EQ'.
        ls_range_machine-low = ls_machines-equnr.

        APPEND ls_range_machine TO lr_range_machine.
        CLEAR: ls_machines, ls_range_machine.
      ENDLOOP.

    ENDIF.

    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_inputobj-werks
        i_parameter = 'EQTYP_MOULD'
      IMPORTING
        et_range    = ra_eqtyp.

    SELECT equz~equnr, iloa~stort, iloa~eqfnr, t499s~ktext, equz~hequi
      FROM equz LEFT JOIN eqkt ON  eqkt~equnr = equz~equnr
                               "AND eqkt~spras = @l_langu
      INNER JOIN iloa AS iloa ON equz~iloan = iloa~iloan
      INNER JOIN equi AS equi ON equz~equnr = equi~equnr
      LEFT JOIN t499s AS t499s ON t499s~stand = iloa~stort AND t499s~werks = @i_inputobj-werks
    INTO CORRESPONDING FIELDS OF TABLE @et_mouldes
      WHERE equi~eqtyp IN @ra_eqtyp
      AND equi~equnr IN @lr_range_equnr
      AND equz~datbi GE @sy-datlo
      AND equz~hequi IN @lr_range_machine
      AND equz~iwerk EQ @i_inputobj-werks  "centro de planejamento = centro de manutenção
      AND eqkt~eqktx IN @lr_range_desc
      AND iloa~stort IN @lr_range_stort
      AND equz~datbi EQ '99991231'
      AND eqkt~spras IN @lr_spras.

*    IF sy-subrc NE 0.


**    Get alternative language
*      SELECT SINGLE spras
*        FROM zabsf_languages
*        INTO l_langu
*       WHERE werks      EQ i_inputobj-werks
*         AND is_default NE space.

*      IF sy-subrc EQ 0.
*
*        SELECT equz~equnr, eqkt~eqktx, iloa~stort, iloa~eqfnr, t499s~ktext ,equz~hequi
*         FROM equz LEFT JOIN eqkt ON  eqkt~equnr = equz~equnr
*                                     AND eqkt~spras = @l_langu
*           INNER JOIN iloa AS iloa ON equz~iloan = iloa~iloan
*           INNER JOIN equi AS equi ON equz~equnr = equi~equnr
*           LEFT JOIN t499s AS t499s ON t499s~stand = iloa~stort AND t499s~werks = @i_inputobj-werks
*         INTO TABLE @et_mouldes
*           WHERE equi~eqtyp IN @ra_eqtyp
*           AND equi~equnr IN @lr_range_equnr
*           AND equz~datbi GE @sy-datlo
*           AND equz~hequi IN @lr_range_machine
*           AND equz~iwerk EQ @i_inputobj-werks  "centro de planejamento = centro de manutenção
*           AND eqkt~eqktx IN @lr_range_desc
*           AND iloa~stort IN @lr_range_stort
*           AND equz~datbi EQ '99991231'.
*
*      ENDIF.
*    ENDIF.

    SORT et_mouldes BY equnr.
    DELETE ADJACENT DUPLICATES FROM et_mouldes COMPARING equnr.

* get mouldes description
    CHECK et_mouldes IS NOT INITIAL.

    SELECT * FROM eqkt INTO TABLE lt_eqkt
      FOR ALL ENTRIES IN et_mouldes
      WHERE ( equnr = et_mouldes-equnr OR equnr = et_mouldes-hequi )
      AND spras = sy-langu.

    IF sy-subrc NE 0.
      SELECT * FROM eqkt INTO TABLE lt_eqkt
        FOR ALL ENTRIES IN et_mouldes
        WHERE ( equnr = et_mouldes-equnr OR equnr = et_mouldes-hequi )
        AND spras = l_langu.

    ENDIF.

    LOOP AT et_mouldes ASSIGNING <fs_mouldes>.

      READ TABLE lt_eqkt INTO ls_eqkt WITH KEY equnr = <fs_mouldes>-equnr.
      <fs_mouldes>-eqktx = ls_eqkt-eqktx.
      CLEAR ls_eqkt.

      READ TABLE lt_eqkt INTO ls_eqkt WITH KEY equnr = <fs_mouldes>-hequi.
      <fs_mouldes>-hequi_txt = ls_eqkt-eqktx.
      CLEAR ls_eqkt.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = <fs_mouldes>-hequi
        IMPORTING
          output = <fs_mouldes>-hequi.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_moulde_location.

    SELECT SINGLE iloa~stort, iloa~eqfnr, t499s~ktext
    FROM equz LEFT JOIN eqkt ON  eqkt~equnr = equz~equnr
    INNER JOIN iloa AS iloa ON equz~iloan = iloa~iloan
    INNER JOIN equi AS equi ON equz~equnr = equi~equnr
    LEFT JOIN t499s AS t499s ON t499s~stand = iloa~stort AND t499s~werks = @i_inputobj-werks
  INTO (@e_stort, @e_eqfnr, @e_ktext)
    WHERE equi~equnr EQ @i_equnr
    AND equz~datbi GT @sy-datlo.

  ENDMETHOD.


  METHOD get_notification.

    DATA: lt_notlongtext   TYPE TABLE OF bapi2080_notfulltxte,
          ls_notlongtext   TYPE bapi2080_notfulltxte,
          ra_istat_default TYPE RANGE OF j_status,
          ra_istat_closed  TYPE RANGE OF j_status,
          ra_istat_proc    TYPE RANGE OF j_status,
          ra_istat_open    TYPE RANGE OF j_status.

    DATA : lt_notitem TYPE TABLE OF bapi2080_notiteme,
           ls_notitem TYPE bapi2080_notiteme.

    DATA : lt_notifcaus TYPE TABLE OF bapi2080_notcause,
           ls_notifcaus TYPE bapi2080_notcause.

    DATA : lt_notifpartnr TYPE TABLE OF bapi2080_notpartnre,
           ls_notifpartnr TYPE bapi2080_notpartnre.

    DATA: lt_partner_info TYPE TABLE OF ihpad,
          ls_partner_info TYPE ihpad.

    DATA: ra_order_type_pm TYPE RANGE OF auart,
          ra_order_type_cs TYPE RANGE OF auart,
          ra_order_types   type range of auart.


    "PM Order Types for creation
    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_inputobj-werks
        i_parameter = 'AUFART_PM_CREATION'
      IMPORTING
        et_range    = ra_order_type_pm.

    APPEND LINES OF ra_order_type_pm TO ra_order_types.


    "CS Order Types for creation
    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_inputobj-werks
        i_parameter = 'AUFART_CS_CREATION'
      IMPORTING
        et_range    = ra_order_type_cs.

    APPEND LINES OF ra_order_type_cs TO ra_order_types.


* get notification status.
    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_inputobj-werks
        i_parameter = 'ISTAT_NOTIF_DEFAULT'
      IMPORTING
        et_range    = ra_istat_default.

    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_inputobj-werks
        i_parameter = 'ISTAT_NOTIF_CLOSED'
      IMPORTING
        et_range    = ra_istat_closed.


    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_inputobj-werks
        i_parameter = 'ISTAT_NOTIF_PROC'
      IMPORTING
        et_range    = ra_istat_proc.

    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_inputobj-werks
        i_parameter = 'ISTAT_NOTIF_OPEN'
      IMPORTING
        et_range    = ra_istat_open.


*>> get default language
    SELECT SINGLE spras
      FROM zabsf_languages
      INTO @DATA(lv_alt_spras)
     WHERE werks      EQ @i_inputobj-werks
       AND is_default EQ @abap_true.


*>> Get Status Code Text
    SELECT SINGLE parva
          FROM zabsf_pm_param
          INTO @DATA(lv_stat_conc)
         WHERE werks = @i_inputobj-werks
           AND parid = 'STAT_COD_CLOSED'.

    SELECT SINGLE parva
          FROM zabsf_pm_param
          INTO @DATA(lv_stat_proc)
         WHERE werks = @i_inputobj-werks
           AND parid = 'STAT_COD_PROC'.

    SELECT SINGLE parva
          FROM zabsf_pm_param
          INTO @DATA(lv_stat_open)
         WHERE werks = @i_inputobj-werks
           AND parid = 'STAT_COD_OPEN'.


*>> get order notification information
    IF i_aufnr IS NOT INITIAL.

      SELECT SINGLE qmel~qmnum, qmel~qmtxt, qmur~urkat, qmur~urgrp, qpgt~kurztext AS qktextgr,
                    qmur~urcod, qpct~kurztext AS qtxt_code, qmur~urtxt,
                    qmel~qmdat, qmel~mzeit, qmih~msaus AS breakdown, qmih~equnr, qmel~aufnr,
                    qmel~qmart, jest~stat AS status
          INTO CORRESPONDING FIELDS OF @e_notification
          FROM qmel LEFT  JOIN qmur ON  qmur~qmnum      = qmel~qmnum
                    LEFT  JOIN qpgt ON  qpgt~katalogart = qmur~urkat
                                    AND qpgt~codegruppe = qmur~urgrp
                                    AND qpgt~sprache    = @sy-langu
                    LEFT  JOIN qpct ON  qpct~katalogart = qmur~urkat
                                    AND qpct~codegruppe = qmur~urgrp
                                    AND qpct~code       = qmur~urcod
                                    AND qpct~sprache    = @sy-langu
                    INNER JOIN qmih AS qmih ON qmih~qmnum = qmel~qmnum
                    INNER JOIN jest AS jest ON jest~objnr = qmel~objnr
         WHERE qmel~aufnr = @i_aufnr
         AND jest~inact NE @abap_true
         AND jest~stat IN @ra_istat_default.


      IF e_notification IS NOT INITIAL AND
         ( e_notification-urgrp IS NOT INITIAL AND e_notification-qktextgr IS INITIAL OR
           e_notification-urcod IS NOT INITIAL AND e_notification-qtxt_code IS INITIAL ).

**>> get default language
*        SELECT SINGLE spras
*          FROM zsf06_languages
*          INTO @DATA(lv_alt_spras)
*         WHERE werks      EQ @i_inputobj-werks
*           AND is_default EQ @abap_true.

        IF lv_alt_spras IS NOT INITIAL AND lv_alt_spras <> sy-langu.
          IF e_notification-urgrp IS NOT INITIAL AND e_notification-qktextgr IS INITIAL.
            SELECT SINGLE kurztext
                INTO @e_notification-qktextgr
                FROM qpgt
               WHERE katalogart = @e_notification-urkat
                 AND codegruppe = @e_notification-urgrp
                 AND sprache    = @lv_alt_spras.
          ENDIF.
          IF e_notification-urcod IS NOT INITIAL AND e_notification-qtxt_code IS INITIAL.
            SELECT SINGLE kurztext
                INTO @e_notification-qtxt_code
                FROM qpct
               WHERE katalogart = @e_notification-urkat
                 AND codegruppe = @e_notification-urgrp
                 AND code       = @e_notification-urcod
                 AND sprache    = @lv_alt_spras.
          ENDIF.

        ENDIF.
      ENDIF.
    ENDIF.

    IF i_qmnum IS NOT INITIAL.

      SELECT SINGLE qmel~qmnum, qmel~qmtxt, qmur~urkat, qmur~urgrp, qpgt~kurztext AS qktextgr,
                   qmur~urcod, qpct~kurztext AS qtxt_code, qmur~urtxt,
                   qmel~qmdat, qmel~mzeit, qmih~equnr, qmel~aufnr,qmel~qmart,
                   jest~stat AS status, tq80_t~qmartx AS qmartx,
*>>CFB GET malfunction data
              qmih~ausvn AS malf_start_date, qmih~auztv AS malf_start_time,
              qmih~msaus AS breakdown, qmih~ausbs AS malf_end_date,
              qmih~auztb AS malf_end_time, qmih~auszt AS breakdown_dur,
              qmih~maueh AS break_dur_unit,
*>>CFB GET Reference Dates
              qmel~strmn AS req_start_date, qmel~strur AS req_start_time,
              qmel~ltrmn AS req_end_date, qmel~ltrur AS req_end_time,
              qmel~priok AS priority,
*>>CFB GET Coding information
              qmel~qmkat AS cod_qmkat,
              qmel~qmgrp AS cod_qmgrp,
              qmel~qmcod AS cod_qmcod,
*>>CFB Get Responsabilities
              qmih~ingrp AS rsp_plan_grp,
              qmih~iwerk AS rsp_plant_plan_grp,

              t024i~innam AS rsp_plan_grp_txt,

              qmel~arbpl AS rsp_main_wc,
              qmel~arbplwerk AS rsp_plant_main_wc,
              qmel~qmnam AS rsp_rpt_by,
              qmel~qmdat AS rsp_notif_date,
              qmel~mzeit AS rsp_notif_time,

              qmel~objnr,
              qmih~kdauf AS salesdoc,
              qmih~kdpos AS salesdoc_item

         INTO CORRESPONDING FIELDS OF @e_notification
         FROM qmel LEFT  JOIN qmur ON  qmur~qmnum      = qmel~qmnum
                   LEFT  JOIN qpgt ON  qpgt~katalogart = qmur~urkat
                                   AND qpgt~codegruppe = qmur~urgrp
                                   AND qpgt~sprache    = @sy-langu
                   LEFT  JOIN qpct ON  qpct~katalogart = qmur~urkat
                                   AND qpct~codegruppe = qmur~urgrp
                                   AND qpct~code       = qmur~urcod
                                   AND qpct~sprache    = @sy-langu
                   INNER JOIN qmih AS qmih ON qmih~qmnum = qmel~qmnum
                   INNER JOIN jest AS jest ON jest~objnr = qmel~objnr

*>>CFB Notification Type TEXT 11.07.2017
                    LEFT JOIN tq80_t AS tq80_t ON tq80_t~qmart = qmel~qmart
                    AND tq80_t~spras = @sy-langu
*>>CFB Notification Type TEXT 11.07.2017
                    LEFT JOIN t024i ON t024i~ingrp = qmih~ingrp
                    AND t024i~iwerk =  qmih~iwerk

        WHERE qmel~qmnum = @i_qmnum
         AND jest~inact NE @abap_true
         AND jest~stat IN @ra_istat_default.


      IF e_notification IS NOT INITIAL AND
         ( e_notification-urgrp IS NOT INITIAL AND e_notification-qktextgr IS INITIAL OR
           e_notification-urcod IS NOT INITIAL AND e_notification-qtxt_code IS INITIAL ).

**>> get default language
*        SELECT SINGLE spras
*          FROM zsf06_languages
*          INTO @lv_alt_spras
*         WHERE werks      EQ @i_inputobj-werks
*           AND is_default EQ @abap_true.

        IF lv_alt_spras IS NOT INITIAL AND lv_alt_spras <> sy-langu.
          IF e_notification-urgrp IS NOT INITIAL AND e_notification-qktextgr IS INITIAL.
            SELECT SINGLE kurztext
                INTO @e_notification-qktextgr
                FROM qpgt
               WHERE katalogart = @e_notification-urkat
                 AND codegruppe = @e_notification-urgrp
                 AND sprache    = @lv_alt_spras.
          ENDIF.
          IF e_notification-urcod IS NOT INITIAL AND e_notification-qtxt_code IS INITIAL.
            SELECT SINGLE kurztext
                INTO @e_notification-qtxt_code
                FROM qpct
               WHERE katalogart = @e_notification-urkat
                 AND codegruppe = @e_notification-urgrp
                 AND code       = @e_notification-urcod
                 AND sprache    = @lv_alt_spras.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.


    IF e_notification-qmnum IS NOT INITIAL.
*>> BMR - get long texts.
      CALL FUNCTION 'BAPI_ALM_NOTIF_GET_DETAIL'
        EXPORTING
          number      = e_notification-qmnum
        TABLES
          notlongtxt  = lt_notlongtext
          notitem     = lt_notitem
          notifcaus   = lt_notifcaus
          notifpartnr = lt_notifpartnr.

      LOOP AT lt_notlongtext INTO ls_notlongtext.

        IF ls_notlongtext-format_col = '>X'.

          ls_notlongtext-text_line(1) = space.    "remove '*' from text
          APPEND ls_notlongtext-text_line+2 TO e_notification-text_long.
        ELSE.
          APPEND ls_notlongtext-text_line TO e_notification-text_long.
        ENDIF.

        CLEAR ls_notlongtext.
      ENDLOOP.


*>>CFB GET Items and respective Causes using the BAPI above
      " do not send the items marked for deletion
      DELETE lt_notitem WHERE delete_flag EQ 'X'.

      MOVE-CORRESPONDING lt_notitem TO e_notification-not_items.

      FIELD-SYMBOLS <fs_not_items> LIKE LINE OF e_notification-not_items.

      LOOP AT e_notification-not_items ASSIGNING <fs_not_items>.

*        LOOP AT lt_notifcaus INTO ls_notifcaus.

        READ TABLE lt_notifcaus WITH KEY
                item_key = <fs_not_items>-item_key
                notif_no = <fs_not_items>-notif_no
                delete_flag = space
        INTO ls_notifcaus.

        IF sy-subrc = 0.

          <fs_not_items>-cause_cat_typ = ls_notifcaus-cause_cat_typ.
          <fs_not_items>-cause_code = ls_notifcaus-cause_code.
          <fs_not_items>-cause_codegrp = ls_notifcaus-cause_codegrp.
          <fs_not_items>-cause_key = ls_notifcaus-cause_key.
          <fs_not_items>-cause_sort_no = ls_notifcaus-cause_sort_no.
          <fs_not_items>-causetext = ls_notifcaus-causetext.
          <fs_not_items>-txt_causegrp = ls_notifcaus-txt_causegrp.
          <fs_not_items>-txt_causecd = ls_notifcaus-txt_causecd.

        ENDIF.

*        ENDLOOP.

      ENDLOOP.





*>> Get status.
*>> status description
      SELECT SINGLE txt30  FROM tj02t INTO e_notification-status_txt
        WHERE istat = e_notification-status
        AND  spras = sy-langu.

      IF sy-subrc NE  0.
        SELECT SINGLE txt30 FROM tj02t INTO e_notification-status_txt
          WHERE istat = e_notification-status
          AND  spras = lv_alt_spras.

      ENDIF.

      IF e_notification-status IN ra_istat_closed.
        e_notification-status_proc = lv_stat_conc.

      ELSEIF e_notification-status IN ra_istat_proc.
        e_notification-status_proc = lv_stat_proc.

      ELSEIF e_notification-status IN ra_istat_open.
        e_notification-status_proc = lv_stat_open.
      ENDIF.


*>> get equipment description
      SELECT SINGLE eqktx FROM eqkt INTO e_notification-eqktx
        WHERE equnr = e_notification-equnr
        AND spras = sy-langu.

      IF sy-subrc NE 0.
        SELECT SINGLE eqktx FROM eqkt INTO e_notification-eqktx
          WHERE equnr = e_notification-equnr
          AND spras = lv_alt_spras.

      ENDIF.



* Functional Location and it's description
      SELECT SINGLE  i~tplnr, ix~pltxt INTO ( @e_notification-func_loc, @e_notification-func_loc_tx )
        FROM iloa AS i
          INNER JOIN qmih AS q ON q~iloan = i~iloan
          INNER JOIN iflotx AS ix ON ix~tplnr = i~tplnr AND ix~spras = @sy-langu
        WHERE q~qmnum = @e_notification-qmnum.

      IF sy-subrc NE 0 AND lv_alt_spras NE sy-langu.
        SELECT SINGLE i~tplnr, ix~pltxt INTO ( @e_notification-func_loc, @e_notification-func_loc_tx )
          FROM iloa AS i
            INNER JOIN qmih AS q ON q~iloan = i~iloan
            INNER JOIN iflotx AS ix ON ix~tplnr = i~tplnr AND ix~spras = @lv_alt_spras
          WHERE q~qmnum = @e_notification-qmnum.
      ENDIF.

      IF e_notification-mzeit = '240000'.
        e_notification-mzeit = e_notification-mzeit - 1.
      ENDIF.
      IF e_notification-req_start_time = '240000'.
        e_notification-req_start_time = e_notification-req_start_time - 1.
      ENDIF.
      IF e_notification-req_end_time = '240000'.
        e_notification-req_end_time = e_notification-req_end_time - 1.
      ENDIF.
      IF e_notification-malf_start_time = '240000'.
        e_notification-malf_start_time = e_notification-malf_start_time - 1.
      ENDIF.
      IF e_notification-malf_end_time = '240000'.
        e_notification-malf_end_time = e_notification-malf_end_time - 1.
      ENDIF.
      IF e_notification-rsp_notif_time = '240000'.
        e_notification-rsp_notif_time = e_notification-rsp_notif_time - 1.
      ENDIF.


    ENDIF.



*>>>CFB Get Technical Object Attachments
*>>>CFB - Change to get only the attachments from Notification ignoring the ones from technical object

    DATA ls_object TYPE sibflporb.

    DATA: lt_attach_list TYPE zabsf_pm_t_attachment_list,
          ls_attach_list TYPE LINE OF zabsf_pm_t_attachment_list.

    IF i_qmnum IS NOT INITIAL.

      DATA lv_qmnum TYPE qmnum.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = i_qmnum
        IMPORTING
          output = lv_qmnum.

      "get for PM Notifications
      CLEAR  ls_object.
      CLEAR ls_attach_list.
      CLEAR lt_attach_list.

      ls_object-typeid    = 'BUS2038'.
      ls_object-instid    = lv_qmnum.
      ls_object-catid     = 'BO'.


      CALL METHOD get_attachments_list
        EXPORTING
          i_gos_obj      = ls_object
        IMPORTING
          et_attachments = lt_attach_list.


      IF lt_attach_list IS NOT INITIAL.

        LOOP AT lt_attach_list INTO ls_attach_list.

          APPEND  ls_attach_list TO e_notification-attach_list.
        ENDLOOP.

      ENDIF.

      "get for CS Notifications
      CLEAR  ls_object.
      CLEAR ls_attach_list.
      CLEAR lt_attach_list.

      ls_object-typeid    = 'BUS2080'.
      ls_object-instid    = lv_qmnum.
      ls_object-catid     = 'BO'.


      CALL METHOD get_attachments_list
        EXPORTING
          i_gos_obj      = ls_object
        IMPORTING
          et_attachments = lt_attach_list.


      IF lt_attach_list IS NOT INITIAL.

        LOOP AT lt_attach_list INTO ls_attach_list.

          APPEND  ls_attach_list TO e_notification-attach_list.
        ENDLOOP.

      ENDIF.

    ENDIF.

* verify if exists func. location and if so get the attachments of that func. location
*    IF e_notification-func_loc IS NOT INITIAL.
*
*      CLEAR  ls_object.
*      CLEAR ls_attach_list.
*      CLEAR lt_attach_list.
*
*      ls_object-typeid    = 'BUS0010'.
*      ls_object-instid    = e_notification-func_loc.
*      ls_object-catid     = 'BO'.
*
*
*      CALL METHOD get_attachments_list
*        EXPORTING
*          i_gos_obj      = ls_object
*        IMPORTING
*          et_attachments = lt_attach_list.
*
*
*      IF lt_attach_list IS NOT INITIAL.
*
*        LOOP AT lt_attach_list INTO ls_attach_list.
*
*          APPEND  ls_attach_list TO e_notification-attach_list.
*        ENDLOOP.
*
*      ENDIF.
*
*    ENDIF.
*
*
** verify if equipment numbe exis, if so get the attachments of that equipment.
*    IF e_notification-equnr IS NOT INITIAL.
*
*      CLEAR  ls_object.
*      CLEAR ls_attach_list.
*      CLEAR lt_attach_list.
*
*      ls_object-typeid    = 'EQUI'.
*      ls_object-instid    = e_notification-equnr.
*      ls_object-catid     = 'BO'.
*
*      CALL METHOD get_attachments_list
*        EXPORTING
*          i_gos_obj      = ls_object
*        IMPORTING
*          et_attachments = lt_attach_list.
*
*
*      IF lt_attach_list IS NOT INITIAL.
*
*        LOOP AT lt_attach_list INTO ls_attach_list.
*
*          APPEND  ls_attach_list TO e_notification-attach_list.
*        ENDLOOP.
*
*      ENDIF.
*
*    ENDIF.
*<<<CFB Get Technical Object Attachments


**>>>CFB 13/07/2017 - Get Customer Information
*    CALL METHOD ZCL_ABSF_PM=>get_customer_info
*      EXPORTING
*        i_inputobj       = i_inputobj
*        i_equnr          = e_notification-equnr
*        i_tplnr          = e_notification-func_loc
*      IMPORTING
*        et_customer_info = e_notification-customer_info.
**<<<CFB 13/07/2017 - Get Customer Information


*>>>CFB 13/07/2017 - Get Service Type
    DATA : ra_notif_type TYPE RANGE OF qmart.

    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_werks
        i_parameter = 'QMART_NOTIF_CS'
      IMPORTING
        et_range    = ra_notif_type.

    IF e_notification-qmart IN ra_notif_type.
      e_notification-serv_type = 'CS'.
    ENDIF.

    CLEAR ra_notif_type.

    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_werks
        i_parameter = 'QMART_NOTIF_PM'
      IMPORTING
        et_range    = ra_notif_type.

    IF e_notification-qmart IN ra_notif_type.
      e_notification-serv_type = 'PM'.
    ENDIF.

*<<<CFB 13/07/2017 - Get Service Type


*>>>CFB 14/07/2017 - Get Responsable and get TEXT of main work center

*    " get user responsable
*    READ TABLE lt_notifpartnr WITH KEY partn_role = 'VU'
*    object_no = e_notification-objnr
*    counter = 0
*    INTO ls_notifpartnr.
*
*    e_notification-rsp_user_resp = ls_notifpartnr-partner.

*>>>DGG 19/07/2017 - Get user responsible
    CALL FUNCTION 'PM_GET_PARTNER_INFO' "
      EXPORTING
        object_number = e_notification-objnr " viqmel-objnr
      TABLES
        ihpad_tab_exp = lt_partner_info " ihpad
      .  "  PM_GET_PARTNER_INFO

    READ TABLE lt_partner_info WITH KEY objnr = e_notification-objnr
      INTO ls_partner_info.
    e_notification-rsp_user_resp = ls_partner_info-parnr.
    e_notification-rsp_user_resp_name = ls_partner_info-name_list.
*<<<DGG 19/07/2017 - Get user responsible

    "get cooding group text if is initial, using lv_alt_spras

    SELECT SINGLE kurztext
    INTO e_notification-cod_qmcod_txt
    FROM qpct
    WHERE katalogart = e_notification-cod_qmkat
          AND codegruppe = e_notification-cod_qmgrp
          AND code = e_notification-cod_qmcod
         " AND version EQ 1
          AND inaktiv EQ space
          AND sprache   EQ sy-langu.

    IF sy-subrc NE 0.

      SELECT SINGLE kurztext
      INTO e_notification-cod_qmcod_txt
      FROM qpct
       WHERE katalogart = e_notification-cod_qmkat
          AND codegruppe = e_notification-cod_qmgrp
          AND code = e_notification-cod_qmcod
        "  AND version = 1
          AND inaktiv EQ space
          AND sprache    EQ lv_alt_spras.

    ENDIF.

    "get workcenter text
    SELECT SINGLE ktext
      INTO e_notification-rsp_main_wc_txt
      FROM crtx
      WHERE objid = e_notification-rsp_main_wc
        AND spras = sy-langu
        AND objty = 'A'. "Tabela Partilhada - Parametro A - Workcenter

    IF sy-subrc NE 0.
      SELECT SINGLE ktext
        INTO e_notification-rsp_main_wc_txt
        FROM crtx
        WHERE objid = e_notification-rsp_main_wc
          AND spras = lv_alt_spras
          AND objty = 'A'. "Tabela Partilhada - Parametro A - Workcenter
    ENDIF.

    " get workcenter
    SELECT SINGLE arbpl
      INTO e_notification-rsp_main_wc
      FROM crhd
      WHERE objid = e_notification-rsp_main_wc
      AND objty = 'A'. "Tabela Partilhada - Parametro A - Workcenter


*<<<CFB 14/07/2017 - Get Responsable and get TEXT of main work center


*>>CFB 24/07/2017 - Get Maintenace History
    CALL METHOD zcl_absf_pm=>get_maintenance_history
      EXPORTING
        i_inputobj       = i_inputobj
        i_equnr          = e_notification-equnr
        i_tplnr          = e_notification-func_loc
      IMPORTING
        et_maint_history = e_notification-maint_history.

*<<CFB 24/07/2017 - Get Maintenace History


*>>>CFB Get the breakdown duration in H
    CALL FUNCTION 'UNIT_CONVERSION_SIMPLE'
      EXPORTING
        input                = e_notification-breakdown_dur
        unit_in              = 'S'
        unit_out             = 'H'
      IMPORTING
        output               = e_notification-breakdown_dur
      EXCEPTIONS
        conversion_not_found = 1
        division_by_zero     = 2
        input_invalid        = 3
        output_invalid       = 4
        overflow             = 5
        type_invalid         = 6
        units_missing        = 7
        unit_in_not_found    = 8
        unit_out_not_found   = 9
        OTHERS               = 10.

*<<<CFB Get the breakdown duration in H


*>>>> CFB 04.10.2018 Envio da estrutura de equipamento com as garantias, matricula

    DATA: ls_equipemnt TYPE zabsf_pm_s_equipment,
          lv_objnr     TYPE equi-objnr,
          lt_bgmkobj   TYPE TABLE OF bgmkobj.

    ls_equipemnt-equnr = e_notification-equnr.
    ls_equipemnt-eqktx = e_notification-eqktx.
    ls_equipemnt-tplnr = e_notification-func_loc.

    SELECT SINGLE objnr FROM equi
      INTO lv_objnr
     WHERE equnr = e_notification-equnr.

*    matricula
    SELECT SINGLE fleet~license_num
      INTO ls_equipemnt-license_num
      FROM fleet AS fleet
      WHERE fleet~objnr = lv_objnr.

    SELECT * FROM bgmkobj
      INTO TABLE lt_bgmkobj
      WHERE j_objnr = lv_objnr.

*   ler a tabela de garantias para cada um dos equipamentos encontrados
    LOOP AT lt_bgmkobj INTO DATA(ls_bgmkobj).

      IF sy-subrc EQ 0.

        CASE ls_bgmkobj-gaart. "case ao tipo de garantia

          WHEN '2'. "garantia do tipo 2 Fornecedor
            ls_equipemnt-vendor_gwldt = ls_bgmkobj-gwldt.
            ls_equipemnt-vendor_gwlen = ls_bgmkobj-gwlen.

            IF sy-datum BETWEEN ls_bgmkobj-gwldt AND ls_bgmkobj-gwlen.
              ls_equipemnt-in_guarantee_vendor = 'X'.
            ENDIF.
          WHEN '3'. "garantia do tipo 3 Fabricante
            ls_equipemnt-manuf_gwldt = ls_bgmkobj-gwldt.
            ls_equipemnt-manuf_gwlen = ls_bgmkobj-gwlen.

            IF sy-datum BETWEEN ls_bgmkobj-gwldt AND ls_bgmkobj-gwlen.
              ls_equipemnt-in_guarantee_manuf = 'X'.

            ENDIF.
          WHEN OTHERS. " só vamos tratar as do tipo 2 e 3

        ENDCASE.

      ENDIF.
    ENDLOOP.

    e_notification-equipment = ls_equipemnt.

*<<<< CFB 04.10.2018 Envio da estrutura de equipamento com as garantias



* >>>> CFB 12.10.2018 Envio de tabela com os tipos de Ordem Associados ao tipo da Nota em questao

    select tq80~auart, t003p~txt
      into CORRESPONDING FIELDS OF table @e_notification-ordertypes_default
      from tq80 as tq80
      INNER JOIN t003p ON  tq80~auart = t003p~auart and
                           t003p~spras = @lv_alt_spras
     where tq80~qmart =  @e_notification-qmart and
           tq80~auart in @ra_order_types.

* <<<< CFB 12.10.2018 Envio de tabela com os tipos de Ordem Associados ao tipo da Nota em questao

  ENDMETHOD.


  METHOD get_notifications_list.

*   CONSTANTS
    "Params in Parametrization Table
    DATA: c_prog            TYPE programm VALUE 'RIQMEL20',
          c_pmo_dp_vari_cfg TYPE param_id VALUE 'PM_NOT_DISP_VARIANT',
          c_param_notif_pm  TYPE param_id VALUE 'QMART_NOTIF_PM',
          c_param_notif_cs  TYPE param_id VALUE 'QMART_NOTIF_CS'.

    DATA: lv_start_table TYPE int4 VALUE '2'.

    "RANGES
    DATA: lr_status_range TYPE rsis_t_range,
          ls_dates        TYPE rsis_s_range,
          lr_dates        TYPE rsis_t_range,
          ls_qmnum        TYPE rsis_s_range,
          lr_qmnum        TYPE rsis_t_range.

    DATA: ra_istat_open    TYPE RANGE OF j_status,
          ra_istat_proc    TYPE RANGE OF j_status,
          ra_istat_closed  TYPE RANGE OF j_status,
          ra_stat_default  TYPE RANGE OF j_status,
          ra_notif_type_pm TYPE RANGE OF qmart,
          ra_notif_type_cs TYPE RANGE OF qmart,
          ra_notif_types   TYPE RANGE OF qmart.

    "VARIABLES
    DATA: lv_vari_protect    TYPE flag,
          lv_disp_var        TYPE slis_vari,
          lv_qmnum           TYPE qmnum,
          lv_where           TYPE string,
          lv_stat_blocked    TYPE boole_d,
          lv_stat_closed     TYPE boole_d,
          lv_stat_processing TYPE boole_d,
          lv_stat_released   TYPE boole_d,
          lv_stat_open       TYPE boole_d,
          lv_stat_stoped     TYPE boole_d,
          lv_stat_others     TYPE boole_d.

    "STRUCTURES
    DATA: BEGIN OF ls_notif_data.
        INCLUDE TYPE zabsf_pm_s_notif_list.
    DATA: qmart TYPE qmart.
    DATA: END OF ls_notif_data.
    DATA: lt_notif_data        LIKE TABLE OF ls_notif_data,
          lt_notif_data_others LIKE TABLE OF ls_notif_data.

    DATA: ls_notif LIKE LINE OF lt_notif_data.


    "INTERNAL TABLES
    DATA: lt_notifications_aux TYPE zabsf_pm_t_notif_list,
          lt_eqkt              TYPE TABLE OF eqkt,
          lt_notifs_status_in  TYPE zabsf_pm_notifs_status_t,
          lt_notifs_status_out TYPE zabsf_pm_notifs_status_t.


    DATA: BEGIN OF ls_spool_list,
            qmnum TYPE qmnum,
          END OF ls_spool_list.
    DATA: lt_spool_list LIKE TABLE OF ls_spool_list.

    "JOB & SPOOL
    DATA: lv_number        TYPE tbtcjob-jobcount,
          lv_name          TYPE tbtcjob-jobname,
          print_parameters TYPE pri_params,
          lv_status        TYPE tbtco-status,
          e_flag           TYPE flag,
          lv_spool_nr      TYPE btclistid.

    FIELD-SYMBOLS <fs_notifications> LIKE LINE OF et_notifications.
    FIELD-SYMBOLS <fs_notif_data> LIKE LINE OF lt_notif_data.


** INITIALIZATIONS
*>> get default language
    SELECT SINGLE spras
      FROM zabsf_languages
      INTO (@DATA(l_alt_spras))
     WHERE werks      EQ @i_inputobj-werks
       AND is_default EQ @abap_true.

    "Notifications Type PM
    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_inputobj-werks
        i_parameter = c_param_notif_pm
      IMPORTING
        et_range    = ra_notif_type_pm.

    APPEND LINES OF ra_notif_type_pm TO ra_notif_types.

    "Notifications Type CS
    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_inputobj-werks
        i_parameter = c_param_notif_cs
      IMPORTING
        et_range    = ra_notif_type_cs.

    APPEND LINES OF ra_notif_type_cs TO ra_notif_types.


*-------------------------------------------
*         Search by Variant
*-------------------------------------------
    IF i_variant IS NOT INITIAL.


      "Return error when Variant is protected
      SELECT SINGLE protected INTO @lv_vari_protect
        FROM varid
        WHERE report = @c_prog
          AND variant = @i_variant.

      IF lv_vari_protect = abap_true.
*            MESSAGE e037(ZABSF_PM).
        CALL METHOD zcl_absf_pm=>add_message
          EXPORTING
            msgty      = 'E'
            msgno      = '037'
            msgv1      = i_variant
          CHANGING
            return_tab = et_returntab.
        EXIT.
      ENDIF.


      "Get Display Variant from Parametrization Table
      SELECT SINGLE parva
        FROM zabsf_pm_param
        INTO lv_disp_var
       WHERE werks = i_inputobj-werks
         AND parid = c_pmo_dp_vari_cfg.


* GET ORDERS USING VARIANT by JOB

*Nome do JOB
      CONCATENATE 'SF_PM_ORD_VARI_' sy-datum '_' sy-uzeit INTO lv_name.


      CALL FUNCTION 'JOB_OPEN'
        EXPORTING
          jobname          = lv_name
        IMPORTING
          jobcount         = lv_number
        EXCEPTIONS
          cant_create_job  = 1
          invalid_job_data = 2
          jobname_missing  = 3
          OTHERS           = 4.


      IF sy-subrc = 0.

        SUBMIT riqmel20 TO SAP-SPOOL
            SPOOL PARAMETERS print_parameters
            WITHOUT SPOOL DYNPRO
            USING SELECTION-SET i_variant
                  WITH variant = lv_disp_var    "Output Display Variant PARAM
                  WITH qmart   IN ra_notif_types "Notification Type PARAM
            VIA JOB lv_name NUMBER lv_number
            AND RETURN.

        IF sy-subrc = 0.
          CALL FUNCTION 'JOB_CLOSE'
            EXPORTING
              jobcount             = lv_number
              jobname              = lv_name
              strtimmed            = 'X'
            EXCEPTIONS
              cant_start_immediate = 1
              invalid_startdate    = 2
              jobname_missing      = 3
              job_close_failed     = 4
              job_nosteps          = 5
              job_notex            = 6
              lock_failed          = 7
              OTHERS               = 8.
          IF sy-subrc <> 0.

          ENDIF.
        ENDIF.
      ENDIF.


* Verifica se o JOB ja acabou
      DO.
        CLEAR lv_status.
        SELECT SINGLE status FROM tbtco INTO lv_status
        WHERE jobname LIKE lv_name
        AND jobcount = lv_number.

*Erro
        IF lv_status = 'A'.
          e_flag = 'E'.
          MESSAGE e026(zabsf_pm).
          CALL METHOD zcl_absf_pm=>add_message
            EXPORTING
              msgty      = 'W'
              msgno      = '026'
              msgv1      = 'riqmel20'
              msgv2      = lv_name
            CHANGING
              return_tab = et_returntab.
          EXIT.
          EXIT.
*Nao ocorreu erro
        ELSEIF lv_status = 'F'.
          e_flag = 'S'.
          EXIT.
        ELSE.
          WAIT UP TO 5 SECONDS.
        ENDIF.

      ENDDO.

      IF e_flag = 'S'.

        CLEAR lv_spool_nr.
        SELECT SINGLE listident INTO lv_spool_nr
          FROM  tbtcp
          WHERE jobname = lv_name
            AND jobcount = lv_number.

        IF lv_spool_nr IS INITIAL. "= '0000000000'.
*          MESSAGE e025(ZABSF_PM).
          CALL METHOD zcl_absf_pm=>add_message
            EXPORTING
              msgty      = 'W'
              msgno      = '025'
              msgv1      = i_variant
            CHANGING
              return_tab = et_returntab.
          EXIT.
        ENDIF.

        CALL METHOD zcl_absf_pm=>conv_spool_list_2_table
          EXPORTING
            i_spooln        = lv_spool_nr
            i_keep_sum_line = 'X'
            i_start_table   = lv_start_table "'2'  " '4'
          CHANGING
            et_spool_table  = lt_spool_list.


        LOOP AT lt_spool_list INTO ls_spool_list.

          ls_qmnum-sign = 'I'.
          ls_qmnum-option = 'CP'.

          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = ls_spool_list-qmnum
            IMPORTING
              output = lv_qmnum.

          ls_qmnum-low = lv_qmnum.

          APPEND ls_qmnum TO lr_qmnum.

        ENDLOOP.

*--------------------------------------------
*--------------------------------------------
*      Get Notifications in list Info
*--------------------------------------------
*--------------------------------------------

        "GET Notifications Info
        SELECT qmel~qmnum,
               qmel~qmdat,
               qmel~mzeit,
               qmel~qmtxt,
               qmel~aufnr,
               qmih~msaus  AS breakdown ,
               qmih~equnr,
               qmel~qmart
        INTO CORRESPONDING FIELDS OF TABLE @lt_notif_data
        FROM qmel AS qmel
         INNER JOIN qmih AS qmih ON qmih~qmnum = qmel~qmnum
        WHERE qmel~qmnum IN @lr_qmnum.

        lv_stat_blocked     = abap_false.
        lv_stat_closed      = abap_true.
        lv_stat_processing  = abap_true.
        lv_stat_released    = abap_false.
        lv_stat_open        = abap_true.
        lv_stat_stoped      = abap_false.
        lv_stat_others      = abap_true.


      ENDIF.


*-------------------------------------------
*    Old serch method (with user filters)
*-------------------------------------------
    ELSE.

*>> Dates
      IF is_filters-date_from IS NOT INITIAL AND is_filters-date_to IS NOT INITIAL.

        ls_dates-sign = 'I'.
        ls_dates-option = 'BT'.
        ls_dates-low = is_filters-date_from.
        ls_dates-high = is_filters-date_to.
        APPEND ls_dates TO lr_dates.

      ELSE.
        IF is_filters-date_from IS NOT INITIAL AND is_filters-date_to IS INITIAL.

          ls_dates-sign = 'I'.
          ls_dates-option = 'BT'.
          ls_dates-low = is_filters-date_from.
          ls_dates-high = '99991231'.
          APPEND ls_dates TO lr_dates.
        ENDIF.

        IF is_filters-date_to IS NOT INITIAL AND is_filters-date_from IS INITIAL.
          ls_dates-sign = 'I'.
          ls_dates-option = 'BT'.
          ls_dates-low = '00000000'.
          ls_dates-high = is_filters-date_to.
          APPEND ls_dates TO lr_dates.
        ENDIF.
      ENDIF.

      IF is_filters-serv_type = 'PM'.
        lv_where = ' qmel~qmart IN @ra_notif_type_pm '.
      ELSEIF is_filters-serv_type = 'CS'.
        lv_where = ' qmel~qmart IN @ra_notif_type_cs '.
      ENDIF.


*--------------------------------------------
*--------------------------------------------
*         Get Notifications Info
*--------------------------------------------
*--------------------------------------------

* get data from tables.
      SELECT  qmel~qmnum,
              qmel~qmdat,
              qmel~mzeit,
              qmel~qmtxt,
              qmel~aufnr,
              qmih~msaus  AS breakdown ,
              qmih~equnr,
              qmel~qmart
        INTO CORRESPONDING FIELDS OF TABLE @lt_notif_data "@et_notifications
        FROM qmel AS qmel
         INNER JOIN qmih AS qmih ON qmih~qmnum = qmel~qmnum
        WHERE qmel~qmart IN @ra_notif_types
          AND qmel~qmdat  IN @lr_dates
          AND qmel~arbplwerk = @i_inputobj-werks  " CFB 08.10.2018  - add werks of user conf on shopfloor
          AND (lv_where).


      lv_stat_blocked     = abap_false.
      lv_stat_closed      = abap_false.
      lv_stat_processing  = abap_false.
      lv_stat_released    = abap_false.
      lv_stat_open        = abap_false.
      lv_stat_stoped      = abap_false.
      lv_stat_others      = abap_false.

      "STATUS => CLOSED
      IF is_filters-stat_finished EQ abap_true.
        lv_stat_closed = abap_true.
      ENDIF.

      "STATUS => PROCESSING
      IF is_filters-stat_open EQ abap_true.
        lv_stat_processing = abap_true.
      ENDIF.

      "STATUS => OPEN
      IF is_filters-stat_created EQ abap_true.
        lv_stat_open = abap_true.
      ENDIF.


    ENDIF.


*      CHECK et_notifications IS NOT INITIAL.
    CHECK lt_notif_data IS NOT INITIAL.

    SORT lt_notif_data BY qmnum.
    DELETE ADJACENT DUPLICATES FROM lt_notif_data COMPARING qmnum.

*>> get status
    MOVE-CORRESPONDING lt_notif_data TO lt_notifs_status_in.

    CALL METHOD zcl_absf_pm=>get_notifs_status
      EXPORTING
        i_werks           = i_inputobj-werks
        i_stat_blocked    = lv_stat_blocked
        i_stat_closed     = lv_stat_closed
        i_stat_processing = lv_stat_processing
        i_stat_released   = lv_stat_released
        i_stat_open       = lv_stat_open
        i_stat_stoped     = lv_stat_stoped
        i_stat_others     = lv_stat_others
        it_notifs_list    = lt_notifs_status_in
      IMPORTING
        et_notifs_list    = lt_notifs_status_out.

*>> status description
    SELECT * FROM tj02t INTO TABLE @DATA(lt_status_txt)
      FOR ALL ENTRIES IN @lt_notifs_status_out
      WHERE istat = @lt_notifs_status_out-status
      AND  spras = @sy-langu.

    IF sy-subrc NE  0.

*>> status description
      SELECT * FROM tj02t INTO TABLE @lt_status_txt
        FOR ALL ENTRIES IN @lt_notifs_status_out
        WHERE istat = @lt_notifs_status_out-status
        AND  spras = @l_alt_spras.

    ENDIF.


*>> Equipment description
    SELECT * FROM eqkt INTO TABLE lt_eqkt
      FOR ALL ENTRIES IN lt_notif_data
      WHERE equnr = lt_notif_data-equnr
      AND spras = sy-langu.

    IF sy-subrc NE 0.
*>> Equipment description default language

      SELECT * FROM eqkt INTO TABLE lt_eqkt
        FOR ALL ENTRIES IN lt_notif_data
        WHERE equnr = lt_notif_data-equnr
        AND spras = l_alt_spras.

    ENDIF.

* Functional Location and it's description
    SELECT q~qmnum, i~tplnr, ix~pltxt INTO TABLE @DATA(lt_func_loc)
      FROM iloa AS i
        INNER JOIN qmih AS q ON q~iloan = i~iloan
        INNER JOIN iflotx AS ix ON ix~tplnr = i~tplnr
      FOR ALL ENTRIES IN @lt_notif_data
      WHERE q~qmnum = @lt_notif_data-qmnum
            AND ix~spras = @sy-langu.

    IF sy-subrc NE 0 AND l_alt_spras NE sy-langu.
      SELECT q~qmnum, i~tplnr, ix~pltxt INTO TABLE @lt_func_loc
        FROM iloa AS i
          INNER JOIN qmih AS q ON q~iloan = i~iloan
          INNER JOIN iflotx AS ix ON ix~tplnr = i~tplnr
         FOR ALL ENTRIES IN @lt_notif_data
         WHERE q~qmnum = @lt_notif_data-qmnum
              AND ix~spras = @l_alt_spras.
    ENDIF.

*   get licence plate from fleet
    SELECT equi~equnr, fleet~license_num
      INTO TABLE @DATA(lt_fleet)
      FROM equi AS equi
      LEFT OUTER JOIN fleet AS fleet ON fleet~objnr = equi~objnr
      FOR ALL ENTRIES IN @lt_notif_data
        WHERE equi~equnr = @lt_notif_data-equnr.


    LOOP AT lt_notif_data ASSIGNING <fs_notif_data>.

*>>  Status
**>> status
      READ TABLE lt_notifs_status_out INTO DATA(ls_notifs_status_out)
        WITH KEY qmnum = <fs_notif_data>-qmnum.
      IF sy-subrc EQ 0.
        <fs_notif_data>-status = ls_notifs_status_out-status.
        <fs_notif_data>-status_proc = ls_notifs_status_out-status_proc.


        READ TABLE lt_status_txt INTO DATA(ls_status_txt)
          WITH KEY istat = <fs_notif_data>-status.
        <fs_notif_data>-status_txt = ls_status_txt-txt30.

*>>  Equipment
        READ TABLE lt_eqkt INTO DATA(ls_eqkt) WITH KEY equnr = <fs_notif_data>-equnr.
        <fs_notif_data>-eqktx = ls_eqkt-eqktx.

*>>  Functional Location and it's description
        READ TABLE lt_func_loc INTO DATA(ls_func_loc) WITH KEY qmnum = <fs_notif_data>-qmnum.
        IF sy-subrc = 0.
          <fs_notif_data>-func_loc = ls_func_loc-tplnr.
          <fs_notif_data>-func_loc_tx = ls_func_loc-pltxt.
        ENDIF.

        IF <fs_notif_data>-qmart IN ra_notif_type_pm.
          <fs_notif_data>-serv_type = 'PM'.
        ELSEIF <fs_notif_data>-qmart IN ra_notif_type_cs.
          <fs_notif_data>-serv_type = 'CS'.
        ENDIF.


*       CFB 17.10.2018 - Get License Plate from fleet
        IF <fs_notif_data> IS ASSIGNED.
          READ TABLE lt_fleet INTO DATA(ls_fleet) WITH KEY equnr = <fs_notif_data>-equnr.
          IF sy-subrc = 0.
            <fs_notif_data>-license_num = ls_fleet-license_num.
          ENDIF.
        ENDIF.

      ELSE.
        DELETE lt_notif_data WHERE qmnum = <fs_notif_data>-qmnum.
      ENDIF.

      CLEAR: ls_status_txt, ls_eqkt, ls_func_loc.





    ENDLOOP.

    MOVE-CORRESPONDING lt_notif_data TO et_notifications.

*>> Sort Table
    LOOP AT et_notifications ASSIGNING <fs_notifications>
      WHERE aufnr IS NOT INITIAL.

      APPEND <fs_notifications> TO lt_notifications_aux.
    ENDLOOP.

    DELETE et_notifications WHERE aufnr NE space.

    SORT et_notifications BY breakdown DESCENDING qmnum ASCENDING.

    SORT lt_notifications_aux BY breakdown DESCENDING qmnum ASCENDING.
    APPEND LINES OF lt_notifications_aux TO et_notifications.

    DELETE ADJACENT DUPLICATES FROM et_notifications COMPARING qmnum.

*>>  Only return Orders with functional location filled
    IF is_filters-stat_func_loc EQ abap_true.

      DELETE et_notifications WHERE func_loc IS INITIAL.

    ENDIF.

  ENDMETHOD.


  METHOD get_notifs_status.

*** VERSION 2 - FOR ALL ENTRIES

    "STRUCTURES
    DATA: ls_notif         TYPE zabsf_pm_notifs_status_s.

    "RANGES
    DATA: ls_qmnum          TYPE rsis_s_range,
          lr_qmnum          TYPE rsis_t_range,
          ra_istat_default  TYPE RANGE OF j_status,
          ra_istat_blocked  TYPE RANGE OF j_status,
          ra_istat_closed   TYPE RANGE OF j_status,
          ra_exclude_closed TYPE RANGE OF j_status,
          ra_istat_proc     TYPE RANGE OF j_status,
          ra_exclude_proc   TYPE RANGE OF j_status,
          ra_istat_open     TYPE RANGE OF j_status,
          ra_exclude_open   TYPE RANGE OF j_status.

    "INTERNAL TABLES
    DATA: lt_notifs_others TYPE zabsf_pm_notifs_status_t.



*>> get system status in parametrization table
    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_werks
        i_parameter = 'ISTAT_NOTIF_CLOSED'
      IMPORTING
        et_range    = ra_istat_closed.

    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_werks
        i_parameter = 'ISTAT_NOTIF_PROC'
      IMPORTING
        et_range    = ra_istat_proc.

    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_werks
        i_parameter = 'ISTAT_NOTIF_OPEN'
      IMPORTING
        et_range    = ra_istat_open.


*>> Get Status Code Text
    SELECT SINGLE parva
          FROM zabsf_pm_param
          INTO @DATA(lv_stat_conc)
         WHERE werks = @i_werks
           AND parid = 'STAT_COD_CLOSED'.

    SELECT SINGLE parva
          FROM zabsf_pm_param
          INTO @DATA(lv_stat_proc)
         WHERE werks = @i_werks
           AND parid = 'STAT_COD_PROC'.

    SELECT SINGLE parva
          FROM zabsf_pm_param
          INTO @DATA(lv_stat_open)
         WHERE werks = @i_werks
           AND parid = 'STAT_COD_OPEN'.

    SELECT SINGLE parva
          FROM zabsf_pm_param
          INTO @DATA(lv_stat_other)
         WHERE werks = @i_werks
           AND parid = 'STAT_COD_OTHER'.


*--------------------------------------------
*--------------------------------------------
*        Get Orders STATUS
*--------------------------------------------
*--------------------------------------------

** CLOSED
    IF i_stat_closed = abap_true.
      "GET Notifications Info - CLOSED
      SELECT qmel~qmnum  AS qmnum,
             jest~stat   AS status
      INTO CORRESPONDING FIELDS OF TABLE @et_notifs_list
      FROM qmel AS qmel
       INNER JOIN jest AS jest ON jest~objnr = qmel~objnr
      FOR ALL ENTRIES IN @it_notifs_list
      WHERE qmel~qmnum = @it_notifs_list-qmnum
        AND jest~stat  IN @ra_istat_closed
        AND jest~inact EQ @abap_false.

      CLEAR ls_notif.
      ls_notif-status_proc = lv_stat_conc.
      MODIFY et_notifs_list FROM ls_notif TRANSPORTING status_proc
       WHERE status_proc IS INITIAL.

    ENDIF.


** PROCESSING
    IF i_stat_processing = abap_true.
      "GET Notifications Status - PROCESSING
      SELECT qmel~qmnum  AS qmnum,
               jest~stat   AS status
        APPENDING CORRESPONDING FIELDS OF TABLE @et_notifs_list
        FROM qmel AS qmel
         INNER JOIN jest AS jest ON jest~objnr = qmel~objnr
        FOR ALL ENTRIES IN @it_notifs_list
        WHERE qmel~qmnum = @it_notifs_list-qmnum
          AND jest~stat IN @ra_istat_proc
          AND jest~inact EQ @space
          AND NOT EXISTS ( SELECT * FROM jest
                              WHERE jest~objnr = qmel~objnr
                                AND jest~stat IN @ra_istat_closed
                                AND jest~inact EQ @space ).

      CLEAR ls_notif.
      ls_notif-status_proc = lv_stat_proc.
      MODIFY et_notifs_list FROM ls_notif TRANSPORTING status_proc
       WHERE status_proc IS INITIAL.

    ENDIF.

** OPEN
    IF i_stat_open = abap_true.
      "GET Orders Status - OPEN
      SELECT qmel~qmnum  AS qmnum,
               jest~stat   AS status
        APPENDING CORRESPONDING FIELDS OF TABLE @et_notifs_list
        FROM qmel AS qmel
         INNER JOIN jest AS jest ON jest~objnr = qmel~objnr
        FOR ALL ENTRIES IN @it_notifs_list
        WHERE qmel~qmnum = @it_notifs_list-qmnum
          AND jest~stat IN @ra_istat_open
          AND jest~inact EQ @space
          AND NOT EXISTS ( SELECT * FROM jest
                              WHERE jest~objnr = qmel~objnr
                                AND ( jest~stat IN @ra_istat_proc
                                   OR jest~stat IN @ra_istat_closed )
                                AND jest~inact EQ @space ).


      CLEAR ls_notif.
      ls_notif-status_proc = lv_stat_open.
      MODIFY et_notifs_list FROM ls_notif TRANSPORTING status_proc
       WHERE status_proc IS INITIAL.

    ENDIF.

    IF et_notifs_list IS NOT INITIAL.
      SORT et_notifs_list BY qmnum.
      DELETE ADJACENT DUPLICATES FROM et_notifs_list COMPARING qmnum.
    ENDIF.


** OTHERS
    IF i_stat_others = abap_true.
      "GET Orders Status - OTHERS
      SELECT qmel~qmnum  AS qmnum,
               jest~stat   AS status
        INTO CORRESPONDING FIELDS OF TABLE @lt_notifs_others
        FROM qmel AS qmel
         INNER JOIN jest AS jest ON jest~objnr = qmel~objnr
        FOR ALL ENTRIES IN @it_notifs_list
        WHERE qmel~qmnum = @it_notifs_list-qmnum
          AND jest~inact EQ @space
          AND NOT EXISTS ( SELECT * FROM jest
                              WHERE jest~objnr = qmel~objnr
                                AND ( jest~stat IN @ra_istat_open
                                   OR jest~stat IN @ra_istat_proc
                                   OR jest~stat IN @ra_istat_closed )
                                AND jest~inact EQ @space ).

      SORT lt_notifs_others BY qmnum DESCENDING status DESCENDING.
      DELETE ADJACENT DUPLICATES FROM lt_notifs_others COMPARING qmnum.

      CLEAR ls_notif.
      ls_notif-status_proc = lv_stat_other.
      MODIFY lt_notifs_others FROM ls_notif TRANSPORTING status_proc
       WHERE status_proc IS INITIAL.

      APPEND LINES OF lt_notifs_others TO et_notifs_list.
    ENDIF.


*** VERSION 1 - RANGE

*    "STRUCTURES
*    DATA: ls_notif         TYPE ZABSF_PM_notifs_status_s.
*
*    "RANGES
*    DATA: ls_qmnum          TYPE rsis_s_range,
*          lr_qmnum          TYPE rsis_t_range,
*          ra_istat_default  TYPE RANGE OF j_status,
*          ra_istat_blocked  TYPE RANGE OF j_status,
*          ra_istat_closed   TYPE RANGE OF j_status,
*          ra_exclude_closed TYPE RANGE OF j_status,
*          ra_istat_proc     TYPE RANGE OF j_status,
*          ra_exclude_proc   TYPE RANGE OF j_status,
*          ra_istat_open     TYPE RANGE OF j_status,
*          ra_exclude_open   TYPE RANGE OF j_status.
*
*    "INTERNAL TABLES
*    DATA: lt_notifs_others TYPE ZABSF_PM_notifs_status_t.
*
*
*
**>> get system status in parametrization table
*    CALL METHOD get_parameter
*      EXPORTING
*        i_werks     = i_werks
*        i_parameter = 'ISTAT_NOTIF_CLOSED'
*      IMPORTING
*        et_range    = ra_istat_closed.
*
*    CALL METHOD get_parameter
*      EXPORTING
*        i_werks     = i_werks
*        i_parameter = 'ISTAT_NOTIF_PROC'
*      IMPORTING
*        et_range    = ra_istat_proc.
*
*    CALL METHOD get_parameter
*      EXPORTING
*        i_werks     = i_werks
*        i_parameter = 'ISTAT_NOTIF_OPEN'
*      IMPORTING
*        et_range    = ra_istat_open.
*
*
**>> Get Status Code Text
*    SELECT SINGLE parva
*          FROM ZABSF_PM_param
*          INTO @DATA(lv_stat_conc)
*         WHERE werks = @i_werks
*           AND parid = 'STAT_COD_CLOSED'.
*
*    SELECT SINGLE parva
*          FROM ZABSF_PM_param
*          INTO @DATA(lv_stat_proc)
*         WHERE werks = @i_werks
*           AND parid = 'STAT_COD_PROC'.
*
*    SELECT SINGLE parva
*          FROM ZABSF_PM_param
*          INTO @DATA(lv_stat_open)
*         WHERE werks = @i_werks
*           AND parid = 'STAT_COD_OPEN'.
*
*    SELECT SINGLE parva
*          FROM ZABSF_PM_param
*          INTO @DATA(lv_stat_other)
*         WHERE werks = @i_werks
*           AND parid = 'STAT_COD_OTHER'.
*
*
*    LOOP AT it_notifs_list INTO DATA(ls_notifs_list).
*      ls_qmnum-sign = 'I'.
*      ls_qmnum-option = 'EQ'.
*      ls_qmnum-low = ls_notifs_list-qmnum.
*      APPEND ls_qmnum TO lr_qmnum.
*    ENDLOOP.
*
**--------------------------------------------
**--------------------------------------------
**        Get Orders STATUS
**--------------------------------------------
**--------------------------------------------
*
*** CLOSED
*    IF i_stat_closed = abap_true.
*        "GET Notifications Info - CLOSED
*        SELECT qmel~qmnum  AS qmnum,
*               jest~stat   AS status
*        INTO CORRESPONDING FIELDS OF TABLE @et_notifs_list
*        FROM qmel AS qmel
*         INNER JOIN jest AS jest ON jest~objnr = qmel~objnr
*        WHERE qmel~qmnum IN @lr_qmnum
*          AND jest~stat  IN @ra_istat_closed
*          AND jest~inact EQ @abap_false.
*
*        CLEAR ls_notif.
*        ls_notif-status_proc = lv_stat_conc.
*        MODIFY et_notifs_list FROM ls_notif TRANSPORTING status_proc
*         WHERE status_proc IS INITIAL.
*
*    ENDIF.
*
*
*** PROCESSING
*    IF i_stat_processing = abap_true.
*      "GET Notifications Status - PROCESSING
*      SELECT qmel~qmnum  AS qmnum,
*               jest~stat   AS status
*        APPENDING CORRESPONDING FIELDS OF TABLE @et_notifs_list
*        FROM qmel AS qmel
*         INNER JOIN jest AS jest ON jest~objnr = qmel~objnr
*        WHERE qmel~qmnum IN @lr_qmnum
*          AND jest~stat IN @ra_istat_proc
*          AND jest~inact EQ @space
*          AND NOT EXISTS ( SELECT * FROM jest
*                              WHERE jest~objnr = qmel~objnr
*                                AND jest~stat IN @ra_istat_closed
*                                AND jest~inact EQ @space ).
*
*        CLEAR ls_notif.
*        ls_notif-status_proc = lv_stat_proc.
*        MODIFY et_notifs_list FROM ls_notif TRANSPORTING status_proc
*         WHERE status_proc IS INITIAL.
*
*    ENDIF.
*
*** OPEN
*    IF i_stat_open = abap_true.
*      "GET Orders Status - OPEN
*      SELECT qmel~qmnum  AS qmnum,
*               jest~stat   AS status
*        APPENDING CORRESPONDING FIELDS OF TABLE @et_notifs_list
*        FROM qmel AS qmel
*         INNER JOIN jest AS jest ON jest~objnr = qmel~objnr
*        WHERE qmel~qmnum IN @lr_qmnum
*          AND jest~stat IN @ra_istat_open
*          AND jest~inact EQ @space
*          AND NOT EXISTS ( SELECT * FROM jest
*                              WHERE jest~objnr = qmel~objnr
*                                AND ( jest~stat IN @ra_istat_proc
*                                   OR jest~stat IN @ra_istat_closed )
*                                AND jest~inact EQ @space ).
*
*
*        CLEAR ls_notif.
*        ls_notif-status_proc = lv_stat_open.
*        MODIFY et_notifs_list FROM ls_notif TRANSPORTING status_proc
*         WHERE status_proc IS INITIAL.
*
*    ENDIF.
*
*    IF et_notifs_list IS NOT INITIAL.
*      SORT et_notifs_list BY qmnum.
*      DELETE ADJACENT DUPLICATES FROM et_notifs_list COMPARING qmnum.
*    ENDIF.
*
*
*** OTHERS
*    IF i_stat_others = abap_true.
*      "GET Orders Status - OTHERS
*      SELECT qmel~qmnum  AS qmnum,
*               jest~stat   AS status
*        INTO CORRESPONDING FIELDS OF TABLE @lt_notifs_others
*        FROM qmel AS qmel
*         INNER JOIN jest AS jest ON jest~objnr = qmel~objnr
*        WHERE qmel~qmnum IN @lr_qmnum
*          AND jest~inact EQ @space
*          AND NOT EXISTS ( SELECT * FROM jest
*                              WHERE jest~objnr = qmel~objnr
*                                AND ( jest~stat IN @ra_istat_open
*                                   OR jest~stat IN @ra_istat_proc
*                                   OR jest~stat IN @ra_istat_closed )
*                                AND jest~inact EQ @space ).
*
*      SORT lt_notifs_others BY qmnum DESCENDING status DESCENDING.
*      DELETE ADJACENT DUPLICATES FROM lt_notifs_others COMPARING qmnum.
*
*      CLEAR ls_notif.
*      ls_notif-status_proc = lv_stat_other.
*      MODIFY lt_notifs_others FROM ls_notif TRANSPORTING status_proc
*       WHERE status_proc IS INITIAL.
*
*      APPEND LINES OF lt_notifs_others TO et_notifs_list.
*    ENDIF.

  ENDMETHOD.


  METHOD get_notif_causes.

    DATA: ra_urkat TYPE RANGE OF urkat,
          ra_urgrp TYPE RANGE OF urgrp.

    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_werks
        i_parameter = 'URKAT_PM'
      IMPORTING
        et_range    = ra_urkat.

    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_werks
        i_parameter = 'URGRP_PM'
      IMPORTING
        et_range    = ra_urgrp.

    SELECT qpgr~katalogart, qpgr~codegruppe,qpgt~kurztext
      INTO TABLE @et_causes
      FROM qpgr INNER JOIN qpgt ON  qpgt~katalogart = qpgr~katalogart
                                AND qpgt~codegruppe = qpgr~codegruppe
                                AND qpgt~sprache    = @sy-langu
     WHERE qpgr~katalogart IN @ra_urkat
       AND qpgr~codegruppe IN @ra_urgrp.

    IF et_causes[] IS INITIAL.
      SELECT SINGLE spras
        FROM zabsf_languages
        INTO @DATA(lv_alt_spras)
       WHERE werks      EQ @i_werks
         AND is_default EQ @abap_true.

      IF sy-subrc = 0 AND lv_alt_spras <> sy-langu.
        SELECT qpgr~katalogart, qpgr~codegruppe,qpgt~kurztext
          INTO TABLE @et_causes
          FROM qpgr INNER JOIN qpgt ON  qpgt~katalogart = qpgr~katalogart
                                    AND qpgt~codegruppe = qpgr~codegruppe
                                    AND qpgt~sprache    = @lv_alt_spras
         WHERE qpgr~katalogart IN @ra_urkat
           AND qpgr~codegruppe IN @ra_urgrp.

      ENDIF.

    ENDIF.

    CHECK et_causes[] IS NOT INITIAL.

    SELECT qpcd~katalogart, qpcd~codegruppe, qpcd~code,qpct~kurztext
      INTO TABLE @et_subcauses
      FROM qpcd INNER JOIN qpct ON  qpct~katalogart = qpcd~katalogart
                                AND qpct~codegruppe = qpcd~codegruppe
                                AND qpct~code       = qpcd~code
                                AND qpct~version    = qpcd~version
                                AND qpct~sprache    = @sy-langu
      FOR ALL ENTRIES IN @et_causes
     WHERE qpcd~katalogart = @et_causes-katalogart
       AND qpcd~codegruppe = @et_causes-codegruppe.

    IF et_subcauses[] IS INITIAL.
      IF lv_alt_spras IS INITIAL.
        SELECT SINGLE spras
          FROM zabsf_languages
          INTO @lv_alt_spras
         WHERE werks      EQ @i_werks
           AND is_default EQ @abap_true.
      ENDIF.
      IF sy-subrc = 0 AND lv_alt_spras <> sy-langu.
        SELECT qpcd~katalogart, qpcd~codegruppe, qpcd~code,qpct~kurztext
          INTO TABLE @et_subcauses
          FROM qpcd INNER JOIN qpct ON  qpct~katalogart = qpcd~katalogart
                                    AND qpct~codegruppe = qpcd~codegruppe
                                    AND qpct~code       = qpcd~code
                                    AND qpct~version    = qpcd~version
                                    AND qpct~sprache    = @lv_alt_spras
          FOR ALL ENTRIES IN @et_causes
         WHERE qpcd~katalogart = @et_causes-katalogart
           AND qpcd~codegruppe = @et_causes-codegruppe.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD get_notif_types.

    DATA: ra_aufart     TYPE RANGE OF aufart.

    DATA: ls_service_type TYPE param_id,
          ra_notif_type   TYPE RANGE OF qmart.

    CONCATENATE 'QMART_NOTIF_' i_serv_type INTO ls_service_type.

    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_werks
        i_parameter = ls_service_type
      IMPORTING
        et_range    = ra_notif_type.

    SELECT tq80~qmart, tq80_t~qmartx
      FROM tq80 INNER JOIN tq80_t ON  tq80_t~qmart = tq80~qmart
                                  AND tq80_t~spras = @sy-langu
      INTO TABLE @et_notif_types
*      WHERE tq80~qmtyp EQ '01' AND tq80~klakt EQ 'X'.
      WHERE tq80~qmart IN @ra_notif_type.
*        AND tq80~qmtyp EQ '01'
    "        AND tq80~klakt EQ 'X'.

    IF et_notif_types[] IS INITIAL.
      SELECT SINGLE spras
        FROM zabsf_languages
        INTO @DATA(lv_alt_spras)
       WHERE werks      EQ @i_werks
         AND is_default EQ @abap_true.

      IF sy-subrc = 0 AND lv_alt_spras <> sy-langu.

        SELECT tq80~qmart, tq80_t~qmartx
          FROM tq80 INNER JOIN tq80_t ON  tq80_t~qmart = tq80~qmart
                                      AND tq80_t~spras = @lv_alt_spras
          INTO TABLE @et_notif_types
*          WHERE tq80~qmtyp EQ '01' AND tq80~klakt EQ 'X'.
          WHERE tq80~qmart IN @ra_notif_type.
        "          AND tq80~klakt EQ 'X'.

      ENDIF.

    ENDIF.


  ENDMETHOD.


  METHOD get_operator.
*  Structures
    DATA: ls_operator TYPE zabsf_pm_s_operador.

*  Get operators assign to order PM
    SELECT *
      FROM zabsf_pm_users
      INTO TABLE @DATA(lt_sf_users)
     WHERE werks EQ @werks
       AND aufnr EQ @aufnr.

    IF lt_sf_users[] IS NOT INITIAL.
      LOOP AT lt_sf_users INTO DATA(ls_sf_users).
        CLEAR ls_operator.

        SELECT SINGLE cname FROM pa0002 INTO ls_operator-nome
          WHERE pernr = ls_sf_users-oprid.

        MOVE-CORRESPONDING ls_sf_users TO ls_operator.

        APPEND ls_operator TO operator_tab.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD get_orders_status.

*** VERSION 2 - FOR ALL ENTRIES

    "STRUCTURES
    DATA: ls_orders         TYPE zabsf_pm_orders_status_s.

    "RANGES
    DATA: ls_aufnr          TYPE rsis_s_range,
          lr_aufnr          TYPE rsis_t_range,
          ra_istat_default  TYPE RANGE OF j_status,
          ra_istat_blocked  TYPE RANGE OF j_status,
          ra_istat_closed   TYPE RANGE OF j_status,
          ra_exclude_closed TYPE RANGE OF j_status,
          ra_istat_proc     TYPE RANGE OF j_status,
          ra_exclude_proc   TYPE RANGE OF j_status,
          ra_istat_open     TYPE RANGE OF j_status,
          ra_exclude_open   TYPE RANGE OF j_status.

    "INTERNAL TABLES
    DATA: lt_orders_others TYPE zabsf_pm_orders_status_t.
*          lt_orders_status TYPE ZABSF_PM_orders_status_t.


*>> get system status in parametrization table
    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_werks
        i_parameter = 'ISTAT_BLOCKED'
      IMPORTING
        et_range    = ra_istat_blocked.

    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_werks
        i_parameter = 'ISTAT_CLOSED'
      IMPORTING
        et_range    = ra_istat_closed.

    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_werks
        i_parameter = 'ISTAT_PROC'
      IMPORTING
        et_range    = ra_istat_proc.

    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_werks
        i_parameter = 'ISTAT_OPEN'
      IMPORTING
        et_range    = ra_istat_open.


*>> Get Status Code Text
    SELECT SINGLE parva
          FROM zabsf_pm_param
          INTO @DATA(lv_stat_block)
         WHERE werks = @i_werks
           AND parid = 'STAT_COD_BLOCK'.

    SELECT SINGLE parva
          FROM zabsf_pm_param
          INTO @DATA(lv_stat_conc)
         WHERE werks = @i_werks
           AND parid = 'STAT_COD_CLOSED'.

    SELECT SINGLE parva
          FROM zabsf_pm_param
          INTO @DATA(lv_stat_proc)
         WHERE werks = @i_werks
           AND parid = 'STAT_COD_PROC'.

    SELECT SINGLE parva
          FROM zabsf_pm_param
          INTO @DATA(lv_stat_open)
         WHERE werks = @i_werks
           AND parid = 'STAT_COD_OPEN'.

    SELECT SINGLE parva
          FROM zabsf_pm_param
          INTO @DATA(lv_stat_other)
         WHERE werks = @i_werks
           AND parid = 'STAT_COD_OTHER'.


*--------------------------------------------
*--------------------------------------------
*        Get Orders STATUS
*--------------------------------------------
*--------------------------------------------

** BLOCKED
    IF i_stat_blocked = abap_true.
      "GET Orders Status - BLOCKED
      SELECT aufk~aufnr       AS aufnr,
             jest~stat        AS status
        INTO CORRESPONDING FIELDS OF TABLE @et_orders_list
        FROM aufk
         INNER JOIN jest ON jest~objnr = aufk~objnr
        FOR ALL ENTRIES IN @it_orders_list
        WHERE aufk~aufnr = @it_orders_list-aufnr
          AND jest~stat IN @ra_istat_blocked
          AND jest~inact EQ @space.

      CLEAR ls_orders.
      ls_orders-status_proc = lv_stat_block.
      MODIFY et_orders_list FROM ls_orders TRANSPORTING status_proc
       WHERE status_proc IS INITIAL.

    ENDIF.

** CLOSED
    IF i_stat_closed = abap_true.
      "GET Orders Status - CLOSED
      SELECT aufk~aufnr       AS aufnr,
             jest~stat        AS status
        APPENDING CORRESPONDING FIELDS OF TABLE @et_orders_list
        FROM aufk
         INNER JOIN jest ON jest~objnr = aufk~objnr
        FOR ALL ENTRIES IN @it_orders_list
        WHERE aufk~aufnr = @it_orders_list-aufnr
          AND jest~stat IN @ra_istat_closed
          AND jest~inact EQ @space
          AND NOT EXISTS ( SELECT * FROM jest
                                WHERE jest~objnr = aufk~objnr
                                  AND jest~stat IN @ra_istat_blocked
                                  AND jest~inact EQ @space ).

      CLEAR ls_orders.
      ls_orders-status_proc = lv_stat_conc.
      MODIFY et_orders_list FROM ls_orders TRANSPORTING status_proc
       WHERE status_proc IS INITIAL.

    ENDIF.

** PROCESSING
    IF i_stat_processing = abap_true.
      "GET Orders Status - PROCESSING
      SELECT aufk~aufnr       AS aufnr,
             jest~stat        AS status
        APPENDING CORRESPONDING FIELDS OF TABLE @et_orders_list
        FROM aufk
         INNER JOIN jest ON jest~objnr = aufk~objnr
        FOR ALL ENTRIES IN @it_orders_list
        WHERE aufk~aufnr = @it_orders_list-aufnr
          AND jest~stat IN @ra_istat_proc
          AND jest~inact EQ @space
          AND NOT EXISTS ( SELECT * FROM jest
                              WHERE jest~objnr = aufk~objnr
                                AND ( jest~stat IN @ra_istat_blocked
                                  OR jest~stat IN @ra_istat_closed )
                                AND jest~inact EQ @space ).

      CLEAR ls_orders.
      ls_orders-status_proc = lv_stat_proc.
      MODIFY et_orders_list FROM ls_orders TRANSPORTING status_proc
       WHERE status_proc IS INITIAL.

    ENDIF.

** OPEN
    IF i_stat_open = abap_true.
      "GET Orders Status - OPEN
      SELECT aufk~aufnr       AS aufnr,
             jest~stat        AS status
        APPENDING CORRESPONDING FIELDS OF TABLE @et_orders_list
        FROM aufk
         INNER JOIN jest ON jest~objnr = aufk~objnr
        FOR ALL ENTRIES IN @it_orders_list
        WHERE aufk~aufnr = @it_orders_list-aufnr
          AND jest~stat IN @ra_istat_open
          AND jest~inact EQ @space
          AND NOT EXISTS ( SELECT * FROM jest
                              WHERE jest~objnr = aufk~objnr
                                AND ( jest~stat IN @ra_istat_blocked
                                   OR jest~stat IN @ra_istat_proc
                                   OR jest~stat IN @ra_istat_closed )
                                AND jest~inact EQ @space ).


      CLEAR ls_orders.
      ls_orders-status_proc = lv_stat_open.
      MODIFY et_orders_list FROM ls_orders TRANSPORTING status_proc
       WHERE status_proc IS INITIAL.

    ENDIF.

    IF et_orders_list IS NOT INITIAL.
      SORT et_orders_list BY aufnr.
      DELETE ADJACENT DUPLICATES FROM et_orders_list COMPARING aufnr.
    ENDIF.


** OTHERS
    IF i_stat_others = abap_true.
      "GET Orders Status - OTHERS
      SELECT aufk~aufnr       AS aufnr,
             jest~stat        AS status
        INTO CORRESPONDING FIELDS OF TABLE @lt_orders_others
        FROM aufk
         INNER JOIN jest ON jest~objnr = aufk~objnr
        FOR ALL ENTRIES IN @it_orders_list
        WHERE aufk~aufnr = @it_orders_list-aufnr
          AND jest~inact EQ @space
          AND NOT EXISTS ( SELECT * FROM jest
                              WHERE jest~objnr = aufk~objnr
                                AND ( jest~stat IN @ra_istat_blocked
                                   OR jest~stat IN @ra_istat_open
                                   OR jest~stat IN @ra_istat_proc
                                   OR jest~stat IN @ra_istat_closed )
                                AND jest~inact EQ @space ).

      SORT lt_orders_others BY aufnr DESCENDING status DESCENDING.
      DELETE ADJACENT DUPLICATES FROM lt_orders_others COMPARING aufnr.

      CLEAR ls_orders.
      ls_orders-status_proc = lv_stat_other.
      MODIFY lt_orders_others FROM ls_orders TRANSPORTING status_proc
       WHERE status_proc IS INITIAL.

      APPEND LINES OF lt_orders_others TO et_orders_list.
    ENDIF.


*** VERSION 1 - RANGE

*    "STRUCTURES
*    DATA: ls_orders         TYPE ZABSF_PM_orders_status_s.
*
*    "RANGES
*    DATA: ls_aufnr          TYPE rsis_s_range,
*          lr_aufnr          TYPE rsis_t_range,
*          ra_istat_default  TYPE RANGE OF j_status,
*          ra_istat_blocked  TYPE RANGE OF j_status,
*          ra_istat_closed   TYPE RANGE OF j_status,
*          ra_exclude_closed TYPE RANGE OF j_status,
*          ra_istat_proc     TYPE RANGE OF j_status,
*          ra_exclude_proc   TYPE RANGE OF j_status,
*          ra_istat_open     TYPE RANGE OF j_status,
*          ra_exclude_open   TYPE RANGE OF j_status.
*
*    "INTERNAL TABLES
*    DATA: lt_orders_others TYPE ZABSF_PM_orders_status_t.
**          lt_orders_status TYPE ZABSF_PM_orders_status_t.
*
*
**>> get system status in parametrization table
*    CALL METHOD get_parameter
*      EXPORTING
*        i_werks     = i_werks
*        i_parameter = 'ISTAT_BLOCKED'
*      IMPORTING
*        et_range    = ra_istat_blocked.
*
*    CALL METHOD get_parameter
*      EXPORTING
*        i_werks     = i_werks
*        i_parameter = 'ISTAT_CLOSED'
*      IMPORTING
*        et_range    = ra_istat_closed.
*
*    CALL METHOD get_parameter
*      EXPORTING
*        i_werks     = i_werks
*        i_parameter = 'ISTAT_PROC'
*      IMPORTING
*        et_range    = ra_istat_proc.
*
*    CALL METHOD get_parameter
*      EXPORTING
*        i_werks     = i_werks
*        i_parameter = 'ISTAT_OPEN'
*      IMPORTING
*        et_range    = ra_istat_open.
*
*
**>> Get Status Code Text
*    SELECT SINGLE parva
*          FROM ZABSF_PM_param
*          INTO @DATA(lv_stat_block)
*         WHERE werks = @i_werks
*           AND parid = 'STAT_COD_BLOCK'.
*
*    SELECT SINGLE parva
*          FROM ZABSF_PM_param
*          INTO @DATA(lv_stat_conc)
*         WHERE werks = @i_werks
*           AND parid = 'STAT_COD_CLOSED'.
*
*    SELECT SINGLE parva
*          FROM ZABSF_PM_param
*          INTO @DATA(lv_stat_proc)
*         WHERE werks = @i_werks
*           AND parid = 'STAT_COD_PROC'.
*
*    SELECT SINGLE parva
*          FROM ZABSF_PM_param
*          INTO @DATA(lv_stat_open)
*         WHERE werks = @i_werks
*           AND parid = 'STAT_COD_OPEN'.
*
*    SELECT SINGLE parva
*          FROM ZABSF_PM_param
*          INTO @DATA(lv_stat_other)
*         WHERE werks = @i_werks
*           AND parid = 'STAT_COD_OTHER'.
*
*
*    LOOP AT it_orders_list INTO DATA(ls_orders_list).
*      ls_aufnr-sign = 'I'.
*      ls_aufnr-option = 'EQ'.
*      ls_aufnr-low = ls_orders_list-aufnr.
*      APPEND ls_aufnr TO lr_aufnr.
*    ENDLOOP.
*
**--------------------------------------------
**--------------------------------------------
**        Get Orders STATUS
**--------------------------------------------
**--------------------------------------------
*
*** BLOCKED
*    IF i_stat_blocked = abap_true.
*      "GET Orders Status - BLOCKED
*      SELECT aufk~aufnr       AS aufnr,
*             jest~stat        AS status
*        INTO CORRESPONDING FIELDS OF TABLE @et_orders_list
*        FROM aufk
*         INNER JOIN jest ON jest~objnr = aufk~objnr
*        WHERE aufk~aufnr IN @lr_aufnr
*          AND jest~stat IN @ra_istat_blocked
*          AND jest~inact EQ @space.
*
*      CLEAR ls_orders.
*      ls_orders-status_proc = lv_stat_block.
*      MODIFY et_orders_list FROM ls_orders TRANSPORTING status_proc
*       WHERE status_proc IS INITIAL.
*
*    ENDIF.
*
*** CLOSED
*    IF i_stat_closed = abap_true.
*      "GET Orders Status - CLOSED
*      SELECT aufk~aufnr       AS aufnr,
*             jest~stat        AS status
*        APPENDING CORRESPONDING FIELDS OF TABLE @et_orders_list
*        FROM aufk
*         INNER JOIN jest ON jest~objnr = aufk~objnr
*        WHERE aufk~aufnr IN @lr_aufnr
*          AND jest~stat IN @ra_istat_closed
*          AND jest~inact EQ @space
*          AND NOT EXISTS ( SELECT * FROM jest
*                                WHERE jest~objnr = aufk~objnr
*                                  AND jest~stat IN @ra_istat_blocked
*                                  AND jest~inact EQ @space ).
*
*      CLEAR ls_orders.
*      ls_orders-status_proc = lv_stat_conc.
*      MODIFY et_orders_list FROM ls_orders TRANSPORTING status_proc
*       WHERE status_proc IS INITIAL.
*
*    ENDIF.
*
*** PROCESSING
*    IF i_stat_processing = abap_true.
*      "GET Orders Status - PROCESSING
*      SELECT aufk~aufnr       AS aufnr,
*             jest~stat        AS status
*        APPENDING CORRESPONDING FIELDS OF TABLE @et_orders_list
*        FROM aufk
*         INNER JOIN jest ON jest~objnr = aufk~objnr
*        WHERE aufk~aufnr IN @lr_aufnr
*          AND jest~stat IN @ra_istat_proc
*          AND jest~inact EQ @space
*          AND NOT EXISTS ( SELECT * FROM jest
*                              WHERE jest~objnr = aufk~objnr
*                                AND ( jest~stat IN @ra_istat_blocked
*                                  OR jest~stat IN @ra_istat_closed )
*                                AND jest~inact EQ @space ).
*
*      CLEAR ls_orders.
*      ls_orders-status_proc = lv_stat_proc.
*      MODIFY et_orders_list FROM ls_orders TRANSPORTING status_proc
*       WHERE status_proc IS INITIAL.
*
*    ENDIF.
*
*** OPEN
*    IF i_stat_open = abap_true.
*      "GET Orders Status - OPEN
*      SELECT aufk~aufnr       AS aufnr,
*             jest~stat        AS status
*        APPENDING CORRESPONDING FIELDS OF TABLE @et_orders_list
*        FROM aufk
*         INNER JOIN jest ON jest~objnr = aufk~objnr
*        WHERE aufk~aufnr IN @lr_aufnr
*          AND jest~stat IN @ra_istat_open
*          AND jest~inact EQ @space
*          AND NOT EXISTS ( SELECT * FROM jest
*                              WHERE jest~objnr = aufk~objnr
*                                AND ( jest~stat IN @ra_istat_blocked
*                                   OR jest~stat IN @ra_istat_proc
*                                   OR jest~stat IN @ra_istat_closed )
*                                AND jest~inact EQ @space ).
*
*
*      CLEAR ls_orders.
*      ls_orders-status_proc = lv_stat_open.
*      MODIFY et_orders_list FROM ls_orders TRANSPORTING status_proc
*       WHERE status_proc IS INITIAL.
*
*    ENDIF.
*
*    IF et_orders_list IS NOT INITIAL.
*      SORT et_orders_list BY aufnr.
*      DELETE ADJACENT DUPLICATES FROM et_orders_list COMPARING aufnr.
*    ENDIF.
*
*
*** OTHERS
*    IF i_stat_others = abap_true.
*      "GET Orders Status - OTHERS
*      SELECT aufk~aufnr       AS aufnr,
*             jest~stat        AS status
*        INTO CORRESPONDING FIELDS OF TABLE @lt_orders_others
*        FROM aufk
*         INNER JOIN jest ON jest~objnr = aufk~objnr
*        WHERE aufk~aufnr IN @lr_aufnr
*          AND jest~inact EQ @space
*          AND NOT EXISTS ( SELECT * FROM jest
*                              WHERE jest~objnr = aufk~objnr
*                                AND ( jest~stat IN @ra_istat_blocked
*                                   OR jest~stat IN @ra_istat_open
*                                   OR jest~stat IN @ra_istat_proc
*                                   OR jest~stat IN @ra_istat_closed )
*                                AND jest~inact EQ @space ).
*
*      SORT lt_orders_others BY aufnr DESCENDING status DESCENDING.
*      DELETE ADJACENT DUPLICATES FROM lt_orders_others COMPARING aufnr.
*
*      CLEAR ls_orders.
*      ls_orders-status_proc = lv_stat_other.
*      MODIFY lt_orders_others FROM ls_orders TRANSPORTING status_proc
*       WHERE status_proc IS INITIAL.
*
*      APPEND LINES OF lt_orders_others TO et_orders_list.
*    ENDIF.


  ENDMETHOD.


  METHOD get_orders_to_associate.
*>>>DGG 19/07/2017 - Associate Order to Notification
*     - ordem ter o mesmo main workcenter da notificaçao
*     - ordem ter o mesmo technical object da notificaçao
*     - ordem ter de estar liberada (=I0002)
*>>>CFB 02/08/2017 - Guarantee that only orders PM are shown if notification is PM
*                  - orders CS if Notification is CS

    DATA : ra_auart TYPE rsis_t_range,
           ls_auart TYPE rsis_s_range.

    DATA : ra_cs_notif_type TYPE RANGE OF qmart,
           ra_pm_notif_type TYPE RANGE OF qmart.

    DATA : ra_aufnr TYPE rsis_t_range,
           ls_aufnr TYPE rsis_s_range.

    DATA: lv_aufnr TYPE aufnr.

    DATA: ra_istat_proc    TYPE RANGE OF j_status.

    DATA lv_qmnum TYPE qmnum.


*>> get default language
    SELECT SINGLE spras
      FROM zabsf_languages
      INTO (@DATA(l_alt_spras))
     WHERE werks      EQ @i_inputobj-werks
       AND is_default EQ @abap_true.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = i_aufnr
      IMPORTING
        output = lv_aufnr.

    ls_aufnr-sign = 'I'.
    ls_aufnr-option = 'CP'.
    CONCATENATE '*' lv_aufnr '*' INTO ls_aufnr-low.
    APPEND ls_aufnr TO ra_aufnr.

    SELECT qmnum
      INTO @DATA(lv_hasqnum)
      FROM qmel
      WHERE qmnum = @i_qmnum.
    ENDSELECT.

    IF lv_hasqnum IS INITIAL.
      CLEAR et_orders.
    ELSE.

*  get notification Type
      SELECT SINGLE qmel~qmart
        INTO @DATA(lv_qmart)
        FROM qmel
        WHERE qmel~qmnum = @i_qmnum.

*>>>>> with notification type we can deternine if PM or CS and show order according

      DATA : lv_service_type  TYPE char2.

      CALL METHOD get_parameter
        EXPORTING
          i_werks     = i_inputobj-werks
          i_parameter = 'QMART_NOTIF_CS'
        IMPORTING
          et_range    = ra_cs_notif_type.

      CALL METHOD get_parameter
        EXPORTING
          i_werks     = i_inputobj-werks
          i_parameter = 'QMART_NOTIF_PM'
        IMPORTING
          et_range    = ra_pm_notif_type.

      IF lv_qmart IN ra_cs_notif_type.
        lv_service_type = 'CS'.
      ELSEIF lv_qmart IN ra_pm_notif_type.
        lv_service_type = 'PM'.

      ENDIF.

      DATA: lv_param TYPE param_id.

      CONCATENATE 'AUFART_' lv_service_type '_CREATION' INTO lv_param.

      CALL METHOD get_parameter
        EXPORTING
          i_werks     = i_inputobj-werks
          i_parameter = lv_param
        IMPORTING
          et_range    = ra_auart.

      IF ra_auart IS INITIAL.
        "send message informing that there aren´t any records
        CALL METHOD zcl_absf_pm=>add_message
          EXPORTING
            msgty      = 'S'
            msgno      = '035'
            msgv1      = i_qmnum
          CHANGING
            return_tab = et_return_tab.

        RETURN.
      ENDIF.



*<<<<<< with notification type we can deternine if PM or CS and show order according

      SELECT SINGLE crhd~arbpl
        INTO @DATA(lv_workc)
        FROM qmel
        INNER JOIN crhd ON crhd~objty = qmel~crobjty
                      AND crhd~objid = qmel~arbpl
        WHERE qmel~qmnum = @i_qmnum.

      SELECT SINGLE equnr
        INTO @DATA(lv_equnr)
        FROM qmih
        WHERE qmnum = @i_qmnum.

      SELECT SINGLE iloa~tplnr
        INTO @DATA(lv_tplnr)
        FROM iloa
          INNER JOIN qmih ON qmih~iloan = iloa~iloan
        WHERE qmih~qmnum = @i_qmnum.

      CALL METHOD get_parameter
        EXPORTING
          i_werks     = i_inputobj-werks
          i_parameter = 'ISTAT_OPEN'
*         Ticket 9000015984
*         i_parameter = 'ISTAT_PROC'
        IMPORTING
          et_range    = ra_istat_proc.

      SELECT ord~erdat, ord~aufnr, ord~ktext, ord~astnr
        INTO CORRESPONDING FIELDS OF TABLE @et_orders
        FROM aufk AS ord
          INNER JOIN jest                 ON jest~objnr = ord~objnr
          INNER JOIN afih                 AS ord_header ON ord~aufnr = ord_header~aufnr
"         LEFT OUTER JOIN iloa            AS loc ON ord_header~iloan = loc~iloan
* Garantee that notification PM gets orders PM and CS gets CS
         WHERE ord~aufnr IN @ra_aufnr

* CFB 08.10.2018 get orders with the same workcenter as the user conf in shopfloor
          AND ord~werks = @i_inputobj-werks

          AND ord~auart IN @ra_auart
* Same Main WorkCentre as the Notification      removed as requeted by LDG
"         AND ord~vaplz EQ @lv_workc

* Order is in proc (=I0002) and active
          AND jest~stat IN @ra_istat_proc
          AND jest~inact EQ @space.

* Same Technical Object as the Notification   removed as requeted by LDG
      "          AND ord_header~equnr EQ @lv_equnr
      "          AND loc~tplnr EQ @lv_tplnr.

      SORT et_orders BY aufnr.
      DELETE ADJACENT DUPLICATES FROM et_orders COMPARING aufnr.

      IF et_orders IS INITIAL.

        "send message informing that there aren´t any records
        CALL METHOD zcl_absf_pm=>add_message
          EXPORTING
            msgty      = 'S'
            msgno      = '035'
            msgv1      = i_qmnum
          CHANGING
            return_tab = et_return_tab.
      ENDIF.

    ENDIF.
  ENDMETHOD.


  method get_order_detail.

    data: ls_stages like line of et_stages,
          lv_auart  type aufart,
          lv_aduhr  type aduhr.

    data: lt_checklist       type zabsf_pm_t_checklist,
          ls_checklist       like line of lt_checklist,
          lv_eqpmt_installed type equnr,
          ls_equi            type equi.

    data ls_object type sibflporb.

    data: lt_attach_list type zabsf_pm_t_attachment_list,
          ls_attach_list type line of zabsf_pm_t_attachment_list.

    "Header data
    call method zcl_absf_pm=>get_order_header
      exporting
        i_inputobj      = i_inputobj
        i_aufnr         = i_aufnr
        i_is_mould_exch = i_is_mould_exch
      importing
        e_order_header  = e_order_header.

    lv_aduhr = e_order_header-aduhr.
    if lv_aduhr = '240000'.
      e_order_header-aduhr  = '235959'.
    endif.


*  Get status order
*    SELECT SINGLE status
*      FROM zabsf_pm_status
*      INTO @DATA(lv_status_proc)
*     WHERE werks EQ @i_inputobj-werks
*       AND aufnr EQ @i_aufnr.

*   Removed werks, because with it we wouldnt get the correct status
    select single status
      from zabsf_pm_status
      into @data(lv_status_proc)
     where aufnr eq @i_aufnr.

    if not lv_status_proc is initial.
      e_order_header-status_proc = lv_status_proc.
    endif.



*  Get operator in order PM
    call method zcl_absf_pm=>get_operator
      exporting
        werks        = i_inputobj-werks
        aufnr        = i_aufnr
      importing
        operator_tab = et_operator.

    "Consumpsions List
    call method zcl_absf_pm=>get_consumptions
      exporting
        i_werks         = i_inputobj-werks
        i_aufnr         = i_aufnr
      importing
        et_consumptions = et_consumptions.
*
*    "Notification Detail
*    CALL METHOD ZCL_ABSF_PM=>get_notification
*      EXPORTING
*        i_werks =  i_inputobj-werks
*        i_aufnr = i_aufnr
*      IMPORTING
*        e_notification = e_notification.

*>>> get only notification Number and send to notification structure
    move e_order_header-qmnum to e_notification-qmnum.

*>>>DGG 20/07/2017 - Get notification details
    call method zcl_absf_pm=>get_notification
      exporting
        i_werks        = i_inputobj-werks
        i_qmnum        = e_order_header-qmnum
      importing
        e_notification = e_notification.
*<<<DGG 20/07/2017 - Get notification details

    "--------------------------------------------------------
    if i_is_mould_exch = abap_true." Mould Exchange

      " Machine sub-equipments
      call method zcl_absf_pm=>get_machine_subequip
        exporting
          i_werks     = i_inputobj-werks
          i_equnr     = e_order_header-mach_equnr
        importing
          et_subequip = et_subequip.

      " Stages List
      call method zcl_absf_pm=>get_stages_mouldexch
        exporting
          i_refdt         = i_refdt
          i_inputobj      = i_inputobj
          i_equnr         = e_order_header-equnr
          i_mach_equnr    = e_order_header-mach_equnr
          i_aufnr         = i_aufnr
        importing
          e_current_stage = e_order_header-stage
          et_stages       = et_stages.

      loop at et_stages into ls_stages.

        ls_checklist-equnr = ls_stages-equnr.
        ls_checklist-stepid = ls_stages-vornr.
        ls_checklist-index_id = ls_stages-vornr.
        ls_checklist-stepdesc = ls_stages-ltxa1.
        ls_checklist-status = ls_stages-status.
        append ls_checklist to lt_checklist.

        call method zcl_absf_pm=>get_checklist
          exporting
            i_inputobj     = i_inputobj
            pm_order       = i_aufnr
            checklist_step = ls_stages-vornr
          changing
            checklist      = lt_checklist
            return_tab     = return_tab.

        append lines of lt_checklist to et_checklist.

        clear: ls_checklist, ls_stages.
        refresh lt_checklist.
      endloop.

* Exclude moulde installed on the machine from equipments list 03.01.2017
*      READ TABLE et_stages INTO ls_stages INDEX 1.
*      lv_eqpmt_installed = ls_stages-equnr.
*
*      IF lv_eqpmt_installed IS NOT INITIAL.
*
*        LOOP AT et_subequip TRANSPORTING NO FIELDS
*          WHERE equnr = lv_eqpmt_installed.
*
*          DELETE et_subequip.
*        ENDLOOP.
*      ENDIF.

    else. " Not Mould Exchange

      call method zcl_absf_pm=>get_checklist
        exporting
          i_inputobj     = i_inputobj
          pm_order       = i_aufnr
          checklist_step = space
        changing
          checklist      = et_checklist
          return_tab     = return_tab.

* get subequipments if equipment is a machine.
      select single * from equi into ls_equi
        where equnr = e_order_header-equnr.

      if sy-subrc eq 0.

        if ls_equi-eqtyp = 'P'. "P - for machine
          call method zcl_absf_pm=>get_machine_subequip
            exporting
              i_werks     = i_inputobj-werks
              i_equnr     = e_order_header-equnr
            importing
              et_subequip = et_subequip.

        endif.
      endif.
    endif.

** Causes List

    call method zcl_absf_pm=>get_notif_causes
      exporting
        i_werks      = i_inputobj-werks
      importing
        et_causes    = et_causes
        et_subcauses = et_subcauses.

* get moulde location
    select single auart from aufk into lv_auart
      where aufnr = i_aufnr.

    if lv_auart eq 'ZCLN'.

      call method zcl_absf_pm=>get_moulde_location
        exporting
          i_equnr    = e_order_header-equnr
          i_inputobj = i_inputobj
        importing
          e_stort    = e_order_header-stort
          e_ktext    = e_order_header-ktext
          e_eqfnr    = e_order_header-eqfnr.

    endif.


*>>CFB 12/07/2017 - Get Maintenace History
    call method zcl_absf_pm=>get_maintenance_history
      exporting
        i_inputobj       = i_inputobj
        i_equnr          = e_order_header-equnr
        i_tplnr          = e_order_header-func_loc
      importing
        et_maint_history = et_maint_history.

*<<CFB 12/07/2017 - Get Maintenace History

*>>>CFB Get Order Object Attachments

* get the attachments of order
    if e_order_header-aufnr is not initial.

      clear ls_object.
      clear ls_attach_list.
      clear lt_attach_list.

      ls_object-typeid    = 'BUS2007'.
      ls_object-instid    = e_order_header-aufnr.
      ls_object-catid     = 'BO'.


      call method get_attachments_list
        exporting
          i_gos_obj      = ls_object
        importing
          et_attachments = lt_attach_list.


      if lt_attach_list is not initial.

        loop at lt_attach_list into ls_attach_list.

          append  ls_attach_list to et_attach_list.
        endloop.

      endif.

    endif.
*<<<CFB Get Order Object Attachments


**>>>CFB 18/07/2017 Get Technical Object Attachments
*
** verify if exists func. location and if so get the attachments of that func. location
*    IF e_order_header-func_loc IS NOT INITIAL.
*
*      CLEAR ls_object.
*      CLEAR ls_attach_list.
*      CLEAR lt_attach_list.
*
*      ls_object-typeid    = 'BUS0010'.
*      ls_object-instid    = e_order_header-func_loc.
*      ls_object-catid     = 'BO'.
*
*
*      CALL METHOD get_attachments_list
*        EXPORTING
*          i_gos_obj      = ls_object
*        IMPORTING
*          et_attachments = lt_attach_list.
*
*      IF lt_attach_list IS NOT INITIAL.
*
*        LOOP AT lt_attach_list INTO ls_attach_list.
*
*          APPEND  ls_attach_list TO et_attach_list.
*        ENDLOOP.
*
*      ENDIF.
*
*    ENDIF.
*
*
** verify if equipment numbe exis, if so get the attachments of that equipment.
*    IF e_order_header-equnr IS NOT INITIAL.
*
*      CLEAR ls_object.
*      CLEAR ls_attach_list.
*      CLEAR lt_attach_list.
*
*      ls_object-typeid    = 'EQUI'.
*      ls_object-instid    = e_order_header-equnr.
*      ls_object-catid     = 'BO'.
*
*
*      CALL METHOD get_attachments_list
*        EXPORTING
*          i_gos_obj      = ls_object
*        IMPORTING
*          et_attachments = lt_attach_list.
*
*
*      IF lt_attach_list IS NOT INITIAL.
*
*        LOOP AT lt_attach_list INTO ls_attach_list.
*
*          APPEND  ls_attach_list TO et_attach_list.
*        ENDLOOP.
*
*      ENDIF.
*
*    ENDIF.
**<<<CFB Get Technical Object Attachments





*>>>> CFB 04.10.2018 Envio da estrutura de equipamento com as garantias

    data: ls_equipemnt type zabsf_pm_s_equipment,
          lv_objnr     type equi-objnr,
          lt_bgmkobj   type table of bgmkobj.

    ls_equipemnt-equnr = e_order_header-equnr.
    ls_equipemnt-eqktx = e_order_header-eqktx.
    ls_equipemnt-tplnr = e_order_header-func_loc.

    select single objnr from equi
      into lv_objnr
     where equnr = e_order_header-equnr.

*    matricula
    select single fleet~license_num
      into ls_equipemnt-license_num
      from fleet as fleet
      where fleet~objnr = lv_objnr.


    select * from bgmkobj
      into table lt_bgmkobj
      where j_objnr = lv_objnr.

*   ler a tabela de garantias para cada um dos equipamentos encontrados
    loop at lt_bgmkobj into data(ls_bgmkobj).

      if sy-subrc eq 0.

        case ls_bgmkobj-gaart. "case ao tipo de garantia

          when '2'. "garantia do tipo 2 Fornecedor
            ls_equipemnt-vendor_gwldt = ls_bgmkobj-gwldt.
            ls_equipemnt-vendor_gwlen = ls_bgmkobj-gwlen.

            if sy-datum between ls_bgmkobj-gwldt and ls_bgmkobj-gwlen.
              ls_equipemnt-in_guarantee_vendor = 'X'.
            endif.
          when '3'. "garantia do tipo 3 Fabricante
            ls_equipemnt-manuf_gwldt = ls_bgmkobj-gwldt.
            ls_equipemnt-manuf_gwlen = ls_bgmkobj-gwlen.

            if sy-datum between ls_bgmkobj-gwldt and ls_bgmkobj-gwlen.
              ls_equipemnt-in_guarantee_manuf = 'X'.

            endif.
          when others. " só vamos tratar as do tipo 2 e 3

        endcase.

      endif.
    endloop.

    e_equipment = ls_equipemnt.

*<<<< CFB 04.10.2018 Envio da estrutura de equipamento com as garantias

  endmethod.


  METHOD get_order_header.

* VARIABLES
    DATA: lv_first_operation(4) VALUE '0010',
          ls_orders_list        TYPE zabsf_pm_s_order_list.

* STRUCTURES
    DATA: ls_filters      TYPE zabsf_pm_s_orderfilter_options.

* RANGES
    DATA: ls_aufnr         TYPE rsis_s_range,
          lr_aufnr         TYPE rsis_t_range,
          ra_eqtyp         TYPE RANGE OF eqtyp,
          ra_istat_default TYPE RANGE OF j_status,
          ra_istat_open    TYPE RANGE OF j_status,
          ra_istat_proc    TYPE RANGE OF j_status,
          ra_istat_closed  TYPE RANGE OF j_status,
          ra_istat_blocked TYPE RANGE OF j_status.

* TABLES
    DATA: et_orders_list       TYPE TABLE OF zabsf_pm_s_order_list,
          lt_orders_status_in  TYPE zabsf_pm_orders_status_t,
          lt_orders_status_out TYPE zabsf_pm_orders_status_t.

    FIELD-SYMBOLS <fs_et_orders_list> TYPE zabsf_pm_s_order_list.

*>> get default language
    SELECT SINGLE spras
      FROM zabsf_languages
      INTO (@DATA(l_alt_spras))
     WHERE werks      EQ @i_inputobj-werks
       AND is_default EQ @abap_true.


*>> get system status in parametrization table
    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_inputobj-werks
        i_parameter = 'ISTAT_DEFAULT'
      IMPORTING
        et_range    = ra_istat_default.

    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_inputobj-werks
        i_parameter = 'ISTAT_BLOCKED'
      IMPORTING
        et_range    = ra_istat_blocked.

    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_inputobj-werks
        i_parameter = 'ISTAT_CLOSED'
      IMPORTING
        et_range    = ra_istat_closed.

    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_inputobj-werks
        i_parameter = 'ISTAT_PROC'
      IMPORTING
        et_range    = ra_istat_proc.

    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_inputobj-werks
        i_parameter = 'ISTAT_OPEN'
      IMPORTING
        et_range    = ra_istat_open.

*>> Get Status Code Text
    SELECT SINGLE parva
          FROM zabsf_pm_param
          INTO @DATA(lv_stat_conc)
         WHERE werks = @i_inputobj-werks
           AND parid = 'STAT_COD_CLOSED'.

    SELECT SINGLE parva
          FROM zabsf_pm_param
          INTO @DATA(lv_stat_proc)
         WHERE werks = @i_inputobj-werks
           AND parid = 'STAT_COD_PROC'.

    SELECT SINGLE parva
          FROM zabsf_pm_param
          INTO @DATA(lv_stat_open)
         WHERE werks = @i_inputobj-werks
           AND parid = 'STAT_COD_OPEN'.

    SELECT SINGLE parva
          FROM zabsf_pm_param
          INTO @DATA(lv_stat_block)
         WHERE werks = @i_inputobj-werks
           AND parid = 'STAT_COD_BLOCK'.

    SELECT SINGLE parva
          FROM zabsf_pm_param
          INTO @DATA(lv_stat_other)
         WHERE werks = @i_inputobj-werks
           AND parid = 'STAT_COD_OTHER'.

    IF i_aufnr IS NOT INITIAL.

      ls_aufnr-sign = 'I'.
      ls_aufnr-option = 'EQ'.
      ls_aufnr-low = i_aufnr.
      APPEND ls_aufnr TO lr_aufnr.
    ENDIF.

    IF i_is_mould_exch = abap_true.

      lv_first_operation = '1000'.

      CALL METHOD get_parameter
        EXPORTING
          i_werks     = i_inputobj-werks
          i_parameter = 'EQTYP_MOULD'
        IMPORTING
          et_range    = ra_eqtyp.
    ENDIF.


    SELECT a~aufnr       AS aufnr,
     a~auart       AS auart,
     a~ktext       AS aufnr_t,
     b~equnr       AS equnr,
     b~priok       AS priok,
     b~addat       AS addat,
     b~aduhr       AS aduhr,
*     c~stat        AS status,
     afvc~pernr    AS technician,

      ihpa~parnr  AS rsp_partner,
     e~equnr       AS mach_equnr,
     b~qmnum       AS qmnum,

     a~vaplz       AS vaplz,
     crhd~werks    AS wawrk

   INTO CORRESPONDING FIELDS OF TABLE @et_orders_list
   FROM aufk AS a
    INNER JOIN afih                 AS b ON a~aufnr = b~aufnr
    INNER JOIN afko                 AS afko ON a~aufnr = afko~aufnr
*    INNER JOIN jest                 AS c ON c~objnr = a~objnr
* Functional Location and it's description
    LEFT OUTER JOIN eqkt            AS eqkt ON eqkt~equnr = b~equnr AND eqkt~spras EQ @sy-langu
    LEFT JOIN afvc                 AS afvc ON afko~aufpl = afvc~aufpl
    LEFT OUTER JOIN objk            AS e ON e~obknr = b~obknr
    LEFT JOIN ihpa                 AS ihpa ON ihpa~objnr = a~objnr AND
                                                ihpa~parvw = 'ZB'
*                                                ihpa~counter = '1'
    LEFT JOIN crhd                 AS crhd ON crhd~objty = b~pm_objty AND
                                                crhd~objid = b~gewrk
   WHERE a~aufnr IN @lr_aufnr.
*    AND c~stat IN @ra_istat_default
*    AND c~inact EQ @space
*    AND afvc~vornr EQ @lv_first_operation . "get first operation for all orders ..AIM

    IF sy-subrc NE 0 AND l_alt_spras NE sy-langu.
* search on alternative language
      SELECT a~aufnr       AS aufnr,
       a~auart       AS auart,
       a~ktext       AS aufnr_t,
       b~equnr       AS equnr,
       b~priok       AS priok,
       b~addat       AS addat,
       b~aduhr       AS aduhr,
*       c~stat        AS status,
       afvc~pernr AS technician,

       ihpa~parnr AS rsp_partner,
       e~equnr       AS mach_equnr,
       b~qmnum       AS qmnum,

       a~vaplz       AS vaplz,
       crhd~werks    AS wawrk
     INTO CORRESPONDING FIELDS OF TABLE @et_orders_list
     FROM aufk AS a
      INNER JOIN afih                 AS b ON a~aufnr = b~aufnr
      INNER JOIN afko                 AS afko ON a~aufnr = afko~aufnr
*      INNER JOIN jest                 AS c ON c~objnr = a~objnr
* Functional Location and it's description
      LEFT OUTER JOIN eqkt            AS eqkt ON eqkt~equnr = b~equnr AND eqkt~spras EQ @l_alt_spras
      "INNER JOIN eqkt                 AS eqkt ON eqkt~equnr = b~equnr
      LEFT OUTER JOIN objk            AS e ON e~obknr = b~obknr
      LEFT JOIN afvc                 AS afvc ON afko~aufpl = afvc~aufpl
      LEFT JOIN ihpa                 AS ihpa ON ihpa~objnr = a~objnr AND
                                                ihpa~parvw = 'ZB'
*                                                ihpa~counter = '1'
      LEFT JOIN crhd                 AS crhd ON crhd~objty = b~pm_objty AND
                                                crhd~objid = b~gewrk


     WHERE a~aufnr IN @lr_aufnr.
*       AND c~stat IN @ra_istat_default
*        AND c~inact EQ @space
*        AND afvc~vornr EQ @lv_first_operation. "get first operation for all orders ..AIM

    ENDIF.

    CHECK et_orders_list IS NOT INITIAL.


*>>> CFB CFB 10.10.2018 - move partner filed (numc12) to pernnr (numc8)
    LOOP AT et_orders_list ASSIGNING <fs_et_orders_list>.
      MOVE <fs_et_orders_list>-rsp_partner TO <fs_et_orders_list>-rsp_user.
    ENDLOOP.


*    "Status BLOCKED
*    LOOP AT et_orders_list INTO ls_orders_list
*      WHERE status IN ra_istat_blocked.
**      ls_orders_list-status_proc = lv_stat_conc.
*    ENDLOOP.

    SELECT * FROM equi INTO TABLE @DATA(lt_equipments)
      FOR ALL ENTRIES IN @et_orders_list
      WHERE equnr = @et_orders_list-equnr.

*>> equipment description
    SELECT * FROM eqkt INTO TABLE @DATA(lt_equi_txt)
      FOR ALL ENTRIES IN @et_orders_list
      WHERE equnr = @et_orders_list-equnr
      AND spras = @sy-langu.

    IF sy-subrc NE 0 AND l_alt_spras NE sy-langu.

      SELECT * FROM eqkt INTO TABLE @lt_equi_txt
       FOR ALL ENTRIES IN @et_orders_list
       WHERE equnr = @et_orders_list-equnr
       AND spras = @l_alt_spras.

    ENDIF.

*>> order type description
    SELECT * FROM t003p INTO TABLE @DATA(lt_auart_txt)
      FOR ALL ENTRIES IN @et_orders_list
      WHERE auart = @et_orders_list-auart
      AND spras = @sy-langu.

    IF sy-subrc NE 0 AND l_alt_spras NE sy-langu.
      SELECT * FROM t003p INTO TABLE @lt_auart_txt
        FOR ALL ENTRIES IN @et_orders_list
        WHERE auart = @et_orders_list-auart
        AND spras = @l_alt_spras.
    ENDIF.

*>> order priority description
    SELECT afih~aufnr, t356_t~artpr, t356_t~priok, t356_t~priokx INTO TABLE @DATA(lt_priok_txt)
      FROM t356_t
        INNER JOIN afih ON afih~artpr = t356_t~artpr AND afih~priok = t356_t~priok
      FOR ALL ENTRIES IN @et_orders_list
      WHERE afih~aufnr = @et_orders_list-aufnr
      AND spras = @sy-langu.

    IF sy-subrc NE 0 AND l_alt_spras NE sy-langu.
      SELECT afih~aufnr, t356_t~artpr, t356_t~priok, t356_t~priokx INTO TABLE @lt_priok_txt
      FROM t356_t
        INNER JOIN afih ON afih~artpr = t356_t~artpr AND afih~priok = t356_t~priok
      FOR ALL ENTRIES IN @et_orders_list
      WHERE afih~aufnr = @et_orders_list-aufnr
        AND spras = @l_alt_spras.
    ENDIF.


*>> status and it's description
    MOVE-CORRESPONDING et_orders_list TO lt_orders_status_in.

    CALL METHOD zcl_absf_pm=>get_orders_status
      EXPORTING
        i_werks           = i_inputobj-werks
        i_stat_blocked    = abap_true
        i_stat_closed     = abap_true
        i_stat_processing = abap_true
        i_stat_released   = abap_false
        i_stat_open       = abap_true
        i_stat_stoped     = abap_false
        i_stat_others     = abap_true
        it_orders_list    = lt_orders_status_in
      IMPORTING
        et_orders_list    = lt_orders_status_out.

    SELECT * FROM tj02t INTO TABLE @DATA(lt_istatus_txt)
      FOR ALL ENTRIES IN @lt_orders_status_out
      WHERE istat = @lt_orders_status_out-status
      AND  spras = @sy-langu.

*    SELECT * FROM tj02t INTO TABLE @DATA(lt_istatus_txt)
*      FOR ALL ENTRIES IN @et_orders_list
*      WHERE istat = @et_orders_list-status
*      AND  spras = @sy-langu.

    IF sy-subrc NE 0 AND l_alt_spras NE sy-langu.

      SELECT * FROM tj02t INTO TABLE @lt_istatus_txt
          FOR ALL ENTRIES IN @lt_orders_status_out
          WHERE istat = @lt_orders_status_out-status
          AND  spras = @l_alt_spras.

*      SELECT * FROM tj02t INTO TABLE @lt_istatus_txt
*          FOR ALL ENTRIES IN @et_orders_list
*          WHERE istat = @et_orders_list-status
*          AND  spras = @l_alt_spras.
    ENDIF.


*>> operator full name
    SELECT * FROM pa0002 INTO TABLE @DATA(lt_names)
      FOR ALL ENTRIES IN @et_orders_list
      WHERE pernr = @et_orders_list-technician.

*>> zb partner  full name
    SELECT * FROM pa0002 INTO TABLE @DATA(lt_names_partner)
      FOR ALL ENTRIES IN @et_orders_list
      WHERE pernr = @et_orders_list-rsp_user.


**>> operator full name
*    SELECT * FROM pa0002 INTO TABLE @DATA(lt_names_partner)
*      FOR ALL ENTRIES IN @et_orders_list
*      WHERE pernr =  @et_orders_list-rsp_user.


*>> ZMLD: Machine equipment description
    SELECT equnr, eqktx FROM eqkt INTO TABLE @DATA(lt_mach_equi_txt)
      FOR ALL ENTRIES IN @et_orders_list
      WHERE equnr = @et_orders_list-mach_equnr
      AND spras = @sy-langu.

    IF sy-subrc NE 0 AND l_alt_spras NE sy-langu.
      SELECT equnr, eqktx FROM eqkt INTO TABLE @lt_mach_equi_txt
       FOR ALL ENTRIES IN @et_orders_list
       WHERE equnr = @et_orders_list-mach_equnr
       AND spras = @l_alt_spras.
    ENDIF.

* Functional Location and it's description
    SELECT a~aufnr, i~tplnr, ix~pltxt INTO TABLE @DATA(lt_func_loc)
      FROM iloa AS i
        INNER JOIN afih AS a ON a~iloan = i~iloan
        INNER JOIN iflotx AS ix ON ix~tplnr = i~tplnr
      FOR ALL ENTRIES IN @et_orders_list
      WHERE a~aufnr = @et_orders_list-aufnr
           AND ix~spras = @sy-langu.

    IF sy-subrc NE 0 AND l_alt_spras NE sy-langu.
      SELECT a~aufnr, i~tplnr, ix~pltxt INTO TABLE @lt_func_loc
        FROM iloa AS i
          INNER JOIN afih AS a ON a~iloan = i~iloan
          INNER JOIN iflotx AS ix ON ix~tplnr = i~tplnr
         FOR ALL ENTRIES IN @et_orders_list
         WHERE a~aufnr = @et_orders_list-aufnr
              AND ix~spras = @l_alt_spras.
    ENDIF.

    LOOP AT et_orders_list ASSIGNING <fs_et_orders_list>.


*>> equipment
      READ TABLE lt_equi_txt INTO DATA(ls_equi_txt) WITH KEY equnr = <fs_et_orders_list>-equnr.
      <fs_et_orders_list>-eqktx = ls_equi_txt-eqktx.

*>> order type
      READ TABLE lt_auart_txt INTO DATA(ls_auart_txt) WITH KEY auart = <fs_et_orders_list>-auart.
      <fs_et_orders_list>-auart = ls_auart_txt-auart.

*>> order priok description
      READ TABLE lt_priok_txt INTO DATA(ls_priok_txt) WITH KEY aufnr = <fs_et_orders_list>-aufnr.
      <fs_et_orders_list>-priok_t = ls_priok_txt-priokx.

*>> status
      READ TABLE lt_orders_status_out INTO DATA(lts_orders_status_out)
        WITH KEY aufnr = <fs_et_orders_list>-aufnr.
      IF sy-subrc EQ 0.
        <fs_et_orders_list>-status = lts_orders_status_out-status.
        <fs_et_orders_list>-status_proc = lts_orders_status_out-status_proc.
      ENDIF.

      READ TABLE lt_istatus_txt INTO DATA(ls_istatus_txt)
        WITH KEY istat = <fs_et_orders_list>-status.
      <fs_et_orders_list>-status_t = ls_istatus_txt-txt30.


*>> name
      READ TABLE lt_names INTO DATA(ls_names) WITH KEY pernr = <fs_et_orders_list>-technician.
      CONCATENATE ls_names-nachn ls_names-vorna INTO DATA(lv_fullname) SEPARATED BY space.
      <fs_et_orders_list>-uname =  lv_fullname.

*>> CFB 10.10.2018 name of zb partner
      READ TABLE lt_names_partner INTO DATA(ls_names_partner) WITH KEY pernr = <fs_et_orders_list>-rsp_user.
      CONCATENATE ls_names_partner-nachn ls_names_partner-vorna INTO DATA(lv_fullname_partner) SEPARATED BY space.
      <fs_et_orders_list>-rsp_user_name =  lv_fullname_partner.


*>> is moulde?
      READ TABLE lt_equipments INTO DATA(ls_equipments) WITH KEY equnr = <fs_et_orders_list>-equnr.
      IF ls_equipments-eqtyp IN ra_eqtyp.
        <fs_et_orders_list>-is_molde = abap_true.
      ENDIF.
*>> ZMLD: machine equipment
      READ TABLE lt_mach_equi_txt INTO DATA(ls_mach_equi_txt) WITH KEY equnr = <fs_et_orders_list>-mach_equnr.
      IF sy-subrc = 0.
        <fs_et_orders_list>-mach_eqktx = ls_mach_equi_txt-eqktx.
      ENDIF.
*>>  Functional Location and it's description
      READ TABLE lt_func_loc INTO DATA(ls_func_loc) WITH KEY aufnr = <fs_et_orders_list>-aufnr.
      IF sy-subrc = 0.
        <fs_et_orders_list>-func_loc = ls_func_loc-tplnr.
        <fs_et_orders_list>-func_loc_tx = ls_func_loc-pltxt.
      ENDIF.

      CLEAR: ls_equi_txt, ls_auart_txt, ls_istatus_txt, ls_names,
             ls_mach_equi_txt, ls_func_loc.

      e_order_header = <fs_et_orders_list>.

    ENDLOOP.


* Get current stage for ZMLD orders.
    IF i_is_mould_exch EQ abap_true.

      LOOP AT et_orders_list ASSIGNING <fs_et_orders_list>.

        CALL METHOD zcl_absf_pm=>get_stages_mouldexch
          EXPORTING
            i_refdt         = sy-datlo
            i_inputobj      = i_inputobj
            i_equnr         = <fs_et_orders_list>-equnr
            i_mach_equnr    = <fs_et_orders_list>-mach_equnr
            i_aufnr         = <fs_et_orders_list>-aufnr
          IMPORTING
            e_current_stage = <fs_et_orders_list>-stage.

      ENDLOOP.
    ENDIF.


  ENDMETHOD.


  METHOD get_order_types.

    DATA: ra_aufart      TYPE RANGE OF aufart.

    DATA: lv_parameter TYPE char20.

    IF i_serv_type IS NOT INITIAL. "exists CS or PM

      IF i_for_creation EQ abap_true.
        CONCATENATE 'AUFART_' i_serv_type '_CREATION' INTO lv_parameter.
      ELSE.
        CONCATENATE 'AUFART_' i_serv_type INTO lv_parameter.
      ENDIF.

      CALL METHOD get_parameter
        EXPORTING
          i_werks     = i_werks
          i_parameter = lv_parameter
        IMPORTING
          et_range    = ra_aufart.

    ELSE. " SERV_TYPE is initial

      IF i_for_creation EQ abap_true.

        CALL METHOD get_parameter
          EXPORTING
            i_werks     = i_werks
            i_parameter = 'AUFART_PM_CREATION'
          IMPORTING
            et_range    = ra_aufart.


        CALL METHOD get_parameter
          EXPORTING
            i_werks     = i_werks
            i_parameter = 'AUFART_CS_CREATION'
          IMPORTING
            et_range    = ra_aufart.

      ELSE.

        CALL METHOD get_parameter
          EXPORTING
            i_werks     = i_werks
            i_parameter = 'AUFART_PM'
          IMPORTING
            et_range    = ra_aufart.

        CALL METHOD get_parameter
          EXPORTING
            i_werks     = i_werks
            i_parameter = 'AUFART_CS'
          IMPORTING
            et_range    = ra_aufart.

      ENDIF.

    ENDIF.


    SELECT t003o~auart, t003p~txt
      FROM t003o INNER JOIN t003p ON  t003p~auart = t003o~auart
                                  AND t003p~spras = @sy-langu
      INTO TABLE @et_order_type
      WHERE t003o~auart IN @ra_aufart.


    IF et_order_type[] IS INITIAL.
      SELECT SINGLE spras
        FROM zabsf_languages
        INTO @DATA(lv_alt_spras)
       WHERE werks      EQ @i_werks
         AND is_default EQ @abap_true.

      IF sy-subrc = 0 AND lv_alt_spras <> sy-langu.
        SELECT t003o~auart, t003p~txt
          FROM t003o INNER JOIN t003p ON  t003p~auart = t003o~auart
                                      AND t003p~spras = @lv_alt_spras
          INTO TABLE @et_order_type
          WHERE t003o~auart IN @ra_aufart.
      ENDIF.

    ENDIF.


  ENDMETHOD.


  METHOD get_parameter.

    DATA: lv_ref TYPE REF TO data.

    CHECK i_parameter IS NOT INITIAL.

    CREATE DATA lv_ref LIKE LINE OF et_range.
    ASSIGN lv_ref->* TO FIELD-SYMBOL(<range>).
    CHECK sy-subrc = 0.

    ASSIGN COMPONENT 'SIGN' OF STRUCTURE <range> TO FIELD-SYMBOL(<sign>).
    CHECK sy-subrc = 0.

    ASSIGN COMPONENT 'OPTION' OF STRUCTURE <range> TO FIELD-SYMBOL(<option>).
    CHECK sy-subrc = 0.

    ASSIGN COMPONENT 'LOW' OF STRUCTURE <range> TO FIELD-SYMBOL(<low>).
    CHECK sy-subrc = 0.

    SELECT SINGLE *
      FROM zabsf_pm_param
      INTO @DATA(ls_param)
     WHERE werks = @i_werks
       AND parid = @i_parameter.

    CHECK sy-subrc = 0.

    <sign> = ls_param-sign.
    <option> = 'EQ'.

    SPLIT ls_param-parva AT ';' INTO TABLE DATA(lt_split).

    LOOP AT lt_split INTO DATA(ls_split).
      <low> = ls_split.
      INSERT <range> INTO et_range INDEX sy-tabix.
    ENDLOOP.
  ENDMETHOD.


  METHOD get_pm_activities.

    DATA: lt_order_type TYPE zabsf_pm_t_order_types_list,
          ls_order_type LIKE LINE OF lt_order_type,
          ls_activities LIKE LINE OF et_activities,
          ls_t350i      TYPE t350i,
          ls_t353i_t    TYPE t353i_t.

    DATA: l_langu TYPE sy-langu.

    FIELD-SYMBOLS: <fs_order_type> TYPE zabsf_pm_s_order_types.

*  Get alternative language
    SELECT SINGLE spras
      FROM zabsf_languages
      INTO l_langu
     WHERE werks      EQ i_inputobj-werks
       AND is_default NE space.

    CALL METHOD zcl_absf_pm=>get_order_types
      EXPORTING
        i_werks        = i_inputobj-werks
        i_for_creation = abap_true
      IMPORTING
        et_order_type  = lt_order_type.

    CHECK lt_order_type IS NOT INITIAL.

    SELECT * FROM t350i INTO TABLE @DATA(lt_t350i)
      FOR ALL ENTRIES IN @lt_order_type
      WHERE auart = @lt_order_type-auart.

    CHECK lt_t350i IS NOT INITIAL.

    SELECT * FROM t353i_t INTO TABLE @DATA(lt_t353i_t)
      FOR ALL ENTRIES IN @lt_t350i
      WHERE ilart EQ @lt_t350i-ilart
      AND spras = @sy-langu.

    IF sy-subrc NE 0.

      SELECT * FROM t353i_t INTO TABLE @lt_t353i_t
        FOR ALL ENTRIES IN @lt_t350i
        WHERE ilart EQ @lt_t350i-ilart
        AND spras EQ @l_langu.
    ENDIF.

    LOOP AT lt_order_type ASSIGNING <fs_order_type>.

      LOOP AT lt_t350i INTO ls_t350i
        WHERE auart EQ <fs_order_type>-auart.

        ls_activities-auart = <fs_order_type>-auart.
        ls_activities-ilart = ls_t350i-ilart.

        READ TABLE lt_t353i_t INTO ls_t353i_t WITH KEY ilart = ls_t350i-ilart.
        IF sy-subrc EQ 0.

          ls_activities-ilatx = ls_t353i_t-ilatx.
        ENDIF.

        APPEND ls_activities TO et_activities.
        CLEAR: ls_t350i, ls_activities, ls_t353i_t.
      ENDLOOP.

    ENDLOOP.



    SORT et_activities BY auart ilart ASCENDING.

  ENDMETHOD.


  METHOD get_pm_orders.

*   CONSTANTS
    "Params in Parametrization Table
    DATA: c_prog            TYPE programm VALUE 'RIAUFK20',
          c_pmo_dp_vari_cfg TYPE param_id VALUE 'PM_ORD_DISP_VARIANT'.
    " lv_first_operation(4) VALUE '0010'.  BMR 06.09.2017 - not relevant for CIMO

    DATA: lv_start_table TYPE int4 VALUE '2'.

    "RANGES
    DATA: ls_order_type    TYPE rsis_s_range,
          lr_order_type    TYPE rsis_t_range,
          ls_technician    TYPE rsis_s_range,
          lr_technician    TYPE rsis_t_range,
          ls_dates         TYPE rsis_s_range,
          lr_dates         TYPE rsis_t_range,
          ls_equipment     TYPE rsis_s_range,
          lr_equipment     TYPE rsis_t_range,
          ls_aufnr         TYPE rsis_s_range,
          lr_aufnr         TYPE rsis_t_range,
          lr_description   TYPE rsis_t_range,
          ls_description   TYPE rsis_s_range,
          lr_spras         TYPE rsis_t_range,
          ls_spras         TYPE rsis_s_range,
*          ls_change_fields TYPE rsis_s_range,
          lr_change_fields TYPE rsis_t_range.

    DATA:
      ra_istat_open     TYPE RANGE OF j_status,
      ra_exclude_open   TYPE RANGE OF j_status,
      ra_istat_proc     TYPE RANGE OF j_status,
      ra_exclude_proc   TYPE RANGE OF j_status,
      ra_exclude_closed TYPE RANGE OF j_status,
      ra_eqtyp          TYPE RANGE OF eqtyp.

    "VARIABLES
    DATA: lv_vari_protect    TYPE flag,
          lv_aufnr           TYPE aufnr,
          lv_disp_var        TYPE slis_vari,
          lv_objectclas      TYPE cdobjectcl,
          lv_objnr           TYPE j_objnr,
          lv_where_ini       TYPE char80,
          lv_where           TYPE string,
          lv_stat_blocked    TYPE boole_d,
          lv_stat_closed     TYPE boole_d,
          lv_stat_processing TYPE boole_d,
          lv_stat_released   TYPE boole_d,
          lv_stat_open       TYPE boole_d,
          lv_stat_stoped     TYPE boole_d,
          lv_stat_others     TYPE boole_d.

    "STRUCTURES
    DATA: ls_deleted_orders TYPE zabsf_pm_s_order_list,
          ls_orders         TYPE zabsf_pm_s_order_list.

    DATA: BEGIN OF ls_spool_list,
            aufnr TYPE aufnr,
          END OF ls_spool_list.
    DATA: lt_spool_list LIKE TABLE OF ls_spool_list.

    DATA: BEGIN OF ls_costs,
            aufnr  TYPE aufnr,
            wkgbtr TYPE dkgrkosist,
          END OF ls_costs.
    DATA lt_costs LIKE TABLE OF ls_costs WITH KEY aufnr.

    "INTERNAL TABLES
    DATA: lt_deleted_orders     TYPE zabsf_pm_t_order_list,
          lt_orders_others      TYPE zabsf_pm_t_order_list,
          lt_et_orders_list_aux TYPE zabsf_pm_t_order_list,
          lt_orders_status_in   TYPE zabsf_pm_orders_status_t,
          lt_orders_status_out  TYPE zabsf_pm_orders_status_t.

    "JOB & SPOOL
    DATA: lv_number        TYPE tbtcjob-jobcount,
          lv_name          TYPE tbtcjob-jobname,
          print_parameters TYPE pri_params,
          lv_status        TYPE tbtco-status,
          e_flag           TYPE flag,
          lv_spool_nr      TYPE btclistid.

    FIELD-SYMBOLS: <fs_et_orders_list> LIKE LINE OF et_orders_list.


    REFRESH: lr_aufnr.

*>> get default language
    SELECT SINGLE spras
      FROM zabsf_languages
      INTO (@DATA(l_alt_spras))
     WHERE werks      EQ @i_inputobj-werks
       AND is_default EQ @abap_true.

*>> Get Order Types Paramatrization.
    IF i_filters-only_zmld = abap_true.     "Mould exchange

      "lv_first_operation = '1000'.

      CALL METHOD get_parameter
        EXPORTING
          i_werks     = i_inputobj-werks
          i_parameter = 'AUFART_MOULD_EXCH'
        IMPORTING
          et_range    = lr_order_type.
    ELSEIF i_filters-auart IS NOT INITIAL.  "Order type entered in filter
      ls_order_type-sign = 'I'.
      ls_order_type-option = 'EQ'.
      ls_order_type-low = i_filters-auart.
      APPEND ls_order_type TO lr_order_type.

    ELSE.                                   "All PM order types, except mould exchange
      CALL METHOD get_parameter
        EXPORTING
          i_werks     = i_inputobj-werks
          i_parameter = 'AUFART_PM'
        IMPORTING
          et_range    = lr_order_type.

      CALL METHOD get_parameter
        EXPORTING
          i_werks     = i_inputobj-werks
          i_parameter = 'AUFART_CS'
        IMPORTING
          et_range    = lr_order_type.
    ENDIF.


    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_inputobj-werks
        i_parameter = 'ISTAT_PROC'
      IMPORTING
        et_range    = ra_istat_proc.

    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_inputobj-werks
        i_parameter = 'ISTAT_OPEN'
      IMPORTING
        et_range    = ra_istat_open.


*-------------------------------------------
*         Search by Variant
*-------------------------------------------
    IF i_variant IS NOT INITIAL.

      "Return error when Variant is protected
      SELECT SINGLE protected INTO @lv_vari_protect
        FROM varid
        WHERE report = @c_prog
          AND variant = @i_variant.

      IF lv_vari_protect = abap_true.
*            MESSAGE e037(ZABSF_PM).
        CALL METHOD zcl_absf_pm=>add_message
          EXPORTING
            msgty      = 'E'
            msgno      = '037'
            msgv1      = i_variant
          CHANGING
            return_tab = et_returntab.
        EXIT.
      ENDIF.


      "Get Display Variant from Parametrization Table
      SELECT SINGLE parva
        FROM zabsf_pm_param
        INTO lv_disp_var
       WHERE werks = i_inputobj-werks
         AND parid = c_pmo_dp_vari_cfg.


* GET ORDERS USING VARIANT by JOB

*Nome do JOB
      CONCATENATE 'SF_PM_ORD_VARI_' sy-datum '_' sy-uzeit INTO lv_name.


      CALL FUNCTION 'JOB_OPEN'
        EXPORTING
          jobname          = lv_name
        IMPORTING
          jobcount         = lv_number
        EXCEPTIONS
          cant_create_job  = 1
          invalid_job_data = 2
          jobname_missing  = 3
          OTHERS           = 4.


      IF sy-subrc = 0.

        SUBMIT riaufk20 TO SAP-SPOOL
            SPOOL PARAMETERS print_parameters
            WITHOUT SPOOL DYNPRO
            USING SELECTION-SET i_variant
                  WITH variant = lv_disp_var    "Output Display Variant PARAM
                  WITH auart IN  lr_order_type  "Order Type PARAM
            VIA JOB lv_name NUMBER lv_number
            AND RETURN.

        IF sy-subrc = 0.
          CALL FUNCTION 'JOB_CLOSE'
            EXPORTING
              jobcount             = lv_number
              jobname              = lv_name
              strtimmed            = 'X'
            EXCEPTIONS
              cant_start_immediate = 1
              invalid_startdate    = 2
              jobname_missing      = 3
              job_close_failed     = 4
              job_nosteps          = 5
              job_notex            = 6
              lock_failed          = 7
              OTHERS               = 8.
          IF sy-subrc <> 0.

          ENDIF.
        ENDIF.
      ENDIF.


* Verifica se o JOB ja acabou
      DO.
        CLEAR lv_status.
        SELECT SINGLE status FROM tbtco INTO lv_status
        WHERE jobname LIKE lv_name
        AND jobcount = lv_number.

*Erro
        IF lv_status = 'A'.
          e_flag = 'E'.
*          MESSAGE e026(ZABSF_PM).
          CALL METHOD zcl_absf_pm=>add_message
            EXPORTING
              msgty      = 'E'
              msgno      = '026'
              msgv1      = 'riaufk20'
              msgv2      = lv_name
            CHANGING
              return_tab = et_returntab.
          EXIT.
          EXIT.
*Nao ocorreu erro
        ELSEIF lv_status = 'F'.
          e_flag = 'S'.
          EXIT.
        ELSE.
          WAIT UP TO 5 SECONDS.
        ENDIF.

      ENDDO.

      IF e_flag = 'S'.

        CLEAR lv_spool_nr.
        SELECT SINGLE listident INTO lv_spool_nr
          FROM  tbtcp
          WHERE jobname = lv_name
            AND jobcount = lv_number.

        IF lv_spool_nr IS INITIAL. "= '0000000000'.
*          MESSAGE e025(ZABSF_PM).
          CALL METHOD zcl_absf_pm=>add_message
            EXPORTING
              msgty      = 'E'
              msgno      = '025'
              msgv1      = i_variant
            CHANGING
              return_tab = et_returntab.
          EXIT.
        ENDIF.

        CALL METHOD zcl_absf_pm=>conv_spool_list_2_table
          EXPORTING
            i_spooln        = lv_spool_nr
            i_keep_sum_line = 'X'
            i_start_table   = lv_start_table " '2' '4'
          CHANGING
            et_spool_table  = lt_spool_list.


        LOOP AT lt_spool_list INTO ls_spool_list.

          ls_aufnr-sign = 'I'.
          ls_aufnr-option = 'CP'.

          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = ls_spool_list-aufnr
            IMPORTING
              output = lv_aufnr.

          ls_aufnr-low = lv_aufnr.

          APPEND ls_aufnr TO lr_aufnr.

        ENDLOOP.

*--------------------------------------------
*--------------------------------------------
*        Get Orders in list Info
*--------------------------------------------
*--------------------------------------------

        SELECT a~aufnr       AS aufnr,
               a~auart       AS auart,
               a~ktext       AS aufnr_t,
               b~equnr       AS equnr,
               b~priok       AS priok,
               b~addat       AS addat,
               b~aduhr       AS aduhr,
               afvc~pernr    AS technician,
               e~equnr       AS mach_equnr,
               b~iwerk       AS div_planif,
               crhd~arbpl    AS wkctr_maint,
               afko~gltrp    AS maint_end_date,
               afko~gluzp    AS maint_end_time
          INTO CORRESPONDING FIELDS OF TABLE @et_orders_list
          FROM aufk AS a
           INNER JOIN afih                 AS b ON a~aufnr = b~aufnr
           INNER JOIN afko                 AS afko ON a~aufnr = afko~aufnr
           INNER JOIN afvc                 AS afvc ON afvc~aufpl  = afko~aufpl
           LEFT OUTER JOIN objk            AS e ON e~obknr = b~obknr
           INNER JOIN crhd                 ON crhd~objid = b~gewrk AND crhd~objty = 'A'
          WHERE a~aufnr IN @lr_aufnr.
        "  AND afvc~vornr EQ @lv_first_operation. BMR 06.09.2017 - no relevant for CIMO

        lv_stat_blocked     = abap_true.
        lv_stat_closed      = abap_true.
        lv_stat_processing  = abap_true.
        lv_stat_released    = abap_false.
        lv_stat_open        = abap_true.
        lv_stat_stoped      = abap_false.
        lv_stat_others      = abap_true.

      ENDIF.


*-------------------------------------------
*    Old serch method (with user filters)
*-------------------------------------------
    ELSE.

*>> get params.
      CALL METHOD get_parameter
        EXPORTING
          i_werks     = i_inputobj-werks
          i_parameter = 'EQTYP_MOULD'
        IMPORTING
          et_range    = ra_eqtyp.

*>> tehcnician name
      IF i_filters-technician_name IS NOT INITIAL.

        ls_technician-sign = 'I'.
        ls_technician-option = 'CP'.
        CONCATENATE '*' i_filters-technician_name '*' INTO ls_technician-low.
        APPEND ls_technician TO lr_technician.

        SELECT pernr, cname FROM pa0002 INTO TABLE @DATA(lt_technames)
          WHERE cname IN @lr_technician.

        REFRESH lr_technician.

        TRANSLATE i_filters-technician_name TO UPPER CASE.

*>>> Search in upper case
        CLEAR ls_technician-low.
        CONCATENATE '*' i_filters-technician_name '*' INTO ls_technician-low.
        APPEND ls_technician TO lr_technician.

        SELECT pernr, cname FROM pa0002 INTO TABLE @DATA(lt_technames_upp)
          WHERE cname IN @lr_technician.

        REFRESH lr_technician.

        APPEND LINES OF lt_technames_upp TO lt_technames.
        SORT lt_technames BY pernr.
        DELETE ADJACENT DUPLICATES FROM lt_technames COMPARING pernr.

        LOOP AT lt_technames INTO DATA(ls_tech).
          ls_technician-sign = 'I'.
          ls_technician-option = 'EQ'.
          ls_technician-low = ls_tech-pernr.

          APPEND ls_technician TO lr_technician.
          CLEAR: ls_tech, ls_technician.
        ENDLOOP.

      ENDIF.

*>> Equipments
      IF i_filters-equnr IS NOT INITIAL.
        ls_equipment-sign = 'I'.
        ls_equipment-option = 'EQ'.
        ls_equipment-low = i_filters-equnr.
        APPEND ls_equipment TO lr_equipment.
      ENDIF.





*>> Technical Object - Equipment OR Functional Location Description
      IF i_filters-eqktx IS NOT INITIAL.

        ls_description-sign = 'I'.
        ls_description-option = 'CP'.
        TRANSLATE i_filters-eqktx TO UPPER CASE.
        CONCATENATE '*' i_filters-eqktx '*' INTO ls_description-low.
        APPEND ls_description TO lr_description.

        ls_spras-sign = 'I'.
        ls_spras-option = 'EQ'.
        ls_spras-low = sy-langu.
        APPEND ls_spras TO lr_spras.

        ls_spras-low = l_alt_spras.
        APPEND ls_spras TO lr_spras.

      ENDIF.

*>> Dates
      IF i_filters-date_from IS NOT INITIAL AND i_filters-date_to IS NOT INITIAL.

        ls_dates-sign = 'I'.
        ls_dates-option = 'BT'.
        ls_dates-low = i_filters-date_from.
        ls_dates-high = i_filters-date_to.
        APPEND ls_dates TO lr_dates.

      ELSE.
        IF i_filters-date_from IS NOT INITIAL AND i_filters-date_to IS INITIAL.

          ls_dates-sign = 'I'.
          ls_dates-option = 'BT'.
          ls_dates-low = i_filters-date_from.
          ls_dates-high = '99991231'.
          APPEND ls_dates TO lr_dates.
        ENDIF.

        IF i_filters-date_to IS NOT INITIAL AND i_filters-date_from IS INITIAL.
          ls_dates-sign = 'I'.
          ls_dates-option = 'BT'.
          ls_dates-low = '00000000'.
          ls_dates-high = i_filters-date_to.
          APPEND ls_dates TO lr_dates.
        ENDIF.
      ENDIF.

      IF i_filters-aufnr IS NOT INITIAL.

        ls_aufnr-sign = 'I'.
        ls_aufnr-option = 'CP'.
        CONCATENATE '*' i_filters-aufnr '*' INTO ls_aufnr-low.

        APPEND ls_aufnr TO lr_aufnr.
      ENDIF.

* get deleted orders for exclusion
      SELECT a~aufnr       AS aufnr
       INTO CORRESPONDING FIELDS OF TABLE @lt_deleted_orders
       FROM aufk AS a
        INNER JOIN afih                 AS b ON a~aufnr = b~aufnr
        LEFT OUTER JOIN iloa            AS i ON b~iloan = i~iloan
        INNER JOIN jest                 AS c ON c~objnr = a~objnr
       WHERE a~aufnr IN @lr_aufnr
         AND a~auart IN @lr_order_type
         AND b~addat IN @lr_dates
* Functional Location and it's description
         AND ( b~equnr IN @lr_equipment OR i~tplnr IN @lr_equipment )
*         AND ( c~stat  EQ 'I0076' OR c~stat EQ 'I0043' ) "deleted or locked
         AND c~stat  EQ 'I0076' "deleted
         AND c~inact EQ @space.

* create range for exclusion
      LOOP AT lt_deleted_orders INTO ls_deleted_orders.

        ls_aufnr-sign = 'E'.
        ls_aufnr-option = 'EQ'.
        ls_aufnr-low = ls_deleted_orders-aufnr.

        APPEND ls_aufnr TO lr_aufnr.
        CLEAR: ls_deleted_orders, ls_aufnr.
      ENDLOOP.


*--------------------------------------------
*--------------------------------------------
*        Get Orders in list Info
*--------------------------------------------
*--------------------------------------------

      lv_where_ini = ' NOT EXISTS ( SELECT * FROM jest WHERE jest~objnr = a~objnr'.

      lv_stat_blocked     = abap_false.
      lv_stat_closed      = abap_false.
      lv_stat_processing  = abap_false.
      lv_stat_released    = abap_false.
      lv_stat_open        = abap_false.
      lv_stat_stoped      = abap_false.
      lv_stat_others      = abap_false.

      "STATUS => CLOSED
      IF i_filters-stat_closed EQ abap_true.

        CALL METHOD get_parameter
          EXPORTING
            i_werks     = i_inputobj-werks
            i_parameter = 'EXCLUDE_CLOSED'
          IMPORTING
            et_range    = ra_exclude_closed.

        IF ra_exclude_closed IS NOT INITIAL.
          CONCATENATE lv_where_ini ' OR jest~stat IN @ra_exclude_closed'
                INTO lv_where.
        ENDIF.

        lv_stat_closed = abap_true.

      ENDIF.

      "STATUS => PROCESSING
      IF i_filters-stat_processing EQ abap_true.

        CALL METHOD get_parameter
          EXPORTING
            i_werks     = i_inputobj-werks
            i_parameter = 'EXCLUDE_PROCESSING'
          IMPORTING
            et_range    = ra_exclude_proc.

        IF ra_exclude_proc IS NOT INITIAL.
          IF lv_where IS INITIAL.
            CONCATENATE lv_where_ini ' ( jest~stat IN @ra_exclude_proc'
                  INTO lv_where.
          ELSE.
            CONCATENATE lv_where ' OR jest~stat IN @ra_exclude_proc' INTO lv_where.
          ENDIF.
        ENDIF.

        lv_stat_processing = abap_true.

      ENDIF.

      "STATUS => RELEASED
      IF i_filters-stat_released EQ abap_true.

        CALL METHOD get_parameter
          EXPORTING
            i_werks     = i_inputobj-werks
            i_parameter = 'EXCLUDE_OPEN'
          IMPORTING
            et_range    = ra_exclude_open.

        IF ra_exclude_open IS NOT INITIAL.
          IF lv_where IS INITIAL.
            CONCATENATE lv_where_ini ' ( jest~stat IN @ra_exclude_open'
              INTO lv_where.
          ELSE.
            CONCATENATE lv_where ' OR jest~stat IN @ra_exclude_open' INTO lv_where.
          ENDIF.
        ENDIF.

        lv_stat_open = abap_true.

      ENDIF.

      IF lv_where IS NOT INITIAL.
        CONCATENATE lv_where ' ) AND jest~inact EQ @space ' INTO lv_where.
      ENDIF.

      SELECT a~aufnr       AS aufnr,
          a~auart       AS auart,
          a~ktext       AS aufnr_t,
          b~equnr       AS equnr,
          b~priok       AS priok,
          b~addat       AS addat,
          b~aduhr       AS aduhr,
          afvc~pernr    AS technician,
          e~equnr       AS mach_equnr,
          b~iwerk       AS div_planif,
          crhd~arbpl    AS wkctr_maint,
          afko~gltrp    AS maint_end_date,
          afko~gluzp    AS maint_end_time
        APPENDING CORRESPONDING FIELDS OF TABLE @et_orders_list
        FROM aufk AS a
         INNER JOIN afih                 AS b ON a~aufnr = b~aufnr
         INNER JOIN afko                 AS afko ON a~aufnr = afko~aufnr
         LEFT OUTER JOIN eqkt            AS eqkt ON eqkt~equnr = b~equnr
         LEFT OUTER JOIN equi            AS equi ON equi~equnr = b~equnr
         LEFT OUTER JOIN iloa            AS i ON b~iloan = i~iloan
         LEFT OUTER JOIN iflotx          AS ix ON ix~tplnr = i~tplnr
         INNER JOIN afvc                 AS afvc ON afvc~aufpl  = afko~aufpl
         LEFT OUTER JOIN objk            AS e ON e~obknr = b~obknr
         INNER JOIN crhd                    ON crhd~objid = b~gewrk AND crhd~objty = 'A'
         LEFT OUTER JOIN fleet           AS fleet ON fleet~objnr = equi~objnr
        WHERE a~aufnr IN @lr_aufnr
         AND a~werks = @i_inputobj-werks " CFB 08.10.2018 add werks of user in shopfloor conf
         AND a~auart IN @lr_order_type
         AND b~addat IN @lr_dates
         AND ( b~equnr IN @lr_equipment OR i~tplnr IN @lr_equipment )
         AND (
               ( eqkt~eqktu IN @lr_description AND eqkt~spras IN @lr_spras )
                OR
               ( fleet~license_num IN @lr_description )
                OR
               ( ix~pltxu IN @lr_description AND ix~spras IN @lr_spras )
              )
         AND afvc~pernr IN @lr_technician
     "    AND afvc~vornr EQ @lv_first_operation   BMR 06.09.2017 - not relevant for CIMO
         AND (lv_where) .

    ENDIF.


*--------------------------------------------
*--------------------------------------------
*   Get Informations for the Orders in list
*--------------------------------------------
*--------------------------------------------
    CHECK et_orders_list IS NOT INITIAL.

    SORT et_orders_list BY aufnr.
    DELETE ADJACENT DUPLICATES FROM et_orders_list COMPARING aufnr.

*>> get status
    MOVE-CORRESPONDING et_orders_list TO lt_orders_status_in.

    CALL METHOD zcl_absf_pm=>get_orders_status
      EXPORTING
        i_werks           = i_inputobj-werks
        i_stat_blocked    = lv_stat_blocked
        i_stat_closed     = lv_stat_closed
        i_stat_processing = lv_stat_processing
        i_stat_released   = lv_stat_released
        i_stat_open       = lv_stat_open
        i_stat_stoped     = lv_stat_stoped
        i_stat_others     = lv_stat_others
        it_orders_list    = lt_orders_status_in
      IMPORTING
        et_orders_list    = lt_orders_status_out.


*>> get status description
    SELECT * FROM equi INTO TABLE @DATA(lt_equipments)
      FOR ALL ENTRIES IN @et_orders_list
      WHERE equnr = @et_orders_list-equnr.

*>> equipment description
    SELECT * FROM eqkt INTO TABLE @DATA(lt_equi_txt)
      FOR ALL ENTRIES IN @et_orders_list
      WHERE equnr = @et_orders_list-equnr
      AND spras = @sy-langu.

    IF sy-subrc NE 0 AND l_alt_spras NE sy-langu.
      SELECT * FROM eqkt INTO TABLE @lt_equi_txt
       FOR ALL ENTRIES IN @et_orders_list
       WHERE equnr = @et_orders_list-equnr
       AND spras = @l_alt_spras.
    ENDIF.

*>> get license plate of equipment from fleet
    SELECT equi~equnr, fleet~license_num
      INTO TABLE @DATA(lt_fleet)
      FROM equi AS equi
      LEFT OUTER JOIN fleet AS fleet ON fleet~objnr = equi~objnr
      FOR ALL ENTRIES IN @et_orders_list
    WHERE equi~equnr = @et_orders_list-equnr.


*>> order type description
    SELECT * FROM t003p INTO TABLE @DATA(lt_auart_txt)
      FOR ALL ENTRIES IN @et_orders_list
      WHERE auart = @et_orders_list-auart
      AND spras = @sy-langu.

    IF sy-subrc NE 0 AND l_alt_spras NE sy-langu.
      SELECT * FROM t003p INTO TABLE @lt_auart_txt
        FOR ALL ENTRIES IN @et_orders_list
        WHERE auart = @et_orders_list-auart
        AND spras = @l_alt_spras.
    ENDIF.


*>> order priority description
    SELECT afih~aufnr, t356_t~artpr, t356_t~priok, t356_t~priokx INTO TABLE @DATA(lt_priok_txt)
      FROM t356_t
        INNER JOIN afih ON afih~artpr = t356_t~artpr AND afih~priok = t356_t~priok
      FOR ALL ENTRIES IN @et_orders_list
      WHERE afih~aufnr = @et_orders_list-aufnr
      AND spras = @sy-langu.

    IF sy-subrc NE 0 AND l_alt_spras NE sy-langu.
      SELECT afih~aufnr, t356_t~artpr, t356_t~priok, t356_t~priokx INTO TABLE @lt_priok_txt
      FROM t356_t
        INNER JOIN afih ON afih~artpr = t356_t~artpr AND afih~priok = t356_t~priok
      FOR ALL ENTRIES IN @et_orders_list
      WHERE afih~aufnr = @et_orders_list-aufnr
        AND spras = @l_alt_spras.
    ENDIF.


*>> order system status
    SELECT * FROM tj02t INTO TABLE @DATA(lt_status_txt)
      FOR ALL ENTRIES IN @lt_orders_status_out
      WHERE istat = @lt_orders_status_out-status
      AND  spras = @sy-langu.

    IF sy-subrc NE 0 AND l_alt_spras NE sy-langu.
      SELECT * FROM tj02t INTO TABLE @lt_status_txt
          FOR ALL ENTRIES IN @et_orders_list
          WHERE istat = @et_orders_list-status
          AND  spras = @l_alt_spras.
    ENDIF.

*>> operator full name
    SELECT * FROM pa0002 INTO TABLE @DATA(lt_names)
      FOR ALL ENTRIES IN @et_orders_list
      WHERE pernr = @et_orders_list-technician.

*>> ZMLD: Machine equipment description
    SELECT equnr, eqktx FROM eqkt INTO TABLE @DATA(lt_mach_equi_txt)
      FOR ALL ENTRIES IN @et_orders_list
      WHERE equnr = @et_orders_list-mach_equnr
      AND spras = @sy-langu.

    IF sy-subrc NE 0 AND l_alt_spras NE sy-langu.
      SELECT equnr, eqktx FROM eqkt INTO TABLE @lt_mach_equi_txt
       FOR ALL ENTRIES IN @et_orders_list
       WHERE equnr = @et_orders_list-mach_equnr
       AND spras = @l_alt_spras.
    ENDIF.

* Functional Location and it's description
    SELECT a~aufnr, i~tplnr, ix~pltxt INTO TABLE @DATA(lt_func_loc)
      FROM iloa AS i
        INNER JOIN afih AS a ON a~iloan = i~iloan
        INNER JOIN iflotx AS ix ON ix~tplnr = i~tplnr
      FOR ALL ENTRIES IN @et_orders_list
      WHERE a~aufnr = @et_orders_list-aufnr
            AND ix~spras = @sy-langu.

    IF sy-subrc NE 0 AND l_alt_spras NE sy-langu.
      SELECT a~aufnr, i~tplnr, ix~pltxt INTO TABLE @lt_func_loc
        FROM iloa AS i
          INNER JOIN afih AS a ON a~iloan = i~iloan
          INNER JOIN iflotx AS ix ON ix~tplnr = i~tplnr
         FOR ALL ENTRIES IN @et_orders_list
         WHERE a~aufnr = @et_orders_list-aufnr
              AND ix~spras = @l_alt_spras.
    ENDIF.


* Order total costs
*    SELECT aufk~aufnr, coep~kokrs, coep~belnr, coep~buzei, coep~objnr, coep~wkgbtr
*      INTO TABLE @DATA(lt_costs_2)
*      FROM coep
*        INNER JOIN aufk ON aufk~objnr = coep~objnr
*      FOR ALL ENTRIES IN @et_orders_list
*      WHERE aufk~aufnr = @et_orders_list-aufnr
*            AND coep~wrttp = '04'
*            AND ( coep~beknz = 'S' OR coep~beknz = 'H' ).
*
*    LOOP AT lt_costs_2 INTO DATA(ls_costs_2).
*      MOVE-CORRESPONDING ls_costs_2 TO ls_costs.
*      COLLECT ls_costs INTO lt_costs.
*    ENDLOOP.
*    SORT lt_costs BY aufnr.

**"Prepare summarized cost based on list of Orders
**      DATA:
**        "Exporting table
**        lt_e_pmco     TYPE          cl_olc_report_tools=>ty_t_pmco,
**        "Collect AUFNR
**        lt_aufnr      TYPE          cl_olc_report_tools=>ty_t_aufnr,
**        ls_aufnr_1      LIKE LINE OF  lt_aufnr..
**
**      ls_aufnr_1-aufnr = '000006015520'.
**      APPEND ls_aufnr_1 TO lt_aufnr.
**
**      CALL METHOD cl_olc_report_tools=>make_header_costs_from_op
**        EXPORTING
**          it_aufnr = lt_aufnr
**        CHANGING
**          ct_pmco  = lt_e_pmco.

*    ENDIF.


    LOOP AT et_orders_list ASSIGNING <fs_et_orders_list>.

**>> status
      READ TABLE lt_orders_status_out INTO DATA(ls_orders_status_out)
        WITH KEY aufnr = <fs_et_orders_list>-aufnr.
      IF sy-subrc EQ 0.
        <fs_et_orders_list>-status = ls_orders_status_out-status.
        <fs_et_orders_list>-status_proc = ls_orders_status_out-status_proc.


        READ TABLE lt_status_txt INTO DATA(ls_status_txt)
          WITH KEY istat = <fs_et_orders_list>-status.
        <fs_et_orders_list>-status_t = ls_status_txt-txt30.

*>> equipment
        READ TABLE lt_equi_txt INTO DATA(ls_equi_txt) WITH KEY equnr = <fs_et_orders_list>-equnr.
        <fs_et_orders_list>-eqktx = ls_equi_txt-eqktx.

*       CFB 17.10.2018 - Get License Plate from fleet
        READ TABLE lt_fleet INTO DATA(ls_fleet) WITH KEY equnr = <fs_et_orders_list>-equnr.
        IF sy-subrc = 0.
          <fs_et_orders_list>-license_num = ls_fleet-license_num.
        ENDIF.

*>> order type
        READ TABLE lt_auart_txt INTO DATA(ls_auart_txt) WITH KEY auart = <fs_et_orders_list>-auart.
        <fs_et_orders_list>-auart = ls_auart_txt-auart.

*>> order priok description
        READ TABLE lt_priok_txt INTO DATA(ls_priok_txt) WITH KEY aufnr = <fs_et_orders_list>-aufnr.
        <fs_et_orders_list>-priok_t = ls_priok_txt-priokx.

*>> name
        READ TABLE lt_names INTO DATA(ls_names) WITH KEY pernr = <fs_et_orders_list>-technician.
        <fs_et_orders_list>-uname = ls_names-cname.

*>> is moulde?
        READ TABLE lt_equipments INTO DATA(ls_equipments) WITH KEY equnr = <fs_et_orders_list>-equnr.
        IF ls_equipments-eqtyp IN ra_eqtyp.
          <fs_et_orders_list>-is_molde = abap_true.
        ENDIF.

*>> ZMLD: machine equipment
        READ TABLE lt_mach_equi_txt INTO DATA(ls_mach_equi_txt) WITH KEY equnr = <fs_et_orders_list>-mach_equnr.
        IF sy-subrc = 0.
          <fs_et_orders_list>-mach_eqktx = ls_mach_equi_txt-eqktx.
        ENDIF.

*>>  Functional Location and it's description
        READ TABLE lt_func_loc INTO DATA(ls_func_loc) WITH KEY aufnr = <fs_et_orders_list>-aufnr.
        IF sy-subrc = 0.
          <fs_et_orders_list>-func_loc = ls_func_loc-tplnr.
          <fs_et_orders_list>-func_loc_tx = ls_func_loc-pltxt.
        ENDIF.

*>>  Costs

        CLEAR: lv_aufnr, lv_objnr.

        CLEAR ls_costs.
        READ TABLE lt_costs INTO ls_costs WITH KEY aufnr = <fs_et_orders_list>-aufnr
          BINARY SEARCH.
        IF sy-subrc = 0.
          <fs_et_orders_list>-total_costs = ls_costs-wkgbtr.
        ENDIF.


* Get current stage for ZMLD orders.
        IF i_filters-only_zmld EQ abap_true.

*          CALL METHOD zcl_pm02_shopfloor=>get_stages_mouldexch
*            EXPORTING
*              i_refdt         = sy-datlo
*              i_inputobj      = i_inputobj
*              i_equnr         = <fs_et_orders_list>-equnr
*              i_mach_equnr    = <fs_et_orders_list>-mach_equnr
*              i_aufnr         = <fs_et_orders_list>-aufnr
*            IMPORTING
*              e_current_stage = <fs_et_orders_list>-stage.

        ENDIF.

* Change icon of Mould Exchange Orders
        IF i_filters-only_zmld = abap_true     "Mould exchange
          AND ( ( <fs_et_orders_list>-status IN ra_istat_open )
             OR ( <fs_et_orders_list>-status IN ra_istat_proc ) ).

          CLEAR: lv_aufnr, lv_objectclas.

          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
            EXPORTING
              input  = <fs_et_orders_list>-aufnr
            IMPORTING
              output = lv_aufnr.

          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = 'ORDER'
            IMPORTING
              output = lv_objectclas.

          CONCATENATE '%' lv_aufnr INTO DATA(lv_objectid).

          CALL METHOD get_parameter
            EXPORTING
              i_werks     = i_inputobj-werks
              i_parameter = 'MOULD_EXCH_FIELDS_CH'
            IMPORTING
              et_range    = lr_change_fields.

          SELECT objectid INTO TABLE @DATA(lt_order_changed)
            FROM cdpos
            WHERE objectclas = @lv_objectclas
              AND objectid LIKE @lv_objectid
              AND fname IN @lr_change_fields.
          "AND ( fname = 'EQUNR' OR fname = 'TPLNR' OR fname = 'PPSID' OR fname = 'GSTRP' ).

          IF sy-subrc = 0.
            <fs_et_orders_list>-order_changed = abap_true.
          ELSE.
            <fs_et_orders_list>-order_changed = abap_false.
          ENDIF.
        ENDIF.

        IF <fs_et_orders_list>-maint_end_time = '240000'.
          <fs_et_orders_list>-maint_end_time = <fs_et_orders_list>-maint_end_time - 1.
        ENDIF.

        IF <fs_et_orders_list>-aduhr = '240000'.
          <fs_et_orders_list>-aduhr = <fs_et_orders_list>-aduhr - 1.
        ENDIF.

      ELSE.
        DELETE et_orders_list WHERE aufnr = <fs_et_orders_list>-aufnr.
      ENDIF.

      CLEAR: ls_equi_txt, ls_auart_txt, ls_names, ls_mach_equi_txt, ls_func_loc,
             ls_status_txt.

    ENDLOOP.

*Sort table by PRIOK and remove duplicates when priok = ''

*>> Delete aufnr duplicates when priok = ''.
    lt_et_orders_list_aux = et_orders_list.
    DELETE lt_et_orders_list_aux WHERE priok IS NOT INITIAL.
    SORT lt_et_orders_list_aux  BY aufnr ASCENDING.
    DELETE ADJACENT DUPLICATES FROM lt_et_orders_list_aux  COMPARING aufnr.
    SORT lt_et_orders_list_aux BY addat ASCENDING aduhr ASCENDING.
*<<<


    DELETE et_orders_list WHERE priok EQ space.
    APPEND LINES OF lt_et_orders_list_aux TO et_orders_list.
    SORT et_orders_list BY addat ASCENDING aduhr ASCENDING priok ASCENDING.
    DELETE ADJACENT DUPLICATES FROM et_orders_list COMPARING aufnr.

*>>  Only return Orders with functional location filled
    IF i_filters-stat_func_loc EQ abap_true.

      DELETE et_orders_list WHERE func_loc IS INITIAL.

    ENDIF.


  ENDMETHOD.


  METHOD get_pm_orders_mould_exchange.

    DATA: lr_order_type    TYPE rsis_t_range,
          ls_dates         TYPE rsis_s_range,
          lr_dates         TYPE rsis_t_range,
          lr_change_fields TYPE rsis_t_range.

    DATA: lt_et_orders_list_aux TYPE zabsf_pm_t_order_list.
    DATA: lv_date_low          TYPE syst_datum.
    DATA: lv_date_high         TYPE syst_datum.

    DATA: ra_stat_open  TYPE RANGE OF j_status,
          ra_stat_proc  TYPE RANGE OF j_status,
          lv_objectclas TYPE cdobjectcl,
          lv_aufnr      TYPE aufnr.

    FIELD-SYMBOLS <fs_et_orders_list> TYPE zabsf_pm_s_order_list.

*>> get default language
    SELECT SINGLE spras
      FROM zabsf_languages
      INTO (@DATA(l_alt_spras))
     WHERE werks      EQ @i_inputobj-werks
       AND is_default EQ @abap_true.

*>> order type Mould exchange
    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_inputobj-werks
        i_parameter = 'AUFART_MOULD_EXCH'
      IMPORTING
        et_range    = lr_order_type.

*>>> CBC - CR13.6 - 31.03.2017
    IF i_date_start IS INITIAL.
      SELECT SINGLE parva
        INTO @DATA(lv_per_back)
        FROM zabsf_pm_param
       WHERE werks = @i_inputobj-werks
         AND parid = 'MOULD_EXCHG_BACK'.

      lv_per_back = lv_per_back * 7.
      lv_date_low = sy-datlo - lv_per_back.
    ELSE.
      lv_date_low = i_date_start.
    ENDIF.

    IF i_date_end IS INITIAL.
      SELECT SINGLE parva
         INTO @DATA(lv_per_fw)
         FROM zabsf_pm_param
        WHERE werks = @i_inputobj-werks
          AND parid = 'MOULD_EXCHG_FW'.

      lv_per_fw   = lv_per_fw * 7.
      lv_date_high = sy-datlo + lv_per_fw.
    ELSE.
      lv_date_high = i_date_end.
    ENDIF.

*    SELECT SINGLE parva
*      INTO @DATA(lv_per_back)
*      FROM ZABSF_PM_param
*     WHERE werks = @i_inputobj-werks
*       AND parid = 'MOULD_EXCHG_BACK'.
*
*    SELECT SINGLE parva
*      INTO @DATA(lv_per_fw)
*      FROM ZABSF_PM_param
*     WHERE werks = @i_inputobj-werks
*       AND parid = 'MOULD_EXCHG_FW'.
*
*
*    lv_per_back = lv_per_back * 7.
*
*    lv_per_fw   = lv_per_fw * 7.
*
*    lv_date_low = sy-datlo - lv_per_back.
*
*    lv_date_high = sy-datlo + lv_per_fw.
*
    ls_dates-sign = 'I'.
    ls_dates-option = 'BT'.
    ls_dates-low = lv_date_low.
    ls_dates-high = lv_date_high.
    APPEND ls_dates TO lr_dates.

*<<< CBC - CR13.6 - 31.03.2017

    SELECT aufk~aufnr    AS aufnr,
           aufk~auart    AS auart,
           aufk~ktext    AS aufnr_t,
           afih~equnr    AS equnr,
           afih~priok    AS priok,
           afih~addat    AS addat,
           afih~aduhr    AS aduhr,
           jest~stat     AS status,
           afvc~pernr    AS technician,
           objk~equnr    AS mach_equnr
 	    INTO CORRESPONDING FIELDS OF TABLE @et_orders_list
      FROM aufk INNER JOIN afih   ON aufk~aufnr = afih~aufnr
                INNER JOIN afko   ON aufk~aufnr = afko~aufnr
                INNER JOIN jest   ON jest~objnr = aufk~objnr
                INNER JOIN afvc   ON afvc~aufpl = afko~aufpl
                LEFT JOIN objk    ON objk~obknr = afih~obknr
     WHERE aufk~auart IN @lr_order_type
       AND afih~addat IN @lr_dates
       AND jest~inact EQ @space
       AND jest~stat  IN ('I0001','I0002')
 	     AND afvc~vornr EQ '1000'. "get first operation for all orders
*       AND NOT EXISTS ( SELECT *
*                          FROM jest
*                         WHERE objnr = aufk~objnr
*                           AND stat  IN ('I0076', 'I0043' ) "deleted or locked
*                           AND inact EQ @space ).

    CHECK et_orders_list IS NOT INITIAL.

    SELECT * FROM equi INTO TABLE @DATA(lt_equipments)
      FOR ALL ENTRIES IN @et_orders_list
      WHERE equnr = @et_orders_list-equnr.

*>> equipment description
    SELECT * FROM eqkt INTO TABLE @DATA(lt_equi_txt)
      FOR ALL ENTRIES IN @et_orders_list
      WHERE equnr = @et_orders_list-equnr
      AND spras = @sy-langu.

    IF sy-subrc NE 0 AND l_alt_spras NE sy-langu.

      SELECT * FROM eqkt INTO TABLE @lt_equi_txt
       FOR ALL ENTRIES IN @et_orders_list
       WHERE equnr = @et_orders_list-equnr
       AND spras = @l_alt_spras.

    ENDIF.

*>> order type description
    SELECT * FROM t003p INTO TABLE @DATA(lt_auart_txt)
      FOR ALL ENTRIES IN @et_orders_list
      WHERE auart = @et_orders_list-auart
      AND spras = @sy-langu.

    IF sy-subrc NE 0 AND l_alt_spras NE sy-langu.
      SELECT * FROM t003p INTO TABLE @lt_auart_txt
        FOR ALL ENTRIES IN @et_orders_list
        WHERE auart = @et_orders_list-auart
        AND spras = @l_alt_spras.
    ENDIF.

*>> status description
    SELECT * FROM tj02t INTO TABLE @DATA(lt_status_txt)
      FOR ALL ENTRIES IN @et_orders_list
      WHERE istat = @et_orders_list-status
      AND  spras = @sy-langu.

    IF sy-subrc NE 0 AND l_alt_spras NE sy-langu.

      SELECT * FROM tj02t INTO TABLE @lt_status_txt
          FOR ALL ENTRIES IN @et_orders_list
          WHERE istat = @et_orders_list-status
          AND  spras = @l_alt_spras.
    ENDIF.

*>> operator full name
    SELECT * FROM pa0002 INTO TABLE @DATA(lt_names)
      FOR ALL ENTRIES IN @et_orders_list
      WHERE pernr = @et_orders_list-technician.

*>> ZMLD: Machine equipment description
    SELECT equnr, eqktx FROM eqkt INTO TABLE @DATA(lt_mach_equi_txt)
      FOR ALL ENTRIES IN @et_orders_list
      WHERE equnr = @et_orders_list-mach_equnr
      AND spras = @sy-langu.

    IF sy-subrc NE 0 AND l_alt_spras NE sy-langu.
      SELECT equnr, eqktx FROM eqkt INTO TABLE @lt_mach_equi_txt
       FOR ALL ENTRIES IN @et_orders_list
       WHERE equnr = @et_orders_list-mach_equnr
       AND spras = @l_alt_spras.
    ENDIF.

* Functional Location and it's description
    SELECT a~aufnr, i~tplnr, ix~pltxt INTO TABLE @DATA(lt_func_loc)
      FROM iloa AS i
        INNER JOIN afih AS a ON a~iloan = i~iloan
        INNER JOIN iflotx AS ix ON ix~tplnr = i~tplnr
      FOR ALL ENTRIES IN @et_orders_list
      WHERE a~aufnr = @et_orders_list-aufnr
            AND ix~spras = @sy-langu.

    IF sy-subrc NE 0 AND l_alt_spras NE sy-langu.
      SELECT a~aufnr, i~tplnr, ix~pltxt INTO TABLE @lt_func_loc
        FROM iloa AS i
          INNER JOIN afih AS a ON a~iloan = i~iloan
          INNER JOIN iflotx AS ix ON ix~tplnr = i~tplnr
         FOR ALL ENTRIES IN @et_orders_list
         WHERE a~aufnr = @et_orders_list-aufnr
              AND ix~spras = @l_alt_spras.
    ENDIF.


* get status from ZABSF_PM_STATUS.
    SELECT * FROM zabsf_pm_status INTO TABLE @DATA(lt_zabsf_pm)
      FOR ALL ENTRIES IN @et_orders_list
      WHERE aufnr = @et_orders_list-aufnr.

    LOOP AT et_orders_list ASSIGNING <fs_et_orders_list>.
*>> order_status
      READ TABLE lt_zabsf_pm INTO DATA(ls_zabsf_pm) WITH KEY aufnr = <fs_et_orders_list>-aufnr.
      IF sy-subrc EQ 0.
        <fs_et_orders_list>-status_proc = ls_zabsf_pm-status.
      ENDIF.
*>> equipment
      READ TABLE lt_equi_txt INTO DATA(ls_equi_txt) WITH KEY equnr = <fs_et_orders_list>-equnr.
      <fs_et_orders_list>-eqktx = ls_equi_txt-eqktx.
*>> order type
      READ TABLE lt_auart_txt INTO DATA(ls_auart_txt) WITH KEY auart = <fs_et_orders_list>-auart.
      <fs_et_orders_list>-auart = ls_auart_txt-auart.
*>> status
      READ TABLE lt_status_txt INTO DATA(ls_status_txt) WITH KEY istat = <fs_et_orders_list>-status.
      <fs_et_orders_list>-status_t = ls_status_txt-txt30.
*>> name
      READ TABLE lt_names INTO DATA(ls_names) WITH KEY pernr = <fs_et_orders_list>-technician.
      <fs_et_orders_list>-uname = ls_names-cname.
*>> ZMLD: machine equipment
      READ TABLE lt_mach_equi_txt INTO DATA(ls_mach_equi_txt) WITH KEY equnr = <fs_et_orders_list>-mach_equnr.
      IF sy-subrc = 0.
        <fs_et_orders_list>-mach_eqktx = ls_mach_equi_txt-eqktx.
      ENDIF.
*>>  Functional Location and it's description
      READ TABLE lt_func_loc INTO DATA(ls_func_loc) WITH KEY aufnr = <fs_et_orders_list>-aufnr.
      IF sy-subrc = 0.
        <fs_et_orders_list>-func_loc = ls_func_loc-tplnr.
        <fs_et_orders_list>-func_loc_tx = ls_func_loc-pltxt.
      ENDIF.

* Change icon of Mould Exchange Orders

      CALL METHOD get_parameter
        EXPORTING
          i_werks     = i_inputobj-werks
          i_parameter = 'ISTAT_OPEN'
        IMPORTING
          et_range    = ra_stat_open.

      CALL METHOD get_parameter
        EXPORTING
          i_werks     = i_inputobj-werks
          i_parameter = 'ISTAT_PROC'
        IMPORTING
          et_range    = ra_stat_proc.

      IF ( ( <fs_et_orders_list>-status IN ra_stat_open )
           OR ( <fs_et_orders_list>-status IN ra_stat_proc ) ).

        CLEAR: lv_aufnr, lv_objectclas.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            input  = <fs_et_orders_list>-aufnr
          IMPORTING
            output = lv_aufnr.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = 'ORDER'
          IMPORTING
            output = lv_objectclas.

        CONCATENATE '%' lv_aufnr INTO DATA(lv_objectid).

*>> BMR INSERT 03.05.2017 - get values from param table for CDPOS select.
        CALL METHOD get_parameter
          EXPORTING
            i_werks     = i_inputobj-werks
            i_parameter = 'MOULD_EXCH_FIELDS_CH'
          IMPORTING
            et_range    = lr_change_fields.
*<< BMR END INSERT 03.05.2017

        SELECT objectid INTO TABLE @DATA(lt_order_changed)
          FROM cdpos
          WHERE objectclas = @lv_objectclas
            AND objectid LIKE @lv_objectid
           " AND ( fname = 'EQUNR' OR fname = 'TPLNR' OR fname = 'PPSID' OR fname = 'GSTRP' ).
            AND fname IN @lr_change_fields.

        IF sy-subrc = 0.
          <fs_et_orders_list>-order_changed = abap_true.
        ELSE.
          <fs_et_orders_list>-order_changed = abap_false.
        ENDIF.
      ENDIF.

      CLEAR: ls_equi_txt, ls_auart_txt, ls_status_txt, ls_names, ls_mach_equi_txt,
             ls_func_loc.

    ENDLOOP.

*Sort table
    LOOP AT et_orders_list ASSIGNING <fs_et_orders_list>
      WHERE priok IS INITIAL.

      APPEND <fs_et_orders_list> TO lt_et_orders_list_aux.
    ENDLOOP.

    DELETE et_orders_list WHERE priok EQ space.

*>> Delete aufnr duplicates.
    SORT et_orders_list BY aufnr ASCENDING.
    DELETE ADJACENT DUPLICATES FROM et_orders_list COMPARING aufnr.
*<<<

    SORT et_orders_list BY addat ASCENDING aduhr ASCENDING priok ASCENDING.

*>> Delete aufnr duplicates.
    SORT lt_et_orders_list_aux  BY aufnr ASCENDING.
    DELETE ADJACENT DUPLICATES FROM lt_et_orders_list_aux  COMPARING aufnr.
*<<<

    SORT lt_et_orders_list_aux BY addat ASCENDING aduhr ASCENDING.

    APPEND LINES OF lt_et_orders_list_aux TO et_orders_list.

    DELETE ADJACENT DUPLICATES FROM et_orders_list COMPARING aufnr.

* Get current stage for ZMLD orders.
    LOOP AT et_orders_list ASSIGNING <fs_et_orders_list>.

      CALL METHOD zcl_absf_pm=>get_stages_mouldexch
        EXPORTING
          i_refdt         = sy-datlo
          i_inputobj      = i_inputobj
          i_equnr         = <fs_et_orders_list>-equnr
          i_mach_equnr    = <fs_et_orders_list>-mach_equnr
          i_aufnr         = <fs_et_orders_list>-aufnr
        IMPORTING
          e_current_stage = <fs_et_orders_list>-stage.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_pm_planner_groups.
*>>>DGG 19/07/2017 - Get list of maintenance planner groups

    DATA : ra_iwerk TYPE rsis_t_range,
           ls_iwerk TYPE rsis_s_range.

    DATA : ra_ingrp TYPE rsis_t_range,
           ls_ingrp TYPE rsis_s_range.

    ls_iwerk-sign = 'I'.
    ls_iwerk-option = 'CP'.
    CONCATENATE '*' i_iwerk '*' INTO ls_iwerk-low.
    APPEND ls_iwerk TO ra_iwerk.

    ls_ingrp-sign = 'I'.
    ls_ingrp-option = 'CP'.
    CONCATENATE '*' i_ingrp '*' INTO ls_ingrp-low.
    APPEND ls_ingrp TO ra_ingrp.

    SELECT t024i~iwerk t001w~name1 t024i~ingrp t024i~innam
      INTO CORRESPONDING FIELDS OF TABLE et_planner_groups
      FROM t024i
        INNER JOIN t001w ON t001w~werks = t024i~iwerk
      WHERE t024i~iwerk IN ra_iwerk
        AND t024i~ingrp IN ra_ingrp.

*<<<DGG 19/07/2017 - Get list of maintenance planner groups
  ENDMETHOD.


  METHOD get_priorities.

    DATA: lv_where TYPE char40.

    DATA: lv_parameter TYPE char20.
    DATA: ra_artpr TYPE RANGE OF artpr.

    FIELD-SYMBOLS : <fs_priorities> LIKE LINE OF et_priorities.

    SELECT SINGLE spras
      FROM zabsf_languages
      INTO @DATA(lv_alt_spras)
     WHERE werks      EQ @i_inputobj-werks
       AND is_default EQ @abap_true.

    CHECK i_artpr IS NOT INITIAL.

* determine priority type from ZABSF_PM_param

    CONCATENATE 'PRIORITY_TYPE_' i_artpr INTO lv_parameter.

    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_inputobj-werks
        i_parameter = lv_parameter
      IMPORTING
        et_range    = ra_artpr.

    CHECK ra_artpr IS NOT INITIAL.

*    IF ra_artpr IS NOT INITIAL.
*      lv_where = 't356~artpr in @ra_artpr'.
*    ENDIF.

    " GET FUNCTIONAL LOCATION
    SELECT t356~*, t356_t~priokx
      INTO CORRESPONDING FIELDS OF TABLE @et_priorities
      FROM t356
        INNER JOIN t356_t ON t356_t~artpr = t356~artpr
         AND t356~priok = t356_t~priok
      WHERE t356~artpr IN @ra_artpr
        AND t356_t~spras = @sy-langu.

    IF sy-subrc NE 0.

      SELECT t356~*, t356_t~priokx
      INTO CORRESPONDING FIELDS OF TABLE @et_priorities
      FROM t356
        INNER JOIN t356_t ON t356_t~artpr = t356~artpr
         AND t356~priok = t356_t~priok
       WHERE t356~artpr IN @ra_artpr
        AND t356_t~spras = @lv_alt_spras.

    ENDIF.

    LOOP AT et_priorities ASSIGNING <fs_priorities>.

      CALL FUNCTION 'CALCULATE_PRIORITY'
        EXPORTING
          i_artpr     = <fs_priorities>-artpr
          i_priok     = <fs_priorities>-priok
          i_flg_popup = space
          i_strmn     = sy-datum
        IMPORTING
          e_strmn     = <fs_priorities>-start_date
          e_strur     = <fs_priorities>-start_time
          e_ltrmn     = <fs_priorities>-end_date
          e_ltrur     = <fs_priorities>-end_time.

      IF <fs_priorities>-start_time = '240000'.
        <fs_priorities>-start_time = <fs_priorities>-start_time - 1.
      ENDIF.
      IF <fs_priorities>-end_time = '240000'.
        <fs_priorities>-end_time = <fs_priorities>-end_time - 1.
      ENDIF.

    ENDLOOP.


  ENDMETHOD.


  METHOD get_priority_calc.

    CALL FUNCTION 'CALCULATE_PRIORITY'
      EXPORTING
        i_artpr     = i_artpr
        i_priok     = i_priok
        i_flg_popup = space
        i_strmn     = sy-datum
      IMPORTING
        e_strmn     = e_priority_dates-start_date
        e_strur     = e_priority_dates-start_time
        e_ltrmn     = e_priority_dates-end_date
        e_ltrur     = e_priority_dates-end_time
        e_priokx    = e_priority_dates-priok_txt.

    IF e_priority_dates-start_time = '240000'.
      e_priority_dates-start_time = e_priority_dates-start_time - 1.
    ENDIF.
    IF e_priority_dates-end_time = '240000'.
      e_priority_dates-end_time = e_priority_dates-end_time - 1.
    ENDIF.

  ENDMETHOD.


  METHOD get_resp_userlist.

    DATA : ls_selection_range TYPE bapiussrge,
           lt_selection_range TYPE TABLE OF bapiussrge,
           lt_userlist        TYPE TABLE OF bapiusname,
           ls_userlist        TYPE bapiusname.

*
*
**DATA ARBPL       TYPE CRHD-ARBPL.
**DATA WERKS       TYPE CRHD-WERKS.
**DATA DATE        TYPE TIMELIST-DATE.
**DATA OUT_PERSONS TYPE STANDARD TABLE OF OBJECT_PERSON_ASSIGNMENT.
*
*    CALL FUNCTION 'CR_PERSONS_OF_WORKCENTER'
*      EXPORTING
*        arbpl                       = i_arbpl
*        werks                       = i_inputobj-werks
*        date                        = i_refdt
*      TABLES
*        out_persons                 = lt_out_persons
*      EXCEPTIONS
*        invalid_object              = 1
*        invalid_hr_planning_variant = 2
*        other_error                 = 3
*        OTHERS                      = 4.
*    IF sy-subrc <> 0.
** Implement suitable error handling here
*    ENDIF.
*
*
*    IF NOT lt_out_persons IS INITIAL.
*
*      LOOP AT lt_out_persons INTO DATA(ls_out_persons).
*
*
*        CLEAR ls_userlist.
*        SELECT SINGLE nachn AS lastname  vorna AS firstname cname AS fullname FROM pa0002
*       INTO CORRESPONDING FIELDS OF ls_userlist
*         WHERE pernr =  ls_out_persons-pernr AND
*              endda GE i_refdt.
*
*
**DATA PERSONNEL_NUMBER TYPE P0001-PERNR.
**DATA VALIDITY_DATE    TYPE SY-DATUM.
**DATA REACTION         TYPE SY-MSGTY.
**DATA USER_ID          TYPE USR02-BNAME.
**DATA SUBRC            TYPE SY-SUBRC.
**DATA ERROR_TABLE      TYPE STANDARD TABLE OF RPBENERR.
*
*        CALL FUNCTION 'HR_FBN_CONVERT_PERNR_TO_USERID'
*          EXPORTING
*            personnel_number = ls_out_persons-pernr
*            validity_date    = i_refdt
*            reaction         = 'X'
*          IMPORTING
*            user_id          = ls_userlist-username
*            subrc            = lv_subrc
*          TABLES
*            error_table      = lt_error_table.
*
*        APPEND ls_userlist TO lt_userlist.
*
*
*      ENDLOOP.
*
*    ENDIF.
*
*
*    et_userslist = lt_userlist.



    ls_selection_range-parameter = 'USERNAME'.
    MOVE 'I' TO ls_selection_range-sign.
    MOVE 'CP' TO ls_selection_range-option.
    CONCATENATE '*' i_usern '*' INTO DATA(lv_username).
    ls_selection_range-low = lv_username.
    APPEND ls_selection_range TO lt_selection_range.

    CALL FUNCTION 'BAPI_USER_GETLIST'
      EXPORTING
        with_username   = 'X'
      TABLES
        userlist        = et_userslist
        selection_range = lt_selection_range.


  ENDMETHOD.


  METHOD get_sales_docs_list.

    DATA: lv_where TYPE char40,
          lv_vbeln LIKE i_vbeln.

    DATA : vbeln_wild_card TYPE char40.

    SELECT SINGLE spras
      FROM zabsf_languages
      INTO @DATA(lv_alt_spras)
     WHERE werks      EQ @i_inputobj-werks
       AND is_default EQ @abap_true.


    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = i_vbeln
      IMPORTING
        output = lv_vbeln.

    IF i_vbeln IS NOT INITIAL.
      CONCATENATE '%' lv_vbeln '%' INTO vbeln_wild_card.
      lv_where = 'vbap~vbeln like @vbeln_wild_card'.
    ENDIF.


* get sales document and respective items
    SELECT vbap~vbeln, vbap~posnr, k~kunnr, k~name1
      INTO CORRESPONDING FIELDS OF TABLE @et_salesdoc
     FROM vbap
      INNER JOIN vbak AS v ON v~vbeln = vbap~vbeln
       LEFT JOIN kna1 AS k ON k~kunnr = v~kunnr

      WHERE (lv_where).


  ENDMETHOD.


  METHOD get_stages_mouldexch.

    TYPES: BEGIN OF ty_stages,
             stage TYPE int4,
           END OF ty_stages.

    CONSTANTS: lc_proc(4)      VALUE 'PROC',
               lc_conc(4)      VALUE 'CONC',
               lc_ini(4)       VALUE 'INI',
               lc_istat_ok(5)  VALUE 'E0002',
               lc_istat_ini(5) VALUE 'E0001'.


    DATA: lt_checklist  TYPE        zabsf_pm_t_checklist,
          ls_stages     TYPE        zabsf_pm_s_stages,
          lt_return     TYPE        bapiret2_t,
          lt_stages_int TYPE TABLE OF ty_stages,
          ls_stages_int TYPE ty_stages,
          ls_afru       TYPE afru,
          lt_status     TYPE TABLE OF jstat.

    DATA: lv_aufpl TYPE co_aufpl,
          lv_objnr TYPE j_objnr,
          ra_eqart TYPE RANGE OF eqart.

    FIELD-SYMBOLS: <fs_afru>        TYPE afru,
                   <fs_main_stages> TYPE zabsf_pm_s_stages.

* get moulde types.
    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_inputobj-werks
        i_parameter = 'MOULDE_EQART'
      IMPORTING
        et_range    = ra_eqart.

* get routing of PM order
    SELECT SINGLE aufpl FROM afko INTO lv_aufpl
      WHERE aufnr = i_aufnr.

    CALL METHOD zcl_absf_pm=>get_checklist
      EXPORTING
        i_inputobj     = i_inputobj
        pm_order       = i_aufnr
        checklist_step = space
      CHANGING
        checklist      = lt_checklist
        return_tab     = lt_return.

* get equipments of only mould type
    SELECT equz~equnr
      INTO TABLE @DATA(lt_mould)
      UP TO 1 ROWS
      FROM equz
      INNER JOIN equi ON equi~equnr = equz~equnr
     WHERE equz~hequi = @i_mach_equnr
      AND equz~datbi = '99991231'
      AND equi~eqart IN @ra_eqart.

    LOOP AT lt_checklist INTO DATA(ls_checklist).

      CLEAR ls_stages.
      ls_stages-vornr = ls_checklist-substepid.
      ls_stages-ltxa1 = ls_checklist-stepdesc.

      IF ls_checklist-substepid = '1000'.
        READ TABLE lt_mould INTO DATA(ls_mould) INDEX 1.
        ls_stages-equnr = ls_mould-equnr.
      ELSEIF ls_checklist-substepid = '2000'.
        ls_stages-equnr = i_equnr.
      ENDIF.

      APPEND ls_stages TO et_stages.
    ENDLOOP.

    CHECK et_stages IS NOT INITIAL.


    LOOP AT et_stages ASSIGNING <fs_main_stages>.

      ">>check if is confirmed
      SELECT SINGLE * FROM afru INTO @ls_afru
        WHERE aueru EQ @abap_true "final confirmation
        AND aufnr EQ @i_aufnr
        AND stokz EQ @space
        AND stzhl EQ @space
        AND vornr EQ @<fs_main_stages>-vornr.

      IF sy-subrc NE 0.
*>> read operation user status.

        SELECT SINGLE objnr FROM afvc INTO lv_objnr
          WHERE aufpl = lv_aufpl
          AND werks = i_inputobj-werks
          AND vornr = <fs_main_stages>-vornr
          AND sumnr = space.

        CALL FUNCTION 'STATUS_READ'
          EXPORTING
            client      = sy-mandt
            objnr       = lv_objnr
            only_active = abap_true
          TABLES
            status      = lt_status.

        IF sy-subrc <> 0.
* Implement suitable error handling here
        ENDIF.

        READ TABLE lt_status TRANSPORTING NO FIELDS WITH KEY stat = lc_istat_ini.
        IF sy-subrc EQ 0.
          <fs_main_stages>-status = lc_ini.
        ENDIF.

        READ TABLE lt_status TRANSPORTING NO FIELDS  WITH KEY stat = lc_istat_ok.
        IF sy-subrc EQ 0.
          <fs_main_stages>-status = lc_proc.
        ENDIF.

      ELSE.
        <fs_main_stages>-status = lc_conc.
      ENDIF.

    ENDLOOP.
*>> get last confirmed finished checklist stage
    SELECT * FROM afru INTO TABLE @DATA(lt_stages)
      FOR ALL ENTRIES IN @et_stages
      WHERE aueru EQ @abap_true "final confirmation
      AND aufnr EQ @i_aufnr
      AND stokz EQ @space
      AND stzhl EQ @space
      AND vornr EQ @et_stages-vornr.

    LOOP AT lt_stages ASSIGNING <fs_afru>.

      CALL FUNCTION 'CHAR_NUMC_CONVERSION'
        EXPORTING
          input   = <fs_afru>-vornr
        IMPORTING
          numcstr = ls_stages_int-stage.

      APPEND ls_stages_int TO lt_stages_int.
      CLEAR ls_stages_int.
    ENDLOOP.

    SORT lt_stages_int BY stage DESCENDING.
    READ TABLE lt_stages_int INTO ls_stages_int INDEX 1.
    IF sy-subrc EQ 0.

      SELECT SINGLE ltxa1 FROM afvc INTO e_current_stage
        WHERE aufpl = lv_aufpl
        AND vornr = ls_stages_int-stage.
    ENDIF.

  ENDMETHOD.


  METHOD get_variants.
*&---------------------------------------------------------------------*
*  CREATION:     23.06.2017 by Cidália Correia (CBC) - Abaco Consultores
*  DESCRIPTION:  Get the variants list for a given progran and user
*&--------------------------------------------------------------------*

    DATA: lv_sapuser      TYPE sysid,
          lv_where        TYPE char50,
          lt_varit        TYPE varit,
          lv_langu        TYPE spras,
          lv_default_name TYPE char40,
          lv_pernr        type pernr_d.

    FIELD-SYMBOLS: <e_var_info> TYPE zabsf_pm_s_variant.


    IF i_pernr IS NOT INITIAL.
*   Get SAP User from HR user (pernr)
      SELECT SINGLE usrid
          INTO lv_sapuser
        FROM pa0105
          WHERE pernr = i_pernr
            AND subty = '0001'
            AND endda >= sy-datum
            AND begda <= sy-datum.

* send error message!
      IF sy-subrc <> 0.
**      MESSAGE e024(ZABSF_PM).
*        CALL METHOD zcl_absf_pm=>add_message
*          EXPORTING
*            msgty      = 'W'
*            msgno      = '024'
*            msgv1      = i_pernr
*          CHANGING
*            return_tab = et_return.
      ELSE.
        lv_where = 'ename = @lv_sapuser'.
      ENDIF.
    ENDIF.


*    CHECK lv_sapuser IS NOT INITIAL.
    CHECK i_pernr IS NOT INITIAL.


*    CONCATENATE 'U_' lv_sapuser INTO lv_default_name.


    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = i_pernr
      IMPORTING
        output = lv_pernr.


    CONCATENATE 'U_' lv_pernr INTO lv_default_name.


*   Get Variant and it's description
    SELECT varid~variant, varit~vtext
      INTO CORRESPONDING FIELDS OF TABLE @e_var_info
      FROM varid
       LEFT OUTER JOIN varit ON varit~report  = varid~report
                            AND varit~variant = varid~variant
                            AND varit~langu  = @i_langu
      WHERE varid~report = @i_prog
        AND environmnt   = 'A'
*        AND ( (lv_where) OR varid~variant = @lv_default_name ) .
        AND ( (lv_where) OR varid~variant = @lv_default_name ) .


    IF sy-subrc NE  0.
*     Get alternative language
      SELECT SINGLE spras
        FROM zabsf_languages
        INTO lv_langu
       WHERE werks      = i_werks
         AND is_default <> space.

      IF sy-subrc EQ 0.
*   Get Variant and it's description in alternative language
        SELECT varid~variant, varit~vtext
          INTO CORRESPONDING FIELDS OF TABLE @e_var_info
          FROM varid
           LEFT OUTER JOIN varit ON varit~report  = varid~report
                                AND varit~variant = varid~variant
                                AND varit~langu  = @lv_langu
          WHERE varid~report = @i_prog
            AND environmnt   = 'A'
            AND ( (lv_where) OR varid~variant = @lv_default_name ).


      ENDIF.
    ENDIF.


    CHECK e_var_info IS NOT INITIAL.

    LOOP AT e_var_info ASSIGNING <e_var_info> WHERE variant = lv_default_name.
      <e_var_info>-is_default = abap_true.
      EXIT.
    ENDLOOP.


  ENDMETHOD.


  METHOD get_workcenters.

    TYPES: BEGIN OF ty_workcenter,
             objty TYPE cr_objty,
             objid TYPE cr_objid,
             arbpl TYPE arbpl,
             verwe TYPE ap_verwe,
             werks TYPE werks_d,
             name1 TYPE name1,
           END OF ty_workcenter.

    DATA: lt_crtx       TYPE TABLE OF crtx,
          lt_workcenter TYPE TABLE OF ty_workcenter,
          l_langu       TYPE sy-langu,
          ls_workcenter LIKE LINE OF et_workcenter,
          ls_crtx       TYPE crtx.

    DATA : lt_tc30t TYPE TABLE OF tc30t,
           ls_tc30t TYPE tc30t.

    DATA : ra_iwerk TYPE rsis_t_range,
           ls_iwerk TYPE rsis_s_range,
           ra_verwe TYPE rsis_t_range,
           ls_verwe TYPE rsis_s_range,
           ra_arbpl TYPE rsis_t_range,
           ls_arbpl TYPE rsis_s_range.

    DATA lv_arbpl TYPE arbpl.

    FIELD-SYMBOLS <fs_workcenter> TYPE ty_workcenter.

    DATA lv_iwerk type iwerk.

*   verify if i_iwerk is initial, if so we will use i_inputobj-werks instead

    if not i_iwerk is INITIAL.
      lv_iwerk = i_iwerk.
    else.
      lv_iwerk = i_inputobj-werks.
    endif.

*>>>DGG 19/07/2017 - get all if null
    CALL METHOD get_parameter
      EXPORTING
        i_werks     = lv_iwerk "i_inputobj-werks
        i_parameter = 'MAIN_PLANT'
      IMPORTING
        et_range    = ra_iwerk.

    IF ra_iwerk IS INITIAL.
      ls_iwerk-sign = 'I'.
      ls_iwerk-option = 'CP'.
      CONCATENATE '*' i_iwerk '*' INTO ls_iwerk-low.
      APPEND ls_iwerk TO ra_iwerk.
    ENDIF.

    CALL METHOD get_parameter
      EXPORTING
        i_werks     = lv_iwerk "i_inputobj-werks
        i_parameter = 'WORK_CENTER_CATEGORY'
      IMPORTING
        et_range    = ra_verwe.

    IF ra_verwe IS INITIAL.
      ls_verwe-sign = 'I'.
      ls_verwe-option = 'CP'.
      CONCATENATE '*' i_verwe '*' INTO ls_verwe-low.
      APPEND ls_verwe TO ra_verwe.
    ENDIF.


    IF i_arbpl IS NOT INITIAL.
      ls_arbpl-sign = 'I'.
      ls_arbpl-option = 'CP'.

      MOVE i_arbpl TO lv_arbpl.
      TRANSLATE lv_arbpl TO UPPER CASE.
      CONCATENATE '*' lv_arbpl '*' INTO ls_arbpl-low.

      APPEND ls_arbpl TO ra_arbpl.
    ENDIF.


    SELECT *
      INTO CORRESPONDING FIELDS OF TABLE lt_workcenter
      FROM crhd
      INNER JOIN t001w ON t001w~werks = crhd~werks
      WHERE  crhd~objty EQ 'A'
        AND crhd~begda LE sy-datlo
        AND crhd~endda GE sy-datlo
        AND crhd~werks IN ra_iwerk
        AND crhd~verwe IN ra_verwe
        AND crhd~lvorm NE abap_true "Not marked for delete
        AND crhd~arbpl IN ra_arbpl.

*<<<DGG 19/07/2017 - get all if null

    CHECK lt_workcenter IS NOT INITIAL.

*      Get Workcenter description
    SELECT *
      FROM crtx
      INTO CORRESPONDING FIELDS OF TABLE lt_crtx
       FOR ALL ENTRIES IN lt_workcenter
     WHERE objty EQ lt_workcenter-objty
       AND objid EQ lt_workcenter-objid
       AND spras EQ sy-langu.

    IF sy-subrc NE  0.
*        Get alternative language
      SELECT SINGLE spras
        FROM zabsf_languages
        INTO l_langu
       WHERE werks      EQ lv_iwerk "i_inputobj-werks
         AND is_default NE space.

      IF sy-subrc EQ 0.
*      Get Workcenter description
        SELECT *
          FROM crtx
          INTO CORRESPONDING FIELDS OF TABLE lt_crtx
           FOR ALL ENTRIES IN lt_workcenter
         WHERE objty EQ lt_workcenter-objty
           AND objid EQ lt_workcenter-objid
           AND spras EQ l_langu.

      ENDIF.
    ENDIF.

*     Get WorkCenter Category Description


    SELECT *
      FROM tc30t
      INTO CORRESPONDING FIELDS OF TABLE lt_tc30t
       FOR ALL ENTRIES IN lt_workcenter
     WHERE verwe EQ lt_workcenter-verwe
       AND spras EQ sy-langu.

    IF sy-subrc NE  0.
*        Get alternative language
      SELECT SINGLE spras
        FROM zabsf_languages
        INTO l_langu
       WHERE werks      EQ lv_iwerk "i_inputobj-werks
         AND is_default NE space.

      IF sy-subrc EQ 0.
*      Get Workcenter Category description
        SELECT *
      FROM tc30t
      INTO CORRESPONDING FIELDS OF TABLE lt_tc30t
       FOR ALL ENTRIES IN lt_workcenter
     WHERE verwe EQ lt_workcenter-verwe
       AND spras EQ l_langu.

      ENDIF.

    ENDIF.



    LOOP AT lt_workcenter ASSIGNING <fs_workcenter>.

      READ TABLE lt_crtx INTO ls_crtx WITH KEY objty = <fs_workcenter>-objty
                                                objid = <fs_workcenter>-objid.
      IF sy-subrc EQ 0.

        ls_workcenter-ktext = ls_crtx-ktext.
      ENDIF.

      READ TABLE lt_tc30t INTO ls_tc30t WITH KEY verwe = <fs_workcenter>-verwe.

      IF sy-subrc EQ 0.

        ls_workcenter-verwe_txt = ls_tc30t-ktext.
      ENDIF.

      ls_workcenter-arbpl = <fs_workcenter>-arbpl.
*>>>DGG 19/07/2017 - add Work Center Category and name
      ls_workcenter-verwe = <fs_workcenter>-verwe.
      ls_workcenter-werks = <fs_workcenter>-werks.
      ls_workcenter-name1 = <fs_workcenter>-name1.
*<<<DGG 19/07/2017 - add Work Center Category and name

      APPEND ls_workcenter TO et_workcenter.
      CLEAR: ls_crtx, ls_workcenter.
    ENDLOOP.


  ENDMETHOD.


  METHOD install_equipment_on_machine.

    DATA: ls_return     TYPE bapireturn,
          ls_return_tab LIKE LINE OF et_return,
          lv_equi       TYPE equnr,
          lv_machine    TYPE equnr.

    CALL FUNCTION 'BAPI_EQMT_INSTALLHR'
      EXPORTING
        equipment = i_equipment
        superequi = i_machine
*>>> CBC - 06.04.2017 - Correcção de erro message id = 044 - "Equip.xxxx: hora mont./desmont.tem de ser superior a hh:mm:ss
        date      = sy-datum
        time      = sy-uzeit
*<<< CBC - 06.04.2017 - Correcção de erro message id = 044 - "Equip.xxxx: hora mont./desmont.tem de ser superior a hh:mm:ss
      IMPORTING
        return    = ls_return.

    IF ls_return-type CA 'AEX'.

      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

      ls_return_tab-message = ls_return-message.
      ls_return_tab-type = ls_return-type.
      APPEND ls_return_tab TO et_return.
      CLEAR: ls_return, ls_return_tab.

    ELSE.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = i_equipment
        IMPORTING
          output = lv_equi.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = i_machine
        IMPORTING
          output = lv_machine.

      CALL METHOD zcl_absf_pm=>add_message
        EXPORTING
          msgty      = 'S'
          msgno      = '003'
          msgv1      = lv_equi
          msgv2      = lv_machine
        CHANGING
          return_tab = et_return.

    ENDIF.

  ENDMETHOD.


  METHOD print_pm_order.

    DATA: lt_bdc   TYPE TABLE OF bdcdata,
          ls_bdc     LIKE LINE OF lt_bdc,
          lt_msg     TYPE TABLE OF bdcmsgcoll,
          lv_tcode   TYPE t020-tcode,
          ls_options TYPE ctu_params.


* get value from parameter DEFAULT_PRINTER
    SELECT SINGLE parva
      INTO @DATA(lv_printer)
      FROM zabsf_pm_param
      WHERE werks = @i_inputobj-werks AND
            parid = 'DEFAULT_PRINTER'.

    if lv_printer is INITIAL.

      lv_printer = 'ZLOCL'.
    endif.


*   tcode to be used on batch input
    lv_tcode = 'IW32'.     " IW3D

    if lv_tcode = 'IW3D'.

*   Create BDC Data
    CLEAR lt_bdc.
    ls_bdc-program  = 'SAPLCOIH'.
    ls_bdc-dynpro   = '0101'.
    ls_bdc-dynbegin = 'X'.
    APPEND ls_bdc TO lt_bdc.

    CLEAR ls_bdc.
    ls_bdc-fnam     = 'BDC_CURSOR'.
    ls_bdc-fval     = 'CAUFVD-AUFNR'.
    APPEND ls_bdc TO lt_bdc.
    CLEAR ls_bdc.
    ls_bdc-fnam     = 'BDC_OKCODE'.
    ls_bdc-fval     = '/00'.
    APPEND ls_bdc TO lt_bdc.
    CLEAR ls_bdc.
    ls_bdc-fnam     = 'CAUFVD-AUFNR'.
    ls_bdc-fval     = i_aufnr.
    APPEND ls_bdc TO lt_bdc.

*   Call transaction
    ls_options-dismode  = 'N'. "background
    ls_options-updmode  = 'L'.
    ls_options-racommit = ' '.
    ls_options-nobinpt  = 'X'.
    ls_options-nobiend  = ' '.
    CALL TRANSACTION lv_tcode USING lt_bdc
                          OPTIONS FROM ls_options
                          MESSAGES INTO lt_msg.

    elseif lv_tcode = 'IW32'.


*     Create BDC Data
      CLEAR lt_bdc.
      ls_bdc-program  = 'SAPLCOIH'.
      ls_bdc-dynpro   = '0101'.
      ls_bdc-dynbegin = 'X'.
      APPEND ls_bdc TO lt_bdc.

      CLEAR ls_bdc.
      ls_bdc-fnam     = 'BDC_CURSOR'.
      ls_bdc-fval     = 'CAUFVD-AUFNR'.
      APPEND ls_bdc TO lt_bdc.
      CLEAR ls_bdc.
      ls_bdc-fnam     = 'BDC_OKCODE'.
      ls_bdc-fval     = '/00'.
      APPEND ls_bdc TO lt_bdc.
      CLEAR ls_bdc.
      ls_bdc-fnam     = 'CAUFVD-AUFNR'.
      ls_bdc-fval     = i_aufnr.
      APPEND ls_bdc TO lt_bdc.

      CLEAR ls_bdc.
      ls_bdc-program  = 'SAPLCOIH'.
      ls_bdc-dynpro   = '3000'.
      ls_bdc-dynbegin = 'X'.
      APPEND ls_bdc TO lt_bdc.

      CLEAR ls_bdc.
      ls_bdc-fnam     = 'BDC_OKCODE'.
      ls_bdc-fval     = '=IHDR'.
      APPEND ls_bdc TO lt_bdc.


      CLEAR ls_bdc.
      ls_bdc-program  = 'SAPLIPRT'.
      ls_bdc-dynpro   = '0110'.
      ls_bdc-dynbegin = 'X'.
      APPEND ls_bdc TO lt_bdc.

      CLEAR ls_bdc.
      ls_bdc-fnam     = 'BDC_CURSOR'.
      ls_bdc-fval     = 'GV_TDDEST(01)'.
      APPEND ls_bdc TO lt_bdc.
      CLEAR ls_bdc.
      ls_bdc-fnam     = 'BDC_OKCODE'.
      ls_bdc-fval     = '=GO'.
      APPEND ls_bdc TO lt_bdc.

      CLEAR ls_bdc.
      ls_bdc-fnam     = 'GV_TDDEST(01)'.
      ls_bdc-fval     = lv_printer.   " Tera a impressora assocaida ao centro nos params do shopfloor
      APPEND ls_bdc TO lt_bdc.

*     Call transaction
      ls_options-dismode  = 'N'. "background
      ls_options-updmode  = 'L'.
      ls_options-racommit = ' '.
      ls_options-nobinpt  = 'X'.
      ls_options-nobiend  = ' '.
      CALL TRANSACTION lv_tcode USING lt_bdc
                            OPTIONS FROM ls_options
                            MESSAGES INTO lt_msg.

    endif.
    IF lt_msg[] IS NOT INITIAL.

      LOOP AT lt_msg INTO DATA(ls_msg)." WHERE msgtyp  EQ 'E'.

        DATA(lv_msgno) = VALUE symsgno( ).
        MOVE ls_msg-msgnr TO lv_msgno.

*    Send error message
        CALL METHOD zcl_absf_pm=>add_message
          EXPORTING
            msgid      = ls_msg-msgid
            msgty      = ls_msg-msgtyp
            msgno      = lv_msgno
            msgv1      = ls_msg-msgv1
            msgv2      = ls_msg-msgv2
            msgv3      = ls_msg-msgv3
            msgv4      = ls_msg-msgv4
          CHANGING
            return_tab = et_return_tab.

      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD set_checklist.


    CONSTANTS: gc_ok(5)  VALUE '[OK.]:',
               gc_nok(5) VALUE '[NOK]:',
               gc_ne(5)  VALUE '[N/E]:'.


    TYPES: BEGIN OF ty_user_stats,
             objnr     TYPE j_objnr,
             user_stat TYPE j_status,
           END OF ty_user_stats.

    TYPES: BEGIN OF ty_notes,
             rueck     TYPE co_rueck,
             rmzhl     TYPE co_rmzhl,
             ltxa1     TYPE co_rtext,
             aufpl     TYPE co_aufpl,
             aplzl     TYPE co_aplzl,
             step_desc TYPE ltxa1,
           END OF ty_notes.

    DATA: ls_checklist LIKE LINE OF checklist.

    DATA: lt_notes      TYPE TABLE OF ty_notes,
          ls_notes      LIKE LINE OF lt_notes,
          lt_steps_desc TYPE TABLE OF ty_notes,
          ls_steps_desc LIKE LINE OF lt_steps_desc,
          lines         TYPE STANDARD TABLE OF tline,
          ls_line       LIKE LINE OF lines.

    DATA: lt_afvc         TYPE TABLE OF afvc,
          ls_afvc         LIKE LINE OF lt_afvc,
          ls_afvc_aux     LIKE LINE OF lt_afvc,
          ls_notification TYPE zabsf_pm_s_notifications,
          ls_aufk         TYPE aufk,
          lv_aufpl        TYPE co_aufpl,
          lv_user_stat    TYPE j_status,
          lt_user_stats   TYPE TABLE OF ty_user_stats,
          ls_user_stats   LIKE LINE OF lt_user_stats,
          lv_equnr        TYPE equnr,
          lv_description  TYPE qmtxt, "matnr ** JGC - 22.06.2017
          lv_aufnr        TYPE aufnr.

    DATA: lt_timetickets      TYPE TABLE OF bapi_alm_timeconfirmation,
          ls_timetickets      LIKE LINE OF lt_timetickets,
          ls_return           TYPE bapiret2,
          lt_return_detail    TYPE TABLE OF bapi_alm_return,
          lv_spras            TYPE spras,
          lf_dont_close       TYPE boole_d,
          lf_create_notif     TYPE boole_d,
          lf_found_operations TYPE boole_d,
          lv_objnr            TYPE j_objnr.

    DATA: lt_operations     TYPE TABLE OF bapi_alm_order_operation_e,
          ls_operations     LIKE LINE OF lt_operations,
          lt_return         TYPE TABLE OF bapiret2,
          ls_op_detail      TYPE  bapi_alm_order_operation_e,
          lt_op_detail_ret  TYPE TABLE OF bapiret2,
          lt_op_detail_text TYPE TABLE OF  bapi_alm_text,
          lt_op_detail_txtl TYPE TABLE OF bapi_alm_text_lines,
          lt_bapi_methods   TYPE TABLE OF bapi_alm_order_method,
          ls_bapi_methods   LIKE LINE OF lt_bapi_methods,
          lt_ordmaint_ret   TYPE bapiret2_t,
          lt_maint_header   TYPE TABLE OF bapi_alm_order_headers_i,
          ls_maint_header   LIKE LINE OF lt_maint_header.

    DATA: lt_longtext          TYPE TABLE OF bapi2080_notfulltxti,
          ls_longtext          LIKE LINE OF lt_longtext,
          lt_longtext_textline TYPE zabsf_pm_t_note_text_long,
          ls_longtext_textline LIKE LINE OF lt_longtext_textline.

    DATA: lt_return_tab TYPE bapiret2_t.

    FIELD-SYMBOLS:<fs_checklist> TYPE zabsf_pm_s_checklist,
                  <fs_notes>     TYPE ty_notes.

* set local language
    lv_spras = i_inputobj-language.
    SET LOCALE LANGUAGE lv_spras.

* get order type
    SELECT SINGLE * FROM aufk INTO ls_aufk
      WHERE aufnr = pm_order.

* get routing for PM order.
    SELECT SINGLE aufpl FROM afko INTO lv_aufpl
      WHERE aufnr = pm_order.

    SELECT * FROM afvc INTO TABLE lt_afvc
      WHERE aufpl = lv_aufpl.

    CHECK ls_aufk-auart IS NOT INITIAL.


    LOOP AT checklist INTO ls_checklist.
      ls_timetickets-orderid = pm_order.
      ls_timetickets-operation = ls_checklist-stepid.
*      ls_timetickets-sub_oper = ls_checklist-substepid.
      ls_timetickets-fin_conf = '1'.
      ls_timetickets-complete = abap_true.
      ls_timetickets-plant = i_inputobj-werks.
      ls_timetickets-pers_no = i_inputobj-pernr.

      CASE abap_true.
        WHEN ls_checklist-ok.
          CONCATENATE gc_ok ls_checklist-observations INTO ls_timetickets-conf_text.

        WHEN ls_checklist-nok.
          CONCATENATE gc_nok ls_checklist-observations INTO ls_timetickets-conf_text.

        WHEN ls_checklist-ne.
          CONCATENATE gc_ne ls_checklist-observations INTO ls_timetickets-conf_text.
      ENDCASE.

      APPEND ls_timetickets TO lt_timetickets.
      CLEAR: ls_checklist, ls_timetickets, ls_afvc, ls_afvc_aux, ls_user_stats.

    ENDLOOP.

    CALL FUNCTION 'BAPI_ALM_CONF_CREATE'
      EXPORTING
        testrun       = abap_false
      IMPORTING
        return        = ls_return
      TABLES
        timetickets   = lt_timetickets
        detail_return = lt_return_detail.

    IF ls_return-type CA 'AEX'.

      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
*send error message and
      CALL METHOD zcl_absf_pm=>add_message
        EXPORTING
          msgid      = ls_return-id
          msgty      = ls_return-type
          msgno      = ls_return-number
          msgv1      = ls_return-message_v1
          msgv2      = ls_return-message_v2
          msgv3      = ls_return-message_v3
          msgv4      = ls_return-message_v4
        CHANGING
          return_tab = return_tab.
      EXIT.

    ELSE.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.

    ENDIF.

* clear buffer
    CALL FUNCTION 'CO_ZF_DATA_RESET_COMPLETE'
      EXPORTING
        i_no_ocm_reset = ' '
        i_status_reset = 'X'.

* get order operations
    CALL FUNCTION 'BAPI_ALM_ORDER_GET_DETAIL'
      EXPORTING
        number        = pm_order
      TABLES
        et_operations = lt_operations
        return        = lt_return.

* get status of each operation
    LOOP AT lt_operations INTO ls_operations.

      lf_found_operations = abap_true.
      CALL FUNCTION 'BAPI_ALM_OPERATION_GET_DETAIL'
        EXPORTING
          iv_orderid      = pm_order
          iv_activity     = ls_operations-activity
          iv_sub_activity = ls_operations-sub_activity
        IMPORTING
          es_operation    = ls_op_detail
        TABLES
          return          = lt_op_detail_ret
          et_text         = lt_op_detail_text
          et_text_lines   = lt_op_detail_txtl.

      IF ls_op_detail-complete = abap_false.
* check from afru table.
        SELECT SINGLE * FROM afru
         INTO @DATA(ls_afru_aux)
           WHERE aufnr    EQ @pm_order
             AND werks    EQ @i_inputobj-werks
             AND stokz    EQ @space
             AND stzhl    EQ @space
             AND aueru    EQ @abap_true
             AND vornr    EQ @ls_operations-activity.

        IF sy-subrc NE 0.
          lf_dont_close = abap_true.
        ENDIF.

      ENDIF.

      CLEAR: ls_operations, ls_op_detail.
    ENDLOOP.

    IF lt_operations IS INITIAL.
*      MESSAGE e036(ZABSF_PM).
      CLEAR ls_return.
      CALL METHOD zcl_absf_pm=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '36'
        CHANGING
          return_tab = return_tab.

      EXIT.
    ENDIF.

  ENDMETHOD.


  METHOD set_operator.
*  Structures
    DATA: ls_return TYPE bapireturn.

*  Get all data
    SELECT *
      FROM zabsf_pm_users
      INTO TABLE @DATA(lt_sf_users)
      WHERE werks  EQ @werks
        AND aufnr  EQ @aufnr.

    LOOP AT operator_tab INTO DATA(ls_operator).
*    Check if personnal number exist
      CALL FUNCTION 'BAPI_EMPLOYEE_CHECKEXISTENCE'
        EXPORTING
          number = pernr
        IMPORTING
          return = ls_return.

      IF ls_return IS INITIAL.
*      Read information from database
        READ TABLE lt_sf_users INTO DATA(ls_sf_users) WITH KEY oprid = ls_operator-oprid.

        IF sy-subrc EQ 0 AND ls_operator-status EQ oprid_status_inactive.
*        Get number operators assigned to Production Order
          DESCRIBE TABLE lt_sf_users LINES DATA(l_nr_operator).

*        Get first operator assigned to Production Order
          SELECT oprid UP TO 1 ROWS
            FROM zabsf_pm_users
            INTO (@DATA(l_first_operator))
           WHERE werks  EQ @werks
             AND aufnr  EQ @aufnr
           ORDER BY udate ASCENDING, utime ASCENDING.
          ENDSELECT.

          IF l_first_operator EQ ls_operator-oprid AND l_nr_operator GT 1.
*          Main operator can not dissociate while there are other associates.
            CALL METHOD zcl_absf_pm=>add_message
              EXPORTING
                msgty      = 'E'
                msgno      = '009'
              CHANGING
                return_tab = return_tab.

            EXIT.
          ELSE.
**          If exist delete entrie in database - 22.06.2017
*            DELETE ZABSF_PM_users FROM @( VALUE #( werks = ls_sf_users-werks
*                                                   aufnr = ls_sf_users-aufnr
*                                                   oprid = ls_sf_users-oprid ) ).
**          If exist delete entrie in database
            DELETE zabsf_pm_users FROM ls_sf_users.
            IF sy-subrc EQ 0.
*            Save changes
              COMMIT WORK AND WAIT.

*            Operation completed successfully
              CALL METHOD zcl_absf_pm=>add_message
                EXPORTING
                  msgty      = 'S'
                  msgno      = '010'
                CHANGING
                  return_tab = return_tab.
            ELSE.
*            Operation not completed
              CALL METHOD zcl_absf_pm=>add_message
                EXPORTING
                  msgty      = 'E'
                  msgno      = '011'
                CHANGING
                  return_tab = return_tab.
            ENDIF.
          ENDIF.
        ELSEIF ls_operator-status EQ oprid_status_active.
**        If not exist insert line in database - 22.06.2017
*          INSERT INTO ZABSF_PM_users VALUES @( VALUE #( werks  = werks
*                                                        aufnr  = aufnr
*                                                        oprid  = ls_operator-oprid
*                                                        udate  = sy-datum
*                                                        utime  = sy-uzeit ) ).
*        If not exist insert line in database
          ls_sf_users-werks  = werks.
          ls_sf_users-aufnr = aufnr.
          ls_sf_users-oprid  = ls_operator-oprid.
          ls_sf_users-udate  = sy-datum.
          ls_sf_users-utime  = sy-uzeit.
          INSERT INTO zabsf_pm_users VALUES ls_sf_users.
          IF sy-subrc EQ 0.
*          Save changes
            COMMIT WORK AND WAIT.

*          Operation completed successfully
            CALL METHOD zcl_absf_pm=>add_message
              EXPORTING
                msgty      = 'S'
                msgno      = '010'
              CHANGING
                return_tab = return_tab.
          ELSE.
*          Operation not completed
            CALL METHOD zcl_absf_pm=>add_message
              EXPORTING
                msgty      = 'E'
                msgno      = '011'
              CHANGING
                return_tab = return_tab.
          ENDIF.
        ENDIF.
      ELSE.
*      Could not find user & on system
        CALL METHOD zcl_absf_pm=>add_message
          EXPORTING
            msgty      = 'E'
            msgno      = '012'
            msgv1      = ls_operator-oprid
          CHANGING
            return_tab = return_tab.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD set_order_in_notification.

    DATA: lv_aufnr TYPE aufnr,
          lv_qmnum TYPE qmnum.

    DATA: ra_istat_proc    TYPE RANGE OF j_status.

    DATA: lt_bapi_methods TYPE TABLE OF bapi_alm_order_method,
          ls_bapi_methods LIKE LINE OF lt_bapi_methods,

          lt_ordmaint_ret TYPE bapiret2_t,
          ls_ordmaint_ret LIKE LINE OF lt_ordmaint_ret,
          lt_objectlist   TYPE STANDARD TABLE OF bapi_alm_order_objectlist,
          ls_objectlist   LIKE LINE OF lt_objectlist,
          lv_olist_lines  TYPE objza,
          lt_return       TYPE bapiret2_t,
          ls_return       LIKE LINE OF lt_ordmaint_ret.


    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = i_qmnum
      IMPORTING
        output = lv_qmnum.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = i_aufnr
      IMPORTING
        output = lv_aufnr.

    CALL METHOD get_parameter
      EXPORTING
        i_werks     = i_inputobj-werks
        i_parameter = 'ISTAT_OPEN'
*         Ticket 9000015984
*         i_parameter = 'ISTAT_PROC'

      IMPORTING
        et_range    = ra_istat_proc.

    SELECT SINGLE crhd~arbpl
        INTO @DATA(lv_workc)
        FROM qmel
        INNER JOIN crhd ON crhd~objty = qmel~crobjty
                      AND crhd~objid = qmel~arbpl
        WHERE qmel~qmnum = @lv_qmnum.

    SELECT SINGLE equnr
      INTO @DATA(lv_equnr)
      FROM qmih
      WHERE qmnum = @lv_qmnum.

    SELECT SINGLE iloa~tplnr
      INTO @DATA(lv_tplnr)
      FROM iloa
        INNER JOIN qmih ON qmih~iloan = iloa~iloan
      WHERE qmih~qmnum = @lv_qmnum.


    SELECT SINGLE ord~aufnr
        INTO @DATA(lv_ord_result)
        FROM aufk AS ord
          INNER JOIN jest                 ON jest~objnr = ord~objnr
          INNER JOIN afih                 AS ord_header ON ord~aufnr = ord_header~aufnr
*          LEFT OUTER JOIN iloa            AS loc ON ord_header~iloan = loc~iloan
         WHERE ord~aufnr EQ @lv_aufnr
* Same Main WorkCentre as the Notification    removed as requeted by LDG
*          AND ord~vaplz EQ @lv_workc

* Order is in proc (=I0002) and active
          AND jest~stat IN @ra_istat_proc
          AND jest~inact EQ @space.
* Same Technical Object as the Notification   removed as requeted by LDG
*          AND ord_header~equnr EQ @lv_equnr
*          AND loc~tplnr EQ @lv_tplnr.
    "   ENDSELECT.

    IF lv_ord_result IS INITIAL.
*    operation not completed
      CALL METHOD zcl_absf_pm=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '011'
        CHANGING
          return_tab = et_return_tab.

      RETURN.
    ENDIF.

* determine number of entries in object list of order
    CALL FUNCTION 'BAPI_ALM_ORDER_GET_DETAIL'
      EXPORTING
        number   = lv_aufnr
      TABLES
        et_olist = lt_objectlist
        return   = lt_return.

    READ TABLE lt_objectlist TRANSPORTING NO FIELDS WITH KEY notif_no = lv_qmnum.
    IF sy-subrc NE 0.

* determine number of entries in objectlist
      DESCRIBE TABLE lt_objectlist LINES lv_olist_lines.
      CLEAR lt_objectlist.

      ls_bapi_methods-refnumber  = 1.
      ls_bapi_methods-objectkey  = lv_aufnr.
      ls_bapi_methods-method     = 'CREATE'.
      ls_bapi_methods-objecttype = 'OBJECTLIST'.
      APPEND ls_bapi_methods TO lt_bapi_methods.

      ls_objectlist-notif_no = lv_qmnum.
* counter: number of entries in objectlist increased by one
      ls_objectlist-counter = lv_olist_lines + 1.

      APPEND ls_objectlist TO lt_objectlist.
    ENDIF.

    CLEAR ls_bapi_methods.
    ls_bapi_methods-method = 'SAVE'.
    APPEND ls_bapi_methods TO lt_bapi_methods.


    CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
      TABLES
        it_methods    = lt_bapi_methods
        it_objectlist = lt_objectlist
        return        = lt_ordmaint_ret.

    LOOP AT lt_ordmaint_ret INTO ls_return
      WHERE type CA 'AEX'.

      CALL METHOD zcl_absf_pm=>add_message
        EXPORTING
          msgid      = ls_return-id
          msgty      = 'E'
          msgno      = ls_return-number
          msgv1      = ls_return-message_v1
          msgv2      = ls_return-message_v2
          msgv3      = ls_return-message_v3
          msgv4      = ls_return-message_v4
        CHANGING
          return_tab = et_return_tab.

      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

    ENDLOOP.

    CHECK et_return_tab IS INITIAL.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.
*
*       Operation completed successfully
    CALL METHOD zcl_absf_pm=>add_message
      EXPORTING
        msgty      = 'S'
        msgno      = '010'
      CHANGING
        return_tab = et_return_tab.
*        ELSE.
**       Operation not completed
*          CALL METHOD ZCL_ABSF_PM=>add_message
*            EXPORTING
*              msgty      = 'E'
*              msgno      = '011'
*            CHANGING
*              return_tab = et_return_tab.
*        ENDIF.
  ENDMETHOD.


  METHOD set_reg_time.
*  METHOD set_reg_time.
*
**  Constants
*    CONSTANTS: c_stat_checklist TYPE j_status VALUE 'E0001'.
*
** Types:
*    TYPES: BEGIN OF ty_equipments,
*             equnr TYPE equnr,
*             eqart TYPE eqart,
*           END OF ty_equipments.
*
**  Internal tables
*    DATA: lt_return        TYPE TABLE OF bapiret2.
*
**  Structures
*    DATA: ls_return      TYPE bapiret2.
*
**  Variables
*    DATA: l_time  TYPE atime,
*          l_aufnr TYPE aufnr.
*
*    DATA: lv_qmnum          TYPE qmnum,
*          ls_notif_header   TYPE bapi2080_nothdri,
*          ls_notif_header_x TYPE bapi2080_nothdri_x,
*          ls_syst           TYPE bapi2080_notsti.
*
*    DATA: lt_operation_new TYPE TABLE OF bapi_alm_order_operation,
*          ls_operation_new LIKE LINE OF lt_operation_new,
*          lt_operation_up  TYPE TABLE OF bapi_alm_order_operation_up,
*          ls_operation_up  LIKE LINE OF lt_operation_up,
*          lt_ordmaint_ret  TYPE bapiret2_t,
*          ls_ordmaint_ret  LIKE LINE OF lt_ordmaint_ret,
*          lt_bapi_methods  TYPE TABLE OF bapi_alm_order_method,
*          ls_bapi_methods  LIKE LINE OF lt_bapi_methods,
*          lt_operation     TYPE TABLE OF bapi_alm_order_operation_e,
*          lf_no_go         TYPE boole_d,
*          lt_maint_header  TYPE TABLE OF bapi_alm_order_headers_i,
*          ls_maint_header  LIKE LINE OF lt_maint_header,
*          from_shopfloor   TYPE boole_d,
*          lv_activity_type TYPE lstar.
*
**  Check lenght of time
*    DATA(l_lengh)    = strlen( i_time ).
*
*    IF l_lengh LT 6.
*      CONCATENATE '0' i_time INTO l_time.
*    ELSE.
*      l_time = i_time.
*    ENDIF.
*
**  Convert to internal format
*    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*      EXPORTING
*        input  = i_aufnr
*      IMPORTING
*        output = l_aufnr.
*
**  Get order type
*    SELECT SINGLE auart
*      FROM aufk
*      INTO (@DATA(l_aufart))
*     WHERE aufnr EQ @l_aufnr.
*
**  Get all operator assign
*    SELECT *
*      FROM zabsf_pm_users
*      INTO TABLE @DATA(lt_sf_users)
*     WHERE werks EQ @i_inputobj-werks
*       AND aufnr EQ @l_aufnr.
*
**  Check if exist start work or stop
*    SELECT SINGLE *
*      FROM zabsf_pm_reg_pm
*      INTO @DATA(ls_sf_reg_pm_tmp)
*     WHERE werks EQ @i_inputobj-werks
*       AND aufnr EQ @l_aufnr.
*
**  Get Routing number of operations in the order
*    SELECT SINGLE aufpl
*      FROM afko
*      INTO (@DATA(l_aufpl))
*     WHERE aufnr EQ @l_aufnr.
*
*
**  Get operation of order
*    SELECT vornr UP TO 1 ROWS
*      FROM afvc
*      INTO (@DATA(l_vornr))
*     WHERE aufpl EQ @l_aufpl
*     ORDER BY aplzl ASCENDING.
*    ENDSELECT.
*
*    SELECT SINGLE auart FROM aufk
*      INTO (@DATA(lv_auart))
*      WHERE aufnr EQ @i_aufnr.
*
*
*
**>>BMR 17.01.2017 - Get activity type of operation.
*    SELECT SINGLE larnt
*      FROM afvc
*      INTO lv_activity_type
*    WHERE aufpl EQ l_aufpl
*      AND vornr EQ l_vornr.
**<<END 17.01.2017
*
**  Activities Type in Shopfloor
*    CASE i_actv_id.
*
**     START
*      WHEN gc_start.
*
*        ls_bapi_methods-refnumber = 1.
*        ls_bapi_methods-objecttype = 'HEADER'.
*        ls_bapi_methods-method = 'RELEASE'.
*        ls_bapi_methods-objectkey = i_aufnr.
*        APPEND ls_bapi_methods TO lt_bapi_methods.
*        CLEAR ls_bapi_methods.
*
*
**>> BMR INSERT 02.01.2017 - change first order first operation assigment.
*        CALL FUNCTION 'BAPI_ALM_ORDER_GET_DETAIL'
*          EXPORTING
*            number        = i_aufnr
*          TABLES
*            et_operations = lt_operation
*            return        = lt_return.
*
*
*        READ TABLE lt_operation INTO DATA(ls_operation_old) INDEX 1.
*        MOVE-CORRESPONDING ls_operation_old TO ls_operation_new.
*        ls_operation_new-pers_no = i_inputobj-pernr.
*        APPEND ls_operation_new TO lt_operation_new.
*        ls_operation_up-pers_no = abap_true.
*        APPEND ls_operation_up TO lt_operation_up.
*
*        ls_bapi_methods-refnumber = 1.
*        ls_bapi_methods-method = 'SAVE'.
*        APPEND ls_bapi_methods TO lt_bapi_methods.
*
*
*        ls_bapi_methods-refnumber = 1.
*        ls_bapi_methods-objecttype = 'OPERATION'.
*        ls_bapi_methods-method = 'CHANGE'.
*        CONCATENATE i_aufnr ls_operation_old-activity INTO ls_bapi_methods-objectkey.
*        APPEND ls_bapi_methods TO lt_bapi_methods.
*        CLEAR ls_bapi_methods.
*
*        CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
*          TABLES
*            it_methods      = lt_bapi_methods
*            it_operation    = lt_operation_new
*            it_operation_up = lt_operation_up
*            return          = lt_ordmaint_ret.
*
*        LOOP AT lt_ordmaint_ret INTO ls_ordmaint_ret
*          WHERE type CA 'AEX'.
*
*          CALL METHOD zcl_absf_pm=>add_message
*            EXPORTING
*              msgid      = ls_ordmaint_ret-id
*              msgty      = ls_ordmaint_ret-type
*              msgno      = ls_ordmaint_ret-number
*              msgv1      = ls_ordmaint_ret-message_v1
*              msgv2      = ls_ordmaint_ret-message_v2
*              msgv3      = ls_ordmaint_ret-message_v3
*              msgv4      = ls_ordmaint_ret-message_v4
*            CHANGING
*              return_tab = return_tab.
*
*          lf_no_go = abap_true.
*          EXIT.
*        ENDLOOP.
*
*        CHECK lf_no_go EQ abap_false.
*
*        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
*          EXPORTING
*            wait = abap_true.
*
**     END_PARC
*      WHEN gc_conc_parc.
*
**     CONC
*      WHEN gc_conc.
**      Get all operations
*        SELECT aufpl,objnr
*          FROM afvc
*          INTO TABLE @DATA(lt_afvc)
*         WHERE aufpl EQ @l_aufpl.
*
*        LOOP AT lt_afvc INTO DATA(ls_afvc).
**         Check if status is initial
*          SELECT SINGLE *
*            FROM jest
*            INTO @DATA(ls_jest)
*           WHERE objnr EQ @ls_afvc-objnr
*             AND stat  EQ @c_stat_checklist
*             AND inact EQ @space.
*
*          IF sy-subrc EQ 0.
**          No confirmation
*            DATA(l_no_confirm) = abap_true.
*            EXIT.
*          ENDIF.
*        ENDLOOP.
*
*        IF l_no_confirm IS NOT INITIAL.
**        Send error message: There are steps in the checklist to be confirmed.
*          CALL METHOD zcl_absf_pm=>add_message
*            EXPORTING
*              msgty      = 'E'
*              msgno      = '020'
*            CHANGING
*              return_tab = return_tab.
*
*          EXIT.
*        ENDIF.
*
**>> BMR INSERT 02.01.2017 - order technical complete!
*        IF i_actv_id = gc_conc.
*
*          REFRESH: lt_bapi_methods, lt_maint_header, lt_ordmaint_ret.
*
*          ls_bapi_methods-refnumber = 1.
*          ls_bapi_methods-objecttype = 'HEADER'.
*          ls_bapi_methods-method = 'TECHNICALCOMPLETE'.
*          ls_bapi_methods-objectkey = i_aufnr.
*          APPEND ls_bapi_methods TO lt_bapi_methods.
*          CLEAR ls_bapi_methods.
*
*          ls_bapi_methods-refnumber = 1.
*          ls_bapi_methods-method = 'SAVE'.
*          APPEND ls_bapi_methods TO lt_bapi_methods.
*
*          ls_maint_header-orderid = i_aufnr.
*          APPEND ls_maint_header TO lt_maint_header.
*
*          CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
*            TABLES
*              it_methods = lt_bapi_methods
*              it_header  = lt_maint_header
*              return     = lt_ordmaint_ret.
*
*          LOOP AT lt_ordmaint_ret TRANSPORTING NO FIELDS
*            WHERE type CA 'AEX'.
*
*            lf_no_go = abap_true.
*            EXIT.
*          ENDLOOP.
*
*          IF sy-subrc EQ 0.
*
*            CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
*
*            REFRESH return_tab.
*            return_tab = lt_ordmaint_ret.
*          ELSE.
*            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
*              EXPORTING
*                wait = abap_true.
*          ENDIF.
*        ENDIF.
**<< BMR END INSERT 02.01.2017.
*
*
*    ENDCASE.
*
*
*    CHECK lf_no_go EQ abap_false.
*
** edit maintenance notification and close.
*    IF i_actv_id EQ gc_conc.
*
*      SELECT SINGLE qmnum FROM afih INTO lv_qmnum
*        WHERE aufnr = i_aufnr.
*
*      CHECK lv_qmnum IS NOT INITIAL.
*
*
*      DATA: ra_istat_closed TYPE RANGE OF j_status,
*            lv_notif_status TYPE j_status.
*
*      CALL METHOD get_parameter
*        EXPORTING
*          i_werks     = i_inputobj-werks
*          i_parameter = 'ISTAT_NOTIF_CLOSED'
*        IMPORTING
*          et_range    = ra_istat_closed.
*
*      CLEAR lv_notif_status.
*
*      SELECT SINGLE jest~stat INTO @lv_notif_status
*        FROM qmel
*          INNER JOIN jest ON jest~objnr = qmel~objnr
*        WHERE qmel~qmnum = @lv_qmnum
*         AND jest~inact NE @abap_true
*         AND jest~stat IN @ra_istat_closed.
*
*
*      CHECK lv_notif_status IS INITIAL.
*
*
*      ls_notif_header-endmlfndate = sy-datlo.
*      ls_notif_header-endmlfntime = sy-timlo.
*      ls_notif_header_x-endmlfndate = abap_true.
*      ls_notif_header_x-endmlfntime = abap_true.
*
**>>> for BADI ZABSF_PM_BREAKDOWN_CALC sap note - 1619709 - Notification breakdown duration not populated by BAPI call
*      from_shopfloor = abap_true.
*      EXPORT from_shopfloor FROM from_shopfloor TO MEMORY ID 'SHOPFLOOR_NOTE_CLOSE'.
**<<<
*      CALL FUNCTION 'BAPI_ALM_NOTIF_DATA_MODIFY'
*        EXPORTING
*          number        = lv_qmnum
*          notifheader   = ls_notif_header
*          notifheader_x = ls_notif_header_x
*        TABLES
*          return        = lt_return.
*
*      LOOP AT lt_return INTO ls_return
*         WHERE type CA 'AEX'.
*
*        CALL METHOD zcl_absf_pm=>add_message
*          EXPORTING
*            msgid      = ls_return-id
*            msgty      = ls_return-type
*            msgno      = ls_return-number
*            msgv1      = ls_return-message_v1
*            msgv2      = ls_return-message_v2
*            msgv3      = ls_return-message_v3
*            msgv4      = ls_return-message_v4
*          CHANGING
*            return_tab = return_tab.
*
*        lf_no_go = abap_true.
*
*        CLEAR ls_return.
*      ENDLOOP.
*
*      CHECK lf_no_go NE abap_true.
*
*      CALL FUNCTION 'BAPI_ALM_NOTIF_SAVE'
*        EXPORTING
*          number = lv_qmnum
*        TABLES
*          return = lt_return.
*
*      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
*        EXPORTING
*          wait = abap_true.
*
*      CALL FUNCTION 'BAPI_ALM_NOTIF_CLOSE'
*        EXPORTING
*          number   = lv_qmnum
*          syststat = ls_syst
*        TABLES
*          return   = lt_return.
*
*      LOOP AT lt_return INTO ls_return
*        WHERE type CA 'AEX'.
*
*        CALL METHOD zcl_absf_pm=>add_message
*          EXPORTING
*            msgid      = ls_return-id
*            msgty      = ls_return-type
*            msgno      = ls_return-number
*            msgv1      = ls_return-message_v1
*            msgv2      = ls_return-message_v2
*            msgv3      = ls_return-message_v3
*            msgv4      = ls_return-message_v4
*          CHANGING
*            return_tab = return_tab.
*
*        lf_no_go = abap_true.
*
*        CLEAR ls_return.
*      ENDLOOP.
*
*      CHECK lf_no_go NE abap_true.
*
*      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
*        EXPORTING
*          wait = abap_true.
*
*    ENDIF.
*  ENDMETHOD.



* Types:
    TYPES: BEGIN OF ty_equipments,
             equnr TYPE equnr,
             eqart TYPE eqart,
           END OF ty_equipments.

*  Internal tables
    DATA: lt_sf_reg_pm     TYPE TABLE OF zabsf_pm_reg_pm,
          lt_timetickets   TYPE TABLE OF bapi_alm_timeconfirmation,
          lt_detail_return TYPE TABLE OF bapi_alm_return,
          lt_object        TYPE TABLE OF bapi1003_object_keys,
          ls_object        TYPE bapi1003_object_keys,
          lt_return        TYPE TABLE OF bapiret2,
          lt_numtab        TYPE TABLE OF bapi1003_alloc_values_num,
          lt_chatab        TYPE TABLE OF bapi1003_alloc_values_char,
          lt_curtab        TYPE TABLE OF bapi1003_alloc_values_curr,
*          lt_subequip      TYPE zpm02_sf_t_sub_equipments_list,
          ls_operators     TYPE zabsf_pm_users,
          lt_equipments    TYPE TABLE OF ty_equipments.

*  Structures
    DATA: ls_sf_reg_pm   TYPE zabsf_pm_reg_pm,
          ls_timetickets TYPE bapi_alm_timeconfirmation,
          ls_return      TYPE bapiret2.

*  Variables
    DATA: l_activity  TYPE ru_ismng,
          l_act_pernr TYPE ru_ismng,
          l_time      TYPE atime,
          l_time_proc TYPE pr_time,
          l_status    TYPE j_status,
          l_aufnr     TYPE aufnr,
          l_objek     TYPE cuobn,
          l_objectkey TYPE objnum,
          l_atnam     TYPE atnam,
          l_atnam_val TYPE atwtb.

    DATA: lv_qmnum          TYPE qmnum,
          ls_notif_header   TYPE bapi2080_nothdri,
          ls_notif_header_x TYPE bapi2080_nothdri_x,
          ls_syst           TYPE bapi2080_notsti.

    DATA: lr_order_type TYPE rsis_t_range,
          i_stat        TYPE STANDARD TABLE OF jstat,
          wa_stat       TYPE jstat,
          lv_time       TYPE atime.


*  Constants
    CONSTANTS: c_min(3)         TYPE c        VALUE 'MIN',
               c_stat_proc      TYPE j_status VALUE 'PROC',
               c_stat_agu       TYPE j_status VALUE 'AGU',
               c_stat_conc      TYPE j_status VALUE 'CONC',
               c_stat_checklist TYPE j_status VALUE 'E0001',
               c_aufart         TYPE aufart   VALUE 'ZMLD',
               c_obj_equi       TYPE tabelle  VALUE 'EQUI',
               c_mafid          TYPE klmaf    VALUE 'O', "Indicator: Object/Class
               c_crb            TYPE atnam    VALUE 'CRB',
               c_vacuum         TYPE atnam    VALUE 'VACUUM',
               c_yes            TYPE atwtb    VALUE 'YES'.

    DATA: lt_operation_new   TYPE TABLE OF bapi_alm_order_operation,
          ls_operation_new   LIKE LINE OF lt_operation_new,
          lt_operation_up    TYPE TABLE OF bapi_alm_order_operation_up,
          ls_operation_up    LIKE LINE OF lt_operation_up,
          lt_ordmaint_ret    TYPE bapiret2_t,
          ls_ordmaint_ret    LIKE LINE OF lt_ordmaint_ret,
          lt_bapi_methods    TYPE TABLE OF bapi_alm_order_method,
          ls_bapi_methods    LIKE LINE OF lt_bapi_methods,
          lt_operation       TYPE TABLE OF bapi_alm_order_operation_e,
*     Begin of change PMC 04.07.2017 - Ticket 9000008672
          ls_operation       LIKE LINE OF lt_operation,
*     End of change PMC 04.07.2017 - Ticket 9000008672
          lf_no_go           TYPE boole_d,
          lt_maint_header    TYPE TABLE OF bapi_alm_order_headers_i,
          ls_maint_header    LIKE LINE OF lt_maint_header,
          lv_update_activity TYPE boole_d,
          from_shopfloor     TYPE boole_d,
          lv_activity_type   TYPE lstar,
          rg_iloan           TYPE RANGE OF iloa-iloan,
          rs_iloan           LIKE LINE OF rg_iloan.

    DATA: lv_status_disp   TYPE tj30-estat,
          lv_status_ofic   TYPE tj30-estat,
          lv_status_schema TYPE tj30-stsma,
          lv_parva         TYPE zabsf_pm_param-parva.

* get value from parameter USER_STAT_CHKIN
    SELECT SINGLE parva
      INTO lv_parva
      FROM zabsf_pm_param
      WHERE werks = i_inputobj-werks AND
            parid = 'USER_STAT_CHKIN'.

    MOVE lv_parva TO lv_status_disp.

* get value from parameter USER_STAT_CHKOUT
    SELECT SINGLE parva
      INTO lv_parva
      FROM zabsf_pm_param
      WHERE werks = i_inputobj-werks AND
            parid = 'USER_STAT_CHKOUT'.

    MOVE lv_parva TO lv_status_ofic.

* get value from parameter USER_STAT_PROFILE
    SELECT SINGLE parva
      INTO lv_parva
      FROM zabsf_pm_param
      WHERE werks = i_inputobj-werks AND
            parid = 'USER_STAT_PROFILE'.

    MOVE lv_parva TO lv_status_schema.


*  Check lenght of time
    DATA(l_lengh)    = strlen( i_time ).

    IF l_lengh LT 6.
      CONCATENATE '0' i_time INTO l_time.
    ELSE.
      lv_time = i_time - 3.

      CLEAR l_lengh.
      l_lengh = strlen( lv_time ).

      IF l_lengh LT 6.
        CONCATENATE '0' lv_time INTO l_time.
      ELSE.
        l_time = lv_time.
      ENDIF.
    ENDIF.

*  Convert to internal format
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = i_aufnr
      IMPORTING
        output = l_aufnr.

*  Get order type
    SELECT SINGLE auart
      FROM aufk
      INTO (@DATA(l_aufart))
     WHERE aufnr EQ @l_aufnr.

*  Get all operator assign
    SELECT *
      FROM zabsf_pm_users
      INTO TABLE @DATA(lt_sf_users)
     WHERE werks EQ @i_inputobj-werks
       AND aufnr EQ @l_aufnr.

*  Check if exist start work or stop
    SELECT SINGLE *
      FROM zabsf_pm_reg_pm
      INTO @DATA(ls_sf_reg_pm_tmp)
     WHERE werks EQ @i_inputobj-werks
       AND aufnr EQ @l_aufnr
       AND iedd  EQ '00000000'
       AND iedz  EQ '000000'.

*  Get Routing number of operations in the order
    SELECT SINGLE aufpl
      FROM afko
      INTO (@DATA(l_aufpl))
     WHERE aufnr EQ @l_aufnr.


*  Get operation of order
    SELECT vornr UP TO 1 ROWS
      FROM afvc
      INTO (@DATA(l_vornr))
     WHERE aufpl EQ @l_aufpl
     ORDER BY aplzl ASCENDING.
    ENDSELECT.


*  Get user responsible from Order Partner Function ZB

    SELECT SINGLE objnr
      FROM aufk
      INTO @DATA(lv_objnr)
      WHERE aufk~aufnr = @l_aufnr.


    SELECT SINGLE parnr FROM ihpa AS ihpa
      INTO @DATA(lv_parnr)
      WHERE ihpa~objnr = @lv_objnr AND
            ihpa~parvw = 'VW' AND
            ihpa~counter = '0'.


*>>BMR 17.01.2017 - Get activity type of operation.
    SELECT SINGLE larnt
      FROM afvc
      INTO lv_activity_type
    WHERE aufpl EQ l_aufpl
      AND vornr EQ l_vornr.
*<<END 17.01.2017

*  Activities Type in Shopfloor
    CASE i_actv_id.
      WHEN gc_start.
*      Create new record
        CLEAR ls_sf_reg_pm.

        IF NOT ls_sf_reg_pm_tmp IS INITIAL.
*      Send error message: There is already a start work record
          CALL METHOD zcl_absf_pm=>add_message
            EXPORTING
              msgty      = 'E'
              msgno      = '042'
            CHANGING
              return_tab = return_tab.

          EXIT.

        ELSE.

          ls_sf_reg_pm-werks = i_inputobj-werks.
          ls_sf_reg_pm-aufnr = l_aufnr.
          ls_sf_reg_pm-isdd = i_date.
          ls_sf_reg_pm-isdz = l_time.

          APPEND ls_sf_reg_pm TO lt_sf_reg_pm.

*         assign ZB partner (user resp) to table zabsf_pm_users
          CLEAR ls_operators.

          ls_operators-aufnr = l_aufnr.
          ls_operators-mandt = sy-mandt.
          ls_operators-oprid = lv_parnr. " user resp
          ls_operators-udate = i_date.
          ls_operators-utime = l_time.
          ls_operators-werks = i_inputobj-werks.

          MODIFY zabsf_pm_users FROM ls_operators.
        ENDIF.
      WHEN gc_conc_parc.
        CLEAR ls_sf_reg_pm.

        IF NOT ls_sf_reg_pm_tmp IS INITIAL.

*       Move same fields
          MOVE-CORRESPONDING ls_sf_reg_pm_tmp TO ls_sf_reg_pm.

*       Time
          l_time_proc = l_time.

*      Calculated activities time
          CALL METHOD zcl_absf_pm=>calc_minutes
            EXPORTING
              date       = ls_sf_reg_pm-isdd
              time       = ls_sf_reg_pm-isdz
              proc_date  = i_date
              proc_time  = l_time_proc
            CHANGING
              activity   = l_activity
              return_tab = return_tab.

          ls_sf_reg_pm-iedd = i_date.
          ls_sf_reg_pm-iedz = l_time_proc.
          ls_sf_reg_pm-ismnw_2 = l_activity.
          ls_sf_reg_pm-ismnu = c_min.

          APPEND ls_sf_reg_pm TO lt_sf_reg_pm.

*      To create confirmation
          ls_timetickets-orderid = l_aufnr.
          ls_timetickets-operation = l_vornr.
          ls_timetickets-postg_date = sy-datlo.
          ls_timetickets-plant = i_inputobj-werks.
          ls_timetickets-exec_start_date = ls_sf_reg_pm-isdd.
*        ls_timetickets-exec_start_time = ls_sf_reg_pm-iedz.
          ls_timetickets-exec_start_time = ls_sf_reg_pm-isdz.
          ls_timetickets-exec_fin_date = i_date.
          ls_timetickets-exec_fin_time = l_time.

* BMR 17.01.2017 - real costs
          ls_timetickets-act_type = lv_activity_type.

*      Number of users assign to Order PM
          DESCRIBE TABLE lt_sf_users LINES DATA(l_number_opr).

*      Work time by user
          IF l_number_opr IS NOT INITIAL.
            l_act_pernr = l_activity / l_number_opr.
          ELSE.
            l_act_pernr = l_activity.
          ENDIF.

          LOOP AT lt_sf_users INTO DATA(ls_sf_users).
            CLEAR: ls_timetickets-act_work,
                   ls_timetickets-un_work,
                   ls_timetickets-pers_no.

            ls_timetickets-act_work = l_activity.
            ls_timetickets-un_work = c_min.
            ls_timetickets-pers_no = ls_sf_users-oprid.

            APPEND ls_timetickets TO lt_timetickets.
          ENDLOOP.

        ELSE.

*      Send error message: There is no start work record
          CALL METHOD zcl_absf_pm=>add_message
            EXPORTING
              msgty      = 'E'
              msgno      = '040'
            CHANGING
              return_tab = return_tab.

          EXIT.
        ENDIF.

      WHEN gc_conc.

*     Begin of change PMC 04.07.2017 - Ticket 9000008672
**      Get all operations
*        SELECT aufpl,objnr
*          FROM afvc
*          INTO TABLE @DATA(lt_afvc)
*         WHERE aufpl EQ @l_aufpl.
*
*        LOOP AT lt_afvc INTO DATA(ls_afvc).
**         Check if status is initial
*          SELECT SINGLE *
*            FROM jest
*            INTO @DATA(ls_jest)
*           WHERE objnr EQ @ls_afvc-objnr
*             AND stat  EQ @c_stat_checklist
*             AND inact EQ @space.
*
*          IF sy-subrc EQ 0.
**          No confirmation
*            DATA(l_no_confirm) = abap_true.
*            EXIT.
*          ENDIF.
*        ENDLOOP.

        REFRESH: lt_operation, lt_return.

*       Get all operations
        SELECT aufpl,objnr,vornr
          FROM afvc
          INTO TABLE @DATA(lt_afvc)
          WHERE aufpl EQ @l_aufpl.

*       Get order operations
        CALL FUNCTION 'BAPI_ALM_ORDER_GET_DETAIL'
          EXPORTING
            number        = i_aufnr
          TABLES
            et_operations = lt_operation
            return        = lt_return.

        SORT lt_operation BY activity sub_activity.

*       Get status of each operation
        LOOP AT lt_operation INTO ls_operation.

          LOOP AT lt_afvc INTO DATA(ls_afvc).

            IF ls_afvc-vornr = ls_operation-sub_activity
            OR ls_afvc-vornr = ls_operation-activity.
              EXIT.
            ENDIF.

          ENDLOOP.

          IF NOT ls_afvc-objnr IS INITIAL.

*           Check if status is initial
            SELECT SINGLE *
             FROM jest
             INTO @DATA(ls_jest)
             WHERE objnr EQ @ls_afvc-objnr
               AND stat  EQ @c_stat_checklist
               AND inact EQ @space.

            IF sy-subrc EQ 0.
*             No confirmation
              DATA(l_no_confirm) = abap_true.
              EXIT.
            ENDIF.

          ENDIF.

        ENDLOOP.
*     End of change PMC 04.07.2017 - Ticket 9000008672

        IF l_no_confirm IS NOT INITIAL.
*      Send error message: There are steps in the checklist to be confirmed.
          CALL METHOD zcl_absf_pm=>add_message
            EXPORTING
              msgty      = 'E'
              msgno      = '020'
            CHANGING
              return_tab = return_tab.

          EXIT.
        ENDIF.

*      To create confirmation
        ls_timetickets-orderid = l_aufnr.
        ls_timetickets-operation = l_vornr.
        ls_timetickets-postg_date = sy-datlo.
        ls_timetickets-plant = i_inputobj-werks.
        ls_timetickets-exec_start_date = i_date.
        ls_timetickets-exec_start_time = l_time.
        ls_timetickets-exec_fin_date = i_date.
        ls_timetickets-exec_fin_time = l_time.
        ls_timetickets-fin_conf = abap_true.
        ls_timetickets-pers_no = lv_parnr.  "" i_inputobj-oprid. CFB - changed to ZB partner of Order

* BMR 17.01.2017 - real costs
        ls_timetickets-act_type = lv_activity_type.

        APPEND ls_timetickets TO lt_timetickets.
    ENDCASE.


    IF lt_sf_reg_pm[] IS NOT INITIAL.
      IF i_actv_id EQ gc_start.


        DATA ls_header TYPE bapi_alm_order_header_e.

*>> BMR INSERT 02.01.2017 - change first order first operation assigment.
        CALL FUNCTION 'BAPI_ALM_ORDER_GET_DETAIL'
          EXPORTING
            number        = i_aufnr
          IMPORTING
            es_header     = ls_header
          TABLES
            et_operations = lt_operation
            return        = lt_return.



*       verify if order is already released
*       first start we have to release the order
        IF NOT ls_header-sys_status CS 'LIB'.

          ls_bapi_methods-refnumber = 1.
          ls_bapi_methods-objecttype = 'HEADER'.
          ls_bapi_methods-method = 'RELEASE'.
          ls_bapi_methods-objectkey = i_aufnr.
          APPEND ls_bapi_methods TO lt_bapi_methods.
          CLEAR ls_bapi_methods.

        ENDIF.

        READ TABLE lt_operation INTO DATA(ls_operation_old) INDEX 1.
        MOVE-CORRESPONDING ls_operation_old TO ls_operation_new.
        ls_operation_new-pers_no = lv_parnr. "   CFB changed for ZB partner     i_inputobj-pernr.
        APPEND ls_operation_new TO lt_operation_new.
        ls_operation_up-pers_no = abap_true.
        APPEND ls_operation_up TO lt_operation_up.

        ls_bapi_methods-refnumber = 1.
        ls_bapi_methods-method = 'SAVE'.
        APPEND ls_bapi_methods TO lt_bapi_methods.

        ls_bapi_methods-refnumber = 1.
        ls_bapi_methods-objecttype = 'OPERATION'.
        ls_bapi_methods-method = 'CHANGE'.
        CONCATENATE i_aufnr ls_operation_old-activity INTO ls_bapi_methods-objectkey.
        APPEND ls_bapi_methods TO lt_bapi_methods.
        CLEAR ls_bapi_methods.

        CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
          TABLES
            it_methods      = lt_bapi_methods
            it_operation    = lt_operation_new
            it_operation_up = lt_operation_up
            return          = lt_ordmaint_ret.

        LOOP AT lt_ordmaint_ret INTO ls_ordmaint_ret
          WHERE type CA 'AEX'.

          CALL METHOD zcl_absf_pm=>add_message
            EXPORTING
              msgid      = ls_ordmaint_ret-id
              msgty      = ls_ordmaint_ret-type
              msgno      = ls_ordmaint_ret-number
              msgv1      = ls_ordmaint_ret-message_v1
              msgv2      = ls_ordmaint_ret-message_v2
              msgv3      = ls_ordmaint_ret-message_v3
              msgv4      = ls_ordmaint_ret-message_v4
            CHANGING
              return_tab = return_tab.

          lf_no_go = abap_true.
          EXIT.
        ENDLOOP.

        CHECK lf_no_go EQ abap_false.

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = abap_true.
*<< BMR END INSERT.

*      Insert new lines
        INSERT zabsf_pm_reg_pm FROM TABLE lt_sf_reg_pm.

        IF sy-subrc EQ 0.
*        Save changes
          COMMIT WORK AND WAIT.

*        Get actual status
          SELECT SINGLE *
            FROM zabsf_pm_status
            INTO @DATA(ls_sf_status)
           WHERE werks EQ @i_inputobj-werks
             AND aufnr EQ @l_aufnr.

          IF sy-subrc EQ 0.
*          Update exist record
*          UPDATE zabsf_pm_status FROM @( VALUE #( BASE ls_sf_status status = c_stat_proc ) ).

            ls_sf_status-status = c_stat_proc.
            UPDATE zabsf_pm_status FROM ls_sf_status.

            IF sy-subrc EQ 0.
              COMMIT WORK AND WAIT.
            ENDIF.
          ELSE.
*          Insert new record
*            INSERT zabsf_pm_status FROM TABLE @( VALUE #( ( werks  = i_inputobj-werks
*                                                            aufnr  = l_aufnr
*                                                            status = c_stat_proc ) ) ).
            ls_sf_status-werks = i_inputobj-werks.
            ls_sf_status-aufnr = l_aufnr.
            ls_sf_status-status = c_stat_proc.
            INSERT INTO zabsf_pm_status VALUES ls_sf_status.

            IF sy-subrc EQ 0.
              COMMIT WORK AND WAIT.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    IF lt_timetickets[] IS NOT INITIAL.

*>> BMR INSERT 02.01.2017 - order technical complete!
      IF i_actv_id = gc_conc.

        CALL METHOD zcl_absf_pm=>check_order_pm_activity
          EXPORTING
            i_aufnr  = i_aufnr
          IMPORTING
            e_update = lv_update_activity.

        REFRESH: lt_bapi_methods, lt_maint_header, lt_ordmaint_ret.

        ls_bapi_methods-refnumber = 1.
        ls_bapi_methods-objecttype = 'HEADER'.
        ls_bapi_methods-method = 'TECHNICALCOMPLETE'.
        ls_bapi_methods-objectkey = i_aufnr.
        APPEND ls_bapi_methods TO lt_bapi_methods.
        CLEAR ls_bapi_methods.

        IF lv_update_activity EQ abap_true.
          ls_bapi_methods-refnumber = 1.
          ls_bapi_methods-method = 'CHANGE'.
          ls_bapi_methods-objectkey = i_aufnr.
          ls_bapi_methods-objecttype = 'HEADER'.

          APPEND ls_bapi_methods TO lt_bapi_methods.
          ls_maint_header-pmacttype = '019'.
          CLEAR ls_bapi_methods.
        ENDIF.

        ls_bapi_methods-refnumber = 1.
        ls_bapi_methods-method = 'SAVE'.
        APPEND ls_bapi_methods TO lt_bapi_methods.

        ls_maint_header-orderid = i_aufnr.
        APPEND ls_maint_header TO lt_maint_header.

        CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
          TABLES
            it_methods = lt_bapi_methods
            it_header  = lt_maint_header
            return     = lt_ordmaint_ret.

        LOOP AT lt_ordmaint_ret TRANSPORTING NO FIELDS
          WHERE type CA 'AEX'.

          lf_no_go = abap_true.
          EXIT.
        ENDLOOP.
        IF sy-subrc EQ 0.

          CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

          REFRESH return_tab.
          return_tab = lt_ordmaint_ret.
        ELSE.

          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = abap_true.

*       >>> CFB 09.10.2018 Check-out of equipment - change status to DISP
          SELECT SINGLE qmnum FROM qmel INTO lv_qmnum
              WHERE aufnr = i_aufnr.

          IF NOT lv_qmnum IS INITIAL.

            " get msaus (breakdown) from qmih
            SELECT SINGLE qmih~msaus
              FROM qmih AS qmih
              INTO @DATA(lv_msaus)
            WHERE qmih~qmnum = @lv_qmnum.

            IF lv_msaus = 'X'. " Has Breakdown

              SELECT SINGLE equi~objnr, equi~eqtyp
                FROM equi
              INNER JOIN afih ON afih~equnr = equi~equnr

                INTO ( @DATA(lv_equi_objnr), @DATA(lv_eqtyp) )
                WHERE afih~aufnr = @l_aufnr.

              IF lv_eqtyp = 'F'.

*                DATA OBJNR          TYPE JEST-OBJNR.
*                DATA ESTAT_INACTIVE TYPE TJ30-ESTAT.
*                DATA ESTAT_ACTIVE   TYPE TJ30-ESTAT.
*                DATA STSMA          TYPE JSTO-STSMA.

                CALL FUNCTION 'I_CHANGE_STATUS'
                  EXPORTING
                    objnr          = lv_equi_objnr
                    estat_inactive = lv_status_ofic
                    estat_active   = lv_status_disp
                    stsma          = lv_status_schema
                  EXCEPTIONS
                    cannot_update  = 1
                    OTHERS         = 2.
                IF sy-subrc <> 0.
*        * Implement suitable error handling here
                ENDIF.

              ENDIF.
            ENDIF.

          ENDIF.
*       <<< CFB 09.10.2018 Check-out of equipment - change status to DISP

        ENDIF.
      ENDIF.

      CHECK lf_no_go EQ abap_false.
*<< BMR END INSERT 02.01.2017.

*    Create confirmation
      CALL FUNCTION 'BAPI_ALM_CONF_CREATE'
        EXPORTING
          post_wrong_entries = '2'
        IMPORTING
          return             = ls_return
        TABLES
          timetickets        = lt_timetickets
          detail_return      = lt_detail_return.

      IF ls_return IS INITIAL.

*      Commit to save records
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = 'X'.

        LOOP AT lt_detail_return INTO DATA(ls_detail_return).
          CLEAR ls_return.

          ls_return-type = ls_detail_return-type.
          ls_return-id = ls_detail_return-message_id.
          ls_return-number = ls_detail_return-message_number.
          ls_return-message = ls_detail_return-message.
          ls_return-message_v1 = ls_detail_return-message_v1.
          ls_return-message_v2 = ls_detail_return-message_v2.
          ls_return-message_v3 = ls_detail_return-message_v3.
          ls_return-message_v4 = ls_detail_return-message_v4.

          APPEND ls_return TO return_tab.

          IF ls_detail_return-type EQ 'I' OR ls_detail_return-type EQ 'S'.
            IF i_actv_id EQ gc_conc_parc.
              CLEAR ls_sf_reg_pm.

              LOOP AT lt_sf_reg_pm INTO ls_sf_reg_pm.
*              Update database
                UPDATE zabsf_pm_reg_pm FROM @ls_sf_reg_pm.

                IF sy-subrc EQ 0.
                  COMMIT WORK AND WAIT.
                ENDIF.
              ENDLOOP.

*            Status
              l_status = c_stat_agu.
            ELSE.
*            Status
              l_status = c_stat_conc.
            ENDIF.

            CLEAR ls_sf_status.

*          Get actual status
            SELECT SINGLE *
              FROM zabsf_pm_status
              INTO @ls_sf_status
             WHERE werks EQ @i_inputobj-werks
               AND aufnr EQ @l_aufnr.

            IF sy-subrc EQ 0.
*            Update exist record
*              update zabsf_pm_status from @( value #( base ls_sf_status status = l_status ) ).
              ls_sf_status-status = l_status.
              UPDATE zabsf_pm_status FROM ls_sf_status.

              IF sy-subrc EQ 0.
                COMMIT WORK AND WAIT.
              ENDIF.
            ELSE.
*            Insert new record
*              insert zabsf_pm_status from table @( value #( ( werks  = i_inputobj-werks
*                                                              aufnr  = l_aufnr
*                                                              status = l_status ) ) ).
              ls_sf_status-werks = i_inputobj-werks.
              ls_sf_status-aufnr = l_aufnr.
              ls_sf_status-status = l_status.
              INSERT INTO zabsf_pm_status VALUES ls_sf_status.

              IF sy-subrc EQ 0.
                COMMIT WORK AND WAIT.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDLOOP.

* clear users form order
        IF i_actv_id EQ gc_conc_parc OR i_actv_id EQ gc_conc.
          LOOP AT lt_sf_users INTO ls_operators.
*            delete zabsf_pm_users from @( value #( aufnr = ls_operators-aufnr
*                                                           werks = i_inputobj-werks
*                                                           oprid = ls_operators-oprid ) ).
            ls_sf_users-aufnr = ls_operators-aufnr.
            ls_sf_users-werks = i_inputobj-werks.
            ls_sf_users-oprid = ls_operators-oprid.
            DELETE zabsf_pm_users FROM ls_sf_users.

            IF sy-subrc EQ 0.
*          Save changes
              COMMIT WORK AND WAIT.
            ENDIF.
            CLEAR ls_operators.
          ENDLOOP.

* edit maintenance notification and close.
          IF i_actv_id EQ gc_conc.

            SELECT SINGLE qmnum FROM qmel INTO lv_qmnum
              WHERE aufnr = i_aufnr.

            CHECK lv_qmnum IS NOT INITIAL.

            ls_notif_header-endmlfndate = sy-datlo.
            ls_notif_header-endmlfntime = sy-timlo.
            ls_notif_header_x-endmlfndate = abap_true.
            ls_notif_header_x-endmlfntime = abap_true.

*>>> for BADI ZBREAKDOWN_CALCULATE sap note - 1619709 - Notification breakdown duration not populated by BAPI call
            from_shopfloor = abap_true.
            EXPORT from_shopfloor FROM from_shopfloor TO MEMORY ID 'SHOPFLOOR_NOTE_CLOSE'.
*<<<
            CALL FUNCTION 'BAPI_ALM_NOTIF_DATA_MODIFY'
              EXPORTING
                number        = lv_qmnum
                notifheader   = ls_notif_header
                notifheader_x = ls_notif_header_x
              TABLES
                return        = lt_return.

            LOOP AT lt_return INTO ls_return
               WHERE type CA 'AEX'.

              CALL METHOD zcl_absf_pm=>add_message
                EXPORTING
                  msgid      = ls_return-id
                  msgty      = ls_return-type
                  msgno      = ls_return-number
                  msgv1      = ls_return-message_v1
                  msgv2      = ls_return-message_v2
                  msgv3      = ls_return-message_v3
                  msgv4      = ls_return-message_v4
                CHANGING
                  return_tab = return_tab.

              lf_no_go = abap_true.

              CLEAR ls_return.
            ENDLOOP.

            CHECK lf_no_go NE abap_true.

            CALL FUNCTION 'BAPI_ALM_NOTIF_SAVE'
              EXPORTING
                number = lv_qmnum
              TABLES
                return = lt_return.

            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
              EXPORTING
                wait = abap_true.

            CALL FUNCTION 'BAPI_ALM_NOTIF_CLOSE'
              EXPORTING
                number   = lv_qmnum
                syststat = ls_syst
              TABLES
                return   = lt_return.

            LOOP AT lt_return INTO ls_return
              WHERE type CA 'AEX'.

              CALL METHOD zcl_absf_pm=>add_message
                EXPORTING
                  msgid      = ls_return-id
                  msgty      = ls_return-type
                  msgno      = ls_return-number
                  msgv1      = ls_return-message_v1
                  msgv2      = ls_return-message_v2
                  msgv3      = ls_return-message_v3
                  msgv4      = ls_return-message_v4
                CHANGING
                  return_tab = return_tab.

              lf_no_go = abap_true.

              CLEAR ls_return.
            ENDLOOP.

            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
              EXPORTING
                wait = abap_true.

          ENDIF.
        ENDIF.

      ELSE.

        CALL METHOD zcl_absf_pm=>add_message
          EXPORTING
            msgid      = ls_return-id
            msgty      = ls_return-type
            msgno      = ls_return-number
            msgv1      = ls_return-message_v1
            msgv2      = ls_return-message_v2
            msgv3      = ls_return-message_v3
            msgv4      = ls_return-message_v4
          CHANGING
            return_tab = return_tab.

      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD set_zmld_checklist.

    CONSTANTS: lc_uninstalling(4) VALUE '1000',
               lc_installing(4)   VALUE '2000',
               lc_setup(4)        VALUE '3000',
               lc_nprt(5)         VALUE 'I0180',
               lc_proc            VALUE 'PROC',
               lc_conc            VALUE 'CONC',
               lc_ini             VALUE 'INI',
               lc_user_stat_ok(5) VALUE 'E0002'.

    DATA: lv_aufpl TYPE co_aufpl,
          lv_objnr TYPE j_objnr,
          ls_afvc  TYPE afvc,
          lf_error TYPE boole_d.

    DATA: lt_locations TYPE zabsf_pm_t_moulde_location,
          lt_checklist TYPE zabsf_pm_t_checklist,
          ls_checklist LIKE LINE OF lt_checklist,
          ls_location  LIKE LINE OF lt_locations,
          lv_garg      TYPE eqegraarg,
          lt_enq       TYPE STANDARD TABLE OF seqg3.

*>>> CBC - CR14.2 - 05.04.2017
    "Change machine's equipament status
    DATA: ls_machine_equip TYPE zabsf_pm_s_sub_equipment,
          lt_machine_equip TYPE zabsf_pm_t_sub_equipments_list,
          i_stat           TYPE STANDARD TABLE OF jstat,
          wa_stat          TYPE jstat.
*<<< CBC - CR14.2 - 05.04.2017


* get key of object lock.
    CONCATENATE sy-mandt i_equipment INTO lv_garg.

    IF i_status EQ 'CONC'.

      IF i_aufnr IS NOT INITIAL AND i_main_step IS NOT INITIAL.

        CASE i_main_step.

*>>>> UNINSTALLING <<<<
          WHEN lc_uninstalling.

            IF i_equipment IS NOT INITIAL.

*1) Uninstall Equipment

              CALL METHOD zcl_absf_pm=>uninstall_eqpmt_from_machine
                EXPORTING
                  i_inputobj  = i_inputobj
                  i_equipment = i_equipment
                  i_machine   = i_machine
                IMPORTING
                  et_return   = return_tab.

              LOOP AT return_tab TRANSPORTING NO FIELDS
                WHERE type CA 'AEX'.
                ">>cancel processing

                lf_error = abap_true.
              ENDLOOP.

              CHECK lf_error EQ abap_false.

*2) Change Equipment Location
              APPEND is_location TO lt_locations.

              DO 5 TIMES.
                CALL FUNCTION 'ENQUEUE_READ'
                  EXPORTING
                    gclient = sy-mandt
                    gname   = 'EQUI'
                    garg    = lv_garg
                  TABLES
                    enq     = lt_enq.
                IF sy-subrc <> 0.
* Implement suitable error handling here
                ENDIF.
                IF lt_enq IS INITIAL.
                  EXIT.
                ELSE.
                  WAIT UP TO 1 SECONDS.
                ENDIF.
              ENDDO.

              CALL METHOD zcl_absf_pm=>change_moulde_location
                EXPORTING
                  i_inputobj = i_inputobj
                  it_mouldes = lt_locations
                IMPORTING
                  return_tab = return_tab.

              LOOP AT return_tab TRANSPORTING NO FIELDS
                WHERE type CA 'AEX'.
                ">>cancel processing

                lf_error = abap_true.
              ENDLOOP.

*3) Change Equipment Status
              CHECK lf_error EQ abap_false.

              DO 5 TIMES.
                CALL FUNCTION 'ENQUEUE_READ'
                  EXPORTING
                    gclient = sy-mandt
                    gname   = 'EQUI'
                    garg    = lv_garg
                  TABLES
                    enq     = lt_enq.
                IF sy-subrc <> 0.
* Implement suitable error handling here
                ENDIF.
                IF lt_enq IS INITIAL.
                  EXIT.
                ELSE.
                  WAIT UP TO 1 SECONDS.
                ENDIF.
              ENDDO.

              CALL METHOD zcl_absf_pm=>change_equipment_status
                EXPORTING
                  i_equnr    = i_equipment
                  i_status   = lc_nprt
                IMPORTING
                  return_tab = return_tab.

              LOOP AT return_tab TRANSPORTING NO FIELDS
                WHERE type CA 'AEX'.
                ">>cancel processing

                lf_error = abap_true.
              ENDLOOP.

*>>> CBC - CR14.2 - 05.04.2017
              "Change other machine's equipament status
              CALL METHOD zcl_absf_pm=>get_machine_subequip
                EXPORTING
                  i_werks     = i_inputobj-werks
                  i_equnr     = i_machine
                IMPORTING
                  et_subequip = lt_machine_equip.

              LOOP AT lt_machine_equip INTO ls_machine_equip.

                CHECK ls_machine_equip-equnr <> i_equipment.

                CALL METHOD zcl_absf_pm=>uninstall_eqpmt_from_machine
                  EXPORTING
                    i_inputobj  = i_inputobj
                    i_equipment = ls_machine_equip-equnr
                    i_machine   = i_machine
                  IMPORTING
                    et_return   = return_tab.

                LOOP AT return_tab TRANSPORTING NO FIELDS
                  WHERE type CA 'AEX'.
                  ">>cancel processing

                  lf_error = abap_true.
                ENDLOOP.
              ENDLOOP.
*<<< CBC - CR14.2 - 05.04.2017

            ENDIF.


*>>>> INSTALLING <<<<<
          WHEN lc_installing.

*1) Check machine equipments

            CALL METHOD zcl_absf_pm=>check_moulde_characts_equip
              EXPORTING
                i_aufnr     = i_aufnr
                i_equipment = i_equipment
                i_machine   = i_machine
                i_werks     = i_inputobj-werks
              CHANGING
                return_tab  = return_tab.

            CHECK return_tab IS INITIAL.

*2) Install moulde on machine
            CALL METHOD zcl_absf_pm=>install_equipment_on_machine
              EXPORTING
                i_inputobj  = i_inputobj
                i_equipment = i_equipment
                i_machine   = i_machine
              IMPORTING
                et_return   = return_tab.

            LOOP AT return_tab TRANSPORTING NO FIELDS
              WHERE type CA 'AEX'.
              ">>cancel processing

              lf_error = abap_true.
            ENDLOOP.

*3) Clear moulde locations
            CHECK lf_error EQ abap_false.
            ls_location-equnr = i_equipment.
            APPEND ls_location TO lt_locations. "initial

            DO 5 TIMES.
              CALL FUNCTION 'ENQUEUE_READ'
                EXPORTING
                  gclient = sy-mandt
                  gname   = 'EQUI'
                  garg    = lv_garg
                TABLES
                  enq     = lt_enq.
              IF sy-subrc <> 0.
* Implement suitable error handling here
              ENDIF.
              IF lt_enq IS INITIAL.
                EXIT.
              ELSE.
                WAIT UP TO 1 SECONDS.
              ENDIF.
            ENDDO.

            CALL METHOD zcl_absf_pm=>change_moulde_location
              EXPORTING
                i_inputobj = i_inputobj
                it_mouldes = lt_locations
              IMPORTING
                return_tab = return_tab.

            LOOP AT return_tab TRANSPORTING NO FIELDS
              WHERE type CA 'AEX'.
              ">>cancel processing

              lf_error = abap_true.
            ENDLOOP.

*3) Create confirmation


*>>>> SETUP <<<<<
          WHEN lc_setup.

*1 ) Create confirmation
        ENDCASE.

        CHECK lf_error EQ abap_false.

        ls_checklist-ok = abap_true.
        ls_checklist-stepid = i_main_step.
*       ls_checklist-substepid = i_main_step.
        ls_checklist-index_id = i_main_step.
        APPEND ls_checklist TO lt_checklist.

        CALL METHOD zcl_absf_pm=>set_checklist
          EXPORTING
            i_inputobj = i_inputobj
            pm_order   = i_aufnr
          CHANGING
            checklist  = lt_checklist
            return_tab = return_tab.

      ELSE.
* send error message!

        CALL METHOD zcl_absf_pm=>add_message
          EXPORTING
            msgty      = 'E'
            msgno      = '019'
          CHANGING
            return_tab = return_tab.

      ENDIF.
    ENDIF.

    IF i_status EQ 'PROC'.
* change user status of stage operation

* get routing for PM order.
      SELECT SINGLE aufpl FROM afko INTO lv_aufpl
        WHERE aufnr = i_aufnr.

      SELECT SINGLE * FROM afvc INTO ls_afvc
       WHERE aufpl = lv_aufpl
       AND vornr = i_main_step
       AND sumnr = ''.

      IF sy-subrc EQ 0.

        CONCATENATE 'OV' ls_afvc-aufpl ls_afvc-aplzl INTO lv_objnr.

        CALL FUNCTION 'STATUS_CHANGE_EXTERN'
          EXPORTING
            client              = sy-mandt
            objnr               = lv_objnr
            user_status         = lc_user_stat_ok
            set_chgkz           = abap_true
          EXCEPTIONS
            object_not_found    = 1
            status_inconsistent = 2
            status_not_allowed  = 3
            OTHERS              = 4.

        IF sy-subrc NE 0.
          CALL METHOD zcl_absf_pm=>add_message
            EXPORTING
              msgty      = 'E'
              msgno      = '14'
            CHANGING
              return_tab = return_tab.
        ELSE.
          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = abap_true.

          CALL METHOD zcl_absf_pm=>add_message
            EXPORTING
              msgty      = 'S'
              msgno      = '13'
            CHANGING
              return_tab = return_tab.
        ENDIF.

      ELSE.

        CALL METHOD zcl_absf_pm=>add_message
          EXPORTING
            msgty      = 'E'
            msgno      = '14'
          CHANGING
            return_tab = return_tab.
      ENDIF.
    ENDIF.


  ENDMETHOD.


  METHOD uninstall_eqpmt_from_machine.

    DATA: ls_return     TYPE bapireturn,
          ls_return_tab LIKE LINE OF et_return,
          lv_machine    TYPE equnr,
          lv_equi       TYPE equnr.

    CALL FUNCTION 'BAPI_EQMT_DISMANTLEHR'
      EXPORTING
        equipment = i_equipment
        superequi = i_machine
*>>> CBC - 06.04.2017 - Correcção de erro message id = 044 - "Equip.xxxx: hora mont./desmont.tem de ser superior a hh:mm:ss
        date      = sy-datum
        time      = sy-uzeit
*<<< CBC - 06.04.2017 - Correcção de erro message id = 044 - "Equip.xxxx: hora mont./desmont.tem de ser superior a hh:mm:ss
      IMPORTING
        return    = ls_return.

    IF ls_return-type CA 'AEX'.

      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

      ls_return_tab-message = ls_return-message.
      ls_return_tab-type = ls_return-type.
      APPEND ls_return_tab TO et_return.
      CLEAR: ls_return, ls_return_tab.

    ELSE.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = i_equipment
        IMPORTING
          output = lv_equi.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = i_machine
        IMPORTING
          output = lv_machine.

      CALL METHOD zcl_absf_pm=>add_message
        EXPORTING
          msgty      = 'S'
          msgno      = '004'
          msgv1      = lv_equi
          msgv2      = lv_machine
        CHANGING
          return_tab = et_return.

    ENDIF.


  ENDMETHOD.
ENDCLASS.
