*&---------------------------------------------------------------------*
*&  Include          Z_LP_PP_SF_CONSUMPTIONS_CHGF01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  INIT_VARIABLES
*&---------------------------------------------------------------------*
FORM init_variables .
  REFRESH gt_alv.
ENDFORM.                    " INIT_VARIABLES


*&---------------------------------------------------------------------*
*&      Form  GET_CONSUMPTIONS
*&---------------------------------------------------------------------*
FORM get_consumptions.
  DATA:
    lt_cellcol  TYPE lvc_t_scol.
  DATA lw_cellcol TYPE lvc_s_scol.
  DATA l_menge TYPE aufm-menge.
  DATA l_tolerance TYPE kbetr.
  DATA l_cust_tolerance TYPE kbetr.

  REFRESH: lt_consumpt.
*Get Consumptions to Correct
  SELECT a~werks, a~data, a~shiftid, a~aufnr, a~ficha,
         a~matnr, b~maktx, a~batch, a~verme, a~status_cons,
         a~ernam, a~erdat
    FROM zabsf_pp076 AS a
    LEFT JOIN makt AS b
          ON a~matnr = b~matnr AND
             b~spras = @sy-langu
    INTO CORRESPONDING FIELDS OF TABLE @lt_consumpt
   WHERE a~werks   EQ @p_werks
     AND a~data    IN @s_data
     AND a~shiftid IN @s_shift
     AND a~aufnr   IN @s_aufnr
     AND a~ficha   IN @s_ficha
     AND a~status_cons EQ @c_stat_p.

* Fill ALV
  MOVE-CORRESPONDING lt_consumpt[] TO gt_alv[].

  IF NOT gt_alv[] IS INITIAL.
    SELECT aufnr, bwtar, charg, shkzg, menge
      FROM aufm
   INTO TABLE @DATA(lt_total)
   FOR ALL ENTRIES IN @gt_alv[]
   WHERE aufnr = @gt_alv-aufnr
     AND bwart IN ('961', '261','962','262').

  ENDIF.




  LOOP AT gt_alv ASSIGNING FIELD-SYMBOL(<fs_alv>).

    CLEAR l_menge.
    LOOP AT lt_total INTO DATA(lw_total) WHERE
        aufnr = <fs_alv>-aufnr AND charg = <fs_alv>-batch.
      CASE lw_total-shkzg.
        WHEN 'H'.
          lw_total-menge = lw_total-menge.
        WHEN 'S'.
          lw_total-menge = lw_total-menge * -1.
      ENDCASE.
      l_menge = l_menge +  lw_total-menge.

    ENDLOOP.

    CLEAR l_cust_tolerance.
    PERFORM get_customizing_tolerance USING <fs_alv>
                                      CHANGING l_cust_tolerance.


    CLEAR l_tolerance.
    IF l_menge > 0.
      l_tolerance =  ( <fs_alv>-verme / l_menge ) * 100.
    ELSE.
      l_tolerance = 100.
    ENDIF.

    CHECK l_tolerance > l_cust_tolerance.
    MOVE TEXT-b04 TO <fs_alv>-log.
    MOVE icon_red_light  TO <fs_alv>-icon.
    lw_cellcol-fname = 'LOG'.
    lw_cellcol-color-col = '6'.
    lw_cellcol-color-int = '0'.
    APPEND lw_cellcol TO <fs_alv>-color.
  ENDLOOP.


ENDFORM.                    " GET_CONSUMPTIONS


*&---------------------------------------------------------------------*
*&      Form  SAVE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM save_data .

  "  DATA lref_sf_consumptions TYPE REF TO zcl_lp_pp_sf_consumptions.
  DATA: ls_components_st TYPE zabsf_pp_s_components,
        refdt            TYPE vvdatum,
        inputobj         TYPE zabsf_pp_s_inputobject,
        return_tab       TYPE bapiret2_t.



** Deleted
  LOOP AT gt_alv INTO DATA(ls_alv_d)
                 WHERE status_cons = c_stat_d.

    CLEAR ls_lp_pp_sf076.
    MOVE-CORRESPONDING ls_alv_d TO ls_lp_pp_sf076.

