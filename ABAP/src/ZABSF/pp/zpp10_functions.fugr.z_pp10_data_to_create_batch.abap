FUNCTION z_pp10_data_to_create_batch.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IV_FIRST_CYCLE) TYPE  FLAG OPTIONAL
*"     REFERENCE(IV_SHIFTID) TYPE  ZABSF_PP_E_SHIFTID OPTIONAL
*"     REFERENCE(IS_INPUTOBJECT) TYPE  ZABSF_PP_S_INPUTOBJECT OPTIONAL
*"     REFERENCE(IV_REFDT) TYPE  VVDATUM OPTIONAL
*"     REFERENCE(IT_GOODMOVEMENTS) TYPE  ZABSF_PP_T_GOODMOVEMENTS
*"  EXPORTING
*"     REFERENCE(EV_NEW_BATCH) TYPE  CHARG_D
*"  TABLES
*"      RETURN_TAB STRUCTURE  BAPIRET2
*"----------------------------------------------------------------------
*Internal tables
  DATA: lt_return     TYPE TABLE OF bapiret2,
        lt_return_tab TYPE bapiret2_t.

*Structures
  DATA: ls_goodmovements TYPE zabsf_pp_s_goodmovements,
        ls_batch         TYPE zabsf_batch,
        ls_batch_cons    TYPE zabsf_pp_s_batch_consumption,
        ls_inputobj      TYPE zabsf_pp_s_inputobject,
        ls_return        TYPE bapiret2,
        ls_arbpl_print   TYPE zabsf_pp_s_arbpl_print,
        ls_zabsf_pp066   TYPE zabsf_pp066.

*References
  DATA: lref_sf_prodord    TYPE REF TO zabsf_pp_cl_prdord,
        lref_sf_batch_oper TYPE REF TO zabsf_pp_cl_batch_operations.

*Variables
  DATA: l_new_charg    TYPE charg_d,
        l_refdt        TYPE vvdatum,
        l_source_value TYPE i,
        l_boxqty       TYPE zabsf_pp_e_boxqty,
        l_msgv1        TYPE symsgv,
        l_msgv2        TYPE symsgv,
        l_equnr        TYPE equnr,
        l_ktx01        TYPE ktx01.

*Constants
  CONSTANTS: c_objty      TYPE cr_objty VALUE 'A',    "Work Center
             c_bwart_101  TYPE bwart    VALUE '101',  "GR goods receipt
             c_bwart_261  TYPE bwart    VALUE '261',  "GR goods receipt
             c_mtart_halb TYPE mtart    VALUE 'HALB', "Material type
             c_mtart_fert TYPE mtart    VALUE 'FERT', "Material type
             c_mtart_roh  TYPE mtart    VALUE 'ROH',  "Material type
             c_matkl_050  TYPE matkl    VALUE '050',  "Material grupo
             c_matkl_001  TYPE matkl    VALUE '001',  "Material grupo
             c_matkl_100  TYPE matkl    VALUE '100',  "Material grupo
             c_auart      TYPE aufart   VALUE 'ZTMP'. "Order type - Temporary order

*Reference date
  IF iv_refdt IS NOT INITIAL.
    l_refdt = iv_refdt.
  ELSE.
    l_refdt = sy-datlo.
  ENDIF.

  LOOP AT it_goodmovements INTO ls_goodmovements WHERE bwart EQ c_bwart_101.
*  Get work center
    SELECT SINGLE crhd~arbpl
      FROM afvc AS afvc
     INNER JOIN crhd AS crhd
        ON crhd~objid EQ afvc~arbid
     WHERE afvc~aufpl EQ @ls_goodmovements-aufpl
       AND afvc~aplzl EQ @ls_goodmovements-aplzl
       AND crhd~objty EQ @c_objty
      INTO (@DATA(l_arbpl)).

    IF ls_goodmovements-charg IS INITIAL.
*    Check if object was created
      IF lref_sf_prodord IS NOT BOUND.
        CREATE OBJECT lref_sf_prodord
          EXPORTING
            initial_refdt = l_refdt
            input_object  = ls_inputobj.
      ENDIF.

*    Quantity
      l_source_value = ls_goodmovements-erfmg.

