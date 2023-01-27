function zabsf_pp_get_work_stations .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(ARBPL) TYPE  ARBPL
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(WORK_STATIONS) TYPE  ZABSF_PP_TT_WORKSTATION
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------~
  "variáveis locais
  data: lv_inikapie_var type kapid,
        l_langu TYPE spras.

*Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.
  "obter id do ct
*  select crhd~objid, crhd~arbpl, crhd~werks, kako~kapid, kako~name
*    , kakt~ktext
*    from crhd as crhd
*    inner join kako as kako
*    on kako~kapie eq crhd~kapid
**    on crhd~kapid eq kako~kapid
*    left join kakt as kakt
*    on kakt~kapid eq kako~kapid
*    and kakt~spras eq @l_langu
*    into corresponding fields of table @work_stations
*      where crhd~arbpl eq @arbpl
*        and crhd~werks eq @inputobj-werks
*        and crhd~objty eq 'A'
*        and kako~kapie ne @lv_inikapie_var.
endfunction.
