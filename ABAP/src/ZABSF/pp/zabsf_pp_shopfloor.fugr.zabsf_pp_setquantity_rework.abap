FUNCTION zabsf_pp_setquantity_rework .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(ARBPL) TYPE  ARBPL
*"     VALUE(AUFNR) TYPE  AUFNR OPTIONAL
*"     VALUE(VORNR) TYPE  VORNR OPTIONAL
*"     VALUE(MATNR) TYPE  MATNR OPTIONAL
*"     VALUE(AUFNR_REWORK) TYPE  AUFNR OPTIONAL
*"     VALUE(REWORK_QTY) TYPE  RU_RMNGA OPTIONAL
*"     VALUE(SCRAP_QTY) TYPE  RU_XMNGA OPTIONAL
*"     VALUE(NUMB_CYCLE) TYPE  NUMC10 OPTIONAL
*"     VALUE(DEFECTID) TYPE  ZABSF_PP_E_DEFECTID OPTIONAL
*"     VALUE(GRUND) TYPE  CO_AGRND OPTIONAL
*"     VALUE(FLAG_CREATE) TYPE  FLAG OPTIONAL
*"     VALUE(FLAG_SCRAP_LIST) TYPE  FLAG OPTIONAL
*"     VALUE(CHARG_T) TYPE  ZABSF_PP_T_BATCH_CONSUMPTION OPTIONAL
*"     VALUE(BACKOFFICE) TYPE  FLAG OPTIONAL
*"     VALUE(SHIFTID) TYPE  ZABSF_PP_E_SHIFTID OPTIONAL
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(CONF_TAB) TYPE  ZABSF_PP_T_CONFIRMATION
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  DATA lref_sf_rework TYPE REF TO zabsf_pp_cl_rework.

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
  CREATE OBJECT lref_sf_rework
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

*Get method of class to set quantity
  SELECT SINGLE methodname
    FROM zabsf_pp003
    INTO (@DATA(l_method))
   WHERE werks    EQ @inputobj-werks
     AND id_class EQ '13'
     AND endda    GE @refdt
     AND begda    LE @refdt.

  CLEAR: l_gname,
         l_garg,
         l_guname,
         l_subrc.

*Check blocks for order
  CALL METHOD zabsf_pp_cl_wait_enqueue=>wait_for_dequeue_ord
    EXPORTING
      i_aufnr    = aufnr
      i_max_time = l_wait
    IMPORTING
      e_gname    = l_gname
      e_garg     = l_garg
      e_guname   = l_guname
      e_return   = l_subrc.

  IF l_subrc NE 0.
*  Send error message
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

  CLEAR: l_gname,
         l_garg,
         l_guname,
         l_subrc.

*Check blocks for order
  CALL METHOD zabsf_pp_cl_wait_enqueue=>wait_for_dequeue_res
    EXPORTING
      i_aufnr    = aufnr
      i_max_time = l_wait
    IMPORTING
      e_gname    = l_gname
      e_garg     = l_garg
      e_guname   = l_guname
      e_return   = l_subrc.

  IF l_subrc NE 0.
*  Send error message
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

  LOOP AT charg_t ASSIGNING FIELD-SYMBOL(<fs_charg_t>).
    CLEAR: l_gname,
           l_garg,
           l_guname,
           l_subrc.

*  Add left zeros
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = <fs_charg_t>-charg
      IMPORTING
        output = <fs_charg_t>-charg.

*  Check blocks
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

  IF l_subrc NE 0.
*  Send error message
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

*Confirmation of scrap quantity
  CALL METHOD lref_sf_rework->(l_method)
    EXPORTING
      arbpl           = arbpl
      aufnr           = aufnr
      vornr           = vornr
      matnr           = matnr
      rework_qty      = rework_qty
      scrap_qty       = scrap_qty
      numb_cycle      = numb_cycle
      defectid        = defectid
      grund           = grund
      flag_create     = flag_create
      flag_scrap_list = flag_scrap_list
      charg_t         = charg_t
      backoffice      = backoffice
      shiftid         = shiftid
    IMPORTING
      conf_tab        = conf_tab
    CHANGING
      aufnr_rework    = aufnr_rework
      return_tab      = return_tab.

  DELETE ADJACENT DUPLICATES FROM return_tab.
ENDFUNCTION.
