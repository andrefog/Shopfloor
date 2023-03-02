*&---------------------------------------------------------------------*
*& Report ZPP_PRINT_RETURN_LABEL_R
*&---------------------------------------------------------------------*
*&Criado por: Bruno Ribeiro
*&DATA:      21.05.2020
*&Descrição: Impressão da lista de picking
*&---------------------------------------------------------------------*
REPORT zsd_delivery_picking.

* declaration of data
INCLUDE rle_delnote_data_declare.
* definition of forms
INCLUDE rle_delnote_forms.
INCLUDE rle_print_forms.


*----------------------------------------------------------------------*
*       FORM ENTRY
*-----------------------------------------------------------------------*
FORM entry USING return_code us_screen.

  DATA: lf_retcode TYPE sy-subrc.
  xscreen = us_screen.
  PERFORM processing USING    us_screen
                     CHANGING lf_retcode.
  IF lf_retcode NE 0.
    return_code = 1.
  ELSE.
    return_code = 0.
  ENDIF.

ENDFORM.                    "ENTRY
*---------------------------------------------------------------------*
*       FORM PROCESSING                                               *
*---------------------------------------------------------------------*
FORM processing USING    proc_screen
                CHANGING cf_retcode.

  DATA: ls_print_data_to_read TYPE ledlv_print_data_to_read.
  DATA: ls_dlv_delnote        TYPE ledlv_delnote.
  DATA: lf_fm_name            TYPE rs38l_fnam.
  DATA: ls_control_param      TYPE ssfctrlop.
  DATA: ls_composer_param     TYPE ssfcompop.
  DATA: ls_recipient          TYPE swotobjid.
  DATA: ls_sender             TYPE swotobjid.
  DATA: lf_formname           TYPE tdsfname.
  DATA: ls_addr_key           LIKE addr_key.

  DATA: land1               TYPE t001-land1,
        print_char          TYPE sipt_likp-print_char,
        cert_id             TYPE sipt_likp-cert_id,
        xblnr               TYPE sipt_likp-xblnr,
        certificate_text    TYPE zcertificate,
        certificate_xblnr   TYPE zcertificate,
        lv_erdat            TYPE wspt_likp-erdat,
        lv_erzet            TYPE wspt_likp-erzet,
        certificate_appr_id TYPE wspt_likp-appr_id,
        lv_doc_status       TYPE wspt_likp-doc_status,
        lv_imp_guia,
        lr_delivprj_rng     TYPE RANGE OF lfart,
        lr_delivsls_rng     TYPE RANGE OF lfart,
        lr_delivtrn_rng     TYPE RANGE OF lfart.

  DATA: lr_classes_rng TYPE RANGE OF klasse_d.

  CONSTANTS: c_doc_status TYPE wspt_likp-doc_status     VALUE 'A',
             c_zcodigo    TYPE zconfiguracao-zcodigo    VALUE 'GUIA_REM',    " para verificar se guia é certificada
             c_zconstante TYPE zconfiguracao-zconstante VALUE 'SEM_CERTIF' . " para verificar se guia é certificada

* SmartForm from customizing table TNAPR
  lf_formname = tnapr-sform.

  "obter configuração
  TRY.
      "tipos de guias criadas a partir de projectos
      CALL METHOD zcl_bc_fixed_values=>get_ranges_value
        EXPORTING
          im_paramter_var = zcl_bc_fixed_values=>gc_exp_doc_proj
          im_modulesp_var = zcl_bc_fixed_values=>gc_salesmod_cst
        IMPORTING
          ex_valrange_tab = lr_delivprj_rng.

      "tipos de guias criadas a partir de ordens de venda
      CALL METHOD zcl_bc_fixed_values=>get_ranges_value
        EXPORTING
          im_paramter_var = zcl_bc_fixed_values=>gc_exp_doc_sale
          im_modulesp_var = zcl_bc_fixed_values=>gc_salesmod_cst
        IMPORTING
          ex_valrange_tab = lr_delivsls_rng.

      "tipos de guias criadas a partir pedidos de transferência
      CALL METHOD zcl_bc_fixed_values=>get_ranges_value
        EXPORTING
          im_paramter_var = zcl_bc_fixed_values=>gc_exp_doc_transf
          im_modulesp_var = zcl_bc_fixed_values=>gc_salesmod_cst
        IMPORTING
          ex_valrange_tab = lr_delivtrn_rng.

      "obter classes para impressão das caracteristicas
      CALL METHOD zcl_bc_fixed_values=>get_ranges_value
        EXPORTING
          im_paramter_var = zcl_bc_fixed_values=>gc_delivchars_cst
          im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
        IMPORTING
          ex_valrange_tab = lr_classes_rng.

    CATCH zcx_pp_exceptions INTO DATA(lo_bcexceptions_obj).
      "falta configuração
      MESSAGE ID lo_bcexceptions_obj->msgid
            TYPE sy-abcde+18(1)
          NUMBER lo_bcexceptions_obj->msgno
            WITH lo_bcexceptions_obj->msgv1
                 lo_bcexceptions_obj->msgv2
                 lo_bcexceptions_obj->msgv3
                 lo_bcexceptions_obj->msgv4
    DISPLAY LIKE lo_bcexceptions_obj->msgty.
      "sair do processamento
      RETURN.
  ENDTRY.
