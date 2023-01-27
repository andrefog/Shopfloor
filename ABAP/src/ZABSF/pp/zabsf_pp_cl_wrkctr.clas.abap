class ZABSF_PP_CL_WRKCTR definition
  public
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !INITIAL_REFDT type VVDATUM
      !INPUT_OBJECT type ZABSF_PP_S_INPUTOBJECT .
  methods GET_WORKCENTER_DETAIL
    importing
      !AREADID type ZABSF_PP_E_AREAID
      !WERKS type WERKS_D
      !HNAME type CR_HNAME
      !ARBPL type ARBPL
      !ACTIONID type ZABSF_PP_E_ACTION optional
      !AUFNR type AUFNR optional
      !VORNR type VORNR optional
    changing
      !WRKCTR_DETAIL type ZABSF_PP_S_WRKCTR_DETAIL
      !RETURN_TAB type BAPIRET2_T .
  methods GET_WORKCENTERS
    importing
      !HNAME type CR_HNAME
      !WERKS type WERKS_D
      !NO_SHIFT_CHECK type BOOLE_D optional
    exporting
      !PARENT type CR_HNAME
      !KTEXT type CR_KTEXT
    changing
      !WRKCTR_TAB type ZABSF_PP_T_WRKCTR
      !RETURN_TAB type BAPIRET2_T .
  methods SET_REFDT
    importing
      !NEW_REFDT type VVDATUM .
protected section.
private section.

  data REFDT type VVDATUM .
  data INPUTOBJ type ZABSF_PP_S_INPUTOBJECT .
ENDCLASS.



CLASS ZABSF_PP_CL_WRKCTR IMPLEMENTATION.


METHOD CONSTRUCTOR.

*Ref. Date
  refdt    = initial_refdt.

*App input data
  inputobj = input_object.

ENDMETHOD.


method get_workcenters.
*Internal tables
  data: lt_crhs type table of crhs,
        lt_crhd type table of crhd,
        lt_crtx type table of crtx.

*Structures
  data: ls_crhd   type crhd,
        ls_crtx   type crtx,
        ls_sf013  type zabsf_pp013,
        ls_wrkctr type zabsf_pp_s_wrkctr.
*Variables
  data: l_hrchy_objid type cr_objid,
        l_shiftid     type zabsf_pp_e_shiftid,
        l_langu       type sy-langu,
        lv_objid_var  type objid_up.

  clear: l_langu,
         l_shiftid,
         parent,
         ktext.

*Set local language for user
  l_langu = inputobj-language.

  set locale language l_langu.

*Translate to upper case
  translate inputobj-oprid to upper case.

  if no_shift_check eq abap_false.
*Get shift witch operator is associated
    select single shiftid
      from zabsf_pp052
      into l_shiftid
     where areaid eq inputobj-areaid
       and oprid  eq inputobj-oprid.

    if sy-subrc ne 0.
*  Operator is not associated with shift
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = 'E'
          msgno      = '061'
          msgv1      = inputobj-oprid
        changing
          return_tab = return_tab.
      exit.
    endif.
  endif.

*Get Hierarchy Object ID
  call function 'CR_HIERARCHY_READ_NAME'
    exporting
      name                = hname
      werks               = werks
    importing
      objid               = l_hrchy_objid
    exceptions
      hierarchy_not_found = 1
      others              = 2.

  if sy-subrc = 0.
*  Get hierarchy object relations
    call function 'CR_HIERARCHY_OBJECTS'
      exporting
        objid               = l_hrchy_objid
      tables
        t_crhs              = lt_crhs
      exceptions
        hierarchy_not_found = 1
        others              = 2.

    if sy-subrc = 0.

      "remover CTS que tem pais
      delete lt_crhs
        where objid_up ne lv_objid_var.

*    Get workcenter ID and description
*      select objty objid arbpl
*        from crhd
*        into corresponding fields of table lt_crhd
*         for all entries in lt_crhs
*       where objty eq lt_crhs-objty_ho
*         and objid eq lt_crhs-objid_ho.

