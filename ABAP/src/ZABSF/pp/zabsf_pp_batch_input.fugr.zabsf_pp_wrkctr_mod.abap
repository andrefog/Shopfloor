FUNCTION ZABSF_PP_WRKCTR_MOD.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(CTU) LIKE  APQI-PUTACTIVE DEFAULT 'X'
*"     VALUE(MODE) LIKE  APQI-PUTACTIVE DEFAULT 'N'
*"     VALUE(UPDATE) LIKE  APQI-PUTACTIVE DEFAULT 'L'
*"     VALUE(GROUP) LIKE  APQI-GROUPID OPTIONAL
*"     VALUE(USER) LIKE  APQI-USERID OPTIONAL
*"     VALUE(KEEP) LIKE  APQI-QERASE OPTIONAL
*"     VALUE(HOLDDATE) LIKE  APQI-STARTDATE OPTIONAL
*"     VALUE(NODATA) LIKE  APQI-PUTACTIVE DEFAULT '/'
*"     VALUE(WERKS_001) LIKE  BDCDATA-FVAL DEFAULT '0070'
*"     VALUE(RESOURCE_002) LIKE  BDCDATA-FVAL DEFAULT 'CEN01'
*"     VALUE(STEXT_003) LIKE  BDCDATA-FVAL DEFAULT '/'
*"     VALUE(VERAN_004) LIKE  BDCDATA-FVAL DEFAULT '/'
*"     VALUE(PLANV_005) LIKE  BDCDATA-FVAL DEFAULT '/'
*"     VALUE(VGWTS_006) LIKE  BDCDATA-FVAL DEFAULT '/'
*"     VALUE(STEXT_007) LIKE  BDCDATA-FVAL DEFAULT '/'
*"     VALUE(VERAN_008) LIKE  BDCDATA-FVAL DEFAULT '/'
*"     VALUE(PLANV_009) LIKE  BDCDATA-FVAL DEFAULT '/'
*"     VALUE(VGWTS_010) LIKE  BDCDATA-FVAL DEFAULT '/'
*"  EXPORTING
*"     VALUE(SUBRC) LIKE  SYST-SUBRC
*"  TABLES
*"      MESSTAB STRUCTURE  BDCMSGCOLL OPTIONAL
*"--------------------------------------------------------------------

subrc = 0.

perform bdc_nodata      using NODATA.

perform open_group      using GROUP USER KEEP HOLDDATE CTU.

perform bdc_dynpro      using 'SAPLCRA0' '0090'.
perform bdc_field       using 'BDC_CURSOR'
                              'RC68A-WERKS'.
perform bdc_field       using 'BDC_OKCODE'
                              '/00'.
perform bdc_field       using 'RC68A-WERKS'
                              WERKS_001.
perform bdc_field       using 'RCRDE-RESOURCE'
                              RESOURCE_002.
perform bdc_dynpro      using 'SAPLCRA0' '4000'.
perform bdc_field       using 'BDC_OKCODE'
                              '=STAW'.
perform bdc_field       using 'BDC_CURSOR'
                              'P1000-STEXT'.
perform bdc_field       using 'P1000-STEXT'
                              STEXT_003.
perform bdc_field       using 'P3000-VERAN'
                              VERAN_004.
perform bdc_field       using 'P3000-PLANV'
                              PLANV_005.
perform bdc_field       using 'P3000-VGWTS'
                              VGWTS_006.
perform bdc_dynpro      using 'SAPLBSVA' '0300'.
perform bdc_field       using 'BDC_OKCODE'
                              '=BACK'.
perform bdc_field       using 'BDC_CURSOR'
                              'P3000-WERKS'.
perform bdc_dynpro      using 'SAPLCRA0' '4000'.
perform bdc_field       using 'BDC_OKCODE'
                              '=UPD'.
perform bdc_field       using 'BDC_CURSOR'
                              'P1000-STEXT'.
perform bdc_field       using 'P1000-STEXT'
                              STEXT_007.
perform bdc_field       using 'P3000-VERAN'
                              VERAN_008.
perform bdc_field       using 'P3000-PLANV'
                              PLANV_009.
perform bdc_field       using 'P3000-VGWTS'
                              VGWTS_010.
perform bdc_transaction tables messtab
using                         'CRC2'
                              CTU
                              MODE
                              UPDATE.
if sy-subrc <> 0.
  subrc = sy-subrc.
  exit.
endif.

perform close_group using     CTU.





ENDFUNCTION.
INCLUDE BDCRECXY .
