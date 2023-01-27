class ZCL_IM_ABSF_PM_BREAKD_CALC definition
  public
  final
  create public .

public section.

  interfaces IF_EX_NOTIF_EVENT_SAVE .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_ABSF_PM_BREAKD_CALC IMPLEMENTATION.


  method IF_EX_NOTIF_EVENT_SAVE~CHANGE_DATA_AT_SAVE.

    "BMR SAP NOTE : 1619709 implementation
  DATA: lv_from_shopfloor TYPE boole_d.

  IMPORT from_shopfloor TO lv_from_shopfloor FROM MEMORY ID 'SHOPFLOOR_NOTE_CLOSE'.

  IF lv_from_shopfloor EQ abap_true.

*   IF cs_viqmel-auszt IS INITIAL.
*   Only execute if breakdown time is not already set
      IF ( cs_viqmel-msaus = 'X' ) AND ( cs_viqmel-ausvn <> 0 ) AND ( cs_viqmel-ausbs >= cs_viqmel-ausvn ).
*       Only if breakdown indicator is set, valid start date, end date not less than start date
        cs_viqmel-auszt = ( cs_viqmel-ausbs - cs_viqmel-ausvn ) * 24 * 60 * 60.
        cs_viqmel-auszt = cs_viqmel-auszt
                  + ( cs_viqmel-auztb - cs_viqmel-auztv ).
      ENDIF.
*    ENDIF.

  ENDIF.

  FREE MEMORY ID 'SHOPFLOOR_NOTE_CLOSE'.


*>>> CBC - 05.04.2017
    DATA: lv_pm_wkcenter TYPE ppsid.

    IMPORT pm_wkcenter TO lv_pm_wkcenter FROM MEMORY ID 'Z_PM_SHOPFLOOR_CREATE_NOTIF'.

    IF lv_pm_wkcenter NE '00000000'.
      cs_viqmel-ppsid = lv_pm_wkcenter.
    ENDIF.

    FREE MEMORY ID 'Z_PM_SHOPFLOOR_CREATE_NOTIF'.
    CLEAR lv_pm_wkcenter.
*<<< CBC - 05.04.2017

  endmethod.
ENDCLASS.
