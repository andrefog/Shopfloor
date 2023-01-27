 function zabsf_mob_get_storages.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(INPUTOBJ) TYPE  ZABSF_MOB_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(ET_STORAGE) TYPE  ZABSF_MOB_T_STORAGE_LIST
*"----------------------------------------------------------------------
   "variáveis locais
   data: lv_hustorag_var type lgort_d.
   "obter depósitos por centro
   select werks, lgort, lgobe
    from t001l
    into corresponding fields of table @et_storage
     where t001l~werks eq @inputobj-werks.

   try.
       "obter armazém default
       call method zcl_bc_fixed_values=>get_single_value
         exporting
           im_paramter_var = zcl_bc_fixed_values=>gc_mob_hu_lgort_cst
           im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
           im_werksval_var = inputobj-werks
         importing
           ex_prmvalue_var = data(lv_conf_var).
       lv_hustorag_var = lv_conf_var.
     catch zcx_bc_exceptions into data(lo_exception_obj).
   endtry.
   "colocar depósito default no início da listagem
   read table et_storage into data(ls_storage_str) with key lgort = lv_hustorag_var.
   if sy-subrc eq 0.
     "remover entrada
     delete et_storage
      where lgort eq ls_storage_str-lgort.
     "inserir entrada na 1ª linha
     insert ls_storage_str into et_storage index 1.
   endif.
 endfunction.
