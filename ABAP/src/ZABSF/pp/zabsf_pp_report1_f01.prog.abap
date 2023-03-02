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
    select_order_setup,
    select_stops,
    select_status_description.
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
  SELECT f~rueck f~arbid f~werks f~lmnga f~xmnga f~rmnga f~isdd
         f~isdz f~aufpl f~aplzl f~aufnr f~vornr f~kaptprog o~gamng e~stat
    FROM afru AS f
      INNER JOIN afko AS o
        ON o~aufnr EQ f~aufnr
      INNER JOIN aufk AS k
        ON k~aufnr EQ f~aufnr
      LEFT OUTER JOIN jest AS e
        ON e~objnr EQ k~objnr AND
           e~inact EQ abap_false AND
           e~stat  EQ gc_stat_order_complete
    INTO TABLE gt_afru
    FOR ALL ENTRIES IN gt_workcenters
    WHERE f~arbid    EQ gt_workcenters-objid
      AND f~werks    EQ gt_workcenters-werks
      AND f~stokz    EQ space
      AND f~stzhl    EQ space
      AND f~isdd     GE gv_begda
      AND f~isdd     LE gv_endda
      AND f~kaptprog NE space.
ENDFORM.                    " SELECT_CONFIRMATIONS

*&---------------------------------------------------------------------*
*&      Form  SELECT_ORDER_SETUP
*&---------------------------------------------------------------------*
FORM select_order_setup .
  CHECK gt_afru[] IS NOT INITIAL.

  DATA(lt_fae) = gt_afru.
  SORT lt_fae BY aufpl aplzl vornr werks arbid rueck.
  DELETE ADJACENT DUPLICATES FROM lt_fae COMPARING aufpl aplzl vornr werks arbid rueck.

  SELECT a~aufpl a~aplzl a~vornr a~werks a~arbid a~rueck
         p~bmsch p~vgw01 p~vge01 p~vgw02 p~vge02 p~vgw03 p~vge03
    FROM afvc AS a
      INNER JOIN plpo AS p
        ON p~plnty EQ a~plnty AND
           p~plnnr EQ a~plnnr AND
           p~plnkn EQ a~plnkn AND
           p~zaehl EQ a~zaehl AND
           p~vornr EQ a~vornr
    INTO TABLE gt_order_setup
    FOR ALL ENTRIES IN lt_fae
    WHERE a~aufpl EQ lt_fae-aufpl
      AND a~aplzl EQ lt_fae-aplzl
      AND a~vornr EQ lt_fae-vornr
      AND a~werks EQ lt_fae-werks
      AND a~arbid EQ lt_fae-arbid
      AND a~rueck EQ lt_fae-rueck.
ENDFORM.

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
        datesr = a-isdd ) ).

  " Get stop time of day for workcenter
  SELECT o~areaid o~hname o~werks o~arbpl o~datesr o~shiftid
         o~time o~endda o~timeend o~stoptime l~motivetype
    FROM zabsf_pp010 AS o
      INNER JOIN zabsf_pp011 AS l
      ON l~areaid   EQ o~areaid AND
         l~werks    EQ o~werks AND
         l~arbpl    EQ o~arbpl AND
         l~stprsnid EQ o~stprsnid AND
         l~endda    GE o~datesr AND
         l~begda    LE o~datesr
    INTO TABLE gt_stops
    FOR ALL ENTRIES IN lt_fae
    WHERE o~werks   EQ lt_fae-werks
      AND o~arbpl   EQ lt_fae-arbpl
      AND o~datesr  LE lt_fae-datesr
      AND o~endda   GE lt_fae-datesr.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  SELECT_STATUS_DESCRIPTION
*&---------------------------------------------------------------------*
FORM select_status_description .
  CHECK gt_workcenters[] IS NOT INITIAL.

  DATA(lt_fae) = gt_workcenters[].
  SORT lt_fae BY stsma stat.
  DELETE ADJACENT DUPLICATES FROM lt_fae COMPARING stsma stat.

  SELECT stsma estat spras txt30
    FROM tj30t
    INTO TABLE gt_tj30t
    FOR ALL ENTRIES IN lt_fae
    WHERE stsma EQ lt_fae-stsma
      AND estat EQ lt_fae-stat.

  LOOP AT lt_fae ASSIGNING FIELD-SYMBOL(<ls_fae>).
    CHECK line_exists( gt_tj30t[ stsma = <ls_fae>-stsma estat = <ls_fae>-stat spras = sy-langu ] ).

    DELETE gt_tj30t
      WHERE stsma EQ <ls_fae>-stsma
        AND estat EQ <ls_fae>-stat
        AND spras NE sy-langu.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  FILL_ALV_TABLE
