function zabsf_pp_stocks.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"     VALUE(IV_MATNR_VAR) TYPE  MATNR OPTIONAL
*"     VALUE(IV_PSPNR_VAR) TYPE  STRING OPTIONAL
*"     VALUE(IV_WERKS_VAR) TYPE  WERKS_D OPTIONAL
*"     VALUE(IV_PF_VAR) TYPE  STRING OPTIONAL
*"     VALUE(IV_MAT_DESC_VAR) TYPE  STRING OPTIONAL
*"     VALUE(IV_SEMIFIN_VAR) TYPE  BOOLE_D OPTIONAL
*"     VALUE(IV_FINISHED_VAR) TYPE  BOOLE_D OPTIONAL
*"  EXPORTING
*"     VALUE(ET_DATA_OUT_TAB) TYPE  ZPS_STOCKS_TT
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  data: ls_stocks_str     like line of et_data_out_tab,
        ex_data_aux_tab   like et_data_out_tab,
        lv_pspnr_conv_var type mspr-pspnr,
        ls_deposito_str   type zps_deposito_str,
        lt_deposito_str   type standard table of zps_deposito_str,
        lr_matnr_var      type range of matnr,
        ls_matnr_str      like line of lr_matnr_var,
        lr_pspnr_var      type range of mspr-pspnr,
        ls_pspnr_str      like line of lr_pspnr_var,
        lr_werks_var      type range of werks_d,
        ls_werks_str      like line of lr_werks_var,
        lr_pf_rng         type range of atwrt,
        lr_name_rng       type range of atwrt,
        lv_pspnr_var      type string.

  data: lr_mart_rng type range of mtart,
        lr_fert_rng type range of mtart,
        lr_halb_rng type range of mtart.


  "criar range tipos de materiais
  try.
      "semi-acabados
      if iv_semifin_var eq abap_true.
        call method zcl_bc_fixed_values=>get_ranges_value
          exporting
            im_paramter_var = zcl_bc_fixed_values=>gc_semiacab_cst
            im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
          importing
            ex_valrange_tab = lr_halb_rng.
      endif.

      "produto acabado
      if iv_finished_var eq abap_true.
        call method zcl_bc_fixed_values=>get_ranges_value
          exporting
            im_paramter_var = zcl_bc_fixed_values=>gc_prodacab_cst
            im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
          importing
            ex_valrange_tab = lr_fert_rng.
      endif.
      "criar range final
      append lines of lr_halb_rng to lr_mart_rng.
      append lines of lr_fert_rng to lr_mart_rng.

    catch zcx_pp_exceptions into data(lo_bcexceptions_obj).
      "mostrar mensagem de erro
      "falta configuração
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = lo_bcexceptions_obj->msgty
          msgno      = lo_bcexceptions_obj->msgno
          msgid      = lo_bcexceptions_obj->msgid
          msgv1      = lo_bcexceptions_obj->msgv1
          msgv2      = lo_bcexceptions_obj->msgv2
          msgv3      = lo_bcexceptions_obj->msgv3
          msgv4      = lo_bcexceptions_obj->msgv4
        changing
          return_tab = return_tab.
      return.
  endtry.


  refresh et_data_out_tab.

  call function 'CONVERSION_EXIT_ABPSP_INPUT'
    exporting
      input  = iv_pspnr_var
    importing
      output = lv_pspnr_conv_var.

******Obter caracteristicas para    =>       PF
  try.
      "obter valores da configuração
      zcl_bc_fixed_values=>get_ranges_value( exporting
                                               im_paramter_var = zcl_bc_fixed_values=>gc_coois_pf_cst
                                               im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                             importing
                                               ex_valrange_tab = lr_pf_rng ).

    catch zcx_pp_exceptions into data(lo_excpetion_obj).  ##NEEDED
      "falta configuração
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = lo_excpetion_obj->msgty
          msgno      = lo_excpetion_obj->msgno
          msgid      = lo_excpetion_obj->msgid
          msgv1      = lo_excpetion_obj->msgv1
          msgv2      = lo_excpetion_obj->msgv2
          msgv3      = lo_excpetion_obj->msgv3
          msgv4      = lo_excpetion_obj->msgv4
        changing
          return_tab = return_tab.
      return.
  endtry.


  try.
      "obter valores da configuração descritivo de material
      zcl_bc_fixed_values=>get_ranges_value( exporting
                                               im_paramter_var = zcl_bc_fixed_values=>gc_charname_cst
                                               im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                             importing
                                               ex_valrange_tab = lr_name_rng ).

    catch zcx_pp_exceptions into lo_excpetion_obj.  ##NEEDED
      "falta configuração
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = lo_excpetion_obj->msgty
          msgno      = lo_excpetion_obj->msgno
          msgid      = lo_excpetion_obj->msgid
          msgv1      = lo_excpetion_obj->msgv1
          msgv2      = lo_excpetion_obj->msgv2
          msgv3      = lo_excpetion_obj->msgv3
          msgv4      = lo_excpetion_obj->msgv4
        changing
          return_tab = return_tab.
      return.
  endtry.


  if iv_matnr_var is not initial.
    ls_matnr_str-low = iv_matnr_var.
    ls_matnr_str-option = 'EQ'.
    ls_matnr_str-sign = 'I'.
    append ls_matnr_str to lr_matnr_var.
  endif.

  if lv_pspnr_conv_var is not initial.
    ls_pspnr_str-low = lv_pspnr_conv_var.
    ls_pspnr_str-option = 'EQ'.
    ls_pspnr_str-sign = 'I'.
    append ls_pspnr_str to lr_pspnr_var.
  endif.

  if iv_werks_var is not initial.
    ls_werks_str-low = iv_werks_var.
    ls_werks_str-option = 'EQ'.
    ls_werks_str-sign = 'I'.
    append ls_werks_str to lr_werks_var.
  endif.


  select mspr~charg, mspr~lgort, mspr~matnr, mspr~prlab, mspr~pspnr,
         mara~meins
    from mspr as mspr
    inner join mara as mara
    on mara~matnr eq mspr~matnr
    into table @data(lt_mspr_tab)
    where       mspr~matnr in @lr_matnr_var and
                mspr~pspnr in @lr_pspnr_var and
                mspr~werks in @lr_werks_var and
                mara~mtart in @lr_mart_rng and
                mspr~prlab gt 0.
  .
  if sy-subrc = 0.


