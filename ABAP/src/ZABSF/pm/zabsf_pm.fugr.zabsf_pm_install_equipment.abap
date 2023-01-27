FUNCTION ZABSF_PM_INSTALL_EQUIPMENT.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM OPTIONAL
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(I_EQUIPMENT) TYPE  EQUNR
*"     VALUE(I_MACHINE) TYPE  EQUNR
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
*  Variables
  DATA: l_langu    TYPE spras,
        lt_return  TYPE bapiret2_t,
        ls_mouldes TYPE ZABSF_PM_s_moulde_location,
        lt_mouldes TYPE ZABSF_PM_t_moulde_location,
        ra_eqtyp   TYPE RANGE OF eqtyp,
        lv_eqtyp   TYPE eqtyp.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

  SET UPDATE TASK LOCAL.

*1) Install Equipment on Machine

  CALL METHOD ZCL_ABSF_PM=>install_equipment_on_machine
    EXPORTING
      i_inputobj  = inputobj
      i_equipment = i_equipment
      i_machine   = i_machine
    IMPORTING
      et_return   = return_tab.


*2) Clear Location if equipment is type 'C'

  LOOP AT return_tab TRANSPORTING NO FIELDS
         WHERE type CA 'AEX'.

    EXIT.
  ENDLOOP.

  IF sy-subrc NE 0.
    SELECT SINGLE eqtyp FROM equi INTO lv_eqtyp
      WHERE equnr = i_equipment.

    CALL METHOD ZCL_ABSF_PM=>get_parameter
      EXPORTING
        i_werks     = inputobj-werks
        i_parameter = 'EQTYP_MOULD'
      IMPORTING
        et_range    = ra_eqtyp.

    IF lv_eqtyp IN ra_eqtyp.

      ls_mouldes-equnr = i_equipment.
      APPEND ls_mouldes TO lt_mouldes.

      CALL METHOD ZCL_ABSF_PM=>change_moulde_location
        EXPORTING
          i_inputobj = inputobj
          it_mouldes = lt_mouldes
        IMPORTING
          return_tab = lt_return.

      APPEND LINES OF lt_return TO return_tab.
    ENDIF.
  ENDIF.


ENDFUNCTION.
