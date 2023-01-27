FUNCTION zabsf_pm_upload_file.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_OBJTYPE) TYPE  CHAR2 OPTIONAL
*"     VALUE(I_SERV_TYPE) TYPE  CHAR2 OPTIONAL
*"     VALUE(I_VALUE) TYPE  STRING
*"     VALUE(I_FILENAME) TYPE  SO_OBJ_DES
*"     VALUE(I_OBJECT) TYPE  STRING
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT OPTIONAL
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"     VALUE(FILEINFO_RETURNTAB) TYPE  ZABSF_PM_S_UPLOAD_RETURNTAB
*"----------------------------------------------------------------------


  DATA:
    l_document_data      TYPE sodocchgi1,
    l_document_type      TYPE so_obj_tp,
    l_document_info      TYPE sofolenti1,
    l_object_content_hex TYPE TABLE OF solix,
*    l_line_content_hex   TYPE solix,
    l_only_name          TYPE string.

*    l_extension          TYPE hap_attachment_type,
*    l_msgno              TYPE char3,
*    l_data_read          TYPE i,
*    l_vendor_id          TYPE borident,
*    l_attachment_id      TYPE borident,
*    ls_doc_bor_key       TYPE hap_s_doc_bor_key,
*    conv_class           TYPE REF TO cl_abap_conv_in_ce,
*    off_class            TYPE REF TO cl_abap_view_offlen.

  DATA: lt_object_header TYPE STANDARD TABLE OF solisti1,
        ls_object_header TYPE solisti1.

  DATA: ls_objectbo  TYPE sibflporb,
        ls_objectatt TYPE sibflporb,
        ls_link      TYPE obl_s_link,

        lv_tplnr     TYPE tplnr,
        lv_equnr     TYPE equnr,
        lv_qmnum     TYPE qmnum,
        lv_aufnr     TYPE aufnr.

  DATA l_folder_id  TYPE sofdk.

  DATA : ls_srgbtbrel TYPE srgbtbrel.

  DATA : lv_brelguid TYPE os_guid.


  IF i_objtype = 'FL'. "FUNCTIONAL LOCATION
    MOVE i_object TO lv_tplnr.

    CALL FUNCTION 'CONVERSION_EXIT_TPLNR_INPUT'
      EXPORTING
        input  = lv_tplnr
      IMPORTING
        output = lv_tplnr.

  ELSEIF i_objtype = 'EQ'. "EQUIPMENT
    MOVE i_object TO lv_equnr.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lv_equnr
      IMPORTING
        output = lv_equnr.

  ELSEIF i_objtype = 'NT'. "Notification
    MOVE i_object TO lv_qmnum.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lv_qmnum
      IMPORTING
        output = lv_qmnum.

  ELSEIF i_objtype = 'OR'.
    MOVE i_object TO lv_aufnr.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lv_aufnr
      IMPORTING
        output = lv_aufnr.

  ENDIF.



  CALL FUNCTION 'SO_FOLDER_ROOT_ID_GET'
    EXPORTING
      region                = 'B'
    IMPORTING
      folder_id             = l_folder_id
    EXCEPTIONS
      communication_failure = 1
      owner_not_exist       = 2
      system_failure        = 3
      x_error               = 4
      OTHERS                = 5.


  l_document_data-obj_descr = i_filename.
  l_document_data-obj_name  = 'ATTACHMENT'. "MITTEILUNG'.
  l_only_name = i_filename.

  CALL METHOD cl_bcs_utilities=>split_name
    EXPORTING
      iv_name      = i_filename
    IMPORTING
      ev_extension = l_document_type.


  DATA: lv_bindata TYPE xstring.

  CALL FUNCTION 'SSFC_BASE64_DECODE'
    EXPORTING
      b64data = i_value
*     B64LENG =
*     B_CHECK =
    IMPORTING
      bindata = lv_bindata