* determine print data
  PERFORM set_print_data_to_read USING    lf_formname
                                 CHANGING ls_print_data_to_read
                                 cf_retcode.

  ls_print_data_to_read-hd_gen = 'X'.
  ls_print_data_to_read-hd_adr = 'X'.
  ls_print_data_to_read-hd_gen_descript = 'X'.
  ls_print_data_to_read-hd_org = 'X'.
  ls_print_data_to_read-hd_org_adr = 'X'.
  ls_print_data_to_read-hd_org_descript = 'X'.
  ls_print_data_to_read-hd_part_add = 'X'.
  ls_print_data_to_read-hd_fin = 'X'.
  ls_print_data_to_read-hd_ft = 'X'.
  ls_print_data_to_read-hd_ft_descript = 'X'.
  ls_print_data_to_read-hd_ref = 'X'.
  ls_print_data_to_read-hd_sched = 'X'.
  ls_print_data_to_read-hd_tech = 'X'.
  ls_print_data_to_read-it_gen = 'X'.
  ls_print_data_to_read-it_gen_descript = 'X'.
  ls_print_data_to_read-it_org = 'X'.
  ls_print_data_to_read-it_org_descript = 'X'.
  ls_print_data_to_read-it_fin = 'X'.
  ls_print_data_to_read-it_ft = 'X'.
  ls_print_data_to_read-it_ft_descript = 'X'.
  ls_print_data_to_read-it_ref = 'X'.
  ls_print_data_to_read-it_reford = 'X'.
  ls_print_data_to_read-it_refpurord = 'X'.
  ls_print_data_to_read-it_sched = 'X'.
  ls_print_data_to_read-it_tech = 'X'.
  ls_print_data_to_read-it_serno = 'X'.
  ls_print_data_to_read-it_confitm = 'X'.
  ls_print_data_to_read-it_confbatch = 'X'.
  ls_print_data_to_read-it_qm = 'X'.


  IF cf_retcode = 0.
