FUNCTION zabsf_pp_getwrkcenter_detail .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(AREADID) TYPE  ZABSF_PP_E_AREAID OPTIONAL
*"     VALUE(WERKS) TYPE  WERKS_D OPTIONAL
*"     VALUE(HNAME) TYPE  CR_HNAME
*"     VALUE(ARBPL) TYPE  ARBPL
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"     VALUE(AUFNR) TYPE  AUFNR OPTIONAL
*"     VALUE(VORNR) TYPE  VORNR OPTIONAL
*"  EXPORTING
*"     VALUE(WRKCTR_DETAIL) TYPE  ZABSF_PP_S_WRKCTR_DETAIL
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA: lref_sf_wrkctr     TYPE REF TO zabsf_pp_cl_wrkctr,
        lref_sf_parameters TYPE REF TO zabsf_pp_cl_parameters.

  DATA ls_return TYPE bapiret2.

  CREATE OBJECT lref_sf_wrkctr
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

  CALL METHOD lref_sf_wrkctr->get_workcenter_detail
    EXPORTING
      areadid       = inputobj-areaid   "Areaid
      werks         = inputobj-werks    "Werks
      hname         = hname
      arbpl         = arbpl
      aufnr         = aufnr
      vornr         = vornr
    CHANGING
      wrkctr_detail = wrkctr_detail
      return_tab    = return_tab.

*>> AJB-02.02.2021 - Add batch validation flag
  SELECT SINGLE parva
    INTO @DATA(lv_batch_validation)
    FROM zabsf_pp032
    WHERE werks = @inputobj-werks
      AND parid = 'ZPP3_BATCHVALIDATION'.
  IF sy-subrc = 0 AND lv_batch_validation IS NOT INITIAL.
    TRANSLATE lv_batch_validation TO UPPER CASE.
    DATA(ls_prord_tab) = VALUE zabsf_pp_s_prdord_detail(
                  batch_validation = lv_batch_validation ).
    MODIFY wrkctr_detail-prord_tab
                  FROM ls_prord_tab
                  TRANSPORTING batch_validation
                  WHERE aufnr IS NOT INITIAL.
  ENDIF.
*<< AJB-02.02.2021

*>> SETUP CONF
  CREATE OBJECT lref_sf_parameters
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

  CALL METHOD lref_sf_parameters->get_output_settings
    EXPORTING
      get_all        = abap_true
    IMPORTING
      all_parameters = wrkctr_detail-output_settings
    CHANGING
      return_tab     = return_tab.

  DELETE ADJACENT DUPLICATES FROM return_tab.
ENDFUNCTION.
