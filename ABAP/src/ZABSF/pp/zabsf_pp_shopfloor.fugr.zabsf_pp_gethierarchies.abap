FUNCTION ZABSF_PP_GETHIERARCHIES.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"     VALUE(REFDT) TYPE  VVDATUM
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"     VALUE(HIERARCHIES_TAB) TYPE  ZABSF_PP_T_HRCHY
*"--------------------------------------------------------------------
* local references
  DATA: lref_sf_wrkctr    TYPE REF TO zabsf_pp_cl_wrkctr,
        lref_sf_dashboard TYPE REF TO zabsf_pp_cl_dashboard.

  DATA: l_langu TYPE spras.
*Set local language for user
  l_langu = sy-langu.

  CREATE OBJECT lref_sf_dashboard
    EXPORTING
      input_refdt    = refdt
      input_inputobj = inputobj.

  CALL METHOD lref_sf_dashboard->get_hierarchies
    CHANGING
      hierarchies = hierarchies_tab.

  IF hierarchies_tab[] IS INITIAL.

    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '018'
      CHANGING
        return_tab = return_tab.
  ENDIF.





ENDFUNCTION.
