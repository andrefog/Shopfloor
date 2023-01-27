FUNCTION z_pp10_get_batch_characteristc.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(I_WERKS) TYPE  WERKS_D
*"     REFERENCE(I_BATCH) TYPE  CHARG_D
*"     REFERENCE(I_MATNR) TYPE  MATNR
*"  EXPORTING
*"     REFERENCE(E_BATCH_VULC) TYPE  CHARG_D
*"----------------------------------------------------------------------
  DATA: lt_object        TYPE TABLE OF bapi1003_object_keys,
        lt_numtab        TYPE TABLE OF bapi1003_alloc_values_num,
        lt_chatab        TYPE TABLE OF bapi1003_alloc_values_char,
        lt_curtab        TYPE TABLE OF bapi1003_alloc_values_curr,
        lt_char_of_batch TYPE TABLE OF clbatch,
        lt_return        TYPE TABLE OF bapiret2.

*Structures
  DATA: ls_object        TYPE bapi1003_object_keys,
        ls_char_of_batch TYPE clbatch,
        ls_oprid         TYPE zabsf_pp_s_operador.

*Variables
  DATA: l_klart     TYPE klassenart,
        l_class     TYPE klasse_d,
        l_objectkey TYPE objnum.

*Constants
  CONSTANTS: c_mch1 TYPE tabelle VALUE 'MCH1'.

*Get class name and number
  PERFORM get_batch_class USING    i_matnr
                          CHANGING l_klart
                                   l_class.

*Create object
  CLEAR ls_object.
  ls_object-key_field = 'MATNR'.
  ls_object-value_int = i_matnr.
  APPEND ls_object TO lt_object.

  CLEAR ls_object.
  ls_object-key_field = 'WERKS'.
  ls_object-value_int = i_werks.
  APPEND ls_object TO lt_object.

  CLEAR ls_object.
  ls_object-key_field = 'CHARG'.
  ls_object-value_int = i_batch.
  APPEND ls_object TO lt_object.

  CALL FUNCTION 'BAPI_OBJCL_CONCATENATEKEY'
    EXPORTING
      objecttable    = c_mch1
    IMPORTING
      objectkey_conc = l_objectkey
    TABLES
      objectkeytable = lt_object
      return         = lt_return.

*Get batch detail
  CALL FUNCTION 'BAPI_OBJCL_GETDETAIL'
    EXPORTING
      objectkey       = l_objectkey
      objecttable     = c_mch1
      classnum        = l_class
      classtype       = l_klart
    TABLES
      allocvaluesnum  = lt_numtab
      allocvalueschar = lt_chatab
      allocvaluescurr = lt_curtab
      return          = lt_return.

*Numeric characteristic
  IF lt_numtab[] IS NOT INITIAL.
    LOOP AT lt_numtab INTO DATA(ls_numtab).
      CLEAR ls_char_of_batch.
      ls_char_of_batch-atnam = ls_numtab-charact.
      ls_char_of_batch-atwtb = ls_numtab-value_from.

      APPEND ls_char_of_batch TO lt_char_of_batch.
    ENDLOOP.
  ENDIF.

*Char characteristics
  IF lt_chatab[] IS NOT INITIAL.
    LOOP AT lt_chatab INTO DATA(ls_chatab).
      CLEAR ls_char_of_batch.
      ls_char_of_batch-atnam = ls_chatab-charact.
      ls_char_of_batch-atwtb = ls_chatab-value_neutral.

      APPEND ls_char_of_batch TO lt_char_of_batch.
    ENDLOOP.
  ENDIF.

*Currency characteristic
  IF lt_curtab[] IS NOT INITIAL.
    LOOP AT lt_curtab INTO DATA(ls_curtab).
      CLEAR ls_char_of_batch.
      ls_char_of_batch-atnam = ls_curtab-charact.
      ls_char_of_batch-atwtb = ls_curtab-value_from.

      APPEND ls_char_of_batch TO lt_char_of_batch.
    ENDLOOP.
  ENDIF.

  CLEAR ls_char_of_batch.
  READ TABLE lt_char_of_batch INTO ls_char_of_batch WITH KEY atnam =  'Z_INJECT_BATCH'.
  IF sy-subrc = 0.
    e_batch_vulc = ls_char_of_batch-atwtb.
  ENDIF.
ENDFUNCTION.