* select print data
    PERFORM get_data USING    ls_print_data_to_read
                     CHANGING ls_addr_key
                              ls_dlv_delnote
                              cf_retcode.

    SELECT SINGLE lfart
      INTO @DATA(lv_lfart_var)
      FROM likp
        WHERE vbeln = @ls_dlv_delnote-hd_gen-deliv_numb.
    " selecionar caracteristicas de um lote que são para imprimir no formulário
    SELECT ksml~imerk
      FROM klah INNER JOIN ksml
        ON klah~clint = ksml~clint
      INTO TABLE @DATA(lt_char)
        WHERE klah~klart = '023'
           AND klah~class IN @lr_classes_rng
            AND ksml~amerk LIKE '1%'.

    LOOP AT ls_dlv_delnote-it_confbatch INTO DATA(ls_confbatch).
      READ TABLE lt_char TRANSPORTING NO FIELDS WITH KEY imerk = ls_confbatch-int_char_no.
      " eliminar caracteristicas que não foram selecionadas
      IF sy-subrc <> 0.
        DELETE ls_dlv_delnote-it_confbatch.
      ENDIF.
    ENDLOOP.
  ENDIF.
  ">>Alterar descrição do material
  "obter dados da reserva
  SELECT *
    FROM lips
    INTO TABLE @DATA(lt_delivitm_tab)
    FOR ALL ENTRIES IN @ls_dlv_delnote-it_gen
      WHERE vbeln EQ @ls_dlv_delnote-it_gen-deliv_numb
        AND posnr EQ @ls_dlv_delnote-it_gen-itm_number.
  "alterar descrição da material a partir da caracterização
  LOOP AT ls_dlv_delnote-it_gen ASSIGNING FIELD-SYMBOL(<fs_delivitm_str>).
    READ TABLE lt_delivitm_tab INTO DATA(ls_delivitm_str) WITH KEY vbeln = <fs_delivitm_str>-deliv_numb
                                                                   posnr = <fs_delivitm_str>-itm_number.
    IF sy-subrc EQ 0.
      "guias de projecto
      IF lv_lfart_var IN lr_delivprj_rng.

        "obter dados da reserva
        SELECT SINGLE *
          FROM resb
          INTO @DATA(ls_reservat_str)
           WHERE rsnum EQ @ls_delivitm_str-rsnum
             AND rspos EQ @ls_delivitm_str-rspos.
        IF sy-subrc EQ 0.
          "obter descrição do material pela reserva
          zcl_mm_classification=>get_desc_as_co02( EXPORTING
                                                     im_resb_str        = ls_reservat_str
                                                   IMPORTING
                                                     ex_description_var = DATA(lv_descript_var)
                                                     ex_pf_var          = DATA(lv_pf_var) ).
          IF lv_descript_var IS NOT INITIAL.
            "alterar descrição
            <fs_delivitm_str>-short_text = lv_descript_var.
          ENDIF.
          "PF
          <fs_delivitm_str>-cust_mat = lv_pf_var.
        ENDIF.
      ENDIF.
      "guias de ordem de venda
      IF lv_lfart_var IN lr_delivsls_rng.
        "obter dados da ordem de venda
        SELECT SINGLE *
          FROM vbap
          INTO @DATA(ls_salesitm_str)
           WHERE vbeln EQ @ls_delivitm_str-vgbel
             AND posnr EQ @ls_delivitm_str-vgpos.
        IF sy-subrc EQ 0.
          "obter valor a partir da configuração da ordem de venda
          zcl_mm_classification=>get_material_desc_by_object( EXPORTING
                                                                im_cuobj_var       = ls_salesitm_str-cuobj
                                                              IMPORTING
                                                                ex_description_var = DATA(lv_salsdesc_var)
                                                                ex_pf_var          = lv_pf_var ).

          IF lv_salsdesc_var IS NOT INITIAL.
            "alterar descrição
            <fs_delivitm_str>-short_text = lv_salsdesc_var.
          ENDIF.
          "PF
          <fs_delivitm_str>-cust_mat = lv_pf_var.
        ENDIF.
      ENDIF.
      "guias de Pedidos de transferência
      IF lv_lfart_var IN lr_delivtrn_rng.
        "obter item do pedido
        SELECT SINGLE *
          FROM ekpo
          INTO @DATA(ls_request_str)
            WHERE ebeln EQ @ls_delivitm_str-vgbel
              AND ebelp EQ @ls_delivitm_str-vgpos.
        IF sy-subrc EQ 0.
          "verificar se material é configuravél
          IF ls_delivitm_str-mtart EQ 'KMAT'.
            "ler configuração do pedido
            zcl_mm_classification=>get_classification_config( EXPORTING
                                                                im_instance_cuobj_var = ls_request_str-cuobj
                                                              IMPORTING
                                                                ex_classfication_tab  = DATA(lt_classific_tab)
                                                              EXCEPTIONS
                                                                instance_not_found    = 1
                                                                OTHERS                = 2 ).
            IF sy-subrc <> 0.
              "mensagem de erro
              MESSAGE ID sy-msgid
                    TYPE sy-msgty
                  NUMBER sy-msgno
                    WITH sy-msgv1
                         sy-msgv2
                         sy-msgv3
                         sy-msgv4.
            ENDIF.
          ENDIF.
          "verificar se existem caracteristicas no lote
          LOOP AT ls_dlv_delnote-it_confbatch INTO DATA(ls_confbatch_str)
            WHERE itm_number = <fs_delivitm_str>-itm_number
             AND deliv_numb = <fs_delivitm_str>-deliv_numb.
            "remover caracteristica
            DELETE ls_dlv_delnote-it_confbatch.
          ENDLOOP.

          LOOP AT lt_classific_tab INTO DATA(ls_classific_str).
            "adicionar caracteristica
            APPEND VALUE #( deliv_numb     = <fs_delivitm_str>-deliv_numb
                            itm_number     = <fs_delivitm_str>-itm_number
                            material       = <fs_delivitm_str>-material
                            plant          = ls_delivitm_str-werks
                            batch          = <fs_delivitm_str>-batch
                            int_char_no    = ls_classific_str-atinn
                            char_name      = ls_classific_str-atnam
                            char_descript  = ls_classific_str-atbez
                            char_value     = ls_classific_str-atwrt
                            value_descript = ls_classific_str-atwtb ) TO ls_dlv_delnote-it_confbatch.
          ENDLOOP.

          "obter valor a partir da configuração da ordem de venda
          zcl_mm_classification=>get_material_desc_by_object( EXPORTING
                                                                im_cuobj_var       = ls_request_str-cuobj
                                                              IMPORTING
                                                                ex_description_var = DATA(lv_reqstdesc_var)
                                                                ex_pf_var          = lv_pf_var ).
          IF lv_reqstdesc_var IS NOT INITIAL.
            "alterar descrição
            <fs_delivitm_str>-short_text = lv_reqstdesc_var.
          ENDIF.
          "PF
          <fs_delivitm_str>-cust_mat = lv_pf_var.
        ENDIF.
      ENDIF.

      IF lv_descript_var IS INITIAL AND lv_salsdesc_var IS INITIAL
        AND lv_reqstdesc_var IS INITIAL AND ls_delivitm_str-charg IS NOT INITIAL.
        "obter descrição do lote
        zcl_mm_classification=>get_material_desc_by_batch( EXPORTING
                                                             im_material_var    = ls_delivitm_str-matnr
                                                             im_batch_var       = ls_delivitm_str-charg
                                                           IMPORTING
                                                             ex_description_var = DATA(lv_batchdesc_var)
                                                             ex_pf_var          = lv_pf_var ).
        IF lv_batchdesc_var IS NOT INITIAL.
          "alterar descrição
          <fs_delivitm_str>-short_text = lv_batchdesc_var.
        ENDIF.
        "PF
        <fs_delivitm_str>-cust_mat = lv_pf_var.
      ENDIF.
    ENDIF.
    "limpara variáveis
    CLEAR: ls_delivitm_str, lv_descript_var, ls_reservat_str,
           lv_salsdesc_var, ls_salesitm_str, lv_batchdesc_var,
           lv_reqstdesc_var, lv_pf_var.
  ENDLOOP.

  IF cf_retcode = 0.
    PERFORM set_print_param USING    ls_addr_key
                            CHANGING ls_control_param
                                     ls_composer_param
                                     ls_recipient
                                     ls_sender
                                     cf_retcode.
  ENDIF.

  ls_composer_param-tdnewid = 'X'.

  " Certificação ------------------------------------------------------
  certificate_text       = 'processado por computador'.


  CLEAR: land1, print_char, cert_id, xblnr.
  FREE: land1, print_char, cert_id, xblnr.

  " Certificação ------------------------------------------------------


  IF cf_retcode = 0.
