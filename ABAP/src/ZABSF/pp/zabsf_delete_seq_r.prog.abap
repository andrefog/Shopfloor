*&---------------------------------------------------------------------*
*&  Programa         ZABSF_DELETE_SEQ_R
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& DESCRIPTION    : Programa de eliminar ordens encerrada da sequência do SF
*&
*& AUTHOR(S)      : Bruno Ribeiro - Abaco Consulting
*& CREATED ON     : 19.10.2020
*&---------------------------------------------------------------------*

report zabsf_delete_seq_r.
"constantes locais
constants: lc_teco_cst type j_status value 'I0045'. "TECO
"variávies locais
data: lt_zpp84_tab type table of zabsf_pp084.

"obter ordens ainda activas no SF
select zpp84~aufnr, zpp84~werks, zpp84~vornr, zpp84~arbpl,
       aufk~objnr, jest~stat
  from zabsf_pp084 as zpp84
    inner join aufk as aufk
    on aufk~aufnr eq zpp84~aufnr
  inner join jest as jest
    on jest~objnr eq aufk~objnr
  into table @data(lt_prodords_tab)
    where jest~stat eq @lc_teco_cst.
if sy-subrc ne 0.
  "Sem ordens para remover
  write: text-001.
else.
  "seleccionar ordens teco
  select *
    from zabsf_pp084
    into table @lt_zpp84_tab
    for all entries in @lt_prodords_tab
    where werks eq @lt_prodords_tab-werks
      and arbpl eq @lt_prodords_tab-arbpl
      and aufnr eq @lt_prodords_tab-aufnr
      and vornr eq @lt_prodords_tab-vornr.
  "eliminar linhas
  delete zabsf_pp084 from table lt_zpp84_tab.
  if sy-subrc eq 0.
    "commit operação
    commit work.
    "Entradas eliminadas com sucesso
    write / lines( lt_zpp84_tab ).
    write / text-003.
  else.
    "rollback
    rollback work.
    "Ocorreram erros ao eliminar entradas
    write: text-002.
  endif.
endif.
