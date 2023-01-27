function zabsf_mob_get_delivery_items .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(INPUTOBJ) TYPE  ZABSF_MOB_S_INPUTOBJECT
*"     VALUE(IV_DELIVERY_VAR) TYPE  VBELN_VL
*"  EXPORTING
*"     VALUE(ET_DELIVITM_TAB) TYPE  ZABSF_MOB_T_ITEM_DETAIL
*"----------------------------------------------------------------------
  types: begin of ty_podocmts_str,
           ebeln type ebeln,
           ebelp type ebelp,
         end of ty_podocmts_str.
  "variáveis locais
  data: ls_delivitm_str like line of et_delivitm_tab,
        lv_received_var type menge_d,
        lt_podocmts_tab type table of ty_podocmts_str.

  "conversão de formatos
  iv_delivery_var = |{ iv_delivery_var alpha = in }|.

  "obter items da guia
  select *
    from lips
    into table @data(lt_delivitm_tab)
      where vbeln eq @iv_delivery_var.
  if sy-subrc ne 0.
    "sair do processamento
    return.
  endif.
  "retirar os items pai quando existe partição de lote
  loop at lt_delivitm_tab into data(ls_lipsdata_str)
    where uecha is initial.
    "verificar se existe partição de lote
    if line_exists( lt_delivitm_tab[ uecha = ls_lipsdata_str-posnr ] ).
      "remover item 'pai'
      delete lt_delivitm_tab.
    endif.
  endloop.

  "criar tabela de ranges
  lt_podocmts_tab = value #( for ls_lips_str in lt_delivitm_tab
                              ( ebeln = ls_lips_str-vgbel
                                ebelp = ls_lips_str-vgpos ) ).
  "obter items do pedido
  select *
    from ekpo
    into table @data(lt_ekpo_tab)
    for all entries in @lt_podocmts_tab
      where ebeln eq @lt_podocmts_tab-ebeln
        and ebelp eq @lt_podocmts_tab-ebelp.
  if sy-subrc ne 0.
    "sair do processamento
    return.
  endif.

  "descrição dos materiais
  select *
    from makt
    into table @data(lt_matsdesc_tab)
      for all entries in @lt_delivitm_tab
      where matnr eq @lt_delivitm_tab-matnr
        and spras eq @sy-langu.


  "percorrer todos os items da guia
  loop at lt_delivitm_tab assigning field-symbol(<fs_delivitm_str>).
    loop at lt_ekpo_tab assigning field-symbol(<fs_ekpo_str>)
      where ebeln eq <fs_delivitm_str>-vgbel
        and ebelp eq <fs_delivitm_str>-vgpos.
      "depósito
      ls_delivitm_str-lgort = <fs_ekpo_str>-lgort.
      "centro
      ls_delivitm_str-werks = <fs_ekpo_str>-werks.

      "obter as entradas de mercadoria
      select *
        from ekbe
        into table @data(lt_goodrecp_tab)
          where ebeln eq @<fs_ekpo_str>-ebeln
            and ebelp eq @<fs_ekpo_str>-ebelp
            and ( bwart eq '101' or bwart eq '102' )
            and bewtp eq 'E'
            and vbeln_st eq @<fs_delivitm_str>-vbeln
            and vbelp_st eq @<fs_delivitm_str>-posnr.

      "percorrer listas das recpções
      loop at lt_goodrecp_tab assigning field-symbol(<fs_goodrecp_str>).
        "entrada de mercadoria
        if <fs_goodrecp_str>-shkzg eq 'S'.
          "somar quantidades
          lv_received_var = lv_received_var + <fs_goodrecp_str>-menge.
        endif.
        "estorno
        if <fs_goodrecp_str>-shkzg eq 'H'.
          "subtrair quantidades
          lv_received_var = lv_received_var - <fs_goodrecp_str>-menge.
        endif.
      endloop.
    endloop.

    "material
    ls_delivitm_str-matnr = <fs_delivitm_str>-matnr.
    "lote
    ls_delivitm_str-charg = <fs_delivitm_str>-charg.
    "UMB
    ls_delivitm_str-meins = <fs_delivitm_str>-meins.
    "guia remessa
    ls_delivitm_str-vbeln = <fs_delivitm_str>-vbeln.
    "item guia remessa
    ls_delivitm_str-posnr = <fs_delivitm_str>-posnr.
    "pedido compra
    ls_delivitm_str-ebeln = <fs_delivitm_str>-vgbel.
    "item pedido compra
    ls_delivitm_str-ebelp = <fs_delivitm_str>-vgpos.
    "desrição material
    ls_delivitm_str-maktx = cond #( when line_exists( lt_matsdesc_tab[ matnr = <fs_delivitm_str>-matnr ] )
                                    then lt_matsdesc_tab[ matnr = <fs_delivitm_str>-matnr ]-maktx ).
    "quantidade a recepcionar
    ls_delivitm_str-menge = <fs_delivitm_str>-lfimg - lv_received_var.
    "converter para unidades
    if ls_delivitm_str-meins eq 'UN'.
      "quantidade em unidades
      ls_delivitm_str-menge_unit = ls_delivitm_str-menge.
    else.
      zabsf_pp_cl_tracking=>convert_to_units( exporting
                                        im_quantity_var = ls_delivitm_str-menge
                                        im_qttyunit_var = <fs_delivitm_str>-meins
                                        im_material_var = <fs_delivitm_str>-matnr
                                        im_batchnum_var = <fs_delivitm_str>-charg
                                      importing
                                        ex_units_var    = ls_delivitm_str-menge_unit ).
    endif.
    "limpar variáveis
    clear lv_received_var.
    "adicionar entrada tabela de saida
    append ls_delivitm_str to et_delivitm_tab.
  endloop.
endfunction.