*    Get box quantity of batch
*      CALL METHOD lref_sf_prodord->get_qty_box
*        EXPORTING
*          matnr        = ls_goodmovements-matnr
*          source_value = l_source_value
*          lmnga        = ls_goodmovements-erfmg
*          gmein        = ls_goodmovements-erfme
*          aufpl        = ls_goodmovements-aufpl
*          aplzl        = ls_goodmovements-aplzl
*        CHANGING
*          boxqty       = l_boxqty.
*
*      IF ls_goodmovements-erfmg GT l_boxqty.
*        CLEAR ls_return.
**        Quantity above box capacity to create
**          MESSAGE e080(zlp_pp_shopfloor) WITH ls_goodmovements-charg INTO DATA(l_error).
*        CALL METHOD zabsf_pp_cl_log=>add_message
*          EXPORTING
*            msgty      = 'E'
*            msgno      = '086'
*          CHANGING
*            return_tab = lt_return_tab.
*
*        MOVE lt_return_tab[] TO return_tab[].
*
*        EXIT.
*      ENDIF.

*    Material
      ls_batch-matnr = ls_goodmovements-matnr.
*    Plant
      ls_batch-werks = ls_goodmovements-werks.
*    Work Center
      ls_batch-arbpl = l_arbpl.
*    Production Date
      ls_batch-hsdat = ls_goodmovements-hsdat.

*    Get batch consumption
      LOOP AT it_goodmovements INTO DATA(ls_goodmvt_261) WHERE bwart EQ c_bwart_261
                                                           AND charg IS NOT INITIAL.

*      Check material group and
        SELECT SINGLE mandt
          FROM mara
          INTO (@DATA(l_mandt))
         WHERE matnr EQ @ls_goodmvt_261-matnr
           AND ( ( mtart EQ @c_mtart_halb AND
                  matkl EQ @c_matkl_050 )
            OR (  mtart EQ @c_mtart_fert AND
                  matkl EQ @c_matkl_001 ) ) .

        IF sy-subrc EQ 0.
*        Batch Consumption
          ls_batch_cons-charg = ls_goodmvt_261-charg.
*        Material Consumption
          ls_batch_cons-matnr = ls_goodmvt_261-matnr.
*        Plant
          ls_batch_cons-werks = ls_goodmvt_261-werks.
*        Relevant for inheritance
          ls_batch_cons-inheritance = abap_true.


          APPEND ls_batch_cons TO ls_batch-charg_t.
        ENDIF.

        CLEAR l_mandt.

*      Check material group and
        SELECT SINGLE mandt
          FROM mara
          INTO (@l_mandt)
         WHERE matnr EQ @ls_goodmvt_261-matnr
           AND mtart EQ @c_mtart_roh
           AND matkl EQ @c_matkl_100.

        IF sy-subrc EQ 0.
*        Batch Consumption
          ls_batch_cons-charg = ls_goodmvt_261-charg.
*        Material Consumption
          ls_batch_cons-matnr = ls_goodmvt_261-matnr.
*        Plant
          ls_batch_cons-werks = ls_goodmvt_261-werks.

          APPEND ls_batch_cons TO ls_batch-charg_t.
        ENDIF.
      ENDLOOP.

*    Production Order
      ls_batch-aufnr = ls_goodmovements-aufnr.

*    Shift
      IF iv_shiftid IS NOT INITIAL.
        ls_batch-kaptprog = iv_shiftid.

*      Get operator
        SELECT SINGLE oprid
          FROM zabsf_pp014
          INTO (@DATA(l_oprid))
         WHERE aufnr EQ @ls_goodmovements-aufnr
           AND vornr EQ @ls_goodmovements-vornr
           AND arbpl EQ @l_arbpl.
      ELSE.
        CLEAR l_oprid.

*      Get operator and shift
        SELECT SINGLE sf014~oprid, sf052~shiftid
          FROM zabsf_pp014 AS sf014
         INNER JOIN zabsf_pp052 AS sf052
            ON sf052~oprid EQ sf014~oprid
         WHERE sf014~aufnr EQ @ls_goodmovements-aufnr
           AND sf014~vornr EQ @ls_goodmovements-vornr
           AND sf014~arbpl EQ @l_arbpl
          INTO (@l_oprid, @DATA(l_shiftid)).

        ls_batch-kaptprog = l_shiftid.
      ENDIF.