*      loop at lt_crhd into ls_crhd.
*
*        select single * from zabsf_pp013 into ls_sf013
*          where werks = werks
*          and arbpl = ls_crhd-arbpl
*          and begda le sy-datlo
*          and endda ge sy-datlo.
*        if sy-subrc ne 0.
*
*          delete lt_crhd.
*        endif.
*        clear ls_crhd.
*      endloop.
    endif.
  else.
    "obter id do centro de trabalho
    select single *
      from crhd
      into @data(ls_crhd_str)
        where arbpl eq @hname
          and werks eq @werks
          and objty eq 'A'.
    if sy-subrc eq 0.
      "obter filhos od CT
      select *
        from crhs
        into table @lt_crhs
          where objty_up eq 'A'
            and objid_up eq @ls_crhd_str-objid.

      "obter CT parent
      select single crhd~arbpl, crhd~objid
        from crhs as crhs
        inner join crhd as crhd
         on crhd~objid eq crhs~objid_up
        into ( @parent, @data(lv_parent_objid_var) )
         where objid_ho eq @ls_crhd_str-objid
           and objty_up eq 'A'
           and objid_up ne @lv_objid_var.
      if sy-subrc ne 0.
        "obter hierarquia superior
        select single crhh~name, crhh~objid
          from crhs as crhs
          inner join crhh as crhh
           on crhh~objid eq crhs~objid_hy
          into ( @parent, @lv_parent_objid_var )
           where objid_ho eq @ls_crhd_str-objid
             and objty_hy eq 'H'
             and objid_up eq @lv_objid_var.
      endif.
    endif.
  endif.

  if lt_crhs[] is not initial.
*    Get workcenter ID and description
    select objty objid arbpl
      from crhd
      into corresponding fields of table lt_crhd
       for all entries in lt_crhs
     where objty eq lt_crhs-objty_ho
       and objid eq lt_crhs-objid_ho.
  else.
*    Get workcenter ID and description
    select objty objid arbpl
      from crhd
      into corresponding fields of table lt_crhd
     where werks eq werks.

  endif.

  if lt_crhd[] is not initial.
*      Get Workcenter description
    select *
      from crtx
      into corresponding fields of table lt_crtx
       for all entries in lt_crhd
     where objty eq lt_crhd-objty
       and objid eq lt_crhd-objid
       and spras eq sy-langu.

    if lt_crtx[] is initial.
      clear l_langu.

*        Get alternative language
      select single spras
        from zabsf_pp061
        into l_langu
       where werks      eq werks
         and is_default ne space.

      if sy-subrc eq 0.
*          Get Workcenter description in alternative language
        select *
          from crtx
          into corresponding fields of table lt_crtx
           for all entries in lt_crhd
         where objty eq lt_crhd-objty
           and objid eq lt_crhd-objid
           and spras eq sy-langu.
      endif.
    endif.

    loop at lt_crhd into ls_crhd.
      clear ls_wrkctr.

*        Workcenter
      ls_wrkctr-arbpl = ls_crhd-arbpl.

*        Read work center description
      read table lt_crtx into ls_crtx with key objty = ls_crhd-objty
                                               objid = ls_crhd-objid.

      if sy-subrc eq 0.
*          Work center description
        ls_wrkctr-ktext = ls_crtx-ktext.
      endif.
      "verificar se é CT ou hierarquia
      select single * from zabsf_pp013 into ls_sf013
        where werks = werks
        and arbpl = ls_crhd-arbpl
        and begda le sy-datlo
        and endda ge sy-datlo.
      if sy-subrc eq 0.
        ls_wrkctr-objty = 'A'.
      else.
        ls_wrkctr-objty = 'H'.
      endif.

      "obter descrição do parent
      select single ktext
        from crtx
        into ktext
       where objid eq lv_parent_objid_var
         and spras eq sy-langu.

      append ls_wrkctr to wrkctr_tab.
    endloop.
  endif.

  if wrkctr_tab[] is initial.