* determine smartform function module for delivery note
    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname           = lf_formname
*       variant            = ' '
*       direct_call        = ' '
      IMPORTING
        fm_name            = lf_fm_name
      EXCEPTIONS
        no_form            = 1
        no_function_module = 2
        OTHERS             = 3.
    IF sy-subrc <> 0.
*   error handling
      cf_retcode = sy-subrc.
      PERFORM protocol_update.
    ENDIF.
  ENDIF.

  IF cf_retcode = 0.
*   call smartform delivery note

    ls_control_param-langu = 'P'.
    CALL FUNCTION lf_fm_name
      EXPORTING
        archive_index       = toa_dara
        archive_parameters  = arc_params
        control_parameters  = ls_control_param
*       mail_appl_obj       =
        mail_recipient      = ls_recipient
        mail_sender         = ls_sender
        output_options      = ls_composer_param
        user_settings       = ' '
        is_dlv_delnote      = ls_dlv_delnote
        is_nast             = nast
        certificate_text    = certificate_text
        certificate_xblnr   = certificate_xblnr
        certificate_appr_id = certificate_appr_id
*      importing  document_output_info =
*       job_output_info     =
*       job_output_options  =
      EXCEPTIONS
        formatting_error    = 1
        internal_error      = 2
        send_error          = 3
        user_canceled       = 4
        OTHERS              = 5.
    IF sy-subrc <> 0.
*   error handling
      cf_retcode = sy-subrc.
      PERFORM protocol_update.
*     get SmartForm protocoll and store it in the NAST protocoll
      PERFORM add_smfrm_prot.                  "INS_HP_335958
    ENDIF.
  ENDIF.

* get SmartForm protocoll and store it in the NAST protocoll
* PERFORM ADD_SMFRM_PROT.                       DEL_HP_335958

ENDFORM.                    "PROCESSING
