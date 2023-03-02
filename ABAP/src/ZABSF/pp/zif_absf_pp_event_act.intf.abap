interface ZIF_ABSF_PP_EVENT_ACT
  public .


  methods GET_ACTIVITY
    importing
      !STATUS_ACTV type J_STATUS
    changing
      !ACTIVITY_STR type ZABSF_PP018
      !RETURN_TAB type BAPIRET2_T .
  methods SET_CONFIRM_TIME
    importing
      !AREAID type ZABSF_PP_E_AREAID optional
      !ARBPL type ARBPL
      !WERKS type WERKS_D optional
      !AUFNR type AUFNR
      !VORNR type VORNR
      !DATE type DATUM
      !TIME type ATIME
      !OPRID type ZABSF_PP_E_OPRID optional
      !RUECK type CO_RUECK
      !AUFPL type CO_AUFPL
      !APLZL type CO_APLZL
      !ACTV_ID type ZABSF_PP_E_ACTV
      !STPRSNID type ZABSF_PP_E_STPRSNID optional
      !STPTY type ZABSF_PP_E_STPTY optional
      value(BACKOFFICE) type FLAG optional
      value(SHIFTID) type ZABSF_PP_E_SHIFTID optional
      !KAPID type KAPID optional
      !LV_EQUIPAMENT type CHAR100 optional
    changing
      !ACTIONID type ZABSF_PP_E_ACTION optional
      !RETURN_TAB type BAPIRET2_T .
  methods GET_ACTIVITY_TYPE
    importing
      !AUFPL type CO_AUFPL
      !APLZL type CO_APLZL
    changing
      !CRCO_TAB type ZABSF_PP_T_CRCO optional
      !PLPO_TAB type PLPO_TAB optional
      !RETURN_TAB type BAPIRET2_T .
  methods SET_REFDT
    importing
      !NEW_REFDT type VVDATUM .
  methods SET_CONF_EVENT_TIME
    importing
      !AREAID type ZABSF_PP_E_AREAID optional
      !ARBPL type ARBPL
      !WERKS type WERKS_D optional
      !AUFNR type AUFNR
      !VORNR type VORNR
      !DATE type DATUM
      !TIME type ATIME
      !OPRID type ZABSF_PP_E_OPRID optional
      !RUECK type CO_RUECK
      !AUFPL type CO_AUFPL
      !APLZL type CO_APLZL
      !ACTV_ID type ZABSF_PP_E_ACTV
      !STPRSNID type ZABSF_PP_E_STPRSNID optional
      !STPTY type ZABSF_PP_E_STPTY optional
      !SCHEDULE_ID type ZABSF_PP_E_SCHEDULE_ID optional
      !REGIME_ID type ZABSF_PP_E_REGIME_ID optional
      !COUNT_INI type ZABSF_PP_E_COUNT_INI optional
      !COUNT_FIN type ZABSF_PP_E_COUNT_FIN optional
      value(BACKOFFICE) type FLAG optional
      value(SHIFTID) type ZABSF_PP_E_SHIFTID optional
      value(NO_CLEAR_OPERATORS_FROM_ORDER) type FLAG optional
      !KAPID type KAPID optional
      !IV_EQUIPMENT type CHAR100 optional
    changing
      !ACTIONID type ZABSF_PP_E_ACTION optional
      !RETURN_TAB type BAPIRET2_T .
endinterface.
