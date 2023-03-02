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
      !IT_ISTAT_FILTERS type STRING_TABLE
    changing
      !WRKCTR_DETAIL type ZABSF_PP_S_WRKCTR_DETAIL
      !RETURN_TAB type BAPIRET2_T .
  methods GET_WORKCENTERS
    importing
      !HNAME type CR_HNAME
      !WERKS type WERKS_D
      !NO_SHIFT_CHECK type BOOLE_D optional
      !OPRID type ZABSF_PP_E_OPRID optional
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


METHOD get_workcenters.
*Internal tables
  DATA: lt_crhs TYPE TABLE OF crhs,
        lt_crhd TYPE TABLE OF crhd,
        lt_crtx TYPE TABLE OF crtx.

*Structures
  DATA: ls_crhd   TYPE crhd,
        ls_crtx   TYPE crtx,
        ls_sf013  TYPE zabsf_pp013,
        ls_wrkctr TYPE zabsf_pp_s_wrkctr.
*Variables
  DATA: l_hrchy_objid TYPE cr_objid,
        l_shiftid     TYPE zabsf_pp_e_shiftid,
        l_langu       TYPE sy-langu,
        lv_objid_var  TYPE objid_up.

  CLEAR: l_langu,
         l_shiftid,
         parent,
         ktext.

*Set local language for user
  l_langu = sy-langu.

*  SET LOCALE LANGUAGE l_langu.

*Translate to upper case
  TRANSLATE inputobj-oprid TO UPPER CASE.

  IF no_shift_check EQ abap_false.
*Get shift witch operator is associated
    SELECT SINGLE shiftid
      FROM zabsf_pp052
      INTO l_shiftid
     WHERE areaid EQ inputobj-areaid
       AND oprid  EQ inputobj-oprid.

    IF sy-subrc NE 0.
*  Operator is not associated with shift
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '061'
          msgv1      = inputobj-oprid
        CHANGING
          return_tab = return_tab.
      EXIT.
    ENDIF.
  ENDIF.

  IF oprid IS SUPPLIED.
    zabsf_pp_cl_utils=>get_user_hrchy_wrkcntr_auth(
      EXPORTING iv_oprid       = oprid       " Shopfloor - Shopfloor Operator ID
      IMPORTING er_hierarchies = DATA(lr_hierarchies) " Range For Hierarchies
                er_workcenters = DATA(lr_workcenters) " Range for Workcenter
    ).
  ENDIF.

  CHECK hname IN lr_hierarchies.

*Get Hierarchy Object ID
  CALL FUNCTION 'CR_HIERARCHY_READ_NAME'
    EXPORTING
      name                = hname
      werks               = werks
    IMPORTING
      objid               = l_hrchy_objid
    EXCEPTIONS
      hierarchy_not_found = 1
      OTHERS              = 2.

  IF sy-subrc = 0.
*  Get hierarchy object relations
    CALL FUNCTION 'CR_HIERARCHY_OBJECTS'
      EXPORTING
        objid               = l_hrchy_objid
      TABLES
        t_crhs              = lt_crhs
      EXCEPTIONS
        hierarchy_not_found = 1
        OTHERS              = 2.

    IF sy-subrc = 0.
      "remover CTS que tem pais
      DELETE lt_crhs WHERE objid_up NE lv_objid_var.

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
    ENDIF.
  ELSE.
    "obter id do centro de trabalho
    SELECT SINGLE *
      FROM crhd
      INTO @DATA(ls_crhd_str)
        WHERE arbpl EQ @hname
          AND werks EQ @werks
          AND objty EQ 'A'.
    IF sy-subrc EQ 0.
      "obter filhos od CT
      SELECT *
        FROM crhs
        INTO TABLE @lt_crhs
          WHERE objty_up EQ 'A'
            AND objid_up EQ @ls_crhd_str-objid.

      "obter CT parent
      SELECT SINGLE crhd~arbpl, crhd~objid
        FROM crhs AS crhs
        INNER JOIN crhd AS crhd
         ON crhd~objid EQ crhs~objid_up
        INTO ( @parent, @DATA(lv_parent_objid_var) )
         WHERE objid_ho EQ @ls_crhd_str-objid
           AND objty_up EQ 'A'
           AND objid_up NE @lv_objid_var.
      IF sy-subrc NE 0.
        "obter hierarquia superior
        SELECT SINGLE crhh~name, crhh~objid
          FROM crhs AS crhs
          INNER JOIN crhh AS crhh
           ON crhh~objid EQ crhs~objid_hy
          INTO ( @parent, @lv_parent_objid_var )
           WHERE objid_ho EQ @ls_crhd_str-objid
             AND objty_hy EQ 'H'
             AND objid_up EQ @lv_objid_var.
      ENDIF.
    ENDIF.
  ENDIF.

  IF lt_crhs[] IS NOT INITIAL.
