*---------------------------------------------------------------------*
*    view related FORM routines
*---------------------------------------------------------------------*
*...processing: ZABSF_PP_V_SF037................................*
FORM GET_DATA_ZABSF_PP_V_SF037.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZABSF_PP034 WHERE
(VIM_WHERETAB) .
    CLEAR ZABSF_PP_V_SF037 .
ZABSF_PP_V_SF037-MANDT =
ZABSF_PP034-MANDT .
ZABSF_PP_V_SF037-AREAID =
ZABSF_PP034-AREAID .
ZABSF_PP_V_SF037-WAREID =
ZABSF_PP034-WAREID .
ZABSF_PP_V_SF037-MATNR =
ZABSF_PP034-MATNR .
ZABSF_PP_V_SF037-DATA =
ZABSF_PP034-DATA .
ZABSF_PP_V_SF037-TIME =
ZABSF_PP034-TIME .
ZABSF_PP_V_SF037-GRUND =
ZABSF_PP034-GRUND .
ZABSF_PP_V_SF037-OPRID =
ZABSF_PP034-OPRID .
ZABSF_PP_V_SF037-SCRAP_QTY =
ZABSF_PP034-SCRAP_QTY .
ZABSF_PP_V_SF037-GMEIN =
ZABSF_PP034-GMEIN .
<VIM_TOTAL_STRUC> = ZABSF_PP_V_SF037.
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
FORM DB_UPD_ZABSF_PP_V_SF037 .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZABSF_PP_V_SF037.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZABSF_PP_V_SF037-ST_DELETE EQ GELOESCHT.
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
  SELECT SINGLE FOR UPDATE * FROM ZABSF_PP034 WHERE
  AREAID = ZABSF_PP_V_SF037-AREAID AND
  WAREID = ZABSF_PP_V_SF037-WAREID AND
  MATNR = ZABSF_PP_V_SF037-MATNR AND
  DATA = ZABSF_PP_V_SF037-DATA AND
  TIME = ZABSF_PP_V_SF037-TIME AND
  GRUND = ZABSF_PP_V_SF037-GRUND AND
  OPRID = ZABSF_PP_V_SF037-OPRID .
    IF SY-SUBRC = 0.
    DELETE ZABSF_PP034 .
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
  SELECT SINGLE FOR UPDATE * FROM ZABSF_PP034 WHERE
  AREAID = ZABSF_PP_V_SF037-AREAID AND
  WAREID = ZABSF_PP_V_SF037-WAREID AND
  MATNR = ZABSF_PP_V_SF037-MATNR AND
  DATA = ZABSF_PP_V_SF037-DATA AND
  TIME = ZABSF_PP_V_SF037-TIME AND
  GRUND = ZABSF_PP_V_SF037-GRUND AND
  OPRID = ZABSF_PP_V_SF037-OPRID .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZABSF_PP034.
    ENDIF.
ZABSF_PP034-MANDT =
ZABSF_PP_V_SF037-MANDT .
ZABSF_PP034-AREAID =
ZABSF_PP_V_SF037-AREAID .
ZABSF_PP034-WAREID =
ZABSF_PP_V_SF037-WAREID .
ZABSF_PP034-MATNR =
ZABSF_PP_V_SF037-MATNR .
ZABSF_PP034-DATA =
ZABSF_PP_V_SF037-DATA .
ZABSF_PP034-TIME =
ZABSF_PP_V_SF037-TIME .
ZABSF_PP034-GRUND =
ZABSF_PP_V_SF037-GRUND .
ZABSF_PP034-OPRID =
ZABSF_PP_V_SF037-OPRID .
ZABSF_PP034-SCRAP_QTY =
ZABSF_PP_V_SF037-SCRAP_QTY .
ZABSF_PP034-GMEIN =
ZABSF_PP_V_SF037-GMEIN .
    IF SY-SUBRC = 0.
    UPDATE ZABSF_PP034 ##WARN_OK.
    ELSE.
    INSERT ZABSF_PP034 .
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
CLEAR: STATUS_ZABSF_PP_V_SF037-UPD_FLAG,
STATUS_ZABSF_PP_V_SF037-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ZABSF_PP_V_SF037.
  SELECT SINGLE * FROM ZABSF_PP034 WHERE
AREAID = ZABSF_PP_V_SF037-AREAID AND
WAREID = ZABSF_PP_V_SF037-WAREID AND
MATNR = ZABSF_PP_V_SF037-MATNR AND
DATA = ZABSF_PP_V_SF037-DATA AND
TIME = ZABSF_PP_V_SF037-TIME AND
GRUND = ZABSF_PP_V_SF037-GRUND AND
OPRID = ZABSF_PP_V_SF037-OPRID .
ZABSF_PP_V_SF037-MANDT =
ZABSF_PP034-MANDT .
ZABSF_PP_V_SF037-AREAID =
ZABSF_PP034-AREAID .
ZABSF_PP_V_SF037-WAREID =
ZABSF_PP034-WAREID .
ZABSF_PP_V_SF037-MATNR =
ZABSF_PP034-MATNR .
ZABSF_PP_V_SF037-DATA =
ZABSF_PP034-DATA .
ZABSF_PP_V_SF037-TIME =
ZABSF_PP034-TIME .
ZABSF_PP_V_SF037-GRUND =
ZABSF_PP034-GRUND .
ZABSF_PP_V_SF037-OPRID =
ZABSF_PP034-OPRID .
ZABSF_PP_V_SF037-SCRAP_QTY =
ZABSF_PP034-SCRAP_QTY .
ZABSF_PP_V_SF037-GMEIN =
ZABSF_PP034-GMEIN .
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZABSF_PP_V_SF037 USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZABSF_PP_V_SF037-AREAID TO
ZABSF_PP034-AREAID .
MOVE ZABSF_PP_V_SF037-WAREID TO
ZABSF_PP034-WAREID .
MOVE ZABSF_PP_V_SF037-MATNR TO
ZABSF_PP034-MATNR .
MOVE ZABSF_PP_V_SF037-DATA TO
ZABSF_PP034-DATA .
MOVE ZABSF_PP_V_SF037-TIME TO
ZABSF_PP034-TIME .
MOVE ZABSF_PP_V_SF037-GRUND TO
ZABSF_PP034-GRUND .
MOVE ZABSF_PP_V_SF037-OPRID TO
ZABSF_PP034-OPRID .
MOVE ZABSF_PP_V_SF037-MANDT TO
ZABSF_PP034-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZABSF_PP034'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZABSF_PP034 TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZABSF_PP034'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
