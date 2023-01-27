function zabsf_mob_add_item_2_delivery.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IV_DELIVERY_VAR) TYPE  VBELN
*"  EXPORTING
*"     REFERENCE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  "variáveis locais
  data: lt_bdcdata_tab  type table of bdcdata.

  "criar batch input
  call method zcl_sf_bdc=>bdc_dynpro
    exporting
      iv_program_var = 'SAPMV50A'
      iv_dynpro_var  = '4004'
    changing
      ch_bdcdata_tab = lt_bdcdata_tab.

  call method zcl_sf_bdc=>bdc_field
    exporting
      iv_fnam_var    = 'BDC_CURSOR'
      iv_fval_var    = 'LIKP-VBELN'
    changing
      ch_bdcdata_tab = lt_bdcdata_tab.

  call method zcl_sf_bdc=>bdc_field
    exporting
      iv_fnam_var    = 'BDC_OKCODE'
      iv_fval_var    = '/00'
    changing
      ch_bdcdata_tab = lt_bdcdata_tab.

  call method zcl_sf_bdc=>bdc_field
    exporting
      iv_fnam_var    = 'LIKP-VBELN'
      iv_fval_var    = conv #( iv_delivery_var )
    changing
      ch_bdcdata_tab = lt_bdcdata_tab.

  "________________

  call method zcl_sf_bdc=>bdc_dynpro
    exporting
      iv_program_var = 'SAPMV50A'
      iv_dynpro_var  = '1000'
    changing
      ch_bdcdata_tab = lt_bdcdata_tab.

  call method zcl_sf_bdc=>bdc_field
    exporting
      iv_fnam_var    = 'BDC_OKCODE'
      iv_fval_var    = '=POAN_T'
    changing
      ch_bdcdata_tab = lt_bdcdata_tab.

  call method zcl_sf_bdc=>bdc_field
    exporting
      iv_fnam_var    = 'BDC_SUBSCR'
      iv_fval_var    = 'SAPMV50A                                1502SUBSCREEN_HEADER'
    changing
      ch_bdcdata_tab = lt_bdcdata_tab.

  call method zcl_sf_bdc=>bdc_field
    exporting
      iv_fnam_var    = 'BDC_CURSOR'
      iv_fval_var    = 'LIKP-BLDAT'
    changing
      ch_bdcdata_tab = lt_bdcdata_tab.

  call method zcl_sf_bdc=>bdc_field
    exporting
      iv_fnam_var    = 'BDC_SUBSCR'
      iv_fval_var    = 'SAPMV50A                                1102SUBSCREEN_BODY'
    changing
      ch_bdcdata_tab = lt_bdcdata_tab.

  call method zcl_sf_bdc=>bdc_field
    exporting
      iv_fnam_var    = 'BDC_SUBSCR'
      iv_fval_var    = 'SAPMV50A                                0611SUBSCREEN_BOTTOM'
    changing
      ch_bdcdata_tab = lt_bdcdata_tab.

  call method zcl_sf_bdc=>bdc_field
    exporting
      iv_fnam_var    = 'BDC_SUBSCR'
      iv_fval_var    = 'SAPMV50A                                1708SUBSCREEN_ICONBAR'
    changing
      ch_bdcdata_tab = lt_bdcdata_tab.

  "-------
  call method zcl_sf_bdc=>bdc_dynpro
    exporting
      iv_program_var = 'SAPMV50A'
      iv_dynpro_var  = '1000'
    changing
      ch_bdcdata_tab = lt_bdcdata_tab.


  call method zcl_sf_bdc=>bdc_field
    exporting
      iv_fnam_var    = 'BDC_OKCODE'
      iv_fval_var    = '/00'
    changing
      ch_bdcdata_tab = lt_bdcdata_tab.

  call method zcl_sf_bdc=>bdc_field
    exporting
      iv_fnam_var    = 'BDC_SUBSCR'
      iv_fval_var    = 'SAPMV50A                                1502SUBSCREEN_HEADER'
    changing
      ch_bdcdata_tab = lt_bdcdata_tab.


  call method zcl_sf_bdc=>bdc_field
    exporting
      iv_fnam_var    = 'BDC_SUBSCR'
      iv_fval_var    = 'SAPMV50A                                1102SUBSCREEN_BODY'
    changing
      ch_bdcdata_tab = lt_bdcdata_tab.

  call method zcl_sf_bdc=>bdc_field
    exporting
      iv_fnam_var    = 'BDC_CURSOR'
      iv_fval_var    = 'LIPS-LGORT(02)'
    changing
      ch_bdcdata_tab = lt_bdcdata_tab.

  call method zcl_sf_bdc=>bdc_field
    exporting
      iv_fnam_var    = 'LIPS-MATNR(02)'
      iv_fval_var    = 'CPA0005'
    changing
      ch_bdcdata_tab = lt_bdcdata_tab.

  call method zcl_sf_bdc=>bdc_field
    exporting
      iv_fnam_var    = 'LIPSD-G_LFIMG(02)'
      iv_fval_var    = '3'
    changing
      ch_bdcdata_tab = lt_bdcdata_tab.

  call method zcl_sf_bdc=>bdc_field
    exporting
      iv_fnam_var    = 'LIPS-VRKME(02))'
      iv_fval_var    = 'UN'
    changing
      ch_bdcdata_tab = lt_bdcdata_tab.

  call method zcl_sf_bdc=>bdc_field
    exporting
      iv_fnam_var    = 'LIPS-WERKS(02)'
      iv_fval_var    = '2100'
    changing
      ch_bdcdata_tab = lt_bdcdata_tab.

  call method zcl_sf_bdc=>bdc_field
    exporting
      iv_fnam_var    = 'LIPS-LGORT(02)'
      iv_fval_var    = '2100'
    changing
      ch_bdcdata_tab = lt_bdcdata_tab.

  call method zcl_sf_bdc=>bdc_field
    exporting
      iv_fnam_var    = 'BDC_SUBSCR'
      iv_fval_var    = 'SAPMV50A                                0611SUBSCREEN_BOTTOM'
    changing
      ch_bdcdata_tab = lt_bdcdata_tab.

  call method zcl_sf_bdc=>bdc_field
    exporting
      iv_fnam_var    = 'BDC_SUBSCR'
      iv_fval_var    = 'SAPMV50A                                1708SUBSCREEN_ICONBAR'
    changing
      ch_bdcdata_tab = lt_bdcdata_tab.


  " ---

  call method zcl_sf_bdc=>bdc_dynpro
    exporting
      iv_program_var = 'SAPMV50A'
      iv_dynpro_var  = '1000'
    changing
      ch_bdcdata_tab = lt_bdcdata_tab.

  call method zcl_sf_bdc=>bdc_field
    exporting
      iv_fnam_var    = 'BDC_OKCODE'
      iv_fval_var    = '=SICH_T'
    changing
      ch_bdcdata_tab = lt_bdcdata_tab.

  call method zcl_sf_bdc=>bdc_field
    exporting
      iv_fnam_var    = 'BDC_SUBSCR'
      iv_fval_var    = 'SAPMV50A                                1502SUBSCREEN_HEADER'
    changing
      ch_bdcdata_tab = lt_bdcdata_tab.

  call method zcl_sf_bdc=>bdc_field
    exporting
      iv_fnam_var    = 'BDC_SUBSCR'
      iv_fval_var    = 'SAPMV50A                                1102SUBSCREEN_BODY'
    changing
      ch_bdcdata_tab = lt_bdcdata_tab.


  call method zcl_sf_bdc=>bdc_field
    exporting
      iv_fnam_var    = 'BDC_SUBSCR'
      iv_fval_var    = 'SAPMV50A                                0611SUBSCREEN_BOTTOM'
    changing
      ch_bdcdata_tab = lt_bdcdata_tab.

  call method zcl_sf_bdc=>bdc_field
    exporting
      iv_fnam_var    = 'BDC_SUBSCR'
      iv_fval_var    = 'SAPMV50A                                1708SUBSCREEN_ICONBAR'
    changing
      ch_bdcdata_tab = lt_bdcdata_tab.

  "chamar transacção
  call transaction 'VL02N' using lt_bdcdata_tab
                   mode   'N'
                   update 'S'
                   messages into return_tab.

  "verificar se ocorreu erro num dynpro
  if sy-subrc eq 1001.
    "Erro ao actualizar lotes na ordem de produção
    call method zabsf_pp_cl_log=>add_message
      exporting
        msgty      = 'E'
        msgno      = 162
      changing
        return_tab = return_tab.
    return.
  endif.
endfunction.
