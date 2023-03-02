FUNCTION zabsf_pp_set_quantity .
*"----------------------------------------------------------------------
*"*"Local Interface:
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
*"     VALUE(MATERIALBATCH) TYPE  ZABSF_PP_T_MATERIALBATCH OPTIONAL
*"     VALUE(MATERIALSERIAL) TYPE  ZABSF_PP_T_MATERIALSERIAL OPTIONAL
*"     VALUE(EQUIPMENT) TYPE  CHAR100 OPTIONAL
*"  EXPORTING
*"     VALUE(CONF_TAB) TYPE  ZABSF_PP_T_CONFIRMATION
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
*Reference
  DATA: lref_sf_prdord  TYPE REF TO zabsf_pp_cl_prdord.

*Variables
  DATA: l_gname  TYPE seqg3-gname,
        l_garg   TYPE seqg3-garg,
        l_guname TYPE seqg3-guname,
        l_subrc  TYPE sy-subrc,
        l_wait   TYPE i.

*Constants
  CONSTANTS: c_wait TYPE zabsf_pp_e_parid VALUE 'WAIT'.

*Get time wait
  SELECT SINGLE parva
    FROM zabsf_pp032
    INTO (@DATA(l_wait_param))
   WHERE parid EQ @c_wait.

  IF l_wait_param IS NOT INITIAL.
    l_wait = l_wait_param.
  ENDIF.

*Create object of class
  CREATE OBJECT lref_sf_prdord
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

*Get method of class to set quantity
  SELECT SINGLE methodname
    FROM zabsf_pp003
    INTO (@DATA(l_method))
   WHERE werks    EQ @inputobj-werks
     AND id_class EQ '12'
     AND endda    GE @refdt
     AND begda    LE @refdt.

  CLEAR l_subrc.

  LOOP AT qty_conf_tab INTO DATA(ls_qty_conf_tab).
    CLEAR: l_gname,
           l_garg,
           l_guname,
           l_subrc.

*  Check blocks for Prodcution Order
    CALL METHOD zabsf_pp_cl_wait_enqueue=>wait_for_dequeue_ord
      EXPORTING
        i_aufnr    = ls_qty_conf_tab-aufnr
        i_max_time = l_wait
      IMPORTING
        e_gname    = l_gname
        e_garg     = l_garg
        e_guname   = l_guname
        e_return   = l_subrc.

    IF l_subrc NE 0.
      EXIT.
    ENDIF.

    CLEAR: l_gname,
           l_garg,
           l_guname,
           l_subrc.

*  Check blocks for prodcution Order
    CALL METHOD zabsf_pp_cl_wait_enqueue=>wait_for_dequeue_res
      EXPORTING
        i_aufnr    = ls_qty_conf_tab-aufnr
        i_max_time = l_wait
      IMPORTING
        e_gname    = l_gname
        e_garg     = l_garg
        e_guname   = l_guname
        e_return   = l_subrc.

    IF l_subrc NE 0.
      EXIT.
    ENDIF.

    LOOP AT ls_qty_conf_tab-charg_t ASSIGNING FIELD-SYMBOL(<fs_charg_t>).
*    Add left zeros
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = <fs_charg_t>-charg
        IMPORTING
          output = <fs_charg_t>-charg.

*    Check blocks
      CALL METHOD zabsf_pp_cl_wait_enqueue=>wait_for_dequeue_mat
        EXPORTING
          i_matnr    = <fs_charg_t>-matnr
          i_werks    = <fs_charg_t>-werks
          i_charg    = <fs_charg_t>-charg
          i_max_time = l_wait
        IMPORTING
          e_gname    = l_gname
          e_garg     = l_garg
          e_guname   = l_guname
          e_return   = l_subrc.

      IF l_subrc NE 0.
        EXIT.
      ENDIF.
    ENDLOOP.

    IF sy-subrc NE 0.
      CALL METHOD zabsf_pp_cl_wait_enqueue=>wait_for_dequeue_mat
        EXPORTING
          i_matnr  = ls_qty_conf_tab-matnr
          i_werks  = inputobj-werks
        IMPORTING
          e_gname  = l_gname
          e_garg   = l_garg
          e_guname = l_guname
          e_return = l_subrc.

      IF l_subrc NE 0.
        EXIT.
      ENDIF.
    ENDIF.

    IF l_subrc NE 0.
      EXIT.
    ENDIF.
  ENDLOOP.

  IF l_subrc NE 0.
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '093'
        msgv1      = l_guname
        msgv2      = l_gname
        msgv3      = l_guname
      CHANGING
        return_tab = return_tab.
    EXIT.
  ENDIF.

*Confirmation of good quantity
  CALL METHOD lref_sf_prdord->(l_method)
    EXPORTING
      areaid         = inputobj-areaid
      werks          = inputobj-werks
      inputobj       = inputobj
      arbpl          = arbpl
      qty_conf_tab   = qty_conf_tab
      tipord         = tipord
      check_stock    = check_stock
      first_cycle    = first_cycle
      backoffice     = backoffice
      shiftid        = shiftid
      supervisor     = supervisor
      vendor         = |{ vendor ALPHA = IN }|
      materialbatch  = materialbatch[]
      materialserial = materialserial[]
      iv_equipment   = equipment
    IMPORTING
      conf_tab       = conf_tab
    CHANGING
      return_tab     = return_tab.

  DELETE ADJACENT DUPLICATES FROM return_tab.
ENDFUNCTION.
