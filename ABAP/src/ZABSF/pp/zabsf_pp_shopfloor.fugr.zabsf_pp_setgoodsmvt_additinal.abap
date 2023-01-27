function zabsf_pp_setgoodsmvt_additinal .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(AUFNR) TYPE  AUFNR
*"     VALUE(COMPONENTS_ST) TYPE  ZABSF_PP_S_COMPONENTS OPTIONAL
*"     VALUE(ADIT_MATNR_ST) TYPE  ZABSF_PP_S_ADIT_MATNR OPTIONAL
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"     VALUE(FOR_DEVOLUTIONS) TYPE  FLAG OPTIONAL
*"     VALUE(FOR_SUBPRODUCTS) TYPE  FLAG OPTIONAL
*"     VALUE(ARBPL) TYPE  ARBPL OPTIONAL
*"     VALUE(DEVOLUTION_DESTINATION) TYPE  CHAR1 OPTIONAL
*"     VALUE(VENDOR) TYPE  LIFNR OPTIONAL
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
*  DATA lref_sf_prdord TYPE REF TO ZABSF_PP_CL_prdord.


  data lref_sf_consum type ref to zabsf_pp_cl_consumptions.

  data: ld_class  type recaimplclname,
        ld_method type seocmpname.

  case 'X'.
    when for_subproducts.
*Get class of interface
      select single imp_clname methodname
          from zabsf_pp003
          into (ld_class, ld_method)
         where werks eq inputobj-werks
           and id_class eq '20'
           and endda ge refdt
           and begda le refdt.

      try .
          create object lref_sf_consum type (ld_class)
            exporting
              initial_refdt = refdt
              input_object  = inputobj.

        catch cx_sy_create_object_error.
*
          call method zabsf_pp_cl_log=>add_message
            exporting
              msgty      = 'E'
              msgno      = '019'
              msgv1      = ld_class
            changing
              return_tab = return_tab.

          exit.
      endtry.

*Create consumption
      call method lref_sf_consum->(ld_method)
        exporting
          aufnr         = aufnr
          arbpl         = arbpl
          components_st = components_st
        changing
          return_tab    = return_tab.

    when for_devolutions.
      "validar preenchimento do nº de lotes. obrigatório nas devoluções
      if components_st-batch is initial.
        call method zabsf_pp_cl_log=>add_message
          exporting
            msgty      = 'E'
            msgno      = '126'
          changing
            return_tab = return_tab.
        return.
      endif.
*Get class of interface
      select single imp_clname methodname
          from zabsf_pp003
          into (ld_class, ld_method)
         where werks eq inputobj-werks
           and id_class eq '23'
           and endda ge refdt
           and begda le refdt.

      try .
          create object lref_sf_consum type (ld_class)
            exporting
              initial_refdt = refdt
              input_object  = inputobj.

        catch cx_sy_create_object_error.
*
          call method zabsf_pp_cl_log=>add_message
            exporting
              msgty      = 'E'
              msgno      = '019'
              msgv1      = ld_class
            changing
              return_tab = return_tab.

          exit.
      endtry.

*Set Devolutions
      call method lref_sf_consum->(ld_method)
        exporting
          aufnr                  = aufnr
          components_st          = components_st
          devolution_destination = devolution_destination
          arbpl                  = arbpl
          werks                  = inputobj-werks
        changing
          return_tab             = return_tab.
  endcase.
endfunction.
