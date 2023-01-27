*----------------------------------------------------------------------*
***INCLUDE Z_LP_PP_SF_REPORT_QUANT_F01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  INIT_VARIABLES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM init_variables .
  REFRESH: it_area,
           it_hname,
           it_arbpl,
           it_shift,
           it_qtd_desc,
           gt_qtd,
           gt_qtd_alv,
           gt_afru,
           gt_total,
           gt_error.

  CLEAR: gs_qtd,
         gs_qtd_alv.
ENDFORM.                    " INIT_VARIABLES
*&---------------------------------------------------------------------*
*&      Form  CREATE_DESC_QUANTITY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM create_desc_quantity .
  DATA: ls_qtd_desc TYPE ty_qtd_desc,
        count       TYPE i.

  CLEAR count.

  DO 6 TIMES.
    CLEAR ls_qtd_desc.

    ADD 1 TO count.
    ls_qtd_desc-seqid = count.

    CASE count.
      WHEN 1.
*      Quantity expected
        ls_qtd_desc-qtd_desc = TEXT-010.
      WHEN 2.
*      Quantity produced
        ls_qtd_desc-qtd_desc = TEXT-011.
      WHEN 3.
*      Good Quantity
        ls_qtd_desc-qtd_desc = TEXT-012.
      WHEN 4.
*      Quantity scrap
        ls_qtd_desc-qtd_desc = TEXT-013.
      WHEN 5.
*      Quantity rework
        ls_qtd_desc-qtd_desc = TEXT-014.
      WHEN 6.
*      Percentage of produced quntities completed
        ls_qtd_desc-qtd_desc = TEXT-015.
    ENDCASE.

    APPEND ls_qtd_desc TO it_qtd_desc.
  ENDDO.
ENDFORM.                    " CREATE_DESC_QUANTITY
*&---------------------------------------------------------------------*
*&      Form  CREATE_F4_FIELD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_C  text
*      -->P_C  text
*      <--P_IT_AREA  text
*      <--P_IT_RETURN  text
*----------------------------------------------------------------------*
FORM create_f4_field  USING p_retfield p_val_org p_dyn_field so_option p_it TYPE STANDARD TABLE.


  DATA: it_return TYPE TABLE OF ddshretval,
        wa_return TYPE ddshretval.

  REFRESH it_return.
  CLEAR wa_return.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = p_retfield
      value_org       = p_val_org
      dynpprog        = sy-cprog
      dynpnr          = sy-dynnr
      dynprofield     = p_dyn_field
    TABLES
      value_tab       = p_it
      return_tab      = it_return
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

*  IF sy-subrc <> 0.
**    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
**          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*
*    CALL METHOD zcl_lp_pp_sf_log=>add_message
*      EXPORTING
*        msgid      = sy-msgid
*        msgty      = sy-msgty
*        msgno      = sy-msgno
*        msgv1      = sy-msgv1
*        msgv2      = sy-msgv2
*        msgv3      = sy-msgv3
*        msgv4      = sy-msgv4
*      CHANGING
*        return_tab = gt_error.
*  ENDIF.
*
*  IF it_return IS NOT INITIAL.
*    LOOP AT it_return INTO wa_return.
*      so_option = wa_return-fieldval.
*    ENDLOOP.
*  ENDIF.

ENDFORM.                    " CREATE_F4_FIELD
*&---------------------------------------------------------------------*
*&      Form  GET_WORKCENTERS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_workcenters TABLES p_hname STRUCTURE so_hname
                      USING p_area p_werks
                   CHANGING p_it TYPE STANDARD TABLE.

  DATA: lt_crhs        TYPE TABLE OF crhs,
        it_aux         TYPE TABLE OF ty_arbpl,
        lt_zabsf_pp002 TYPE TABLE OF zabsf_pp002,
        ls_zabsf_pp002 TYPE zabsf_pp002,
        wa_hname       TYPE cr_hname,
        l_hrchy_objid  TYPE cr_objid.

  IF p_hname[] IS NOT INITIAL.
    LOOP AT p_hname INTO wa_hname.
*    Get workcenter for Hierarchy
      PERFORM get_workcenters_table USING wa_hname p_werks CHANGING it_aux.

      IF it_aux[] IS NOT INITIAL.
        APPEND LINES OF it_aux TO p_it.
      ENDIF.
    ENDLOOP.
  ELSE.
*  Get all hierarchies for area
    SELECT hname
      FROM zabsf_pp002
      INTO CORRESPONDING FIELDS OF TABLE lt_zabsf_pp002
     WHERE areaid EQ p_area
       AND werks  EQ p_werks.

    SORT lt_zabsf_pp002 BY hname.

    DELETE ADJACENT DUPLICATES FROM lt_zabsf_pp002.

    LOOP AT lt_zabsf_pp002 INTO ls_zabsf_pp002.
*    Get workcenter for Hierarchy
      PERFORM get_workcenters_table USING ls_zabsf_pp002-hname p_werks CHANGING it_aux.

      IF it_aux[] IS NOT INITIAL.
        APPEND LINES OF it_aux TO p_it.
      ENDIF.
    ENDLOOP.

**  Get workcenter ID and description
*    SELECT crhd~arbpl crtx~ktext
*      INTO CORRESPONDING FIELDS OF TABLE p_it
*      FROM crhd INNER JOIN crtx
*        ON crtx~objty EQ crhd~objty
*       AND crtx~objid EQ crhd~objid
*     WHERE crhd~werks EQ p_werks
*       AND crhd~objty EQ 'A'
*       AND crtx~spras EQ sy-langu.
  ENDIF.
ENDFORM.                    " GET_WORKCENTERS
*&---------------------------------------------------------------------*
*&      Form  GET_WORKCENTERS_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_WA_HNAME  text
*      <--P_IT_AUX  text
*----------------------------------------------------------------------*
FORM get_workcenters_table  USING    p_wa_hname p_werks
                            CHANGING p_it_aux TYPE STANDARD TABLE.

  DATA: lt_crhs       TYPE TABLE OF crhs,
        l_hrchy_objid TYPE cr_objid.

  REFRESH lt_crhs.

  CLEAR l_hrchy_objid.

