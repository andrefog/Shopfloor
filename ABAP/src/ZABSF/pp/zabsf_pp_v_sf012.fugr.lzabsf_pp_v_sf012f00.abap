*---------------------------------------------------------------------*
*    view related FORM routines
*---------------------------------------------------------------------*
*...processing: ZABSF_PP_V_SF012................................*
FORM GET_DATA_ZABSF_PP_V_SF012.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZABSF_PP013 WHERE
(VIM_WHERETAB) .
    CLEAR ZABSF_PP_V_SF012 .
ZABSF_PP_V_SF012-MANDT =
ZABSF_PP013-MANDT .
ZABSF_PP_V_SF012-AREAID =
ZABSF_PP013-AREAID .
ZABSF_PP_V_SF012-WERKS =
ZABSF_PP013-WERKS .
ZABSF_PP_V_SF012-ARBPL =
ZABSF_PP013-ARBPL .
ZABSF_PP_V_SF012-ENDDA =
ZABSF_PP013-ENDDA .
ZABSF_PP_V_SF012-BEGDA =
ZABSF_PP013-BEGDA .
ZABSF_PP_V_SF012-PRDTY =
ZABSF_PP013-PRDTY .
ZABSF_PP_V_SF012-QTY_PREV =
ZABSF_PP013-QTY_PREV .
ZABSF_PP_V_SF012-REG_QUANT =
ZABSF_PP013-REG_QUANT .
ZABSF_PP_V_SF012-TIP_TRAB =
ZABSF_PP013-TIP_TRAB .
ZABSF_PP_V_SF012-ARBPL_TYPE =
ZABSF_PP013-ARBPL_TYPE .
<VIM_TOTAL_STRUC> = ZABSF_PP_V_SF012.
    APPEND TOTAL.
  ENDSELECT.
  SORT TOTAL BY <VIM_XTOTAL_KEY>.
  <STATUS>-ALR_SORTED = 'R'.
*.check dynamic selectoptions (not in DDIC)...........................*
  IF X_HEADER-SELECTION NE SPACE.
    PERFORM CHECK_DYNAMIC_SELECT_OPTIONS.
  ELSEIF X_HEADER-DELMDTFLAG NE SPACE.
    PERFORM BUILD_MAINKEY_TAB.
  ENDIF.
  REFRESH EXTRACT.
ENDFORM.
*---------------------------------------------------------------------*
FORM DB_UPD_ZABSF_PP_V_SF012 .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZABSF_PP_V_SF012.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZABSF_PP_V_SF012-ST_DELETE EQ GELOESCHT.
     READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
     IF SY-SUBRC EQ 0.
       DELETE EXTRACT INDEX SY-TABIX.
     ENDIF.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN GELOESCHT.
  SELECT SINGLE FOR UPDATE * FROM ZABSF_PP013 WHERE
  AREAID = ZABSF_PP_V_SF012-AREAID AND
  WERKS = ZABSF_PP_V_SF012-WERKS AND
  ARBPL = ZABSF_PP_V_SF012-ARBPL AND
  ENDDA = ZABSF_PP_V_SF012-ENDDA .
    IF SY-SUBRC = 0.
    DELETE ZABSF_PP013 .
    ENDIF.
    IF STATUS-DELETE EQ GELOESCHT.
      READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY> BINARY SEARCH.
      DELETE EXTRACT INDEX SY-TABIX.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN OTHERS.
  SELECT SINGLE FOR UPDATE * FROM ZABSF_PP013 WHERE
  AREAID = ZABSF_PP_V_SF012-AREAID AND
  WERKS = ZABSF_PP_V_SF012-WERKS AND
  ARBPL = ZABSF_PP_V_SF012-ARBPL AND
  ENDDA = ZABSF_PP_V_SF012-ENDDA .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZABSF_PP013.
    ENDIF.
ZABSF_PP013-MANDT =
ZABSF_PP_V_SF012-MANDT .
ZABSF_PP013-AREAID =
ZABSF_PP_V_SF012-AREAID .
ZABSF_PP013-WERKS =
ZABSF_PP_V_SF012-WERKS .
ZABSF_PP013-ARBPL =
ZABSF_PP_V_SF012-ARBPL .
ZABSF_PP013-ENDDA =
ZABSF_PP_V_SF012-ENDDA .
ZABSF_PP013-BEGDA =
ZABSF_PP_V_SF012-BEGDA .
ZABSF_PP013-PRDTY =
ZABSF_PP_V_SF012-PRDTY .
ZABSF_PP013-QTY_PREV =
ZABSF_PP_V_SF012-QTY_PREV .
ZABSF_PP013-REG_QUANT =
ZABSF_PP_V_SF012-REG_QUANT .
ZABSF_PP013-TIP_TRAB =
ZABSF_PP_V_SF012-TIP_TRAB .
ZABSF_PP013-ARBPL_TYPE =
ZABSF_PP_V_SF012-ARBPL_TYPE .
    IF SY-SUBRC = 0.
    UPDATE ZABSF_PP013 ##WARN_OK.
    ELSE.
    INSERT ZABSF_PP013 .
    ENDIF.
    READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
    IF SY-SUBRC EQ 0.
      <XACT> = ORIGINAL.
      MODIFY EXTRACT INDEX SY-TABIX.
    ENDIF.
    <ACTION> = ORIGINAL.
    MODIFY TOTAL.
  ENDCASE.
ENDLOOP.
CLEAR: STATUS_ZABSF_PP_V_SF012-UPD_FLAG,
STATUS_ZABSF_PP_V_SF012-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ZABSF_PP_V_SF012.
  SELECT SINGLE * FROM ZABSF_PP013 WHERE
AREAID = ZABSF_PP_V_SF012-AREAID AND
WERKS = ZABSF_PP_V_SF012-WERKS AND
ARBPL = ZABSF_PP_V_SF012-ARBPL AND
ENDDA = ZABSF_PP_V_SF012-ENDDA .
ZABSF_PP_V_SF012-MANDT =
ZABSF_PP013-MANDT .
ZABSF_PP_V_SF012-AREAID =
ZABSF_PP013-AREAID .
ZABSF_PP_V_SF012-WERKS =
ZABSF_PP013-WERKS .
ZABSF_PP_V_SF012-ARBPL =
ZABSF_PP013-ARBPL .
ZABSF_PP_V_SF012-ENDDA =
ZABSF_PP013-ENDDA .
ZABSF_PP_V_SF012-BEGDA =
ZABSF_PP013-BEGDA .
ZABSF_PP_V_SF012-PRDTY =
ZABSF_PP013-PRDTY .
ZABSF_PP_V_SF012-QTY_PREV =
ZABSF_PP013-QTY_PREV .
ZABSF_PP_V_SF012-REG_QUANT =
ZABSF_PP013-REG_QUANT .
ZABSF_PP_V_SF012-TIP_TRAB =
ZABSF_PP013-TIP_TRAB .
ZABSF_PP_V_SF012-ARBPL_TYPE =
ZABSF_PP013-ARBPL_TYPE .
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZABSF_PP_V_SF012 USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZABSF_PP_V_SF012-AREAID TO
ZABSF_PP013-AREAID .
MOVE ZABSF_PP_V_SF012-WERKS TO
ZABSF_PP013-WERKS .
MOVE ZABSF_PP_V_SF012-ARBPL TO
ZABSF_PP013-ARBPL .
MOVE ZABSF_PP_V_SF012-ENDDA TO
ZABSF_PP013-ENDDA .
MOVE ZABSF_PP_V_SF012-MANDT TO
ZABSF_PP013-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZABSF_PP013'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZABSF_PP013 TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZABSF_PP013'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
