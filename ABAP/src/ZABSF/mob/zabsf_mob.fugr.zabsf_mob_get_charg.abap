function zabsf_mob_get_charg.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(INPUTOBJ) TYPE  ZABSF_MOB_S_INPUTOBJECT
*"     VALUE(IV_MATNR) TYPE  MATNR
*"  EXPORTING
*"     VALUE(ET_CHARG) TYPE  ZABSF_MOB_T_CHARG
*"----------------------------------------------------------------------
  "variáveis locais
  data: lv_material_var type matnr.
  "conversão de formatos
  lv_material_var = |{ iv_matnr alpha = in }|.
  "obter lotes por centro e material
  select mchb~matnr, mchb~werks, mchb~charg, mchb~ersda, mchb~clabs, mchb~lgort,
         qbew~pspnr
   from mchb
   left join qbew
      on qbew~matnr eq mchb~matnr
     and qbew~bwkey eq mchb~werks
     and qbew~bwtar eq mchb~charg
   into corresponding fields of table @et_charg
    where mchb~matnr eq @lv_material_var
      and mchb~werks eq @inputobj-werks
      and mchb~clabs gt 0.
  "percorrer todos os lotes
  loop at et_charg assigning field-symbol(<fs_charg_str>).
    "obter descrição do material
    zcl_mm_classification=>get_material_desc_by_batch( exporting
                                                         im_material_var    = <fs_charg_str>-matnr
                                                         im_batch_var       = <fs_charg_str>-charg
                                                       importing
                                                         ex_description_var = <fs_charg_str>-maktx ).
  endloop.

endfunction.