*Get Hierarchy Object ID
  CALL FUNCTION 'CR_HIERARCHY_READ_NAME'
    EXPORTING
      name                = p_wa_hname
      werks               = p_werks
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
*    Get workcenter ID and description
      SELECT crhd~arbpl crtx~ktext
        INTO CORRESPONDING FIELDS OF TABLE p_it_aux
        FROM crhd INNER JOIN crtx
          ON crtx~objty EQ crhd~objty
         AND crtx~objid EQ crhd~objid
         FOR ALL ENTRIES IN lt_crhs
       WHERE crhd~objty EQ lt_crhs-objty_ho
         AND crhd~objid EQ lt_crhs-objid_ho
         AND crtx~spras EQ sy-langu.
    ENDIF.
  ENDIF.
ENDFORM.                    " GET_WORKCENTERS_TABLE
*&---------------------------------------------------------------------*
*&      Form  CHECK_SO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM check_so USING p_areaid p_werks p_data.
  DATA: lt_zabsf_pp001 TYPE TABLE OF zabsf_pp001,
        lt_zabsf_pp002 TYPE TABLE OF zabsf_pp002,
        lt_zabsf_pp050 TYPE TABLE OF zabsf_pp050,
        lt_arbpl       TYPE TABLE OF ty_arbpl.

  DATA: wa_zabsf_pp001 TYPE zabsf_pp001,
        wa_zabsf_pp002 TYPE zabsf_pp002,
        wa_zabsf_pp050 TYPE zabsf_pp050,
        wa_arbpl       TYPE ty_arbpl,
        ls_hname       LIKE LINE OF so_hname,
        ls_arbpl       LIKE LINE OF so_arbpl,
        ls_shift       LIKE LINE OF so_shift.

  REFRESH: lt_zabsf_pp001,
           lt_zabsf_pp002,
           lt_zabsf_pp050,
           lt_arbpl.

  CLEAR: wa_zabsf_pp001,
         wa_zabsf_pp002,
         wa_zabsf_pp050,
         wa_arbpl,
         ls_hname,
         ls_arbpl,
         ls_shift.

*Send error message
  IF so_hname[] IS INITIAL AND so_arbpl[] IS NOT INITIAL.
*  Fill missing parameter
*    MESSAGE i053(zabsf_pp).
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'I'
        msgno      = '053'
      CHANGING
        return_tab = gt_error.
    EXIT.
  ENDIF.

*Check if parameter Hierarchy is not initial
  IF so_hname[] IS INITIAL.
*  Get all hierarchies for area
    SELECT *
      FROM zabsf_pp002
      INTO CORRESPONDING FIELDS OF TABLE lt_zabsf_pp002
     WHERE areaid EQ p_areaid
       AND werks EQ p_werks
       AND begda  LE p_data
       AND endda  GE p_data.

    LOOP AT lt_zabsf_pp002 INTO wa_zabsf_pp002.
      ls_hname-sign = 'I'.
      ls_hname-option = 'EQ'.
      ls_hname-low = wa_zabsf_pp002-hname.

      APPEND ls_hname TO so_hname.
    ENDLOOP.

    SORT so_hname.

    DELETE ADJACENT DUPLICATES FROM so_hname.
  ENDIF.

*Check if parameter Workcenter is not initial
  IF so_arbpl[] IS INITIAL.
    LOOP AT so_hname INTO ls_hname.
*    Get workcenter for hierarchy
      PERFORM get_workcenters_table USING ls_hname-low p_werks
                                    CHANGING lt_arbpl.

      LOOP AT lt_arbpl INTO wa_arbpl.
        ls_arbpl-sign = 'I'.
        ls_arbpl-option = 'EQ'.
        ls_arbpl-low = wa_arbpl-arbpl.

        APPEND ls_arbpl TO so_arbpl.
      ENDLOOP.
    ENDLOOP.

    SORT so_arbpl.

    DELETE ADJACENT DUPLICATES FROM so_arbpl.
  ENDIF.

*Check if parameter Shift is not initial
  IF so_shift[] IS INITIAL.
*  Get shifts for area
    SELECT *
      FROM zabsf_pp001
      INTO CORRESPONDING FIELDS OF TABLE lt_zabsf_pp001
     WHERE areaid EQ p_areaid
       AND werks EQ p_werks
       AND begda  LE p_data
       AND endda  GE p_data.

    LOOP AT lt_zabsf_pp001 INTO wa_zabsf_pp001.
      ls_shift-sign = 'I'.
      ls_shift-option = 'EQ'.
      ls_shift-low = wa_zabsf_pp001-shiftid.

      APPEND ls_shift TO so_shift.
    ENDLOOP.

    SORT so_shift.

    DELETE ADJACENT DUPLICATES FROM so_shift.
  ENDIF.
ENDFORM.                    " CHECK_SO
*&---------------------------------------------------------------------*
*&      Form  SAVE_DB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM save_db .
  DATA: lt_zabsf_pp056 TYPE TABLE OF zabsf_pp056.

  DATA: ls_zabsf_pp056 TYPE zabsf_pp056,
        flag_error     TYPE c.

  REFRESH lt_zabsf_pp056.

*Get all data saved in database
  SELECT *
    FROM zabsf_pp056
    INTO CORRESPONDING FIELDS OF TABLE lt_zabsf_pp056
    WHERE areaid  EQ pa_area
      AND hname   IN so_hname
      AND werks   EQ pa_werks
      AND arbpl   IN so_arbpl
      AND shiftid IN so_shift
      AND data    EQ pa_date.

  CLEAR: gs_qtd,
         flag_error.

  LOOP AT gt_qtd INTO gs_qtd.
    CLEAR ls_zabsf_pp056.
