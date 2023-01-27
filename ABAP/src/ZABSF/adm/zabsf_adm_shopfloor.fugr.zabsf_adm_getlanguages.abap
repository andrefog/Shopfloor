FUNCTION ZABSF_ADM_GETLANGUAGES.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(LANGUAGES_TAB) TYPE  ZABSF_PP_T_LANGUAGES
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

 DATA lref_sf_administration TYPE REF TO zabsf_adm_cl_administration.

  CREATE OBJECT lref_sf_administration
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

*Get plants
  CALL METHOD lref_sf_administration->get_languages
    CHANGING
      languages_tab = languages_tab
      return_tab    = return_tab.

ENDFUNCTION.
