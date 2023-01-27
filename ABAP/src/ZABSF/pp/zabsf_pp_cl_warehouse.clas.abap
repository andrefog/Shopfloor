class ZABSF_PP_CL_WAREHOUSE definition
  public
  final
  create public .

public section.

  methods GET_ORDER_TO_CONF
    importing
      !MATNR type MATNR
    changing
      !STOCK type ZABSF_PP_E_STOCK
      !GOODMVT_TAB type ZABSF_PP_T_GOODMVT
      !RETURN_TAB type BAPIRET2_T .
  methods CONSTRUCTOR
    importing
      !INITIAL_REFDT type VVDATUM
      !INPUT_OBJECT type ZABSF_PP_S_INPUTOBJECT .
  methods GET_WAREHOUSES
    changing
      !WAREHOUSE_TAB type ZABSF_PP_T_WAREHOUSE
      !RETURN_TAB type BAPIRET2_T .
  methods GET_WAREHOUSES_DETAIL
    importing
      !WAREID type ZABSF_PP_E_WAREID optional
      !MATNR type MATNR optional
      !HNAME type CR_HNAME optional
    changing
      !WAREHOUSE_TAB type ZABSF_PP_T_WAREHOUSE
      !WAREH_DETAIL_TAB type ZABSF_PP_T_WAREH_DETAIL
      !RETURN_TAB type BAPIRET2_T .
  methods SET_REFDT
    importing
      !NEW_REFDT type VVDATUM .
  methods SET_QUALITY_WARE
    importing
      !WAREID type ZABSF_PP_E_WAREID
      !MATNR type MATNR
      !REWORK_QTY type RU_RMNGA optional
      !DEFECTID type ZABSF_PP_E_DEFECTID optional
      !REWORK_TAB type ZABSF_PP_T_REWORK optional
      !SCRAP_QTY type RU_XMNGA optional
      !GRUND type CO_AGRND optional
      !LMNGA type LMNGA optional
      !GMEIN type MEINS optional
    changing
      !RETURN_TAB type BAPIRET2_T .
  methods GET_DEFECTS_WARE
    importing
      !WAREID type ZABSF_PP_E_WAREID
      !REASONTYP type ZABSF_PP_E_REASONTYP
    changing
      !DEFECT_WARE_TAB type ZABSF_PP_T_DEFECT_WARE
      !REASON_TAB type ZABSF_PP_T_REASON
      !RETURN_TAB type BAPIRET2_T .
  methods GET_STOCK_WAREHOUSE
    importing
      !HNAME type CR_HNAME
    changing
      !STOCKS_TAB type ZABSF_PP_T_STOCKS
      !RETURN_TAB type BAPIRET2_T .
protected section.
private section.

  data REFDT type VVDATUM .
  data INPUTOBJ type ZABSF_PP_S_INPUTOBJECT .
  constants TIPO_ORDEM type ZABSF_PP_E_TIPORD value 'N' ##NO_TEXT.
ENDCLASS.



CLASS ZABSF_PP_CL_WAREHOUSE IMPLEMENTATION.


METHOD CONSTRUCTOR.

*Ref. Date
  refdt    = initial_refdt.

*App input data
  inputobj = input_object.

ENDMETHOD.


METHOD get_defects_ware.

  IF reasontyp EQ 'D'.
*  Get defects
    SELECT zabsf_pp037~defectid zabsf_pp037_t~defect_desc
      INTO CORRESPONDING FIELDS OF TABLE defect_ware_tab
      FROM zabsf_pp037 AS zabsf_pp037
     INNER JOIN zabsf_pp037_t AS zabsf_pp037_t
        ON zabsf_pp037_t~areaid EQ zabsf_pp037~areaid
       AND zabsf_pp037_t~wareid EQ zabsf_pp037~wareid
       AND zabsf_pp037_t~defectid EQ zabsf_pp037~defectid
     WHERE zabsf_pp037~areaid EQ inputobj-areaid
       AND zabsf_pp037~werks  EQ inputobj-werks
       AND zabsf_pp037~wareid EQ wareid.

    IF sy-subrc EQ 0.
*    Operation completed successfully
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'S'
          msgno      = '013'
        CHANGING
          return_tab = return_tab.
    ELSE.
*    No defects found
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '037'
          msgv1      = inputobj-areaid
          msgv2      = wareid
          msgv3      = inputobj-werks
        CHANGING
          return_tab = return_tab.
    ENDIF.
  ENDIF.

  IF reasontyp EQ 'C'.
*  Reason for variances in completion confirmations
    SELECT grund grdtx
      FROM trugt
      INTO CORRESPONDING FIELDS OF TABLE reason_tab
      WHERE werks EQ inputobj-werks
        AND spras EQ sy-langu.

    IF sy-subrc EQ 0.
*    Operation completed successfully
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'S'
          msgno      = '013'
        CHANGING
          return_tab = return_tab.
    ELSE.
*    No reason found
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '033'
          msgv1      = inputobj-werks
        CHANGING
          return_tab = return_tab.
    ENDIF.
  ENDIF.
ENDMETHOD.


METHOD get_order_to_conf.
  DATA: lt_goodmvt_temp TYPE TABLE OF ty_goodsmvt,
        lt_afvc         TYPE TABLE OF afvc,
        lt_t430         TYPE TABLE OF t430,
        lt_vornr        TYPE TABLE OF ty_vornr,
        lt_afvv         TYPE TABLE OF afvv,
        lt_crhd         TYPE TABLE OF crhd,
        lt_auart_bd     TYPE TABLE OF zabsf_pp019.

  DATA: wa_goodmvt   TYPE zabsf_pp_s_goodmvt,
        ld_auart     TYPE auart,
        ls_afvc      TYPE afvc,
        ls_t430      TYPE t430,
        ls_jest      TYPE jest,
        ls_vornr     TYPE ty_vornr,
        ls_auart_bd  TYPE zabsf_pp019,
        ld_aufpl_ant TYPE co_aufpl,
        ls_afvv      TYPE afvv,
        ls_crhd      TYPE crhd,
        ld_lmnga     TYPE lmnga,
        ld_xmnga_act TYPE xmnga,
        ld_wareid    TYPE zabsf_pp_e_wareid.

  DATA: r_auart  TYPE RANGE OF auart,
        wa_auart LIKE LINE OF r_auart.

  FIELD-SYMBOLS <fs_good> TYPE ty_goodsmvt.

  REFRESH: lt_goodmvt_temp,
           lt_afvc,
           lt_t430,
           lt_vornr,
           lt_afvv,
           lt_crhd,
           lt_auart_bd.

  CLEAR: ld_aufpl_ant,
         ls_auart_bd,
         ld_auart,
         ls_afvc,
         ls_crhd.

*Get order type
*  SELECT SINGLE auart
*    FROM ZABSF_PP019
*    INTO ld_auart
*    WHERE areaid EQ inputobj-areaid
*      AND tipord EQ tipo_ordem.
  SELECT auart
    FROM zabsf_pp019
    INTO CORRESPONDING FIELDS OF TABLE lt_auart_bd
   WHERE areaid EQ inputobj-areaid.

