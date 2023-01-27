function zabsf_mob_navigat.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(INPUTOBJ) TYPE  ZABSF_MOB_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(NAV_TAB) TYPE  ZABSF_MOB_CONFIG_TT
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  "limpar variávies exportação
  refresh: nav_tab,
          return_tab.
  "obter menu
  select * from zabsf_mob_config
    into table @data(lt_mob_config_tab)
      where werks eq @inputobj-werks.
  if sy-subrc = 0.
    nav_tab = lt_mob_config_tab.
  else.
    "Sem dados na tabela de navegação ZABSF_MOB_NAVIGATION
    call method zabsf_mob_cl_log=>add_message
      exporting
        msgty      = 'E'
        msgno      = 003
      changing
        return_tab = return_tab.
  endif.
endfunction.
