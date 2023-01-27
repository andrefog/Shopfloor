FUNCTION ZABSF_PM_GET_ATTACH_FILE.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(I_GUID) TYPE  CHAR40 OPTIONAL
*"     VALUE(I_ATTA_ID) TYPE  GOS_ATTA_ID OPTIONAL
*"     VALUE(I_ATTA_CAT) TYPE  GOS_ATTA_CAT OPTIONAL
*"  EXPORTING
*"     VALUE(E_FILE_BASE64) TYPE  XSTRING
*"     VALUE(E_FILE_MIMETYPE) TYPE  W3CONTTYPE
*"     VALUE(E_FILE_EXTENSION) TYPE  CHAR10
*"----------------------------------------------------------------------
*
*  Variables
  DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

  CALL METHOD ZCL_ABSF_PM=>get_attachment_file
    EXPORTING
      i_guid = i_guid
      i_atta_id = i_atta_id
      i_atta_cat = i_atta_cat

    IMPORTING
      e_file_base64 = e_file_base64
      e_file_mimetype = e_file_mimetype
      e_file_extension = e_file_extension.

ENDFUNCTION.
