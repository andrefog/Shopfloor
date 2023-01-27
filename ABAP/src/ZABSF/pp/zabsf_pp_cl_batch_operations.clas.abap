class ZABSF_PP_CL_BATCH_OPERATIONS definition
  public
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !INITIAL_REFDT type VVDATUM
      !INPUT_OBJECT type ZABSF_PP_S_INPUTOBJECT
      !INPUT_PRINT_ST type ZABSF_PP_S_ARBPL_PRINT optional .
  methods CLOSE_BATCH
    importing
      !ERFMG type MB_ERFMG optional
      !SHIFTID type ZABSF_PP_E_SHIFTID optional
    changing
      value(RETURN_TAB) type BAPIRET2_T optional .
  methods RETREIVE_BATCH
    importing
      value(BATCH) type CHARG_D
      value(LENUM) type LENUM optional
    changing
      value(RETURN_TAB) type BAPIRET2_T .
  methods GET_BATCH
    importing
      value(AUFNR) type AUFNR
      value(VORNR) type VORNR
    exporting
      value(E_BATCH) type CHARG_D
      value(E_LENUM) type LENUM .
  methods CHECK_BATCH_STOCK
    importing
      !ARBPL type ARBPL
      !AUFNR type AUFNR
      !VORNR type VORNR
      !CHARG_T type ZABSF_PP_T_BATCH_CONSUMPTION
    exporting
      !RETURN_TAB type BAPIRET2_T .
  methods CHECK_BATCH_STOCK_RPACK
    importing
      !ARBPL type ARBPL
      !AUFNR type AUFNR
      !VORNR type VORNR
      !CHARG_T type ZABSF_PP_T_BATCH_CONSUMPTION
    exporting
      !RETURN_TAB type BAPIRET2_T .
  methods CREATE_BATCH
    importing
      value(WERKS) type WERKS_D
      value(MATNR) type MATNR
      value(BATCH) type CHARG_D
    changing
      value(RETURN_TAB) type BAPIRET2_T .
protected section.
private section.

  data REFDT type VVDATUM .
  data INPUTOBJ type ZABSF_PP_S_INPUTOBJECT .
  data ARBPL_PRINT_ST type ZABSF_PP_S_ARBPL_PRINT .
ENDCLASS.



CLASS ZABSF_PP_CL_BATCH_OPERATIONS IMPLEMENTATION.


  method check_batch_stock.
    "constantes
    constants: lc_ordertype_cst type aufart value 'ZPP2'.
*  Internal table
    data: lt_return_tab type bapiret2_t.

*  Constants
    constants: c_objty type cr_objty value 'A', "Work center
               c_proc  type zabsf_pp_e_status_cons value 'P'.

*  Variables
    data: l_langu type spras.

*Variables
    data: l_aufnr        type aufnr,
          l_vornr        type vornr,
          lv_msg         type symsgno,
          lv_batch_valid type flag,
          ls_zabsf_pp076 type zabsf_pp076,
          ls_zabsf_pp069 type zabsf_pp069.


*Convert to input format
    call function 'CONVERSION_EXIT_ALPHA_INPUT'
      exporting
        input  = aufnr
      importing
        output = l_aufnr.

    "obter tipo de ordem
    select single auart
      from aufk
      into @data(lv_ordertpy_var)
        where aufnr eq @l_aufnr.

*Convert to INPUT FORMAT
    call function 'CONVERSION_EXIT_ALPHA_INPUT'
      exporting
        input  = vornr
      importing
        output = l_vornr.

*  Set local language for user
    l_langu = inputobj-language.
    set locale language l_langu.


*  Save batch consumption
    loop at charg_t into data(ls_batch).

*    Add leading zeros to batch number
      call function 'CONVERSION_EXIT_ALPHA_INPUT'
        exporting
          input  = ls_batch-charg
        importing
          output = ls_batch-charg.

*    Check the batch has already saved in Changes Batch Consumption
      select single batch
        from zabsf_pp076
        into @data(l_charg)
       where werks = @ls_batch-werks and
             batch = @ls_batch-charg and
             status_cons = @c_proc. "staus P
      if ( sy-subrc = 0 ).
        refresh lt_return_tab.

*        Remove left zeros in batch
        call function 'CONVERSION_EXIT_ALPHA_OUTPUT'
          exporting
            input  = ls_batch-charg
          importing
            output = ls_batch-charg.

*        No stock avaliable for batch &.
        call method zabsf_pp_cl_log=>add_message
          exporting
            msgty      = 'E'
            msgno      = '90'
            msgv1      = ls_batch-charg
          changing
            return_tab = lt_return_tab.

        append lines of lt_return_tab to return_tab.
        exit.
      endif.


*    Check the batch is restricted use stock
      select single zustd
        from mch1
        into @data(l_zustd)
       where matnr eq @ls_batch-matnr and
             charg eq @ls_batch-charg.
      if ( sy-subrc = 0 and not l_zustd is initial ).
        refresh lt_return_tab.

*        Remove left zeros in batch
        call function 'CONVERSION_EXIT_ALPHA_OUTPUT'
          exporting
            input  = ls_batch-charg
          importing
            output = ls_batch-charg.

*        No stock avaliable for batch &.
        call method zabsf_pp_cl_log=>add_message
          exporting
            msgty      = 'E'
            msgno      = '98'
            msgv1      = ls_batch-charg
          changing
            return_tab = lt_return_tab.

        append lines of lt_return_tab to return_tab.
        exit.
      endif.


