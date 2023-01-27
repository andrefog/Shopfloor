class ZCL_ABSF_MOB definition
  public
  final
  create public .

public section.

  types:
    TY_BATCHES_RNG type RANGE OF CHARG_d .

  class-methods PRINT_TRANSFER_LABEL
    importing
      !IT_RETURN_REC_LABEL type ZPP_RETURN_REC_LABEL_TT
      !IM_PRINTER_VAR type RSPOPNAME
    exporting
      !ET_RETURN_TAB type BAPIRET2_T .
  class-methods GET_RECEIVED_QUANTITY
    importing
      !IM_VALEBELN_VAR type EBELN
      !IM_VALEBELP_VAR type EBELP
    exporting
      !EX_QUANTITY_VAR type MENGE_D .
  class-methods PRINT_MOVEMENTS_LABEL
    importing
      !IM_RC_TRANS_VAR type BOOLE_D optional
      !IM_DEVOLUCAO_VAR type BOOLE_D optional
      !IM_DOCNUMBER_VAR type MBLNR
      !IM_DOCYEAR_VAR type MJAHR
      !IM_BATCH_RNG type TY_BATCHES_RNG optional
      !IM_PRINTER_VAR type RSPOPNAME
    changing
      !CH_RETURN_TAB type BAPIRET2_T .
  class-methods CHECK_HU_AND_DELIVERY
    importing
      !IM_HUNUMBER_VAR type VENUM
      !IM_DELIVERY_VAR type VBELN_VL
    exporting
      !ET_RETURN_TAB type BAPIRET2_T .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ABSF_MOB IMPLEMENTATION.


  method check_hu_and_delivery.
    "variáveis locais
    data: lv_uechaini_var type posnr,
          lv_delivery_var type vbeln_vl.

    "limpar variáveis de exportação
    refresh et_return_tab.

    "verficar se HU está atribuida a uma delivery
    select single *
      from vekp
      into @data(ls_vekp_str)
        where venum eq @im_hunumber_var.
    if sy-subrc eq 0 and ls_vekp_str-vbeln_gen is not initial.
      " HU &1 está atribuida à guia &2
      call method zabsf_mob_cl_log=>add_message
        exporting
          msgty      = 'E'
          msgno      = 014
          msgv1      = ls_vekp_str-exidv
          msgv2      = ls_vekp_str-vbeln_gen
        changing
          return_tab = et_return_tab.
      "sair do processamento
      return.
    endif.
    "obter items da HU
    select *
      from vepo
      into table @data(lt_husitems_tab)
        where venum eq @im_hunumber_var.

    "obter items 'pai' da delivery
    select *
      from lips
      into table @data(lt_delivitm_tab)
        where vbeln eq @im_delivery_var
          and uecha eq @lv_uechaini_var.

    "percorrer todos os items da hu
    loop at lt_husitems_tab assigning field-symbol(<fs_delivitm_str>).
      if not line_exists( lt_delivitm_tab[ matnr = <fs_delivitm_str>-matnr ] ).
        <fs_delivitm_str>-matnr = | { <fs_delivitm_str>-matnr ALPHA = OUT } |.
        lv_delivery_var = im_delivery_var.
        lv_delivery_var = | { lv_delivery_var ALPHA = OUT } |.

        "Material &1 não existe na Guia &2
        call method zabsf_mob_cl_log=>add_message
          exporting
            msgty      = 'E'
            msgno      = 011
            msgv1      = <fs_delivitm_str>-matnr
            msgv2      = lv_delivery_var