*Create range for order type
  LOOP AT lt_auart_bd INTO ls_auart_bd.
    CLEAR wa_auart.

    wa_auart-sign = 'I'.
    wa_auart-option = 'EQ'.
    wa_auart-low = ls_auart_bd-auart.

    APPEND wa_auart TO r_auart.
  ENDLOOP.

*Get all orders in workcenter
  SELECT aufk~aufnr aufk~objnr afko~gstrs afko~gamng afko~gmein afko~plnbez afko~stlbez
         afko~aufpl afvc~aplzl afvc~arbid afvc~vornr afvc~ltxa1 afvc~steus jest~stat
    INTO CORRESPONDING FIELDS OF TABLE lt_goodmvt_temp
    FROM afko AS afko
   INNER JOIN aufk AS aufk
      ON aufk~aufnr EQ afko~aufnr
   INNER JOIN jest AS jest
      ON jest~objnr EQ aufk~objnr
     AND jest~stat  EQ 'I0010' " CONF PARC
     AND jest~inact EQ space
   INNER JOIN afvc AS afvc
      ON afvc~aufpl EQ afko~aufpl
   INNER JOIN t430 AS t430
      ON t430~steus EQ afvc~steus
     AND t430~ruek  EQ '1'
     AND t430~autwe EQ 'X'
   WHERE afko~stlbez EQ matnr
     AND afvc~werks EQ inputobj-werks
     AND afvc~steus EQ 'ZLP3'
*     AND aufk~auart EQ ld_auart.
     AND aufk~auart IN r_auart.

  IF lt_goodmvt_temp[] IS NOT INITIAL.
*  Get workcenters
    SELECT *
      FROM crhd
      INTO CORRESPONDING FIELDS OF TABLE lt_crhd
      FOR ALL ENTRIES IN lt_goodmvt_temp
      WHERE objty EQ 'A'
        AND objid EQ lt_goodmvt_temp-arbid
        AND werks EQ inputobj-werks.

*  Get quantity confirmed for last operation of order
    SELECT *
      FROM afvv
      INTO CORRESPONDING FIELDS OF TABLE lt_afvv
      FOR ALL ENTRIES IN lt_goodmvt_temp
      WHERE aufpl EQ lt_goodmvt_temp-aufpl
        AND aplzl EQ lt_goodmvt_temp-aplzl.

*  Get operation of order
    SELECT *
      FROM afvc
      INTO CORRESPONDING FIELDS OF TABLE lt_afvc
      FOR ALL ENTRIES IN lt_goodmvt_temp
     WHERE aufpl EQ lt_goodmvt_temp-aufpl.

*  Check steus
    SELECT *
      FROM t430
      INTO CORRESPONDING FIELDS OF TABLE lt_t430
      FOR ALL ENTRIES IN lt_afvc
      WHERE steus EQ lt_afvc-steus
        AND ruek  EQ '1'
        AND autwe EQ space.

    SORT lt_afvc BY aufpl vornr ASCENDING.

*  Get last operation mark confirmed
    LOOP AT lt_afvc INTO ls_afvc.
      CLEAR ls_vornr.

*      IF sy-tabix EQ 1.
*        ld_aufpl_ant = ls_afvc-aufpl.
*      ENDIF.

*      IF ld_aufpl_ant EQ ls_afvc-aufpl.

*    Check if exist Routing number for operation in internal table
      READ TABLE lt_vornr INTO ls_vornr WITH KEY aufpl = ls_afvc-aufpl.

      IF sy-subrc NE 0.
*      Create a new line in internal table for last operation confirmed
        ls_vornr-aufpl = ls_afvc-aufpl.
        INSERT ls_vornr INTO TABLE lt_vornr.
      ENDIF.

*    Check if was operation mark
      READ TABLE lt_t430 INTO ls_t430 WITH KEY steus = ls_afvc-steus.

      IF sy-subrc EQ 0.
*      Check if operation was confirmed
        SELECT SINGLE *
          FROM jest
          INTO CORRESPONDING FIELDS OF ls_jest
         WHERE objnr EQ ls_afvc-objnr
           AND ( stat EQ 'I0010' OR    "CONF PARC
                 stat EQ 'I0009' )
           AND inact EQ space.    "CONF

        IF sy-subrc EQ 0.
*        Modify internal table with the new operation
          ls_vornr-vornr_ant = ls_afvc-vornr.
          ls_vornr-aplzl_ant = ls_afvc-aplzl.
          MODIFY lt_vornr FROM ls_vornr TRANSPORTING vornr vornr_ant aplzl_ant WHERE aufpl EQ ls_afvc-aufpl.
        ENDIF.

      ELSE.
*      Modify internal table with the last operation of order
        ls_vornr-vornr = ls_afvc-vornr.
        MODIFY lt_vornr FROM ls_vornr TRANSPORTING vornr vornr_ant aplzl_ant WHERE aufpl EQ ls_afvc-aufpl.
      ENDIF.
*      ELSE.
**      Create a new line in internal table for last operation confirmed
*        ls_vornr-aufpl = ls_afvc-aufpl.
*
*        INSERT ls_vornr INTO TABLE lt_vornr.
*      ENDIF.

*      ld_aufpl_ant = ls_afvc-aufpl.
    ENDLOOP.

    LOOP AT lt_goodmvt_temp ASSIGNING <fs_good>.
      CLEAR: wa_goodmvt,
             ls_vornr,
             ls_crhd,
             ld_lmnga,
             ld_xmnga_act.

*    Plant
      wa_goodmvt-werks = inputobj-werks.
*    Workcenter
      READ TABLE lt_crhd INTO ls_crhd WITH KEY objid = <fs_good>-arbid.

      IF sy-subrc EQ 0.
        wa_goodmvt-arbpl = ls_crhd-arbpl.
      ENDIF.

*    Order number
      wa_goodmvt-aufnr = <fs_good>-aufnr.
*    Operation Number
      wa_goodmvt-vornr = <fs_good>-vornr.
*    Description of operation
      wa_goodmvt-ltxa1 = <fs_good>-ltxa1.
*    Routing number for operation
      wa_goodmvt-aufpl = <fs_good>-aufpl.

*    Material Number
      IF <fs_good>-plnbez IS NOT INITIAL.
        wa_goodmvt-matnr = <fs_good>-plnbez.
      ELSE.
        wa_goodmvt-matnr = <fs_good>-stlbez.
      ENDIF.

*    Material Description
      SELECT SINGLE maktx
        FROM makt
        INTO wa_goodmvt-maktx
        WHERE matnr EQ wa_goodmvt-matnr
          AND spras EQ sy-langu.

*    Target quantity
      wa_goodmvt-gamng = <fs_good>-gamng.
*    Base Unit
      wa_goodmvt-gmein = <fs_good>-gmein.
*    Sched. start
      wa_goodmvt-gstrs = <fs_good>-gstrs.

