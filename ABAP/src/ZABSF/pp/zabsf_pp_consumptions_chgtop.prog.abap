*&---------------------------------------------------------------------*
*&  Include           Z_LP_PP_SF_CONSUMPTIONS_CHGTOP
*&---------------------------------------------------------------------*
*Predefine a local class for event handling to allow the
*declaration of a reference variable before the class is defined.
class lcl_event_receiver definition deferred.

*&---------------------------------------------------------------------*
*&  Tables
*&---------------------------------------------------------------------*
tables: zabsf_pp076.

*&---------------------------------------------------------------------*
*&  Types
*&---------------------------------------------------------------------*
*Shift
types: begin of ty_shift,
         shiftid    type zabsf_pp_e_shiftid,
         shift_desc type zabsf_pp_e_shiftdesc,
       end of ty_shift.

*&---------------------------------------------------------------------*
*&  Internal Tables
*&---------------------------------------------------------------------*
data: gt_alv      type table of zabsf_pp_s_consumptions_alv,
      lt_consumpt type table of zabsf_pp076,
      it_shift    type table of ty_shift.  "Shift

*&---------------------------------------------------------------------*
*&  Structures
*&---------------------------------------------------------------------*
data: ls_consumpt    type zabsf_pp076,
      ls_lp_pp_sf076 type zabsf_pp076.


*&---------------------------------------------------------------------*
*&  ALV
*&---------------------------------------------------------------------*
data: gt_fieldcatalog    type table of lvc_s_fcat,
      g_custom_container type ref to cl_gui_custom_container,
      g_grid             type ref to cl_gui_alv_grid,
      gr_event_receiver  type ref to lcl_event_receiver,
      g_container        type scrfname value 'GR_CONTAINER',
      gs_layout          type lvc_s_layo,
      l_variant          type disvariant,
      ok_code            type syucomm.

data : ls_exclude type ui_func,
       pt_exclude type ui_functions.

data: l_motivo    type zabsf_pp_s_consumptions_alv-grund.

constants c_struc_alv type dd02l-tabname
                      value 'ZABSF_PP_S_CONSUMPTIONS_ALV'.


** Variables
data: l_answer,
      l_not_exec.

*&---------------------------------------------------------------------*
*&  Constants
*&---------------------------------------------------------------------*
constants: c_shift     type dfies-fieldname value 'SHIFTID',
           c_vorg      type ddbool_d        value 'S',
           c_shift_dyn type dynfnam         value 'S_SHIFT',
           c_werks     type werks_d          value '1020',
           c_stat_p    type zabsf_pp_e_status_cons value 'P', "To processed
           c_stat_d    type zabsf_pp_e_status_cons value 'D', "Deleted
           c_stat_c    type zabsf_pp_e_status_cons value 'C'. "Completed

*&---------------------------------------------------------------------*
*&       Class (Defimition)  lcl_event_receiver
*&---------------------------------------------------------------------*
*        Text
*----------------------------------------------------------------------*
class lcl_event_receiver definition.
  public section.
    methods:
*      handle_toolbar FOR EVENT toolbar OF cl_gui_alv_grid
*        IMPORTING e_object e_interactive,
      handle_user_command for event user_command of cl_gui_alv_grid
        importing e_ucomm,
      handle_data_changed for event data_changed of cl_gui_alv_grid
        importing er_data_changed,

      handle_double_click  for event double_click of cl_gui_alv_grid
        importing e_row
                    e_column
                    es_row_no,

      handle_toolbar  for event toolbar  of cl_gui_alv_grid
        importing e_object e_interactive.

