 function zabsf_mob_add_btch_to_delivery .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(INPUTOBJ) TYPE  ZABSF_MOB_S_INPUTOBJECT
*"     VALUE(IV_VBELN) TYPE  VBELN_VL
*"     VALUE(IV_CHARG) TYPE  CHARG_D
*"     VALUE(IV_MATNR) TYPE  MATNR
*"     VALUE(IV_QTY) TYPE  LFIMG
*"     VALUE(IV_MEINS) TYPE  MEINS
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
   "tipos
   types: begin of ty_itab.
       include type lips.
   types:   kosta type kosta.
   types: end of ty_itab.

   "variáveis locais
   data: lt_return     type table of bapiret2,
         ls_return     type          bapiret2,
         ls_vbkok      type          vbkok,
         lt_prot       type table of prott,
         ls_prot       type          prott,
         lt_rehang     type table of hum_rehang_hu,
         ls_vbkok2_str type vbpok,
         lt_vbpok      type table of vbpok.

   data: ls_header_data      type bapiobdlvhdrchg,
         ls_header_control   type bapiobdlvhdrctrlchg,
         ls_control          type bapidlvcontrol,
         lt_item_data        type table of bapiobdlvitemchg,
         lt_item_ctrl        type table of bapiobdlvitemctrlchg,
         lt_item_data_spl    type table of  /spe/bapiobdlvitemchg,
         lv_errorflg_var     type boole_d,
         lt_lips             type table of ty_itab,
         lr_delivprj_rng     type range of lfart,
         lr_delivsls_rng     type range of lfart,
         lr_delivtrf_rng     type range of lfart,
         lr_matsconf_rng     type range of mtart,
         lv_uecha_var        type posnr,
         lv_resbdesc_var     type atwrt,
         lv_addparent_var    type boole_d,
         lv_splitbatch_var   type boole_d,
         lv_pickedqtt_var    type pikmg,
         lv_batchstrg_var    type lgort_d,
         lv_chang_strg_var   type boole_d,
         lv_convert_unit_var type boole_d.

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
       "tipos de materiais configuráveis
       call method zcl_bc_fixed_values=>get_ranges_value
         exporting
           im_paramter_var = zcl_bc_fixed_values=>gc_expedmats_cst
           im_modulesp_var = zcl_bc_fixed_values=>gc_salesmod_cst
           im_werksval_var = inputobj-werks
         importing
           ex_valrange_tab = lr_matsconf_rng.

       "tipos de guias criadas a partir pedidos de transferência
       call method zcl_bc_fixed_values=>get_ranges_value
         exporting
           im_paramter_var = zcl_bc_fixed_values=>gc_exp_doc_transf
           im_modulesp_var = zcl_bc_fixed_values=>gc_salesmod_cst
         importing
           ex_valrange_tab = lr_delivtrf_rng.

       "depósito dos lotes
       call method zcl_bc_fixed_values=>get_single_value
         exporting
           im_paramter_var = zcl_bc_fixed_values=>gc_exped_bacth_strg_cst
           im_modulesp_var = zcl_bc_fixed_values=>gc_salesmod_cst
           im_werksval_var = inputobj-werks
         importing
           ex_prmvalue_var = data(lv_valstorage_var).
       lv_batchstrg_var = lv_valstorage_var.

     catch zcx_bc_exceptions into data(lo_bcexceptions_obj).
       "falta configuração
       call method zabsf_mob_cl_log=>add_message
         exporting
           msgty      = lo_bcexceptions_obj->msgty
           msgno      = lo_bcexceptions_obj->msgno
           msgid      = lo_bcexceptions_obj->msgid
           msgv1      = lo_bcexceptions_obj->msgv1
           msgv2      = lo_bcexceptions_obj->msgv2
           msgv3      = lo_bcexceptions_obj->msgv3
           msgv4      = lo_bcexceptions_obj->msgv4
         changing
           return_tab = et_return.
       "sair do processamento
       return.
   endtry.

   "adicionar leading zeros
   iv_charg = |{ iv_charg alpha = in }|.
   iv_matnr = |{ iv_matnr alpha = in }|.

   "obter os items 'pai'
   select lips~vbeln, lips~posnr, lips~meins, lips~matnr, lips~rsnum, lips~rspos, lips~vgbel,
     lips~vgpos, lips~umvkn, lips~umvkz, lips~vrkme, lips~werks, lips~charg, lips~lfimg,
     vbup~kosta,
     likp~lfart, mara~mtart
     from lips as lips
     inner join likp as likp
      on likp~vbeln eq lips~vbeln
     inner join vbup as vbup
     on vbup~vbeln eq lips~vbeln and vbup~posnr eq lips~posnr
     inner join mara as mara
      on mara~matnr eq lips~matnr
     into table @data(lt_delivitems_tab)
    where lips~vbeln = @iv_vbeln
      and lips~matnr = @iv_matnr
      and lips~werks = @inputobj-werks
      and lips~uecha = @lv_uecha_var.

   if lt_delivitems_tab is initial.
     "Guia sem item correspondente para lote &1
     call method zabsf_mob_cl_log=>add_message
       exporting
         msgty      = 'E'
         msgno      = '015'
         msgv1      = iv_charg
       changing
         return_tab = et_return.
     return.
   endif.

   "dados cabeçalho
   ls_header_data-deliv_numb    = iv_vbeln.
   ls_header_control-deliv_numb = iv_vbeln.
   "control
   ls_control-upd_ind = abap_true.

   "obter dados da reserva
   select *
     from resb
     into table @data(lt_resbtabl_tab)
     for all entries in @lt_delivitems_tab
       where rsnum eq @lt_delivitems_tab-rsnum
         and rspos eq @lt_delivitems_tab-rspos.

   "obter dados ordem de venda
   select *
     from vbap
     into table @data(lt_salesitm_tab)
   for all entries in @lt_delivitems_tab
     where vbeln eq @lt_delivitems_tab-vgbel
       and posnr eq @lt_delivitems_tab-vgpos.

   "obter dados do pedido de transferência
   select *
     from ekpo
     into table @data(lt_purchase_tab)
      for all entries in @lt_delivitems_tab
       where ebeln eq @lt_delivitems_tab-vgbel.


   loop at lt_delivitems_tab into data(ls_delivitm_str).
     "verificar se é para alterar depósito
     if ls_delivitm_str-lfart in lr_delivprj_rng.
       lv_chang_strg_var = abap_true.
     endif.
     "verificar se é para converter unidades
