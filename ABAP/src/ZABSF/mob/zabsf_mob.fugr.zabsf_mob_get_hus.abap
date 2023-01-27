function zabsf_mob_get_hus.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(INPUTOBJ) TYPE  ZABSF_MOB_S_INPUTOBJECT
*"     VALUE(IV_VBELN) TYPE  VBELN_VL
*"     VALUE(IV_GET_ITEMS) TYPE  FLAG OPTIONAL
*"  EXPORTING
*"     VALUE(ET_HUS) TYPE  ZABSF_MOB_T_HUS_LIST
*"----------------------------------------------------------------------

  "variáveis locais
  data: lr_vbeln type rsis_t_range.

  if iv_vbeln is not initial.
    "criar range de nº do fornecimento
    append value #( sign = 'I'
                    option = 'CP'
                    low = |{ '*' }{ iv_vbeln }{ '*' }| ) to lr_vbeln.
  endif.

  "obter dados Cabeçalho do documento de fornecimento
   select vbeln, vstel, vkorg, lfart, lfdat, kunnr, btgew, gewei, volum, voleh
    from likp
    into corresponding fields of table @et_hus
      where vbeln in @lr_vbeln.

  if iv_get_items eq abap_true and et_hus is not initial.
  "obter dados items do documento de fornecimento
    select lips~vbeln, lips~posnr, lips~pstyv, lips~matnr, makt~maktx, lips~werks, lips~lgort, lips~kdmat, lips~lgmng, lips~meins
      from lips left join makt on ( lips~matnr = makt~matnr and makt~spras = @sy-langu )
      into table @data(lt_lips)
      for all entries in @et_hus
        where vbeln = @et_hus-vbeln.

    loop at et_hus assigning field-symbol(<fs_hus>).
      "tabela auxilaira
      data(lt_lips_aux) = lt_lips.
      "remover Hus que não são da guia
      delete lt_lips_aux
        where vbeln <> <fs_hus>-vbeln.
      "copiar entradas
      move-corresponding lt_lips_aux to <fs_hus>-fitem_tab.
      "limpar tabela interna
      refresh lt_lips_aux.
    endloop.

  endif.
endfunction.