*    Check the batch has the same material
      select single *
        from mcha
        into @data(ls_mcha)
       where matnr eq @ls_batch-matnr
         and werks eq @ls_batch-werks
         and charg eq @ls_batch-charg.

      if sy-subrc eq 0.
        if ls_batch-maktx is not initial and lv_ordertpy_var eq lc_ordertype_cst.
          "obter nome que está  no lote
          call method zcl_mm_classification=>get_material_desc_by_batch
            exporting
              im_material_var    = ls_batch-matnr
              im_batch_var       = ls_batch-charg
            importing
              ex_description_var = data(lv_batchname_var).
          "verificar se o nome é igual
          if lv_batchname_var ne ls_batch-maktx.
            call method zabsf_pp_cl_log=>add_message
              exporting
                msgty      = 'E'
                msgno      = '89'
                msgv1      = ls_batch-charg
                msgv2      = ls_batch-maktx
              changing
                return_tab = lt_return_tab.

            append lines of lt_return_tab to return_tab.
            exit.
          endif.
        endif.

        "Limpar variáveis
        clear lv_batch_valid.

        "Check if batch is set for valid use in table ZLP_PP_SF078
        call method zabsf_pp_cl_prdord=>check_batch_open_for_use
          exporting
            werks = ls_batch-werks
            charg = ls_batch-charg
          changing
            valid = lv_batch_valid.

        if lv_ordertpy_var eq lc_ordertype_cst.
          select single *
            from zabsf_pp069
            into @data(ls_pp_sf069)
           where werks eq @ls_batch-werks
             and aufnr eq @aufnr
             and vornr eq @vornr
             and matnr eq @ls_batch-matnr
             and maktx eq @ls_batch-maktx.
        else.
          select single *
            from zabsf_pp069
            into @ls_pp_sf069
           where werks eq @ls_batch-werks
             and aufnr eq @aufnr
             and vornr eq @vornr
             and matnr eq @ls_batch-matnr.
        endif.

* Begin: SMP ticket 9000010888 - Check Status após alteração no centro de trabalho
        if ls_pp_sf069 is not initial and ls_pp_sf069-batch ne ls_batch-charg.
* IF ls_pp_sf069-batch NE ls_batch-charg.
          if ( not ls_pp_sf069-batch is initial ).
* End: SMP ticket 9000010888
*         Get Shift of Operator
            select single shiftid
            from zabsf_pp052
            into @data(l_shiftid)
            where areaid = @inputobj-areaid and
                  oprid  = @inputobj-oprid.
            if ( sy-subrc = 0 ).

**         Get Material Description
              select single maktx
              from makt
              into @data(l_maktx)
              where matnr = @ls_batch-matnr and
                    spras = @l_langu.

**         Get Card
              select single ficha
              from zabsf_pp066
              into @data(l_ficha)
              where werks = @inputobj-werks and
                    aufnr = @aufnr and
                    vornr = @vornr. "AND
*                      batch = @ls_batch-charg.
              if ( sy-subrc = 0 ).

*             Get Stock for old batch
*        Get stock of batch
                select single clabs
                  from afko as afko
                 inner join aufk as aufk
                    on aufk~aufnr eq afko~aufnr
                 inner join afpo as afpo
                    on afpo~aufnr eq afko~aufnr
                 inner join mchb as mchb
                    on mchb~matnr eq @ls_batch-matnr
                   and mchb~lgort eq afpo~lgort
                   and mchb~werks eq aufk~werks
                 where aufk~werks eq @inputobj-werks
                   and afko~aufnr eq @aufnr
                   and mchb~charg eq @ls_pp_sf069-batch
                  into (@data(l_clabs)).

                if ( l_clabs > 0 ).

                  call method zabsf_pp_cl_log=>add_message
                    exporting
                      msgty      = 'W'
                      msgno      = '99'
                      msgv1      = ls_pp_sf069-batch
                    changing
                      return_tab = lt_return_tab.

                  append lines of lt_return_tab to return_tab.


*          Insert register of change batch consumption
*                  insert into zabsf_pp076
*                  values @( value #( werks = inputobj-werks
*                                     data = sy-datlo
*                                     shiftid = l_shiftid
*                                     aufnr = aufnr
*                                     ficha = l_ficha
*                                     matnr = ls_batch-matnr
*                                     maktx = l_maktx
*                                     batch = ls_pp_sf069-batch
*                                     verme = l_clabs
*                                     status_cons = c_proc
*                                     ernam = inputobj-oprid
*                                     erdat = sy-datlo ) ).
                  ls_zabsf_pp076-werks = inputobj-werks.
                  ls_zabsf_pp076-data = sy-datlo.
                  ls_zabsf_pp076-shiftid = l_shiftid.
                  ls_zabsf_pp076-aufnr = aufnr.
                  ls_zabsf_pp076-ficha = l_ficha.
                  ls_zabsf_pp076-matnr = ls_batch-matnr.
                  ls_zabsf_pp076-maktx = l_maktx.
                  ls_zabsf_pp076-batch = ls_pp_sf069-batch.
                  ls_zabsf_pp076-verme = l_clabs.
                  ls_zabsf_pp076-status_cons = c_proc.
                  ls_zabsf_pp076-ernam = inputobj-oprid.
                  ls_zabsf_pp076-erdat = sy-datlo.

                  insert into zabsf_pp076 values ls_zabsf_pp076.

                  if ( sy-subrc = 0 ).
                    commit work and wait.
                  endif.
                endif.
              endif.
            endif.
          endif.
