*&---------------------------------------------------------------------*
*& Report  Z_LP_PP_SF_REPORT_QUANT
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zabsf_pp_report_quant.

INCLUDE zabsf_pp_report_quant_top.

INITIALIZATION.
  DATA: lt_arbpl TYPE TABLE OF ty_arbpl,
        lt_afru  TYPE TABLE OF afru.

  DATA: wa_arbpl TYPE ty_arbpl,
        ls_hname LIKE so_hname, "Name of hierarchy
        ls_arbpl LIKE so_arbpl, "Workcenter
        ls_shift LIKE so_shift. "Shift

*Initialize global variables
  PERFORM init_variables.
  PERFORM create_desc_quantity.

START-OF-SELECTION.

  IF pa_regt IS NOT INITIAL.
*  Fill internal table with all information necessary for calculate OEE

*  Plant
    gs_qtd-werks = pa_werks.

*  Area
    PERFORM get_areas_for_plant.

* Hierachy.
    PERFORM get_hierarchies.

*  Date
    PERFORM create_data_range.

*  Check if all optional parameter are filled
    PERFORM check_so USING pa_area pa_werks pa_date.

*  Fill hierarchy, workcenter and indicators OEE
    LOOP AT so_hname INTO ls_hname.
*    Hierarchy
      gs_qtd-hname = ls_hname-low.

*    Get workcenter for hierarchy
      PERFORM get_workcenters_table USING gs_qtd-hname gs_qtd-werks
                                    CHANGING lt_arbpl.

      LOOP AT so_arbpl INTO ls_arbpl.
        READ TABLE lt_arbpl INTO wa_arbpl WITH KEY arbpl = ls_arbpl-low.

        IF sy-subrc EQ 0.
*        Workcenter
          gs_qtd-arbpl = wa_arbpl-arbpl.

*        Fill shift
          LOOP AT so_shift INTO ls_shift.
*          Shift
            gs_qtd-shiftid = ls_shift-low.
            APPEND gs_qtd TO gt_qtd.
          ENDLOOP.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

    SORT gt_qtd BY areaid hname	werks	arbpl shiftid ASCENDING.

*  Get data from afru
    PERFORM get_data_afru.

    IF gt_qtd[] IS NOT INITIAL.


*    Calculate incators OEE
      LOOP AT gt_qtd ASSIGNING <fs_qtd>.
*      Get quantities
        PERFORM get_quantity USING <fs_qtd>-areaid <fs_qtd>-hname <fs_qtd>-werks <fs_qtd>-arbpl
                                   <fs_qtd>-shiftid <fs_qtd>-data
                             CHANGING <fs_qtd>-gamng <fs_qtd>-lmnga <fs_qtd>-xmnga
                                      <fs_qtd>-rmnga <fs_qtd>-qtdprod <fs_qtd>-pctprod.
      ENDLOOP.
    ENDIF.
  ENDIF.

END-OF-SELECTION.

  IF gt_error[] IS INITIAL.
    IF pa_simul IS NOT INITIAL OR pa_hist IS NOT INITIAL.
      IF pa_hist IS NOT INITIAL.
        PERFORM get_data_db.
      ENDIF.

      IF gt_qtd[] IS NOT INITIAL.
*      Show data in ALV
        PERFORM show_data.
      ELSE.
        SET SCREEN 0.
      ENDIF.

    ENDIF.

    IF pa_creat IS NOT INITIAL.
*    Save data in database
      PERFORM save_db.
    ENDIF.
  ENDIF.

  INCLUDE zabsf_pp_report_quant_f01.
  INCLUDE zabsf_pp_report_quant_o01.
  INCLUDE zabsf_pp_report_quant_i01.