*    Confirmed yield
      READ TABLE lt_afvv INTO ls_afvv WITH KEY aufpl = <fs_good>-aufpl
                                               aplzl = <fs_good>-aplzl.
      IF sy-subrc EQ 0.
        wa_goodmvt-lmnga = ls_afvv-lmnga.
        ld_xmnga_act = ls_afvv-xmnga.
      ENDIF.

*    Get last operation confirmed
      READ TABLE lt_vornr INTO ls_vornr WITH KEY aufpl = <fs_good>-aufpl
                                                 vornr = <fs_good>-vornr.

      IF sy-subrc EQ 0.
        SELECT SINGLE lmnga
          FROM afvv
          INTO ld_lmnga
         WHERE aufpl EQ ls_vornr-aufpl
           AND aplzl EQ ls_vornr-aplzl_ant.

*      Missing quantity
        wa_goodmvt-missingqty = ld_lmnga - ( wa_goodmvt-lmnga + ld_xmnga_act ).

*      Quantity of back operation
        SELECT SUM( lmnga ) SUM( xmnga )
          FROM afru
          INTO (wa_goodmvt-qty_oprant,wa_goodmvt-qty_refant)
         WHERE aufnr EQ wa_goodmvt-aufnr
           AND vornr EQ ls_vornr-vornr_ant
           AND stokz EQ space
           AND stzhl EQ space.
      ENDIF.

      APPEND wa_goodmvt TO goodmvt_tab.
    ENDLOOP.
  ELSE.
*  Information: No orders found for material
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'I'
        msgno      = '041'
        msgv1      = matnr
      CHANGING
        return_tab = return_tab.
  ENDIF.

*Get stock of last warehouse
  SELECT SINGLE wareid
    FROM zabsf_pp039
    INTO ld_wareid
   WHERE areaid EQ inputobj-areaid
     AND werks EQ inputobj-werks
     AND ware_next EQ space.

  IF ld_wareid IS NOT INITIAL.
*  Get stock of warehouse
    SELECT SINGLE lmnga
      FROM zabsf_pp035
      INTO stock
     WHERE areaid EQ inputobj-areaid
       AND wareid EQ ld_wareid
       AND matnr EQ matnr.
  ENDIF.
ENDMETHOD.


METHOD get_stock_warehouse.
  DATA: lt_zabsf_pp038 TYPE TABLE OF zabsf_pp038,
        lt_zabsf_pp035 TYPE TABLE OF zabsf_pp035,
        lt_zabsf_pp041 TYPE TABLE OF zabsf_pp041,
        lt_zabsf_pp054 TYPE TABLE OF zabsf_pp054,
        lt_makt        TYPE TABLE OF makt,
        lt_mard        TYPE TABLE OF mard,
        lt_marc        TYPE TABLE OF marc.

  DATA: ls_zabsf_pp038 TYPE zabsf_pp038,
        ls_zabsf_pp035 TYPE zabsf_pp035,
        ls_zabsf_pp041 TYPE zabsf_pp041,
        ls_zabsf_pp054 TYPE zabsf_pp054,
        ls_stocks      TYPE zabsf_pp_s_stocks,
        ls_makt        TYPE makt,
        ls_mard        TYPE mard,
        ls_marc        TYPE marc,
        ld_lgort_col   TYPE zabsf_pp_e_lgort_col,
        ld_lgort_fin   TYPE zabsf_pp_e_lgort_fin,
        ld_tot_max     TYPE zabsf_pp_e_maxlim,
        count          TYPE i.

  DATA: r_lgort  TYPE RANGE OF lgort_d,
        wa_lgort LIKE LINE OF r_lgort.

  REFRESH: lt_zabsf_pp038,
           lt_zabsf_pp035,
           lt_zabsf_pp041,
           lt_zabsf_pp054,
           lt_makt,
           lt_mard,
           lt_marc.

  CLEAR: ls_zabsf_pp038,
         ls_zabsf_pp035,
         ls_zabsf_pp041,
         ls_zabsf_pp054,
         ls_stocks,
         ls_makt,
         ls_mard,
         ls_marc,
         ld_lgort_col,
         ld_lgort_fin,
         ld_tot_max,
         r_lgort,
         wa_lgort.

*Get all materials
  SELECT *
    FROM zabsf_pp038
    INTO CORRESPONDING FIELDS OF TABLE lt_zabsf_pp038
    WHERE areaid EQ inputobj-areaid
      AND werks  EQ inputobj-werks
      AND hname  EQ hname.

  IF lt_zabsf_pp038[] IS NOT INITIAL.
*  Get material description
    SELECT *
      FROM makt
      INTO CORRESPONDING FIELDS OF TABLE lt_makt
      FOR ALL ENTRIES IN lt_zabsf_pp038
     WHERE matnr EQ lt_zabsf_pp038-matnr
       AND spras EQ sy-langu.

*  Get storage location real
    SELECT SINGLE lgort_col lgort_fin
      FROM zabsf_pp040
      INTO (ld_lgort_col, ld_lgort_fin)
     WHERE areaid EQ inputobj-areaid
       AND werks EQ inputobj-werks.

*  Create range of lgort
    CLEAR wa_lgort.
    wa_lgort-sign = 'I'.
    wa_lgort-option = 'EQ'.
    wa_lgort-low = ld_lgort_col.

    APPEND wa_lgort TO r_lgort.

    CLEAR wa_lgort.
    wa_lgort-sign = 'I'.
    wa_lgort-option = 'EQ'.
    wa_lgort-low = ld_lgort_fin.

    APPEND wa_lgort TO r_lgort.

*  Get stock of range of lgort
    SELECT *
      FROM mard
      INTO CORRESPONDING FIELDS OF TABLE lt_mard
      FOR ALL ENTRIES IN lt_zabsf_pp038
     WHERE matnr EQ lt_zabsf_pp038-matnr
       AND werks EQ inputobj-werks
       AND lgort IN r_lgort.

*  Get material group
    SELECT *
      FROM marc
      INTO CORRESPONDING FIELDS OF TABLE lt_marc
       FOR ALL ENTRIES IN lt_zabsf_pp038
     WHERE matnr EQ lt_zabsf_pp038-matnr
       AND werks EQ inputobj-werks.

*  Get material group description
    SELECT *
      FROM zabsf_pp054
      INTO CORRESPONDING FIELDS OF TABLE lt_zabsf_pp054
       FOR ALL ENTRIES IN lt_marc
     WHERE dispo EQ lt_marc-dispo
       AND spras EQ sy-langu.

*  Get stocks of all warehouse
    SELECT *
      FROM zabsf_pp035
      INTO CORRESPONDING FIELDS OF TABLE lt_zabsf_pp035
       FOR ALL ENTRIES IN lt_zabsf_pp038
     WHERE areaid EQ lt_zabsf_pp038-areaid
       AND matnr  EQ lt_zabsf_pp038-matnr.

