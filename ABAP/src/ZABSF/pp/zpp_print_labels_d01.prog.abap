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
CLASS gcl_print_label DEFINITION FINAL.
************************************************************************
* Secção Pública -------------------------------------------------------
************************************************************************
  PUBLIC SECTION.
    "constructor da classe
    METHODS constructor
      IMPORTING
        im_p_printr_var TYPE rspopname
        im_p_copies_var TYPE int1
        im_p_previw_var TYPE flag
        im_p_langug_var TYPE spras
      RAISING
        zcx_pp_exceptions.

    "iniciar processamento
    METHODS process_execute
      IMPORTING
        im_aufnrval_var TYPE aufnr
        im_batchval_var TYPE charg_d
        im_material_var TYPE matnr
        im_matndesc_var TYPE atwrt
        im_projtpep_var TYPE ps_psp_pnr
        im_quantity_var TYPE int2
        im_qtt_unit_var TYPE meins
        im_sequence_var TYPE flag
        im_confirmt_var TYPE co_rueck
        im_confcont_var TYPE co_rmzhl
        im_shopflor_var TYPE flag
        im_so_numbr_tab TYPE ANY TABLE
      RAISING
        zcx_pp_exceptions.

    "secção privada
  PRIVATE SECTION.
    DATA: gv_ppreview_var TYPE flag,
          gv_language_var TYPE spras,
          gv_oprinter_var TYPE rspopname,
          gv_nmcopies_var TYPE int1.

    METHODS check_label_existence
      IMPORTING
        im_aufnrval_var TYPE aufnr
        im_batchval_var TYPE charg_d
        im_material_var TYPE matnr
        im_projtpep_var TYPE ps_psp_pnr
        im_qtt_unit_var TYPE meins
        im_so_numbr_tab TYPE ANY TABLE
      RAISING
        zcx_pp_exceptions.

    METHODS print_labels
      IMPORTING
        im_tblabels_tab TYPE zpp_prod_label_tt
        im_aufnrval_var TYPE aufnr
      RAISING
        zcx_pp_exceptions.

    METHODS create_labels_table
      IMPORTING
        im_aufnrval_var TYPE aufnr
        im_batchval_var TYPE charg_d
        im_material_var TYPE matnr
        im_matndesc_var TYPE atwrt
        im_projtpep_var TYPE ps_psp_pnr
        im_quantity_var TYPE int2
        im_qtt_unit_var TYPE meins
        im_confirmt_var TYPE co_rueck
        im_confcont_var TYPE co_rmzhl
        im_sequence_var TYPE flag
        im_shopflor_var TYPE flag
        im_so_numbr_tab TYPE ANY TABLE
      EXPORTING
        ex_tblabels_tab TYPE zpp_prod_label_tt
      RAISING
        zcx_pp_exceptions.

ENDCLASS.