*  Check if exist data saved in database
    READ TABLE lt_zabsf_pp056 INTO ls_zabsf_pp056 WITH KEY areaid  = gs_qtd-areaid
                                                             hname   = gs_qtd-hname
                                                             werks   = gs_qtd-werks
                                                             arbpl   = gs_qtd-arbpl
                                                             shiftid = gs_qtd-shiftid
                                                             data    = gs_qtd-data.

    IF sy-subrc EQ 0.
*    Update value OEE with new value
      ls_zabsf_pp056-gamng = gs_qtd-gamng.
      ls_zabsf_pp056-lmnga = gs_qtd-lmnga.
      ls_zabsf_pp056-xmnga = gs_qtd-xmnga.
      ls_zabsf_pp056-rmnga = gs_qtd-rmnga.
      ls_zabsf_pp056-qtdprod = gs_qtd-qtdprod.
      ls_zabsf_pp056-pctprod = gs_qtd-pctprod.

      UPDATE zabsf_pp056 FROM ls_zabsf_pp056.

      IF sy-subrc NE 0.
        flag_error = 'X'.
*      Data not saved successfully in database
        MESSAGE e058(zabsf_pp).
        EXIT.
      ENDIF.
    ELSE.
*    Insert new line in database
      INSERT INTO zabsf_pp056 VALUES gs_qtd.

      IF sy-subrc NE 0.
        flag_error = 'X'.
*      Data not saved successfully in database
        MESSAGE e058(zabsf_pp).
        EXIT.
      ENDIF.
    ENDIF.
  ENDLOOP.

  IF flag_error IS INITIAL.
*  Data saved successfully in database
    MESSAGE s057(zabsf_pp).
  ENDIF.
ENDFORM.                    " SAVE_DB
*&---------------------------------------------------------------------*
*&      Form  SHOW_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM show_data.
*Get data to alv
  PERFORM fill_data_alv.

  IF gt_qtd_alv[] IS NOT INITIAL.
*  Show data
    CALL SCREEN 100.
  ENDIF.
ENDFORM.                    " SHOW_DATA
*&---------------------------------------------------------------------*
*&      Form  FILL_DATA_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fill_data_alv.
*Types for Hierarchy
  TYPES: BEGIN OF ty_hname_desc,
           objid TYPE cr_objid,
           name  TYPE cr_hname,
           ktext TYPE cr_ktext,
         END OF ty_hname_desc.

*Types for Workcenter
  TYPES: BEGIN OF ty_arbpl_desc,
           objid TYPE cr_objid,
           arbpl TYPE arbpl,
           ktext TYPE cr_ktext,
         END OF ty_arbpl_desc.

  DATA: lt_qtd_alv    TYPE TABLE OF zabsf_pp_s_data_alv,
        lt_area_desc  TYPE TABLE OF zabsf_pp000_t,
        lt_hname_desc TYPE TABLE OF ty_hname_desc,
        lt_werks_desc TYPE TABLE OF t001w,
        lt_arbpl_desc TYPE TABLE OF ty_arbpl_desc,
        lt_shift_desc TYPE TABLE OF zabsf_pp001_t.

  DATA: ls_qtd_alv    TYPE zabsf_pp_s_data_alv,
        ls_area_desc  TYPE zabsf_pp000_t,
        ls_hname_desc TYPE ty_hname_desc,
        ls_werks_desc TYPE t001w,
        ls_arbpl_desc TYPE ty_arbpl_desc,
        ls_shift_desc TYPE zabsf_pp001_t,
        ls_total      TYPE ty_total,
        ls_qtd_desc   TYPE ty_qtd_desc,
        ld_day        TYPE scal-indicator,
        ld_value      TYPE mengv13.

  REFRESH: lt_area_desc,
           lt_hname_desc,
           lt_werks_desc,
           lt_arbpl_desc,
           lt_shift_desc,
           gt_total.

  CLEAR: ls_qtd_alv,
         gs_qtd.

*Get data to get description
  LOOP AT gt_qtd INTO gs_qtd.
    CLEAR ls_qtd_alv.
    MOVE-CORRESPONDING gs_qtd TO ls_qtd_alv.

    APPEND ls_qtd_alv TO lt_qtd_alv.
  ENDLOOP.

  DELETE ADJACENT DUPLICATES FROM lt_qtd_alv.

*Get description for Area
  SELECT *
    FROM zabsf_pp000_t
    INTO CORRESPONDING FIELDS OF TABLE lt_area_desc
     FOR ALL ENTRIES IN lt_qtd_alv
   WHERE areaid EQ lt_qtd_alv-areaid
     AND spras EQ sy-langu.

*Get description for Hierarchy
  SELECT crhh~objid crhh~name crtx~ktext
    INTO CORRESPONDING FIELDS OF TABLE lt_hname_desc
    FROM crtx AS crtx
   INNER JOIN crhh AS crhh
      ON crhh~objty EQ crtx~objty
     AND crhh~objid EQ crtx~objid
     FOR ALL ENTRIES IN lt_qtd_alv
   WHERE crhh~name  EQ lt_qtd_alv-hname
     AND crhh~objty EQ 'H'
     AND crhh~werks EQ lt_qtd_alv-werks
     AND crtx~spras EQ sy-langu.

*Get description for Plant
  SELECT *
    FROM t001w
    INTO CORRESPONDING FIELDS OF TABLE lt_werks_desc
     FOR ALL ENTRIES IN lt_qtd_alv
   WHERE werks EQ lt_qtd_alv-werks
     AND spras EQ sy-langu.

*Get description for Workcenter
  SELECT crhd~objid crhd~arbpl crtx~ktext
    INTO CORRESPONDING FIELDS OF TABLE lt_arbpl_desc
    FROM crtx AS crtx
   INNER JOIN crhd AS crhd
      ON crhd~objty EQ crtx~objty
     AND crhd~objid EQ crtx~objid
     FOR ALL ENTRIES IN lt_qtd_alv
   WHERE crhd~arbpl EQ lt_qtd_alv-arbpl
     AND crhd~objty EQ 'A'
     AND crhd~werks EQ lt_qtd_alv-werks
     AND crtx~spras EQ sy-langu.

