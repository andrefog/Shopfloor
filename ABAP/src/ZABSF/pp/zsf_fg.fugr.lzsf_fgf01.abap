*----------------------------------------------------------------------*
***INCLUDE LZSF_FGF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  ZABSF_AUTOINCREMENT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*

FORM zabsf_autoincrement .
  DATA: lv_num TYPE ZABSF_PP_E_SEQID.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      nr_range_nr             = '01'
      object                  = 'ZSF_SEQID'
    IMPORTING
      number                  = lv_num
    EXCEPTIONS
      interval_not_found      = 1
      number_range_not_intern = 2
      object_not_found        = 3
      quantity_is_0           = 4
      quantity_is_not_1       = 5
      interval_overflow       = 6
      buffer_overflow         = 7
      OTHERS                  = 8.

  IF sy-subrc EQ 0.
    ZABSF_PP004-SEQID = lv_num.
  ENDIF.
ENDFORM.
