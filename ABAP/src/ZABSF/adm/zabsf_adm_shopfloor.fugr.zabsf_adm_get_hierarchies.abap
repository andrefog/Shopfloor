FUNCTION zabsf_adm_get_hierarchies.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"  EXPORTING
*"     VALUE(HIERARCHIES_AND_WORKCTS) TYPE  ZABSF_PP_T_WRKCTR
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA: ls_hier_str                TYPE zabsf_pp_s_wrkctr,
        lt_crhs                    TYPE TABLE OF crhs,
        lt_crhd                    TYPE TABLE OF crhd,
        ls_crhd                    TYPE crhd,
        l_langu                    TYPE sy-langu,
        ls_sf013                   TYPE zabsf_pp013,
        ls_wrkctr                  TYPE zabsf_pp_s_wrkctr,
        ls_crtx                    TYPE crtx,
        lv_objid_var               TYPE objid_up,
        lt_hierarchies_workcenters TYPE ty_t_hirarchy,
        lt_hierarchies_aux         TYPE ty_t_hirarchy,
        lt_workcenters_aux         TYPE ty_t_hirarchy.

  zabsf_pp_cl_utils=>get_user_hrchy_wrkcntr_auth(
    EXPORTING iv_oprid       = inputobj-oprid       " Shopfloor - Shopfloor Operator ID
    IMPORTING er_hierarchies = DATA(lr_hierarchies) " Range For Hierarchies
              er_workcenters = DATA(lr_workcenters) " Range for Workcenter
  ).

  IF inputobj-areaid IS NOT INITIAL.
    DATA(lr_areaid) = VALUE zabsf_range_areaid( ( sign = 'I' option = 'EQ' low = inputobj-areaid ) ).
  ENDIF.

  "obter as hierarquias
  SELECT crhh~*
    FROM crhh AS crhh
    INNER JOIN zabsf_pp002 AS zpp2
    ON zpp2~hname EQ crhh~name
    INTO TABLE @DATA(lt_hierarchies_tab)
      WHERE zpp2~werks EQ @inputobj-werks
        AND name       IN @lr_hierarchies
        AND areaid     IN @lr_areaid
        AND zpp2~werks EQ @inputobj-werks
*        AND shiftid    EQ @inputobj-shiftid
        AND begda      LE @sy-datum
        AND endda      GE @sy-datum.

* BEG INS - André Fogagnoli - 21.09.2022 - AJUSTE PERFORMANCE
  SORT lt_hierarchies_tab BY name.
  DELETE ADJACENT DUPLICATES FROM lt_hierarchies_tab COMPARING objid.
* END INS - André Fogagnoli - 21.09.2022

  "percorrer as hierarquias
  LOOP AT lt_hierarchies_tab INTO DATA(ls_hierchies_str).

    CALL FUNCTION 'CR_HIERARCHY_OBJECTS'
      EXPORTING
        objid               = ls_hierchies_str-objid
      TABLES
        t_crhs              = lt_crhs
      EXCEPTIONS
        hierarchy_not_found = 1
        OTHERS              = 2.

*BEG MOD - André Fogagnoli - 21.09.2022 - Correção Childs.
    IF lt_crhs[] IS NOT INITIAL.
      "adicionar hierarquia
      APPEND
        VALUE #(
          arbpl = ls_hierchies_str-name
          objty = 'H'
          objid = ls_hierchies_str-objid
        ) TO lt_hierarchies_workcenters.

      SELECT crhd~arbpl, crhd~objid, crhd~objty, crhs~objid_up, pp13~prdty
        FROM crhs AS crhs
        INNER JOIN crhd AS crhd
          ON crhd~objid EQ crhs~objid_ho
        LEFT OUTER JOIN zabsf_pp013 AS pp13
          ON pp13~areaid EQ @inputobj-areaid AND
             pp13~werks  EQ @inputobj-werks AND
             pp13~arbpl  EQ crhd~arbpl
        INTO TABLE @DATA(lt_workcenter_srt)
        FOR ALL ENTRIES IN @lt_crhs
        WHERE objid_ho   EQ @lt_crhs-objid_ho
          AND objid_up   EQ @lt_crhs-objid_up
          AND crhd~arbpl IN @lr_workcenters.

      LOOP AT lt_workcenter_srt ASSIGNING FIELD-SYMBOL(<ls_workcenter_srt>).
        APPEND
          VALUE #(
            arbpl  = <ls_workcenter_srt>-arbpl
            objty  = 'A'
            objid  = <ls_workcenter_srt>-objid
            parent = ls_hierchies_str-name
            prdty  = <ls_workcenter_srt>-prdty
          ) TO lt_hierarchies_workcenters.

      ENDLOOP.
    ENDIF.
  ENDLOOP.