*          Update with new batch consumption
*          update zabsf_pp069 from @( value #( base ls_pp_sf069 batch = ls_batch-charg
*                                                               maktx = ls_batch-maktx ) ).
          ls_pp_sf069-batch = ls_batch-charg.
          ls_pp_sf069-maktx = ls_batch-maktx.
          update zabsf_pp069 from ls_pp_sf069.

          if sy-subrc eq 0.
            refresh lt_return_tab.

            commit work and wait.

*            Operation completed sucessfully
            call method zabsf_pp_cl_log=>add_message
              exporting
                msgty      = 'S'
                msgno      = '013'
              changing
                return_tab = lt_return_tab.

            append lines of lt_return_tab to return_tab.
          endif.
        else.
          if ls_pp_sf069 is initial.
*            Add batch consumption for use in process
*            insert zabsf_pp069 from table @( value #( ( werks = ls_batch-werks
*                                                        aufnr = aufnr
*                                                        vornr = vornr
*                                                        matnr = ls_batch-matnr
*                                                        batch = ls_batch-charg
*                                                        maktx = ls_batch-maktx ) ) ).
            ls_zabsf_pp069-werks = ls_batch-werks.
            ls_zabsf_pp069-aufnr = aufnr.
            ls_zabsf_pp069-vornr = vornr.
            ls_zabsf_pp069-matnr = ls_batch-matnr.
            ls_zabsf_pp069-batch = ls_batch-charg.
            ls_zabsf_pp069-maktx = ls_batch-maktx.
            insert zabsf_pp069 from ls_zabsf_pp069.
            if sy-subrc eq 0.
              refresh lt_return_tab.

              commit work and wait.

*              Operation completed sucessfully
              call method zabsf_pp_cl_log=>add_message
                exporting
                  msgty      = 'S'
                  msgno      = '013'
                changing
                  return_tab = lt_return_tab.

              append lines of lt_return_tab to return_tab.
            endif.
          endif.
        endif.
      else.
        refresh lt_return_tab.

*      Remove left zeros in Material
        call function 'CONVERSION_EXIT_ALPHA_OUTPUT'
          exporting
            input  = ls_batch-matnr
          importing
            output = ls_batch-matnr.

*      Remove left zeros in batch
        call function 'CONVERSION_EXIT_ALPHA_OUTPUT'
          exporting
            input  = ls_batch-charg
          importing
            output = ls_batch-charg.

*      There is no data to the lot (&) and material (&) Indicated.
        call method zabsf_pp_cl_log=>add_message
          exporting
            msgty      = 'E'
            msgno      = '89'
            msgv1      = ls_batch-charg
            msgv2      = cond #( when ls_batch-maktx is not initial
                                 then ls_batch-maktx
                                 else ls_batch-matnr )
          changing
            return_tab = lt_return_tab.

        append lines of lt_return_tab to return_tab.
      endif.
    endloop.
  endmethod.


  method check_batch_stock_rpack.
*  Internal table
    data: lt_return_tab type bapiret2_t.

*  Constants
    constants: c_objty type cr_objty value 'A', "Work center
               c_proc  type zabsf_pp_e_status_cons value 'P'.

*  Variables
    data: l_langu type spras.

*Variables
    data: l_aufnr type aufnr,
          l_vornr type vornr,
          lv_msg  type symsgno,
          ls_zabsf_pp077 type zabsf_pp077.

*Convert to input format
    call function 'CONVERSION_EXIT_ALPHA_INPUT'
      exporting
        input  = aufnr
      importing
        output = l_aufnr.

*Convert to INPUT FORMAT
    call function 'CONVERSION_EXIT_ALPHA_INPUT'
      exporting
        input  = vornr
      importing
        output = l_vornr.

*  Set local language for user
    l_langu = inputobj-language.
    set locale language l_langu.


*  Save batch consumption
    loop at charg_t into data(ls_batch).

*    Add leading zeros to batch number
      call function 'CONVERSION_EXIT_ALPHA_INPUT'
        exporting
          input  = ls_batch-charg
        importing
          output = ls_batch-charg.


      select single matnr
        from mcha
        into @data(l_matnr)
        where werks = @ls_batch-werks and
              charg = @ls_batch-charg.
      if ( sy-subrc = 0 and not l_matnr is initial ).
        ls_batch-matnr = l_matnr.
      endif.

*  Get reserv number
      select single rsnum
        from afko
        into (@data(l_rsnum))
       where aufnr eq @l_aufnr.

*  Get Reservation/dependent requirements
      select *
        from resb
        into table @data(lt_resb)
       where rsnum eq @l_rsnum
         and aufnr eq @l_aufnr
         and vornr eq @l_vornr
         and werks eq @inputobj-werks
         and xloek eq @space
         and rgekz ne @space.
      if ( lt_resb[] is initial ).

*        Remove left zeros in batch
        call function 'CONVERSION_EXIT_ALPHA_OUTPUT'
          exporting
            input  = ls_batch-matnr
          importing
            output = ls_batch-matnr.

*        No stock avaliable for batch &.
        call method zabsf_pp_cl_log=>add_message
          exporting
            msgty      = 'E'
            msgno      = '101'
          changing
            return_tab = lt_return_tab.

        append lines of lt_return_tab to return_tab.
        exit.
      endif.

**    Verify if material is in reservation
      read table lt_resb into data(ls_resb)
            with key matnr = ls_batch-matnr.
      if ( sy-subrc <> 0 ).

*        Remove left zeros in batch
        call function 'CONVERSION_EXIT_ALPHA_OUTPUT'
          exporting
            input  = ls_batch-matnr
          importing
            output = ls_batch-matnr.

