*---------------------------------------------------------------------*
*    view related FORM routines
*---------------------------------------------------------------------*
*...processing: ZABSF_PP_V_SF031................................*
FORM GET_DATA_ZABSF_PP_V_SF031.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZABSF_PP041 WHERE
(VIM_WHERETAB) .
    CLEAR ZABSF_PP_V_SF031 .
ZABSF_PP_V_SF031-MANDT =
ZABSF_PP041-MANDT .
ZABSF_PP_V_SF031-AREAID =
ZABSF_PP041-AREAID .
ZABSF_PP_V_SF031-WERKS =
ZABSF_PP041-WERKS .
ZABSF_PP_V_SF031-WAREID =
ZABSF_PP041-WAREID .
ZABSF_PP_V_SF031-MATNR =
ZABSF_PP041-MATNR .
ZABSF_PP_V_SF031-LOW_LIMIT =
ZABSF_PP041-LOW_LIMIT .
ZABSF_PP_V_SF031-MAX_LIMIT =
ZABSF_PP041-MAX_LIMIT .
ZABSF_PP_V_SF031-GMEIN =
ZABSF_PP041-GMEIN .
<VIM_TOTAL_STRUC> = ZABSF_PP_V_SF031.
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
FORM DB_UPD_ZABSF_PP_V_SF031 .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZABSF_PP_V_SF031.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZABSF_PP_V_SF031-ST_DELETE EQ GELOESCHT.
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
  SELECT SINGLE FOR UPDATE * FROM ZABSF_PP041 WHERE
  AREAID = ZABSF_PP_V_SF031-AREAID AND
  WERKS = ZABSF_PP_V_SF031-WERKS AND
  WAREID = ZABSF_PP_V_SF031-WAREID AND
  MATNR = ZABSF_PP_V_SF031-MATNR .
    IF SY-SUBRC = 0.
    DELETE ZABSF_PP041 .
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
  SELECT SINGLE FOR UPDATE * FROM ZABSF_PP041 WHERE
  AREAID = ZABSF_PP_V_SF031-AREAID AND
  WERKS = ZABSF_PP_V_SF031-WERKS AND
  WAREID = ZABSF_PP_V_SF031-WAREID AND
  MATNR = ZABSF_PP_V_SF031-MATNR .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZABSF_PP041.
    ENDIF.
ZABSF_PP041-MANDT =
ZABSF_PP_V_SF031-MANDT .
ZABSF_PP041-AREAID =
ZABSF_PP_V_SF031-AREAID .
ZABSF_PP041-WERKS =
ZABSF_PP_V_SF031-WERKS .
ZABSF_PP041-WAREID =
ZABSF_PP_V_SF031-WAREID .
ZABSF_PP041-MATNR =
ZABSF_PP_V_SF031-MATNR .
ZABSF_PP041-LOW_LIMIT =
ZABSF_PP_V_SF031-LOW_LIMIT .
ZABSF_PP041-MAX_LIMIT =
ZABSF_PP_V_SF031-MAX_LIMIT .
ZABSF_PP041-GMEIN =
ZABSF_PP_V_SF031-GMEIN .
    IF SY-SUBRC = 0.
    UPDATE ZABSF_PP041 ##WARN_OK.
    ELSE.
    INSERT ZABSF_PP041 .
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
CLEAR: STATUS_ZABSF_PP_V_SF031-UPD_FLAG,
STATUS_ZABSF_PP_V_SF031-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ZABSF_PP_V_SF031.
  SELECT SINGLE * FROM ZABSF_PP041 WHERE
AREAID = ZABSF_PP_V_SF031-AREAID AND
WERKS = ZABSF_PP_V_SF031-WERKS AND
WAREID = ZABSF_PP_V_SF031-WAREID AND
MATNR = ZABSF_PP_V_SF031-MATNR .
ZABSF_PP_V_SF031-MANDT =
ZABSF_PP041-MANDT .
ZABSF_PP_V_SF031-AREAID =
ZABSF_PP041-AREAID .
ZABSF_PP_V_SF031-WERKS =
ZABSF_PP041-WERKS .
ZABSF_PP_V_SF031-WAREID =
ZABSF_PP041-WAREID .
ZABSF_PP_V_SF031-MATNR =
ZABSF_PP041-MATNR .
ZABSF_PP_V_SF031-LOW_LIMIT =
ZABSF_PP041-LOW_LIMIT .
ZABSF_PP_V_SF031-MAX_LIMIT =
ZABSF_PP041-MAX_LIMIT .
ZABSF_PP_V_SF031-GMEIN =
ZABSF_PP041-GMEIN .
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZABSF_PP_V_SF031 USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZABSF_PP_V_SF031-AREAID TO
ZABSF_PP041-AREAID .
MOVE ZABSF_PP_V_SF031-WERKS TO
ZABSF_PP041-WERKS .
MOVE ZABSF_PP_V_SF031-WAREID TO
ZABSF_PP041-WAREID .
MOVE ZABSF_PP_V_SF031-MATNR TO
ZABSF_PP041-MATNR .
MOVE ZABSF_PP_V_SF031-MANDT TO
ZABSF_PP041-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZABSF_PP041'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZABSF_PP041 TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZABSF_PP041'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