*    UPDATE zabsf_pp076 FROM @( VALUE #( BASE ls_lp_pp_sf076
*                                              status_cons = c_stat_d
*                                              aenam = sy-uname
*                                              aedat = sy-datum
*                                              ) ).

    ls_lp_pp_sf076-status_cons = c_stat_d.
    ls_lp_pp_sf076-aenam = sy-uname.
    ls_lp_pp_sf076-aedat = sy-datum.
    UPDATE zabsf_pp076 FROM ls_lp_pp_sf076.

    IF ( sy-subrc EQ 0 ).
      COMMIT WORK AND WAIT.
    ENDIF.
  ENDLOOP.


** Completed
  LOOP AT gt_alv INTO DATA(ls_alv_c)
                 WHERE status_cons = c_stat_c.


*    Create object
    inputobj-werks = ls_alv_c-werks.

**  Fill Component
    SELECT SINGLE meins
      FROM mara
      INTO @DATA(l_meins)
      WHERE matnr = @ls_alv_c-matnr.

    CLEAR ls_components_st.
    ls_components_st-matnr = ls_alv_c-matnr.
    ls_components_st-maktx = ls_alv_c-maktx.
    ls_components_st-consqty = ls_alv_c-verme.
    ls_components_st-meins = l_meins.
    ls_components_st-batch = ls_alv_c-batch.

** Shopfloor - Consumptions Goods Movements
    CALL FUNCTION 'ZABSF_PP_SETGOODSMVT'
      EXPORTING
        aufnr         = ls_alv_c-aufnr
        components_st = ls_components_st
*       REFDT         = SY-DATUM
        inputobj      = inputobj
      IMPORTING
        return_tab    = return_tab.

    LOOP AT return_tab INTO DATA(ls_err) WHERE type = 'E'.
      CONTINUE.
    ENDLOOP.

*    IF ( lref_sf_consumptions IS NOT BOUND ).
**    Create object
*      inputobj-werks = ls_alv_c-werks.
*      CREATE OBJECT lref_sf_consumptions
*        EXPORTING
*          initial_refdt = refdt
*          input_object  = inputobj.
*    ENDIF.
*
*    SELECT SINGLE meins
*      FROM mara
*      INTO @DATA(l_meins)
*      WHERE matnr = @ls_alv_c-matnr.
*
*    CLEAR components_st.
*    components_st-matnr = ls_alv_c-matnr.
*    components_st-maktx = ls_alv_c-maktx.
*    components_st-consqty = ls_alv_c-verme.
*    components_st-meins = l_meins.
*    components_st-batch = ls_alv_c-batch.
*
*    lref_sf_consumptions->zif_lp_pp_sf_consumptions~create_consum_order(
*      EXPORTING
*        aufnr         = ls_alv_c-aufnr
*        components_st = components_st
*      CHANGING
*        return_tab    = return_tab ).


*    CLEAR ls_lp_pp_sf076.
*    MOVE-CORRESPONDING ls_alv_c TO ls_lp_pp_sf076.
*
*    UPDATE ZABSF_PP076 FROM @( VALUE #( BASE ls_lp_pp_sf076
*                                              status_cons = c_stat_c
*                                              aenam = sy-uname
*                                              aedat = sy-datum
*                                              ) ).
*    IF ( sy-subrc EQ 0 ).
*      COMMIT WORK AND WAIT.
*    ENDIF.
  ENDLOOP.

*  MESSAGE TEXT-012 TYPE 'I'.
  LEAVE TO SCREEN 0.

ENDFORM.



*&---------------------------------------------------------------------*
*&      Form  CREATE_F4_FIELD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_C_WARE  text
*      -->P_C_VORG  text
*      -->P_C_WARE_DYN  text
*      -->P_SO_WARE  text
*      -->P_IT_WARE  text
*----------------------------------------------------------------------*
FORM create_f4_field USING p_retfield p_val_org p_dyn_field
                           so_option p_it
                     TYPE STANDARD TABLE.

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

ENDFORM.                    " CREATE_F4_FIELD
*&---------------------------------------------------------------------*
*&      Form  HANDLE_TOOLBAR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_E_OBJECT  text
*      -->P_E_INTERACTIVE  text
*----------------------------------------------------------------------*
FORM handle_toolbar  USING e_object TYPE REF TO cl_alv_event_toolbar_set
                           e_interactive TYPE c.


  DATA: ls_toolbar TYPE stb_button.