*    Operator
      ls_batch-pernr = l_oprid.

*    Valuation type
      ls_batch-bwtar = ls_goodmovements-bwtar.

*    Get Equipment Description - Mould
*      CALL FUNCTION 'Z_PP10_GET_MOULD'
*        EXPORTING
*          iv_aufpl = ls_goodmovements-aufpl
*          iv_aplzl = ls_goodmovements-aplzl
*          iv_werks = ls_goodmovements-werks
*        IMPORTING
*          ev_equnr = l_equnr
*          ev_eqktx = l_ktx01.

      ls_batch-eqktx = l_equnr.

*    Create batch
      CALL FUNCTION 'Z_PP10_CREATE_BATCH'
        EXPORTING
          is_batch     = ls_batch
        IMPORTING
          ev_new_charg = l_new_charg
        TABLES
          return_tab   = lt_return.

      IF l_new_charg IS NOT INITIAL.
*      Batch created
*        ls_goodmovements-charg = l_new_charg.
        ev_new_batch = l_new_charg.

*      Get operation of Production order
        SELECT SINGLE vornr
          FROM afvc
          INTO (@DATA(l_vornr))
         WHERE aufpl EQ @ls_goodmovements-aufpl
           AND aplzl EQ @ls_goodmovements-aplzl.

*      Check if exist record save in table ZLP_PP_SF066 - Batch management
        SELECT SINGLE *
          FROM zabsf_pp066
          INTO @DATA(ls_batch_manag)
         WHERE werks EQ @ls_goodmovements-werks
           AND aufnr EQ @ls_goodmovements-aufnr
           AND vornr EQ @l_vornr.

        IF sy-subrc EQ 0.
*        Update exist recond in table with new batch active
*          UPDATE zabsf_pp066 FROM @( VALUE #( BASE ls_batch_manag batch = l_new_charg ) ).

          ls_batch_manag-batch = l_new_charg.
          UPDATE zabsf_pp066 FROM ls_batch_manag.
          COMMIT WORK AND WAIT.

        ELSE.
*        Insert new record with batch active for production order
*          INSERT zabsf_pp066 FROM TABLE @( VALUE #( ( werks = ls_goodmovements-werks
*                                                       aufnr = ls_goodmovements-aufnr
*                                                       vornr = l_vornr
*                                                       batch = l_new_charg ) ) ).
          ls_zabsf_pp066-werks = ls_goodmovements-werks.
          ls_zabsf_pp066-aufnr = ls_goodmovements-aufnr.
          ls_zabsf_pp066-vornr = l_vornr.
          ls_zabsf_pp066-batch = l_new_charg.
          INSERT INTO zabsf_pp066 VALUES ls_zabsf_pp066.

          COMMIT WORK AND WAIT.
        ENDIF.

        IF ls_goodmovements-erfmg EQ l_boxqty.
*        Data to print
          ls_arbpl_print-arbpl = l_arbpl.
          ls_arbpl_print-aufnr = ls_goodmovements-aufnr.
          ls_arbpl_print-matnr = ls_goodmovements-matnr.
          ls_arbpl_print-vornr = ls_goodmovements-vornr.

*        First cycle
          IF iv_first_cycle IS NOT INITIAL.
            ls_arbpl_print-first_cycle = iv_first_cycle.
          ENDIF.

*        Input data
          IF is_inputobject IS INITIAL.
*          Plant
            ls_inputobj-werks = ls_goodmovements-werks.
          ELSE.
            MOVE-CORRESPONDING is_inputobject TO ls_inputobj.
          ENDIF.

*        Create object.
          IF lref_sf_batch_oper IS NOT BOUND.
            CREATE OBJECT lref_sf_batch_oper
              EXPORTING
                initial_refdt  = l_refdt
                input_object   = ls_inputobj
                input_print_st = ls_arbpl_print.
          ENDIF.

*        Close Box
          CALL METHOD lref_sf_batch_oper->close_batch
            EXPORTING
              erfmg      = ls_goodmovements-erfmg
              shiftid    = ls_batch-kaptprog
            CHANGING
              return_tab = lt_return_tab.


          MOVE lt_return_tab[] TO return_tab[].
          EXIT.
        ENDIF.

      ELSE.
        IF lt_return[] IS NOT INITIAL AND l_new_charg IS INITIAL.