*   Get limits for warehouse and material
    SELECT *
      FROM zabsf_pp041
      INTO CORRESPONDING FIELDS OF TABLE lt_zabsf_pp041
       FOR ALL ENTRIES IN lt_zabsf_pp038
     WHERE areaid EQ inputobj-areaid
       AND werks  EQ inputobj-werks
       AND matnr  EQ lt_zabsf_pp038-matnr.

    LOOP AT lt_zabsf_pp038 INTO ls_zabsf_pp038.
      CLEAR ls_stocks.

*    Read material group
      READ TABLE lt_marc INTO ls_marc WITH KEY matnr = ls_zabsf_pp038-matnr.

      IF sy-subrc EQ 0.
*      Group material
        ls_stocks-dispo = ls_marc-dispo.

        READ TABLE lt_zabsf_pp054 INTO ls_zabsf_pp054 WITH KEY dispo = ls_stocks-dispo.

        IF sy-subrc EQ 0.
*        Group material description
          ls_stocks-grpdesc = ls_zabsf_pp054-grpdesc.
        ENDIF.
      ENDIF.

*    Material
      ls_stocks-matnr = ls_zabsf_pp038-matnr.
*    Material description
      READ TABLE lt_makt INTO ls_makt WITH KEY matnr = ls_zabsf_pp038-matnr.

      IF sy-subrc EQ 0.
        ls_stocks-maktx = ls_makt-maktx.
      ENDIF.

*    Get stock of all warehouse
      LOOP AT lt_zabsf_pp035 INTO ls_zabsf_pp035 WHERE matnr EQ ls_zabsf_pp038-matnr.

*      Get limits
        READ TABLE lt_zabsf_pp041 INTO ls_zabsf_pp041 WITH KEY matnr  = ls_zabsf_pp035-matnr
                                                                 wareid = ls_zabsf_pp035-wareid.

        CASE ls_zabsf_pp035-wareid.
          WHEN 'PROD'.
            ls_stocks-wareqty_1 = ls_zabsf_pp035-stock.
            IF ls_zabsf_pp041-low_limit IS NOT INITIAL OR ls_zabsf_pp041-max_limit IS NOT INITIAL.
*            Get limits for stock
              ls_stocks-low_limit1 = ls_zabsf_pp041-low_limit.
              ls_stocks-max_limit1 = ls_zabsf_pp041-max_limit.
              ls_stocks-gmein = ls_zabsf_pp041-gmein.
            ENDIF.

*          Sum of stock all warehouse
            ADD ls_stocks-wareqty_1 TO ls_stocks-totarm.
          WHEN 'REVS'.
            ls_stocks-wareqty_2 = ls_zabsf_pp035-stock.
            IF ls_zabsf_pp041-low_limit IS NOT INITIAL OR ls_zabsf_pp041-max_limit IS NOT INITIAL.
*            Get limits for stock
              ls_stocks-low_limit2 = ls_zabsf_pp041-low_limit.
              ls_stocks-max_limit2 = ls_zabsf_pp041-max_limit.
              ls_stocks-gmein = ls_zabsf_pp041-gmein.
            ENDIF.

*          Sum of stock all warehouse
            ADD ls_stocks-wareqty_2 TO ls_stocks-totarm.
          WHEN 'SUPR'.
            ls_stocks-wareqty_3 = ls_zabsf_pp035-stock.

            IF ls_zabsf_pp041-low_limit IS NOT INITIAL OR ls_zabsf_pp041-max_limit IS NOT INITIAL.
*            Get limits for stock
              ls_stocks-low_limit3 = ls_zabsf_pp041-low_limit.
              ls_stocks-max_limit3 = ls_zabsf_pp041-max_limit.
              ls_stocks-gmein = ls_zabsf_pp041-gmein.
            ENDIF.

*          Sum of stock all warehouse
            ADD ls_stocks-wareqty_3 TO ls_stocks-totarm.
        ENDCASE.
      ENDLOOP.

      CLEAR ld_tot_max.

*    Cards
      ld_tot_max = ls_stocks-max_limit1 + ls_stocks-max_limit2 + ls_stocks-max_limit3.
      ls_stocks-cards = ld_tot_max - ls_stocks-totarm.

      CLEAR ls_zabsf_pp041.

      LOOP AT lt_zabsf_pp041 INTO ls_zabsf_pp041 WHERE matnr EQ ls_zabsf_pp038-matnr
                                                     AND ( wareid EQ 'TARM' OR wareid EQ 'TDEP' ).

        CASE ls_zabsf_pp041-wareid.
          WHEN 'TARM'.
            IF ls_zabsf_pp041-low_limit IS NOT INITIAL OR ls_zabsf_pp041-max_limit IS NOT INITIAL.
*            Get limits for stock
              ls_stocks-low_limarm = ls_zabsf_pp041-low_limit.
              ls_stocks-max_limarm = ls_zabsf_pp041-max_limit.
              ls_stocks-gmein = ls_zabsf_pp041-gmein.
            ENDIF.
          WHEN 'TDEP'.
            IF ls_zabsf_pp041-low_limit IS NOT INITIAL OR ls_zabsf_pp041-max_limit IS NOT INITIAL.
*            Get limits for stock
              ls_stocks-low_limdep = ls_zabsf_pp041-low_limit.
              ls_stocks-max_limdep = ls_zabsf_pp041-max_limit.
              ls_stocks-gmein = ls_zabsf_pp041-gmein.
            ENDIF.
        ENDCASE.
      ENDLOOP.

*    Get stock of warehouse sap
      LOOP AT lt_mard INTO ls_mard WHERE matnr EQ ls_zabsf_pp038-matnr.

*      Get limits
        READ TABLE lt_zabsf_pp041 INTO ls_zabsf_pp041 WITH KEY matnr  =  ls_mard-matnr
                                                                 wareid = ls_mard-lgort.
        CASE ls_mard-lgort.
          WHEN ld_lgort_col.
            ls_stocks-wareqty_4 = ls_mard-labst.

            IF ls_zabsf_pp041-low_limit IS NOT INITIAL OR ls_zabsf_pp041-max_limit IS NOT INITIAL.
*            Get limits for stock
              ls_stocks-low_limit4 = ls_zabsf_pp041-low_limit.
              ls_stocks-max_limit4 = ls_zabsf_pp041-max_limit.
              ls_stocks-gmein = ls_zabsf_pp041-gmein.
            ENDIF.

*          Sum of stock all warehouse sap
            ADD ls_stocks-wareqty_4 TO ls_stocks-totdep.
          WHEN ld_lgort_fin.
            ls_stocks-wareqty_5 = ls_mard-labst.

            IF ls_zabsf_pp041-low_limit IS NOT INITIAL OR ls_zabsf_pp041-max_limit IS NOT INITIAL.
*            Get limits for stock
              ls_stocks-low_limit5 = ls_zabsf_pp041-low_limit.
              ls_stocks-max_limit5 = ls_zabsf_pp041-max_limit.
              ls_stocks-gmein = ls_zabsf_pp041-gmein.
            ENDIF.

