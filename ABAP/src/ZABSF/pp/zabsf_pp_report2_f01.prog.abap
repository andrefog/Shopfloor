*&---------------------------------------------------------------------*
*&  Include           ZABSF_PP_REPORT1_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  ADJUST_RANGE_DATE
*&---------------------------------------------------------------------*
FORM adjust_range_date .
  DATA(lr_date) = s_date[].

  IF lr_date[] IS NOT INITIAL.
    zabsf_pp_cl_utils=>adjust_range_date( CHANGING cr_date = lr_date ).
    gv_begda = lr_date[ 1 ]-low.
    gv_endda = lr_date[ 1 ]-high.
  ELSE.
    "For performance purpouse, the selection will be
    "done for today only. If need to select more dates
    "set the period.
    MESSAGE i398(00) WITH TEXT-i01 TEXT-i02 TEXT-i03 ''.

    gv_begda = sy-datum.
    gv_endda = sy-datum.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  SELECT_DATA
*&---------------------------------------------------------------------*
FORM select_data .
  PERFORM:
    select_workcenters,
    select_confirmations,
    select_stops,
    select_rework,
    select_scraps,
    select_defects.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  SELECT_WORKCENTERS
*&---------------------------------------------------------------------*
FORM select_workcenters.
  SELECT werks, hname
    FROM zabsf_pp002
    INTO TABLE @DATA(lt_hierarchies)
    WHERE werks  IN @s_werks
      AND hname  IN @s_hname
      AND begda  LE @gv_endda
      AND endda  GE @gv_begda.

  SELECT objty, objid, name, werks
    FROM crhh
    INTO TABLE @DATA(lt_crhh)
    FOR ALL ENTRIES IN @lt_hierarchies
    WHERE name  EQ @lt_hierarchies-hname
      AND werks EQ @lt_hierarchies-werks.
  CHECK lt_crhh[] IS NOT INITIAL.

  SELECT objty_hy, objid_hy, objty_ho, objid_ho
    FROM crhs
    INTO TABLE @DATA(lt_crhs)
    FOR ALL ENTRIES IN @lt_crhh
    WHERE objty_hy EQ @lt_crhh-objty
      AND objid_hy EQ @lt_crhh-objid.
  CHECK lt_crhs[] IS NOT INITIAL.

  " Get workcenter ID and description
  SELECT objty, objid, arbpl, werks, kapid, stobj
    FROM crhd
    INTO TABLE @DATA(lt_crhd)
    FOR ALL ENTRIES IN @lt_crhs
    WHERE objty EQ @lt_crhs-objty_ho
      AND objid EQ @lt_crhs-objid_ho
      AND arbpl IN @s_arbpl.
  CHECK lt_crhd[] IS NOT INITIAL.

  " Get capacity is relevant
  SELECT kapid, kapter
    FROM kako
    INTO TABLE @DATA(lt_kako)
    FOR ALL ENTRIES IN @lt_crhd
    WHERE kapid EQ @lt_crhd-kapid.

  " Get Status
  SELECT o~objnr, o~stsma, e~stat
    FROM jsto AS o
    INNER JOIN jest AS e
      ON e~objnr EQ o~objnr
    INTO TABLE @DATA(lt_jsto)
    FOR ALL ENTRIES IN @lt_crhd
    WHERE o~objnr EQ @lt_crhd-stobj
      AND e~inact EQ @abap_false.

  LOOP AT lt_crhd ASSIGNING FIELD-SYMBOL(<ls_crhd>).
    CHECK line_exists( lt_kako[ kapid = <ls_crhd>-kapid kapter = abap_true ] ).

    DATA(ls_crhs) = VALUE #( lt_crhs[ objty_ho = <ls_crhd>-objty objid_ho = <ls_crhd>-objid ] OPTIONAL ).
    DATA(ls_crhh) = VALUE #( lt_crhh[ objty = ls_crhs-objty_hy objid = ls_crhs-objid_hy ] OPTIONAL ).
    DATA(ls_jsto) = VALUE #( lt_jsto[ objnr = <ls_crhd>-stobj ] OPTIONAL ).

    APPEND
      VALUE #(
        werks  = ls_crhh-werks
        hname  = ls_crhh-name
        arbpl  = <ls_crhd>-arbpl
        objid  = <ls_crhd>-objid
        kapid  = <ls_crhd>-kapid
        stsma  = ls_jsto-stsma
        stat   = ls_jsto-stat
      ) TO gt_workcenters.
  ENDLOOP.
