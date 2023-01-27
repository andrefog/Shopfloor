class ZCL_SF_BDC definition
  public
  final
  create public .

public section.

  class-methods BDC_DYNPRO
    importing
      !IV_PROGRAM_VAR type BDC_PROG
      !IV_DYNPRO_VAR type BDC_DYNR
    changing
      !CH_BDCDATA_TAB type BDCDATA_TAB .
  class-methods BDC_FIELD
    importing
      !IV_FNAM_VAR type FNAM_____4
      !IV_FVAL_VAR type BDC_FVAL
    changing
      !CH_BDCDATA_TAB type BDCDATA_TAB .
protected section.
private section.
ENDCLASS.



CLASS ZCL_SF_BDC IMPLEMENTATION.


  method bdc_dynpro.
    append value #( program  = iv_program_var
                    dynpro   = iv_dynpro_var
                    dynbegin = abap_true ) to ch_bdcdata_tab.
  endmethod.


  method bdc_field.
    append value #( fnam = iv_fnam_var
                    fval = iv_fval_var ) to ch_bdcdata_tab.
  endmethod.
ENDCLASS.
