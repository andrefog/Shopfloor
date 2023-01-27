FUNCTION ZABSF_ADM_GETPLANTS.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT OPTIONAL
*"  EXPORTING
*"     VALUE(WERKS_TAB) TYPE  ZABSF_PP_T_WERKS
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

data lref_sf_administration type ref to zabsf_adm_cl_administration.

  create object lref_sf_administration
    exporting
      initial_refdt = refdt
      input_object  = inputobj.

*Get plants
  call method lref_sf_administration->get_plants
    changing
      werks_tab  = werks_tab
      return_tab = return_tab.

  "remover duplicados
  sort werks_tab by werks.
  delete adjacent duplicates from werks_tab comparing werks.



ENDFUNCTION.