ENDFORM.                    " GET_WORKCENTERS_TABLE

*&---------------------------------------------------------------------*
*&      Form  SELECT_CONFIRMATIONS
*&---------------------------------------------------------------------*
FORM select_confirmations .
  CHECK gt_workcenters[] IS NOT INITIAL.

  " Get confirmations
  SELECT u~rueck u~arbid u~werks u~lmnga u~xmnga u~rmnga u~isdd
         u~isdz u~aufnr u~vornr u~kaptprog k~auart o~matnr c~steus
    FROM afru AS u
    INNER JOIN aufk AS k
      ON k~aufnr EQ u~aufnr
    INNER JOIN afpo AS o
      ON o~aufnr EQ u~aufnr
    INNER JOIN afvc AS c
      ON c~aufpl EQ u~aufpl AND
         c~aplzl EQ u~aplzl
    INTO TABLE gt_afru
    FOR ALL ENTRIES IN gt_workcenters
    WHERE u~arbid    EQ gt_workcenters-objid
      AND u~werks    EQ gt_workcenters-werks
      AND u~stokz    EQ space
      AND u~stzhl    EQ space
      AND u~isdd     GE gv_begda
      AND u~isdd     LE gv_endda
      AND u~kaptprog NE space.
ENDFORM.                    " SELECT_CONFIRMATIONS

*&---------------------------------------------------------------------*
*&      Form  SELECT_STOPS
*&---------------------------------------------------------------------*
FORM select_stops .
  CHECK gt_afru[] IS NOT INITIAL.

  DATA(lt_fae) =
    VALUE tt_stops(
      FOR a IN gt_afru
      ( werks  = a-werks
        arbpl  = gt_workcenters[ objid = a-arbid ]-arbpl
        begda = a-isdd ) ).

  " Get stop time of day for workcenter
  SELECT areaid hname werks arbpl datesr shiftid
         time endda timeend stoptime
    FROM zabsf_pp010
    INTO TABLE gt_stops
    FOR ALL ENTRIES IN lt_fae
    WHERE werks   EQ lt_fae-werks
      AND arbpl   EQ lt_fae-arbpl
      AND datesr  LE lt_fae-begda
      AND endda   GE lt_fae-begda.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  SELECT_REWORK
*&---------------------------------------------------------------------*
FORM select_rework .
  CHECK gt_afru[] IS NOT INITIAL.

  DATA(lt_fae) =
    VALUE tt_rework(
      FOR a IN gt_afru
      WHERE ( rmnga NE 0 )
      ( aufnr = a-aufnr
        data  = a-isdd
        timer = a-isdz ) ).

  " Get stop time of day for workcenter
  SELECT aufnr defectid rework data timer
    FROM zabsf_pp004
    INTO TABLE gt_reworks
    FOR ALL ENTRIES IN lt_fae
    WHERE aufnr EQ lt_fae-aufnr
      AND data  EQ lt_fae-data
      AND timer EQ lt_fae-timer.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  SELECT_SCRAPS
*&---------------------------------------------------------------------*
FORM select_scraps .
  CHECK gt_afru[] IS NOT INITIAL.

  DATA(lt_fae) =
    VALUE tt_scraps(
      FOR a IN gt_afru
      WHERE ( xmnga NE 0 )
      ( matnr = a-matnr
        data  = a-isdd
        time = a-isdz ) ).

  " Get stop time of day for workcenter
  SELECT matnr data time grund
    FROM zabsf_pp034
    INTO TABLE gt_scraps
    FOR ALL ENTRIES IN lt_fae
    WHERE matnr EQ lt_fae-matnr
      AND data  EQ lt_fae-data
      AND time  EQ lt_fae-time.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  SELECT_DEFECTS
*&---------------------------------------------------------------------*
FORM select_defects .
  CHECK gt_reworks[] IS NOT INITIAL
    OR  gt_scraps[] IS NOT INITIAL.

  DATA(lt_fae) = VALUE tt_trugt( FOR r IN gt_reworks ( grund = r-defectid ) ).
  APPEND LINES OF VALUE tt_trugt( FOR s IN gt_scraps ( grund = s-grund ) ) TO lt_fae.
  SORT lt_fae BY grund.
  DELETE ADJACENT DUPLICATES FROM lt_fae.

  SELECT werks grund grdtx
    FROM trugt
    INTO TABLE gt_trugt
    FOR ALL ENTRIES IN lt_fae
    WHERE spras EQ sy-langu
      AND grund EQ lt_fae-grund.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  FILL_ALV_TABLE
