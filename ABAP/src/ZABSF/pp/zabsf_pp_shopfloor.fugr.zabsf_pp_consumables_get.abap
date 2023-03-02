FUNCTION ZABSF_PP_CONSUMABLES_GET.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(AUFNR) TYPE  AUFNR
*"  EXPORTING
*"     VALUE(CONSUMABLES) TYPE  ZPP_CONSUMABLES_TABLE
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"--------------------------------------------------------------------
" Check input
  IF aufnr IS INITIAL.
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '201'
        msgv1      = 'AUFNR'
      CHANGING
        return_tab = return_tab.
    RETURN.
  ENDIF.

  " Make sure production order is in DB format
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = aufnr
    IMPORTING
      output = aufnr.

  " Get data
  SELECT aufnr, type, creation_date, value, oprid
    INTO TABLE @consumables
    FROM zpp_consumables
    WHERE aufnr = @aufnr
    ORDER BY PRIMARY KEY.
  IF sy-subrc <> 0.
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '202'
        msgv1      = aufnr
      CHANGING
        return_tab = return_tab.
    RETURN.
  ENDIF.





ENDFUNCTION.
