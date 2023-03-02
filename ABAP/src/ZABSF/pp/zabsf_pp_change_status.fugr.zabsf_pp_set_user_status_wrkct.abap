FUNCTION ZABSF_PP_SET_USER_STATUS_WRKCT.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(OBJNR) TYPE  J_OBJNR
*"     VALUE(OLD_STATUS) TYPE  J_STATUS
*"     VALUE(NEW_STATUS) TYPE  J_STATUS
*"     REFERENCE(MESSAGE_CLASS) TYPE  SY-MSGID DEFAULT 'ZABSF_PP'
*"  EXPORTING
*"     REFERENCE(RETURN) TYPE  BAPIRET2
*"--------------------------------------------------------------------
DATA: jest_ins TYPE TABLE OF jest_upd,
        jest_upd TYPE TABLE OF jest_upd,
        jsto_ins TYPE TABLE OF jsto,
        jsto_upd TYPE TABLE OF jsto_upd,
        obj_del  TYPE TABLE OF onr00.

  DATA: ls_jest_old TYPE jest,
        ls_jest_new TYPE jest,
        ls_jsto     TYPE jsto,
        wa_update   TYPE jest_upd,
        wa_insert   TYPE jest_upd.

  REFRESH: jest_ins,
           jest_upd,
           jsto_upd,
           jsto_ins,
           obj_del.

  CLEAR: wa_update,
         wa_insert,
         ls_jest_new,
         ls_jest_old,
         ls_jsto.

*Get data from jsto
  SELECT SINGLE *
    FROM jsto
    INTO CORRESPONDING FIELDS OF ls_jsto
    WHERE objnr EQ objnr.

*Get information for old status
  SELECT SINGLE *
    FROM jest
    INTO CORRESPONDING FIELDS OF ls_jest_old
    WHERE objnr EQ objnr
      AND stat  EQ old_status.

*Get information for new status
  SELECT SINGLE *
    FROM jest
    INTO CORRESPONDING FIELDS OF ls_jest_new
    WHERE objnr EQ objnr
      AND stat  EQ new_status.

  IF sy-subrc NE 0.
*  Insert new status
    wa_insert-mandt = sy-mandt.
    wa_insert-objnr = objnr.
    wa_insert-stat = new_status.
    wa_insert-inact = space.
    wa_insert-chgnr = 001.
    wa_insert-chgkz = 'X'.
    wa_insert-obtyp = ls_jsto-obtyp.
    wa_insert-stsma = ls_jsto-stsma.

    APPEND wa_insert TO jest_ins.

    CLEAR wa_insert.
  ELSE.
*Update new status
    wa_update-mandt = sy-mandt.
    wa_update-objnr = objnr.
    wa_update-stat = new_status.
    wa_update-inact = space.
    wa_update-chgnr = ls_jest_new-chgnr + 1.
    wa_update-chgkz = 'X'.
    wa_update-obtyp = ls_jsto-obtyp.
    wa_update-stsma = ls_jsto-stsma.

    APPEND wa_update TO jest_upd.

    CLEAR wa_update.
  ENDIF.

*Update old status to inative
  wa_update-mandt = sy-mandt.
  wa_update-objnr = objnr.
  wa_update-stat = old_status.
  wa_update-inact = 'X'.
  wa_update-chgnr = ls_jest_old-chgnr + 1.
  wa_update-chgkz = 'X'.
  wa_update-obtyp = ls_jsto-obtyp.
  wa_update-stsma = ls_jsto-stsma.

  APPEND wa_update TO jest_upd.

  CALL FUNCTION 'STATUS_UPDATE'
    TABLES
      jest_ins = jest_ins
      jest_upd = jest_upd
      jsto_ins = jsto_ins
      jsto_upd = jsto_upd
      obj_del  = obj_del.

  IF sy-subrc EQ 0.
    CALL FUNCTION 'BALW_BAPIRETURN_GET2'
      EXPORTING
        type   = 'S'
        cl     = message_class
        number = '013'
      IMPORTING
        return = return.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.
  ELSE.
    CALL FUNCTION 'BALW_BAPIRETURN_GET2'
      EXPORTING
        type   = 'E'
        cl     = message_class
        number = '012'
      IMPORTING
        return = return.

    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

  ENDIF.





ENDFUNCTION.
