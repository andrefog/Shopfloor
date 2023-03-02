interface ZIF_ABSF_PP_CONSUMPTIONS
  public .


  methods GET_COMPONENTS_ORDER
    importing
      !AUFNR type AUFNR
      !VORNR type VORNR optional
      !AREAID type ZABSF_PP_E_AREAID optional
      !FOR_SUBPRODUCTS type FLAG optional
    changing
      !COMPONENTS_TAB type ZABSF_PP_T_COMPONENTS
      !RETURN_TAB type BAPIRET2_T .
  methods CREATE_CONSUM_MATNR
    importing
      !MATNR type MATNR
      !VORNE type PZPNR
      !LMNGA type LMNGA
      !MEINS type MEINS
      !PLANORDER type PLNUM optional
      !COMPONENTS_TAB type ZABSF_PP_T_COMPONENTS optional
      !MATERIALBATCH type ZABSF_PP_T_MATERIALBATCH optional
      !MATERIALSERIAL type ZABSF_PP_T_MATERIALSERIAL optional
    changing
      !RETURN_TAB type BAPIRET2_T .
  methods CREATE_CONSUM_ORDER
    importing
      !AUFNR type AUFNR
      !COMPONENTS_ST type ZABSF_PP_S_COMPONENTS optional
      !ADIT_MATNR_ST type ZABSF_PP_S_ADIT_MATNR optional
      !LENUM type LENUM optional
    changing
      !RETURN_TAB type BAPIRET2_T .
  methods GET_COMPONENTS_MATNR
    importing
      !MATNR type MATNR
      !VORNR type PZPNR
      !LMNGA type LMNGA
      !MEINS type MEINS
    changing
      !COMPONENTS_TAB type ZABSF_PP_T_COMPONENTS
      !RETURN_TAB type BAPIRET2_T .
  methods GET_BATCH_CONSUMED
    importing
      !AUFNR type AUFNR
      !VORNR type VORNR
    exporting
      !FICHA type ZABSF_PP_E_FICHA
      !TIME type RU_ISDZ
      !BATCH_CONSUMED_TAB type ZABSF_PP_T_BATCH_CONSUMED
    changing
      !RETURN_TAB type BAPIRET2_T .
  methods REM_COMPONENTS_ORDER
    importing
      !AUFNR type AUFNR
      !VORNR type VORNR optional
    changing
      !COMPONENTS_TAB type ZABSF_PP_T_COMPONENTS
      !RETURN_TAB type BAPIRET2_T .
  methods CREATE_TRANSF_POST
    importing
      !IV_MATNR type MATNR
      !IV_LMNGA type LMNGA
      !IV_MEINS type MEINS
      !IV_SLGORT type LGORT_D
      !IV_DLGORT type LGORT_D
    changing
      !CT_RETURN type BAPIRET2_T .
endinterface.
