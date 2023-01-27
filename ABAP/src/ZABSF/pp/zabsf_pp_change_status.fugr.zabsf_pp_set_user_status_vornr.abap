function zabsf_pp_set_user_status_vornr .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(OBJNR) TYPE  J_OBJNR
*"     VALUE(OLD_STATUS) TYPE  J_STATUS OPTIONAL
*"     VALUE(NEW_STATUS) TYPE  J_STATUS
*"     REFERENCE(MESSAGE_CLASS) TYPE  SY-MSGID DEFAULT 'ZABSF_PP'
*"  EXPORTING
*"     REFERENCE(RETURN) TYPE  BAPIRET2
*"     REFERENCE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
*{   INSERT         DEVK931753                                        1
  data: jest_ins type table of jest_upd,
        jest_upd type table of jest_upd,
        jsto_ins type table of jsto,
        jsto_upd type table of jsto_upd,
        obj_del  type table of onr00.

  data: ls_jest_old type jest,
        ls_jest_new type jest,
        ls_jsto     type jsto,
        wa_update   type jest_upd,
        wa_insert   type jest_upd.

  refresh: jest_ins,
           jest_upd,
           jsto_upd,
           jsto_ins,
           obj_del.

  clear: wa_update,
         wa_insert,
         ls_jest_new,
         ls_jest_old,
         ls_jsto.

*Get data from jsto
  select single *
    from jsto
    into corresponding fields of ls_jsto
    where objnr eq objnr
      and stsma eq 'ZBYSTEEL'.
  if sy-subrc ne 0.
    call method zabsf_pp_cl_log=>add_message
      exporting
        msgno      = '152'
        msgty      = 'E'
      changing
        return_tab = return_tab.
    return.
  endif.
*Get information for old status
  if old_status is not initial.
    select single *
      from jest
      into corresponding fields of ls_jest_old
      where objnr eq objnr
        and stat  eq old_status.
  endif.

*Get information for new status
  select single *
    from jest
    into corresponding fields of ls_jest_new
    where objnr eq objnr
      and stat  eq new_status.

  if sy-subrc ne 0.
*  Insert new status
    wa_insert-mandt = sy-mandt.
    wa_insert-objnr = objnr.
    wa_insert-stat = new_status.
    wa_insert-inact = space.
    wa_insert-chgnr = 001.
    wa_insert-chgkz = 'X'.
    wa_insert-obtyp = ls_jsto-obtyp.
    wa_insert-stsma = ls_jsto-stsma.

    append wa_insert to jest_ins.

    clear wa_insert.
  else.
*Update new status
    wa_update-mandt = sy-mandt.
    wa_update-objnr = objnr.
    wa_update-stat = new_status.
    wa_update-inact = space.
    wa_update-chgnr = ls_jest_new-chgnr + 1.
    wa_update-chgkz = 'X'.
    wa_update-obtyp = ls_jsto-obtyp.
    wa_update-stsma = ls_jsto-stsma.

    append wa_update to jest_upd.

    clear wa_update.
  endif.

*Update old status to inative
  if old_status is not initial.
    wa_update-mandt = sy-mandt.
    wa_update-objnr = objnr.
    wa_update-stat = old_status.
    wa_update-inact = 'X'.
    wa_update-chgnr = ls_jest_old-chgnr + 1.
    wa_update-chgkz = 'X'.
    wa_update-obtyp = ls_jsto-obtyp.
    wa_update-stsma = ls_jsto-stsma.

    append wa_update to jest_upd.

  endif.
  call function 'STATUS_UPDATE'
    tables
      jest_ins = jest_ins
      jest_upd = jest_upd
      jsto_ins = jsto_ins
      jsto_upd = jsto_upd
      obj_del  = obj_del.

  if sy-subrc eq 0.
    call function 'BALW_BAPIRETURN_GET2'
      exporting
        type   = 'S'
        cl     = message_class
        number = '013'
      importing
        return = return.

    call function 'BAPI_TRANSACTION_COMMIT'
      exporting
        wait = 'X'.
  else.
    call function 'BALW_BAPIRETURN_GET2'
      exporting
        type   = 'E'
        cl     = message_class
        number = '012'
      importing
        return = return.

    call function 'BAPI_TRANSACTION_ROLLBACK'.

  endif.
*}   INSERT
endfunction.
