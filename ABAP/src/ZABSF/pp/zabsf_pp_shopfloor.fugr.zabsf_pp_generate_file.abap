FUNCTION zabsf_pp_generate_file .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(DOC_ID) TYPE  ZABSF_PP_E_DOC_ID OPTIONAL
*"     VALUE(MATNR_TAB) TYPE  ZABSF_PP_T_MATNR
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(FILE) TYPE  LOCALFILE
*"     VALUE(PDF_CONTENT) TYPE  SOLIX_TAB
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  DATA lref_sf_print TYPE REF TO zif_absf_pp_print.

  DATA: ld_class  TYPE recaimplclname,
        ld_method TYPE seocmpname.

*Get class of interface
  SELECT SINGLE imp_clname methodname
      FROM zabsf_pp003
      INTO (ld_class, ld_method)
     WHERE werks EQ inputobj-werks
       AND id_class EQ '6'
       AND endda GE refdt
       AND begda LE refdt.

  TRY .
      CREATE OBJECT lref_sf_print TYPE (ld_class)
        EXPORTING
          initial_refdt = refdt
          input_object  = inputobj.

    CATCH cx_sy_create_object_error.
*
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '019'
          msgv1      = ld_class
        CHANGING
          return_tab = return_tab.

      EXIT.
  ENDTRY.

  CALL METHOD lref_sf_print->(ld_method)
    EXPORTING
      doc_id      = doc_id
      matnr_tab   = matnr_tab
    CHANGING
      file        = file
      pdf_content = pdf_content
      return_tab  = return_tab.
ENDFUNCTION.
