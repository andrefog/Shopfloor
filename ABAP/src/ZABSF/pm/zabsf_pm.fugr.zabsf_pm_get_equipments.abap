FUNCTION ZABSF_PM_GET_EQUIPMENTS .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(I_ONLY_MOULDS) TYPE  BOOLE_D OPTIONAL
*"     VALUE(I_EQUNR) TYPE  EQUNR OPTIONAL
*"     VALUE(I_EQKTX) TYPE  KTX01 OPTIONAL
*"     VALUE(I_ARBPL) TYPE  ARBPL OPTIONAL
*"  EXPORTING
*"     VALUE(ET_EQUIPMENTS) TYPE  ZABSF_PM_T_EQUIPMENTS_LIST
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
*&---------------------------------------------------------------------*
*  04.04.2017 - Cidália Correia (CBC) - Abaco Consultores
*  CHANGE REQUEST: CR 13.4 - ELASTOMER_Technical_SF_MAN_CR 13.4 Create notification at Maintenance Shopfloor.docx
*  DESCRIPTION   :  Include equipment type and it's description and filter by main work center (i_arbpl)
*&--------------------------------------------------------------------*

*  Variables
  DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

CALL METHOD ZCL_ABSF_PM=>get_equipments
  EXPORTING
    i_werks       = inputobj-werks
    i_only_moulds = i_only_moulds
    i_equnr       = i_equnr
    i_eqktx       = i_eqktx
*>>> CBC - CR13.4 - 04.04.2017
    i_arbpl       = i_arbpl
*>>> CBC - CR13.4 - 04.04.2017
  IMPORTING
    et_equipment  = et_equipments.


ENDFUNCTION.
