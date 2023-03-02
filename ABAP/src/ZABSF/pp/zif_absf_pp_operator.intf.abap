interface ZIF_ABSF_PP_OPERATOR
  public .


  methods GET_OPERATOR
    importing
      !ARBPL type ARBPL
      !AUFNR type AUFNR
      !VORNR type VORNR
      !TIPORD type ZABSF_PP_E_TIPORD default 'N'
    changing
      !OPERATOR_TAB type ZABSF_PP_T_OPERADOR
      !RETURN_TAB type BAPIRET2_T .
  methods GET_OPERATOR_RPOINT
    importing
      !RPOINT type ZABSF_PP_E_RPOINT
    changing
      !OPERATOR_TAB type ZABSF_PP_T_OPERADOR
      !RETURN_TAB type BAPIRET2_T .
  methods SET_REFDT
    importing
      !NEW_REFDT type VVDATUM .
  methods SET_OPERATOR
    importing
      !ARBPL type ARBPL
      !AUFNR type AUFNR
      !VORNR type VORNR
      !TIPORD type ZABSF_PP_E_TIPORD default 'N'
      !OPERATOR_TAB type ZABSF_PP_T_OPERADOR
      !KAPID type KAPID optional
    changing
      !RETURN_TAB type BAPIRET2_T .
  methods SET_OPERATOR_RPOINT
    importing
      !RPOINT type ZABSF_PP_E_RPOINT
      !TIME type ATIME
      !OPERATOR_TAB type ZABSF_PP_T_OPERADOR
      !SHIFTID type ZABSF_PP_E_SHIFTID optional
    changing
      !RETURN_TAB type BAPIRET2_T .
  methods GET_OPERATOR_WRKCTR
    importing
      !ARBPL type ARBPL
    changing
      !OPER_WRKCTR_TAB type ZABSF_PP_T_OPERADOR
      !RETURN_TAB type BAPIRET2_T .
  methods GET_OPERATOR_ORD
    importing
      !ARBPL type ARBPL
      !AUFNR type AUFNR
      !VORNR type VORNR
      !TIPORD type ZABSF_PP_E_TIPORD default 'N'
    changing
      !OPERATOR_TAB type ZABSF_PP_T_OPERADOR
      !RETURN_TAB type BAPIRET2_T .
endinterface.