*        No stock avaliable for batch &.
        call method zabsf_pp_cl_log=>add_message
          exporting
            msgty      = 'E'
            msgno      = '100'
            msgv1      = ls_batch-matnr
          changing
            return_tab = lt_return_tab.

        append lines of lt_return_tab to return_tab.
        exit.
      endif.


*    Check the batch is restricted use stock
      select single zustd
        from mch1
        into @data(l_zustd)
       where matnr eq @ls_batch-matnr and
             charg eq @ls_batch-charg.
      if ( sy-subrc = 0 and not l_zustd is initial ).
        refresh lt_return_tab.

*        Remove left zeros in batch
        call function 'CONVERSION_EXIT_ALPHA_OUTPUT'
          exporting
            input  = ls_batch-charg
          importing
            output = ls_batch-charg.

*        No stock avaliable for batch &.
        call method zabsf_pp_cl_log=>add_message
          exporting
            msgty      = 'E'
            msgno      = '98'
            msgv1      = ls_batch-charg
          changing
            return_tab = lt_return_tab.

        append lines of lt_return_tab to return_tab.
        exit.
      endif.


*    Check the batch has the same material
      select single *
        from mcha
        into @data(ls_mcha)
       where matnr eq @ls_batch-matnr
         and werks eq @ls_batch-werks
         and charg eq @ls_batch-charg.

      if ( sy-subrc eq 0 ).
*      Check stock for batch in storage bin
        select single *
          from lqua
          into @data(ls_lqua)
         where matnr eq @ls_batch-matnr
           and werks eq @ls_batch-werks
           and charg eq @ls_batch-charg
           and verme gt 0
           and bestq not in ('Q','R','S') "Q - Stock in Quality Control, R - Returns Stock, S - Blocked Stock
*     AND lqua~einme EQ 0
*     AND lqua~ausme EQ 0
           and exists ( select crhd~objid
                          from crhd as crhd
                         inner join pkhd as pkhd
                            on crhd~werks eq pkhd~werks
                           and crhd~prvbe eq pkhd~prvbe
                         where pkhd~lgnum eq lqua~lgnum
                           and pkhd~lgtyp eq lqua~lgtyp
                           and pkhd~lgpla eq lqua~lgpla
                           and pkhd~matnr eq lqua~matnr
                           and pkhd~werks eq lqua~werks
                           and crhd~arbpl eq @arbpl ).

        if ( sy-subrc eq 0 ).
*        Check if exist batch consumption saved
          select single *
            from zabsf_pp077
            into @data(ls_pp_sf077)
           where werks eq @ls_batch-werks
             and aufnr eq @aufnr
             and vornr eq @vornr
             and matnr eq @ls_batch-matnr.

          if ( ls_pp_sf077 is not initial and
               ls_pp_sf077-batch eq ls_batch-charg ).

            refresh lt_return_tab.

*            Operation completed sucessfully
            call method zabsf_pp_cl_log=>add_message
              exporting
                msgty      = 'S'
                msgno      = '013'
              changing
                return_tab = lt_return_tab.

            append lines of lt_return_tab to return_tab.

          else.

            select single max( indice )
            from zabsf_pp077
            into @data(l_indice)
           where werks eq @ls_batch-werks
             and aufnr eq @aufnr
             and vornr eq @vornr.
            l_indice = l_indice + 1.

*            Add batch consumption for use in process
*            INSERT zabsf_pp077 FROM TABLE @( VALUE #( ( werks = ls_batch-werks
*                                                         aufnr = aufnr
*                                                         vornr = vornr
*                                                         matnr = ls_batch-matnr
*                                                         batch = ls_batch-charg
*                                                         indice = l_indice
*                                                         rsnum = ls_resb-rsnum
*                                                         rspos = ls_resb-rspos ) ) ).
            ls_zabsf_pp077-werks = ls_batch-werks.
            ls_zabsf_pp077-aufnr = aufnr.
            ls_zabsf_pp077-vornr = vornr.
            ls_zabsf_pp077-matnr = ls_batch-matnr.
            ls_zabsf_pp077-batch = ls_batch-charg.
            ls_zabsf_pp077-indice = l_indice.
            ls_zabsf_pp077-rsnum = ls_resb-rsnum.
            ls_zabsf_pp077-rspos = ls_resb-rspos .

            insert zabsf_pp077 from ls_zabsf_pp077.
            if ( sy-subrc eq 0 ).
              refresh lt_return_tab.

              commit work and wait.

*              Operation completed sucessfully
              call method zabsf_pp_cl_log=>add_message
                exporting
                  msgty      = 'S'
                  msgno      = '013'
                changing
                  return_tab = lt_return_tab.

              append lines of lt_return_tab to return_tab.
            endif.
          endif.

        else.
          refresh lt_return_tab.

*      Check stock for batch in storage bin
          clear lv_msg.
          select single bestq
            from lqua
            into @data(lv_bestq)
           where matnr eq @ls_batch-matnr
             and werks eq @ls_batch-werks
             and charg eq @ls_batch-charg
             and verme gt 0
             and exists ( select crhd~objid
                            from crhd as crhd
                           inner join pkhd as pkhd
                              on crhd~werks eq pkhd~werks
                             and crhd~prvbe eq pkhd~prvbe
                           where pkhd~lgnum eq lqua~lgnum
                             and pkhd~lgtyp eq lqua~lgtyp
                             and pkhd~lgpla eq lqua~lgpla
                             and pkhd~matnr eq lqua~matnr
                             and pkhd~werks eq lqua~werks
                             and crhd~arbpl eq @arbpl ).
          "  Q - Stock in Quality Control, R - Returns Stock, S - Blocked Stock
          if ( lv_bestq = 'Q' ).
            lv_msg = '103'.
          elseif ( lv_bestq = 'R' ).
            lv_msg = '104'.
          elseif ( lv_bestq = 'S' ).
            lv_msg = '105'.
          else.
            lv_msg = '90'.
          endif.

