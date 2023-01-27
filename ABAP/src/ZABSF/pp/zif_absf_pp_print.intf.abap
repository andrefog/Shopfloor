interface ZIF_ABSF_PP_PRINT
  public .


  methods SET_REFDT
    importing
      !NEW_REFDT type VVDATUM .
  methods PRINT
    importing
      !ARBPL_PRINT_ST type ZABSF_PP_S_ARBPL_PRINT optional
      !WARE_PRINT_ST type ZABSF_PP_S_WARE_PRINT optional
    changing
      !RETURN_TAB type BAPIRET2_T .
  methods GENERATE_FILE
    importing
      !DOC_ID type ZABSF_PP_E_DOC_ID optional
      !MATNR_TAB type ZABSF_PP_T_MATNR
    changing
      !FILE type LOCALFILE optional
      !PDF_CONTENT type SOLIX_TAB optional
      !RETURN_TAB type BAPIRET2_T .
  methods GET_NAME_FORM
    importing
      !FORMNAME type TDSFNAME
    changing
      !FM_NAME type RS38L_FNAM
      !RETURN_TAB type BAPIRET2_T .
  methods PRINT_PP_LABEL
    importing
      !ARBPL_PRINT_ST type ZABSF_PP_S_ARBPL_PRINT optional
      !WARE_PRINT_ST type ZABSF_PP_S_WARE_PRINT optional
      !BATCH type CHARG_D optional
      !ERFMG type MB_ERFMG optional
      !SHIFTID type ZABSF_PP_E_SHIFTID optional
    changing
      !RETURN_TAB type BAPIRET2_T .
  methods PRINT_FIRST_CYCLE
    importing
      !ARBPL_PRINT_ST type ZABSF_PP_S_ARBPL_PRINT optional
      !WARE_PRINT_ST type ZABSF_PP_S_WARE_PRINT optional
      !BATCH type CHARG_D optional
      !ERFMG type MB_ERFMG optional
    changing
      !RETURN_TAB type BAPIRET2_T .
endinterface.