*     EXCEPTIONS
*     SSF_KRN_ERROR            = 1
*     SSF_KRN_NOOP             = 2
*     SSF_KRN_NOMEMORY         = 3
*     SSF_KRN_OPINV            = 4
*     SSF_KRN_INPUT_DATA_ERROR = 5
*     SSF_KRN_INVALID_PAR      = 6
*     SSF_KRN_INVALID_PARLEN   = 7
*     OTHERS  = 8
    .
  l_document_data-doc_size = xstrlen( lv_bindata ).
  CONCATENATE '&SO_FILENAME=' l_only_name INTO ls_object_header-line.
  APPEND ls_object_header TO lt_object_header.


  CALL METHOD cl_bcs_convert=>xstring_to_solix
    EXPORTING
      iv_xstring = lv_bindata
    RECEIVING
      et_solix   = l_object_content_hex.

  CALL FUNCTION 'SO_DOCUMENT_INSERT_API1'
    EXPORTING
      folder_id                  = l_folder_id
      document_data              = l_document_data
      document_type              = l_document_type
    IMPORTING
      document_info              = l_document_info
    TABLES
*     object_content             = l_object_content
      contents_hex               = l_object_content_hex
      object_header              = lt_object_header
    EXCEPTIONS
      folder_not_exist           = 1
      document_type_not_exist    = 2
      operation_no_authorization = 3
      parameter_error            = 4
      x_error                    = 5
      enqueue_error              = 6
      OTHERS                     = 7.


** fill key information for the business object
*  ls_doc_bor_key-planversion = '01'.
*  ls_doc_bor_key-id = lv_lifnr.
*
*  "    ls_doc_bor_key-id          = '0000000001'.
*  CLEAR ls_doc_bor_key-partid.
*
** assign BOR-key (for appraisal document)
*  l_vendor_id = ls_doc_bor_key.
*  l_vendor_id-objtype = 'LFA1'.
**  l_vendor_id-objtype = 'IFLOT'.
*
*  l_attachment_id-objtype = 'MESSAGE'. "'SOFM'.
*  l_attachment_id-objkey  = l_document_info-doc_id(34).


  IF i_objtype = 'FL'. "FUNCTIONAL LOCATION
    ls_objectbo-typeid    = 'BUS0010'.
    ls_objectbo-instid    = lv_tplnr."'0000000001'.
    ls_objectbo-catid = 'BO'.
  ELSEIF i_objtype = 'EQ'. "EQUIPMENT
    ls_objectbo-typeid    = 'EQUI'.
    ls_objectbo-instid    = lv_equnr."'0000000001'.
    ls_objectbo-catid = 'BO'.
  ELSEIF i_objtype = 'NT'. "NOTIFICATION  PM or CS

    IF i_serv_type = 'PM'.
      ls_objectbo-typeid    = 'BUS2038'.
    ELSEIF i_serv_type = 'CS'.
      ls_objectbo-typeid    = 'BUS2080'.
    ENDIF.
    ls_objectbo-instid    = lv_qmnum.
    ls_objectbo-catid = 'BO'.

  ELSEIF i_objtype = 'OR'.
    ls_objectbo-typeid    = 'BUS2007'.
    ls_objectbo-instid    = lv_aufnr.
    ls_objectbo-catid = 'BO'.
  ELSE.
*    ls_objectbo-typeid    = 'LFA1'.
*    ls_objectbo-instid    = lv_lifnr."'0000000001'.
*    ls_objectbo-catid = 'BO'.
  ENDIF.

  ls_objectatt-typeid   = 'MESSAGE'."'SOFM'.
  ls_objectatt-instid    =  l_document_info-doc_id(34).
  ls_objectatt-catid     = 'BO'.

  ls_link-reltype       = 'ATTA'.


  CALL METHOD cl_binary_relation=>create_link
    EXPORTING
      is_object_a = ls_objectbo
      is_object_b = ls_objectatt
      ip_reltype  = ls_link-reltype
    IMPORTING
      ep_link_id  = lv_brelguid. " fileinfo_returntab-brelguid.

  COMMIT WORK AND WAIT.

* get atta cat and atta_id

  SELECT SINGLE * FROM srgbtbrel INTO ls_srgbtbrel
      WHERE brelguid = lv_brelguid. "fileinfo_returntab-brelguid.

  IF sy-subrc EQ 0.
    fileinfo_returntab-atta_id = ls_srgbtbrel-instid_b.
    fileinfo_returntab-atta_cat = 'MSG'.


  ENDIF.

  WRITE lv_brelguid TO fileinfo_returntab-brelguid.


ENDFUNCTION.