*    Get workcenter ID
    SELECT objty objid arbpl
      FROM crhd
      INTO CORRESPONDING FIELDS OF TABLE lt_crhd
       FOR ALL ENTRIES IN lt_crhs
     WHERE objty EQ lt_crhs-objty_ho
       AND objid EQ lt_crhs-objid_ho.
  ELSE.
*    Get workcenter ID and description
    SELECT objty objid arbpl
      FROM crhd
      INTO CORRESPONDING FIELDS OF TABLE lt_crhd
     WHERE werks EQ werks.

  ENDIF.

  DELETE lt_crhd WHERE arbpl NOT IN lr_workcenters.

  IF lt_crhd[] IS NOT INITIAL.

*   Get Workcenter description
    SELECT *
      FROM crtx
      INTO CORRESPONDING FIELDS OF TABLE lt_crtx
       FOR ALL ENTRIES IN lt_crhd
     WHERE objty EQ lt_crhd-objty
       AND objid EQ lt_crhd-objid
       AND spras EQ sy-langu.

    IF lt_crtx[] IS INITIAL.
      CLEAR l_langu.

*     Get alternative language
      SELECT SINGLE spras
        FROM zabsf_pp061
        INTO l_langu
       WHERE werks      EQ werks
         AND is_default NE space.

      IF sy-subrc EQ 0.
*       Get Workcenter description in alternative language
        SELECT *
          FROM crtx
          INTO CORRESPONDING FIELDS OF TABLE lt_crtx
           FOR ALL ENTRIES IN lt_crhd
         WHERE objty EQ lt_crhd-objty
           AND objid EQ lt_crhd-objid
           AND spras EQ sy-langu.
      ENDIF.
    ENDIF.

    LOOP AT lt_crhd INTO ls_crhd.
      CLEAR ls_wrkctr.

*        Workcenter
      ls_wrkctr-arbpl = ls_crhd-arbpl.

*        Read work center description
      READ TABLE lt_crtx INTO ls_crtx WITH KEY objty = ls_crhd-objty
                                               objid = ls_crhd-objid.

      IF sy-subrc EQ 0.
*          Work center description
        ls_wrkctr-ktext = ls_crtx-ktext.
      ENDIF.
      "verificar se é CT ou hierarquia
      SELECT SINGLE *
        FROM zabsf_pp013
        INTO ls_sf013
        WHERE werks EQ werks
          AND arbpl EQ ls_crhd-arbpl
          AND begda LE sy-datlo
          AND endda GE sy-datlo.

      IF sy-subrc EQ 0.
        ls_wrkctr-objty = 'A'.
        ls_wrkctr-prdty = ls_sf013-prdty.
      ELSE.
        ls_wrkctr-objty = 'H'.
      ENDIF.

      "obter descrição do parent
      SELECT SINGLE ktext
        FROM crtx
        INTO ktext
       WHERE objid EQ lv_parent_objid_var
         AND spras EQ sy-langu.

      APPEND ls_wrkctr TO wrkctr_tab.
    ENDLOOP.
  ENDIF.

  IF wrkctr_tab[] IS INITIAL.
*     No workcenters found
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '006'
      CHANGING
        return_tab = return_tab.
  ENDIF.


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
ENDMETHOD.


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
  l_langu = sy-langu.

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
        IT_ISTAT_FILTERS = IT_ISTAT_FILTERS
      changing
        oper_wrkctr_tab = wrkctr_detail-oper_wrkctr_tab
        prdord_tab      = wrkctr_detail-prord_tab
        return_tab      = return_tab.

    sort wrkctr_detail-prord_tab by sequence.

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
      catch zcx_pp_exceptions .
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
