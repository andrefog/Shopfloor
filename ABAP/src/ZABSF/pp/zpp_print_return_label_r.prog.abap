*&---------------------------------------------------------------------*
*& Report ZPP_PRINT_RETURN_LABEL_R
*&---------------------------------------------------------------------*
*&Criado por: João Lopes
*&DATA:       30.03.2020
*&Descrição: F_LOG_004 - Impressão da etiqueta de devolução
*&---------------------------------------------------------------------*
report zpp_print_return_label_r.
"includes do programa
include rvadtabl.

"variáveis globais
data: gt_labels_tab type zpp_return_prod_label_tt.
*----------------------------------------------------------------------*
*       FORM ENTRY
*----------------------------------------------------------------------*
*       procedure for output prcessing
*----------------------------------------------------------------------*
*  -->  RETURN_CODE    : code for processing
*  -->  SCREEN_OUTPUT  : output on screen
*----------------------------------------------------------------------*
form entry using ef_return_code   type i
                 if_screen_output type c ##CALLED.

  "variáveis locais
  data: lv_formname     type tdsfname,
        lv_fm_name      type rs38l_fnam,
        ls_ctrparam_str type ssfctrlop,
        ls_soutputs_str type ssfcompop.

  "considerar apenas impressão
  if tnapr-nacha ne '1'.
    "sair do processamento
    return.
  endif.

  "nome do formulário
  lv_formname = tnapr-sform.
  "opções de output
  ls_soutputs_str-tddest = nast-ldest.
  "novo request de spool
  ls_soutputs_str-tdnewid = 'X'.
  "impressão imediata
  ls_soutputs_str-tdimmed = nast-dimme.
  "eliminar após saida
  ls_soutputs_str-tddelete = nast-delet.

  "nº de cópias
  if nast-anzal eq 0.
    ls_soutputs_str-tdcopies = '1'.
  else.
    ls_soutputs_str-tdcopies = nast-anzal.
  endif.

  "parametros de impressão
  ls_ctrparam_str-no_open = 'X'.
  ls_ctrparam_str-no_close = 'X'.
  ls_ctrparam_str-langu = nast-spras.
  ls_ctrparam_str-replangu1 = nast-spras.
  "ls_ctrparam_str-preview = abap_false.

  "obter nome do formulário
  call function 'SSF_FUNCTION_MODULE_NAME'
    exporting
      formname           = lv_formname
    importing
      fm_name            = lv_fm_name
    exceptions
      no_form            = 1
      no_function_module = 2
      others             = 3.
  if sy-subrc <> 0.
    "devolver id do erro
    ef_return_code = sy-subrc.
    "actualizar mensagem na NACE
    perform protocol_update using if_screen_output.
    "sair do processamento
    return.
  endif.

  "obter lotes
  perform get_batches.

  "abrir formulário
  call function 'SSF_OPEN'
    exporting
      user_settings      = abap_false
      output_options     = ls_soutputs_str
      control_parameters = ls_ctrparam_str
    exceptions
      formatting_error   = 1
      internal_error     = 2
      send_error         = 3
      user_canceled      = 4
      others             = 5.
  if sy-subrc <> 0.
    "devolver id do erro
    ef_return_code = sy-subrc.
    "actualizar mensagem na NACE
    perform protocol_update using if_screen_output.
    "sair do processamento
    return.
  endif.

  loop at gt_labels_tab into data(ls_labels).
    "invocar formulário
    call function lv_fm_name
      exporting
        control_parameters       = ls_ctrparam_str
        output_options           = ls_soutputs_str
        user_settings            = abap_false
        is_return_prod_label_str = ls_labels
      exceptions
        formatting_error         = 1
        internal_error           = 2
        send_error               = 3
        user_canceled            = 4
        others                   = 5.
    if sy-subrc ne 0.
      ef_return_code = sy-subrc.
      "actualizar mensagem na NACE
      perform protocol_update using if_screen_output.
      "sair do processamento
      return.
    endif.
    ls_soutputs_str-tdnewid   = abap_false.
  endloop.

  "encerrar formulário
  call function 'SSF_CLOSE'
    exceptions
      formatting_error = 1
      internal_error   = 2
      send_error       = 3
      others           = 4.
  if sy-subrc ne 0.
    ef_return_code = sy-subrc.
    "actualizar mensagem na NACE
    perform protocol_update using if_screen_output.
    "sair do processamento
    return.
  endif.
  ef_return_code = sy-subrc.
endform.