endclass.
*&--------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&       Class (Implementation)  lcl_event_receiver
*&---------------------------------------------------------------------*
*        Text
*----------------------------------------------------------------------*
class lcl_event_receiver implementation.
  method handle_user_command.
    data: lt_index_rows  type lvc_t_row.
    data: lt_row_no      type lvc_t_roid.
    data: ls_index_rows  type lvc_s_row.
    data: l_return       type bapiret2.
    data: lt_cellcol     type lvc_t_scol.
    data: lw_cellcol     type lvc_s_scol.

    call method g_grid->get_selected_rows
      importing
        et_index_rows = lt_index_rows
        et_row_no     = lt_row_no.

    case e_ucomm.
      when 'CHANGE'.
        loop at lt_index_rows into ls_index_rows.

          read table gt_alv assigning field-symbol(<ls_alv_d>)
                    index ls_index_rows-index.
          if sy-subrc = 0.

            check <ls_alv_d>-status_cons = c_stat_p.

            clear l_motivo.
            call screen 0900 starting at 10 10.
            <ls_alv_d>-grund = l_motivo.
            clear l_motivo.
            if not <ls_alv_d>-grund is initial.
              move icon_yellow_light  to <ls_alv_d>-icon.
              refresh <ls_alv_d>-color.
              clear <ls_alv_d>-log .
            else.
              move icon_red_light  to <ls_alv_d>-icon.
              lw_cellcol-fname = 'LOG'.
              lw_cellcol-color-col = '6'.
              lw_cellcol-color-int = '0'.
              append lw_cellcol to <ls_alv_d>-color.
            endif.

          endif.
        endloop.

      when 'PROCESSAR'.
        loop at lt_index_rows into ls_index_rows.

          read table gt_alv assigning <ls_alv_d>
                    index ls_index_rows-index.
          if sy-subrc = 0.

            check <ls_alv_d>-status_cons = c_stat_p and <ls_alv_d>-log is initial.
            break mba.
            perform create_goodmvt using <ls_alv_d>
                                   changing l_return
                                            <ls_alv_d>-mblnr
                                            <ls_alv_d>-mjahr.
            if l_return is initial.
              move icon_green_light  to <ls_alv_d>-icon.
              <ls_alv_d>-status_cons = c_stat_c.
              <ls_alv_d>-aenam       = sy-uname.
              <ls_alv_d>-aedat       = sy-datum.
              clear <ls_alv_d>-log .

              clear ls_lp_pp_sf076.
              move-corresponding <ls_alv_d> to ls_lp_pp_sf076.

*             update zabsf_pp076 from @( value #( base ls_lp_pp_sf076
*                                                       status_cons = c_stat_c
*                                                      aenam = sy-uname
*                                                      aedat = sy-datum
*                                                       ) ).

              ls_lp_pp_sf076-status_cons = c_stat_c.
              ls_lp_pp_sf076-aenam = sy-uname.
              ls_lp_pp_sf076-aedat = sy-datum.
              update zabsf_pp076 from ls_lp_pp_sf076.

              if ( sy-subrc eq 0 ).
                commit work and wait.
              endif.
            else.
              move l_return-message to <ls_alv_d>-log.
              move icon_red_light  to <ls_alv_d>-icon.
              refresh <ls_alv_d>-color.
              lw_cellcol-fname = 'LOG'.
              lw_cellcol-color-col = '6'.
              lw_cellcol-color-int = '0'.
              append lw_cellcol to <ls_alv_d>-color.
            endif.

          endif.
        endloop.

      when 'ELIMINAR'.
        loop at lt_index_rows into ls_index_rows.

          read table gt_alv assigning <ls_alv_d> index ls_index_rows-index.
          if sy-subrc = 0.
            check <ls_alv_d>-status_cons = c_stat_p.
            delete from zabsf_pp076 where werks   = <ls_alv_d>-werks
                                       and data    = <ls_alv_d>-data
                                       and shiftid = <ls_alv_d>-shiftid
                                       and aufnr   = <ls_alv_d>-aufnr
                                       and ficha   = <ls_alv_d>-ficha
                                       and matnr   = <ls_alv_d>-matnr
                                       and batch   = <ls_alv_d>-batch .

            if sy-subrc = 0.
              commit work and wait.
              <ls_alv_d>-status_cons = c_stat_d.
              <ls_alv_d>-aenam       = sy-uname.
              <ls_alv_d>-aedat       = sy-datum.
              clear <ls_alv_d>-log .
              refresh <ls_alv_d>-color.
              move icon_delete  to <ls_alv_d>-icon.
              loop at gt_fieldcatalog assigning field-symbol(<fs_fieldcat>).
                <ls_alv_d>-log = text-b05.
                lw_cellcol-fname = <fs_fieldcat>-fieldname.
                lw_cellcol-color-col = '7'.
                lw_cellcol-color-int = '0'.
                append lw_cellcol to <ls_alv_d>-color.
              endloop.
            else.
              move icon_red_light  to <ls_alv_d>-icon.
              loop at gt_fieldcatalog assigning <fs_fieldcat>.
                <ls_alv_d>-log = text-b05.
                lw_cellcol-fname = <fs_fieldcat>-fieldname.
                lw_cellcol-color-col = '7'.
                lw_cellcol-color-int = '0'.
                append lw_cellcol to <ls_alv_d>-color.
              endloop.
            endif.

          endif.
        endloop.

    endcase.

*     Refresh Keep position selected
    call method g_grid->refresh_table_display.

    call method g_grid->set_selected_rows
      exporting
        it_index_rows = lt_index_rows.

  endmethod.

  method handle_data_changed.
    "DATA: ls_good      TYPE lvc_s_modi.

    loop at er_data_changed->mt_good_cells into data(ls_good).

    endloop.
  endmethod. "handle_data_changed

  method handle_toolbar.
    perform handle_toolbar using e_object
                                 e_interactive.
  endmethod.                    "handle_toolbar


  method handle_double_click.
    perform handle_double_click using e_row e_column es_row_no .
  endmethod.                    "handle_double_click
endclass.
