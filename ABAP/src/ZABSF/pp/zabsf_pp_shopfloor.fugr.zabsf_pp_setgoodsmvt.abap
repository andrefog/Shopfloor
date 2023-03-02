FUNCTION ZABSF_PP_SETGOODSMVT.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(AUFNR) TYPE  AUFNR
*"     VALUE(COMPONENTS_ST) TYPE  ZABSF_PP_S_COMPONENTS OPTIONAL
*"     VALUE(ADIT_MATNR_ST) TYPE  ZABSF_PP_S_ADIT_MATNR OPTIONAL
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"     VALUE(LENUM) TYPE  LENUM OPTIONAL
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"--------------------------------------------------------------------
*  DATA lref_sf_prdord TYPE REF TO ZABSF_PP_CL_prdord.
*
*  CREATE OBJECT lref_sf_prdord
*    EXPORTING
*      initial_refdt = refdt
*      input_object  = inputobj.
*
*  CALL METHOD lref_sf_prdord->create_consum_order
*    EXPORTING
*      aufnr         = aufnr
*      components_st = components_st
*      adit_matnr_st = adit_matnr_st
*    CHANGING
*      return_tab    = return_tab.

  data lref_sf_consum type ref to zif_absf_pp_consumptions.   "ZABSF_PP_CL_CONSUMPTIONS

  data: ld_class  type recaimplclname,
        ld_method type seocmpname.


*Get class of interface
  select single imp_clname methodname
      from zabsf_pp003
      into (ld_class, ld_method)
     where werks eq inputobj-werks
       and id_class eq '7'
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
      components_st = components_st
      adit_matnr_st = adit_matnr_st
      lenum         = lenum
    changing
      return_tab    = return_tab.





ENDFUNCTION.
