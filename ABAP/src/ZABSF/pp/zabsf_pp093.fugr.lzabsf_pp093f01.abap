*----------------------------------------------------------------------*
***INCLUDE LZABSF_PP093F01.
*----------------------------------------------------------------------*
  TYPES:
    BEGIN OF ty_total.
      INCLUDE STRUCTURE zabsf_pp093.
    TYPES:
      status TYPE c,
    END OF ty_total,

    tt_total TYPE STANDARD TABLE OF ty_total WITH DEFAULT KEY.

*&---------------------------------------------------------------------*
*&      Form  SAVING
*&---------------------------------------------------------------------*
  FORM saving.
    DATA:
      lt_total TYPE tt_total,
      ls_total TYPE ty_total.

    LOOP AT total ASSIGNING FIELD-SYMBOL(<lv_total>).
      ls_total = <lv_total>.
      APPEND ls_total TO lt_total.
    ENDLOOP.

    DELETE lt_total WHERE status EQ 'L'.

    DATA(lv_build) = abap_true.

    LOOP AT lt_total ASSIGNING FIELD-SYMBOL(<ls_total>)
      WHERE status EQ 'N'
        OR  status EQ 'U'.
      PERFORM check_overlay
        USING <ls_total>-endpr <ls_total>-begpr <ls_total>-status lv_build.
      lv_build = abap_false.
    ENDLOOP.

    sy-subrc = 0.
  ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  CHANGING
*&---------------------------------------------------------------------*
  FORM changing .
    PERFORM check_overlay
      USING zabsf_pp093-endpr zabsf_pp093-begpr 'N' abap_true.

    sy-subrc = 0.
  ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  CHECK_OVERLAY
*&---------------------------------------------------------------------*
  FORM check_overlay USING iv_endpr TYPE zabsf_pp093-endpr
                           iv_begpr TYPE zabsf_pp093-begpr
                           iv_status TYPE c
                           iv_build TYPE boolean.
    STATICS:
      lt_total   TYPE tt_total,
      ls_total   TYPE ty_total,
      ls_extract TYPE ty_total.

    IF iv_build EQ abap_true.
      CLEAR lt_total[].
      LOOP AT total ASSIGNING FIELD-SYMBOL(<lv_total>).
        ls_total = <lv_total>.
        APPEND ls_total TO lt_total.
      ENDLOOP.

      DELETE lt_total WHERE status EQ 'L'.
    ENDIF.

    LOOP AT lt_total ASSIGNING FIELD-SYMBOL(<ls_overlay>)
      WHERE endpr  GE iv_begpr
        AND begpr  LE iv_endpr
        AND endpr  NE  iv_endpr
        AND status NE iv_status
        AND status NE 'D'.

      IF <ls_overlay>-endpr LE iv_endpr AND
         <ls_overlay>-begpr GE iv_begpr.
        <ls_overlay>-status = 'D'.

      ELSEIF <ls_overlay>-endpr GT iv_endpr AND
             <ls_overlay>-begpr LT iv_begpr.
        ls_total        = <ls_overlay>.
        ls_total-endpr  = iv_begpr - 1.
        ls_total-status = 'N'.
        APPEND ls_total TO lt_total.

        <ls_overlay>-begpr  = iv_endpr + 1.
        <ls_overlay>-status = 'U'.
      ELSE.
        IF <ls_overlay>-begpr BETWEEN iv_begpr AND iv_endpr.
          <ls_overlay>-begpr  = zabsf_pp093-endpr + 1.
          <ls_overlay>-status = 'U'.
        ELSEIF <ls_overlay>-endpr BETWEEN iv_begpr AND iv_endpr.
          ls_total            = <ls_overlay>.
          <ls_overlay>-status = 'D'.
          ls_total-endpr      = iv_begpr - 1.
          ls_total-status     = 'N'.
          APPEND ls_total TO lt_total.
        ENDIF.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_total ASSIGNING FIELD-SYMBOL(<ls_total>).
      READ TABLE extract
        WITH KEY = <ls_total>(6)
        ASSIGNING FIELD-SYMBOL(<lv_extract>).
      IF sy-subrc IS INITIAL.
        ls_extract = <lv_extract>.
        ls_extract-status = <ls_overlay>-status.
        <lv_extract> = ls_extract.
      ENDIF.
    ENDLOOP.

    total[] = lt_total[].

    sy-subrc = 0.
  ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  VALIDATE_ENDPR  INPUT
*&---------------------------------------------------------------------*
  MODULE validate_endpr INPUT.
    CHECK zabsf_pp093-endpr LT 0 OR zabsf_pp093-endpr GT 100.
    " Enter value between 0 and 100.
    MESSAGE e398(00) WITH TEXT-e01.

  ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDATE_BEGPR  INPUT
*&---------------------------------------------------------------------*
  MODULE validate_begpr INPUT.
    CHECK zabsf_pp093-begpr LT 0 OR zabsf_pp093-begpr GT 100.
    " Enter value between 0 and 100.
    MESSAGE e398(00) WITH TEXT-e01.

  ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDATE_CLRPR  INPUT
*&---------------------------------------------------------------------*
  MODULE validate_clrpr INPUT.
    CHECK zabsf_pp093-clrpr IS INITIAL.
    " Enter value for color.
    MESSAGE e398(00) WITH TEXT-e02.

  ENDMODULE.
