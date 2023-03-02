FUNCTION zabsf_pp_get_workcentersarea.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_AREAID) TYPE  ZABSF_PP_E_AREAID
*"     VALUE(IV_REFDT) TYPE  DATUM DEFAULT SY-DATUM
*"     VALUE(IS_INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     REFERENCE(ET_WORKCENTERSAREA) TYPE  ZABSF_PP_T_WORKCENTERSAREA
*"     REFERENCE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA(lv_date) = sy-datum.

  SELECT areaid, werks, arbpl, endda, begda
    FROM zabsf_pp013 INTO TABLE @et_workcentersarea
    WHERE areaid EQ @iv_areaid
    AND werks EQ '0070'
    AND endda GE @sy-datum
    AND begda LE @sy-datum.

ENDFUNCTION.