*        Remove left zeros in batch
          call function 'CONVERSION_EXIT_ALPHA_OUTPUT'
            exporting
              input  = ls_batch-charg
            importing
              output = ls_batch-charg.

*        No stock avaliable for batch &.
          call method zabsf_pp_cl_log=>add_message
            exporting
              msgty      = 'E'
              msgno      = lv_msg
              msgv1      = ls_batch-charg
            changing
              return_tab = lt_return_tab.

          append lines of lt_return_tab to return_tab.
        endif.
      else.
        refresh lt_return_tab.

*      Remove left zeros in Material
        call function 'CONVERSION_EXIT_ALPHA_OUTPUT'
          exporting
            input  = ls_batch-matnr
          importing
            output = ls_batch-matnr.

*      Remove left zeros in batch
        call function 'CONVERSION_EXIT_ALPHA_OUTPUT'
          exporting
            input  = ls_batch-charg
          importing
            output = ls_batch-charg.

*      There is no data to the lot (&) and material (&) Indicated.
        call method zabsf_pp_cl_log=>add_message
          exporting
            msgty      = 'E'
            msgno      = '89'
            msgv1      = ls_batch-charg
            msgv2      = ls_batch-matnr
          changing
            return_tab = lt_return_tab.

        append lines of lt_return_tab to return_tab.
      endif.
    endloop.

  endmethod.


  method close_batch.
*  Variables
    data: l_source_value type i,
          l_lmnga        type lmnga,
          l_boxqty       type zabsf_pp_e_boxqty.

*  References
    data: lref_print     type ref to zabsf_pp_cl_print,
          lref_sf_prdord type ref to zabsf_pp_cl_prdord.

* Changed by MBA - testes 30.03.2017
    wait up to 2 seconds.
* End of change

*  Get batch active
    select single *
      from zabsf_pp066
      into @data(ls_sf_066)
     where werks eq @inputobj-werks
       and aufnr eq @arbpl_print_st-aufnr
       and vornr eq @arbpl_print_st-vornr.

    if sy-subrc eq 0.
*    Update table
      data(l_old_batch) = ls_sf_066-batch.

