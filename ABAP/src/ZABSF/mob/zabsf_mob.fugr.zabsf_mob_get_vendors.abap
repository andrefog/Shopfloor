function zabsf_mob_get_vendors.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(INPUTOBJ) TYPE  ZABSF_MOB_S_INPUTOBJECT
*"     VALUE(IV_LIFNR) TYPE  LIFNR OPTIONAL
*"     VALUE(IV_NAME1) TYPE  NAME1_GP OPTIONAL
*"  EXPORTING
*"     VALUE(ET_VENDORS) TYPE  ZABSF_MOB_T_VENDORS_LIST
*"----------------------------------------------------------------------
  "variáveis locais
  data: lr_lifnr type rsis_t_range,
        lr_name1 type rsis_t_range.
  "criar range de fornecedor
  if iv_lifnr is not initial.
    "criar range de fornecedor
    append value #( sign = 'I'
                    option = 'CP'
                    low = |{ '*' }{ iv_lifnr }{ '*' }| ) to lr_lifnr.
  endif.
  if iv_name1 is not initial.
    "criar range para nome de fornecedor
    append value #( sign = 'I'
                    option = 'CP'
                    low = |{ '*' }{ iv_name1 }{ '*' }| ) to lr_name1.
  endif.
  "obter fornecedores
  select lifnr, name1, land1
    from lfa1
    into corresponding fields of table @et_vendors
      where lifnr in @lr_lifnr
        and name1 in @lr_name1.
endfunction.
