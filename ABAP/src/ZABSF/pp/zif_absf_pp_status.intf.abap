interface ZIF_ABSF_PP_STATUS
  public .


  methods SET_REFDT
    importing
      !NEW_REFDT type VVDATUM .
  methods GET_STATUS_ORD
    importing
      !AUFNR type AUFNR
    changing
      !STATUS type J_STATUS
      !STATUS_DESC type J_TXT30
      !RETURN_TAB type BAPIRET2_T .
  methods GET_STATUS_WRK
    importing
      !ARBPL type ARBPL
      !WERKS type WERKS_D
    changing
      !STATUS type J_STATUS
      !STATUS_DESC type J_TXT30
      !STSMA type JSTO-STSMA
      !RETURN_TAB type BAPIRET2_T .
  methods SET_STATUS_ORD
    importing
      !STSMA type J_STSMA
    changing
      !STATUS_INPUT_TAB type ZABSF_PP_T_STATUS_ORD
      !RETURN_TAB type BAPIRET2_T .
  methods SET_STATUS_VORNR
    importing
      !ARBPL type ARBPL
      !AUFNR type AUFNR
      !VORNR type VORNR
      !OBJTY type J_OBART optional
      !STATUS_OPER type J_STATUS optional
      !ACTIONID type ZABSF_PP_E_ACTION optional
    changing
      !STATUS_OUT type J_STATUS optional
      !RETURN_TAB type BAPIRET2_T .
  methods SET_STATUS_WRK
    importing
      !ARBPL type ARBPL
      !WERKS type WERKS_D
      !STATUS type J_STATUS
      !STSMA type J_STSMA
      !ACTIONID type ZABSF_PP_E_ACTION optional
    changing
      !RETURN_TAB type BAPIRET2_T .
  methods GET_STATUS_VORNR
    importing
      !ARBPL type ARBPL
      !AUFNR type AUFNR
      !MATNR type MATNR
      !MAKTX type MAKTX
      !VORNR type VORNR
      !ACTIONID type ZABSF_PP_E_ACTION
    changing
      !VORNR_DETAIL type ZABSF_PP_S_VORNR_DETAIL
      !RETURN_TAB type BAPIRET2_T .
endinterface.
