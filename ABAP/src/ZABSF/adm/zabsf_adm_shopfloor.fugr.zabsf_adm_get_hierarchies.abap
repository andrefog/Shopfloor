FUNCTION ZABSF_ADM_GET_HIERARCHIES.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"  EXPORTING
*"     VALUE(HIERARCHIES_AND_WORKCTS) TYPE  ZABSF_PP_T_WRKCTR
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

 data: ls_hier_str  type zabsf_pp_s_wrkctr,
        lt_crhs      type table of crhs,
        lt_crhd      type table of crhd,
        ls_crhd      type crhd,
        lt_crtx      type table of crtx,
        l_langu      type sy-langu,
        ls_sf013     type zabsf_pp013,
        ls_wrkctr    type zabsf_pp_s_wrkctr,
        ls_crtx      type crtx,
        lv_objid_var type objid_up.

  "obter as hierarquias
  select crhh~*
    from crhh as crhh
    inner join zabsf_pp002 as zpp2
    on zpp2~hname eq crhh~name
    into table @data(lt_hierarchies_tab)
      where zpp2~werks eq @inputobj-werks
        and begda le @sy-datum
        and endda ge @sy-datum.

  "percorrer as hierarquias
  loop at lt_hierarchies_tab into data(ls_hierchies_str).

    call function 'CR_HIERARCHY_OBJECTS'
      exporting
        objid               = ls_hierchies_str-objid
      tables
        t_crhs              = lt_crhs
      exceptions
        hierarchy_not_found = 1
        others              = 2.
    if sy-subrc eq 0.
      "adicionar hierarquia
      append value #( arbpl = ls_hierchies_str-name
                      objid = ls_hierchies_str-objid
                      objty = 'H' ) to lt_crhd.
      "centros de trabalho
      loop at lt_crhs into data(ls_crhs_str).
        "obter CT
        select single crhd~arbpl, crhd~objid, crhd~objty, crhs~objid_up
          from crhs as crhs
          inner join crhd as crhd
           on crhd~objid eq crhs~objid_ho
          into @data(ls_workcenter_str)
           where objid_ho eq @ls_crhs_str-objid_ho.
        if sy-subrc eq 0.
          move-corresponding ls_workcenter_str to ls_crhd.
          append ls_crhd to lt_crhd.
        endif.
      endloop.
    endif.
  endloop.

  sort lt_crhd by arbpl.
  delete adjacent duplicates from lt_crhd comparing arbpl.

  if lt_crhd[] is not initial.
*      Get Workcenter description
    select *
      from crtx
      into corresponding fields of table lt_crtx
       for all entries in lt_crhd
     where objty eq lt_crhd-objty
       and objid eq lt_crhd-objid
       and spras eq sy-langu.

    loop at lt_crhd into ls_crhd.
      clear ls_wrkctr.

*        Workcenter
      ls_wrkctr-arbpl = ls_crhd-arbpl.
      "decrição centro de trabalho
      read table lt_crtx into ls_crtx with key objid = ls_crhd-objid.
      if sy-subrc eq 0.
        ls_wrkctr-ktext = ls_crtx-ktext.
      endif.
      "verificar se é CT ou hierarquia
      select single * from zabsf_pp013 into ls_sf013
        where werks = inputobj-werks
        and arbpl = ls_crhd-arbpl
        and begda le sy-datlo
        and endda ge sy-datlo.
      if sy-subrc eq 0.
        ls_wrkctr-objty = 'A'.
      else.
        ls_wrkctr-objty = 'H'.
      endif.

      "obter CT parent
      select single crhd~arbpl
        from crhs as crhs
        inner join crhd as crhd
         on crhd~objid eq crhs~objid_up
        into ( @ls_wrkctr-parent )
         where objid_ho eq @ls_crhd-objid
           and objty_up eq 'A'
           and objid_up ne @lv_objid_var.
      if sy-subrc ne 0.
        "obter hierarquia superior
        select single crhh~name
          from crhs as crhs
          inner join crhh as crhh
           on crhh~objid eq crhs~objid_hy
          into ( @ls_wrkctr-parent )
           where objid_ho eq @ls_crhd-objid
             and objty_hy eq 'H'
             and objid_up eq @lv_objid_var.
      endif.

      append ls_wrkctr to hierarchies_and_workcts.
    endloop.
  endif.



ENDFUNCTION.