*Get description for Shift
  SELECT *
    FROM zabsf_pp001_t
    INTO CORRESPONDING FIELDS OF TABLE lt_shift_desc
     FOR ALL ENTRIES IN lt_qtd_alv
   WHERE areaid  EQ lt_qtd_alv-areaid
     AND werks   EQ lt_qtd_alv-werks
     AND shiftid EQ lt_qtd_alv-shiftid
     AND spras   EQ sy-langu.

*Get total week for Quantity
  LOOP AT gt_qtd INTO gs_qtd.
*  Total quantity
    READ TABLE gt_total INTO ls_total WITH KEY areaid  = gs_qtd-areaid
                                               hname   = gs_qtd-hname
                                               werks   = gs_qtd-werks
                                               arbpl   = gs_qtd-arbpl
                                               shiftid = gs_qtd-shiftid
                                               week    = gs_qtd-week.

    IF sy-subrc EQ 0.
*    Add value quantity to total
      ADD gs_qtd-gamng TO ls_total-tot_gamng.
      ADD gs_qtd-lmnga TO ls_total-tot_lmnga.
      ADD gs_qtd-xmnga TO ls_total-tot_xmnga.
      ADD gs_qtd-rmnga TO ls_total-tot_rmnga.
      ADD gs_qtd-qtdprod TO ls_total-tot_qtdprod.
      ADD gs_qtd-pctprod TO ls_total-tot_pctprod.

      MODIFY TABLE gt_total FROM ls_total.
    ELSE.
*    Insert new line in internal table total
      MOVE-CORRESPONDING gs_qtd TO ls_total.

      ls_total-tot_gamng = gs_qtd-gamng.
      ls_total-tot_lmnga = gs_qtd-lmnga.
      ls_total-tot_xmnga = gs_qtd-xmnga.
      ls_total-tot_rmnga = gs_qtd-rmnga.
      ls_total-tot_qtdprod = gs_qtd-qtdprod.
      ls_total-tot_pctprod = gs_qtd-pctprod.

      INSERT ls_total INTO TABLE gt_total.
    ENDIF.
  ENDLOOP.

*Fill glbal internal table to show data in alv
  CLEAR gs_qtd.

  LOOP AT gt_qtd INTO gs_qtd.
    CLEAR: gs_qtd_alv,
           ls_area_desc,
           ls_hname_desc,
           ls_werks_desc,
           ls_arbpl_desc,
           ls_shift_desc,
           ld_day.

*>>>PAP - Correcção - 20.05.2015
    READ TABLE gt_qtd_alv INTO gs_qtd_alv WITH KEY areaid  = gs_qtd-areaid
                                                   hname   = gs_qtd-hname
                                                   werks   = gs_qtd-werks
                                                   arbpl   = gs_qtd-arbpl
                                                   shiftid = gs_qtd-shiftid
                                                   week    = gs_qtd-week.

    IF sy-subrc EQ 0.
*    Get number day in week
      CALL FUNCTION 'DATE_COMPUTE_DAY'
        EXPORTING
          date = gs_qtd-data
        IMPORTING
          day  = ld_day.

*    Type quantities calculated
      LOOP AT it_qtd_desc INTO ls_qtd_desc.
        CLEAR: gs_qtd_alv-qtd_desc,
               gs_qtd_alv-vdata1,
               gs_qtd_alv-vdata2,
               gs_qtd_alv-vdata3,
               gs_qtd_alv-vdata4,
               gs_qtd_alv-vdata5,
               gs_qtd_alv-vdata6,
               gs_qtd_alv-vdata7,
               gs_qtd_alv-tshift,
               gs_qtd_alv-tweek,
               ld_value.

        CASE ls_qtd_desc-seqid.
          WHEN 1.
            gs_qtd_alv-qtd_desc = ls_qtd_desc-qtd_desc.
            ld_value = gs_qtd-gamng.
          WHEN 2.
            gs_qtd_alv-qtd_desc = ls_qtd_desc-qtd_desc.
            ld_value = gs_qtd-qtdprod.
          WHEN 3.
            gs_qtd_alv-qtd_desc = ls_qtd_desc-qtd_desc.
            ld_value = gs_qtd-lmnga.
          WHEN 4.
            gs_qtd_alv-qtd_desc = ls_qtd_desc-qtd_desc.
            ld_value = gs_qtd-xmnga.
          WHEN 5.
            gs_qtd_alv-qtd_desc = ls_qtd_desc-qtd_desc.
            ld_value = gs_qtd-rmnga.
          WHEN 6.
            gs_qtd_alv-qtd_desc = ls_qtd_desc-qtd_desc.
            ld_value = gs_qtd-pctprod.
        ENDCASE.

*      Add differente quantities
        PERFORM add_data_quantity TABLES gt_total
                                  USING ld_day ld_value gs_qtd-areaid gs_qtd-hname gs_qtd-werks
                                        gs_qtd-arbpl gs_qtd-shiftid gs_qtd-week ls_qtd_desc-seqid
                                  CHANGING gs_qtd_alv-vdata1 gs_qtd_alv-vdata2 gs_qtd_alv-vdata3 gs_qtd_alv-vdata4 gs_qtd_alv-vdata5
                                           gs_qtd_alv-vdata6 gs_qtd_alv-vdata7 gs_qtd_alv-tshift gs_qtd_alv-tweek.

        MODIFY TABLE gt_qtd_alv FROM gs_qtd_alv TRANSPORTING vdata1 vdata2 vdata3 vdata4 vdata5
                                                             vdata6 vdata7 tshift tweek.
      ENDLOOP.
    ELSE.
*<<<PAP - Correcção
      MOVE-CORRESPONDING gs_qtd TO gs_qtd_alv.

