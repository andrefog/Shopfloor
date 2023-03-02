FUNCTION ZABSF_PP_PRINT.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(ARBPL_PRINT_ST) TYPE  ZABSF_PP_S_ARBPL_PRINT OPTIONAL
*"     VALUE(WARE_PRINT_ST) TYPE  ZABSF_PP_S_WARE_PRINT OPTIONAL
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"--------------------------------------------------------------------
call method zabsf_pp_cl_print=>print_short_label
    exporting
      inputobj   = inputobj
      arbpl      = arbpl_print_st-arbpl
      aufnr      = arbpl_print_st-aufnr
      matnr      = arbpl_print_st-matnr
    importing
      return_tab = return_tab.





ENDFUNCTION.
