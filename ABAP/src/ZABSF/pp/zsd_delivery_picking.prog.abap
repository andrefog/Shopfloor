*&---------------------------------------------------------------------*
*& Report ZPP_PRINT_RETURN_LABEL_R
*&---------------------------------------------------------------------*
*&Criado por: Bruno Ribeiro
*&DATA:      21.05.2020
*&Descrição: Impressão da lista de picking
*&---------------------------------------------------------------------*
report zsd_delivery_picking.

* declaration of data
include rle_delnote_data_declare.
* definition of forms
include rle_delnote_forms.
include rle_print_forms.


*----------------------------------------------------------------------*
*       FORM ENTRY
*-----------------------------------------------------------------------*
form entry using return_code us_screen.

  data: lf_retcode type sy-subrc.
  xscreen = us_screen.
  perform processing using    us_screen
                     changing lf_retcode.
  if lf_retcode ne 0.
    return_code = 1.
  else.
    return_code = 0.
  endif.

endform.                    "ENTRY
*---------------------------------------------------------------------*
*       FORM PROCESSING                                               *
*---------------------------------------------------------------------*
form processing using    proc_screen
                changing cf_retcode.

  data: ls_print_data_to_read type ledlv_print_data_to_read.
  data: ls_dlv_delnote        type ledlv_delnote.
  data: lf_fm_name            type rs38l_fnam.
  data: ls_control_param      type ssfctrlop.
  data: ls_composer_param     type ssfcompop.
  data: ls_recipient          type swotobjid.
  data: ls_sender             type swotobjid.
  data: lf_formname           type tdsfname.
  data: ls_addr_key           like addr_key.

  data: land1               type t001-land1,
        print_char          type sipt_likp-print_char,
        cert_id             type sipt_likp-cert_id,
        xblnr               type sipt_likp-xblnr,
        certificate_text    type zcertificate,
        certificate_xblnr   type zcertificate,
        lv_erdat            type wspt_likp-erdat,
        lv_erzet            type wspt_likp-erzet,
        certificate_appr_id type wspt_likp-appr_id,
        lv_doc_status       type wspt_likp-doc_status,
        lv_imp_guia,
        lr_delivprj_rng     type range of lfart,
        lr_delivsls_rng     type range of lfart,
        lr_delivtrn_rng     type range of lfart.

  data: lr_classes_rng type range of klasse_d.

  constants: c_doc_status type wspt_likp-doc_status     value 'A',
             c_zcodigo    type zconfiguracao-zcodigo    value 'GUIA_REM',    " para verificar se guia é certificada
             c_zconstante type zconfiguracao-zconstante value 'SEM_CERTIF' . " para verificar se guia é certificada

* SmartForm from customizing table TNAPR
  lf_formname = tnapr-sform.

  "obter configuração
  try.
      "tipos de guias criadas a partir de projectos
      call method zcl_bc_fixed_values=>get_ranges_value
        exporting
          im_paramter_var = zcl_bc_fixed_values=>gc_exp_doc_proj
          im_modulesp_var = zcl_bc_fixed_values=>gc_salesmod_cst
        importing
          ex_valrange_tab = lr_delivprj_rng.

      "tipos de guias criadas a partir de ordens de venda
      call method zcl_bc_fixed_values=>get_ranges_value
        exporting
          im_paramter_var = zcl_bc_fixed_values=>gc_exp_doc_sale
          im_modulesp_var = zcl_bc_fixed_values=>gc_salesmod_cst
        importing
          ex_valrange_tab = lr_delivsls_rng.

      "tipos de guias criadas a partir pedidos de transferência
      call method zcl_bc_fixed_values=>get_ranges_value
        exporting
          im_paramter_var = zcl_bc_fixed_values=>gc_exp_doc_transf
          im_modulesp_var = zcl_bc_fixed_values=>gc_salesmod_cst
        importing
          ex_valrange_tab = lr_delivtrn_rng.

      "obter classes para impressão das caracteristicas
      call method zcl_bc_fixed_values=>get_ranges_value
        exporting
          im_paramter_var = zcl_bc_fixed_values=>gc_delivchars_cst
          im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
        importing
          ex_valrange_tab = lr_classes_rng.

    catch zcx_bc_exceptions into data(lo_bcexceptions_obj).
      "falta configuração
      message id lo_bcexceptions_obj->msgid
            type sy-abcde+18(1)
          number lo_bcexceptions_obj->msgno
            with lo_bcexceptions_obj->msgv1
                 lo_bcexceptions_obj->msgv2
                 lo_bcexceptions_obj->msgv3
                 lo_bcexceptions_obj->msgv4
    display like lo_bcexceptions_obj->msgty.
      "sair do processamento
      return.
  endtry.