*    Read description for Area
      READ TABLE lt_area_desc INTO ls_area_desc WITH KEY areaid = gs_qtd-areaid.

      IF sy-subrc EQ 0.
*      Area description
        gs_qtd_alv-area_desc = ls_area_desc-area_desc.
      ENDIF.

*    Read description for Hierarchy
      READ TABLE lt_hname_desc INTO ls_hname_desc WITH KEY name = gs_qtd-hname.

      IF sy-subrc EQ 0.
*      Hierarchy description
        gs_qtd_alv-hktext = ls_hname_desc-ktext.
      ENDIF.

*    Read description for Plant
      READ TABLE lt_werks_desc INTO ls_werks_desc WITH KEY werks = gs_qtd-werks.

      IF sy-subrc EQ 0.
*      Plant description
        gs_qtd_alv-name1 = ls_werks_desc-name1.
      ENDIF.

*    Read description for Workcenter
      READ TABLE lt_arbpl_desc INTO ls_arbpl_desc WITH KEY arbpl = gs_qtd-arbpl.

      IF sy-subrc EQ 0.
*      Workcenter description
        gs_qtd_alv-ktext = ls_arbpl_desc-ktext.
      ENDIF.

*    Read description for Shift
      READ TABLE lt_shift_desc INTO ls_shift_desc WITH KEY areaid  = gs_qtd-areaid
                                                           werks   = gs_qtd-werks
                                                           shiftid = gs_qtd-shiftid.

      IF sy-subrc EQ 0.
*      Shift description
        gs_qtd_alv-shift_desc = ls_shift_desc-shift_desc.
      ENDIF.

*    Get number day in week
      CALL FUNCTION 'DATE_COMPUTE_DAY'
        EXPORTING
          date = gs_qtd-data
        IMPORTING
          day  = ld_day.

*    Type quantities calculated
      LOOP AT it_qtd_desc INTO ls_qtd_desc.
        CLEAR: gs_qtd_alv-qtd_desc,
               gs_qtd_alv-vdata1,
               gs_qtd_alv-vdata2,
               gs_qtd_alv-vdata3,
               gs_qtd_alv-vdata4,
               gs_qtd_alv-vdata5,
               gs_qtd_alv-vdata6,
               gs_qtd_alv-vdata7,
               gs_qtd_alv-tshift,
               gs_qtd_alv-tweek,
               ld_value.

        CASE ls_qtd_desc-seqid.
          WHEN 1.
            gs_qtd_alv-qtd_desc = ls_qtd_desc-qtd_desc.
            ld_value = gs_qtd-gamng.
          WHEN 2.
            gs_qtd_alv-qtd_desc = ls_qtd_desc-qtd_desc.
            ld_value = gs_qtd-qtdprod.
          WHEN 3.
            gs_qtd_alv-qtd_desc = ls_qtd_desc-qtd_desc.
            ld_value = gs_qtd-lmnga.
          WHEN 4.
            gs_qtd_alv-qtd_desc = ls_qtd_desc-qtd_desc.
            ld_value = gs_qtd-xmnga.
          WHEN 5.
            gs_qtd_alv-qtd_desc = ls_qtd_desc-qtd_desc.
            ld_value = gs_qtd-rmnga.
          WHEN 6.
            gs_qtd_alv-qtd_desc = ls_qtd_desc-qtd_desc.
            ld_value = gs_qtd-pctprod.
        ENDCASE.

*      Add differente quantities
        PERFORM add_data_quantity TABLES gt_total
                                  USING ld_day ld_value gs_qtd-areaid gs_qtd-hname gs_qtd-werks
                                        gs_qtd-arbpl gs_qtd-shiftid gs_qtd-week ls_qtd_desc-seqid
                                  CHANGING gs_qtd_alv-vdata1 gs_qtd_alv-vdata2 gs_qtd_alv-vdata3 gs_qtd_alv-vdata4 gs_qtd_alv-vdata5
                                           gs_qtd_alv-vdata6 gs_qtd_alv-vdata7 gs_qtd_alv-tshift gs_qtd_alv-tweek.

*      Data for ALV
        APPEND gs_qtd_alv TO gt_qtd_alv.
      ENDLOOP.
    ENDIF.
  ENDLOOP.

*>>>PAP - Correcção - 20.05.2015
  DATA: ld_days TYPE pea_scrdd.

  FIELD-SYMBOLS: <fs_qtd_alv> TYPE zabsf_pp_s_data_alv.

  IF so_date[] IS NOT INITIAL.

    CLEAR ld_days.

    CALL FUNCTION 'HR_HK_DIFF_BT_2_DATES'
      EXPORTING
        date1                       = so_date-high
        date2                       = so_date-low
        output_format               = '03'
      IMPORTING
        days                        = ld_days
      EXCEPTIONS
        overflow_long_years_between = 1
        invalid_dates_specified     = 2
        OTHERS                      = 3.

    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.


    LOOP AT gt_qtd_alv ASSIGNING <fs_qtd_alv> WHERE qtd_desc EQ TEXT-015.

      IF ld_days IS NOT INITIAL.
        <fs_qtd_alv>-tshift = <fs_qtd_alv>-tshift / ld_days.
        <fs_qtd_alv>-tweek = <fs_qtd_alv>-tweek / ld_days.
      ENDIF.
    ENDLOOP.

  ENDIF.
*<<<PAP - Correcção - 20.05.2015
ENDFORM.                    " FILL_DATA_ALV
*&---------------------------------------------------------------------*
*&      Form  ADD_DATA_QUANTITY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_DAY  text
*      -->P_AREAID  text
*      -->P_HNAME  text
*      -->P_WERKS  text
*      -->P_ARBPL  text
*      -->P_SHIFTID  text
*      -->P_WEEK  text
*      -->P_IT_TOTAL  text
*      <--P_TSHIFT  text
*      <--P_TWEEK  text
*----------------------------------------------------------------------*
FORM add_data_quantity TABLES p_it_total LIKE gt_total
                       USING p_day p_value p_areaid p_hname p_werks p_arbpl
                             p_shiftid p_week p_seqid
                       CHANGING p_vdata1 p_vdata2 p_vdata3 p_vdata4 p_vdata5
                                 p_vdata6 p_vdata7 p_tshift p_tweek.

  DATA ls_total TYPE ty_total.

