function zabsf_mob_get_packing_material.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(INPUTOBJ) TYPE  ZABSF_MOB_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(ET_MATNR) TYPE  ZABSF_MOB_T_PACKING_MAT
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  "variáveis locais
  data: ls_message_str like line of et_return.
  try.
      "obter valor da configuração
      call method zcl_bc_fixed_values=>get_single_value
        exporting
          im_paramter_var = zcl_bc_fixed_values=>gc_matnpack_cst
          im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
          im_werksval_var = inputobj-werks
        importing
          ex_prmvalue_var = data(lv_matnpack_var).
    catch zcx_bc_exceptions into data(lo_excption_obj).
      "falta configuração
      message id lo_excption_obj->msgid
            type lo_excption_obj->msgty
          number lo_excption_obj->msgno
            with lo_excption_obj->msgv1
                 lo_excption_obj->msgv2
                 lo_excption_obj->msgv3
                 lo_excption_obj->msgv4
            into ls_message_str-message.

      ls_message_str-type = sy-abcde+4(1).
      append ls_message_str to et_return.
      "sair do processamento
      return.
  endtry.

  "Obter material de embalegem e descripção do material
  select mara~matnr, makt~maktx
   from mara
   left join makt
      on makt~matnr eq mara~matnr
     and makt~spras eq @sy-langu
   into corresponding fields of table @et_matnr
    where mara~vhart eq @lv_matnpack_var.
endfunction.
