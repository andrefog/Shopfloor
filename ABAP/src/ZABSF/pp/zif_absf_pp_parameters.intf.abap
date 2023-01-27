interface ZIF_ABSF_PP_PARAMETERS
  public .


  methods SET_REFDT
    importing
      !NEW_REFDT type VVDATUM .
  methods GET_PARAMETERS
    changing
      !PARAMETERS_TAB type ZABSF_PP_T_PARAMETERS
      !RETURN_TAB type BAPIRET2_T .
endinterface.