*     No workcenters found
    call method zabsf_pp_cl_log=>add_message
      exporting
        msgty      = 'E'
        msgno      = '006'
      changing
        return_tab = return_tab.
  endif.


*  call method zabsf_pp_cl_log=>add_message
*    exporting
*      msgid      = sy-msgid
*      msgty      = sy-msgty
*      msgno      = sy-msgno
*      msgv1      = sy-msgv1
*      msgv2      = sy-msgv2
*      msgv3      = sy-msgv3
*      msgv4      = sy-msgv4
*    changing
*      return_tab = return_tab.

  "else.
  "BMR - 16.06.2020
  "obter id do centro de trabalho
*  select single *
*    from crhd
*    into @data(ls_crhd_str)
*      where arbpl eq @hname
*        and werks eq @werks
*        and objty eq 'A'.
*  if sy-subrc eq 0.
*    select *
*      from crhs
*      into table @data(lt_crhs_tab)
*        where objty_up eq 'A'
*          and objid_up eq @ls_crhd_str-objid.
*
*    "eliminar CTs que não estão na tabela Z
*    loop at lt_crhs_tab into ls_crhd.
*
*      select single * from zabsf_pp013 into ls_sf013
*        where werks = werks
*        and arbpl = ls_crhd-arbpl
*        and begda le sy-datlo
*        and endda ge sy-datlo.
*      if sy-subrc ne 0.
*
*        delete lt_crhs_tab.
*      endif.
*      clear ls_crhd.
*    endloop.
*  endif.

*    call method zabsf_pp_cl_log=>add_message
*      exporting
*        msgid      = sy-msgid
*        msgty      = sy-msgty
*        msgno      = sy-msgno
*        msgv1      = sy-msgv1
*        msgv2      = sy-msgv2
*        msgv3      = sy-msgv3
*        msgv4      = sy-msgv4
*      changing
*        return_tab = return_tab.
  "endif.
endmethod.


method get_workcenter_detail.
*References
  data: lref_sf_prdord      type ref to zabsf_pp_cl_prdord,
        lref_sf_status      type ref to zabsf_pp_cl_status,
        lref_sf_maintenance type ref to zabsf_pp_cl_maintenance,
        lref_sf_parameters  type ref to zabsf_pp_cl_parameters.

  data: lv_get_qualifications type flag.

*Structures
  data: ls_zabsf_pp058  type zabsf_pp058,
        lr_workcent_rng type range of arbpl.

*Variables
  data: l_objid   type cr_objid,
        l_shiftid type zabsf_pp_e_shiftid,
        l_langu   type sy-langu.

  clear: ls_zabsf_pp058,
         l_objid,
         l_shiftid.

*>> SETUP CONF
  create object lref_sf_parameters
    exporting
      initial_refdt = refdt
      input_object  = inputobj.

  call method lref_sf_parameters->get_output_settings
    exporting
      parid           = lref_sf_parameters->c_qualifications
    importing
      parameter_value = lv_get_qualifications
    changing
      return_tab      = return_tab.

*Translate to upper case
  translate inputobj-oprid to upper case.

*Set local language for user
  l_langu = inputobj-language.

  set locale language l_langu.

*Get shift witch operator is associated
  select single shiftid
    from zabsf_pp052
    into l_shiftid
   where areaid eq inputobj-areaid
     and oprid  eq inputobj-oprid.

  if sy-subrc ne 0.
*  Operator is not associated with shift
    call method zabsf_pp_cl_log=>add_message
      exporting
        msgty      = 'E'
        msgno      = '061'
        msgv1      = inputobj-oprid
      changing
        return_tab = return_tab.

    exit.
  endif.

*Get expiration date of workcenter
  select single endda objid
    from crhd
    into (wrkctr_detail-endda, l_objid)
    where arbpl eq arbpl
      and werks eq werks.