*****Seleccionar depósitos a processar a partir do centro
    select lgort from zpp_deposit_tab into table @data(lt_lgort_tab)
      where werks in @lr_werks_var.
    if sy-subrc = 0.

      loop at lt_mspr_tab     into data(ls_mspr_str).

****Validação de deposito
        read table lt_lgort_tab with key lgort = ls_mspr_str-lgort transporting no fields.
        if sy-subrc = 0.

*****Obter e validar PEP
          if ls_mspr_str-charg is not initial
            and ls_mspr_str-matnr is not initial.

            "obter classificação do lote
            zcl_mm_classification=>get_classification_by_batch( exporting
                                                                  im_material_var       = ls_mspr_str-matnr
                                                                  im_lote_var           = ls_mspr_str-charg
                                                                  im_shownull_var       = abap_true
                                                                importing
                                                                  ex_classification_tab = data(lt_charact_tab)
                                                                  ex_class_tab          = data(lt_class_tab) ).

            loop at lt_charact_tab into data(ls_characct_str)
                                      where atnam in lr_pf_rng.
            endloop.


******Validação por valor de PF
*            IF ls_characct_str-ausp1 EQ iv_pf_var
            if ls_characct_str-ausp1 cs iv_pf_var
              or iv_pf_var is initial.

*****PF
              ls_stocks_str-pf = ls_characct_str-ausp1.


*****Validação para a descrição do material
*****descrição do material

              clear ls_characct_str-ausp1.
              loop at lt_charact_tab into ls_characct_str
                                        where atnam in lr_name_rng.


                ls_stocks_str-descricao = ls_characct_str-ausp1.

              endloop.

*        if ls_characct_str-ausp1 EQ IV_MAT_DESC_VAR
              if ls_characct_str-ausp1 cs iv_mat_desc_var
                    or iv_mat_desc_var is initial.




*****MATERIAL
                ls_stocks_str-material = ls_mspr_str-matnr.

*****Unidade de medida

                ls_stocks_str-meins = ls_mspr_str-meins.

******Deposito

                ls_deposito_str-quantidade    = ls_mspr_str-prlab.
                ls_deposito_str-lote          = ls_mspr_str-charg.
                ls_deposito_str-deposito      = ls_mspr_str-lgort.

                select single lgobe from t001l into @data(lv_lgobe_var)
                  where werks = @iv_werks_var and
                        lgort = @ls_mspr_str-lgort.
                if sy-subrc = 0.
                  ls_deposito_str-deposito_desc = lv_lgobe_var.
                endif.
                append ls_deposito_str to ls_stocks_str-deposito.
*****quantidade
****lote



***Projecto + PEP
                if ls_mspr_str-pspnr is not initial.
                  select single psphi from prps where pspnr = @ls_mspr_str-pspnr into @data(lv_psphi_var).
                  if sy-subrc = 0.
                    ls_stocks_str-projecto = lv_psphi_var.
                    "projecto
                    call function 'CONVERSION_EXIT_KONPD_OUTPUT'
                      exporting
                        input  = lv_psphi_var
                      importing
                        output = ls_stocks_str-out_projecto.

                  endif.

******PEP de entrada
                  clear lv_pspnr_var.
                  call function 'CONVERSION_EXIT_ABPSP_OUTPUT'
                    exporting
                      input  = ls_mspr_str-pspnr
                    importing
                      output = ls_stocks_str-out_pep.

                  ls_stocks_str-pep = ls_mspr_str-pspnr.

*****Se não foi inserido pep como parametro, é necessário converter os 2 valores


                endif.

                append ls_stocks_str to et_data_out_tab.

                clear ls_stocks_str.
                refresh ls_stocks_str-deposito.


*****VAlidação por descrição do material
              endif.

****Validação por PF
            endif.

*****Se tivermos lote e material
          endif.

*****Validação de deposito
        endif.

****Loop aos dados da mspr
      endloop.

***zpp_deposit_tab => Selecção de depositos
    endif.



***    mspr
  endif.



******Junção de deposito para o mesmo header (Projecto, PEP, PF, MAT, descrição)
  refresh ex_data_aux_tab.
  loop at et_data_out_tab into data(ls_data_str).

    read table ex_data_aux_tab with key projecto  =  ls_data_str-projecto
                                        pep       = ls_data_str-pep
                                        pf        = ls_data_str-pf
                                        material  = ls_data_str-material
                                        descricao = ls_data_str-descricao
                        assigning field-symbol(<fs_data_aux_str>).
    if sy-subrc = 0.
****adicionar nova linha de deposito
      append lines of ls_data_str-deposito to <fs_data_aux_str>-deposito.

    else.
**  adicionar nova linha total
      append ls_data_str to ex_data_aux_tab.

    endif.

  endloop.

  et_data_out_tab[] = ex_data_aux_tab[].

endfunction.