*          Sum of stock all warehouse sap
            ADD ls_stocks-wareqty_5 TO ls_stocks-totdep.
        ENDCASE.
      ENDLOOP.

      APPEND ls_stocks TO stocks_tab.
    ENDLOOP.

    DELETE stocks_tab WHERE wareqty_1 EQ 0
                        AND wareqty_2 EQ 0
                        AND wareqty_3 EQ 0
                        AND wareqty_4 EQ 0
                        AND wareqty_5 EQ 0
                        AND totarm    EQ 0
                        AND totdep    EQ 0
                        AND cards     EQ 0.

    SORT stocks_tab BY grpdesc.
  ELSE.
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '043'
        msgv1      = hname
      CHANGING
        return_tab = return_tab.
  ENDIF.
ENDMETHOD.


METHOD get_warehouses.
  DATA it_zabsf_pp039 TYPE TABLE OF zabsf_pp039.

  DATA wa_zabsf_pp039 TYPE zabsf_pp039.

  DATA ld_shiftid TYPE zabsf_pp_e_shiftid.

  FIELD-SYMBOLS <fs_ware> TYPE zabsf_pp_s_warehouse.

  REFRESH it_zabsf_pp039.

  CLEAR: wa_zabsf_pp039,
         ld_shiftid.

  TRANSLATE inputobj-oprid TO UPPER CASE. "CLS 16.06.2015
*Get shift witch operator is associated
  SELECT SINGLE shiftid
    FROM zabsf_pp052
    INTO ld_shiftid
   WHERE areaid EQ inputobj-areaid
     AND oprid EQ inputobj-oprid.

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

*Get sequence of warehouses
  SELECT *
    FROM zabsf_pp039
    INTO CORRESPONDING FIELDS OF TABLE it_zabsf_pp039
   WHERE areaid EQ inputobj-areaid
     AND werks EQ inputobj-werks.

*Get warehouse
  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE warehouse_tab
    FROM zabsf_pp025 AS zabsf_pp025
   INNER JOIN zabsf_pp025_t AS zabsf_pp025_t
      ON zabsf_pp025_t~areaid EQ zabsf_pp025~areaid
     AND zabsf_pp025_t~werks EQ zabsf_pp025~werks
     AND zabsf_pp025_t~wareid EQ zabsf_pp025~wareid
   WHERE zabsf_pp025~areaid EQ inputobj-areaid
     AND zabsf_pp025~werks EQ inputobj-werks.

  IF sy-subrc NE 0.
*  No warehouse found
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '036'
      CHANGING
        return_tab = return_tab.
  ELSE.

*  Fill the next warehouse
    LOOP AT warehouse_tab ASSIGNING <fs_ware>.
      READ TABLE it_zabsf_pp039 INTO wa_zabsf_pp039 WITH KEY wareid = <fs_ware>-wareid.

      IF sy-subrc EQ 0.
        <fs_ware>-ware_next = wa_zabsf_pp039-ware_next.
      ENDIF.
    ENDLOOP.

*  Operation completed successfully
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'S'
        msgno      = '013'
      CHANGING
        return_tab = return_tab.
  ENDIF.
ENDMETHOD.


METHOD get_warehouses_detail.
  DATA: it_zabsf_pp035 TYPE TABLE OF zabsf_pp035,
        it_zabsf_pp038 TYPE TABLE OF zabsf_pp038,
        it_makt        TYPE TABLE OF makt.

  DATA: wa_zabsf_pp035  TYPE zabsf_pp035,
        wa_wareh_detail TYPE zabsf_pp_s_wareh_detail,
        wa_makt         TYPE makt.

  DATA ld_shiftid TYPE zabsf_pp_e_shiftid.

  REFRESH: it_zabsf_pp035,
           it_zabsf_pp038,
           it_makt.

  CLEAR: wa_makt,
         ld_shiftid.

  TRANSLATE inputobj-oprid TO UPPER CASE. "CLS 16.06.2015
*Get shift witch operator is associated
  SELECT SINGLE shiftid
    FROM zabsf_pp052
    INTO ld_shiftid
   WHERE areaid EQ inputobj-areaid
     AND oprid EQ inputobj-oprid.

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

*Get warehouses
  CALL METHOD me->get_warehouses
    CHANGING
      warehouse_tab = warehouse_tab
      return_tab    = return_tab.

  IF matnr IS INITIAL.
*  Get material of hierarchy
    SELECT *
      FROM zabsf_pp038
      INTO CORRESPONDING FIELDS OF TABLE it_zabsf_pp038
     WHERE areaid EQ inputobj-areaid
       AND werks  EQ inputobj-werks
*       AND wareid EQ wareid
       AND hname  EQ hname.

    IF it_zabsf_pp038[] IS NOT INITIAL.
*    Get quantity save of warehouse
      SELECT *
        FROM zabsf_pp035
        INTO CORRESPONDING FIELDS OF TABLE it_zabsf_pp035
         FOR ALL ENTRIES IN it_zabsf_pp038
       WHERE areaid EQ inputobj-areaid
         AND wareid EQ wareid
         AND matnr  EQ it_zabsf_pp038-matnr.
    ENDIF.
  ELSE.
*  Get material of hierarchy
    SELECT *
      FROM zabsf_pp038
      INTO CORRESPONDING FIELDS OF TABLE it_zabsf_pp038
     WHERE areaid EQ inputobj-areaid
       AND werks  EQ inputobj-werks
*       AND wareid EQ wareid
       AND matnr  EQ matnr
       AND hname  EQ hname.

    IF it_zabsf_pp038[] IS NOT INITIAL.
*    Get quantity save of warehouse
      SELECT *
        FROM zabsf_pp035
        INTO CORRESPONDING FIELDS OF TABLE it_zabsf_pp035
         FOR ALL ENTRIES IN it_zabsf_pp038
       WHERE areaid EQ inputobj-areaid
         AND wareid EQ wareid
         AND matnr  EQ it_zabsf_pp038-matnr.
    ENDIF.
  ENDIF.

  IF sy-subrc EQ 0.
*  Get description of material
    SELECT *
      FROM makt
      INTO CORRESPONDING FIELDS OF TABLE it_makt
      FOR ALL ENTRIES IN it_zabsf_pp035
     WHERE matnr EQ it_zabsf_pp035-matnr.

    LOOP AT it_zabsf_pp035 INTO wa_zabsf_pp035.
      CLEAR wa_wareh_detail.

*    Material
      wa_wareh_detail-matnr = wa_zabsf_pp035-matnr.

*    Material description
      READ TABLE it_makt INTO wa_makt WITH KEY matnr = wa_zabsf_pp035-matnr.

      IF sy-subrc EQ 0.
        wa_wareh_detail-maktx = wa_makt-maktx.
      ENDIF.

*    Stock warehouse
      wa_wareh_detail-stock = wa_zabsf_pp035-stock.
*    Quantity
      wa_wareh_detail-lmnga = wa_zabsf_pp035-lmnga.
*    Unit
      wa_wareh_detail-gmein = wa_zabsf_pp035-gmein.

      APPEND wa_wareh_detail TO wareh_detail_tab.
    ENDLOOP.

    DELETE wareh_detail_tab WHERE stock EQ 0.
  ELSE.
