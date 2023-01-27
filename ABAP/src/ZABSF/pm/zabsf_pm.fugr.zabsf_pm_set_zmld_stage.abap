FUNCTION ZABSF_PM_SET_ZMLD_STAGE.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM OPTIONAL
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(I_AUFNR) TYPE  AUFNR
*"     VALUE(I_MAIN_STEP) TYPE  VORNR
*"     VALUE(I_EQUIPMENT) TYPE  EQUNR OPTIONAL
*"     VALUE(I_MACHINE) TYPE  EQUNR OPTIONAL
*"     VALUE(IS_LOCATION) TYPE  ZABSF_PM_S_MOULDE_LOCATION OPTIONAL
*"     VALUE(I_STATUS) TYPE  CHAR4
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

*Variables
  DATA: l_langu TYPE spras.

*Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

  CALL METHOD ZCL_ABSF_PM=>set_zmld_checklist
    EXPORTING
      i_inputobj   = inputobj
*      it_checklist = it_checklist
      i_aufnr      = i_aufnr
      i_main_step  = i_main_step
      i_equipment  = i_equipment
      i_machine    = i_machine
      is_location  = is_location
      i_status     = i_status
    IMPORTING
      return_tab   = return_tab.


ENDFUNCTION.