*---------------------------------------------------------------------*
*       FORM PROTOCOL_UPDATE                                          *
*---------------------------------------------------------------------*
*       save processing messages                                      *
*---------------------------------------------------------------------*
form protocol_update using if_screen_output type c.
  "actualização de mensagem na NACE
  check if_screen_output eq space.
  call function 'NAST_PROTOCOL_UPDATE'
    exporting
      msg_arbgb = syst-msgid
      msg_nr    = syst-msgno
      msg_ty    = syst-msgty
      msg_v1    = syst-msgv1
      msg_v2    = syst-msgv2
      msg_v3    = syst-msgv3
      msg_v4    = syst-msgv4
    exceptions
      others    = 1.
  if sy-subrc <> 0. endif.
endform.
"obter lotes
form get_batches.
  "varávies locais
  data: lv_document_var type mblnr,
        lv_docmyear_var type mjahr,
        lr_charname_rng type range of atnam,
        lv_charcomp_var type atnam,
        lv_charlarg_var type atnam,
        lv_matdescr_var type maktx,
        lv_pepelout_var type char24.

  "documento
  lv_document_var = nast-objky(10).
  "ano
  lv_docmyear_var = nast-objky+10(4).
  "obter os movimentos
  select *
    from mseg
    into table @data(lt_docmitems_tab)
     where mblnr eq @lv_document_var
       and mjahr eq @lv_docmyear_var
       and bwart eq '262'.
  if sy-subrc ne 0.
    "sair do processamento
    return.
  endif.
  "obter descrição dos materiais
  select *
    from makt
    into table @data(lt_matrdesc_tab)
    for all entries in @lt_docmitems_tab
      where matnr eq @lt_docmitems_tab-matnr
        and spras eq @sy-langu.
  "obter caracteristicas relevantes
  try.
      "nome
      zcl_bc_fixed_values=>get_ranges_value( exporting
                                               im_paramter_var = zcl_bc_fixed_values=>gc_charname_cst
                                               im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                             importing
                                               ex_valrange_tab = lr_charname_rng ).
    catch zcx_bc_exceptions.
  endtry.
  try.
      "comprimento
      zcl_bc_fixed_values=>get_single_value( exporting
                                               im_paramter_var = zcl_bc_fixed_values=>gc_charcomp_cst
                                               im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                             importing
                                               ex_prmvalue_var = data(lv_valuechr_var) ).
      "conversão de formatos
      lv_charcomp_var = lv_valuechr_var.
    catch zcx_bc_exceptions.
  endtry.
  try.
      "largura
      zcl_bc_fixed_values=>get_single_value( exporting
                                               im_paramter_var = zcl_bc_fixed_values=>gc_charlarg_cst
                                               im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                             importing
                                               ex_prmvalue_var = lv_valuechr_var ).
      "conversão de formatos
      lv_charlarg_var = lv_valuechr_var.
    catch zcx_bc_exceptions.
  endtry.
  "percorrer todos os items
  loop at lt_docmitems_tab into data(ls_msegline_str).
    "obter configuração do lote
    zcl_mm_classification=>get_classification_by_batch( exporting
                                                          im_material_var       = ls_msegline_str-matnr
                                                          im_lote_var           = ls_msegline_str-charg
                                                        importing
                                                          ex_classification_tab = data(lt_characts_tab) ).
    "descrição material
    loop at lt_characts_tab into data(ls_characts_str)
      where atnam in lr_charname_rng
        and ausp1 is not initial.
      "descrição do material
      lv_matdescr_var = ls_characts_str-ausp1.
      "sair do loop
      exit.
    endloop.

    if lv_matdescr_var is initial.
      "obter descrição do dado mestre
      lv_matdescr_var = cond #( when line_exists( lt_matrdesc_tab[ matnr = ls_msegline_str-matnr ] )
                                then lt_matrdesc_tab[ matnr = ls_msegline_str-matnr ]-maktx ).
    endif.
    "obter desc
    append value #( matnr = ls_msegline_str-matnr
                    maktx = lv_matdescr_var
                    met_comp = cond #( when line_exists( lt_characts_tab[ atnam = lv_charcomp_var ] )
                                       then lt_characts_tab[ atnam = lv_charcomp_var ]-ausp1 )
                    met_larg = cond #( when line_exists( lt_characts_tab[ atnam = lv_charlarg_var ] )
                                       then lt_characts_tab[ atnam = lv_charlarg_var ]-ausp1 )
                    menge = ls_msegline_str-menge
                    meins = ls_msegline_str-meins
                    pspnr = ls_msegline_str-mat_pspnr
                    batch = ls_msegline_str-charg ) to gt_labels_tab.
    "limpar variáveis
    clear: lv_matdescr_var.
  endloop.
  "obter descrição do material na caracteristica
endform.