*  refresh e_object->mt_toolbar.

  CLEAR ls_toolbar.
  ls_toolbar-function  = 'DUMMY'.
  ls_toolbar-butn_type = '3'.
  APPEND ls_toolbar TO e_object->mt_toolbar.

  CLEAR ls_toolbar.
  ls_toolbar-function  = 'CHANGE'.
  ls_toolbar-butn_type = '0'.
  ls_toolbar-disabled  = space.
  ls_toolbar-icon      = icon_change.
  ls_toolbar-text      = TEXT-b03.
  ls_toolbar-quickinfo = TEXT-b03.
  ls_toolbar-checked   = space.
  APPEND ls_toolbar TO e_object->mt_toolbar.

  CLEAR ls_toolbar.
  ls_toolbar-function  = 'DUMMY'.
  ls_toolbar-butn_type = '3'.
  APPEND ls_toolbar TO e_object->mt_toolbar.

  CLEAR ls_toolbar.
  ls_toolbar-function  = 'PROCESSAR'.
  ls_toolbar-butn_type = '0'.
  ls_toolbar-disabled  = space.
  ls_toolbar-icon      = icon_execute_object.
  ls_toolbar-text      = TEXT-b01.
  ls_toolbar-quickinfo = TEXT-b01.
  ls_toolbar-checked   = space.
  APPEND ls_toolbar TO e_object->mt_toolbar.

  CLEAR ls_toolbar.
  ls_toolbar-function  = 'DUMMY'.
  ls_toolbar-butn_type = '3'.
  APPEND ls_toolbar TO e_object->mt_toolbar.

  CLEAR ls_toolbar.
  ls_toolbar-function  = 'ELIMINAR'.
  ls_toolbar-butn_type = '0'.
  ls_toolbar-disabled  = space.
  ls_toolbar-icon      = icon_delete.
  ls_toolbar-text      = TEXT-b02.
  ls_toolbar-quickinfo = TEXT-b02.
  ls_toolbar-checked   = space.
  APPEND ls_toolbar TO e_object->mt_toolbar.


ENDFORM.                    "handle_toolbar
*&---------------------------------------------------------------------*
*&      Form  SET_GRID_EVENTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_grid_events .

  IF gr_event_receiver IS INITIAL.
    CREATE OBJECT gr_event_receiver.
  ENDIF.
  SET HANDLER gr_event_receiver->handle_user_command
              FOR g_grid.
  SET HANDLER gr_event_receiver->handle_toolbar
              FOR g_grid.
  SET HANDLER gr_event_receiver->handle_double_click
              FOR g_grid.
*  SET HANDLER go_alv_events->handle_hotspot_click
*              FOR g_grid.
ENDFORM.                    "set_grid_events
*&---------------------------------------------------------------------*
*&      Form  CREATE_GOODMVT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM create_goodmvt USING l_alv_data TYPE zabsf_pp_s_consumptions_alv
                    CHANGING l_return TYPE bapiret2
                             l_materialdocument TYPE bapi2017_gm_head_ret-mat_doc
                             l_matdocumentyear  TYPE bapi2017_gm_head_ret-doc_year.
*Internal tables
  DATA lt_goodsmvt_item TYPE TABLE OF bapi2017_gm_item_create.
  DATA return_tab    TYPE TABLE OF bapiret2.

*Structures
  DATA: ls_goodsmvt_header  TYPE bapi2017_gm_head_01,
        ls_goodsmvt_code    TYPE bapi2017_gm_code,
        ls_goodsmvt_item    TYPE bapi2017_gm_item_create,
        ls_goodsmvt_headret TYPE bapi2017_gm_head_ret.

*Variables
  DATA: l_aufnr            TYPE aufnr.

  REFRESH lt_goodsmvt_item.

  CLEAR: ls_goodsmvt_item,
         ls_goodsmvt_header,
         ls_goodsmvt_code.

*  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*    EXPORTING
*      input                         = l_alv_data-aufnr
*    IMPORTING
*      output                        = l_alv_data-aufnr
*Header of material document
  ls_goodsmvt_header-pstng_date = sy-datlo.
  ls_goodsmvt_header-doc_date = sy-datlo.
  ls_goodsmvt_header-pr_uname = sy-uname.

*Movement type
  ls_goodsmvt_code-gm_code = '03'.

*Data to create movement
*Plant
  ls_goodsmvt_item-plant = l_alv_data-werks.
*Movement Type
  ls_goodsmvt_item-move_type = '961'.
