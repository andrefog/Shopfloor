*&---------------------------------------------------------------------*
*&  Programa         ZPP_PRINT_LABELS_R
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& DESCRIPTION    : Programa de (re)impressão de etiquetas
*&
*& AUTHOR(S)      : Bruno Ribeiro - Abaco Consulting
*& CREATED ON     : 30.03.2020
*&---------------------------------------------------------------------*
report zpp_print_labels_r.
"includes do programa
include: zpp_print_labels_top,
         zpp_print_labels_scr,
         zpp_print_labels_d01,
         zpp_print_labels_p01.

start-of-selection.
  try.
      "instanciar classe
      go_printlbl_obj = new gcl_print_label( im_p_printr_var = p_printr
                                             im_p_copies_var = p_copies
                                             im_p_langug_var = p_langu
                                             im_p_previw_var = p_prewin ).
      "conversão de formatos
      p_batch = |{ p_batch alpha = in }|.
      p_matnr = |{ p_matnr alpha = in }|.
      p_aufnr = |{ p_aufnr alpha = in }|.
      "iniciar processamento
      go_printlbl_obj->process_execute( exporting
                                          im_aufnrval_var = p_aufnr
                                          im_batchval_var = p_batch
                                          im_material_var = p_matnr
                                          im_matndesc_var = p_maktx
                                          im_projtpep_var = p_pspnr
                                          im_quantity_var = p_quant
                                          im_qtt_unit_var = p_meins
                                          im_sequence_var = p_seqnr
                                          im_confirmt_var = p_rueck
                                          im_confcont_var = p_rmzhl
                                          im_shopflor_var = p_shopf
                                          im_so_numbr_tab = so_numb[] ).

    catch zcx_pp_exceptions into go_excption_obj.
      "mostrar mensagem de erro
      message id go_excption_obj->msgid
            type sy-abcde+18(1)
          number go_excption_obj->msgno
            with go_excption_obj->msgv1
                 go_excption_obj->msgv2
                 go_excption_obj->msgv3
                 go_excption_obj->msgv4
    display like go_excption_obj->msgty.
  endtry.
