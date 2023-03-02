class ZABSF_PP_CL_STATUS definition
  public
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !INITIAL_REFDT type VVDATUM
      !INPUT_OBJECT type ZABSF_PP_S_INPUTOBJECT .
  methods STATUS_OBJECT
    importing
      !ARBPL type ARBPL optional
      !AUFNR type AUFNR optional
      !VORNR type VORNR optional
      !MATNR type MATNR optional
      !MAKTX type MAKTX optional
      !WERKS type WERKS_D optional
      !OBJTY type J_OBART
      !STATUS type J_STATUS optional
      !STSMA type J_STSMA optional
      !METHOD type ZABSF_PP_E_METHOD
      !STATUS_OPER type J_STATUS optional
      !ACTIONID type ZABSF_PP_E_ACTION optional
      !STPRSNID type ZABSF_PP_E_STPRSNID optional
    changing
      !STATUS_INPUT_TAB type ZABSF_PP_T_STATUS_ORD optional
      !STATUS_OUT type J_STATUS optional
      !STATUS_DESC type J_TXT30 optional
      !STSMA_OUT type JSTO-STSMA optional
      !VORNR_DETAIL type ZABSF_PP_S_VORNR_DETAIL optional
      !RETURN_TAB type BAPIRET2_T .
protected section.
private section.

  data REFDT type VVDATUM .
  data INPUTOBJ type ZABSF_PP_S_INPUTOBJECT .
  constants OBJTYP_WRK type J_OBART value 'CA' ##NO_TEXT.
  constants OBJTYP_ORD type J_OBART value 'OR' ##NO_TEXT.
  constants NEW_STATUS type J_STATUS value 'AGU' ##NO_TEXT.
ENDCLASS.



CLASS ZABSF_PP_CL_STATUS IMPLEMENTATION.


METHOD CONSTRUCTOR.
*Ref. Date
  refdt    = initial_refdt.

*App input data
  inputobj = input_object.
ENDMETHOD.


METHOD status_object.
*Reference
  DATA lref_sf_status TYPE REF TO zif_ABSF_PP_status.

*Get class of interface
  SELECT SINGLE imp_clname
    FROM zabsf_pp003
    INTO (@DATA(l_class))
   WHERE werks    EQ @inputobj-werks
     AND id_class EQ '1'
     AND endda    GE @refdt
     AND begda    LE @refdt.

  TRY .
*    Create object of class - Status
      CREATE OBJECT lref_sf_status TYPE (l_class)
        EXPORTING
          initial_refdt = sy-datum
          input_object  = inputobj.

    CATCH cx_sy_create_object_error.
*    Send message error
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '019'
          msgv1      = l_class
        CHANGING
          return_tab = return_tab.
  ENDTRY.

  CASE objty.
    WHEN 'CA'. "Workcenter
      CASE method.
        WHEN 'G'.
          CALL METHOD lref_sf_status->get_status_wrk
            EXPORTING
              arbpl       = arbpl
              werks       = werks
            CHANGING
              status      = status_out
              status_desc = status_desc
              stsma       = stsma_out
              return_tab  = return_tab.
        WHEN 'S'.
          CALL METHOD lref_sf_status->set_status_wrk
            EXPORTING
              arbpl      = arbpl
              werks      = werks
              status     = status
              stsma      = stsma
              actionid   = actionid
            CHANGING
              return_tab = return_tab.
      ENDCASE.
    WHEN 'OV'. "Operation
      CASE method.
        WHEN 'S'.
          CALL METHOD lref_sf_status->set_status_vornr
            EXPORTING
              arbpl      = arbpl
              aufnr      = aufnr
              vornr      = vornr
              objty      = objty
              actionid   = actionid
              stprsnid   = stprsnid
            CHANGING
              status_out = status_out
              return_tab = return_tab.
        WHEN 'G'.
          CALL METHOD lref_sf_status->get_status_vornr
            EXPORTING
              arbpl        = arbpl
              aufnr        = aufnr
              matnr        = matnr
              maktx        = maktx
              vornr        = vornr
              actionid     = actionid
            CHANGING
              vornr_detail = vornr_detail
              return_tab   = return_tab.
      ENDCASE.
  ENDCASE.
ENDMETHOD.
ENDCLASS.