*Production Order
  ls_goodsmvt_item-orderid = l_alv_data-aufnr.


  IF l_alv_data IS NOT INITIAL.
**  Get number reservation
*    SELECT SINGLE rsnum, rspos
*      FROM resb
*      INTO (@DATA(l_rsnum), @DATA(l_rspos))
*     WHERE matnr EQ @components_st-matnr
*       AND aufnr EQ @l_aufnr.

*    IF l_alv_data-matnr NA sy-abcde.
**    Material - Component
*      CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
*        EXPORTING
*          input        = l_alv_data-matnr
*        IMPORTING
*          output       = ls_goodsmvt_item-material
*        EXCEPTIONS
*          length_error = 1
*          OTHERS       = 2.
*    ELSE.
    ls_goodsmvt_item-material = l_alv_data-matnr.
*    ENDIF.

*    ls_goodsmvt_item-material = components_st-matnr.
*  Quantity
    ls_goodsmvt_item-entry_qnt = l_alv_data-verme.
*  Unit
*    ls_goodsmvt_item-entry_uom = l_alv_data-meins.

*  Storage Location
*    IF components_st-lgort IS INITIAL.
    ls_goodsmvt_item-stge_loc = '1001'.
*    ELSE.
*      ls_goodsmvt_item-stge_loc = l_alv_data-lgort.
*    ENDIF.

** Motivo
    ls_goodsmvt_item-move_reas = l_alv_data-grund.

**  Reservation
*    ls_goodsmvt_item-reserv_no = l_rsnum.
*    ls_goodsmvt_item-res_item = l_rspos.
*
**  Operation number
*    ls_goodsmvt_item-activity = components_st-vornr.

*  Batch
*    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*      EXPORTING
*        input  = l_alv_data-batch
*      IMPORTING
*        output = ls_goodsmvt_item-batch.

*  Batch
    ls_goodsmvt_item-batch = l_alv_data-batch.

    APPEND ls_goodsmvt_item TO lt_goodsmvt_item.
  ENDIF.

*Create consumption of the Production Order
  CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
    EXPORTING
      goodsmvt_header  = ls_goodsmvt_header
      goodsmvt_code    = ls_goodsmvt_code
    IMPORTING
      goodsmvt_headret = ls_goodsmvt_headret
      materialdocument = l_materialdocument
      matdocumentyear  = l_matdocumentyear
    TABLES
      goodsmvt_item    = lt_goodsmvt_item
      return           = return_tab.

  IF return_tab[] IS INITIAL.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.
  ELSE.
    LOOP AT return_tab INTO l_return
          WHERE type CA 'EAX'.
      EXIT.
    ENDLOOP.

  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_CUSTOMIZING_TOLERANCE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_<FS_ALV>  text
*      <--P_L_CUST_TOLERANCE  text
*----------------------------------------------------------------------*
FORM get_customizing_tolerance  USING    p_fs_alv TYPE zabsf_pp_s_consumptions_alv
                                CHANGING p_cust_tolerance.


* get materital

  SELECT SINGLE matkl FROM mara INTO @DATA(l_matkl)
      WHERE matnr = @p_fs_alv-matnr.

  SELECT SINGLE auart FROM aufk INTO @DATA(l_auart)
      WHERE aufnr = @p_fs_alv-aufnr.

  CLEAR p_cust_tolerance.
  SELECT SINGLE tol_cons INTO p_cust_tolerance
        FROM zabsf_pp071
        WHERE areaid = 'PP01'
          AND werks = p_fs_alv-werks
          AND auart = l_auart
          AND matkl = l_matkl.


ENDFORM.
FORM handle_double_click  USING i_row TYPE lvc_s_row
                                i_column TYPE lvc_s_col
                                is_row_no TYPE lvc_s_roid.

*  break-point.

  READ TABLE gt_alv INTO DATA(l_alv) INDEX i_row-index.

  IF l_alv-mblnr IS NOT INITIAL AND l_alv-mjahr IS NOT INITIAL.

    CALL FUNCTION 'MIGO_DIALOG'
      EXPORTING
        i_mblnr             = l_alv-mblnr
        i_mjahr             = l_alv-mjahr
      EXCEPTIONS
        illegal_combination = 1
        OTHERS              = 2.


  ENDIF.


ENDFORM.                    "handle_double_click
