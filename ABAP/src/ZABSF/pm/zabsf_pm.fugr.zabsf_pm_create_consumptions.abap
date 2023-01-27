FUNCTION zabsf_pm_create_consumptions.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(AUFNR) TYPE  AUFNR
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(CONSUMPTIONS_TAB) TYPE  ZABSF_PM_T_CONSUMPTIONS_LIST
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
*Variables
  DATA: l_langu TYPE spras.

  DATA: lt_comsumptions TYPE zabsf_pm_t_consumptions_list,
        lt_components   TYPE zabsf_pm_t_consumptions_list.


*Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.


  LOOP AT consumptions_tab INTO DATA(ls_coms).

    CASE ls_coms-postp.
      WHEN 'L'.
        APPEND ls_coms TO lt_comsumptions.

      WHEN 'N'.
        APPEND ls_coms TO lt_components.
        WHEN OTHERS. "shouldn't happen
    ENDCASE.

  ENDLOOP.


  IF NOT lt_components IS INITIAL.

*   Create consumptions for Order
    CALL METHOD zcl_absf_pm=>create_pr
      EXPORTING
        i_aufnr         = aufnr
        i_inputobj      = inputobj
        it_consumptions = lt_components
      IMPORTING
        return_tab      = return_tab.

  ENDIF.

  IF NOT lt_comsumptions IS INITIAL.


*   Create consumptions for Order
    CALL METHOD zcl_absf_pm=>create_consumptions
      EXPORTING
        i_aufnr         = aufnr
        i_inputobj      = inputobj
        it_consumptions = lt_comsumptions
      IMPORTING
        return_tab      = return_tab.

  ENDIF.


ENDFUNCTION.