*Put value quantity in corresponding day in week
  CASE p_day.
    WHEN 1.
      p_vdata1 = p_value.
    WHEN 2.
      p_vdata2 = p_value.
    WHEN 3.
      p_vdata3 = p_value.
    WHEN 4.
      p_vdata4 = p_value.
    WHEN 5.
      p_vdata5 = p_value.
    WHEN 6.
      p_vdata6 = p_value.
    WHEN 7.
      p_vdata7 = p_value.
  ENDCASE.

*Total value quantity for shift
  CLEAR ls_total.
  LOOP AT p_it_total INTO ls_total WHERE areaid  EQ p_areaid
                                     AND hname   EQ p_hname
                                     AND werks   EQ p_werks
                                     AND arbpl   EQ p_arbpl
                                     AND shiftid EQ p_shiftid
                                     AND week    EQ p_week.

*  Total for shift
    CASE p_seqid.
      WHEN 1.
        ADD ls_total-tot_gamng TO p_tshift.
      WHEN 2.
        ADD ls_total-tot_qtdprod TO p_tshift.
      WHEN 3.
        ADD ls_total-tot_lmnga TO p_tshift.
      WHEN 4.
        ADD ls_total-tot_xmnga TO p_tshift.
      WHEN 5.
        ADD ls_total-tot_rmnga TO p_tshift.
      WHEN 6.
        ADD ls_total-tot_pctprod TO p_tshift.
    ENDCASE.
  ENDLOOP.

*Total value quantity in week
  CLEAR ls_total.
  LOOP AT p_it_total INTO ls_total WHERE areaid EQ p_areaid
                                     AND hname  EQ p_hname
                                     AND werks  EQ p_werks
                                     AND arbpl  EQ p_arbpl
                                     AND week   EQ p_week.

*  Total for shift
    CASE p_seqid.
      WHEN 1.
        ADD ls_total-tot_gamng TO p_tweek.
      WHEN 2.
        ADD ls_total-tot_qtdprod TO p_tweek.
      WHEN 3.
        ADD ls_total-tot_lmnga TO p_tweek.
      WHEN 4.
        ADD ls_total-tot_xmnga TO p_tweek.
      WHEN 5.
        ADD ls_total-tot_rmnga TO p_tweek.
      WHEN 6.
        ADD ls_total-tot_pctprod TO p_tweek.
    ENDCASE.
  ENDLOOP.
ENDFORM.                    " ADD_DATA_QUANTITY
*&---------------------------------------------------------------------*
*&      Form  GET_DATA_DB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data_db .
  DATA: lt_zabsf_pp056 TYPE TABLE OF zabsf_pp056.

  DATA: ls_zabsf_pp056 TYPE zabsf_pp056.

  REFRESH lt_zabsf_pp056.

*Get all data saved in database
  SELECT *
    FROM zabsf_pp056
    INTO CORRESPONDING FIELDS OF TABLE lt_zabsf_pp056
    WHERE areaid  EQ pa_area
      AND hname   IN so_hname
      AND werks   EQ pa_werks
      AND arbpl   IN so_arbpl
      AND shiftid IN so_shift
      AND data    IN so_date.

  IF lt_zabsf_pp056[] IS NOT INITIAL.
*  Pass data to global internal table
    gt_qtd[] = lt_zabsf_pp056[].
  ELSE.
*    MESSAGE i018(zabsf_pp).

    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
*       msgid      = sy-msgid
        msgty      = 'I'
        msgno      = '018'
      CHANGING
        return_tab = gt_error.
    EXIT.
  ENDIF.
ENDFORM.                    " GET_DATA_DB
*&---------------------------------------------------------------------*
*&      Form  GET_DATA_AFRU
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data_afru .
  DATA: lt_crhd TYPE TABLE OF crhd,
        wa_crhd TYPE crhd.

  DATA: r_arbpl  TYPE RANGE OF objid,
        wa_arbpl LIKE LINE OF r_arbpl.

*Get workcenter id
  SELECT objid
    FROM crhd
    INTO CORRESPONDING FIELDS OF TABLE lt_crhd
    WHERE arbpl IN so_arbpl
     AND werks = pa_werks
     AND objty EQ 'A'.

  IF lt_crhd[] IS NOT INITIAL.
    LOOP AT lt_crhd INTO wa_crhd.
      wa_arbpl-option = 'EQ'.
      wa_arbpl-sign = 'I'.
      wa_arbpl-low = wa_crhd-objid.

      APPEND wa_arbpl TO r_arbpl.
    ENDLOOP.
  ENDIF.

  IF pa_area EQ c_mec  OR pa_area EQ c_opt OR pa_area EQ c_prd.
*  Get confirmation for day, shift and workcenter
    SELECT *
      FROM afru
      INTO CORRESPONDING FIELDS OF TABLE gt_afru
      WHERE budat    EQ pa_date
        AND arbid    IN r_arbpl
        AND werks    EQ pa_werks
        AND kaptprog IN so_shift
        AND stokz    EQ space
        AND stzhl    EQ space.
  ELSE.
    "  PERFORM get_afru_mont TABLES r_arbpl. lógica não utilizada
  ENDIF.