*        Send message error
          MOVE lt_return[] TO return_tab[].
        ELSEIF lt_return[] IS NOT INITIAL.
*        No batch created
          CALL METHOD zabsf_pp_cl_log=>add_message
            EXPORTING
              msgty      = 'E'
              msgno      = '081'
            CHANGING
              return_tab = lt_return_tab.

          MOVE lt_return_tab[] TO return_tab[].

          EXIT.
        ENDIF.
      ENDIF.
    ELSE.
*    Get order type
      SELECT SINGLE auart
        FROM aufk
        INTO (@DATA(l_auart))
       WHERE aufnr EQ @ls_goodmovements-aufnr.

      IF l_auart NE c_auart.
*      Check quantity confirmed
        SELECT SINGLE cinsm, clabs
          FROM mchb
          INTO (@DATA(l_cinsm),@DATA(l_clabs))
         WHERE matnr EQ @ls_goodmovements-matnr
           AND werks EQ @ls_goodmovements-werks
           AND lgort EQ @ls_goodmovements-lgort
           AND charg EQ @ls_goodmovements-charg.

        IF sy-subrc EQ 0.
*        Stock quantity of Batch
          DATA(l_stock) = l_cinsm + l_clabs.

*        Create object to get box quantity
          IF lref_sf_prodord IS NOT BOUND.
            CREATE OBJECT lref_sf_prodord
              EXPORTING
                initial_refdt = l_refdt
                input_object  = ls_inputobj.
          ENDIF.

*        Quantity
          l_source_value = ls_goodmovements-erfmg.

**        Get box quantity of batch
*          CALL METHOD lref_sf_prodord->get_qty_box
*            EXPORTING
*              matnr        = ls_goodmovements-matnr
*              source_value = l_source_value
*              lmnga        = ls_goodmovements-erfmg
*              gmein        = ls_goodmovements-erfme
*              aufpl        = ls_goodmovements-aufpl
*              aplzl        = ls_goodmovements-aplzl
*            CHANGING
*              boxqty       = l_boxqty.
*
**        Check quantity to confirm
*          DATA(l_qty_avail) = l_boxqty - l_stock.

*          IF ls_goodmovements-erfmg GT l_qty_avail.
*            CLEAR ls_return.
*
**         Quantity above box capacity (lote: &)
**          MESSAGE e080(zlp_pp_shopfloor) WITH ls_goodmovements-charg INTO DATA(l_error).
*
*            l_msgv1 = l_qty_avail.
*            CONDENSE l_msgv1.
*
*            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*              EXPORTING
*                input  = ls_goodmovements-charg
*              IMPORTING
*                output = l_msgv2.
*
*
*            CALL METHOD zabsf_pp_cl_log=>add_message
*              EXPORTING
*                msgty      = 'E'
*                msgno      = '080'
*                msgv1      = l_msgv1
*                msgv2      = l_msgv2
*              CHANGING
*                return_tab = lt_return_tab.
*
*            MOVE lt_return_tab[] TO return_tab[].
*
*            EXIT.
*          ENDIF.

*        Print label
          IF ( l_stock + ls_goodmovements-erfmg ) EQ l_boxqty.
*          Data to print
            ls_arbpl_print-arbpl = l_arbpl.
            ls_arbpl_print-aufnr = ls_goodmovements-aufnr.
            ls_arbpl_print-matnr = ls_goodmovements-matnr.
            ls_arbpl_print-vornr = ls_goodmovements-vornr.

*          Input data
            IF is_inputobject IS INITIAL.
*            Plant
              ls_inputobj-werks = ls_goodmovements-werks.
            ELSE.
              MOVE-CORRESPONDING is_inputobject TO ls_inputobj.
            ENDIF.

            IF lref_sf_batch_oper IS NOT BOUND.
              CREATE OBJECT lref_sf_batch_oper
                EXPORTING
                  initial_refdt  = l_refdt
                  input_object   = ls_inputobj
                  input_print_st = ls_arbpl_print.
            ENDIF.

*          Close Box
            CALL METHOD lref_sf_batch_oper->close_batch
              EXPORTING
                erfmg      = ls_goodmovements-erfmg
              CHANGING
                return_tab = lt_return_tab.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.
ENDFUNCTION.