*     if ls_delivitm_str-lfart in lr_delivtrf_rng
*       and iv_meins eq 'UN'.
*       lv_convert_unit_var = abap_true.
*     endif.
     "forcar a conversão de unidades
     if iv_meins eq 'UN'.
       "conversão de unidades
       lv_convert_unit_var = abap_true.
     endif.
     "verficar se o lote é igual
     if ls_delivitm_str-charg eq iv_charg.
       "obter quantidade com picking feito
       call function 'WB2_GET_PICK_QUANTITY'
         exporting
           i_vbeln             = ls_delivitm_str-vbeln
           i_posnr             = ls_delivitm_str-posnr
         importing
           e_pikmg             = lv_pickedqtt_var
         exceptions
           document_read_error = 1
           others              = 2.
       if sy-subrc <> 0.
*         call method zabsf_mob_cl_log=>add_message
*           exporting
*             msgty      = sy-msgty
*             msgno      = sy-msgno
*             msgid      = sy-msgid
*             msgv1      = sy-msgv1
*             msgv2      = sy-msgv2
*             msgv3      = sy-msgv3
*             msgv4      = sy-msgv4
*           changing
*             return_tab = et_return.
*         "sair do processamento
*         return.
       endif.

       if iv_meins ne ls_delivitm_str-meins.
         "verificar se é para converter unidades
         if lv_convert_unit_var eq abap_true.
           "converter para unidades
           zabsf_pp_cl_tracking=>convert_to_meins( exporting
                                                     im_qttyunit_var = conv #( iv_qty )
                                                     im_meins_var    = ls_delivitm_str-meins
                                                     im_material_var = iv_matnr
                                                     im_batchnum_var = iv_charg
                                                   importing
                                                     ex_quantity_var = data(lv_quantity_var)
                                                     et_return_tab   = et_return ).
           if et_return is not initial.
             "sair do processamento
             return.
           endif.
           "esmagar qtd
           iv_qty = lv_quantity_var.
         else.
           "Unidade &1 da etiqueta é diferente. Esperado &2
           call method zabsf_mob_cl_log=>add_message
             exporting
               msgty      = 'E'
               msgno      = '016'
               msgv1      = iv_meins
               msgv2      = ls_delivitm_str-meins
             changing
               return_tab = et_return.
           "sair do processamento
           return.
         endif.
       endif.

       "verificar quantidades
       if iv_qty gt ( ls_delivitm_str-lfimg - lv_pickedqtt_var ).
         "Material &1 qtd. na etiqueta (&2) excede a qtd restante da guia (&3)
         call method zabsf_mob_cl_log=>add_message
           exporting
             msgty      = 'E'
             msgno      = '017'
             msgv1      = ls_delivitm_str-matnr
             msgv2      = iv_qty
             msgv3      = ls_delivitm_str-lfimg - lv_pickedqtt_var
           changing
             return_tab = et_return.
         "sair do processamento
         return.
       endif.

       "adicionar item pai à lista de items a alterar
       append value #( deliv_numb      = iv_vbeln
                       deliv_item      = ls_delivitm_str-posnr
                       material        = ls_delivitm_str-matnr
                       fact_unit_denom = ls_delivitm_str-umvkn
                       fact_unit_nom   = ls_delivitm_str-umvkz
                       sales_unit      = ls_delivitm_str-vrkme
                       sales_unit_iso  = ls_delivitm_str-vrkme
                       batch           = ls_delivitm_str-charg
                       base_uom        = ls_delivitm_str-meins
                       base_uom_iso    = ls_delivitm_str-meins ) to lt_item_data.

       "estrutura dados de control
       append value #( deliv_numb = iv_vbeln
                       deliv_item = ls_delivitm_str-posnr ) to lt_item_ctrl.

       "mudar o depósito do item pai
       append value #( deliv_numb = iv_vbeln
                       deliv_item = ls_delivitm_str-posnr
                       stge_loc   =  cond #( when lv_chang_strg_var eq abap_true
                                             then lv_batchstrg_var  ) ) to lt_item_data_spl.
     else.
       "verificar se o material é configurável
       if ls_delivitm_str-mtart in lr_matsconf_rng."todos estes materais são geridos a lote
         "verificar se guia é de projecto
         if ls_delivitm_str-lfart in lr_delivprj_rng.
           "obter dados da reserva
           read table lt_resbtabl_tab into data(ls_reservat_str) with key rsnum = ls_delivitm_str-rsnum
                                                                          rspos = ls_delivitm_str-rspos.
           if sy-subrc eq 0.
             "obter descrição do material pela reserva
             zcl_mm_classification=>get_desc_as_co02( exporting
                                                        im_resb_str        = ls_reservat_str
                                                      importing
                                                        ex_description_var = data(lv_co02desc_var) ).
             if lv_co02desc_var is initial.
               "material &1 sem descrição na reserva
               call method zabsf_mob_cl_log=>add_message
                 exporting
                   msgty      = 'E'
                   msgno      = '010'
                   msgv1      = ls_delivitm_str-matnr
                 changing
                   return_tab = et_return.
               "sair do processamento
               return.
             endif.
             "alterar descrição
             lv_resbdesc_var = lv_co02desc_var.
           endif.
         endif.
         "verificar se guia é de ordem de venda
         if ls_delivitm_str-lfart in lr_delivsls_rng.
           "obter dados da ordem de venda
           read table lt_salesitm_tab into data(ls_salesitm_str) with key vbeln = ls_delivitm_str-vgbel
                                                                          posnr = ls_delivitm_str-vgpos.
           if sy-subrc eq 0.
             "obter valor a partir da configuração
             zcl_mm_classification=>get_material_desc_by_object( exporting
                                                                   im_cuobj_var       = ls_salesitm_str-cuobj
                                                                 importing
                                                                   ex_description_var = data(lv_salsdesc_var) ).
             if lv_salsdesc_var is initial.
               "Material &1 sem descrição na ordem de venda &2
               call method zabsf_mob_cl_log=>add_message
                 exporting
                   msgty      = 'E'
                   msgno      = '018'
                   msgv1      = ls_delivitm_str-matnr
                   msgv2      = ls_delivitm_str-vgbel
                 changing
                   return_tab = et_return.
               "sair do processamento
               return.
             endif.
             "alterar descrição
             lv_resbdesc_var = lv_salsdesc_var.
           endif.
         endif.
         "verificar se guia é de transferência
         if ls_delivitm_str-lfart in lr_delivtrf_rng.
           "obter dados do pedido
           read table lt_purchase_tab into data(ls_purchase_str) with key ebeln = ls_delivitm_str-vgbel
                                                                          ebelp = ls_delivitm_str-vgpos.
           if sy-subrc eq 0.
             "obter valor a partir da configuração
             zcl_mm_classification=>get_material_desc_by_object( exporting
                                                                   im_cuobj_var       = ls_purchase_str-cuobj
                                                                 importing
                                                                   ex_description_var = data(lv_ekpodesc_var) ).
             if lv_ekpodesc_var is initial.
               "Material &1 sem descrição no pedido &2
               call method zabsf_mob_cl_log=>add_message
                 exporting
                   msgty      = 'E'
                   msgno      = '022'
                   msgv1      = ls_delivitm_str-matnr
                   msgv2      = ls_delivitm_str-vgbel
                 changing
                   return_tab = et_return.
               "sair do processamento
               return.
             endif.
             "alterar descrição
             lv_resbdesc_var = lv_ekpodesc_var.
           endif.
         endif.

         "obter a descrição que está no lote da hu
         zcl_mm_classification=>get_material_desc_by_batch( exporting
                                                              im_material_var    = iv_matnr
                                                              im_batch_var       = iv_charg
                                                            importing
                                                              ex_description_var = data(lv_batchdesc_var) ).
         "verificar se tem nome de material
         if lv_batchdesc_var is initial.
           "Lote &1 sem nome de material
           call method zabsf_mob_cl_log=>add_message
             exporting
               msgty      = 'E'
               msgno      = '019'
               msgv1      = iv_charg
             changing
               return_tab = et_return.
           "sair do processamento
           return.
         endif.
         "verificar se 'material' é o mesmo
         if lv_resbdesc_var eq lv_batchdesc_var.
           if lv_addparent_var eq abap_false.
             "set da flag de item 'pai' a alterar
             lv_addparent_var = abap_true.
             "adicionar item pai à lista de items a alterar
             append value #( deliv_numb      = iv_vbeln
                             deliv_item      = ls_delivitm_str-posnr
                             material        = ls_delivitm_str-matnr
                             fact_unit_denom = ls_delivitm_str-umvkn
                             fact_unit_nom   = ls_delivitm_str-umvkz
                             sales_unit      = ls_delivitm_str-vrkme
                             sales_unit_iso  = ls_delivitm_str-vrkme
                             base_uom        = ls_delivitm_str-meins
                             base_uom_iso    = ls_delivitm_str-meins ) to lt_item_data.

             "estrutura dados de control
             append value #( deliv_numb = iv_vbeln
                             deliv_item = ls_delivitm_str-posnr
                         "    chg_delqty = abap_true  -> se estiver activo, altera a qtd a fornecer no item principal
                             ) to lt_item_ctrl.
           endif.

           if iv_meins ne ls_delivitm_str-meins.
             "verificar se é para converter unidades
             if lv_convert_unit_var eq abap_true.
               "converter para unidades
               zabsf_pp_cl_tracking=>convert_to_meins( exporting
                                                         im_qttyunit_var = conv #( iv_qty )
                                                         im_meins_var    = ls_delivitm_str-meins
                                                         im_material_var = iv_matnr
                                                         im_batchnum_var = iv_charg
                                                       importing
                                                         ex_quantity_var = lv_quantity_var
                                                         et_return_tab   = et_return ).
               if et_return is not initial.
                 "sair do processamento
                 return.
               endif.
               "esmagar qtd
               iv_qty = lv_quantity_var.
             else.
               "Unidade &1 da etiqueta é diferente. Esperado &2
               call method zabsf_mob_cl_log=>add_message
                 exporting
                   msgty      = 'E'
                   msgno      = '016'
                   msgv1      = iv_meins
                   msgv2      = ls_delivitm_str-meins
                 changing
                   return_tab = et_return.
               "sair do processamento
               return.
             endif.
           endif.

           "verificar quantidades
           if iv_qty gt ls_delivitm_str-lfimg.
             "Material &1 qtd. na etiqueta (&2) excede a qtd restante da guia (&3)
             call method zabsf_mob_cl_log=>add_message
               exporting
                 msgty      = 'E'
                 msgno      = '017'
                 msgv1      = ls_delivitm_str-matnr
                 msgv2      = iv_qty
                 msgv3      = ls_delivitm_str-lfimg
               changing
                 return_tab = et_return.
             "sair do processamento
             return.
           endif.
           "flag de implementação de split batch
           lv_splitbatch_var = abap_true.
           "estutura item partição do lote
           append value #( deliv_numb      = iv_vbeln
                           hieraritem      = ls_delivitm_str-posnr
                           usehieritm      = '1'
                           material        = iv_matnr
                           batch           = iv_charg
                           dlv_qty         = iv_qty
                           conv_fact       = ls_delivitm_str-umvkz / ls_delivitm_str-umvkn
                           fact_unit_denom = ls_delivitm_str-umvkn
                           fact_unit_nom   = ls_delivitm_str-umvkz
                           dlv_qty_imunit  = iv_qty * ( ls_delivitm_str-umvkz / ls_delivitm_str-umvkn ) ) to lt_item_data.

           "estrutura dados de control
           append value #( deliv_numb = iv_vbeln
                          chg_delqty = abap_true
                            ) to lt_item_ctrl.
         endif.
       else.
         "processo normal, validar apenas o material
         if ls_delivitm_str-matnr eq iv_matnr.
           if lv_addparent_var eq abap_false.
             "set da flag de item 'pai' a alterar
             lv_addparent_var = abap_true.
             "criar estrutura de item 'pai'
             append value #( deliv_numb      = iv_vbeln
                             deliv_item      = ls_delivitm_str-posnr
                             material        = ls_delivitm_str-matnr
                             fact_unit_denom = ls_delivitm_str-umvkn
                             fact_unit_nom   = ls_delivitm_str-umvkz
                             sales_unit      = ls_delivitm_str-vrkme
                             sales_unit_iso  = ls_delivitm_str-vrkme
                             base_uom        = ls_delivitm_str-meins
                             base_uom_iso    = ls_delivitm_str-meins ) to lt_item_data.

             "estrutura dados de control
             append value #( deliv_numb = iv_vbeln
                             deliv_item = ls_delivitm_str-posnr
                          "   chg_delqty = abap_true
                              ) to lt_item_ctrl.
           endif.
           if iv_meins ne ls_delivitm_str-meins.
             "verificar se é para converter unidades
             if lv_convert_unit_var eq abap_true.
               "converter para unidades
               zabsf_pp_cl_tracking=>convert_to_meins( exporting
                                                         im_qttyunit_var = conv #( iv_qty )
                                                         im_meins_var    = ls_delivitm_str-meins
                                                         im_material_var = iv_matnr
                                                         im_batchnum_var = iv_charg
                                                       importing
                                                         ex_quantity_var = lv_quantity_var
                                                         et_return_tab   = et_return ).
               if et_return is not initial.
                 "sair do processamento
                 return.
               endif.
               "esmagar qtd
               iv_qty = lv_quantity_var.
             else.
               "Unidade &1 da etiqueta é diferente. Esperado &2
               call method zabsf_mob_cl_log=>add_message
                 exporting
                   msgty      = 'E'
                   msgno      = '016'
                   msgv1      = iv_meins
                   msgv2      = ls_delivitm_str-meins
                 changing
                   return_tab = et_return.
               "sair do processamento
               return.
             endif.
           endif.
           "verificar quantidades
           if iv_qty gt ls_delivitm_str-lfimg.
             "Material &1 qtd. na etiqueta (&2) excede a qtd restante da guia (&3)
             call method zabsf_mob_cl_log=>add_message
               exporting
                 msgty      = 'E'
                 msgno      = '017'
                 msgv1      = ls_delivitm_str-matnr
                 msgv2      = iv_qty
                 msgv3      = ls_delivitm_str-lfimg
               changing
                 return_tab = et_return.
             "sair do processamento
             return.
           endif.
           "flag de implementação de split batch
           lv_splitbatch_var = abap_true.
           "estutura item partição do lote
           append value #( deliv_numb      = iv_vbeln
                           hieraritem      = ls_delivitm_str-posnr
                           usehieritm      = '1'
                           material        = iv_matnr
                           batch           = iv_charg
                           dlv_qty         = iv_qty
                           conv_fact       = ls_delivitm_str-umvkz / ls_delivitm_str-umvkn
                           fact_unit_denom = ls_delivitm_str-umvkn
                           fact_unit_nom   = ls_delivitm_str-umvkz
                           dlv_qty_imunit  = iv_qty * ( ls_delivitm_str-umvkz / ls_delivitm_str-umvkn ) ) to lt_item_data.

           "estrutura dados de control
           append value #( deliv_numb = iv_vbeln
                           chg_delqty = abap_true
                            ) to lt_item_ctrl.
         endif.
       endif.
     endif.
     "limpar variáveis
     clear: lv_co02desc_var, lv_batchdesc_var, lv_resbdesc_var,
            ls_delivitm_str, lv_addparent_var, lv_pickedqtt_var,
            lv_salsdesc_var, lv_quantity_var, lv_ekpodesc_var.
   endloop.

   "verificar se encontrou items para alterar
   if lt_item_data is initial.
     "Nenhuma correspondência encontrada na guia
     call method zabsf_mob_cl_log=>add_message
       exporting
         msgty      = 'E'
         msgno      = '020'
       changing
         return_tab = et_return.
     "sair do processamento
     return.
   endif.


   data: lt_new                     type table of bapiobdlvitem,
         lt_new_spl                 type table of  /spe/bapiobdlvitm,
         lt_collective_change_items type table of /spe/bapiobdlvcollchgir.

   "efectuar partição/atribuição de lote
   call function 'BAPI_OUTB_DELIVERY_CHANGE'
     exporting
       header_data             = ls_header_data
       header_control          = ls_header_control
       delivery                = iv_vbeln
       techn_control           = ls_control
     tables
       item_data               = lt_item_data
       item_control            = lt_item_ctrl
       item_data_spl           = lt_item_data_spl
       new_item_data           = lt_new
       new_item_data_spl       = lt_new_spl
       collective_change_items = lt_collective_change_items
       return                  = et_return.
   "verificar se ocorremam erros
   loop at et_return transporting no fields
     where type ca 'EAX'.
     "rollback
     call function 'BAPI_TRANSACTION_ROLLBACK'.
     "sair do processamento
     return.
   endloop.

   "commit da operação
   call function 'BAPI_TRANSACTION_COMMIT'
     exporting
       wait = abap_true.

   if lv_splitbatch_var eq abap_true.
     "remover os items pais
     delete lt_item_data where hieraritem eq lv_uecha_var.
     do 10 times.
       "obter os subitems criados sem piciking feito
       select lips~*, vbup~kosta
         from lips as lips
         inner join vbup as vbup
         on vbup~vbeln eq lips~vbeln and vbup~posnr eq lips~posnr
         into corresponding fields of table @lt_lips
         for all entries in @lt_item_data
         where lips~vbeln eq @iv_vbeln
           and uecha eq @lt_item_data-hieraritem
           and charg eq @lt_item_data-batch
           and matnr eq @lt_item_data-material
           and vbup~kosta ne 'C'.
       if sy-subrc ne 0.
         "esperar 0.2 segundos.
         wait up to '0.2' seconds.
       else.
         "sair do DO
         exit.
       endif.
     enddo.
     if lt_lips is initial.
       "Ocorreu erro ao efectuar a partição de lote
       call method zabsf_mob_cl_log=>add_message
         exporting
           msgty      = 'E'
           msgno      = '013'
           msgv1      = ls_delivitm_str-matnr
           msgv2      = ls_delivitm_str-charg
           msgv3      = iv_vbeln
         changing
           return_tab = et_return.
       "sair do processamento
       return.
     endif.
   endif.

   "limpar variáveis
   refresh: lt_item_data, lt_item_ctrl, lt_return.

   "verificar se depósito dos items é diferente do configurado
   if lv_chang_strg_var eq abap_true.

     loop at lt_lips into data(ls_lips)
       where matnr eq iv_matnr
         and charg eq iv_charg
         and lgort ne lv_batchstrg_var.

       "criar estrutura de item
       append value #( deliv_numb      = iv_vbeln
                       deliv_item      = ls_lips-posnr
                       fact_unit_denom = ls_lips-umvkn
                       fact_unit_nom   = ls_lips-umvkz ) to lt_item_data.
       "estrutura dados de control
       append value #( deliv_numb = iv_vbeln
                       deliv_item = ls_lips-posnr ) to lt_item_ctrl.
       "alterar depóstio do subitem
       append value #( deliv_numb = iv_vbeln
                       deliv_item = ls_lips-posnr
                       stge_loc   = lv_batchstrg_var ) to lt_item_data_spl.
     endloop.
   endif.

   if lines( lt_item_data ) > 0.
     "alterar depósito dos subitems de partição de lote
     call function 'BAPI_OUTB_DELIVERY_CHANGE'
       exporting
         header_data    = ls_header_data
         header_control = ls_header_control
         delivery       = iv_vbeln
         techn_control  = ls_control
       tables
         item_data      = lt_item_data
         item_control   = lt_item_ctrl
         return         = et_return
         item_data_spl  = lt_item_data_spl.
     "verificar se ocorreram erros
     loop at et_return transporting no fields
       where type ca 'EAX'.
       "rollback
       call function 'BAPI_TRANSACTION_ROLLBACK'.
       "sair do processamento
       return.
     endloop.

     "commit da operação
     call function 'BAPI_TRANSACTION_COMMIT'
       exporting
         wait = abap_true.
   endif.

   data: lt_lips_split type table of ty_itab.

   "obter item com o lote que não esteja com o picking feito
   select single lips~vbeln, lips~posnr, lips~matnr, lips~charg, vbup~kosta
      from lips as lips
      inner join vbup as vbup
      on vbup~vbeln eq lips~vbeln and vbup~posnr eq lips~posnr
      into @data(ls_split_str)
      where lips~vbeln eq @iv_vbeln
        and charg eq @iv_charg
        and matnr eq @iv_matnr
        and vbup~kosta ne 'C'.
   if sy-subrc ne 0.
     "Todos os items com picking feito
   endif.

   "nº da delivery
   ls_vbkok-vbeln_vl = iv_vbeln.
   "criar tabela de picking
   ls_vbkok2_str-vbeln_vl = iv_vbeln.
   ls_vbkok2_str-posnr_vl = ls_split_str-posnr.
   ls_vbkok2_str-vbeln    = iv_vbeln.
   ls_vbkok2_str-posnn    = ls_split_str-posnr.
   ls_vbkok2_str-matnr    = ls_split_str-matnr.
   ls_vbkok2_str-charg    = ls_split_str-charg.
   ls_vbkok2_str-pikmg    = iv_qty.
   append ls_vbkok2_str to lt_vbpok.
   clear: ls_vbkok2_str.


   "associar HU à delivery e pickig
   call function 'WS_DELIVERY_UPDATE'
     exporting
       vbkok_wa           = ls_vbkok
       synchron           = 'X'
       commit             = 'X'
       update_picking     = abap_true
       delivery           = ls_vbkok-vbeln_vl
       if_database_update = '1'
     importing
       ef_error_any_0     = lv_errorflg_var
     tables
       prot               = lt_prot
       vbpok_tab          = lt_vbpok
     exceptions
       error_message      = 1
       others             = 99.
   if sy-subrc <> 0.
     ls_return-id         = sy-msgid.
     ls_return-type       = sy-msgty.
     ls_return-number     = sy-msgno.
     ls_return-message_v1 = sy-msgv1.
     ls_return-message_v2 = sy-msgv2.
     ls_return-message_v3 = sy-msgv3.
     ls_return-message_v4 = sy-msgv4.
     "criar mensagem de erro
     message id sy-msgid
           type sy-msgty
         number sy-msgno
           with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
           into ls_return-message.
     "adicionar mensagem tabela de retorno
     append ls_return to et_return.
   endif.
   "percorrer as mensagnes de erro
   if lv_errorflg_var eq abap_true.
     loop at lt_prot into ls_prot
       where msgty ca 'AXE'.

       ls_return-id         = ls_prot-msgid.
       ls_return-type       = ls_prot-msgty.
       ls_return-number     = ls_prot-msgno.
       ls_return-message_v1 = ls_prot-msgv1.
       ls_return-message_v2 = ls_prot-msgv1.
       ls_return-message_v3 = ls_prot-msgv3.
       ls_return-message_v4 = ls_prot-msgv4.
       "criar mensagem de erro
       message id ls_prot-msgid
             type ls_prot-msgty
           number ls_prot-msgno
             with ls_prot-msgv1 ls_prot-msgv2 ls_prot-msgv3 ls_prot-msgv4
             into ls_return-message.
       "adicionar mensagem tabela de retorno
       append ls_return to et_return.
     endloop.
   endif.
 endfunction.