*&---------------------------------------------------------------------*
FORM fill_alv_table .
  LOOP AT gt_afru ASSIGNING FIELD-SYMBOL(<ls_afru>).
    DATA(ls_workcenter) = VALUE #( gt_workcenters[ objid = <ls_afru>-arbid ] OPTIONAL ).

    READ TABLE gt_alv
      ASSIGNING FIELD-SYMBOL(<ls_alv>)
      WITH KEY hname   = ls_workcenter-hname
               shiftid = <ls_afru>-kaptprog
               arbpl   = ls_workcenter-arbpl
               aufnr   = <ls_afru>-aufnr.

    IF sy-subrc IS NOT INITIAL.
      APPEND INITIAL LINE TO gt_alv ASSIGNING <ls_alv>.
      DATA(ls_order_setup) =
        VALUE #( gt_order_setup[
          aufpl = <ls_afru>-aufpl
          aplzl = <ls_afru>-aplzl
          vornr = <ls_afru>-vornr
          werks = <ls_afru>-werks
          arbid = <ls_afru>-arbid
          rueck = <ls_afru>-rueck ] OPTIONAL ).

      <ls_alv>-hname     = ls_workcenter-hname.
      <ls_alv>-shiftid   = <ls_afru>-kaptprog.
      <ls_alv>-arbpl     = ls_workcenter-arbpl.
      <ls_alv>-stat      = VALUE #( gt_tj30t[ stsma = ls_workcenter-stsma estat = ls_workcenter-stat ]-txt30 OPTIONAL ).
      <ls_alv>-gamng     = <ls_afru>-gamng.
      <ls_alv>-aufnr     = <ls_afru>-aufnr.
      <ls_alv>-vgw01     = ls_order_setup-vgw01.
      <ls_alv>-vge01     = ls_order_setup-vge01.
      <ls_alv>-vgw02     = ls_order_setup-vgw02.
      <ls_alv>-vge02     = ls_order_setup-vge02.
      <ls_alv>-vgw03     = ls_order_setup-vgw03.
      <ls_alv>-vge03     = ls_order_setup-vge03.
      <ls_alv>-completed = COND #( WHEN <ls_afru>-stat IS INITIAL THEN abap_false ELSE abap_true ).
    ENDIF.

    ADD <ls_afru>-lmnga TO <ls_alv>-lmnga.

    IF <ls_afru>-xmnga NE 0.
      DATA(lv_setup) = abap_false.
      LOOP AT gt_stops TRANSPORTING NO FIELDS
        WHERE werks EQ <ls_afru>-werks
          AND arbpl EQ <ls_alv>-arbpl
          AND ( ( datesr  LT <ls_afru>-isdd AND   " On same day of the stop start
                  endda   GT <ls_afru>-isdd )
             OR ( datesr  EQ <ls_afru>-isdd AND   " Between start and end
                  time    GE <ls_afru>-isdz )
             OR ( endda   EQ <ls_afru>-isdd AND   " On same day of the stop end
                  timeend GE <ls_afru>-isdz ) )
          AND motivetype  EQ zabsf_pp_cl_dashboard=>gc_mtype_planned.
        lv_setup = abap_true.
        EXIT.
      ENDLOOP.

      IF lv_setup EQ abap_true.
        ADD <ls_afru>-xmnga TO <ls_alv>-zmnga.
      ELSE.
        ADD <ls_afru>-xmnga TO <ls_alv>-xmnga.
      ENDIF.
    ENDIF.
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

      " Set Completed as a checkbox
      DATA(lo_column) = CAST cl_salv_column_table( lo_columns->get_column( 'COMPLETED' ) ).
      lo_column->set_cell_type( if_salv_c_cell_type=>checkbox ).

      " Zebra
      lo_salv->get_display_settings( )->set_striped_pattern( cl_salv_display_settings=>true ).

      " Sum
      add_aggregation: 'GAMNG', 'VGW01','VGW02','VGW03','ZMNGA','LMNGA','XMNGA'.

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