*  Information: No workcenters found
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'I'
        msgno      = '018'
      CHANGING
        return_tab = return_tab.
  ENDIF.
ENDMETHOD.


METHOD set_quality_ware.

  DATA: wa_zabsf_pp035  TYPE zabsf_pp035,
        wa_zabsf_pp034  TYPE zabsf_pp034,
        wa_zabsf_pp036  TYPE zabsf_pp036,
        wa_zabsf_pp039  TYPE zabsf_pp039,
        ls_zabsf_pp057  TYPE zabsf_pp057,
        ls_rework       TYPE zabsf_pp_s_rework,
        ls_print_ware   TYPE zabsf_pp_s_ware_print,
        ld_ware_next    TYPE zabsf_pp_e_warenext,
        ld_ware_def     TYPE zabsf_pp_e_ware_defect,
        ld_total_conf   TYPE mengv13,
        ld_total_rework TYPE mengv13,
        lv_ok           TYPE c,
        ld_zcntrl       TYPE zabsf_pp_e_zcntrl.

  CLEAR: ld_total_rework,
         ld_total_conf,
         ls_rework,
         lv_ok.

  DATA: r_ware  TYPE RANGE OF zabsf_pp_e_wareid,
        wa_ware LIKE LINE OF r_ware.

  CLEAR: wa_zabsf_pp035,
         wa_zabsf_pp034,
         wa_zabsf_pp036,
         wa_zabsf_pp039,
         ls_zabsf_pp057,
         ls_rework,
         ld_total_conf,
         ld_ware_next,
         ld_ware_def,
         wa_ware.

*Select warehouse for save quantity of rework
  SELECT SINGLE ware_defect
    FROM zabsf_pp039
    INTO ld_ware_def
   WHERE areaid      EQ inputobj-areaid
     AND werks       EQ inputobj-werks
     AND wareid      EQ wareid
     AND ware_defect NE space.

*Get data of current warehouse
  SELECT SINGLE *
    FROM zabsf_pp035
    INTO CORRESPONDING FIELDS OF wa_zabsf_pp035
   WHERE areaid EQ inputobj-areaid
     AND wareid EQ wareid
     AND matnr  EQ matnr.

  IF sy-subrc EQ 0.
*  Sum all quantities (rework, scrap and good quantity)
*  Get total of rework
    LOOP AT rework_tab INTO ls_rework.
      ADD ls_rework-rework TO ld_total_rework.
    ENDLOOP.

    ld_total_conf = ld_total_rework + scrap_qty + lmnga.

    IF wa_zabsf_pp035-stock LT ld_total_conf.
*    No stock warehouse
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '040'
          msgv1      = wareid
        CHANGING
          return_tab = return_tab.
    ELSE.
      IF lmnga IS NOT INITIAL.
**    Get data of current warehouse
*        SELECT SINGLE *
*          FROM ZABSF_PP035
*          INTO CORRESPONDING FIELDS OF wa_ZABSF_PP035
*         WHERE areaid EQ inputobj-areaid
*           AND wareid EQ wareid
*           AND matnr  EQ matnr.

*      IF sy-subrc EQ 0.
*      Subtract quantity transfered in stock of warehouse
        SUBTRACT lmnga FROM wa_zabsf_pp035-stock.

        IF wa_zabsf_pp035-stock LT 0.
*        No stock warehouse
          CALL METHOD zabsf_pp_cl_log=>add_message
            EXPORTING
              msgty      = 'E'
              msgno      = '040'
              msgv1      = wareid
            CHANGING
              return_tab = return_tab.
        ELSE.

          UPDATE zabsf_pp035 FROM wa_zabsf_pp035.

          IF sy-subrc EQ 0.
*          Operation completed successfully
            CALL METHOD zabsf_pp_cl_log=>add_message
              EXPORTING
                msgty      = 'S'
                msgno      = '013'
              CHANGING
                return_tab = return_tab.
          ELSE.
*          Operation not completed successfully
            CALL METHOD zabsf_pp_cl_log=>add_message
              EXPORTING
                msgty      = 'E'
                msgno      = '012'
              CHANGING
                return_tab = return_tab.

            CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

          ENDIF.

*        Get next warehouse
          SELECT SINGLE ware_next
            FROM zabsf_pp039
            INTO ld_ware_next
           WHERE wareid EQ wareid.

          IF sy-subrc EQ 0.
            IF ld_ware_next EQ space.
*            Return quantity to final operation
*              wa_ZABSF_PP035-lmnga = lmnga.

*>>> PAP - Correcção - 20.05.2015
              ADD lmnga TO wa_zabsf_pp035-lmnga.
*<<< PAP - Correcção - 20.05.2015

              UPDATE zabsf_pp035 FROM wa_zabsf_pp035.

              IF sy-subrc EQ 0.
*              Operation completed successfully
                CALL METHOD zabsf_pp_cl_log=>add_message
                  EXPORTING
                    msgty      = 'S'
                    msgno      = '013'
                  CHANGING
                    return_tab = return_tab.
              ELSE.
*              Operation not completed successfully
                CALL METHOD zabsf_pp_cl_log=>add_message
                  EXPORTING
                    msgty      = 'E'
                    msgno      = '012'
                  CHANGING
                    return_tab = return_tab.

                CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
              ENDIF.
            ELSE.
              CLEAR wa_zabsf_pp035.
*            Add quantity to next warehouse
              SELECT SINGLE *
                FROM zabsf_pp035
                INTO CORRESPONDING FIELDS OF wa_zabsf_pp035
               WHERE areaid EQ inputobj-areaid
                 AND wareid EQ ld_ware_next
                 AND matnr  EQ matnr.

              IF sy-subrc EQ 0.
*              Update quantity
                ADD lmnga TO wa_zabsf_pp035-stock.

                UPDATE zabsf_pp035 FROM wa_zabsf_pp035.

                IF sy-subrc EQ 0.
*                Operation completed successfully
                  CALL METHOD zabsf_pp_cl_log=>add_message
                    EXPORTING
                      msgty      = 'S'
                      msgno      = '013'
                    CHANGING
                      return_tab = return_tab.
                ELSE.
*                Operation not completed successfully
                  CALL METHOD zabsf_pp_cl_log=>add_message
                    EXPORTING
                      msgty      = 'E'
                      msgno      = '012'
                    CHANGING
                      return_tab = return_tab.

                  CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
                ENDIF.
              ELSE.
*              Insert new line to next warehouse
                CLEAR wa_zabsf_pp035.
                wa_zabsf_pp035-areaid = inputobj-areaid.
                wa_zabsf_pp035-wareid = ld_ware_next.
                wa_zabsf_pp035-matnr = matnr.
                wa_zabsf_pp035-stock = lmnga.
                wa_zabsf_pp035-gmein = gmein.

                INSERT zabsf_pp035 FROM wa_zabsf_pp035.

                IF sy-subrc EQ 0.
*                Operation completed successfully
                  CALL METHOD zabsf_pp_cl_log=>add_message
                    EXPORTING
                      msgty      = 'S'
                      msgno      = '013'
                    CHANGING
                      return_tab = return_tab.
                ELSE.
