class ZCL_IM_WORKORDER_CONFIRM definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_WORKORDER_CONFIRM .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_WORKORDER_CONFIRM IMPLEMENTATION.


  METHOD if_ex_workorder_confirm~at_cancel_check.
*  Variables
    DATA: l_rueck_input TYPE co_rueck,
          l_rmzhl_input TYPE co_rmzhl.

*  Export to memory Box quantity
    EXPORT l_rueck_input FROM is_confirmation-rueck TO MEMORY ID 'RUECK_INPUT_SF'.
*  Export to memory Activity Number
    EXPORT l_rmzhl_input FROM is_confirmation-rmzhl TO MEMORY ID 'RMZHL_INPUT_SF'.
  ENDMETHOD.


  METHOD if_ex_workorder_confirm~at_save.
* Variables
    DATA: l_rueck_input TYPE co_rueck,
          l_rmzhl_input TYPE co_rmzhl.

*  Import from memory Box quantity
    IMPORT l_rueck_input TO l_rueck_input FROM MEMORY ID 'RUECK_INPUT_SF'.
*  Import from memory Activity Number
    IMPORT l_rmzhl_input TO l_rmzhl_input FROM MEMORY ID 'RMZHL_INPUT_SF'.


    IF l_rueck_input IS NOT INITIAL AND l_rmzhl_input IS NOT INITIAL.
*    Check if exist record in table ZLP_PP_SF065
      SELECT *
        FROM zabsf_pp065
        INTO TABLE @DATA(lt_sf065)
       WHERE conf_no  EQ @l_rueck_input
         AND conf_cnt EQ @l_rmzhl_input.

      IF lt_sf065[] IS NOT INITIAL.
*      Change line cancel
        LOOP AT lt_sf065 INTO DATA(ls_sf065).
*        Update record cancelled
*          UPDATE zabsf_pp065 FROM @( VALUE #( BASE ls_sf065 reversal = abap_true ) ).
          ls_sf065-reversal = abap_true.
          UPDATE zabsf_pp065 FROM ls_sf065.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  method IF_EX_WORKORDER_CONFIRM~BEFORE_UPDATE.
  endmethod.


  method IF_EX_WORKORDER_CONFIRM~INDIVIDUAL_CAPACITY.
  endmethod.


  method IF_EX_WORKORDER_CONFIRM~IN_UPDATE.
  endmethod.
ENDCLASS.
