FUNCTION ZABSF_PP_BATCH_OPERATIONS.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(ARBPL_PRINT_ST) TYPE  ZABSF_PP_S_ARBPL_PRINT OPTIONAL
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"     VALUE(BATCH) TYPE  CHARG_D OPTIONAL
*"     VALUE(LENUM) TYPE  LENUM OPTIONAL
*"     VALUE(CREATE_AND_RETREIVE) TYPE  FLAG OPTIONAL
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"--------------------------------------------------------------------
DATA: l_langu   TYPE spras.


  DATA: lref_print            TYPE REF TO zabsf_pp_cl_print,
        lref_batch_operations TYPE REF TO zabsf_pp_cl_batch_operations.


*Set local language for user
  l_langu = sy-langu.

  CREATE OBJECT lref_batch_operations
    EXPORTING
      initial_refdt  = refdt
      input_object   = inputobj
      input_print_st = arbpl_print_st.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = batch
    IMPORTING
      output = batch.

  IF batch IS INITIAL.
* Close Box
    CALL METHOD lref_batch_operations->close_batch
      CHANGING
        return_tab = return_tab.

  ELSE.
* Retreive Box
    IF create_and_retreive EQ abap_false.
      CALL METHOD lref_batch_operations->retreive_batch
        EXPORTING
          batch      = batch
          lenum      = lenum
        CHANGING
          return_tab = return_tab.
    ELSE.
      "1º - Create
      CALL METHOD lref_batch_operations->create_batch
        EXPORTING
          matnr      = arbpl_print_st-matnr
          batch      = batch
          werks      = inputobj-werks
        CHANGING
          return_tab = return_tab.

      IF return_tab is INITIAL.
      "2º - retreive if creation was successeful.
      CALL METHOD lref_batch_operations->retreive_batch
        EXPORTING
          batch      = batch
          lenum      = lenum
        CHANGING
          return_tab = return_tab.
      endif.
    ENDIF.

  ENDIF.

  COMMIT WORK AND WAIT.





ENDFUNCTION.