*                Operation not completed successfully
                  CALL METHOD zabsf_pp_cl_log=>add_message
                    EXPORTING
                      msgty      = 'E'
                      msgno      = '012'
                    CHANGING
                      return_tab = return_tab.

                  CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
                ENDIF.
              ENDIF.
            ENDIF.
          ELSE.
*          No data found
            CALL METHOD zabsf_pp_cl_log=>add_message
              EXPORTING
                msgty      = 'E'
                msgno      = '039'
                msgv1      = wareid
              CHANGING
                return_tab = return_tab.
          ENDIF.
        ENDIF.
*      ELSE.
**        No data found
*        CALL METHOD ZABSF_PP_cl_log=>add_message
*          EXPORTING
*            msgty      = 'I'
*            msgno      = '038'
*            msgv1      = wareid
*          CHANGING
*            return_tab = return_tab.
*      ENDIF.

*      Saved regist of quantity good
        CLEAR: ls_zabsf_pp057,
               ld_zcntrl.

        SELECT SINGLE zcntrl
          FROM zabsf_pp039
          INTO ld_zcntrl
         WHERE wareid EQ wareid
           AND ware_next EQ ld_ware_next.

        IF sy-subrc EQ 0.
          ls_zabsf_pp057-areaid = inputobj-areaid.
          ls_zabsf_pp057-wareid = wareid.
          ls_zabsf_pp057-matnr = matnr.
          ls_zabsf_pp057-data = refdt.
          ls_zabsf_pp057-time = sy-uzeit.
          ls_zabsf_pp057-oprid = inputobj-oprid.
          ls_zabsf_pp057-lmnga = lmnga.
          ls_zabsf_pp057-gmein = gmein.
          ls_zabsf_pp057-zcntrl = ld_zcntrl.

          INSERT zabsf_pp057 FROM ls_zabsf_pp057.

          IF sy-subrc EQ 0.
*          Operation completed successfully
            CALL METHOD zabsf_pp_cl_log=>add_message
              EXPORTING
                msgty      = 'S'
                msgno      = '013'
              CHANGING
                return_tab = return_tab.
          ELSE.
*          Operation not completed successfully
            CALL METHOD zabsf_pp_cl_log=>add_message
              EXPORTING
                msgty      = 'E'
                msgno      = '012'
              CHANGING
                return_tab = return_tab.

            CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
          ENDIF.
        ELSE.
*        Operation not completed successfully
          CALL METHOD zabsf_pp_cl_log=>add_message
            EXPORTING
              msgty      = 'E'
              msgno      = '012'
            CHANGING
              return_tab = return_tab.
        ENDIF.
      ENDIF.

      IF scrap_qty IS NOT INITIAL AND grund IS NOT INITIAL.
        CLEAR wa_zabsf_pp035.

*      Get information of warehousee
        SELECT SINGLE *
          FROM zabsf_pp035
          INTO CORRESPONDING FIELDS OF wa_zabsf_pp035
         WHERE areaid EQ inputobj-areaid
           AND wareid EQ wareid
           AND matnr  EQ matnr.

        IF sy-subrc EQ 0.
          SUBTRACT scrap_qty FROM wa_zabsf_pp035-stock.

          IF wa_zabsf_pp035-stock LT 0.
*          No stock warehouse
            CALL METHOD zabsf_pp_cl_log=>add_message
              EXPORTING
                msgty      = 'E'
                msgno      = '040'
                msgv1      = wareid
              CHANGING
                return_tab = return_tab.
          ELSE.
            UPDATE zabsf_pp035 FROM wa_zabsf_pp035.

            IF sy-subrc EQ 0.
*            Operation completed successfully
              CALL METHOD zabsf_pp_cl_log=>add_message
                EXPORTING
                  msgty      = 'S'
                  msgno      = '013'
                CHANGING
                  return_tab = return_tab.
            ELSE.
*            Operation completed successfully
              CALL METHOD zabsf_pp_cl_log=>add_message
                EXPORTING
                  msgty      = 'E'
                  msgno      = '012'
                CHANGING
                  return_tab = return_tab.

              CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
            ENDIF.

**          Get information of scrap
*            SELECT SINGLE *
*              FROM ZABSF_PP034
*              INTO CORRESPONDING FIELDS OF wa_ZABSF_PP034
*              WHERE areaid EQ inputobj-areaid
*                AND wareid EQ wareid
*                AND matnr  EQ matnr
*                AND grund  EQ grund
*                AND data   EQ sy-datum
*                AND oprid  EQ inputobj-oprid.
*
*            IF sy-subrc EQ 0.
*              ADD scrap_qty TO wa_ZABSF_PP034-scrap_qty.
*
*              UPDATE ZABSF_PP034 FROM wa_ZABSF_PP034.
*
*              IF sy-subrc EQ 0.
**              Operation completed successfully
*                CALL METHOD ZABSF_PP_cl_log=>add_message
*                  EXPORTING
*                    msgty      = 'S'
*                    msgno      = '013'
*                  CHANGING
*                    return_tab = return_tab.
*              ELSE.
**              Operation not completed successfully
*                CALL METHOD ZABSF_PP_cl_log=>add_message
*                  EXPORTING
*                    msgty      = 'E'
*                    msgno      = '012'
*                  CHANGING
*                    return_tab = return_tab.
*
*                CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
*              ENDIF.
*            ELSE.

            CLEAR wa_zabsf_pp034.

            wa_zabsf_pp034-areaid = inputobj-areaid.
            wa_zabsf_pp034-wareid = wareid.
            wa_zabsf_pp034-matnr = matnr.
            wa_zabsf_pp034-grund = grund.
            wa_zabsf_pp034-scrap_qty = scrap_qty.
            wa_zabsf_pp034-gmein = gmein.
            wa_zabsf_pp034-data = refdt.
            wa_zabsf_pp034-time = sy-uzeit.
            wa_zabsf_pp034-oprid = inputobj-oprid.

            INSERT zabsf_pp034 FROM wa_zabsf_pp034.

            IF sy-subrc EQ 0.
*            Operation completed successfully
              CALL METHOD zabsf_pp_cl_log=>add_message
                EXPORTING
                  msgty      = 'S'
                  msgno      = '013'
                CHANGING
                  return_tab = return_tab.
            ELSE.
*            Operation not completed successfully
              CALL METHOD zabsf_pp_cl_log=>add_message
                EXPORTING
                  msgty      = 'E'
                  msgno      = '012'
                CHANGING
                  return_tab = return_tab.

              CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
            ENDIF.
*            ENDIF.

          ENDIF.
        ELSE.
*        No data found
          CALL METHOD zabsf_pp_cl_log=>add_message
            EXPORTING
              msgty      = 'I'
              msgno      = '038'
              msgv1      = wareid
            CHANGING
              return_tab = return_tab.
        ENDIF.
      ENDIF.

      IF rework_tab[] IS NOT INITIAL.
        CLEAR ls_rework.
        LOOP AT rework_tab INTO ls_rework.
          CLEAR wa_zabsf_pp036.

