function zabsf_pp_set_quantity .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(ARBPL) TYPE  ARBPL OPTIONAL
*"     VALUE(QTY_CONF_TAB) TYPE  ZABSF_PP_T_QTY_CONF
*"     VALUE(TIPORD) TYPE  ZABSF_PP_E_TIPORD DEFAULT 'N'
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"     VALUE(CHECK_STOCK) TYPE  FLAG OPTIONAL
*"     VALUE(FIRST_CYCLE) TYPE  FLAG OPTIONAL
*"     VALUE(BACKOFFICE) TYPE  FLAG OPTIONAL
*"     VALUE(SHIFTID) TYPE  ZABSF_PP_E_SHIFTID OPTIONAL
*"     VALUE(SUPERVISOR) TYPE  FLAG OPTIONAL
*"     VALUE(VENDOR) TYPE  LIFNR OPTIONAL
*"  EXPORTING
*"     VALUE(CONF_TAB) TYPE  ZABSF_PP_T_CONFIRMATION
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
*Reference
  data: lref_sf_prdord  type ref to zabsf_pp_cl_prdord.

*Variables
  data: l_gname  type seqg3-gname,
        l_garg   type seqg3-garg,
        l_guname type seqg3-guname,
        l_subrc  type sy-subrc,
        l_wait   type i.

*Constants
  constants: c_wait type zabsf_pp_e_parid value 'WAIT'.

*Get time wait
  select single parva
    from zabsf_pp032
    into (@data(l_wait_param))
   where parid eq @c_wait.

  if l_wait_param is not initial.
    l_wait = l_wait_param.
  endif.


*Create object of class
  create object lref_sf_prdord
    exporting
      initial_refdt = refdt
      input_object  = inputobj.

*Get method of class to set quantity
  select single methodname
    from zabsf_pp003
    into (@data(l_method))
   where werks    eq @inputobj-werks
     and id_class eq '12'
     and endda    ge @refdt
     and begda    le @refdt.

  clear l_subrc.

  loop at qty_conf_tab into data(ls_qty_conf_tab).
    clear: l_gname,
           l_garg,
           l_guname,
           l_subrc.

*  Check blocks for Prodcution Order
    call method zabsf_pp_cl_wait_enqueue=>wait_for_dequeue_ord
      exporting
        i_aufnr    = ls_qty_conf_tab-aufnr
        i_max_time = l_wait
      importing
        e_gname    = l_gname
        e_garg     = l_garg
        e_guname   = l_guname
        e_return   = l_subrc.

    if l_subrc ne 0.
      exit.
    endif.

    clear: l_gname,
           l_garg,
           l_guname,
           l_subrc.

*  Check blocks for prodcution Order
    call method zabsf_pp_cl_wait_enqueue=>wait_for_dequeue_res
      exporting
        i_aufnr    = ls_qty_conf_tab-aufnr
        i_max_time = l_wait
      importing
        e_gname    = l_gname
        e_garg     = l_garg
        e_guname   = l_guname
        e_return   = l_subrc.

    if l_subrc ne 0.
      exit.
    endif.

    loop at ls_qty_conf_tab-charg_t assigning field-symbol(<fs_charg_t>).
*    Add left zeros
      call function 'CONVERSION_EXIT_ALPHA_INPUT'
        exporting
          input  = <fs_charg_t>-charg
        importing
          output = <fs_charg_t>-charg.

*    Check blocks
      call method zabsf_pp_cl_wait_enqueue=>wait_for_dequeue_mat
        exporting
          i_matnr    = <fs_charg_t>-matnr
          i_werks    = <fs_charg_t>-werks
          i_charg    = <fs_charg_t>-charg
          i_max_time = l_wait
        importing
          e_gname    = l_gname
          e_garg     = l_garg
          e_guname   = l_guname
          e_return   = l_subrc.

      if l_subrc ne 0.
        exit.
      endif.
    endloop.

    if sy-subrc ne 0.
      call method zabsf_pp_cl_wait_enqueue=>wait_for_dequeue_mat
        exporting
          i_matnr  = ls_qty_conf_tab-matnr
          i_werks  = inputobj-werks
        importing
          e_gname  = l_gname
          e_garg   = l_garg
          e_guname = l_guname
          e_return = l_subrc.

      if l_subrc ne 0.
        exit.
      endif.
    endif.

    if l_subrc ne 0.
      exit.
    endif.
  endloop.

  if l_subrc ne 0.
    call method zabsf_pp_cl_log=>add_message
      exporting
        msgty      = 'E'
        msgno      = '093'
        msgv1      = l_guname
        msgv2      = l_gname
        msgv3      = l_guname
      changing
        return_tab = return_tab.
    exit.
  endif.

*Confirmation of good quantity
  call method lref_sf_prdord->(l_method)
    exporting
      areaid       = inputobj-areaid
      werks        = inputobj-werks
      inputobj     = inputobj
      arbpl        = arbpl
      qty_conf_tab = qty_conf_tab
      tipord       = tipord
      check_stock  = check_stock
      first_cycle  = first_cycle
      backoffice   = backoffice
      shiftid      = shiftid
      supervisor   = supervisor
      vendor       = |{ vendor alpha = in }|
    importing
      conf_tab     = conf_tab
    changing
      return_tab   = return_tab.

  delete adjacent duplicates from return_tab.
endfunction.