*            msgv1      = conv #( <fs_delivitm_str>-matnr )
*            msgv2      = conv #( im_delivery_var )
          changing
            return_tab = et_return_tab.
        "sair do processamento
        return.
      endif.
    endloop.
  endmethod.


  method get_received_quantity.
    "limpar variáveis de exportação
    clear ex_quantity_var.
    "obter as entradas de mercadoria
    select *
      from ekbe
      into table @data(lt_goodrecp_tab)
        where ebeln eq @im_valebeln_var
          and ebelp eq @im_valebelp_var
          "and bwart eq @gc_mvmtrecp_cst
          and bewtp eq 'E'.
    "percorrer listas das recpções
    loop at lt_goodrecp_tab assigning field-symbol(<fs_goodrecp_str>).
      "entrada de mercadoria
      if <fs_goodrecp_str>-shkzg eq 'S'.
        "somar quantidades
        ex_quantity_var = ex_quantity_var + <fs_goodrecp_str>-menge.
      endif.
      "estorno
      if <fs_goodrecp_str>-shkzg eq 'H'.
        "subtrair quantidades
        ex_quantity_var = ex_quantity_var - <fs_goodrecp_str>-menge.
      endif.
    endloop.

  endmethod.


  method print_movements_label.
    "constantes
    constants lc_job_name type btcjob value 'ZPP_PRINT_MOVMTS_R'.
    "variáveis locais
    data: lv_job_nr          type btcjobcnt,
          lv_job_released(1),
          lr_label_rng       type range of int4.

    "criar job
    call function 'JOB_OPEN'
      exporting
        jobname          = lc_job_name
      importing
        jobcount         = lv_job_nr
      exceptions
        cant_create_job  = 1
        invalid_job_data = 2
        jobname_missing  = 3
        others           = 4.
    if syst-subrc ne 0.
      "erro ao abrir job
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgid      = sy-msgid
          msgty      = sy-msgty
          msgno      = sy-msgno
          msgv1      = sy-msgv1
          msgv2      = sy-msgv2
          msgv3      = sy-msgv3
          msgv4      = sy-msgv4
        changing
          return_tab = ch_return_tab.
      "sair do processamento
      return.
    endif.

    "submit ao programa de impressão
    submit (lc_job_name)
      with p_copies eq '1'
      with p_prewin eq abap_false
      with p_printr eq im_printer_var
      with p_langu  eq sy-langu
      with rb_rectr eq im_rc_trans_var
      with rb_dev   eq im_devolucao_var

      with p_mblnr eq im_docnumber_var
      with p_mjahr eq im_docyear_var
      with so_batch in im_batch_rng[]
        via job lc_job_name number lv_job_nr and return.

    if sy-subrc ne 0.
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgid      = sy-msgid
          msgty      = sy-msgty
          msgno      = sy-msgno
          msgv1      = sy-msgv1
          msgv2      = sy-msgv2
          msgv3      = sy-msgv3
          msgv4      = sy-msgv4
        changing
          return_tab = ch_return_tab.
      "sair do processamento
      return.
    endif.
    "encerrar job
    call function 'JOB_CLOSE'
      exporting
        jobcount             = lv_job_nr
        jobname              = lc_job_name
        strtimmed            = 'X'
      importing
        job_was_released     = lv_job_released
      exceptions
        cant_start_immediate = 1
        invalid_startdate    = 2
        jobname_missing      = 3
        job_close_failed     = 4
        job_nosteps          = 5
        job_notex            = 6
        lock_failed          = 7
        others               = 8.
    if sy-subrc ne 0.
      "erro ao encerrar o job
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgid      = sy-msgid
          msgty      = sy-msgty
          msgno      = sy-msgno
          msgv1      = sy-msgv1
          msgv2      = sy-msgv2
          msgv3      = sy-msgv3
          msgv4      = sy-msgv4
        changing
          return_tab = ch_return_tab.
    endif.
  endmethod.


  method print_transfer_label.
    "constantes locais
    constants: lc_formname_cst type tdsfname value 'ZPP_RETURN_REC_LABEL'.

    "variáveis locais
    data: lv_language_var  type spras,
          lv_nmcopies_var  type int1,
          lv_ppreview_var  type flag1,
          lv_vazament_var  type atnam,
          lv_sequendr_var  type atnam,
          lv_comprimt_var  type atnam,
          lv_clargura_var  type atnam,
          lr_espessura_rng type range of atnam,
          lv_funcname_var  type rs38l_fnam,
          ls_soutputs_str  type ssfcompop,
          ls_ctrparam_str  type ssfctrlop.

    data(lt_reclabls_tab) = it_return_rec_label.

    "obter caracteristicas da configuração
    try.
        "comprimento
        zcl_bc_fixed_values=>get_single_value( exporting
                                                 im_paramter_var = zcl_bc_fixed_values=>gc_charcomp_cst
                                                 im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                               importing
                                                 ex_prmvalue_var = data(lv_valuechr_var) ).
        "conversão de formatos
        lv_comprimt_var = lv_valuechr_var.
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
        lv_clargura_var = lv_valuechr_var.
      catch zcx_bc_exceptions.
    endtry.
    try.
        "vazamento
        zcl_bc_fixed_values=>get_single_value( exporting
                                                 im_paramter_var = zcl_bc_fixed_values=>gc_charvaza_cst
                                                 im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                               importing
                                                 ex_prmvalue_var = lv_valuechr_var ).
        "conversão de formatos
        lv_vazament_var = lv_valuechr_var.
      catch zcx_bc_exceptions.
    endtry.
    try.
        "sequenciador
        zcl_bc_fixed_values=>get_single_value( exporting
                                                 im_paramter_var = zcl_bc_fixed_values=>gc_charseq_cst
                                                 im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                               importing
                                                 ex_prmvalue_var = lv_valuechr_var ).
        "conversão de formatos
        lv_sequendr_var = lv_valuechr_var.
      catch zcx_bc_exceptions.
    endtry.
    try.

        "espessura
        zcl_bc_fixed_values=>get_ranges_value( exporting
                                                 im_paramter_var = zcl_bc_fixed_values=>gc_charesp_cst
                                                 im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                               importing
                                                 ex_valrange_tab = lr_espessura_rng ).
      catch zcx_bc_exceptions.
    endtry.

    "limpar variáveis de exportação
    refresh et_return_tab.
    lv_nmcopies_var = '1'.
    "obter classificação do lote
    zcl_mm_classification=>get_classification_by_batch( exporting
                                                          im_material_var       = it_return_rec_label[ 1 ]-matnr
                                                          im_lote_var           = it_return_rec_label[ 1 ]-charg
                                                        importing
                                                          ex_classification_tab = data(lt_characts_tab) ).

    read table lt_reclabls_tab assigning field-symbol(<fs_reclabls_str>) index 1.
    if <fs_reclabls_str> is not assigned.
      "sair do processamento
      return.
    endif.
    "vazamento
    read table lt_characts_tab into data(ls_charats_str) with key atnam = lv_vazament_var.
    <fs_reclabls_str>-vazam = ls_charats_str-ausp1.
    clear ls_charats_str.
    "sequenciador
    read table lt_characts_tab into ls_charats_str with key atnam = lv_sequendr_var.
    <fs_reclabls_str>-sequenc = ls_charats_str-ausp1.
    clear ls_charats_str.
    "comprimento
    read table lt_characts_tab into ls_charats_str with key atnam = lv_comprimt_var.
    <fs_reclabls_str>-comprim = ls_charats_str-ausp1.
    clear ls_charats_str.
    "largura
    read table lt_characts_tab into ls_charats_str with key atnam = lv_clargura_var.
    <fs_reclabls_str>-largura = ls_charats_str-ausp1.
    clear ls_charats_str.
    "espessura
    loop at lt_characts_tab into ls_charats_str
      where atnam in lr_espessura_rng
        and ausp1 is not initial.
      "espessura
      <fs_reclabls_str>-espessu = ls_charats_str-ausp1.
      "sair do loop
      exit.
    endloop.
    "descrição do material
    zcl_mm_classification=>get_material_desc_by_batch( exporting
                                                         im_material_var    = <fs_reclabls_str>-matnr
                                                         im_batch_var       = <fs_reclabls_str>-charg
                                                       importing
                                                         ex_description_var = data(lv_descript_var) ).
    "descrição do material
    <fs_reclabls_str>-maktx = lv_descript_var.
    if <fs_reclabls_str>-maktx is initial.
      "obter descrição dos dados mestre
      select single maktx
        from makt
        into @<fs_reclabls_str>-maktx
          where matnr eq @<fs_reclabls_str>-matnr
            and spras eq @sy-langu.
    endif.
    "obter nome do formulário
    call function 'SSF_FUNCTION_MODULE_NAME'
      exporting
        formname           = lc_formname_cst
      importing
        fm_name            = lv_funcname_var
      exceptions
        no_form            = 1
        no_function_module = 2
        others             = 3.

    if sy-subrc <> 0.
      "Erro ao obter nome do formulário
      call method zabsf_mob_cl_log=>add_message
        exporting
          msgty      = 'E'
          msgno      = '004'
        changing
          return_tab = et_return_tab.
    endif.

    "opções de output
    ls_soutputs_str-tddest   = im_printer_var.
    ls_soutputs_str-tdnewid  = abap_true.
    ls_soutputs_str-tdimmed  = abap_true.
    ls_soutputs_str-tdnoprev = abap_true.
    ls_soutputs_str-tdcopies = lv_nmcopies_var.

    ls_ctrparam_str-no_dialog = abap_true.

    ls_ctrparam_str-no_open   = abap_true.
    ls_ctrparam_str-no_close  = abap_true.
    ls_ctrparam_str-langu     = sy-langu.
    ls_ctrparam_str-replangu1 = sy-langu.
    ls_soutputs_str-tdnewid   = abap_true.

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
    if sy-subrc ne 0.
      "Erro ao abrir formulário
      call method zabsf_mob_cl_log=>add_message
        exporting
          msgty      = 'E'
          msgno      = '003'
        changing
          return_tab = et_return_tab.
      "sair do processamento
      return.
    endif.

    "invocar formulário
    call function lv_funcname_var
      exporting
        control_parameters  = ls_ctrparam_str
        output_options      = ls_soutputs_str
        user_settings       = abap_false
        is_retrec_label_str = <fs_reclabls_str>
      exceptions
        formatting_error    = 1
        internal_error      = 2
        send_error          = 3
        user_canceled       = 4
        others              = 5.
    if sy-subrc ne 0.
    endif.
    "encerrar formulário
    call function 'SSF_CLOSE'
      exceptions
        formatting_error = 1
        internal_error   = 2
        send_error       = 3
        others           = 4.
    if sy-subrc ne 0.
      "Erro ao encerrar o formulário
      call method zabsf_mob_cl_log=>add_message
        exporting
          msgty      = 'E'
          msgno      = '005'
        changing
          return_tab = et_return_tab.
      "sair do processamento
      return.
    endif.
  endmethod.
ENDCLASS.