*&---------------------------------------------------------------------*
FORM fill_alv_table .
  LOOP AT gt_afru ASSIGNING FIELD-SYMBOL(<ls_afru>).
    DATA(ls_workcenter) = VALUE #( gt_workcenters[ objid = <ls_afru>-arbid ] OPTIONAL ).

    LOOP AT gt_stops INTO DATA(ls_stop)
      WHERE werks  EQ ls_workcenter-werks
        AND arbpl  EQ ls_workcenter-arbpl
        AND ( ( begda LT <ls_afru>-isdd AND endda GT <ls_afru>-isdd )
          OR  ( begda EQ <ls_afru>-isdd AND begtm LE <ls_afru>-isdz )
          OR  ( endda EQ <ls_afru>-isdd AND endtm GE <ls_afru>-isdz ) ).
      EXIT.
    ENDLOOP.

    DATA(ls_rework) =
      VALUE #( gt_reworks[ aufnr = <ls_afru>-aufnr
                           data  = <ls_afru>-isdd
                           timer = <ls_afru>-isdz ] OPTIONAL ).

    DATA(ls_scrap) =
      VALUE #( gt_scraps[ matnr = <ls_afru>-matnr
                          data  = <ls_afru>-isdd
                          time  = <ls_afru>-isdz ] OPTIONAL ).

    APPEND INITIAL LINE TO gt_alv ASSIGNING FIELD-SYMBOL(<ls_alv>).
    <ls_alv>-hname         = ls_workcenter-hname.
    <ls_alv>-shiftid       = <ls_afru>-kaptprog.
    <ls_alv>-arbpl         = ls_workcenter-arbpl.
    <ls_alv>-aufnr         = <ls_afru>-aufnr.
    <ls_alv>-auart         = <ls_afru>-auart.
    <ls_alv>-steus         = <ls_afru>-steus.
    <ls_alv>-begda         = ls_stop-begda.
    <ls_alv>-begtm         = ls_stop-begtm.
    <ls_alv>-endda         = ls_stop-endda.
    <ls_alv>-endtm         = ls_stop-endtm.
*    <ls_alv>-nome_colabora = ls_order_setup-vgw03.
    <ls_alv>-lmnga         = <ls_afru>-lmnga.
    <ls_alv>-xmnga         = <ls_afru>-xmnga.
    <ls_alv>-grdtx         = VALUE #( gt_trugt[ werks = ls_workcenter-werks grund = ls_scrap-grund ] OPTIONAL ).
    <ls_alv>-rmnga         = <ls_afru>-rmnga.
    <ls_alv>-defectid      = VALUE #( gt_trugt[ werks = ls_workcenter-werks grund = ls_rework-defectid ] OPTIONAL ).
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ALV
*&---------------------------------------------------------------------*
FORM display_alv .
  DEFINE add_aggregation.
    lo_salv->get_aggregations( )->add_aggregation(
      columnname  = &1
      aggregation = if_salv_c_aggregation=>total ).
  end-of-definition.

  DEFINE add_sort.
    lo_salv->get_sorts( )->add_sort(
      columnname = &1
      subtotal   = if_salv_c_bool_sap=>true ).
  end-of-definition.

  TRY.
      cl_salv_table=>factory(
        IMPORTING r_salv_table = DATA(lo_salv)
        CHANGING  t_table      = gt_alv ).

      DATA(lo_columns) = lo_salv->get_columns( ).

      " Set all toolbar button active
      lo_salv->get_functions( )->set_all( ).

      " Optimize Cell Width
      lo_columns->set_optimize( ).

      " Zebra
      lo_salv->get_display_settings( )->set_striped_pattern( cl_salv_display_settings=>true ).

      " Zebra
      lo_salv->get_display_settings( )->set_striped_pattern( cl_salv_display_settings=>true ).

      " Sum
      add_aggregation: 'LMNGA','XMNGA','RMNGA'.

      " Sub-totals
      add_sort: 'HNAME','SHIFTID','ARBPL'.

      " Display ALV
      lo_salv->display( ).
    CATCH cx_salv_msg INTO DATA(lo_exception).
      DATA(ls_msg) = lo_exception->get_message( ).
      MESSAGE ID ls_msg-msgid TYPE ls_msg-msgty NUMBER ls_msg-msgno
        WITH ls_msg-msgv1 ls_msg-msgv2 ls_msg-msgv3 ls_msg-msgv4.
  ENDTRY.
ENDFORM.
