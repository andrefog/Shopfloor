class ZABSF_WM_AUX definition
  public
  final
  create public .

public section.

  class-methods CREATE_TO
    importing
      value(I_WERKS) type WERKS_D optional
      value(I_LGNUM) type LGNUM optional
      value(I_LGORT) type LGORT_D optional
      value(I_LGTYP) type LGTYP optional
      value(I_LGPLA) type LGPLA optional
      value(I_NLTYP) type LTAP_NLTYP optional
      value(I_NLPLA) type LTAP_NLPLA optional
      value(I_BESTQ) type BESTQ optional
      value(I_MATERIALS) type ZABSF_PP_S_COMPONENTS
    exporting
      value(E_RETURN_TAB) type BAPIRET1_TAB
    changing
      value(E_TANUM) type TANUM optional .
protected section.
private section.
ENDCLASS.



CLASS ZABSF_WM_AUX IMPLEMENTATION.


METHOD create_to.
*
*    DATA: lv_tanum      TYPE tanum,
*          lt_ltap_creat TYPE TABLE OF ltap_creat,
*          ls_ltap_creat TYPE ltap_creat.
*
*    DATA ls_return  TYPE bapiret1.
*
*    DATA l_no_auth  TYPE flag01.
*
*    DATA: lv_msgv1 TYPE symsgv,
*          lv_msgv2 TYPE symsgv.
*
*    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
*      EXPORTING
*        input        = i_materials-matnr
*      IMPORTING
*        output       = i_materials-matnr
*      EXCEPTIONS
*        length_error = 1
*        OTHERS       = 2.
*
*  SELECT lqua~matnr, lqua~charg, lqua~letyp, lqua~lenum, lqua~meins, t331~lenvw
*    FROM lqua INNER JOIN t331 ON t331~lgnum = lqua~lgnum
*                             AND t331~lgtyp = lqua~lgtyp
*    INTO TABLE @DATA(lt_lqua)
*     FOR ALL ENTRIES IN @i_materials
*   WHERE lqua~lgnum = @i_lgnum
*     AND lqua~lgtyp = @i_lgtyp
*     AND lqua~lgpla = @i_lgpla
*     AND lqua~matnr = @i_materials-matnr
*     AND lqua~charg = @i_materials-charg
*     AND lqua~verme > 0
*     AND lqua~einme = 0
*     AND lqua~ausme = 0.
*
*    LOOP AT i_materials INTO DATA(ls_materials).
*
*      MOVE ls_materials-matnr TO lv_msgv1.
*      MOVE ls_materials-charg TO lv_msgv2.
*
*      READ TABLE lt_lqua INTO DATA(ls_lqua) WITH KEY matnr = ls_materials-matnr
*                                                     charg = ls_materials-charg.
*
*      IF sy-subrc <> 0.
*
*        CALL METHOD zmob02_aux_class=>add_message_ret1
*          EXPORTING
*            langu     = i_user_lang
*            msgid     = 'ZMOB02'
*            msgno     = '015'
*            msgty     = 'E'
*            msgv1     = lv_msgv1
*            msgv2     = lv_msgv2
*          IMPORTING
*            et_return = e_return_tab.
*
*      ENDIF.
*
*      CALL METHOD zmob02_aux_class=>check_hu_managment
*        EXPORTING
*          lgnum         = i_lgnum
*          lgtyp         = i_nltyp
*        IMPORTING
*          managed_by_hu = lv_managed_by_hu.
*
*      IF lv_managed_by_hu EQ abap_true.
*
*        SELECT SINGLE * FROM lqua INTO @DATA(ls_lqua_aux)
*          WHERE werks = @i_werks
*          AND lgnum = @i_lgnum
*          AND lgtyp = @i_nltyp
*          AND lgpla = @i_nlpla.
*
*          IF sy-subrc EQ 0.
*            ls_ltap_creat-nlenr = ls_lqua_aux-lenum.
*            ls_ltap_creat-letyp = ls_lqua_aux-letyp.
*          ENDIF.
*
*        ENDIF.
*
*        ls_ltap_creat-matnr = ls_materials-matnr.
*        ls_ltap_creat-charg = ls_materials-charg.
*        ls_ltap_creat-werks = i_werks.
*        ls_ltap_creat-lgort = i_lgort.
*        ls_ltap_creat-anfme = ls_materials-anfme.
*        ls_ltap_creat-altme = ls_lqua-meins.
*        ls_ltap_creat-letyp = ls_lqua-letyp.
*        ls_ltap_creat-vlenr = ls_lqua-lenum.
*        ls_ltap_creat-vltyp = i_lgtyp.
*        ls_ltap_creat-vlpla = i_lgpla.
*        ls_ltap_creat-nltyp = i_nltyp.
*        ls_ltap_creat-nlpla = i_nlpla.
*        ls_ltap_creat-bestq = i_bestq.
*
*        APPEND ls_ltap_creat TO lt_ltap_creat.
*      ENDLOOP.
*
*      IF e_return_tab[] IS NOT INITIAL.
*        EXIT.
*      ENDIF.
*
*      CALL FUNCTION 'L_TO_CREATE_MULTIPLE'
*        EXPORTING
*          i_lgnum                = i_lgnum
*          i_bwlvs                = '900'
*          i_bname                = i_user
*        IMPORTING
*          e_tanum                = lv_tanum
*        TABLES
*          t_ltap_creat           = lt_ltap_creat
*        EXCEPTIONS
*          no_to_created          = 1
*          bwlvs_wrong            = 2
*          betyp_wrong            = 3
*          benum_missing          = 4
*          betyp_missing          = 5
*          foreign_lock           = 6
*          vltyp_wrong            = 7
*          vlpla_wrong            = 8
*          vltyp_missing          = 9
*          nltyp_wrong            = 10
*          nlpla_wrong            = 11
*          nltyp_missing          = 12
*          rltyp_wrong            = 13
*          rlpla_wrong            = 14
*          rltyp_missing          = 15
*          squit_forbidden        = 16
*          manual_to_forbidden    = 17
*          letyp_wrong            = 18
*          vlpla_missing          = 19
*          nlpla_missing          = 20
*          sobkz_wrong            = 21
*          sobkz_missing          = 22
*          sonum_missing          = 23
*          bestq_wrong            = 24
*          lgber_wrong            = 25
*          xfeld_wrong            = 26
*          date_wrong             = 27
*          drukz_wrong            = 28
*          ldest_wrong            = 29
*          update_without_commit  = 30
*          no_authority           = 31
*          material_not_found     = 32
*          lenum_wrong            = 33
*          matnr_missing          = 34
*          werks_missing          = 35
*          anfme_missing          = 36
*          altme_missing          = 37
*          lgort_wrong_or_missing = 38
*          error_message          = 39
*          OTHERS                 = 40.
*      IF sy-subrc <> 0.
** Implement suitable error handling here
*      ENDIF.
*
*      IF lv_tanum IS INITIAL.
*
*        CALL METHOD zmob02_aux_class=>add_message_ret1
*          EXPORTING
*            langu     = i_user_lang
*            msgid     = sy-msgid
*            msgno     = sy-msgno
*            msgty     = sy-msgty
*            msgv1     = sy-msgv1
*            msgv2     = sy-msgv2
*            msgv3     = sy-msgv3
*            msgv4     = sy-msgv4
*          IMPORTING
*            et_return = e_return_tab.
*
*        EXIT.
*      ENDIF.
*      e_tanum = lv_tanum.
*
*      CLEAR ls_return.
*      APPEND ls_return TO e_return_tab.

    ENDMETHOD.
ENDCLASS.
