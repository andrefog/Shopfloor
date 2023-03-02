FUNCTION ZABSF_PP_CONSUMABLES_DELETE.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(CONSUMABLES) TYPE  ZPP_CONSUMABLES_TABLE
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"--------------------------------------------------------------------
" Check input
  IF consumables IS INITIAL.
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '201'
        msgv1      = 'CONSUMABLES'
      CHANGING
        return_tab = return_tab.
    RETURN.
  ENDIF.

  " Convert data to DB
  DATA consumables_db TYPE STANDARD TABLE OF zpp_consumables.
  MOVE-CORRESPONDING consumables TO consumables_db.

  " Delete data
  DELETE zpp_consumables FROM TABLE consumables_db.

  " Check result
  IF sy-subrc = 0.
    " Everything ok
    COMMIT WORK AND WAIT.
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'S'
        msgno      = '205'
        msgv1      = sy-dbcnt
      CHANGING
        return_tab = return_tab.
  ELSE.
    " Error
    ROLLBACK WORK.
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '206'
        msgv1      = 'ZPP_CONSUMABLES'
      CHANGING
        return_tab = return_tab.
    RETURN.
  ENDIF.





ENDFUNCTION.