*END MOD - André Fogagnoli - 21.09.2022 - Correção Childs.

  IF lt_hierarchies_workcenters[] IS NOT INITIAL.
    SELECT objty, objid, ktext_up
      FROM crtx
      INTO TABLE @DATA(lt_crtx)
      FOR ALL ENTRIES IN @lt_hierarchies_workcenters
      WHERE objty EQ @lt_hierarchies_workcenters-objty
        AND objid EQ @lt_hierarchies_workcenters-objid.

    LOOP AT lt_hierarchies_workcenters INTO DATA(ls_hierarchies_workcenters).
      IF ls_hierarchies_workcenters-objty = 'H'.
        APPEND
          VALUE #(
            arbpl  = ls_hierarchies_workcenters-arbpl
            objty  = ls_hierarchies_workcenters-objty
            parent = ls_hierarchies_workcenters-parent
*BEG - João Coelho - 22.09.2022 - AJUSTE KTEXT
            ktext  = VALUE #( lt_crtx[ objty = ls_hierarchies_workcenters-objty objid = ls_hierarchies_workcenters-objid ]-ktext_up OPTIONAL )
*END - João Coelho - 22.09.2022 - AJUSTE KTEXT
            prdty  = ls_hierarchies_workcenters-prdty )
          TO lt_hierarchies_aux.
      ENDIF.

      IF ls_hierarchies_workcenters-objty = 'A'.
        APPEND
          VALUE #(
            arbpl  = ls_hierarchies_workcenters-arbpl
            objty  = ls_hierarchies_workcenters-objty
            parent = ls_hierarchies_workcenters-parent
*BEG - João Coelho - 22.09.2022 - AJUSTE KTEXT
            ktext  = VALUE #( lt_crtx[ objty = ls_hierarchies_workcenters-objty objid = ls_hierarchies_workcenters-objid ]-ktext_up OPTIONAL )
*END - João Coelho - 22.09.2022 - AJUSTE KTEXT
            prdty  = ls_hierarchies_workcenters-prdty )
          TO lt_workcenters_aux.
      ENDIF.
    ENDLOOP.

* BEG - João Lopes - 17.11.2022
* Areas: OPT e MTG - sort hierarchies and work centers by "KTEXT" field
*        MEC - sort hierarchies and work centers by "ARBPL" field

    IF inputobj-areaid <> 'MEC'.
      SORT lt_hierarchies_aux BY ktext.
      SORT lt_workcenters_aux BY parent ktext.
    ELSE.
      SORT lt_hierarchies_aux BY arbpl.
      SORT lt_workcenters_aux BY parent arbpl.
    ENDIF.

    LOOP AT lt_hierarchies_aux INTO DATA(ls_hierarchies_aux).

      APPEND VALUE #( arbpl  = ls_hierarchies_aux-arbpl
                      objty  = ls_hierarchies_aux-objty
                      parent = ls_hierarchies_aux-parent
                      ktext  = ls_hierarchies_aux-ktext
                      prdty  = ls_hierarchies_aux-prdty )
          TO hierarchies_and_workcts.

      LOOP AT lt_workcenters_aux INTO DATA(ls_workcenters_aux) WHERE parent = ls_hierarchies_aux-arbpl.

        APPEND VALUE #( arbpl  = ls_workcenters_aux-arbpl
                        objty  = ls_workcenters_aux-objty
                        parent = ls_workcenters_aux-parent
                        ktext  = ls_workcenters_aux-ktext
                        prdty  = ls_workcenters_aux-prdty )
         TO hierarchies_and_workcts.
      ENDLOOP.
    ENDLOOP.