**        Get information of rework
*          SELECT SINGLE *
*            FROM ZABSF_PP036
*            INTO CORRESPONDING FIELDS OF wa_ZABSF_PP036
*           WHERE areaid    EQ inputobj-areaid
*             AND wareid    EQ wareid
*             AND matnr     EQ matnr
*             AND defectid  EQ ls_rework-defectid
*             AND data      EQ sy-datum
*             AND oprid     EQ inputobj-oprid.
*
*          IF sy-subrc EQ 0.
**          Update database with quantity of rework
*            ADD ls_rework-rework TO wa_ZABSF_PP036-rework.
*
*            UPDATE ZABSF_PP036 FROM wa_ZABSF_PP036.
*
*            IF sy-subrc EQ 0.
**            Operation completed successfully
*              CALL METHOD ZABSF_PP_cl_log=>add_message
*                EXPORTING
*                  msgty      = 'S'
*                  msgno      = '013'
*                CHANGING
*                  return_tab = return_tab.
*            ELSE.
**            Operation not completed successfully
*              CALL METHOD ZABSF_PP_cl_log=>add_message
*                EXPORTING
*                  msgty      = 'E'
*                  msgno      = '012'
*                CHANGING
*                  return_tab = return_tab.
*
*              CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
*            ENDIF.
*          ELSE.

*          Create new line in database
          wa_zabsf_pp036-areaid = inputobj-areaid.
          wa_zabsf_pp036-wareid = wareid.
          wa_zabsf_pp036-matnr = matnr.
          wa_zabsf_pp036-defectid = ls_rework-defectid.
          wa_zabsf_pp036-rework = ls_rework-rework.
          wa_zabsf_pp036-vorme = gmein.
          wa_zabsf_pp036-data = refdt.
          wa_zabsf_pp036-time = sy-uzeit.
          wa_zabsf_pp036-oprid = inputobj-oprid.

          INSERT zabsf_pp036 FROM wa_zabsf_pp036.

          IF sy-subrc EQ 0.
*            Operation completed successfully
            CALL METHOD zabsf_pp_cl_log=>add_message
              EXPORTING
                msgty      = 'S'
                msgno      = '013'
              CHANGING
                return_tab = return_tab.
          ELSE.
*            Operation not completed successfully
            CALL METHOD zabsf_pp_cl_log=>add_message
              EXPORTING
                msgty      = 'E'
                msgno      = '012'
              CHANGING
                return_tab = return_tab.

            CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
          ENDIF.
*          ENDIF.

*        Get information of warehouse for put quantity rework
          CLEAR wa_zabsf_pp035.

          SELECT SINGLE *
            FROM zabsf_pp035
            INTO CORRESPONDING FIELDS OF wa_zabsf_pp035
           WHERE areaid EQ inputobj-areaid
             AND wareid EQ ld_ware_def
             AND matnr  EQ matnr.

          IF sy-subrc EQ 0.
*          Update stock quantity in first warehouse with quantity of rework
            ADD ls_rework-rework TO wa_zabsf_pp035-stock.

            UPDATE zabsf_pp035 FROM wa_zabsf_pp035.

            IF sy-subrc EQ 0.
*            Operation completed successfully
              CALL METHOD zabsf_pp_cl_log=>add_message
                EXPORTING
                  msgty      = 'S'
                  msgno      = '013'
                CHANGING
                  return_tab = return_tab.
            ELSE.
              lv_ok = 'X'.
*            Operation not completed successfully
              CALL METHOD zabsf_pp_cl_log=>add_message
                EXPORTING
                  msgty      = 'E'
                  msgno      = '012'
                CHANGING
                  return_tab = return_tab.

              CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
            ENDIF.
          ELSE.
*          Insert new line for quantity rework
            CLEAR wa_zabsf_pp035.
            wa_zabsf_pp035-areaid = inputobj-areaid.
            wa_zabsf_pp035-wareid = ld_ware_def.
            wa_zabsf_pp035-matnr = matnr.
            wa_zabsf_pp035-stock = ls_rework-rework.
            wa_zabsf_pp035-gmein = gmein.

            INSERT zabsf_pp035 FROM wa_zabsf_pp035.

            IF sy-subrc EQ 0.
*            Operation completed successfully
              CALL METHOD zabsf_pp_cl_log=>add_message
                EXPORTING
                  msgty      = 'S'
                  msgno      = '013'
                CHANGING
                  return_tab = return_tab.
            ELSE.
              lv_ok = 'X'.
*            Operation not completed successfully
              CALL METHOD zabsf_pp_cl_log=>add_message
                EXPORTING
                  msgty      = 'E'
                  msgno      = '012'
                CHANGING
                  return_tab = return_tab.

              CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
            ENDIF.
          ENDIF.

          IF lv_ok IS INITIAL.
            CLEAR wa_zabsf_pp035.

            SELECT SINGLE *
              FROM zabsf_pp035
              INTO CORRESPONDING FIELDS OF wa_zabsf_pp035
             WHERE areaid EQ inputobj-areaid
               AND wareid EQ wareid
               AND matnr  EQ matnr.

            IF sy-subrc EQ 0.
              SUBTRACT ls_rework-rework FROM wa_zabsf_pp035-stock.

              IF wa_zabsf_pp035-stock LT 0.
*              No stock warehouse
                CALL METHOD zabsf_pp_cl_log=>add_message
                  EXPORTING
                    msgty      = 'E'
                    msgno      = '040'
                    msgv1      = wareid
                  CHANGING
                    return_tab = return_tab.
              ELSE.
                UPDATE zabsf_pp035 FROM wa_zabsf_pp035.

                IF sy-subrc EQ 0.
*                Operation completed successfully
                  CALL METHOD zabsf_pp_cl_log=>add_message
                    EXPORTING
                      msgty      = 'S'
                      msgno      = '013'
                    CHANGING
                      return_tab = return_tab.
                ELSE.
*                Operation completed successfully
                  CALL METHOD zabsf_pp_cl_log=>add_message
                    EXPORTING
                      msgty      = 'E'
                      msgno      = '012'
                    CHANGING
                      return_tab = return_tab.

                  CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDIF.


      CLEAR ls_print_ware.

      ls_print_ware-wareid = wareid.
      ls_print_ware-matnr = matnr.
      ls_print_ware-lmnga = lmnga.

      MOVE rework_tab TO ls_print_ware-rework_tab.

*    Print layout
      CALL FUNCTION 'ZABSF_PP_PRINT'
        EXPORTING
          ware_print_st = ls_print_ware
          refdt         = refdt
          inputobj      = inputobj
        IMPORTING
          return_tab    = return_tab.

    ENDIF.
  ELSE.
*  No data found
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'I'
        msgno      = '038'
        msgv1      = wareid
      CHANGING
        return_tab = return_tab.
  ENDIF.
ENDMETHOD.


METHOD SET_REFDT.

*Set new reference date
  refdt = new_refdt.

  ENDMETHOD.
ENDCLASS.
