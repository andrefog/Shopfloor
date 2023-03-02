FUNCTION ZABSF_PP_SET_OVERRIDE_STATUS.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"     VALUE(AUFNR) TYPE  AUFNR
*"     VALUE(STATUS) TYPE  FLAG OPTIONAL
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"--------------------------------------------------------------------
"variáveis locais
  data ls_override_str type zabsf_pp080.
  "criar estrutura de actualização
  ls_override_str = value #( aufnr     = |{ aufnr alpha = in }|
                             oprid     = inputobj-oprid
                             werks     = inputobj-werks
                             pernr     = inputobj-pernr
                             erdat     = inputobj-dateconf
                             time      = inputobj-timeconf
                             override  = status ).
  "actualizar tabela
  modify zabsf_pp080 from ls_override_str.
  if sy-subrc eq 0.
    "commit da base de dados
    commit work and wait.
  else.
    "rollback
    rollback work.
    "ocorreu um erro ao actualizar registo na Base de Dados
    zabsf_pp_cl_log=>add_message( exporting
                                    msgty      = 'E'
                                    msgno      = '068'
                                  changing
                                    return_tab = return_tab ).
  endif.





ENDFUNCTION.