ENDFORM.                    " GET_DATA_AFRU
*&---------------------------------------------------------------------*
*&      Form  GET_QUANTITY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_<FS_QTD>_AREAID  text
*      -->P_<FS_QTD>_HNAME  text
*      -->P_<FS_QTD>_WERKS  text
*      -->P_<FS_QTD>_ARBPL  text
*      -->P_<FS_QTD>_SHIFTID  text
*      -->P_<FS_QTD>_DATA  text
*      <--P_<FS_QTD>_GAMNG  text
*      <--P_<FS_QTD>_LMNGA  text
*      <--P_<FS_QTD>_XMNGA  text
*      <--P_<FS_QTD>_RMNGA  text
*      <--P_<FS_QTD>_QTDPROD  text
*      <--P_<FS_QTD>_PCTPROD  text
*----------------------------------------------------------------------*
FORM get_quantity USING p_areaid p_hname p_werks
                        p_arbpl p_shiftid p_data
                  CHANGING p_gamng p_lmnga p_xmnga
                           p_rmnga p_qtdprod p_pctprod.

  TYPES: BEGIN OF ty_aufnr,
           aufnr TYPE aufnr,
         END OF ty_aufnr.

  DATA: lt_afko  TYPE TABLE OF afko,
        lt_aufnr TYPE TABLE OF ty_aufnr.

  DATA: ls_afru  TYPE afru,
        ls_afko  TYPE afko,
        ld_objid TYPE cr_objid.

  IF gt_afru[] IS NOT INITIAL.
*  Get workcenter id
    SELECT SINGLE objid
      FROM crhd
      INTO ld_objid
     WHERE arbpl EQ p_arbpl
      AND werks EQ p_werks
       AND objty EQ 'A'.

    LOOP AT gt_afru INTO ls_afru WHERE budat    EQ p_data
                                   AND arbid    EQ ld_objid
                                   AND werks    EQ p_werks
                                   AND kaptprog EQ p_shiftid.

*    Good Quantity
      ADD ls_afru-lmnga TO p_lmnga.
*    Quantity scrap
*      ADD ls_afru-xmnga TO p_xmnga.
      IF ls_afru-xmnga IS NOT INITIAL AND ls_afru-grund = '0005'.
        ADD ls_afru-xmnga TO p_xmnga.
      ENDIF.
*    Quantity rework
      ADD ls_afru-rmnga TO p_rmnga.

*      APPEND ls_afru-aufnr TO lt_aufnr.
    ENDLOOP.

*    SORT lt_aufnr.
*
*    DELETE ADJACENT DUPLICATES FROM lt_aufnr.
*
*    IF lt_aufnr[] IS NOT INITIAL.
**    Get details of orders to calculated Quantity expected
*      SELECT *
*        FROM afko
*        INTO CORRESPONDING FIELDS OF TABLE lt_afko
*        FOR ALL ENTRIES IN lt_aufnr
*       WHERE aufnr EQ lt_aufnr-aufnr.
*
*      LOOP AT lt_afko INTO ls_afko.
**      Quantity expected
*        ADD ls_afko-gamng TO p_gamng.
*      ENDLOOP.
*
**    Quantity produced
*      p_qtdprod = p_lmnga + p_xmnga + p_rmnga.
*
*      IF p_gamng NE 0.
**      Percentage of produced quntities completed
*        p_pctprod = ( p_lmnga / p_gamng ) * 100.
*      ENDIF.
*    ENDIF.

*  Quantity expected
    SELECT SINGLE qty_prev
      FROM zabsf_pp013
      INTO p_gamng
     WHERE areaid EQ p_areaid
       AND werks  EQ p_werks
       AND arbpl  EQ p_arbpl
       AND endda  GE sy-datum
       AND begda  LE sy-datum.

*  Quantity produced
    p_qtdprod = p_lmnga + p_xmnga + p_rmnga.

    IF p_gamng NE 0.
*    Percentage of produced quntities completed
      p_pctprod = ( p_lmnga / p_gamng ) * 100.
    ENDIF.
  ENDIF.
ENDFORM.                    " GET_QUANTITY
*&---------------------------------------------------------------------*
*&      Form  GET_AFRU_MONT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_R_ARBPL  text
*----------------------------------------------------------------------*
FORM get_afru_mont  TABLES p_arbpl TYPE STANDARD TABLE.

  DATA: lt_mkpf       TYPE TABLE OF mkpf,
        lt_mkpf_aux   TYPE TABLE OF mkpf,
        lt_blpp_mblnr TYPE TABLE OF blpp,
        lt_blpp_afru  TYPE TABLE OF blpp,
        lt_blpk       TYPE TABLE OF blpk.

  DATA: ls_mkpf       TYPE mkpf,
        ls_blpp_mblnr TYPE blpp,
        ls_blpp_afru  TYPE blpp,
        ls_shift      LIKE so_shift.

  FIELD-SYMBOLS: <fs_afru> TYPE afru.


  REFRESH: lt_mkpf,
           lt_mkpf_aux,
           lt_blpp_mblnr,
           lt_blpp_afru,
           lt_blpk.

  CLEAR: ls_mkpf,
         ls_blpp_mblnr,
         ls_blpp_afru,
         ls_shift.

*Get all material document created in day
  LOOP AT so_shift INTO ls_shift.
    SELECT *
      FROM mkpf
      INTO CORRESPONDING FIELDS OF TABLE lt_mkpf_aux
     WHERE mjahr EQ pa_date(4)
       AND bldat EQ pa_date
       AND bktxt EQ ls_shift-low
       AND vgart EQ c_vgart
       AND blart EQ c_blart
       AND blaum EQ c_blaum.

    INSERT LINES OF lt_mkpf_aux INTO TABLE lt_mkpf.
  ENDLOOP.

  SORT lt_mkpf BY mblnr bktxt.

  DELETE ADJACENT DUPLICATES FROM lt_mkpf.

  IF lt_mkpf[] IS NOT INITIAL.
*  Get Confirmation number of material document
    SELECT *
      FROM blpp
      INTO CORRESPONDING FIELDS OF TABLE lt_blpp_mblnr
       FOR ALL ENTRIES IN lt_mkpf
     WHERE belnr EQ lt_mkpf-mblnr.

    IF lt_blpp_mblnr[] IS NOT INITIAL.