*      ls_sf_066-batch = ''.
*      UPDATE zlp_pp_sf066 FROM ls_sf_066.
*    Clear card active
*      UPDATE zabsf_pp066 FROM @( VALUE #( BASE ls_sf_066 batch = space lenum = space ) ).

      ls_sf_066-batch = space.
      ls_sf_066-lenum = space.
      update zabsf_pp066 from ls_sf_066.
      if sy-subrc ne 0.
*       Error during dbase operation
        call method zabsf_pp_cl_log=>add_message
          exporting
            msgty      = 'E'
            msgno      = '068'
          changing
            return_tab = return_tab.

      else.
        commit work and wait.

*      Get detail of Production Order
        select single afko~gamng, afko~gmein, afko~aufpl, afvc~aplzl,
                      afko~plnbez, afko~stlbez
          from afko as afko
         inner join afvc as afvc
            on afvc~aufpl eq afko~aufpl
         where afko~aufnr eq @arbpl_print_st-aufnr
           and afvc~vornr eq @arbpl_print_st-vornr
           and afvc~werks eq @inputobj-werks
          into (@data(l_gamng), @data(l_gmein), @data(l_aufpl),
                @data(l_aplzl), @data(l_plnbez), @data(l_stlbez)).


*      Quantity of Box
        l_source_value = l_gamng.

        if l_plnbez is not initial.
          data(l_matnr) = l_plnbez.
        else.
          l_matnr = l_stlbez.
        endif.

        if lref_sf_prdord is not bound.
*        Create object
          create object lref_sf_prdord
            exporting
              initial_refdt = refdt
              input_object  = inputobj.
        endif.

*      Get box quantity
        call method lref_sf_prdord->get_qty_box
          exporting
            matnr        = l_matnr
            source_value = l_source_value
            lmnga        = l_lmnga
            gmein        = l_gmein
            aufpl        = l_aufpl
            aplzl        = l_aplzl
          changing
            boxqty       = l_boxqty.

*      Get box quantity for Production Order
        select single *
          from zabsf_pp017
          into @data(ls_zlp_pp_sf017)
         where aufnr eq @arbpl_print_st-aufnr
           and vornr eq @arbpl_print_st-vornr.

        if sy-subrc eq 0.
*        Update box quantity
*          UPDATE zabsf_pp017 FROM @( VALUE #( BASE ls_zlp_pp_sf017 boxqty = l_boxqty prdqty_box = space ) ).
          ls_zlp_pp_sf017-boxqty = l_boxqty.
          ls_zlp_pp_sf017-prdqty_box = space.
          update zabsf_pp017 from ls_zlp_pp_sf017.
          commit work and wait.
        endif.

*      Get class of interface
        select single imp_clname, methodname
            from zabsf_pp003
            into (@data(l_class), @data(l_method))
           where werks    eq @inputobj-werks
             and id_class eq '5'
             and endda    ge @refdt
             and begda    le @refdt.

*      Create object
        create object lref_print type (l_class)
          exporting
            initial_refdt = refdt
            input_object  = inputobj.

*{   REPLACE        S4DK901990                                        1
*\*      Print label.
*\        CALL METHOD lref_print->(l_method)
*\          EXPORTING
*\            arbpl_print_st = arbpl_print_st
*\            batch          = l_old_batch
*\            erfmg          = erfmg
*\            shiftid        = shiftid
*\          CHANGING
*\            return_tab     = return_tab.

*NSF - Início - Inclusão de parâmetro para definir impressão em PP
        select single  status
            from zabsf_pp079
            into (@data(l_status))
           where werks  eq @inputobj-werks
             and areaid eq @inputobj-areaid
             and parid  eq 'PRINT_LABEL_PP'
             and status eq 'X'.

        if sy-subrc = 0.

*      Print label.
          call method lref_print->(l_method)
            exporting
              arbpl_print_st = arbpl_print_st
              batch          = l_old_batch
              erfmg          = erfmg
              shiftid        = shiftid
            changing
              return_tab     = return_tab.
        endif.
*NSF - Fim - Inclusão de parâmetro para definir impressão em PP
*}   REPLACE

      endif.

    else.
*    Entry not found, send error message
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = 'E'
          msgno      = '069'
        changing
          return_tab = return_tab.

    endif.
  endmethod.


  METHOD CONSTRUCTOR.
*ref. date
    refdt    = initial_refdt.

*App input data
    inputobj = input_object.
    arbpl_print_st = input_print_st.
  ENDMETHOD.


METHOD create_batch.

  DATA: lv_matnr     TYPE matnr18,
        lv_new_batch TYPE charg_d,
        lt_return    TYPE TABLE OF bapiret2,
        ls_batch_att TYPE bapibatchatt.

  DATA: lf_no_good   TYPE flag,
        lv_year      TYPE p,
        lv_date      TYPE p,
        lv_trash(72).
  DATA lv_meses TYPE int4.
  DATA lv_diasmeses TYPE decfloat34.
  DATA lv_diasmeses_tx TYPE string.

  CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
    EXPORTING
      input  = matnr
    IMPORTING
      output = lv_matnr.

*Check if batch number is valid
  DATA(length) =  strlen( batch ).
  IF length NE 5.
    lf_no_good = abap_true.
  ENDIF.

  TRANSLATE batch(1) TO UPPER CASE.
  DATA(first_letter) = batch(1).
  IF first_letter NE 'L'.
    lf_no_good = abap_true.
  ENDIF.

  DATA(year) = batch+1(1).

  CALL FUNCTION 'MOVE_CHAR_TO_NUM'
    EXPORTING
      chr             = year
    IMPORTING
      num             = lv_year
    EXCEPTIONS
      convt_no_number = 1
      convt_overflow  = 2
      OTHERS          = 3.

  IF sy-subrc <> 0.
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '120'
      CHANGING
        return_tab = return_tab.
    EXIT.
  ENDIF.

  IF lv_year LT 0 OR lv_year GT 9.
    lf_no_good = abap_true.
  ENDIF.

  DATA(date) = batch+2(3).

  CALL FUNCTION 'MOVE_CHAR_TO_NUM'
    EXPORTING
      chr             = date
    IMPORTING
      num             = lv_date
    EXCEPTIONS
      convt_no_number = 1
      convt_overflow  = 2
      OTHERS          = 3.

  IF sy-subrc <> 0.
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '120'
      CHANGING
        return_tab = return_tab.
    EXIT.
  ENDIF.

  IF lv_date LT 001 OR lv_date GT 366.
    lf_no_good = abap_true.
  ENDIF.

  IF lf_no_good EQ abap_true.
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '120'
      CHANGING
        return_tab = return_tab.
    EXIT.
  ENDIF.

*preencher data de produçao
  ls_batch_att-prod_date = sy-datum.

* A pedido da VLM nao pode ser alterada a data
**MJP:INI:ABACO_ABAP: 04.06.2019 17:17:08
***  SELECT SINGLE * FROM mara INTO @DATA(ls_mara)
***    WHERE matnr = @lv_matnr.
***  IF sy-subrc IS INITIAL.
***    SELECT SINGLE * FROM marc INTO @DATA(ls_marc)
***      WHERE matnr = @lv_matnr
***        AND werks = @werks.
***
***    IF sy-subrc IS INITIAL.
***      IF ls_marc-maxlz IS INITIAL AND ( ls_mara-mtart = 'FERT' OR ls_mara-mtart = 'HALB' ).
***        lf_no_good = abap_true.
***        CALL METHOD zabsf_pp_cl_log=>add_message
***          EXPORTING
***            msgty      = 'E'
***            msgno      = '129'
***          CHANGING
***            return_tab = return_tab.
***        EXIT.
***      ELSE.
***        MOVE ls_marc-maxlz TO lv_meses.
***
***        CALL FUNCTION 'HR_JP_ADD_MONTH_TO_DATE'
***          EXPORTING
***            iv_monthcount = lv_meses
***            iv_date       = sy-datum
***          IMPORTING
***            ev_date       = ls_batch_att-expirydate.
***      ENDIF.
***    ENDIF.
***  ENDIF.
**MJP:FIM:ABACO_ABAP: 04.06.2019 17:17:12


**MJP:INI:ABACO_ABAP: 05.06.2019 09:21:03
  SELECT SINGLE * FROM mara INTO @DATA(ls_mara)
    WHERE matnr = @lv_matnr.

  IF sy-subrc IS INITIAL.

    CLEAR: lv_diasmeses, lv_diasmeses_tx, lv_meses, return_tab.

    IF ls_mara-mhdhb IS INITIAL AND ( ls_mara-mtart = 'FERT' OR ls_mara-mtart = 'HALB' OR ls_mara-mtart = 'HAWA' ).
      lf_no_good = abap_true.
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '129'
        CHANGING
          return_tab = return_tab.
      EXIT.

    ELSE.

      IF ls_mara-iprkz IS INITIAL. "D

        lv_diasmeses = ls_mara-mhdhb / 30.
        lv_diasmeses_tx = lv_diasmeses.
        SPLIT lv_diasmeses_tx AT '.' INTO lv_diasmeses_tx lv_trash.
        lv_meses = lv_diasmeses_tx.

        SELECT SINGLE parva FROM zabsf_pp032 INTO @DATA(lv_vlpla)
                    WHERE werks = @werks
                      AND parid = 'TMP_VALID_MIN'.

        IF lv_meses LT lv_vlpla.
          lf_no_good = abap_true.
          CALL METHOD zabsf_pp_cl_log=>add_message
            EXPORTING
              msgty      = 'E'
              msgno      = '129'
            CHANGING
              return_tab = return_tab.
          EXIT.
        ENDIF.
      ELSE. "M / 2
        lv_meses = ls_mara-mhdhb.
      ENDIF.

      CALL FUNCTION 'HR_JP_ADD_MONTH_TO_DATE'
        EXPORTING
          iv_monthcount = lv_meses
          iv_date       = sy-datum
        IMPORTING
          ev_date       = ls_batch_att-expirydate.
    ENDIF.
  ENDIF.
**MJP:FIM:ABACO_ABAP: 05.06.2019 09:21:05


*  ls_batch_att-expirydate
*  ls_batch_att-PROD_DATE =
  ls_batch_att-vendrbatch = batch.

  CALL FUNCTION 'BAPI_BATCH_CREATE'
    EXPORTING
      material        = lv_matnr
      batch           = batch
      plant           = werks
      batchattributes = ls_batch_att
    IMPORTING
      batch           = lv_new_batch
    TABLES
      return          = lt_return.

  LOOP AT lt_return INTO DATA(ls_return)
    WHERE type CA 'AEX'.

    APPEND ls_return TO return_tab.
  ENDLOOP.

  IF return_tab IS INITIAL.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.

  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
  ENDIF.


ENDMETHOD.


  METHOD get_batch.
    data: l_batch type charg_d.

*  Get batch from z table
    SELECT SINGLE batch lenum
      FROM zabsf_pp066
      INTO (l_batch, e_lenum)
     WHERE werks EQ inputobj-werks
       AND aufnr EQ aufnr
       AND vornr EQ vornr.

*  Convert to format output
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = l_batch
      IMPORTING
        output = e_batch.
  ENDMETHOD.


  method retreive_batch.
*  Variables
    data: l_batch type charg_d,
          l_lenum type lenum,
          l_subrc type sy-subrc,
          ls_zabsf_pp066 type zabsf_pp066.
    data: flag_pal_erro.

*  Constants
    constants: c_control_key type zabsf_pp_e_control_key value 'S',
               c_bestq       type bestq                value 'Q'.


*Tratar número de lote antigo para HAWA "produzido".

    select single mtart
      from mara
      into @data(lv_mtart)
      where matnr = @arbpl_print_st-matnr.

    if lv_mtart = 'HAWA'.

      shift batch left deleting leading '0'.
      l_batch = batch.

    else.

*  Add left zeros
      call function 'CONVERSION_EXIT_ALPHA_INPUT'
        exporting
          input  = batch
        importing
          output = l_batch.

    endif.
*    l_subrc = 4.
*    WHILE l_subrc NE 0.
**  Validate batch number
*      SELECT  SINGLE *
*         FROM mcha
*         INTO @DATA(ls_mcha)
*        WHERE werks EQ @inputobj-werks
*          AND matnr EQ @arbpl_print_st-matnr
*          AND charg EQ @l_batch.
*      MOVE sy-subrc TO l_subrc.
*      IF sy-subrc NE 0.
*        WAIT UP TO '0.1' SECONDS.
*      ENDIF.
*    ENDWHILE.

    do 20 times.
*  Validate batch number
      select  single *
         from mcha
         into @data(ls_mcha)
        where werks eq @inputobj-werks
          and matnr eq @arbpl_print_st-matnr
          and charg eq @l_batch.
      if sy-subrc ne 0.
        wait up to '0.1' seconds.
      else.
        exit.
      endif.
    enddo.

    if ls_mcha is not initial.
*    Get information to check Stock Category
      select single *
        from zabsf_pp075
        into @data(ls_sf075)
       where werks eq @inputobj-werks
         and control_key eq @c_control_key.

*    Get Storage location
      select single lgort
        from afpo
        into (@data(l_lgort))
       where aufnr eq @arbpl_print_st-aufnr.

*    Check if batch was in stock quality
*      SELECT SINGLE *
*        FROM lqua
*        INTO @DATA(ls_lqua)
*       WHERE lgnum EQ @ls_sf075-lgnum
*         AND matnr EQ @arbpl_print_st-matnr
*         AND werks EQ @inputobj-werks
*         AND charg EQ @l_batch
*         AND bestq EQ @c_bestq
*         AND lgtyp EQ @ls_sf075-lgtyp
*         AND lgpla EQ @ls_sf075-lgpla
*         AND lgort EQ @l_lgort.

*      IF sy-subrc EQ 0.
*      Check if exist batch active
      select single *
        from zabsf_pp066
        into @data(ls_pp_sf066)
       where werks eq @inputobj-werks
         and aufnr eq @arbpl_print_st-aufnr
         and vornr eq @arbpl_print_st-vornr.

      if sy-subrc eq 0.
*        Update with new batch active
*        UPDATE zabsf_pp066 FROM @( VALUE #( BASE ls_pp_sf066 batch = batch lenum = lenum ) ).
        ls_pp_sf066-batch = batch.
        ls_pp_sf066-lenum = lenum.
        update zabsf_pp066 from ls_pp_sf066.
        commit work and wait.

*        Get stock of batch
        select single cinsm, clabs
          from afko as afko
         inner join aufk as aufk
            on aufk~aufnr eq afko~aufnr
         inner join afpo as afpo
            on afpo~aufnr eq afko~aufnr
         inner join mchb as mchb
            on mchb~matnr eq afko~plnbez
           and mchb~lgort eq afpo~lgort
           and mchb~werks eq aufk~werks
         where aufk~werks eq @inputobj-werks
           and afko~aufnr eq @arbpl_print_st-aufnr
           and mchb~charg eq @l_batch
          into (@data(l_cinsm),@data(l_clabs)).

*        Get produced quantity
        select single *
          from zabsf_pp017
          into @data(ls_zlp_pp_sf017)
         where aufnr eq @arbpl_print_st-aufnr
           and vornr eq @arbpl_print_st-vornr.

        if sy-subrc eq 0.
*          Update produced quantity
*          UPDATE zabsf_pp017 FROM @( VALUE #( BASE ls_zlp_pp_sf017 prdqty_box = l_cinsm + l_clabs ) ).
          ls_zlp_pp_sf017-prdqty_box = l_cinsm + l_clabs.
          update zabsf_pp017 from ls_zlp_pp_sf017.
          commit work and wait.
        endif.
      else.
*        Insert new record with batch active for production order
*        insert zabsf_pp066 from table @( value #( ( werks = inputobj-werks
*                                                     aufnr = arbpl_print_st-aufnr
*                                                     vornr = arbpl_print_st-vornr
*                                                     batch = l_batch
*                                                     lenum = l_lenum ) ) ).
        ls_zabsf_pp066-werks = inputobj-werks.
        ls_zabsf_pp066-aufnr = arbpl_print_st-aufnr.
        ls_zabsf_pp066-vornr = arbpl_print_st-vornr.
        ls_zabsf_pp066-batch = l_batch.
        ls_zabsf_pp066-lenum = l_lenum.
        insert into zabsf_pp066 values ls_zabsf_pp066.
        commit work and wait.
      endif.

      if sy-subrc ne 0.
        call method zabsf_pp_cl_log=>add_message
          exporting
            msgty      = 'E'
            msgno      = '071'
          changing
            return_tab = return_tab.
        flag_pal_erro = 'X'.
      else.
        call method zabsf_pp_cl_log=>add_message
          exporting
            msgty      = 'S'
            msgno      = '013'
          changing
            return_tab = return_tab.
      endif.
*      ELSE.
**      Batch & isn't in quality control.
*        CALL METHOD zabsf_pp_cl_log=>add_message
*          EXPORTING
*            msgty      = 'E'
*            msgno      = '094'
*            msgv1      = l_batch
*          CHANGING
*            return_tab = return_tab.
*      ENDIF.
    else.
*    Record now found, throw error message
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = 'E'
          msgno      = '072'
        changing
          return_tab = return_tab.
      flag_pal_erro = 'X'.
    endif.

* Paletização
*    DATA: lv_por_completar TYPE lqua-verme,
*          lv_verme_palete  TYPE lqua-verme.
*    IF flag_pal_erro = space.
*
*      SELECT SINGLE parva FROM zabsf_pp032 INTO @DATA(lv_lgpla)
*        WHERE werks = @inputobj-werks
*          AND parid = 'PALLET_LGPLA'.
*
*      SELECT SINGLE parva FROM zabsf_pp032 INTO @DATA(lv_lgtyp)
*        WHERE werks = @inputobj-werks
*          AND parid = 'SUPPLYMENT_LGTYP'.
*
*      SELECT SINGLE * FROM lqua INTO @DATA(ls_lqua)
*        WHERE matnr = @arbpl_print_st-matnr
*          AND charg = @batch
*          AND lgtyp = @lv_lgtyp
*          AND lgpla = @lv_lgpla.
*      IF sy-subrc EQ 0.
*
*        SELECT SINGLE * FROM marm INTO @DATA(ls_marm)
*          WHERE matnr = @arbpl_print_st-matnr
*            AND meinh = 'PAL'.
*
*        lv_verme_palete = ls_lqua-verme * ls_marm-umren / ls_marm-umrez.
*        IF lv_verme_palete < 1. " PODE HAVER PALETIZAÇÃO
**VALOR EM UN BASICA POR COMPLETAR NA PALETE
*          lv_por_completar = ls_marm-umrez / ls_marm-umren - ls_lqua-verme.
*
*          CALL METHOD zabsf_pp_cl_log=>add_message
*            EXPORTING
*              msgty      = 'W'
*              msgno      = '125'
*              msgv1      = lv_por_completar
*              msgv2      = ls_lqua-meins
*            CHANGING
*              return_tab = return_tab.
*
*        ENDIF.
*      ENDIF.
*    ENDIF.


  endmethod.
ENDCLASS.