*Get description of workcenter
  select single ktext
    from crtx
    into wrkctr_detail-ktext
   where objty eq 'A'
     and objid eq l_objid
     and spras eq sy-langu.

  if wrkctr_detail-ktext is initial.
    clear l_langu.

*  Get alternative language
    select single spras
      from zabsf_pp061
      into l_langu
     where werks      eq inputobj-werks
       and is_default ne space.

    if sy-subrc eq 0.
*    Get description of workcenter with alternative language
      select single ktext
        from crtx
        into wrkctr_detail-ktext
       where objty eq 'A'
         and objid eq l_objid
         and spras eq l_langu.
    endif.
  endif.

  wrkctr_detail-areadid = areadid.
  wrkctr_detail-werks = werks.
  wrkctr_detail-hname = hname.
  wrkctr_detail-arbpl = arbpl.

* Get work type for Work center and work center type
  select single tip_trab, arbpl_type
    from zabsf_pp013
    into (@wrkctr_detail-tip_trab, @wrkctr_detail-arbpl_type)
   where areaid eq @areadid
     and werks  eq @werks
     and arbpl  eq @arbpl
     and endda  gt @sy-datlo
     and begda  lt @sy-datlo.

  if wrkctr_detail is not initial.
*  Create object of class status
    create object lref_sf_status
      exporting
        initial_refdt = refdt
        input_object  = inputobj.

*  Create object of class prdord
    create object lref_sf_prdord
      exporting
        initial_refdt = refdt
        input_object  = inputobj.

*  Get all orders
    call method lref_sf_prdord->get_prod_orders
      exporting
        hname           = hname
        arbpl           = arbpl
        werks           = werks
        actionid        = actionid
        aufnr           = aufnr
        vornr           = vornr
      changing
        oper_wrkctr_tab = wrkctr_detail-oper_wrkctr_tab
        prdord_tab      = wrkctr_detail-prord_tab
        return_tab      = return_tab.

*>>SETUP get qualifications.
    if lv_get_qualifications eq abap_true.
      call method lref_sf_prdord->get_qualifications
        exporting
          arbpl      = arbpl
          inputobj   = inputobj
        changing
          prord_tab  = wrkctr_detail-prord_tab
          return_tab = return_tab.
    endif.
*<<

*  Get current status of Workcenter
    call method lref_sf_status->status_object
      exporting
        arbpl       = arbpl
        werks       = werks
        objty       = 'CA'
        method      = 'G'
        actionid    = actionid
      changing
        status_out  = wrkctr_detail-status
        status_desc = wrkctr_detail-status_desc
        return_tab  = return_tab.

*  Get if workcenter list scrap historic
    select single *
      from zabsf_pp058
      into corresponding fields of ls_zabsf_pp058
     where areaid eq inputobj-areaid
       and hname eq hname
       and arbpl eq arbpl.

    if sy-subrc ne 0.
      wrkctr_detail-flag_scrap_list = 'X'.
    endif.

    "obter centros de trabalho para impressão de etiqueta PP Lite
    try.
        call method zcl_bc_fixed_values=>get_ranges_value
          exporting
            im_paramter_var = zcl_bc_fixed_values=>gc_printshort_cst
            im_modulesp_var = zcl_bc_fixed_values=>gc_productn_cst
            im_werksval_var = werks
          importing
            ex_valrange_tab = lr_workcent_rng.
      catch zcx_bc_exceptions .
    endtry.
    if wrkctr_detail-arbpl in lr_workcent_rng.
      "flag de impressão de etiqueta lite
      wrkctr_detail-print_label = abap_true.
    endif.


  else.
*  No workcenter detail found
    call method zabsf_pp_cl_log=>add_message
      exporting
        msgty      = 'I'
        msgno      = '006'
      changing
        return_tab = return_tab.
  endif.
endmethod.


METHOD SET_REFDT.

*Set new reference date
  refdt = new_refdt.

  ENDMETHOD.
ENDCLASS.