* END - João Lopes - 17.11.2022 - sort hierarchies and work centers by "KTEXT" field
  ENDIF.
*    IF sy-subrc EQ 0.
*      "adicionar hierarquia
*      APPEND VALUE #( arbpl = ls_hierchies_str-name
*                      objid = ls_hierchies_str-objid
*                      objty = 'H' ) TO lt_crhd.
*      centros de trabalho
*      loop at lt_crhs into data(ls_crhs_str).
*        "obter CT
*        select single crhd~arbpl, crhd~objid, crhd~objty, crhs~objid_up
*          from crhs as crhs
*          inner join crhd as crhd
*           on crhd~objid eq crhs~objid_ho
*          into @data(ls_workcenter_str)
*           where objid_ho eq @ls_crhs_str-objid_ho.
*        if sy-subrc eq 0.
*          move-corresponding ls_workcenter_str to ls_crhd.
*          append ls_crhd to lt_crhd.
*        endif.
*      endloop.
*    ENDIF.
*  ENDLOOP.
*
*  SORT lt_crhd BY arbpl.
*  DELETE ADJACENT DUPLICATES FROM lt_crhd COMPARING arbpl.
*
*  IF lt_crhd[] IS NOT INITIAL.
**      Get Workcenter description
*    SELECT *
*      FROM crtx
*      INTO CORRESPONDING FIELDS OF TABLE lt_crtx
*       FOR ALL ENTRIES IN lt_crhd
*     WHERE objty EQ lt_crhd-objty
*       AND objid EQ lt_crhd-objid
*       AND spras EQ sy-langu.
*
*    LOOP AT lt_crhd INTO ls_crhd.
*      CLEAR ls_wrkctr.
*
**        Workcenter
*      ls_wrkctr-arbpl = ls_crhd-arbpl.
*      "decrição centro de trabalho
*      READ TABLE lt_crtx INTO ls_crtx WITH KEY objid = ls_crhd-objid.
*      IF sy-subrc EQ 0.
*        ls_wrkctr-ktext = ls_crtx-ktext.
*      ENDIF.
*      "verificar se é CT ou hierarquia
*      SELECT SINGLE * FROM zabsf_pp013 INTO ls_sf013
*        WHERE werks = inputobj-werks
*        AND arbpl = ls_crhd-arbpl
*        AND begda LE sy-datlo
*        AND endda GE sy-datlo.
*      IF sy-subrc EQ 0.
*        ls_wrkctr-objty = 'A'.
*      ELSE.
*        ls_wrkctr-objty = 'H'.
*      ENDIF.
*
*      "obter CT parent
*      SELECT SINGLE crhd~arbpl
*        FROM crhs AS crhs
*        INNER JOIN crhd AS crhd
*         ON crhd~objid EQ crhs~objid_up
*        INTO ( @ls_wrkctr-parent )
*         WHERE objid_ho EQ @ls_crhd-objid
*           AND objty_up EQ 'A'
*           AND objid_up NE @lv_objid_var.
*      IF sy-subrc NE 0.
*        "obter hierarquia superior
*        SELECT SINGLE crhh~name
*          FROM crhs AS crhs
*          INNER JOIN crhh AS crhh
*           ON crhh~objid EQ crhs~objid_hy
*          INTO ( @ls_wrkctr-parent )
*           WHERE objid_ho EQ @ls_crhd-objid
*             AND objty_hy EQ 'H'
*             AND objid_up EQ @lv_objid_var.
*      ENDIF.
*
*      APPEND ls_wrkctr TO hierarchies_and_workcts.
*    ENDLOOP.
*  ENDIF.


ENDFUNCTION.
