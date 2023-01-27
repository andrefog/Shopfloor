*&---------------------------------------------------------------------*
*&  Include           ZPP_PRINT_LABELS_D01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report ZPP_PRINT_LABELS
*&---------------------------------------------------------------------*
*&Criado por: Bruno Ribeiro
*&DATA:       31.03.2020
*&Descrição: Impressão de etiquetas
*&---------------------------------------------------------------------*
class gcl_print_label definition final.
************************************************************************
* Secção Pública -------------------------------------------------------
************************************************************************
  public section.
    "constructor da classe
    methods constructor
      importing
        im_p_printr_var type rspopname
        im_p_copies_var type int1
        im_p_previw_var type flag
        im_p_langug_var type spras
      raising
        zcx_bc_exceptions.

    "iniciar processamento
    methods process_execute
      importing
        im_aufnrval_var type aufnr
        im_batchval_var type charg_d
        im_material_var type matnr
        im_matndesc_var type atwrt
        im_projtpep_var type ps_psp_pnr
        im_quantity_var type int2
        im_qtt_unit_var type meins
        im_sequence_var type flag
        im_confirmt_var type co_rueck
        im_confcont_var type co_rmzhl
        im_shopflor_var type flag
        im_so_numbr_tab type any table
      raising
        zcx_bc_exceptions.

    "secção privada
  private section.
    data: gv_ppreview_var type flag,
          gv_language_var type spras,
          gv_oprinter_var type rspopname,
          gv_nmcopies_var type int1.

    methods check_label_existence
      importing
        im_aufnrval_var type aufnr
        im_batchval_var type charg_d
        im_material_var type matnr
        im_projtpep_var type ps_psp_pnr
        im_qtt_unit_var type meins
        im_so_numbr_tab type any table
      raising
        zcx_bc_exceptions.

    methods print_labels
      importing
        im_tblabels_tab type zpp_prod_label_tt
        im_aufnrval_var type aufnr
      raising
        zcx_bc_exceptions.

    methods create_labels_table
      importing
        im_aufnrval_var type aufnr
        im_batchval_var type charg_d
        im_material_var type matnr
        im_matndesc_var type atwrt
        im_projtpep_var type ps_psp_pnr
        im_quantity_var type int2
        im_qtt_unit_var type meins
        im_confirmt_var type co_rueck
        im_confcont_var type co_rmzhl
        im_sequence_var type flag
        im_shopflor_var type flag
        im_so_numbr_tab type any table
      exporting
        ex_tblabels_tab type zpp_prod_label_tt
      raising
        zcx_bc_exceptions.

endclass.