*    Get confirmation number of material document valid for day
      SELECT *
        FROM blpk
        INTO CORRESPONDING FIELDS OF TABLE lt_blpk
         FOR ALL ENTRIES IN lt_blpp_mblnr
       WHERE prtnr EQ lt_blpp_mblnr-prtnr
         AND datum EQ pa_date.

      IF lt_blpk[] IS NOT INITIAL.
*      Get confirmation number for afru
        SELECT *
          FROM blpp
          INTO CORRESPONDING FIELDS OF TABLE lt_blpp_afru
          FOR ALL ENTRIES IN lt_blpk
          WHERE prtnr EQ lt_blpk-prtnr
           AND belnr EQ space
           AND rueck NE '0000000000'
           AND rmzhl NE '00000000'.

        IF lt_blpp_afru[] IS NOT INITIAL.
*        Get confirmation
          SELECT  afru~rueck afru~rmzhl afru~budat plpo~arbid afru~werks afru~isdd
                  afru~stokz afru~stzhl afru~lmnga afru~rmnga afru~xmnga afru~aufpl
                  afru~aplzl afru~vornr afru~aufnr
            INTO CORRESPONDING FIELDS OF TABLE gt_afru
            FROM afru AS afru
           INNER JOIN afvc AS afvc
              ON afvc~aufpl EQ afru~aufpl
             AND afvc~aplzl EQ afru~aplzl
           INNER JOIN plpo AS plpo
              ON plpo~plnnr EQ afvc~plnnr
             AND plpo~plnkn EQ afvc~plnkn
             AND plpo~zaehl EQ afvc~zaehl
             AND plpo~plnty EQ afvc~plnty
             AND plpo~vornr EQ afvc~vornr
             FOR ALL ENTRIES IN lt_blpp_afru
           WHERE afru~rueck EQ lt_blpp_afru-rueck
             AND afru~budat EQ pa_date
             AND afru~werks EQ pa_werks
             AND afru~stokz EQ space
             AND afru~stzhl EQ space
             AND plpo~arbid IN p_arbpl.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

  IF gt_afru[] IS NOT INITIAL.
    LOOP AT gt_afru ASSIGNING <fs_afru>.
      CLEAR: ls_mkpf,
             ls_blpp_mblnr,
             ls_blpp_afru.

      READ TABLE lt_blpp_afru INTO ls_blpp_afru WITH KEY rueck = <fs_afru>-rueck
                                                         rmzhl = <fs_afru>-rmzhl.

      IF sy-subrc EQ 0.
        READ TABLE lt_blpp_mblnr INTO ls_blpp_mblnr WITH KEY prtnr = ls_blpp_afru-prtnr.

        IF sy-subrc EQ 0.
          READ TABLE lt_mkpf INTO ls_mkpf WITH KEY mblnr = ls_blpp_mblnr-belnr.

          IF sy-subrc EQ 0.
            <fs_afru>-kaptprog = ls_mkpf-bktxt.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDIF.
ENDFORM.                    " GET_AFRU_MONT

*{   INSERT         &$&$&$&$                                          1
*&---------------------------------------------------------------------*
*&      Form  CREATE_DATA_RANGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM create_data_range .

  DATA: lv_date_past   TYPE begda,
        lv_date_future TYPE endda,
        lr_dates       TYPE rsis_s_range.

  CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
    EXPORTING
      date      = sy-datum
      days      = 0
      months    = 1
      signum    = '-'
      years     = 0
    IMPORTING
      calc_date = lv_date_past.


  CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
    EXPORTING
      date      = sy-datum
      days      = 1
      months    = 0
      signum    = '+'
      years     = 0
    IMPORTING
      calc_date = lv_date_future.

  lr_dates-sign = 'I'.
  lr_dates-high = 'BT'.
  lr_dates-low = lv_date_past.
  lr_dates-high = lv_date_future.

  APPEND lr_dates TO gr_dates.

  CALL FUNCTION 'DAY_ATTRIBUTES_GET'
    EXPORTING
      date_from                  = lv_date_past
      date_to                    = lv_date_future
    TABLES
      day_attributes             = gt_days
    EXCEPTIONS
      factory_calendar_not_found = 1
      holiday_calendar_not_found = 2
      date_has_invalid_format    = 3
      date_inconsistency         = 4
      OTHERS                     = 5.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


*  Week
  CALL FUNCTION 'DATE_GET_WEEK'
    EXPORTING
      date         = pa_date
    IMPORTING
      week         = gs_qtd-week
    EXCEPTIONS
      date_invalid = 1
      OTHERS       = 2.

  IF sy-subrc <> 0.
*    Message error standard
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgid      = sy-msgid
        msgty      = sy-msgty
        msgno      = sy-msgno
        msgv1      = sy-msgv1
        msgv2      = sy-msgv2
        msgv3      = sy-msgv3
        msgv4      = sy-msgv4
      CHANGING
        return_tab = gt_error.
  ENDIF.



ENDFORM.
*}   INSERT
*&---------------------------------------------------------------------*
*&      Form  GET_AREAS_FOR_PLANT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_areas_for_plant .

  DATA: lt_sf008 TYPE TABLE OF zabsf_pp008,
        ls_sf008 TYPE zabsf_pp008.


  IF pa_area IS NOT INITIAL.
    gs_qtd-areaid = pa_area.
  ELSE.

    SELECT * FROM zabsf_pp008 INTO TABLE lt_sf008
        WHERE werks = pa_werks
        AND tarea_id = gc_type_area
        AND begda LE sy-datlo
        AND endda GE sy-datlo.

    LOOP AT lt_sf008 INTO ls_sf008.

      gs_qtd-areaid = ls_sf008-areaid.
      APPEND gs_qtd TO gt_qtd.
      CLEAR ls_sf008.
    ENDLOOP.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_HIERARCHIES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_hierarchies .

  DATA: ls_qtd LIKE LINE OF gt_qtd.

  LOOP AT gt_qtd INTO ls_qtd.

    CLEAR: ls_qtd.
  ENDLOOP.

ENDFORM.