* determine print data
  perform set_print_data_to_read using    lf_formname
                                 changing ls_print_data_to_read
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


  if cf_retcode = 0.
* select print data
    perform get_data using    ls_print_data_to_read
                     changing ls_addr_key
                              ls_dlv_delnote
                              cf_retcode.

    select single lfart
      into @data(lv_lfart_var)
      from likp
        where vbeln = @ls_dlv_delnote-hd_gen-deliv_numb.
    " selecionar caracteristicas de um lote que são para imprimir no formulário
    select ksml~imerk
      from klah inner join ksml
        on klah~clint = ksml~clint
      into table @data(lt_char)
        where klah~klart = '023'
           and klah~class in @lr_classes_rng
            and ksml~amerk like '1%'.

    loop at ls_dlv_delnote-it_confbatch into data(ls_confbatch).
      read table lt_char transporting no fields with key imerk = ls_confbatch-int_char_no.
      " eliminar caracteristicas que não foram selecionadas
      if sy-subrc <> 0.
        delete ls_dlv_delnote-it_confbatch.
      endif.
    endloop.
  endif.
  ">>Alterar descrição do material
  "obter dados da reserva
  select *
    from lips
    into table @data(lt_delivitm_tab)
    for all entries in @ls_dlv_delnote-it_gen
      where vbeln eq @ls_dlv_delnote-it_gen-deliv_numb
        and posnr eq @ls_dlv_delnote-it_gen-itm_number.
  "alterar descrição da material a partir da caracterização
  loop at ls_dlv_delnote-it_gen assigning field-symbol(<fs_delivitm_str>).
    read table lt_delivitm_tab into data(ls_delivitm_str) with key vbeln = <fs_delivitm_str>-deliv_numb
                                                                   posnr = <fs_delivitm_str>-itm_number.
    if sy-subrc eq 0.
      "guias de projecto
      if lv_lfart_var in lr_delivprj_rng.

        "obter dados da reserva
        select single *
          from resb
          into @data(ls_reservat_str)
           where rsnum eq @ls_delivitm_str-rsnum
             and rspos eq @ls_delivitm_str-rspos.
        if sy-subrc eq 0.
          "obter descrição do material pela reserva
          zcl_mm_classification=>get_desc_as_co02( exporting
                                                     im_resb_str        = ls_reservat_str
                                                   importing
                                                     ex_description_var = data(lv_descript_var)
                                                     ex_pf_var          = data(lv_pf_var) ).
          if lv_descript_var is not initial.
            "alterar descrição
            <fs_delivitm_str>-short_text = lv_descript_var.
          endif.
          "PF
          <fs_delivitm_str>-cust_mat = lv_pf_var.
        endif.
      endif.
      "guias de ordem de venda
      if lv_lfart_var in lr_delivsls_rng.
        "obter dados da ordem de venda
        select single *
          from vbap
          into @data(ls_salesitm_str)
           where vbeln eq @ls_delivitm_str-vgbel
             and posnr eq @ls_delivitm_str-vgpos.
        if sy-subrc eq 0.
          "obter valor a partir da configuração da ordem de venda
          zcl_mm_classification=>get_material_desc_by_object( exporting
                                                                im_cuobj_var       = ls_salesitm_str-cuobj
                                                              importing
                                                                ex_description_var = data(lv_salsdesc_var)
                                                                ex_pf_var          = lv_pf_var ).

          if lv_salsdesc_var is not initial.
            "alterar descrição
            <fs_delivitm_str>-short_text = lv_salsdesc_var.
          endif.
          "PF
          <fs_delivitm_str>-cust_mat = lv_pf_var.
        endif.
      endif.
      "guias de Pedidos de transferência
      if lv_lfart_var in lr_delivtrn_rng.
        "obter item do pedido
        select single *
          from ekpo
          into @data(ls_request_str)
            where ebeln eq @ls_delivitm_str-vgbel
              and ebelp eq @ls_delivitm_str-vgpos.
        if sy-subrc eq 0.
          "verificar se material é configuravél
          if ls_delivitm_str-mtart eq 'KMAT'.
            "ler configuração do pedido
            zcl_mm_classification=>get_classification_config( exporting
                                                                im_instance_cuobj_var = ls_request_str-cuobj
                                                              importing
                                                                ex_classfication_tab  = data(lt_classific_tab)
                                                              exceptions
                                                                instance_not_found    = 1
                                                                others                = 2 ).
            if sy-subrc <> 0.
              "mensagem de erro
              message id sy-msgid
                    type sy-msgty
                  number sy-msgno
                    with sy-msgv1
                         sy-msgv2
                         sy-msgv3
                         sy-msgv4.
            endif.
          endif.
          "verificar se existem caracteristicas no lote
          loop at ls_dlv_delnote-it_confbatch into data(ls_confbatch_str)
            where itm_number = <fs_delivitm_str>-itm_number
             and deliv_numb = <fs_delivitm_str>-deliv_numb.
            "remover caracteristica
            delete ls_dlv_delnote-it_confbatch.
          endloop.

          loop at lt_classific_tab into data(ls_classific_str).
            "adicionar caracteristica
            append value #( deliv_numb     = <fs_delivitm_str>-deliv_numb
                            itm_number     = <fs_delivitm_str>-itm_number
                            material       = <fs_delivitm_str>-material
                            plant          = ls_delivitm_str-werks
                            batch          = <fs_delivitm_str>-batch
                            int_char_no    = ls_classific_str-atinn
                            char_name      = ls_classific_str-atnam
                            char_descript  = ls_classific_str-atbez
                            char_value     = ls_classific_str-atwrt
                            value_descript = ls_classific_str-atwtb ) to ls_dlv_delnote-it_confbatch.
          endloop.

          "obter valor a partir da configuração da ordem de venda
          zcl_mm_classification=>get_material_desc_by_object( exporting
                                                                im_cuobj_var       = ls_request_str-cuobj
                                                              importing
                                                                ex_description_var = data(lv_reqstdesc_var)
                                                                ex_pf_var          = lv_pf_var ).
          if lv_reqstdesc_var is not initial.
            "alterar descrição
            <fs_delivitm_str>-short_text = lv_reqstdesc_var.
          endif.
          "PF
          <fs_delivitm_str>-cust_mat = lv_pf_var.
        endif.
      endif.

      if lv_descript_var is initial and lv_salsdesc_var is initial
        and lv_reqstdesc_var is initial and ls_delivitm_str-charg is not initial.
        "obter descrição do lote
        zcl_mm_classification=>get_material_desc_by_batch( exporting
                                                             im_material_var    = ls_delivitm_str-matnr
                                                             im_batch_var       = ls_delivitm_str-charg
                                                           importing
                                                             ex_description_var = data(lv_batchdesc_var)
                                                             ex_pf_var          = lv_pf_var ).
        if lv_batchdesc_var is not initial.
          "alterar descrição
          <fs_delivitm_str>-short_text = lv_batchdesc_var.
        endif.
        "PF
        <fs_delivitm_str>-cust_mat = lv_pf_var.
      endif.
    endif.
    "limpara variáveis
    clear: ls_delivitm_str, lv_descript_var, ls_reservat_str,
           lv_salsdesc_var, ls_salesitm_str, lv_batchdesc_var,
           lv_reqstdesc_var, lv_pf_var.
  endloop.

  if cf_retcode = 0.
    perform set_print_param using    ls_addr_key
                            changing ls_control_param
                                     ls_composer_param
                                     ls_recipient
                                     ls_sender
                                     cf_retcode.
  endif.

  ls_composer_param-tdnewid = 'X'.

  " Certificação ------------------------------------------------------
  certificate_text       = 'processado por computador'.


  clear: land1, print_char, cert_id, xblnr.
  free: land1, print_char, cert_id, xblnr.

  " Certificação ------------------------------------------------------


  if cf_retcode = 0.
* determine smartform function module for delivery note
    call function 'SSF_FUNCTION_MODULE_NAME'
      exporting
        formname           = lf_formname
*       variant            = ' '
*       direct_call        = ' '
      importing
        fm_name            = lf_fm_name
      exceptions
        no_form            = 1
        no_function_module = 2
        others             = 3.
    if sy-subrc <> 0.
*   error handling
      cf_retcode = sy-subrc.
      perform protocol_update.
    endif.
  endif.

  if cf_retcode = 0.
*   call smartform delivery note

    ls_control_param-langu = 'P'.
    call function lf_fm_name
      exporting
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
      exceptions
        formatting_error    = 1
        internal_error      = 2
        send_error          = 3
        user_canceled       = 4
        others              = 5.
    if sy-subrc <> 0.
*   error handling
      cf_retcode = sy-subrc.
      perform protocol_update.
*     get SmartForm protocoll and store it in the NAST protocoll
      perform add_smfrm_prot.                  "INS_HP_335958
    endif.
  endif.

* get SmartForm protocoll and store it in the NAST protocoll
* PERFORM ADD_SMFRM_PROT.                       DEL_HP_335958

endform.                    "PROCESSING
