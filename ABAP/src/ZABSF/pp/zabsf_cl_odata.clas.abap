class ZABSF_CL_ODATA definition
  public
  final
  create public .

public section.

  types:
    BEGIN OF ty_operationalert,
        materialid    TYPE matnr,
        alertid       TYPE zabsf_pp_e_alertid,
        materialdesc  TYPE maktx,
        operation     TYPE vornr,
        alerttitle    TYPE zabsf_pp_e_alerttitle,
        alertdesc     TYPE zabsf_pp_e_alert,
        flag          TYPE flag,
        username      TYPE zabsf_e_username,
        operationdesc TYPE ltxa1,
        areaid        TYPE zabsf_pp_e_areaid,
      END OF ty_operationalert .
  types:
    tt_operationalert TYPE STANDARD TABLE OF ty_operationalert WITH DEFAULT KEY .
  types:
    BEGIN OF ty_operationnumber,
        matnr TYPE matnr,
        vornr TYPE vornr,
        ltxa1 TYPE ltxa1,
        werks TYPE werks_d,
      END OF ty_operationnumber .
  types:
    tt_operationnumber TYPE STANDARD TABLE OF ty_operationnumber WITH DEFAULT KEY .
  types:
    BEGIN OF ty_workcenteroperation,
        workcenterid          TYPE arbpl,
        workcenterdescription TYPE cr_ktext,
      END OF ty_workcenteroperation .
  types:
    tt_workcenteroperation TYPE STANDARD TABLE OF ty_workcenteroperation WITH DEFAULT KEY .
  types:
    BEGIN OF ty_info,
        matnr  TYPE matnr,
        gmein  TYPE meins,
        vornr  TYPE vornr,
        hname  TYPE cr_hname,
        arbpl  TYPE arbpl,
        aplzl  TYPE co_aplzl,
        aufpl  TYPE co_aufpl,
        rueck  TYPE co_rueck,
        tipord TYPE zabsf_pp_e_tipord,
        wareid TYPE zlp_sf_e_wareid,
        aufnr  TYPE aufnr,
      END OF ty_info .
  types:
    tt_info TYPE STANDARD TABLE OF ty_info WITH DEFAULT KEY .
  types:
    BEGIN OF ty_label,
        material              TYPE matnr,
        order                 TYPE aufnr,
        operation             TYPE vornr,
        workcenter            TYPE arbpl,
        workcenterdescription TYPE cr_ktext,
        type                  TYPE char1,
        qtyconf               TYPE string,
        qtytotal              TYPE string,
        qtyparc               TYPE string,
        pdf                   TYPE string,
      END OF ty_label .
  types:
    BEGIN OF ty_form,
        materialid  TYPE string,
        operationid TYPE string,
        mime_type   TYPE string,
        value       TYPE string,
      END OF ty_form .
  types:
    BEGIN OF ty_movimentlabel,
        materialid   TYPE matnr,
        materialdesc TYPE maktx,
        lote         TYPE charg_d,
        deporigem    TYPE vornr,
        depdestino   TYPE vornr,
        pdf          TYPE string,
      END OF ty_movimentlabel .
  types:
    BEGIN OF ty_contentcsv,
        content TYPE string,
      END OF ty_contentcsv .
  types:
    tt_contentcsv TYPE STANDARD TABLE OF ty_contentcsv WITH DEFAULT KEY .
  types:
    BEGIN OF ty_workday,
        refdt   TYPE string,
        content TYPE tt_contentcsv,
      END OF ty_workday .
  types:
    BEGIN OF ty_defect,
        workcenterid                TYPE string,
        id                          TYPE string,
        defectdescription           TYPE string,
        requiresreworkordercriation TYPE abap_bool,
        createreworkordercriation   TYPE abap_bool,
        defectquantity              TYPE i,
        productionorderid           TYPE string,
        operationid                 TYPE string,
        materialid                  TYPE string,
        ireworkorderid              TYPE string,
        oreworkorderid              TYPE string,
        exist                       TYPE string,
        ordernumber                 TYPE string,
      END OF ty_defect .
  types:
    tt_defect TYPE STANDARD TABLE OF ty_defect WITH DEFAULT KEY .
  types:
    BEGIN OF ty_deposit_positions,
        plant TYPE string,
        lgort TYPE string,
        lgpbe TYPE string,
      END OF ty_deposit_positions .
  types:
    tt_deposit_positions TYPE STANDARD TABLE OF ty_deposit_positions WITH DEFAULT KEY .
  types:
    BEGIN OF ty_reportpointoperations,
        rpoint                      TYPE  string,
        reportpointoperationplanned TYPE boolean,
        typeid                      TYPE char1,
        amount                      TYPE zabsf_pp_e_amount,
        aplzl                       TYPE co_aplzl,
        arbpl                       TYPE arbpl,
        auart                       TYPE auart,
        aufnr                       TYPE aufnr,
        aufpl                       TYPE co_aufpl,
        autwe                       TYPE autwe,
        availability_information    TYPE zbapi_order_return_tt,
        batch                       TYPE charg_d,
        batch_validation            TYPE flag,
        boxqty                      TYPE zabsf_pp_e_boxqty,
        cname                       TYPE pad_cname,
        components                  TYPE zabsf_pp_t_components,
        components_checked          TYPE boole_d,
        count_ini                   TYPE zabsf_pp_e_count_ini,
        cy_seqnr                    TYPE char20,
        date_reprog                 TYPE zabsf_pp_e_date_reprog,
        gamng                       TYPE gamng,
        gmein                       TYPE meins,
        gsmng                       TYPE gsmng,
        gsmngweek                   TYPE gsmng,
        gsmngdelay                  TYPE gsmng,
        stk0070                     TYPE labst,
        stk0079                     TYPE labst,
        gstrs                       TYPE co_gstrs,
        gsuzs                       TYPE co_gsuzs,
        kapid                       TYPE kapid,
        ktext                       TYPE kaptext,
        lenum                       TYPE lenum,
        lmnga                       TYPE lmnga,
        lmnga_card                  TYPE lmnga,
        lmngasm                     TYPE zabsf_pp_e_lmngasm,
        ltxa1                       TYPE ltxa1,
        maktx                       TYPE maktx,
        marco                       TYPE flag,
        matnr                       TYPE matnr,
        missing_parts               TYPE boole_d,
        missingqty                  TYPE zabsf_pp_e_missingqty,
        multimaterial               TYPE flag,
        name                        TYPE kapname,
        numb_cycle                  TYPE numc10,
        numb_mcycle                 TYPE zabsf_pp_e_numb_mcycle,
        oprid_tab                   TYPE zabsf_pp_t_operador,
        override                    TYPE boole_d,
        passage                     TYPE zabsf_pp_e_passage,
        prdqty_box                  TYPE zabsf_pp_e_prdqty_box,
        prod_time                   TYPE zabsf_pp_e_prod_time,
        production_plan             TYPE char50,
        program                     TYPE char50,
        project                     TYPE char50,
        project_plan                TYPE char20,
        projn                       TYPE ps_psp_ele,
        psphi                       TYPE ps_psphi,
        qtdrpoint                   TYPE zabsf_pp_e_qtdrpoint,
        qtext                       TYPE qtext,
        qty_proc                    TYPE zabsf_pp_e_qty,
        quali                       TYPE quali_d,
        read_label                  TYPE boole_d,
        regime_desc                 TYPE zabsf_pp_e_regime_desc,
        regime_id                   TYPE zabsf_pp_e_regime_id,
        rmnga                       TYPE ru_rmnga,
        rueck                       TYPE co_rueck,
        schedule_desc               TYPE zabsf_pp_e_schedule_desc,
        schedule_id                 TYPE zabsf_pp_e_schedule_id,
        schematics                  TYPE char50,
        sequence                    TYPE /bofu/fdt_seq_no,
        status                      TYPE j_status,
        status_color                TYPE zpp_status_color_e,
        status_desc                 TYPE j_txt30,
        status_oper                 TYPE j_status,
        theoretical_qty             TYPE zabsf_pp_e_theoretical_qty,
        time_mcycle                 TYPE zabsf_pp_e_time_mcycle,
        tipord                      TYPE zabsf_pp_e_tipord,
        total_qty                   TYPE gamng,
        traceability                TYPE zpp_total_traceability,
        unit_alt                    TYPE meins,
        units                       TYPE zabsf_pp_t_units_of_matnr,
        vornr                       TYPE vornr,
        vornr_tot                   TYPE zabsf_pp_e_vornr,
        wareid                      TYPE zabsf_pp_e_wareid,
        werks                       TYPE werks_d,
        xmnga                       TYPE ru_xmnga,
        xmnga_card                  TYPE ru_xmnga,
        zerma_txt                   TYPE dzerma_txt,
        info                        TYPE ty_info,
        oinfo                       TYPE ty_info,
        refdt                       TYPE string,
        hname                       TYPE cr_hname,
        add_rem                     TYPE char1,
      END OF ty_reportpointoperations .
  types:
    tt_reportpointoperations TYPE STANDARD TABLE OF ty_reportpointoperations WITH DEFAULT KEY .
  types:
    BEGIN OF ty_reportpoint,
        hname                 TYPE cr_hname,
        ktext                 TYPE cr_ktext,
        endda                 TYPE endda,
        rpoint                TYPE zabsf_pp_e_rpoint,
        takt                  TYPE zabsf_pp_e_takt,
        lmnga                 TYPE lmnga,
        lmngasm               TYPE zabsf_pp_e_lmngasm,
        gsmng                 TYPE gsmng,
        status                TYPE j_status,
        status_desc           TYPE j_txt30,
        statusstopdescription TYPE string,
        gmein                 TYPE meins,
        operreportpoint       TYPE zabsf_pp_t_operador,
        operareportpoint      TYPE zabsf_pp_t_operador,
        reportpointoperations TYPE tt_reportpointoperations,
      END OF ty_reportpoint .
  types:
    tt_reportpoint TYPE STANDARD TABLE OF ty_reportpoint WITH DEFAULT KEY .
  types:
    BEGIN OF ty_reportpointsetoperator,
        rpoint    TYPE zabsf_pp_e_rpoint,
        time      TYPE string,
        refdt     TYPE string,
        operators TYPE zabsf_pp_t_operador,
      END OF ty_reportpointsetoperator .
  types:
    tt_reportpointsetoperator TYPE STANDARD TABLE OF ty_reportpointsetoperator WITH DEFAULT KEY .
  types:
    BEGIN OF ty_reportpointgoodsmvt,
        matnr          TYPE matnr,
        vorne          TYPE pzpnr,
        lmnga          TYPE lmnga,
        meins          TYPE meins,
        planorder      TYPE plnum,
        refdt          TYPE datum,
        mlmnga         TYPE lmnga,
        slgort         TYPE lgort_d,
        dlgort         TYPE lgort_d,
        components     TYPE zabsf_pp_t_components,
        materialbatch  TYPE zabsf_pp_t_materialbatch,
        materialserial TYPE zabsf_pp_t_materialserial,
      END OF ty_reportpointgoodsmvt .
  types:
    tt_reportpointgoodsmvt TYPE STANDARD TABLE OF ty_reportpointgoodsmvt WITH DEFAULT KEY .
  types:
    BEGIN OF ty_reason,
        reasonid    TYPE string,
        description TYPE string,
        scrapqty    TYPE string,
      END OF ty_reason .
  types:
    tt_reason TYPE STANDARD TABLE OF ty_reason WITH DEFAULT KEY .
  types:
    BEGIN OF ty_reportpointdefects,
        rpoint     TYPE string,
        reasontype TYPE string,
        refdt      TYPE string,
        defects    TYPE tt_defect,
        reason     TYPE tt_reason,
      END OF ty_reportpointdefects .
  types:
    tt_reportpointdefects TYPE STANDARD TABLE OF ty_reportpointdefects WITH DEFAULT KEY .
  types:
    BEGIN OF ty_reportpointquality,
        rpoint TYPE zabsf_pp_e_rpoint,
        matnr  TYPE matnr,
        refdt  TYPE vvdatum,
        scrap  TYPE zabsf_pp_t_scrap,
        rework TYPE zabsf_pp_t_rework,
      END OF ty_reportpointquality .
  types:
    tt_reportpointquality TYPE STANDARD TABLE OF ty_reportpointquality WITH DEFAULT KEY .
  types:
    BEGIN OF ty_passage,
        passnumber  TYPE string,
        result_def  TYPE string,
        defect_desc TYPE string,
      END OF ty_passage .
  types:
    tt_passage TYPE STANDARD TABLE OF ty_passage WITH DEFAULT KEY .
  types:
    BEGIN OF ty_reportpointpassage,
        hname      TYPE cr_hname,
        rpoint     TYPE zlp_sf_e_rpoint,
        matnr      TYPE matnr,
        gernr      TYPE gernr,
        refdt      TYPE vvdatum,
        passnumber TYPE zabsf_pp_e_passnumber,
        flag_def   TYPE zabsf_pp_e_flag_def,
        defectid   TYPE zabsf_pp_e_defectid,
        defects    TYPE tt_defect,
        passages   TYPE tt_passage,
      END OF ty_reportpointpassage .
  types:
    tt_reportpointpassage TYPE STANDARD TABLE OF ty_reportpointpassage WITH DEFAULT KEY .
  types:
    BEGIN OF ty_systeminfo,
        mandt TYPE string,
        sysid TYPE string,
      END OF ty_systeminfo .
  types:
    tt_systeminfo TYPE STANDARD TABLE OF ty_systeminfo WITH DEFAULT KEY .
  types:
    BEGIN OF ty_parameter,
        parameterid TYPE string,
        value       TYPE string,
        description TYPE string,
      END OF ty_parameter .
  types:
    tt_parameter TYPE STANDARD TABLE OF ty_parameter WITH DEFAULT KEY .
  types:
    BEGIN OF ty_role,
        id              TYPE i,
        roledescription TYPE string,
      END OF ty_role .
  types:
    tt_role TYPE STANDARD TABLE OF ty_role .
  types:
    BEGIN OF ty_hierarchystatus,
        areaid  TYPE string,
        shiftid TYPE string,
        status  TYPE i,
      END OF ty_hierarchystatus .
  types:
    tt_hierarchystatus TYPE STANDARD TABLE OF ty_hierarchystatus WITH DEFAULT KEY .
  types:
    BEGIN OF ty_hierarchy,
        hierarchyid          TYPE string,
        hierarchydescription TYPE string,
        areaid               TYPE string,
        shiftid              TYPE string,
        hstatus              TYPE tt_hierarchystatus,
        status               TYPE i,
      END OF ty_hierarchy .
  types:
    tt_hierarchy TYPE STANDARD TABLE OF ty_hierarchy .
  types:
    BEGIN OF ty_timereportorder,
        centerid               TYPE string,
        workcenterid           TYPE string,
        project                TYPE string,
        schematics             TYPE string,
        pf                     TYPE string,
        orderid                TYPE string,
        accumulatedmachinetime TYPE p LENGTH 7 DECIMALS 2,
        accumulatedlabortime   TYPE p LENGTH 7 DECIMALS 2,
        confirmedquantity      TYPE p LENGTH 7 DECIMALS 2,
        plannedquantity        TYPE p LENGTH 7 DECIMALS 2,
      END OF ty_timereportorder .
  types:
    tt_timereportorder TYPE STANDARD TABLE OF ty_timereportorder WITH DEFAULT KEY .
  types:
    BEGIN OF ty_timereportcenter,
        centerid         TYPE string,
        timereportorders TYPE tt_timereportorder,
      END OF ty_timereportcenter .
  types:
    tt_timereportcenter TYPE STANDARD TABLE OF ty_timereportcenter WITH DEFAULT KEY .
  types:
    BEGIN OF ty_operationconsumptionlist,
        id                   TYPE i,
        componentid          TYPE string,
        componentdescription TYPE string,
        batch                TYPE string,
        "quantity             TYPE p LENGTH 7 DECIMALS 3,
        "QUANTITY type P length 16 decimals 0,
        quantity             TYPE i,
        unit                 TYPE string,
        workcenterid         TYPE string,
        productionorderid    TYPE string,
        operationid          TYPE string,
        materialid           TYPE string,
      END OF ty_operationconsumptionlist .
  types:
    tt_operationconsumptionlist TYPE STANDARD TABLE OF ty_operationconsumptionlist WITH DEFAULT KEY .
  types:
    BEGIN OF ty_consumptionhistoryinfo,
        workcenterid             TYPE string,
        productionorderid        TYPE string,
        operationid              TYPE string,
        materialid               TYPE string,
        card                     TYPE string,
        starttime                TYPE string,
        operationconsumptionlist TYPE tt_operationconsumptionlist,
      END OF ty_consumptionhistoryinfo .
  types:
    tt_consumptionhistoryinfo TYPE STANDARD TABLE OF ty_consumptionhistoryinfo WITH DEFAULT KEY .
  types:
    BEGIN OF ty_equipment,
        areaid               TYPE string,
        workcenterid         TYPE string,
        equipmentid          TYPE string,
        equipmentdescription TYPE string,
      END OF ty_equipment .
  types:
    tt_equipment TYPE STANDARD TABLE OF ty_equipment WITH DEFAULT KEY .
  types:
    BEGIN OF ty_missingpart,
        materialid          TYPE string,
        operationid         TYPE string,
        productionorderid   TYPE string,
        workcenterid        TYPE string,
        offlineversion      TYPE i,
        materialdescription TYPE string,
        quantitymissing     TYPE p LENGTH 16 DECIMALS 0,
        project             TYPE string,
        schematics          TYPE string,
      END OF ty_missingpart .
  types:
    tt_missingpart TYPE STANDARD TABLE OF ty_missingpart WITH DEFAULT KEY .
  types:
    BEGIN OF ty_multimaterial,
        materialid          TYPE string,
        operationid         TYPE string,
        productionorderid   TYPE string,
        workcenterid        TYPE string,
        offlineversion      TYPE i,
        reservenumber       TYPE string,
        reserveitem         TYPE string,
        materialdescription TYPE string,
        quantitytomake      TYPE p LENGTH 16 DECIMALS 0,
        quantitymade        TYPE p LENGTH 16 DECIMALS 0,
        quantityrework      TYPE p LENGTH 16 DECIMALS 0,
        quantityscrap       TYPE p LENGTH 16 DECIMALS 0,
        quantitymissing     TYPE p LENGTH 16 DECIMALS 0,
        bundlevalue         TYPE i,
        boxbundle           TYPE i,
        goodquantity        TYPE i,
        unitvalue           TYPE string,
        unittype            TYPE string,
        unitgmein           TYPE string,
        project             TYPE string,
        schematics          TYPE string,
        checked             TYPE abap_bool,
        conftime            TYPE string,
        confday             TYPE string,
        lgort               TYPE string,
        sobkz               TYPE string,
        batchid             TYPE string,
        vornr               TYPE string,
        consumedmaterialid  TYPE string,
        consumedbatchid     TYPE string,
      END OF ty_multimaterial .
  types:
    tt_multimaterial TYPE STANDARD TABLE OF ty_multimaterial WITH DEFAULT KEY .
  types:
    BEGIN OF ty_operationinfo,
        rueck  TYPE string,
        aufpl  TYPE string,
        aplzl  TYPE string,
        matnr  TYPE string,
        tipord TYPE string,
        wareid TYPE string,
        arbpl  TYPE string,
        gmein  TYPE string,
        vorne  TYPE string,
        hname  TYPE string,
        aufnr  TYPE string,
      END OF ty_operationinfo .
  types:
    tt_operationinfo TYPE STANDARD TABLE OF ty_operationinfo WITH DEFAULT KEY .
  types:
    BEGIN OF ty_operationstopreason,
        id                             TYPE string,
        operationstopreasondescription TYPE string,
      END OF ty_operationstopreason .
  types:
    tt_operationstopreason TYPE STANDARD TABLE OF ty_operationstopreason WITH DEFAULT KEY .
  types:
    BEGIN OF ty_rework,
        id                TYPE i,
        operationid       TYPE string,
        productionorderid TYPE string,
        workcenterid      TYPE string,
        offlineversion    TYPE i,
        defectquantity    TYPE i,
        defectid          TYPE string,
        defect            TYPE ty_defect,
      END OF ty_rework .
  types:
    tt_rework TYPE STANDARD TABLE OF ty_rework WITH DEFAULT KEY .
  types:
    BEGIN OF ty_scrap,
        id                TYPE string,
        scrapdescription  TYPE string,
        scrapquantity     TYPE i,
        scraplistquantity TYPE p LENGTH 16 DECIMALS 0,
        showscraplist     TYPE abap_bool,
        productionorderid TYPE string,
        operationid       TYPE string,
        materialid        TYPE string,
        conftime          TYPE string,
        confday           TYPE string,
      END OF ty_scrap .
  types:
    tt_scrap TYPE STANDARD TABLE OF ty_scrap WITH DEFAULT KEY .
  types:
    BEGIN OF ty_operationconsumption,
        productionorderid          TYPE string,
        materialid                 TYPE string,
        operationconsumptiontype   TYPE string,
        reservenumber              TYPE string,
        reserveitem                TYPE string,
        batchid                    TYPE string,
        unitid                     TYPE string,
        materialdescription        TYPE string,
        ilgort                     TYPE string,
        materialdescriptiondisplay TYPE string,
        olgort                     TYPE string,
        operationdescription       TYPE string,
        quantitynecessary          TYPE p LENGTH 16 DECIMALS 0,
        quantityconsumed           TYPE p LENGTH 16 DECIMALS 0,
        quantitytoconsumedisplay   TYPE string,
        quantitytoconsume          TYPE p LENGTH 16 DECIMALS 0,
        iunit                      TYPE string,
        iunit_output               TYPE string,
        ounit                      TYPE string,
        iorsnum                    TYPE string,
        oorsnum                    TYPE string,
        iorspos                    TYPE string,
        oorspos                    TYPE string,
        batchexpirationdate        TYPE string,
        displaymode                TYPE string,
        action                     TYPE string,
        batchflag                  TYPE string,
        workcenterid               TYPE string,
        operationid                TYPE string,
        availablestock             TYPE p LENGTH 16 DECIMALS 0,
        palletid                   TYPE string,
        reservedmaterial           TYPE abap_bool,
        seqlantek                  TYPE string,
        quantitysuggested          TYPE p LENGTH 16 DECIMALS 0,
        unitsuggested              TYPE string,
        width                      TYPE string,
        length                     TYPE string,
        reference                  TYPE string,
        operationconsumed          TYPE string,
      END OF ty_operationconsumption .
  types:
    tt_operationconsumption TYPE STANDARD TABLE OF ty_operationconsumption WITH DEFAULT KEY .
  types:
    BEGIN OF ty_orderoperator,
        operatorid TYPE string,
      END OF ty_orderoperator .
  types:
    tt_orderoperator TYPE STANDARD TABLE OF ty_orderoperator WITH DEFAULT KEY .
  types:
    BEGIN OF ty_scrapmissing,
        id                     TYPE string,
        operationid            TYPE string,
        productionorderid      TYPE string,
        hierarchyid            TYPE string,
        workcenterid           TYPE string,
        offlineversion         TYPE i,
        scrapdescription       TYPE string,
        scrapquantity          TYPE i,
        goodnrcycles           TYPE i,
        scrapalreadyregistered TYPE p LENGTH 16 DECIMALS 0,
        consumptionlist        TYPE string,
        consumptionlistitems   TYPE tt_operationconsumption,
        conftime               TYPE string,
        confday                TYPE string,
        processrecord          TYPE abap_bool,
        unit                   TYPE string,
        orderoperators         TYPE tt_orderoperator,
      END OF ty_scrapmissing .
  types:
    tt_scrapmissing TYPE STANDARD TABLE OF ty_scrapmissing WITH DEFAULT KEY .
  types:
    BEGIN OF ty_operation,
        id                             TYPE string,
        productionorderid              TYPE string,
        hierarchyid                    TYPE string,
        workcenterid                   TYPE string,
        offlineversion                 TYPE i,
        operationdescription           TYPE string,
        materialid                     TYPE string,
        materialdescription            TYPE string,
        programeddate                  TYPE string,
        typeid                         TYPE string,
        productionordertype            TYPE string,
        reprogproductionorder          TYPE abap_bool,
        quantitytomake                 TYPE p LENGTH 16 DECIMALS 0,
        quantitymade                   TYPE p LENGTH 16 DECIMALS 0,
        quantityrework                 TYPE p LENGTH 16 DECIMALS 0,
        quantityscrap                  TYPE p LENGTH 16 DECIMALS 0,
        quantitymissing                TYPE p LENGTH 16 DECIMALS 0,
        bundlevalue                    TYPE i,
        boxbundle                      TYPE i,
        goodquantity                   TYPE i,
        printbox                       TYPE string,
        accumulatedquantity            TYPE p LENGTH 16 DECIMALS 0,
        numberoperationstoend          TYPE i,
        statusid                       TYPE string,
        previousstatusid               TYPE string,
        statusdescription              TYPE string,
        starthour                      TYPE string,
        startday                       TYPE string,
        operationstopreasonid          TYPE string,
        operationstopreason            TYPE ty_operationstopreason,
        scrapquantity                  TYPE i,
        scrapid                        TYPE string,
        scrap                          TYPE ty_scrap,
        defectids                      TYPE string,
        defectquantities               TYPE i,
        operationaction                TYPE string,
        operationactivity              TYPE string,
        operationduration              TYPE i,
        operationunit                  TYPE string,
        alerttext                      TYPE string,
        operatorid                     TYPE string,
        operatorname                   TYPE string,
        operatorqualificationid        TYPE string,
        operatorqualificationdescripti TYPE string,
        scheduleid                     TYPE string,
        scheduledescription            TYPE string,
        regimeid                       TYPE string,
        regimedescription              TYPE string,
        initialcyclecounter            TYPE i,
        currenttheoreticalcyclecounter TYPE i,
        currentrealcyclecounter        TYPE i,
        totaltheoreticalquantity       TYPE i,
        theoreticalquantity            TYPE i,
        goodnrcycles                   TYPE i,
        operationlot                   TYPE string,
        operationpallet                TYPE string,
        changeoperationlot             TYPE string,
        changeoperationpallet          TYPE string,
        closebox                       TYPE abap_bool,
        consumptionlist                TYPE string,
        consumptionlistitems           TYPE tt_operationconsumption,
        conftime                       TYPE string,
        confday                        TYPE string,
        programedtime                  TYPE string,
        firstcycle                     TYPE string,
        alternateunit                  TYPE string,
        materialimageurl               TYPE string,
        spinningtime                   TYPE p LENGTH 16 DECIMALS 0,
        viscosity                      TYPE p LENGTH 16 DECIMALS 0,
        inktemperature                 TYPE p LENGTH 16 DECIMALS 0,
        inksugestedtemperature         TYPE p LENGTH 16 DECIMALS 0,
        mininktemperature              TYPE p LENGTH 16 DECIMALS 0,
        maxinktemperature              TYPE p LENGTH 16 DECIMALS 0,
        productioninstructiondocumentu TYPE string,
        outputsettings_schedulesandreg TYPE abap_bool,
        marcooperation                 TYPE abap_bool,
        iinfo                          TYPE ty_operationinfo,
        oinfo                          TYPE ty_operationinfo,
        reworklist                     TYPE tt_rework,
        finalcyclecounter              TYPE i,
        totalmissingquantity           TYPE string,
        totalqtyalreadyregistered      TYPE p LENGTH 16 DECIMALS 0,
        scrapsmissing                  TYPE tt_scrapmissing,
        goodquantityoperator           TYPE p LENGTH 16 DECIMALS 0,
        scrapquantityoperator          TYPE p LENGTH 16 DECIMALS 0,
        islotoperation                 TYPE abap_bool,
        processrecord                  TYPE abap_bool,
        areaadminvalidated             TYPE abap_bool,
        workcentertype                 TYPE string,
        adjustmentquantity             TYPE i,
        unitvalue                      TYPE string,
        unittype                       TYPE string,
        unitgmein                      TYPE string,
        project                        TYPE string,
        schematics                     TYPE string,
        componentschecked              TYPE string,
        availabilitystatus             TYPE string,
        availabilityoverride           TYPE string,
        availabilitycolour             TYPE string,
        pf                             TYPE string,
        productionplanid               TYPE string,
        missingparts                   TYPE tt_missingpart,
        ismultimaterial                TYPE abap_bool,
        ispreviousoperationnecessary   TYPE abap_bool,
        ismmbatchvalidationnecessary   TYPE abap_bool,
        multimaterials                 TYPE tt_multimaterial,
        blockstatusonclose             TYPE abap_bool,
        checked                        TYPE abap_bool,
        workcenterpositionid           TYPE string,
        workcenterpositionname         TYPE string,
        workcenterpositiondescription  TYPE string,
        previousoperationconfirmation  TYPE string,
        previousoperationcounter       TYPE string,
        ordersequencenumber            TYPE string,
        sequence                       TYPE i,
        tableordersequence             TYPE string,
        tableordersequencechanged      TYPE abap_bool,
        traceability                   TYPE string,
        materialbatch                  TYPE zabsf_pp_t_materialbatch,
        materialserial                 TYPE zabsf_pp_t_materialserial,
        steus                          TYPE string,
        equipment                      TYPE string,
        orderoperators                 TYPE tt_orderoperator,
      END OF ty_operation .
  types:
    tt_operation TYPE STANDARD TABLE OF ty_operation WITH DEFAULT KEY .
  types:
    BEGIN OF ty_operationrework,
        id                             TYPE string,
        productionorderid              TYPE string,
        hierarchyid                    TYPE string,
        workcenterid                   TYPE string,
        offlineversion                 TYPE i,
        operationdescription           TYPE string,
        materialid                     TYPE string,
        materialdescription            TYPE string,
        programeddate                  TYPE string,
        typeid                         TYPE string,
        productionordertype            TYPE string,
        reprogproductionorder          TYPE abap_bool,
        quantitytomake                 TYPE p LENGTH 16 DECIMALS 0,
        quantitymade                   TYPE p LENGTH 16 DECIMALS 0,
        quantityrework                 TYPE p LENGTH 16 DECIMALS 0,
        quantityscrap                  TYPE p LENGTH 16 DECIMALS 0,
        quantitymissing                TYPE p LENGTH 16 DECIMALS 0,
        bundlevalue                    TYPE i,
        boxbundle                      TYPE i,
        goodquantity                   TYPE i,
        printbox                       TYPE string,
        accumulatedquantity            TYPE p LENGTH 16 DECIMALS 0,
        numberoperationstoend          TYPE i,
        statusid                       TYPE string,
        previousstatusid               TYPE string,
        statusdescription              TYPE string,
        starthour                      TYPE string,
        startday                       TYPE string,
        operationstopreasonid          TYPE string,
        operationstopreason            TYPE ty_operationstopreason,
        scrapquantity                  TYPE i,
        scrapid                        TYPE string,
        scrap                          TYPE ty_scrap,
        defectids                      TYPE string,
        defectquantities               TYPE i,
        operationaction                TYPE string,
        operationactivity              TYPE string,
        operationduration              TYPE i,
        operationunit                  TYPE string,
        alerttext                      TYPE string,
        operatorid                     TYPE string,
        operatorname                   TYPE string,
        operatorqualificationid        TYPE string,
        operatorqualificationdescripti TYPE string,
        scheduleid                     TYPE string,
        scheduledescription            TYPE string,
        regimeid                       TYPE string,
        regimedescription              TYPE string,
        initialcyclecounter            TYPE i,
        currenttheoreticalcyclecounter TYPE i,
        currentrealcyclecounter        TYPE i,
        totaltheoreticalquantity       TYPE i,
        theoreticalquantity            TYPE i,
        goodnrcycles                   TYPE i,
        operationlot                   TYPE string,
        operationpallet                TYPE string,
        changeoperationlot             TYPE string,
        changeoperationpallet          TYPE string,
        closebox                       TYPE abap_bool,
        consumptionlist                TYPE string,
        consumptionlistitems           TYPE tt_operationconsumption,
        conftime                       TYPE string,
        confday                        TYPE string,
        programedtime                  TYPE string,
        firstcycle                     TYPE string,
        alternateunit                  TYPE string,
        materialimageurl               TYPE string,
        spinningtime                   TYPE p LENGTH 16 DECIMALS 0,
        viscosity                      TYPE p LENGTH 16 DECIMALS 0,
        inktemperature                 TYPE p LENGTH 16 DECIMALS 0,
        inksugestedtemperature         TYPE p LENGTH 16 DECIMALS 0,
        mininktemperature              TYPE p LENGTH 16 DECIMALS 0,
        maxinktemperature              TYPE p LENGTH 16 DECIMALS 0,
        productioninstructiondocumentu TYPE string,
        outputsettings_schedulesandreg TYPE abap_bool,
        marcooperation                 TYPE abap_bool,
        iinfo                          TYPE ty_operationinfo,
        oinfo                          TYPE ty_operationinfo,
        reworklist                     TYPE tt_rework,
        finalcyclecounter              TYPE i,
        totalmissingquantity           TYPE string,
        totalqtyalreadyregistered      TYPE p LENGTH 16 DECIMALS 0,
        scrapsmissing                  TYPE tt_scrapmissing,
        goodquantityoperator           TYPE p LENGTH 16 DECIMALS 0,
        scrapquantityoperator          TYPE p LENGTH 16 DECIMALS 0,
        islotoperation                 TYPE abap_bool,
        processrecord                  TYPE abap_bool,
        areaadminvalidated             TYPE abap_bool,
        workcentertype                 TYPE string,
        adjustmentquantity             TYPE i,
        unitvalue                      TYPE string,
        unittype                       TYPE string,
        unitgmein                      TYPE string,
        project                        TYPE string,
        schematics                     TYPE string,
        componentschecked              TYPE string,
        availabilitystatus             TYPE string,
        availabilityoverride           TYPE string,
        availabilitycolour             TYPE string,
        pf                             TYPE string,
        productionplanid               TYPE string,
        missingparts                   TYPE tt_missingpart,
        ismultimaterial                TYPE abap_bool,
        ispreviousoperationnecessary   TYPE abap_bool,
        ismmbatchvalidationnecessary   TYPE abap_bool,
        multimaterials                 TYPE tt_multimaterial,
        blockstatusonclose             TYPE abap_bool,
        checked                        TYPE abap_bool,
        workcenterpositionid           TYPE string,
        workcenterpositionname         TYPE string,
        workcenterpositiondescription  TYPE string,
        previousoperationconfirmation  TYPE string,
        previousoperationcounter       TYPE string,
        ordersequencenumber            TYPE string,
        sequence                       TYPE i,
        tableordersequence             TYPE string,
        tableordersequencechanged      TYPE abap_bool,
        traceability                   TYPE string,
        materialbatch                  TYPE zabsf_pp_t_materialbatch,
        materialserial                 TYPE zabsf_pp_t_materialserial,
        steus                          TYPE string,
        equipment                      TYPE string,
        orderoperators                 TYPE tt_orderoperator,
      END OF ty_operationrework .
  types:
    tt_operationrework TYPE STANDARD TABLE OF ty_operationrework WITH DEFAULT KEY .
  types:
    BEGIN OF ty_operationoperator,
        operationid          TYPE string,
        productionorderid    TYPE string,
        workcenterid         TYPE string,
        operatorid           TYPE string,
        status               TYPE string,
        operatorname         TYPE string,
        operationrunning     TYPE abap_bool,
        starthour            TYPE string,
        startday             TYPE string,
        oinfo                TYPE ty_operationinfo,
        workcenterpositionid TYPE string,
        password             TYPE string,
      END OF ty_operationoperator .
  types:
    tt_operationoperator TYPE STANDARD TABLE OF ty_operationoperator WITH DEFAULT KEY .
  types:
    BEGIN OF ty_operator,
        id           TYPE string,
        workcenterid TYPE string,
        operatorname TYPE string,
      END OF ty_operator .
  types:
    tt_operator TYPE STANDARD TABLE OF ty_operator WITH DEFAULT KEY .
  types:
    BEGIN OF ty_productionorder,
        id                         TYPE string,
        workcenterid               TYPE string,
        productionorderdescription TYPE string,
        materialid                 TYPE string,
        materialdescription        TYPE string,
        typeid                     TYPE string,
        productionordertype        TYPE string,
      END OF ty_productionorder .
  types:
    tt_productionorder TYPE STANDARD TABLE OF ty_productionorder WITH DEFAULT KEY .
  types:
    BEGIN OF ty_stopreason,
        id                     TYPE string,
        stopreasondescription  TYPE string,
        maintenancerequesttype TYPE string,
      END OF ty_stopreason .
  types:
    tt_stopreason TYPE STANDARD TABLE OF ty_stopreason WITH DEFAULT KEY .
  types:
    BEGIN OF ty_workcenter,
        id                             TYPE string,
        workcenterdescription          TYPE string,
        statusid                       TYPE string,
        statusdescription              TYPE string,
        statusstopdescription          TYPE string,
        showscraplist                  TYPE abap_bool,
        stopreasonid                   TYPE string,
        stopreason                     TYPE ty_stopreason,
        productionorders               TYPE tt_productionorder,
        operations                     TYPE tt_operation,
        availableoperators             TYPE tt_operator,
        assignedoperators              TYPE tt_operationoperator,
        equipments                     TYPE tt_equipment,
        checklistonly                  TYPE abap_bool,
        maintenanceorderid             TYPE string,
        maintenancestageid             TYPE string,
        worktype                       TYPE string,
        finalcyclesbyoperation         TYPE string,
        starthour                      TYPE string,
        startday                       TYPE string,
        workcentertype                 TYPE string,
        outputsettings_batchgeneration TYPE abap_bool,
        outputsettings_batchvalidation TYPE abap_bool,
        outputsettings_btstart1stcycle TYPE abap_bool,
        outputsettings_btstartlaunch   TYPE abap_bool,
        outputsettings_consumptions    TYPE abap_bool,
        outputsettings_onlymarcoops    TYPE abap_bool,
        outputsettings_goodqttmarco    TYPE abap_bool,
        outputsettings_scrapqttmarco   TYPE abap_bool,
        outputsettings_prodinfo        TYPE abap_bool,
        outputsettings_qualifications  TYPE abap_bool,
        outputsettings_schedulesandreg TYPE abap_bool,
        showtransferlabel              TYPE abap_bool,
        parenthierarchy                TYPE string,
        parenthierarchydescription     TYPE string,
        shiftid                        TYPE string,
        hierarchyid                    TYPE string,
        prdty                          TYPE zabsf_pp_e_prdty,
      END OF ty_workcenter .
  types:
    tt_workcenter TYPE STANDARD TABLE OF ty_workcenter WITH DEFAULT KEY .
  types:
    BEGIN OF ty_stockreportdeposit,
        centerid           TYPE string,
        depositid          TYPE string,
        depositdescription TYPE string,
      END OF ty_stockreportdeposit .
  types:
    tt_stockreportdeposit TYPE STANDARD TABLE OF ty_stockreportdeposit WITH DEFAULT KEY .
  types:
    BEGIN OF ty_stockreportmaterialdeposit,
        centerid            TYPE string,
        project             TYPE string,
        schematics          TYPE string,
        pf                  TYPE string,
        materialid          TYPE string,
        materialdescription TYPE string,
        batchid             TYPE string,
        depositid           TYPE string,
        deposittotalstock   TYPE p LENGTH 16 DECIMALS 0,
      END OF ty_stockreportmaterialdeposit .
  types:
    tt_stockreportmaterialdeposit TYPE STANDARD TABLE OF ty_stockreportmaterialdeposit WITH DEFAULT KEY .
  types:
    BEGIN OF ty_stockreportmaterial,
        centerid                    TYPE string,
        project                     TYPE string,
        schematics                  TYPE string,
        pf                          TYPE string,
        materialid                  TYPE string,
        materialdescription         TYPE string,
        batchid                     TYPE string,
        project_display             TYPE string,
        schematics_display          TYPE string,
        unit                        TYPE string,
        stockreportmaterialdeposits TYPE tt_stockreportmaterialdeposit,
      END OF ty_stockreportmaterial .
  types:
    tt_stockreportmaterial TYPE STANDARD TABLE OF ty_stockreportmaterial WITH DEFAULT KEY .
  types:
    BEGIN OF ty_stockreportcenter,
        centerid             TYPE string,
        stockreportdeposits  TYPE tt_stockreportdeposit,
        stockreportmaterials TYPE tt_stockreportmaterial,
      END OF ty_stockreportcenter .
  types:
    tt_stockreportcenter TYPE STANDARD TABLE OF ty_stockreportcenter WITH DEFAULT KEY .
  types:
    BEGIN OF ty_operatoroee,
        id              TYPE string,
        workcenteroeeid TYPE string,
        operatorname    TYPE string,
      END OF ty_operatoroee .
  types:
    tt_operatoroee TYPE STANDARD TABLE OF ty_operatoroee WITH DEFAULT KEY .
  types:
    BEGIN OF ty_workcenteroee,
        id                          TYPE string,
        workcenterdescription       TYPE string,
        statusid                    TYPE string,
        statusdescription           TYPE string,
        statusstopdescription       TYPE string,
        productivity                TYPE string,
        availability                TYPE string,
        performance                 TYPE string,
        quality                     TYPE string,
        oee                         TYPE p LENGTH 16 DECIMALS 0,
        oeelowerlimit               TYPE p LENGTH 16 DECIMALS 0,
        oeeupperlimit               TYPE p LENGTH 16 DECIMALS 0,
        hierarchystatus             TYPE i,
        materialid                  TYPE string,
        statusdate                  TYPE string,
        stopreason                  TYPE string,
        stoptime                    TYPE p LENGTH 16 DECIMALS 0,
        qtytomake                   TYPE p LENGTH 16 DECIMALS 0,
        qtyproduced                 TYPE p LENGTH 16 DECIMALS 0,
        qtyscrap                    TYPE p LENGTH 16 DECIMALS 0,
        scrapperc                   TYPE string,
        qtydefectsinsheet           TYPE string,
        qtymissingwithscrap         TYPE p LENGTH 16 DECIMALS 0,
        shiftsremainingwithscrap    TYPE p LENGTH 16 DECIMALS 0,
        qtymissingwithoutscrap      TYPE p LENGTH 16 DECIMALS 0,
        shiftsremainingwithoutscrap TYPE p LENGTH 16 DECIMALS 0,
        hierarchyid                 TYPE string,
        productionorderid           TYPE string,
        operationid                 TYPE string,
        operatorsoee                TYPE tt_operatoroee,
      END OF ty_workcenteroee .
  types:
    tt_workcenteroee TYPE STANDARD TABLE OF ty_workcenteroee WITH DEFAULT KEY .
  types:
    BEGIN OF ty_operationconsumptiondevoc,
        productionorderid         TYPE string,
        materialid                TYPE string,
        operationconsumptiontype  TYPE string,
        batchid                   TYPE string,
        reservenumber             TYPE string,
        reserveitem               TYPE string,
        unitid                    TYPE string,
        characteristictext        TYPE string,
        characteristictype        TYPE string,
        characteristicdescription TYPE string,
        characteristicvalue       TYPE string,
        characteristicunit        TYPE string,
      END OF ty_operationconsumptiondevoc .
  types:
    tt_operationconsumptiondevoc TYPE STANDARD TABLE OF ty_operationconsumptiondevoc WITH DEFAULT KEY .
  types:
    BEGIN OF ty_operationconsumptiondevolu,
        productionorderid              TYPE string,
        materialid                     TYPE string,
        operationconsumptiontype       TYPE string,
        batchid                        TYPE string,
        reservenumber                  TYPE string,
        reserveitem                    TYPE string,
        unitid                         TYPE string,
        operationdescription           TYPE string,
        materialdescription            TYPE string,
        quantitynecessary              TYPE p LENGTH 16 DECIMALS 0,
        quantityconsumed               TYPE p LENGTH 16 DECIMALS 0,
        quantitytoconsumedisplay       TYPE string,
        quantitytoconsume              TYPE p LENGTH 16 DECIMALS 0,
        ilgort                         TYPE string,
        olgort                         TYPE string,
        iunit                          TYPE string,
        iunit_output                   TYPE string,
        ounit                          TYPE string,
        iorsnum                        TYPE string,
        oorsnum                        TYPE string,
        iorspos                        TYPE string,
        oorspos                        TYPE string,
        batchexpirationdate            TYPE string,
        displaymode                    TYPE string,
        action                         TYPE string,
        batchflag                      TYPE string,
        workcenterid                   TYPE string,
        operationid                    TYPE string,
        availablestock                 TYPE string,
        characteristicsupdatestring    TYPE string,
        characteristicvalid            TYPE abap_bool,
        characteristicvisible          TYPE abap_bool,
        devolutiondestinationwarehouse TYPE string,
        characteristics                TYPE tt_operationconsumptiondevoc,
      END OF ty_operationconsumptiondevolu .
  types:
    tt_operationconsumptiondevolu TYPE STANDARD TABLE OF ty_operationconsumptiondevolu WITH DEFAULT KEY .
  types:
    BEGIN OF ty_workcenterposition,
        id          TYPE string,
        name        TYPE string,
        description TYPE string,
      END OF ty_workcenterposition .
  types:
    tt_workcenterposition TYPE STANDARD TABLE OF ty_workcenterposition WITH DEFAULT KEY .
  types:
    BEGIN OF ty_shift,
        shiftid          TYPE string,
        shiftdescription TYPE string,
        active           TYPE abap_bool,
      END OF ty_shift .
  types:
    tt_shift TYPE STANDARD TABLE OF ty_shift WITH DEFAULT KEY .
  types:
    BEGIN OF ty_userarea,
        areaid          TYPE string,
        areadescription TYPE string,
        areatype        TYPE string,
      END OF ty_userarea .
  types:
    tt_userarea TYPE STANDARD TABLE OF ty_userarea WITH DEFAULT KEY .
  types:
    BEGIN OF ty_area,
        areaid TYPE string,
      END OF ty_area .
  types:
    tt_area TYPE STANDARD TABLE OF ty_area WITH DEFAULT KEY .
  types:
    BEGIN OF ty_authobjprofile,
        authobjectid TYPE string,
      END OF ty_authobjprofile .
  types:
    tt_authobjprofile TYPE STANDARD TABLE OF ty_authobjprofile WITH DEFAULT KEY .
  types:
    BEGIN OF ty_center,
        centerid          TYPE string,
        centerdescription TYPE string,
        defaultshift      TYPE string,
      END OF ty_center .
  types:
    tt_center TYPE STANDARD TABLE OF ty_center WITH DEFAULT KEY .
  types:
    BEGIN OF ty_additionaltime,
        ordernumber    TYPE string,
        workcenter     TYPE string,
        shiftid        TYPE string,
        operatorid     TYPE string,
        begintimestamp TYPE string,
        endtimestamp   TYPE string,
        quantity       TYPE string,
        unit           TYPE string,
      END OF ty_additionaltime .
  types:
    tt_additionaltime TYPE STANDARD TABLE OF ty_additionaltime WITH DEFAULT KEY .
  types:
    BEGIN OF ty_authorizationactivityofobje,
        authorizationprofileid      TYPE string,
        authorizationobjectid       TYPE string,
        authorizationactivitytypeid TYPE /iwbep/sb_odata_ty_int2,
        checked                     TYPE abap_bool,
      END OF ty_authorizationactivityofobje .
  types:
    tt_authorizationactivityofobje TYPE STANDARD TABLE OF ty_authorizationactivityofobje WITH DEFAULT KEY .
  types:
    BEGIN OF ty_authorizationobject,
        authorizationprofileid        TYPE string,
        authorizationobjectid         TYPE string,
        authorizationactivitiesofobje TYPE tt_authorizationactivityofobje,
      END OF ty_authorizationobject .
  types:
    tt_authorizationobject TYPE STANDARD TABLE OF ty_authorizationobject WITH DEFAULT KEY .
  types:
    BEGIN OF ty_authorizationprofile,
        authorizationprofileid         TYPE string,
        authorizationprofiledescriptio TYPE string,
        authorizationobjects           TYPE tt_authorizationobject,
        authprofile_authactofobject    TYPE tt_authorizationactivityofobje,
      END OF ty_authorizationprofile .
  types:
    tt_authorizationprofile TYPE STANDARD TABLE OF ty_authorizationprofile WITH DEFAULT KEY .
  types:
    BEGIN OF ty_authorizationprofilesofrole,
        authorizationroleid    TYPE string,
        authorizationprofileid TYPE string,
        authorizationprofile   TYPE ty_authorizationprofile,
      END OF ty_authorizationprofilesofrole .
  types:
    tt_authorizationprofilesofrole TYPE STANDARD TABLE OF ty_authorizationprofilesofrole WITH DEFAULT KEY .
  types:
    BEGIN OF ty_authorizationrole,
        authorizationroleid          TYPE string,
        authorizationroledescription TYPE string,
        authorizationprofilesofrole  TYPE tt_authorizationprofilesofrole,
      END OF ty_authorizationrole .
  types:
    tt_authorizationrole TYPE STANDARD TABLE OF ty_authorizationrole WITH DEFAULT KEY .
  types:
    BEGIN OF ty_treehierarchy,
        id          TYPE c LENGTH 128,
        parentid    TYPE c LENGTH 128,
        description TYPE string,
        objty       TYPE string,
        centerid    TYPE /iwbep/sb_odata_ty_int2,
        prdty       TYPE zabsf_pp_e_prdty,
      END OF ty_treehierarchy .
  types:
    tt_treehierarchy TYPE STANDARD TABLE OF ty_treehierarchy WITH DEFAULT KEY .
  types:
    BEGIN OF ty_userlanguage,
        languageid          TYPE string,
        languagedescription TYPE string,
      END OF ty_userlanguage .
  types:
    tt_userlanguage TYPE STANDARD TABLE OF ty_userlanguage WITH DEFAULT KEY .
  types:
    BEGIN OF ty_usersap,
        usersap  TYPE string,
        password TYPE string,
      END OF ty_usersap .
  types:
    tt_usersap TYPE STANDARD TABLE OF ty_usersap WITH DEFAULT KEY .
  types:
    BEGIN OF ty_token,
        access_token                   TYPE string,
        usersupplierid                 TYPE string,
        usererpid                      TYPE string,
        workcenters                    TYPE string,
        hierarchies                    TYPE string,
        language                       TYPE string,
        center                         TYPE string,
        authorizationactivityofobjects TYPE string,
        authorizationrolesofusers      TYPE string,
        expires_in                     TYPE /iwbep/sb_odata_ty_p_int64,
        userjsoninfo                   TYPE string,
        areatype                       TYPE string,
        actions                        TYPE string,
        client_id                      TYPE string,
        username                       TYPE string,
        name                           TYPE string,
        area                           TYPE string,
        role                           TYPE string,
        password                       TYPE string,
      END OF ty_token .
  types:
    tt_token TYPE STANDARD TABLE OF ty_token WITH DEFAULT KEY .
  types:
    BEGIN OF ty_user,
        validto             TYPE string,
        validfrom           TYPE string,
*        workcenters         TYPE string,
        userlanguage        TYPE string,
        userjsoninfo        TYPE string,
        usererpid           TYPE string,
        userdownloadfolder  TYPE string,
        userarea            TYPE string,
        name                TYPE string,
        hierarchies         TYPE string,
        center              TYPE string,
        useruploadfolder    TYPE string,
        usersupplierid      TYPE string,
        usersap             TYPE string,
        username            TYPE string,
        authorizationroleid TYPE string,
        roleid              TYPE string,
        roledescription     TYPE string,
        password            TYPE string,
        oldpassword         TYPE string,
        workcenters         TYPE zabsf_pp_tt_user_workcenters,
      END OF ty_user .
  types:
    tt_user TYPE STANDARD TABLE OF ty_user WITH DEFAULT KEY .
  types:
    BEGIN OF ty_param,
        value       TYPE flag,
        refreshtime TYPE string,
      END OF ty_param .
  types:
    tt_param TYPE STANDARD TABLE OF ty_param WITH DEFAULT KEY .
  types:
    BEGIN OF ty_operationequipment,
        areaid    TYPE string,
        prodorder TYPE string,
        operation TYPE string,
        equipment TYPE string,
      END OF ty_operationequipment .
  types:
    tt_operationequipment TYPE STANDARD TABLE OF ty_operationequipment WITH DEFAULT KEY .
  types:
    BEGIN OF ty_confirmedstock,
        material     TYPE string,
        operation    TYPE string,
        remainingqty TYPE i,
      END OF ty_confirmedstock .
  types:
    tt_confirmedstock TYPE STANDARD TABLE OF ty_confirmedstock WITH DEFAULT KEY .
  types:
    BEGIN OF ty_material,
        center       TYPE string,
        materialid   TYPE string,
        materialdesc TYPE string,
      END OF ty_material .
  types:
    tt_material TYPE STANDARD TABLE OF ty_material WITH DEFAULT KEY .
  types:
    BEGIN OF ty_dashboard1,
        refdt        TYPE datum,
        hierarchyid  TYPE cr_hname,
        workcenterid TYPE arbpl,
        oee          TYPE string,
        availability TYPE string,
        performance  TYPE string,
        quality      TYPE string,
        evolution    TYPE zabsf_pp_t_dashb_evolution,
      END OF ty_dashboard1 .
  types:
    tt_dashboard1 TYPE STANDARD TABLE OF ty_dashboard1 WITH DEFAULT KEY .
  types:
    BEGIN OF ty_dashboard2,
        refdt        TYPE string,
        hierarchyid  TYPE cr_hname,
        workcenterid TYPE arbpl,
        stops        TYPE zabsf_pp_t_dashb_stops,
        review       TYPE zabsf_pp_t_dashb_review,
        quality      TYPE zabsf_pp_t_dashb_qualities,
        performance  TYPE zabsf_pp_t_dashb_performance,
        losts        TYPE zabsf_pp_t_dashb_losts,
        availability TYPE zabsf_pp_t_dashb_availability,
      END OF ty_dashboard2 .
  types:
    tt_dashboard2 TYPE STANDARD TABLE OF ty_dashboard2 WITH DEFAULT KEY .
  types:
    BEGIN OF ty_dashboardcolors,
        begpercentage TYPE string,
        endpercentage TYPE string,
        color         TYPE string,
      END OF ty_dashboardcolors .
  types:
    tt_dashboardcolors TYPE STANDARD TABLE OF ty_dashboardcolors WITH DEFAULT KEY .

  class-methods CRE_AUTHORIZATIONACTIVITYOFOB
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods CRE_AUTHORIZATIONPROFILE
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods CRE_AUTHORIZATIONPROFILESOFRO
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods CRE_AUTHORIZATIONROLE
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods CRE_OPERATIONALERT
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER .
  class-methods CRE_OPERATIONOPERATOR
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods OLD_CRE_TOKEN
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods CRE_TOKEN
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods OLD_CRE_USER
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods CRE_USER
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods OLD_CRE_USERSAP
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods CRE_USERSAP
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods DEL_AUTHORIZATIONACTIVITY
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods DEL_AUTHORIZATIONACTIVITYOFOB
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods DEL_AUTHORIZATIONPROFILE
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods DEL_AUTHORIZATIONPROFILESOFRO
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods DEL_AUTHORIZATIONROLE
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods DEL_USER
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods DEL_USERSAP
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_ADMTREEHIERARCHY
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_ADMTREEHIERARCHYS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_AREAS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER .
  class-methods GET_AUTHOBJPROS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER .
  class-methods GET_AUTHORIZATIONACTIVITYOFOB
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_AUTHORIZATIONPROFILE
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_AUTHORIZATIONPROFILES
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_AUTHORIZATIONPROFILESOFRO
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_AUTHORIZATIONPROFILESOFROS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_AUTHORIZATIONROLE
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_AUTHORIZATIONROLES
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_CENTERS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_CONFIRMEDSTOCKS_AON
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER .
  class-methods GET_CONFIRMEDSTOCKS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER .
  class-methods GET_DASHBOARD1S
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_DASHBOARD2S
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_DASHBOARDCOLORS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_DEFECTS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER .
  class-methods GET_DEPOSITSAREAS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_DEPOSITSPLANTS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_DEPOSITSPOSITIONS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_EQUIPMENTS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER .
  class-methods GET_FORM
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_GETFORM
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_GETWORKCENTERS_1
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_GETWORKCENTERS_2
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_HIERARCHYS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER .
  class-methods GET_LABEL
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_MATERIALBATCHS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_MATERIALS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER .
  class-methods GET_MATERIALSERIALS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_MOVIMENTSLABEL
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_OPERATION
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_OPERATIONALERTS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER .
  class-methods GET_OPERATIONCONSUMPTION
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_OPERATIONCONSUMPTIONDEVOL
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_OPERATIONCONSUMPTIONHISTO
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_OPERATIONCONSUMPTIONHISTOS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_OPERATIONCONSUMPTIONS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_OPERATIONNUMBERS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_OPERATIONOPERATORS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_OPERATIONS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_OPERATIONSTOPREASONS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_ORDEROPERATIONS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_PARAMETERS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_PARAMS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER .
  class-methods GET_REPORTPOINTCOMPONENTS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_REPORTPOINTDEFECTS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_REPORTPOINTPASSAGE
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_REPORTPOINTS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_ROLES
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER .
  class-methods GET_RUNEXECS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER .
  class-methods GET_SHIFT
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_SHIFTS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_STOCKREPORTCENTERS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER .
  class-methods GET_STOPREASON
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_STOPREASONS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_SYSTEMINFOS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER .
  class-methods GET_TIMEREPORTCENTER
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ES_ENTITY type TY_TIMEREPORTCENTER
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER .
  class-methods GET_TREEHIERARCHYS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_USER
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_USERAREAS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_USERLANGUAGES
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_USERS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_USERSAP
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_USERSAPS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_WORKCENTER
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_WORKCENTEROEE
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_WORKCENTEROEES
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_WORKCENTEROPERATION
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_WORKCENTERPOSITION
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_WORKCENTERPOSITIONS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_WORKCENTERS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods GET_WORKCENTERSAREAS
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
    exporting
      !ER_ENTITY_SET type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER .
  class-methods UPD_ADDITIONALTIME
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods UPD_AUTHORIZATIONACTIVITYOFOB
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods UPD_OPERATION
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods UPD_OPERATIONALERT
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER .
  class-methods UPD_OPERATIONCONSUMPTION
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods UPD_OPERATIONEQUIPMENT
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER .
  class-methods UPD_OPERATIONOPERATOR
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods UPD_OPERATIONREWORK
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods UPD_REPORTPOINTGOODSMVT
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods UPD_REPORTPOINTOPERATION
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods UPD_REPORTPOINTPASSAGE
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods UPD_REPORTPOINTQUALITY
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods UPD_REPORTPOINTSETOPERATOR
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods UPD_SCRAPMISSING
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods UPD_SHIFT
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods OLD_UPD_USER
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods UPD_USER
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods OLD_UPD_USERSAP
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods UPD_USERSAP
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods UPD_WORKCENTER
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods UPD_WORKDAY
    importing
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IT_KEYS type /IWBEP/T_MGW_TECH_PAIRS
      !IV_JWT_TOKEN type STRING
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER
    exporting
      !ER_ENTITY type ref to DATA
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
protected section.
private section.
ENDCLASS.



CLASS ZABSF_CL_ODATA IMPLEMENTATION.


  METHOD cre_authorizationactivityofob.
    " Data Declarations
    DATA: ls_input_authactobj TYPE ty_authorizationactivityofobje,
          ls_authactobj       TYPE zsf_authactobj.

    " Read the input data
    io_data_provider->read_entry_data( IMPORTING es_data = ls_input_authactobj ).

    " Check if data already exists
    SELECT * FROM zsf_authactobj
        WHERE profileid EQ @ls_input_authactobj-authorizationprofileid
        AND objectid EQ @ls_input_authactobj-authorizationobjectid
        AND activitytypeid EQ @ls_input_authactobj-authorizationactivitytypeid
        INTO TABLE @DATA(lt_authobj).

    " If it does stop processing the request
    IF lt_authobj IS INITIAL.

      DATA(ls_authobj) = VALUE zsf_authobj( profileid = ls_input_authactobj-authorizationprofileid
                                            objectid = ls_input_authactobj-authorizationobjectid ).

      INSERT INTO zsf_authobj VALUES ls_authobj.

      " If it doesn't then add it to the table
      ls_authactobj-profileid = ls_input_authactobj-authorizationprofileid.
      ls_authactobj-objectid = ls_input_authactobj-authorizationobjectid.
      ls_authactobj-activitytypeid = ls_input_authactobj-authorizationactivitytypeid.
      ls_authactobj-checked = ls_input_authactobj-checked.
      INSERT INTO zsf_authactobj VALUES ls_authactobj.
      IF ( sy-subrc = 0 ).
* insert completed
        COMMIT WORK AND WAIT.
      ELSE.
        MESSAGE e002(z_sf_messages) INTO DATA(lv_msg).

        CALL METHOD co_msg->add_message_text_only
          EXPORTING
            iv_msg_type = 'E'
            iv_msg_text = CONV #( lv_msg ).

        " Raising Exception
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            message_container = co_msg.
      ENDIF.

    ELSE.
      MESSAGE e007(z_sf_messages) INTO lv_msg.

      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( lv_msg ).

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ENDIF.
    er_entity = lcl_utils=>copy_data_to_ref( ls_input_authactobj ).
  ENDMETHOD.


  METHOD cre_authorizationprofile.
    " Data Declarations
    DATA: ls_request  TYPE ty_authorizationprofile,
          ls_authprof TYPE zsf_authprof.

    " Read the input data
    io_data_provider->read_entry_data( IMPORTING es_data = ls_request ).

    " Check if data already exists
    SELECT * FROM zsf_authprof
        WHERE id EQ @ls_request-authorizationprofileid
        INTO TABLE @DATA(lt_authprof).

    " If it does stop processing the request
    IF lt_authprof IS NOT INITIAL.
      MESSAGE e005(z_sf_messages) INTO DATA(lv_msg).

      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( lv_msg ).

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ELSE.

      " Update structure data and insert it into the table
      ls_authprof-id = ls_request-authorizationprofileid.
      ls_authprof-description = ls_request-authorizationprofiledescriptio.

      INSERT INTO zsf_authprof VALUES ls_authprof.

      IF ( sy-subrc = 0 ).
* delete completed
        COMMIT WORK AND WAIT.
      ELSE.
        MESSAGE e002(z_sf_messages) INTO lv_msg.

        CALL METHOD co_msg->add_message_text_only
          EXPORTING
            iv_msg_type = 'E'
            iv_msg_text = CONV #( lv_msg ).

        " Raising Exception
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            message_container = co_msg.
      ENDIF.
    ENDIF.
    er_entity = lcl_utils=>copy_data_to_ref( ls_request ).
  ENDMETHOD.


  METHOD cre_authorizationprofilesofro.
    " Data Declarations
    DATA: ls_request      TYPE ty_authorizationprofilesofrole,
          ls_authprofrole TYPE zsf_authprofrole.

    " Read the input data
    io_data_provider->read_entry_data( IMPORTING es_data = ls_request ).

    " Check if data already exists
    SELECT * FROM zsf_authprofrole
        WHERE roleid EQ @ls_request-authorizationroleid
        AND profileid EQ @ls_request-authorizationprofileid
        INTO TABLE @DATA(lt_authprofrole).

    " If it does stop processing the request
    IF lt_authprofrole IS NOT INITIAL.
      MESSAGE e009(z_sf_messages) INTO DATA(lv_msg).

      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( lv_msg ).

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ELSE.

      " Update structure data and insert it into the table
      ls_authprofrole-roleid = ls_request-authorizationroleid.
      ls_authprofrole-profileid = ls_request-authorizationprofileid.

      INSERT INTO zsf_authprofrole VALUES ls_authprofrole.

      IF ( sy-subrc = 0 ).
* delete completed
        COMMIT WORK AND WAIT.
      ELSE.
        MESSAGE e002(z_sf_messages) INTO lv_msg.

        CALL METHOD co_msg->add_message_text_only
          EXPORTING
            iv_msg_type = 'E'
            iv_msg_text = CONV #( lv_msg ).

        " Raising Exception
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            message_container = co_msg.
      ENDIF.
    ENDIF.
*    DATA(ls_response) = VALUE ty_authorizationprofilesofrole( authorizationroleid = ls_request-authorizationroleid
*                                                              authorizationprofileid = ls_request-authorizationprofileid ).
*    er_entity = lcl_utils=>copy_data_to_ref( ls_response ).
    DATA(ls_response) = CORRESPONDING ZCL_Z_SF_ODATA_SERVICE_MPC_EXT=>TS_AUTHORIZATIONPROFILESOFROLE( ls_request ).
    er_entity = lcl_utils=>copy_data_to_ref( ls_response ).
  ENDMETHOD.


  METHOD cre_authorizationrole.
    " Data Declarations
    DATA: ls_request  TYPE ty_authorizationrole,
          ls_authrole TYPE zsf_authrole.

    " Read the input data
    io_data_provider->read_entry_data( IMPORTING es_data = ls_request ).

    " Check if data already exists
    SELECT *
      FROM zsf_authrole
        WHERE id EQ @ls_request-authorizationroleid
        INTO TABLE @DATA(lt_authrole).

    " If it does stop processing the request
    IF lt_authrole IS NOT INITIAL.
      MESSAGE e010(z_sf_messages) INTO DATA(lv_msg).

      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( lv_msg ).

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ELSE.

      " Update structure data and insert it into the table
      ls_authrole-id = ls_request-authorizationroleid.
      ls_authrole-description = ls_request-authorizationroledescription.

      INSERT INTO zsf_authrole VALUES ls_authrole.

      IF ( sy-subrc = 0 ).
* delete completed
        COMMIT WORK AND WAIT.
      ELSE.
        MESSAGE e002(z_sf_messages) INTO lv_msg.

        CALL METHOD co_msg->add_message_text_only
          EXPORTING
            iv_msg_type = 'E'
            iv_msg_text = CONV #( lv_msg ).

        " Raising Exception
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            message_container = co_msg.
      ENDIF.
    ENDIF.
    er_entity = lcl_utils=>copy_data_to_ref( ls_request ).
  ENDMETHOD.


  METHOD cre_operationalert.
    DATA: ls_input   TYPE ty_operationalert,
          ls_alerts  TYPE zabsf_pp_alerts,
          ls_results TYPE zabsf_pp_alerts,
          lv_msg     TYPE string.

    " Read input data
    io_data_provider->read_entry_data( IMPORTING es_data = ls_input ).

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input        = ls_input-materialid
      IMPORTING
        output       = ls_input-materialid
      EXCEPTIONS
        length_error = 1
        OTHERS       = 2.

    SELECT COUNT(*)
      FROM zabsf_pp_alerts
      WHERE matnr EQ @ls_input-materialid
      AND vornr EQ @ls_input-operation
      AND flag EQ @abap_true
      INTO @DATA(lv_count_active).

    IF lv_count_active > 0 AND ls_input-flag EQ abap_true.
      " exist active alert for material and operation.
      MESSAGE e166(zabsf_pp) WITH ls_input-materialid ls_input-operation INTO lv_msg.

      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( lv_msg ).

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ENDIF.

    IF ( lv_count_active EQ 0 AND ls_input-flag EQ abap_true ) OR ls_input-flag EQ abap_false.
      ls_alerts-matnr = ls_input-materialid.
      ls_alerts-vornr = ls_input-operation.

      SELECT MAX( alertid )
        FROM zabsf_pp_alerts
        WHERE matnr EQ @ls_input-materialid
        AND vornr EQ @ls_input-operation
        INTO @DATA(lv_alertid).

      ls_alerts-alertid = lv_alertid + 1.

      SELECT SINGLE maktx
        FROM makt
        WHERE matnr EQ @ls_input-materialid
        INTO @DATA(lv_maktx).

      ls_alerts-maktr = lv_maktx.
      ls_alerts-alerttitle = ls_input-alerttitle.
      ls_alerts-alertdesc = ls_input-alertdesc.
      ls_alerts-flag = ls_input-flag.
      ls_alerts-username = ls_input-username.
      ls_alerts-ltxa1 = ls_input-operationdesc.
      ls_alerts-areaid = is_inputobj-areaid.

      INSERT INTO zabsf_pp_alerts VALUES ls_alerts.

      IF ( sy-subrc = 0 ).
        " update completed
        COMMIT WORK AND WAIT.
      ELSE.
        MESSAGE e002(z_sf_messages) INTO lv_msg.

        CALL METHOD co_msg->add_message_text_only
          EXPORTING
            iv_msg_type = 'E'
            iv_msg_text = CONV #( lv_msg ).

        " Raising Exception
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            message_container = co_msg.
      ENDIF.
    ENDIF.

    er_entity = lcl_utils=>copy_data_to_ref( ls_input ).
  ENDMETHOD.


  METHOD cre_operationoperator.
    DATA: ls_operationoperator TYPE ty_operationoperator,
          lt_operator_tab      TYPE zabsf_pp_t_operador,
          lt_return_tab        TYPE bapiret2_t,
          lv_msg               TYPE string.


    "JPC - 20/10/2020
    DATA(lv_shiftid) = VALUE #( it_keys[ name = 'SHIFTID' ]-value OPTIONAL ).

    " Read input data
    io_data_provider->read_entry_data( IMPORTING es_data = ls_operationoperator ).

    DATA(lv_valid) = lcl_helper_token=>authenticate( EXPORTING iv_username = ls_operationoperator-operatorid
                                                               iv_password = ls_operationoperator-password ).

    IF lv_valid EQ abap_true.
      DATA(lt_workcenters) = VALUE zabsf_pp_tt_user_workcenters( FOR w IN zabsf_pp_cl_user=>get_userworkcenters( CONV #( ls_operationoperator-operatorid ) ) (
                                                            id = COND #( WHEN w-objty EQ 'A' THEN w-arbpl ELSE w-hname )
                                                            parentid    = COND #( WHEN w-objty EQ 'A' THEN w-hname ELSE '' )
                                                            description = w-ktext
                                                            objty       = w-objty ) ).

      IF NOT line_exists( lt_workcenters[ id = ls_operationoperator-workcenterid ] ).
        lv_msg = `Utilizador não está associado ao Centro de Trabalho.`.

        co_msg->add_message_text_only( EXPORTING iv_msg_type = 'E'
                                        iv_msg_text = CONV #( lv_msg ) ).

        " Raising Exception
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            message_container = co_msg.
      ENDIF.


      SELECT COUNT(*) FROM zsf_users INTO @DATA(lv_user_count) WHERE username EQ @ls_operationoperator-operatorid OR usererpid EQ @ls_operationoperator-operatorid.
      IF lv_user_count EQ 0.
        CALL METHOD co_msg->add_message_text_only
          EXPORTING
            iv_msg_type = 'E'
            iv_msg_text = CONV #( `OPERATOR DOES NOT EXIST` ).
        RETURN.
      ENDIF.

      lt_operator_tab = VALUE #( ( oprid = ls_operationoperator-operatorid status = ls_operationoperator-status ) ).

      "JPC - 13/10/2020
      DATA lref_sf_operator TYPE REF TO zif_absf_pp_operator.
      DATA: ld_class  TYPE recaimplclname,
            ld_method TYPE seocmpname.

*Get class of interface
      SELECT SINGLE imp_clname methodname
          FROM zabsf_pp003
          INTO (ld_class, ld_method)
         WHERE werks EQ is_inputobj-werks
           AND id_class EQ '11'
           AND endda GE sy-datum
           AND begda LE sy-datum.
      TRY .
          CREATE OBJECT lref_sf_operator TYPE (ld_class)
            EXPORTING
              initial_refdt = sy-datum
              input_object  = is_inputobj.
        CATCH cx_sy_create_object_error.
*    No data for object in customizing table
          CALL METHOD zabsf_pp_cl_log=>add_message
            EXPORTING
              msgty      = 'E'
              msgno      = '019'
              msgv1      = ld_class
            CHANGING
              return_tab = lt_return_tab.
          EXIT.
      ENDTRY.

      CALL METHOD lref_sf_operator->(ld_method)
        EXPORTING
          rpoint       = CONV zabsf_pp_e_rpoint( ls_operationoperator-workcenterid )
          time         = CONV atime( sy-uzeit )
          operator_tab = CONV zabsf_pp_t_operador( lt_operator_tab )
          shiftid      = CONV zabsf_pp_e_shiftid( lv_shiftid )
        CHANGING
          return_tab   = lt_return_tab.

      lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

      IF ls_operationoperator-operationrunning EQ abap_false.
        CALL FUNCTION 'ZABSF_PP_SETOPERATORS'
          EXPORTING
            arbpl        = CONV arbpl( ls_operationoperator-workcenterid )
            aufnr        = CONV aufnr( ls_operationoperator-productionorderid )
            vornr        = CONV vornr( ls_operationoperator-operationid )
            operator_tab = lt_operator_tab
            refdt        = sy-datum
            inputobj     = is_inputobj
            kapid        = CONV kapid( ls_operationoperator-workcenterpositionid )
          IMPORTING
            return_tab   = lt_return_tab.

        lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

      ELSE.

        CALL FUNCTION 'ZABSF_PP_SET_OPRID_AND_RESTART'
          EXPORTING
            arbpl        = CONV arbpl( ls_operationoperator-workcenterid )
            aufnr        = CONV aufnr( ls_operationoperator-productionorderid )
            vornr        = CONV vornr( ls_operationoperator-operationid )
            operator_tab = lt_operator_tab
            refdt        = sy-datum
            inputobj     = is_inputobj
            tipo         = 0
            date         = CONV datum( sy-datum )
            time         = CONV atime( sy-uzeit )
            rueck        = CONV co_rueck( ls_operationoperator-oinfo-rueck )
            aufpl        = CONV co_aufpl( ls_operationoperator-oinfo-aufpl )
            aplzl        = CONV co_aplzl( ls_operationoperator-oinfo-aplzl )
            kapid        = CONV kapid( ls_operationoperator-workcenterpositionid )
          IMPORTING
            return_tab   = lt_return_tab.

        lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).
      ENDIF.
    ELSE.
      MESSAGE e011(z_sf_messages) INTO lv_msg.

      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( lv_msg ).

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ENDIF.

    er_entity = lcl_utils=>copy_data_to_ref( ls_operationoperator ).
  ENDMETHOD.


  METHOD cre_token.
    DATA: ls_request_token TYPE ty_token,
          ls_token         TYPE ty_token,
          lv_msg           TYPE string.

    " Read input data
    io_data_provider->read_entry_data( IMPORTING es_data = ls_request_token ).

    " Hash input password
    DATA(lv_hashed_password) = zabsf_pp_cl_authentication=>new_get_hashed_password( EXPORTING iv_password = ls_request_token-password ).

    DATA(lv_username) = CONV string( to_upper( val = ls_request_token-username ) ).

    DATA(lv_valid) = lcl_helper_token=>authenticate( EXPORTING iv_username = ls_request_token-username
                                                               iv_password = ls_request_token-password ).

    IF lv_valid NE abap_true.
      MESSAGE e011(z_sf_messages) INTO lv_msg.

      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( lv_msg ).

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ENDIF.

    SELECT SINGLE a~username, a~name, a~usersap, b~description AS role,
          a~center, a~userlanguage, a~userarea,
          a~hierarchies, a~workcenters, a~userjsoninfo,
          a~usererpid, a~usersupplierid
      FROM zsf_users AS a
      LEFT OUTER JOIN zsf_roles AS b
      ON a~roleid EQ b~id
      INTO @DATA(ls_user)
      WHERE username EQ @ls_request_token-username.

*BEGIN: JOL - 05/01/2023: Get active workcenters for the user
    DATA(lt_workcenters) = VALUE zabsf_pp_tt_user_workcenters( FOR w IN zabsf_pp_cl_user=>get_userworkcenters( ls_user-username ) (
                                                                           id = COND #( WHEN w-objty EQ 'A' THEN w-arbpl ELSE w-hname )
                                                                           parentid    = COND #( WHEN w-objty EQ 'A' THEN w-hname ELSE '' )
                                                                           description = w-ktext
                                                                           objty       = w-objty ) ).

    DATA(lt_workcenters_string) = /ui2/cl_json=>serialize( data = lt_workcenters compress = abap_false pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).
*END: JOL - 05/01/2023

    ls_token = VALUE ty_token( expires_in = 86399
                               client_id = ``
                               username = ls_request_token-username
                               name = ls_user-name
                               area = ls_user-userarea
                               areatype = ``
                               role = ls_user-role
                               center = ls_user-center
                               language = ls_user-userlanguage
                               hierarchies = ls_user-hierarchies
                               workcenters = lt_workcenters_string
                               userjsoninfo = ls_user-userjsoninfo
                               usererpid = ls_user-usererpid
                               usersupplierid = ls_user-usersupplierid ).

    " Get actions/routes and serialize to json
    " [{"routename":"Launchpad","actionid":"ViewPermission","parentid":""}]
    zabsf_pp_cl_authentication=>get_actions(
      EXPORTING
        iv_username  = CONV zabsf_e_username( lv_username )
      IMPORTING
        ev_actions   = ls_token-actions
    ).

    " Get authorizationActivityOfObjects and serialize to json
    zabsf_pp_cl_authentication=>get_activityofobjects(
      EXPORTING
        iv_username  = CONV zabsf_e_username( lv_username )
      IMPORTING
        ev_authactobj = ls_token-authorizationactivityofobjects
    ).

    " Get authorization roles by user and serialize to json
    zabsf_pp_cl_authentication=>get_authorizationrolesuser(
      EXPORTING
        iv_username  = CONV zabsf_e_username( lv_username )
        iv_serializejson = 'X'
      IMPORTING
        ev_authroleuser  = ls_token-authorizationrolesofusers
    ).

    " Get JWT Token and write it as a cookie
    DATA(lv_jwt_token) = zabsf_pp_cl_authentication=>create_token(
      EXPORTING
        iv_username   = CONV #( ls_request_token-username )
        iv_name       = CONV string( ls_user-name )
        iv_role       = CONV string( ls_user-role )
        iv_center     = CONV string( ls_user-center )
        iv_area       = CONV string( ls_user-userarea )
        iv_language   = CONV string( ls_user-userlanguage )
        iv_usererpid  = CONV string( ls_user-usererpid ) ).

    zabsf_pp_cl_authentication=>new_set_token_cookie( EXPORTING iv_value = lv_jwt_token ).

    er_entity = lcl_utils=>copy_data_to_ref( ls_token ).
  ENDMETHOD.


METHOD cre_user.
  DATA: ls_request TYPE ty_user,
        lv_langu   TYPE spras,
        lv_msg     TYPE string.

  " Read input data
  io_data_provider->read_entry_data( IMPORTING es_data = ls_request ).

  " Check if user already exists
  SELECT COUNT(*)
    FROM zsf_users
    WHERE username = @ls_request-username.

  IF sy-subrc NE 0.
    MESSAGE e004(z_sf_messages) INTO lv_msg.

    co_msg->add_message_text_only( EXPORTING iv_msg_type = 'E'
                                             iv_msg_text = CONV #( lv_msg ) ).

    " Raising Exception
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
      EXPORTING
        message_container = co_msg.
  ENDIF.

  DATA(lv_validfrom) = cl_xlf_date_time=>parse( EXPORTING iso8601 = ls_request-validfrom ).
  DATA(lv_validto) = cl_xlf_date_time=>parse( EXPORTING iso8601 = ls_request-validto ).

  DATA(ls_user) = VALUE zsf_users( username = ls_request-username
                                    center = ls_request-center
                                    userarea = ls_request-userarea
                                    name = ls_request-name
                                    roleid = ls_request-roleid
                                    usersap = ls_request-usersap
                                    validfrom = lv_validfrom
                                    validto = lv_validto
                                    userdownloadfolder =  ls_request-userdownloadfolder
                                    useruploadfolder =  ls_request-useruploadfolder
                                    userjsoninfo =  ls_request-userjsoninfo
                                    usererpid =  ls_request-usererpid
                                    usersupplierid =  ls_request-usersupplierid ).

  " Check if the language is valid or default to english
  SELECT SINGLE spras
    FROM zabsf_pp061
    INTO lv_langu
    WHERE werks      EQ is_inputobj-werks
      AND is_default NE space
      AND spras EQ sy-langu.
  lv_langu = COND #( WHEN sy-subrc EQ 0 THEN lv_langu ELSE `EN` ).

  ls_user = VALUE #( BASE ls_user language = lv_langu
                                  userlanguage = lv_langu ).

  " increment ID
  DATA(ls_authorization) = VALUE zsf_auth( id = CONV zabsf_e_userid( |{ lcl_helper_user=>get_userid( ) }| )
                                           username = ls_request-username
                                           passwordhash = |{ zabsf_pp_cl_authentication=>new_get_hashed_password( ls_request-password ) }| ).

  DATA(ls_authroleuser) = VALUE zsf_authroleuser( username = ls_request-username
                                                  roleid = ls_request-authorizationroleid ).

  INSERT zsf_auth FROM ls_authorization.
  IF sy-subrc NE 0.
    MESSAGE e002(z_sf_messages) INTO lv_msg.
  ENDIF.

  INSERT zsf_users FROM ls_user.
  IF lv_msg IS INITIAL AND sy-subrc NE 0.
    MESSAGE e002(z_sf_messages) INTO lv_msg.
  ENDIF.

  INSERT zsf_authroleuser FROM ls_authroleuser.
  IF lv_msg IS INITIAL AND sy-subrc NE 0.
    MESSAGE e002(z_sf_messages) INTO lv_msg.
  ENDIF.

  IF lv_msg IS NOT INITIAL.
    ROLLBACK WORK.

    co_msg->add_message_text_only( EXPORTING iv_msg_type = 'E'
                                              iv_msg_text = CONV #( lv_msg ) ).

    " Raising Exception
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
      EXPORTING
        message_container = co_msg.
  ENDIF.

  COMMIT WORK AND WAIT.

  zabsf_pp_cl_user=>upd_userworkcenters(
    iv_username    = CONV #( ls_request-username )
    it_workcenters = ls_request-workcenters
  ).

  er_entity = lcl_utils=>copy_data_to_ref( ls_request ).
ENDMETHOD.


METHOD cre_usersap.
  " Data Declarations
  DATA: ls_request TYPE ty_usersap,
        ls_usersap TYPE zsf_userssap,
        lv_msg     TYPE string.

  " Read the input data
  io_data_provider->read_entry_data( IMPORTING es_data = ls_request ).

  SELECT COUNT(*)
    FROM zsf_userssap
    WHERE usersap = @ls_request-usersap.

  IF sy-subrc NE 0.
    MESSAGE e008(z_sf_messages) INTO lv_msg.

    CALL METHOD co_msg->add_message_text_only
      EXPORTING
        iv_msg_type = 'E'
        iv_msg_text = CONV #( lv_msg ).

    " Raising Exception
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
      EXPORTING
        message_container = co_msg.
  ENDIF.

  " Update structure data and insert it into the table
  ls_usersap = VALUE #( usersap = ls_request-usersap
                        password = |{ zabsf_pp_cl_authentication=>new_get_hashed_password( ls_request-password ) }| ).

  INSERT INTO zsf_userssap VALUES ls_usersap.
  IF sy-subrc NE 0.
    MESSAGE e002(z_sf_messages) INTO lv_msg.
  ENDIF.

  IF lv_msg IS NOT INITIAL.
    ROLLBACK WORK.

    co_msg->add_message_text_only( EXPORTING iv_msg_type = 'E'
                                             iv_msg_text = CONV #( lv_msg ) ).

    " Raising Exception
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
      EXPORTING
        message_container = co_msg.
  ENDIF.

  er_entity = lcl_utils=>copy_data_to_ref( ls_request ).
ENDMETHOD.


  METHOD del_authorizationactivity.
*    Get the property values
    READ TABLE it_keys INTO DATA(ls_profileid) WITH KEY name = 'AUTHORIZATIONPROFILEID'.
    READ TABLE it_keys INTO DATA(ls_objectid) WITH KEY name = 'AUTHORIZATIONOBJECTID'.
    READ TABLE it_keys INTO DATA(ls_activitytypeid) WITH KEY name = 'AUTHORIZATIONACTIVITYTYPEID'.

    "check if exist user Shopfloor with userSap
    SELECT SINGLE *
      FROM zsf_authactobj
      INTO @DATA(ls_authobj)
      WHERE profileid = @ls_profileid-value
      AND objectid = @ls_objectid-value
      AND activitytypeid = @ls_activitytypeid-value.

    IF ls_authobj IS NOT INITIAL.

      DELETE FROM zsf_authactobj WHERE profileid = ls_authobj-profileid AND objectid = ls_authobj-objectid AND activitytypeid = ls_authobj-activitytypeid.
      IF ( sy-subrc = 0 ).
* delete completed
        COMMIT WORK AND WAIT.
      ELSE.
        MESSAGE e002(z_sf_messages) INTO DATA(lv_msg).

        CALL METHOD co_msg->add_message_text_only
          EXPORTING
            iv_msg_type = 'E'
            iv_msg_text = CONV #( lv_msg ).

        " Raising Exception
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            message_container = co_msg.
      ENDIF.
    ELSE.
      MESSAGE e003(z_sf_messages) INTO lv_msg.

      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( lv_msg ).

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ENDIF.
  ENDMETHOD.


  METHOD DEL_AUTHORIZATIONACTIVITYOFOB.
*    Get the property values
    READ TABLE it_keys INTO DATA(ls_profileid) WITH KEY name = 'AUTHORIZATIONPROFILEID'.
    READ TABLE it_keys INTO DATA(ls_objectid) WITH KEY name = 'AUTHORIZATIONOBJECTID'.
    READ TABLE it_keys INTO DATA(ls_activitytypeid) WITH KEY name = 'AUTHORIZATIONACTIVITYTYPEID'.

    "check if exist user Shopfloor with userSap
    SELECT SINGLE *
      FROM zsf_authactobj
      INTO @DATA(ls_authobj)
      WHERE profileid = @ls_profileid-value
      AND objectid = @ls_objectid-value
      AND activitytypeid = @ls_activitytypeid-value.

    IF ls_authobj IS NOT INITIAL.

      DELETE FROM zsf_authobj WHERE profileid = ls_authobj-profileid AND objectid = ls_authobj-objectid.
      DELETE FROM zsf_authactobj WHERE profileid = ls_authobj-profileid AND objectid = ls_authobj-objectid AND activitytypeid = ls_authobj-activitytypeid.
      IF ( sy-subrc = 0 ).
* delete completed
        COMMIT WORK AND WAIT.
      ELSE.
        MESSAGE e002(z_sf_messages) INTO DATA(lv_msg).

        CALL METHOD co_msg->add_message_text_only
          EXPORTING
            iv_msg_type = 'E'
            iv_msg_text = CONV #( lv_msg ).

        " Raising Exception
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            message_container = co_msg.
      ENDIF.
    ELSE.
      MESSAGE e003(z_sf_messages) INTO lv_msg.

      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( lv_msg ).

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ENDIF.
  ENDMETHOD.


  METHOD del_authorizationprofile.
    " To get the AuthorizationProfileId
    READ TABLE it_keys INTO DATA(ls_authprofid) WITH KEY name = 'AUTHORIZATIONPROFILEID'.

* check if exist auhorization Profile
    SELECT SINGLE id
      FROM zsf_authprof
      INTO @DATA(lv_authprof)
      WHERE id = @ls_authprofid-value.

    IF lv_authprof IS NOT INITIAL.

      SELECT SINGLE profileid
        FROM zsf_authactobj
        WHERE profileid EQ @ls_authprofid-value
        INTO @DATA(lv_authactobj).

      IF lv_authactobj IS NOT INITIAL.
        DELETE FROM zsf_authactobj WHERE profileid = ls_authprofid-value.
        IF ( sy-subrc = 0 ).
          DELETE FROM zsf_authprof WHERE id = ls_authprofid-value.
          IF ( sy-subrc = 0 ).
* delete completed
            COMMIT WORK AND WAIT.
          ELSE.
            MESSAGE e002(z_sf_messages) INTO DATA(lv_msg).

            CALL METHOD co_msg->add_message_text_only
              EXPORTING
                iv_msg_type = 'E'
                iv_msg_text = CONV #( lv_msg ).

            " Raising Exception
            RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
              EXPORTING
                message_container = co_msg.
          ENDIF.
        ELSE.
          MESSAGE e002(z_sf_messages) INTO lv_msg.

          CALL METHOD co_msg->add_message_text_only
            EXPORTING
              iv_msg_type = 'E'
              iv_msg_text = CONV #( lv_msg ).

          " Raising Exception
          RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
            EXPORTING
              message_container = co_msg.
        ENDIF.
      ELSE.
        DELETE FROM zsf_authprof WHERE id = ls_authprofid-value.
        IF ( sy-subrc = 0 ).
* delete completed
          COMMIT WORK AND WAIT.
        ELSE.
          MESSAGE e002(z_sf_messages) INTO lv_msg.

          CALL METHOD co_msg->add_message_text_only
            EXPORTING
              iv_msg_type = 'E'
              iv_msg_text = CONV #( lv_msg ).

          " Raising Exception
          RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
            EXPORTING
              message_container = co_msg.
        ENDIF.
      ENDIF.
    ELSE.
      MESSAGE e003(z_sf_messages) INTO lv_msg.

      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( lv_msg ).

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ENDIF.
  ENDMETHOD.


  METHOD del_authorizationprofilesofro.
    READ TABLE it_keys INTO DATA(ls_authroleid) WITH KEY name = 'AUTHORIZATIONROLEID'.
    READ TABLE it_keys INTO DATA(ls_authprofid) WITH KEY name = 'AUTHORIZATIONPROFILEID'.

    SELECT SINGLE *
      FROM zsf_authprofrole
      WHERE profileid EQ @ls_authprofid-value
      AND roleid EQ @ls_authroleid-value
      INTO @DATA(ls_authprofrole).

    IF ls_authprofrole IS NOT INITIAL.

      DELETE FROM zsf_authprofrole WHERE profileid = ls_authprofrole-profileid AND roleid = ls_authprofrole-roleid.
      IF ( sy-subrc = 0 ).
* delete completed
        COMMIT WORK AND WAIT.
      ELSE.
        MESSAGE e002(z_sf_messages) INTO DATA(lv_msg).

        CALL METHOD co_msg->add_message_text_only
          EXPORTING
            iv_msg_type = 'E'
            iv_msg_text = CONV #( lv_msg ).

        " Raising Exception
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            message_container = co_msg.
      ENDIF.
    ELSE.
      MESSAGE e003(z_sf_messages) INTO lv_msg.

      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( lv_msg ).

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ENDIF.
  ENDMETHOD.


  METHOD del_authorizationrole.
    " To get the AuthotizationRoleId
    READ TABLE it_keys INTO DATA(ls_authroleid) WITH KEY name = 'AUTHORIZATIONROLEID'.

* check if exist auhorization Role
    SELECT SINGLE id
      FROM zsf_authrole
      INTO @DATA(lv_authrole)
      WHERE id = @ls_authroleid-value.

    IF lv_authrole IS NOT INITIAL.

      SELECT SINGLE *
        FROM zsf_authprofrole
        WHERE roleid EQ @lv_authrole
        INTO @DATA(ls_authprofrole).

      IF ls_authprofrole IS NOT INITIAL.

        DELETE FROM zsf_authprofrole WHERE roleid = ls_authprofrole-roleid.
        IF ( sy-subrc = 0 ).
          DELETE FROM zsf_authrole WHERE id = ls_authroleid-value.
          IF ( sy-subrc = 0 ).
* delete completed
            COMMIT WORK AND WAIT.
          ELSE.
            MESSAGE e002(z_sf_messages) INTO DATA(lv_msg).

            CALL METHOD co_msg->add_message_text_only
              EXPORTING
                iv_msg_type = 'E'
                iv_msg_text = CONV #( lv_msg ).

            " Raising Exception
            RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
              EXPORTING
                message_container = co_msg.
          ENDIF.
        ELSE.
          MESSAGE e002(z_sf_messages) INTO lv_msg.

          CALL METHOD co_msg->add_message_text_only
            EXPORTING
              iv_msg_type = 'E'
              iv_msg_text = CONV #( lv_msg ).

          " Raising Exception
          RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
            EXPORTING
              message_container = co_msg.
        ENDIF.
      ELSE.
        DELETE FROM zsf_authrole WHERE id = ls_authroleid-value.
        IF ( sy-subrc = 0 ).
* delete completed
          COMMIT WORK AND WAIT.
        ELSE.
          MESSAGE e002(z_sf_messages) INTO lv_msg.

          CALL METHOD co_msg->add_message_text_only
            EXPORTING
              iv_msg_type = 'E'
              iv_msg_text = CONV #( lv_msg ).

          " Raising Exception
          RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
            EXPORTING
              message_container = co_msg.
        ENDIF.
      ENDIF.
    ELSE.
      MESSAGE e003(z_sf_messages) INTO lv_msg.

      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( lv_msg ).

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ENDIF.
  ENDMETHOD.


  METHOD del_user.
    READ TABLE it_keys INTO DATA(ls_userid) WITH KEY name = 'USERNAME'.

    DELETE FROM zsf_users WHERE username = ls_userid-value.
    IF ( sy-subrc = 0 ).
      DELETE FROM zsf_auth WHERE username = ls_userid-value.
      IF ( sy-subrc = 0 ).
        DELETE FROM zsf_authroleuser WHERE username = ls_userid-value.
        IF ( sy-subrc = 0 ).
* delete completed
          COMMIT WORK AND WAIT.
          zabsf_pp_cl_user=>del_userworkcenters( CONV #( ls_userid-value ) ).
        ELSE.
          MESSAGE e002(z_sf_messages) INTO DATA(lv_msg).

          CALL METHOD co_msg->add_message_text_only
            EXPORTING
              iv_msg_type = 'E'
              iv_msg_text = CONV #( lv_msg ).

          " Raising Exception
          RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
            EXPORTING
              message_container = co_msg.
        ENDIF.
      ELSE.
        MESSAGE e002(z_sf_messages) INTO lv_msg.

        CALL METHOD co_msg->add_message_text_only
          EXPORTING
            iv_msg_type = 'E'
            iv_msg_text = CONV #( lv_msg ).

        " Raising Exception
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            message_container = co_msg.
      ENDIF.
    ELSE.
      MESSAGE e002(z_sf_messages) INTO lv_msg.

      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( lv_msg ).

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ENDIF.
  ENDMETHOD.


  METHOD del_usersap.
    READ TABLE it_keys INTO DATA(ls_userid) WITH KEY name = 'USERSAP'.

* check if exist user Shopfloor with userSap
    SELECT SINGLE usersap
      FROM zsf_users
      INTO @DATA(lv_usersap)
      WHERE usersap = @ls_userid-value.

    IF lv_usersap IS INITIAL.

      DELETE FROM zsf_userssap WHERE usersap = ls_userid-value.
      IF ( sy-subrc = 0 ).
* delete completed
        COMMIT WORK AND WAIT.
      ELSE.
        MESSAGE e002(z_sf_messages) INTO DATA(lv_msg).

        CALL METHOD co_msg->add_message_text_only
          EXPORTING
            iv_msg_type = 'E'
            iv_msg_text = CONV #( lv_msg ).

        " Raising Exception
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            message_container = co_msg.
      ENDIF.
    ELSE.
      MESSAGE e001(z_sf_messages) INTO lv_msg.

      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( lv_msg ).

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ENDIF.
  ENDMETHOD.


  METHOD GET_ADMTREEHIERARCHY.
    DATA: lt_return_tab              TYPE bapiret2_t,
          lt_hierarchies_and_workcts TYPE zabsf_pp_t_wrkctr,
          lt_treehierarchies         TYPE tt_treehierarchy.

    DATA(ls_inputobj) =
      VALUE zabsf_pp_s_inputobject(
        areaid = VALUE #( it_keys[ name = 'AREAID' ]-value OPTIONAL )
        werks  = VALUE #( it_keys[ name = 'CENTERID' ]-value OPTIONAL ) ).

    CALL FUNCTION 'ZABSF_ADM_GET_HIERARCHIES'
      EXPORTING
        inputobj                = ls_inputobj
        refdt                   = sy-datum
      IMPORTING
        hierarchies_and_workcts = lt_hierarchies_and_workcts
        return_tab              = lt_return_tab.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

    lt_treehierarchies =
      VALUE #( FOR ls_hierarchies_and_workcts IN lt_hierarchies_and_workcts (
        id          = ls_hierarchies_and_workcts-arbpl
        parentid    = ls_hierarchies_and_workcts-parent
        description = ls_hierarchies_and_workcts-ktext
        objty       = ls_hierarchies_and_workcts-objty
        prdty       = ls_hierarchies_and_workcts-prdty ) ).

    er_entity = lcl_utils=>copy_data_to_ref( lt_treehierarchies ).
  ENDMETHOD.


  METHOD get_admtreehierarchys.
    DATA: lt_return_tab              TYPE bapiret2_t,
          lt_hierarchies_and_workcts TYPE zabsf_pp_t_wrkctr,
          lt_treehierarchies         TYPE tt_treehierarchy.

    DATA(ls_inputobj) =
      VALUE zabsf_pp_s_inputobject(
        areaid = VALUE #( it_keys[ name = 'AREAID' ]-value OPTIONAL )
        werks  = VALUE #( it_keys[ name = 'CENTERID' ]-value OPTIONAL ) ).

    CALL FUNCTION 'ZABSF_ADM_GET_HIERARCHIES'
      EXPORTING
        inputobj                = ls_inputobj
        refdt                   = sy-datum
      IMPORTING
        hierarchies_and_workcts = lt_hierarchies_and_workcts
        return_tab              = lt_return_tab.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

    lt_treehierarchies =
      VALUE #( FOR ls_hierarchies_and_workcts IN lt_hierarchies_and_workcts (
        id          = ls_hierarchies_and_workcts-arbpl
        parentid    = ls_hierarchies_and_workcts-parent
        description = ls_hierarchies_and_workcts-ktext
        objty       = ls_hierarchies_and_workcts-objty
        prdty       = ls_hierarchies_and_workcts-prdty ) ).

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_treehierarchies ).
  ENDMETHOD.


  METHOD get_areas.
    DATA : lt_return TYPE bapiret2_t,
           ls_area   TYPE ty_area,
           lt_area   TYPE tt_area.

    SELECT areaid FROM zabsf_pp008
      INTO TABLE @DATA(lt_areas).

    LOOP AT lt_areas ASSIGNING FIELD-SYMBOL(<fs_areas>).
      CLEAR: ls_area.
      ls_area = VALUE ty_area( areaid = <fs_areas>-areaid ).

      APPEND ls_area TO lt_area.
    ENDLOOP.

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_area ).
  ENDMETHOD.


  METHOD GET_AUTHOBJPROS.
    DATA : lt_return         TYPE bapiret2_t,
           ls_authobjprofile TYPE ty_authobjprofile,
           lt_authobjprofile TYPE tt_authobjprofile.

    SELECT authobjectid
      FROM zabsf_authobjpro
      INTO TABLE @DATA(lt_authobjprofiles).

    LOOP AT lt_authobjprofiles ASSIGNING FIELD-SYMBOL(<fs_authobjprofiles>).
      CLEAR: ls_authobjprofile.
      ls_authobjprofile = VALUE ty_authobjprofile( authobjectid = <fs_authobjprofiles>-authobjectid ).

      APPEND ls_authobjprofile TO lt_authobjprofile.
    ENDLOOP.

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_authobjprofile ).
  ENDMETHOD.


  METHOD get_authorizationactivityofob.
    DATA ls_result TYPE ty_authorizationactivityofobje.

    READ TABLE it_keys INTO DATA(ls_profileid) WITH KEY name = 'AUTHORIZATIONPROFILEID'.
    READ TABLE it_keys INTO DATA(ls_objectid) WITH KEY name = 'AUTHORIZATIONOBJECTID'.
    READ TABLE it_keys INTO DATA(ls_activitytypeid) WITH KEY name = 'AUTHORIZATIONACTIVITYTYPEID'.

    SELECT SINGLE *
        FROM zsf_authactobj
        WHERE profileid EQ @ls_profileid-value
        AND objectid EQ @ls_objectid-value
        AND activitytypeid EQ @ls_activitytypeid-value
        INTO @DATA(ls_authactobj).

    ls_result = VALUE #( authorizationprofileid = ls_authactobj-profileid
                         authorizationobjectid = ls_authactobj-objectid
                         authorizationactivitytypeid = ls_authactobj-activitytypeid
                         checked = ls_authactobj-checked ).

    er_entity = lcl_utils=>copy_data_to_ref( ls_result ).
  ENDMETHOD.


  METHOD get_authorizationprofile.
*    DATA ls_result TYPE ty_authorizationprofile.
*
*    READ TABLE it_keys INTO DATA(ls_profileid) WITH KEY name = 'AUTHORIZATIONPROFILEID'.
*
*    SELECT SINGLE *
*      FROM zsf_authprof
*    WHERE id EQ @ls_profileid-value
*    INTO @DATA(ls_authprof).
*
*    ls_result = VALUE #( authorizationprofileid = ls_authprof-id authorizationprofiledescriptio = ls_authprof-description ).
*
*    DATA: lr_authobj TYPE REF TO data.
*    FIELD-SYMBOLS: <fs_authobj> TYPE ANY TABLE.
*
*    CREATE DATA lr_authobj TYPE ty_authorizationobject.
*
*    CALL METHOD ZABSF_CL_ODATA=>get_authorizationobjects
*      EXPORTING
*        is_inputobj   = is_inputobj
*        it_keys       = it_keys
*        iv_jwt_token  = iv_jwt_token
*      IMPORTING
*        er_entity_set = lr_authobj
*      CHANGING
*        co_msg = co_msg.
*
*    ASSIGN lr_authobj->* TO <fs_authobj>.
*
*    MOVE-CORRESPONDING <fs_authobj> TO ls_result-authorizationobjects.
*
*    LOOP AT ls_result-authorizationobjects INTO DATA(ls_res_authobj).
*      LOOP AT ls_res_authobj-authorizationactivitiesofobje INTO DATA(ls_res_authactobj).
*        APPEND VALUE #( authorizationprofileid = ls_res_authactobj-authorizationprofileid
*                        authorizationobjectid = ls_res_authactobj-authorizationobjectid
*                        authorizationactivitytypeid = ls_res_authactobj-authorizationactivitytypeid
*                        checked = ls_res_authactobj-checked ) TO ls_result-authprofile_authactofobject.
*      ENDLOOP.
*    ENDLOOP.
*
*    er_entity = lcl_utils=>copy_data_to_ref( ls_result ).

    DATA ls_result TYPE ty_authorizationprofile.

    READ TABLE it_keys INTO DATA(ls_profileid) WITH KEY name = 'AUTHORIZATIONPROFILEID'.

    SELECT SINGLE *
      FROM zsf_authprof
    WHERE id EQ @ls_profileid-value
    INTO @DATA(ls_authprof).

    ls_result = VALUE #( authorizationprofileid = ls_authprof-id authorizationprofiledescriptio = ls_authprof-description ).

*    DATA: lr_authobj TYPE REF TO data.
*    FIELD-SYMBOLS: <fs_authobj> TYPE ANY TABLE.

*    CREATE DATA lr_authobj TYPE ty_authorizationobject.

    CALL METHOD lcl_helper_authprofile=>get_authorizationobjects
      EXPORTING
        is_inputobj   = is_inputobj
        it_keys       = it_keys
        iv_jwt_token  = iv_jwt_token
      IMPORTING
*       er_entity_set = lr_authobj
        et_entity_set = ls_result-authorizationobjects.
*      CHANGING
*        co_msg = co_msg.

*    ASSIGN lr_authobj->* TO <fs_authobj>.

*    MOVE-CORRESPONDING <fs_authobj> TO ls_result-authorizationobjects.

    LOOP AT ls_result-authorizationobjects INTO DATA(ls_res_authobj).
      LOOP AT ls_res_authobj-authorizationactivitiesofobje INTO DATA(ls_res_authactobj).
        APPEND VALUE #( authorizationprofileid = ls_res_authactobj-authorizationprofileid
                        authorizationobjectid = ls_res_authactobj-authorizationobjectid
                        authorizationactivitytypeid = ls_res_authactobj-authorizationactivitytypeid
                        checked = ls_res_authactobj-checked ) TO ls_result-authprofile_authactofobject.
      ENDLOOP.
    ENDLOOP.

    er_entity = lcl_utils=>copy_data_to_ref( ls_result ).
  ENDMETHOD.


  METHOD get_authorizationprofiles.
    DATA lt_result TYPE tt_authorizationprofile.

    READ TABLE it_keys INTO DATA(ls_profileid) WITH KEY name = 'AUTHORIZATIONPROFILEID'.

    SELECT * FROM zsf_authprof
    WHERE id LIKE @ls_profileid-value
    OR id IS NOT NULL
    INTO TABLE @DATA(lt_authprof).

    lt_result = VALUE #( FOR ls_authprof IN lt_authprof ( authorizationprofileid = ls_authprof-id
                                                          authorizationprofiledescriptio = ls_authprof-description ) ).

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_result ).
  ENDMETHOD.


  METHOD get_authorizationprofilesofro.
    DATA ls_result TYPE ty_authorizationprofilesofrole.

    READ TABLE it_keys INTO DATA(ls_roleid) WITH KEY name = 'AUTHORIZATIONROLEID'.
    READ TABLE it_keys INTO DATA(ls_profileid) WITH KEY name = 'AUTHORIZATIONPROFILEID'.

    SELECT SINGLE *
      FROM zsf_authprofrole
      WHERE roleid EQ @ls_roleid-value
      AND profileid EQ @ls_profileid-value
      INTO @DATA(ls_authprofrole).

    ls_result = VALUE #( authorizationroleid = ls_authprofrole-roleid authorizationprofileid = ls_authprofrole-profileid ).

    er_entity = lcl_utils=>copy_data_to_ref( ls_result ).
  ENDMETHOD.


  METHOD get_authorizationprofilesofros.
    DATA lt_result TYPE tt_authorizationprofilesofrole.

    READ TABLE it_keys INTO DATA(ls_roleid) WITH KEY name = 'AUTHORIZATIONROLEID'.
    READ TABLE it_keys INTO DATA(ls_profileid) WITH KEY name = 'AUTHORIZATIONPROFILEID'.

    SELECT a~roleid, a~profileid, b~description AS descripprof, c~description AS descriprole
        FROM zsf_authprofrole AS a
          LEFT OUTER JOIN zsf_authprof AS b
            ON a~profileid  = b~id
          LEFT OUTER JOIN zsf_authrole AS c
            ON a~roleid = c~id
        WHERE a~roleid EQ @ls_roleid-value
        INTO TABLE @DATA(lt_authprofrole).

    IF ls_profileid-value IS NOT INITIAL.
      DELETE lt_authprofrole WHERE profileid NE ls_profileid-value.
    ENDIF.

    lt_result = VALUE #( FOR ls_authprofrole IN lt_authprofrole ( authorizationroleid = ls_authprofrole-roleid
                                                                  authorizationprofileid = ls_authprofrole-profileid ) ).

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_result ).
  ENDMETHOD.


  METHOD get_authorizationrole.
    DATA ls_result TYPE ty_authorizationrole.

    READ TABLE it_keys INTO DATA(ls_roleid) WITH KEY name = 'AUTHORIZATIONROLEID'.

    SELECT SINGLE *
        FROM zsf_authrole
      WHERE id EQ @ls_roleid-value
      INTO @DATA(ls_authrole).

    ls_result = VALUE #( authorizationroleid = ls_authrole-id authorizationroledescription = ls_authrole-description ).

    DATA: lr_authprofrole TYPE REF TO data.
    FIELD-SYMBOLS: <fs_authprofrole> TYPE ANY TABLE.

    CREATE DATA lr_authprofrole TYPE ty_authorizationobject.

    CALL METHOD zabsf_cl_odata=>get_authorizationprofilesofros
      EXPORTING
        is_inputobj   = is_inputobj
        it_keys       = it_keys
        iv_jwt_token  = iv_jwt_token
      IMPORTING
        er_entity_set = lr_authprofrole
      CHANGING
        co_msg        = co_msg.

    ASSIGN lr_authprofrole->* TO <fs_authprofrole>.

    MOVE-CORRESPONDING <fs_authprofrole> TO ls_result-authorizationprofilesofrole.

*    LOOP AT ls_result-authorizationobjects INTO DATA(ls_res_authprofrole).
*      LOOP AT ls_res_authprofrole-authorizationactivitiesofobje INTO DATA(ls_res_authactobj).
*        APPEND VALUE #( authorizationprofileid = ls_res_authactobj-authorizationprofileid
*                        authorizationobjectid = ls_res_authactobj-authorizationobjectid
*                        authorizationactivitytypeid = ls_res_authactobj-authorizationactivitytypeid
*                        checked = ls_res_authactobj-checked ) TO ls_result-authprofile_authactofobject.
*      ENDLOOP.
*    ENDLOOP.

    er_entity = lcl_utils=>copy_data_to_ref( ls_result ).
  ENDMETHOD.


  METHOD get_authorizationroles.
    DATA lt_result TYPE tt_authorizationrole.

    READ TABLE it_keys INTO DATA(ls_roleid) WITH KEY name = 'AUTHORIZATIONROLEID'.

    SELECT *
      FROM zsf_authrole
      INTO TABLE @DATA(lt_authrole).

    lt_result = VALUE #( FOR ls_authrole IN lt_authrole ( authorizationroleid = ls_authrole-id
                                                          authorizationroledescription = ls_authrole-description ) ).

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_result ).
  ENDMETHOD.


  METHOD get_centers.
    DATA : lt_return_tab TYPE bapiret2_t,
           lt_werks_tab  TYPE zabsf_pp_t_werks,
           lt_center     TYPE tt_center.

    CALL FUNCTION 'ZABSF_ADM_GETPLANTS'
      EXPORTING
        refdt      = sy-datum
        inputobj   = is_inputobj
      IMPORTING
        werks_tab  = lt_werks_tab
        return_tab = lt_return_tab.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

    lt_center = VALUE #( FOR ls_werks IN lt_werks_tab ( centerid = ls_werks-werks
                                                        centerdescription = ls_werks-name1
                                                        defaultshift = ls_werks-first_shift ) ).

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_center ).
  ENDMETHOD.


  METHOD get_confirmedstocks.
    TYPES:
      BEGIN OF lty_movement,
        aufnr TYPE aufnr,
        mgvrg TYPE mgvrg,
        lmnga TYPE lmnga,
        xmnga TYPE xmnga,
        werks TYPE werks_d,
        ltxa1 TYPE ltxa1,
        arbpl TYPE arbpl,
        name  TYPE char10,
        vornr TYPE vornr,
        steus TYPE steus,
        matnr TYPE co_matnr,
        fica  TYPE i,
        passa TYPE i,
      END OF lty_movement .
    TYPES:
      BEGIN OF lty_order,
        shiftid TYPE zabsf_pp_e_shiftid,
        hname   TYPE cr_hname,
        aufnr   TYPE aufnr,
        arbpl   TYPE arbpl,
      END OF lty_order .
    TYPES:
      BEGIN OF lty_confirmedstock,
        material     TYPE string,
        operation    TYPE string,
        ltxa1        TYPE string,
        remainingqty TYPE i,
      END OF lty_confirmedstock .

    DATA: lt_orders           TYPE STANDARD TABLE OF lty_order,
          lt_movements        TYPE SORTED TABLE OF lty_movement WITH NON-UNIQUE KEY primary_key COMPONENTS vornr aufnr matnr ltxa1,
          lt_unique_movements TYPE STANDARD TABLE OF lty_movement,
          lt_global           TYPE STANDARD TABLE OF lty_confirmedstock.

    " Set production orders istat filter
    DATA(lt_istat_filters) = VALUE string_table( ( CONV #( 'I0009' ) ) ( CONV #( 'I0045' ) ) ).

    " Get all hierarchies and the respective shift ids
    DATA: lt_workcenters     TYPE string_table,
          lt_active_orders   TYPE string_table,
          lt_inactive_orders TYPE string_table.
    " Get active orders
    lcl_helper_confirmedstocks=>get_active_orders( EXPORTING is_inputobj = is_inputobj
                                                   IMPORTING et_workcenters = lt_workcenters
                                                             et_orders = lt_active_orders ).
    lt_orders = VALUE #( BASE lt_orders FOR ls_active_order IN lt_active_orders ( aufnr = CONV aufnr( ls_active_order ) ) ).

    " Get inactive orders
    lcl_helper_confirmedstocks=>get_inactive_orders( EXPORTING is_inputobj = is_inputobj
                                                               it_workcenters = lt_workcenters
                                                     IMPORTING et_orders = lt_inactive_orders ).
    lt_orders = VALUE #( BASE lt_orders FOR ls_inactive_order IN lt_inactive_orders ( aufnr = CONV aufnr( ls_inactive_order ) ) ).

    " Remove duplicate orders
    sort lt_orders BY aufnr ASCENDING.
    DELETE ADJACENT DUPLICATES FROM lt_orders COMPARING aufnr.

    IF lines( lt_orders ) GT 0.
      " Get all movements
      SELECT b~aufnr, a~mgvrg, a~lmnga, a~xmnga, c~werks, c~ltxa1, e~arbpl, g~name, c~vornr, c~steus, d~matnr
          FROM afko AS b
          INNER JOIN afvv AS a ON a~aufpl EQ b~aufpl
          INNER JOIN afvc AS c ON c~aufpl EQ a~aufpl AND c~aplzl EQ a~aplzl
          INNER JOIN afpo AS d ON d~aufnr EQ b~aufnr
          INNER JOIN crhd AS e ON e~objid EQ c~arbid
          INNER JOIN crhs AS f ON f~objid_ho EQ c~arbid AND f~objid_up EQ ''
          INNER JOIN crhh AS g ON g~objid EQ f~objid_hy
          FOR ALL ENTRIES IN @lt_orders
          WHERE b~aufnr = @lt_orders-aufnr
        INTO CORRESPONDING FIELDS OF TABLE @lt_movements.

      " Added filtering support to delete matching steus
      DATA(lt_steus_filters) = VALUE string_table( ( CONV #( 'PP01' ) ) ).
      LOOP AT lt_steus_filters ASSIGNING FIELD-SYMBOL(<fs_steus_filter>).
        DELETE lt_movements WHERE steus = <fs_steus_filter>.
      ENDLOOP.

      LOOP AT lt_orders ASSIGNING FIELD-SYMBOL(<fs_order2>).
        " Get matching movements for desired order
        DATA(lt_filtered_movements) = FILTER #( lt_movements WHERE aufnr EQ <fs_order2>-aufnr AND vornr NE CONV vornr( `` ) ).

        " Calculate remaining stock
        FIELD-SYMBOLS <fs_prev_value> TYPE i.
        LOOP AT lt_filtered_movements ASSIGNING FIELD-SYMBOL(<fs_movement>).
          DATA lv_prev_value TYPE i.
          IF <fs_prev_value> IS NOT ASSIGNED.
            lv_prev_value = CONV i( <fs_movement>-mgvrg ).
            ASSIGN lv_prev_value TO <fs_prev_value>.
          ENDIF.
          <fs_movement>-fica = COND #( WHEN <fs_prev_value> IS ASSIGNED THEN <fs_prev_value> ELSE <fs_movement>-mgvrg ) - ( <fs_movement>-lmnga + <fs_movement>-xmnga ).
          <fs_movement>-fica = COND #( WHEN <fs_movement>-fica LT 0 THEN 0 ELSE <fs_movement>-fica ).
          <fs_movement>-passa = <fs_movement>-lmnga.

          lv_prev_value = CONV i( <fs_movement>-passa ).
          ASSIGN lv_prev_value TO <fs_prev_value>.
        ENDLOOP.
        UNASSIGN <fs_prev_value>.

        " Get unique movements
        lt_unique_movements = CORRESPONDING #( lt_filtered_movements MAPPING ltxa1 = ltxa1 ).
        SORT lt_unique_movements BY ltxa1 ASCENDING.
        DELETE ADJACENT DUPLICATES FROM lt_unique_movements COMPARING ltxa1.

        " Add remaining stock from the current order to the results table
        LOOP AT lt_unique_movements ASSIGNING FIELD-SYMBOL(<fs_unique_material_operation>).
          " Add the current order/material to the results table if it doesn't already exist
          IF NOT line_exists( lt_global[ material = <fs_unique_material_operation>-matnr operation = <fs_unique_material_operation>-name ] ).

            lt_global = VALUE #( BASE lt_global ( material = <fs_unique_material_operation>-matnr
                                                  operation = <fs_unique_material_operation>-name
                                                   ) ).
          ENDIF.

          " Sum the remaining stock
          lt_global[ material = <fs_unique_material_operation>-matnr operation = <fs_unique_material_operation>-name ]-remainingqty = REDUCE i(
                                      INIT val = lt_global[ material = <fs_unique_material_operation>-matnr operation = <fs_unique_material_operation>-name ]-remainingqty
                                      FOR wa IN
                                      FILTER #( lt_filtered_movements
                                                WHERE aufnr EQ <fs_order2>-aufnr
                                                AND vornr NE CONV vornr( `` )
                                                AND matnr EQ <fs_unique_material_operation>-matnr
                                                AND ltxa1 EQ <fs_unique_material_operation>-ltxa1 )
                                      NEXT val = val + wa-fica ).
        ENDLOOP.

      ENDLOOP.

      " Format the material field
      LOOP AT lt_global ASSIGNING FIELD-SYMBOL(<fs_global>).
        DATA lv_material TYPE string.
        CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
          EXPORTING
            input  = CONV matnr( <fs_global>-material )
          IMPORTING
            output = lv_material.
        <fs_global>-material = lv_material.
      ENDLOOP.
    ENDIF.

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_global ).
  ENDMETHOD.


  METHOD get_confirmedstocks_aon.
    DATA: lt_hierarchies TYPE lcl_helper_confirmedstocks2=>tt_hierarchy,
          lt_workcenters TYPE lcl_helper_confirmedstocks2=>tt_workcenter,
          lt_orders      TYPE lcl_helper_confirmedstocks2=>tt_order2,
          lt_movements   TYPE lcl_helper_confirmedstocks2=>tt_sorted_movements,
          lt_results     TYPE lcl_helper_confirmedstocks2=>tt_confirmedstocks.

    " Get the hierarchies
    lt_hierarchies = lcl_helper_confirmedstocks2=>get_hierarchies( EXPORTING iv_oprid  = is_inputobj-oprid
                                                                             iv_areaid = is_inputobj-areaid
                                                                             iv_werks  = is_inputobj-werks ).

    " Get the workcenters
    lt_workcenters = lcl_helper_confirmedstocks2=>get_workcenters( EXPORTING iv_oprid       = is_inputobj-oprid
                                                                             it_hierarchies = lt_hierarchies
                                                                             iv_werks       = is_inputobj-werks ).

    " Get the orders
    lt_orders = lcl_helper_confirmedstocks2=>get_orders( EXPORTING iv_areaid      = is_inputobj-areaid
                                                                   iv_werks       = is_inputobj-werks
                                                                   it_workcenters = lt_workcenters ).

    " Get the movements
    lt_movements = lcl_helper_confirmedstocks2=>get_movements( EXPORTING iv_werks  = is_inputobj-werks
                                                                         it_orders = lt_orders ).

    IF lt_movements IS NOT INITIAL.
      LOOP AT lt_orders ASSIGNING FIELD-SYMBOL(<fs_order>).
        " Get matching movements for desired order
        DATA lt_filtered_movements TYPE lcl_helper_confirmedstocks2=>tt_sorted_movements.
        lt_filtered_movements = FILTER #( lt_movements WHERE aufnr EQ <fs_order>-aufnr AND vornr NE CONV vornr( `` ) ).

        " Calculate the remaining stock
        lcl_helper_confirmedstocks2=>calculate_remaining_stock_alt( CHANGING ct_filtered_movements = lt_filtered_movements ).

        " Get unique movements
        DATA lt_unique_movements TYPE lcl_helper_confirmedstocks2=>tt_standard_movements.
        lt_unique_movements = CORRESPONDING #( lt_filtered_movements MAPPING ltxa1 = ltxa1 ).
        SORT lt_unique_movements BY ltxa1 ASCENDING.
        DELETE ADJACENT DUPLICATES FROM lt_unique_movements COMPARING ltxa1.

        lcl_helper_confirmedstocks2=>sum_and_group( EXPORTING it_unique_movements   = lt_unique_movements
                                                              it_filtered_movements = lt_filtered_movements
                                                              iv_aufnr              = <fs_order>-aufnr
                                                    CHANGING  ct_results            = lt_results ).
      ENDLOOP.

      " Format the material field
      Data lt_output TYPE lcl_helper_confirmedstocks2=>tt_confirmedstocks.
      LOOP AT lt_results ASSIGNING FIELD-SYMBOL(<fs_result>).
        DATA: lv_material TYPE string,
              ls_output TYPE lcl_helper_confirmedstocks2=>ty_confirmedstock.
        CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
          EXPORTING
            input  = CONV matnr( <fs_result>-material )
          IMPORTING
            output = lv_material.
*        <fs_result>-material = CONV #( lv_material ).
        ls_output = CORRESPONDING #( <fs_result> ).
        ls_output-material = CONV #( lv_material ).
        APPEND ls_output TO lt_output.
      ENDLOOP.
    ENDIF.

    "Martelo por causa do int16
    "lt_output = VALUE #( BASE ( lt_output ) FOR <fs_martelo> IN lt_output WHERE ( <fs_martelo>-remainingqty GE 32000 ) ( <fs_martelo>-remainingqty = 32000 ) ).
    LOOP AT lt_output ASSIGNING FIELD-SYMBOL(<fs_martelo>).
      IF <fs_martelo>-remainingqty GE 32000.
        <fs_martelo>-remainingqty = 32000.
      ENDIF.
    ENDLOOP.

*    er_entity_set = lcl_utils=>copy_data_to_ref( lt_results ).
    er_entity_set = lcl_utils=>copy_data_to_ref( lt_output ).
  ENDMETHOD.


  METHOD get_dashboard1s.
    DATA :
      lt_return     TYPE bapiret2_t,
      ls_dashboard1 TYPE ty_dashboard1.

    ls_dashboard1-refdt        = VALUE datum( it_keys[ name = 'REFDT' ]-value OPTIONAL ).
    ls_dashboard1-hierarchyid  = VALUE cr_hname( it_keys[ name = 'HIERARCHYID' ]-value OPTIONAL ).
    ls_dashboard1-workcenterid = VALUE arbpl( it_keys[ name = 'WORKCENTERID' ]-value OPTIONAL ).

    IF ls_dashboard1-refdt IS INITIAL.
      ls_dashboard1-refdt = sy-datum.
    ENDIF.

    CALL FUNCTION 'ZABSF_PP_GET_DASHBOARD1'
      EXPORTING
        iv_refdt        = ls_dashboard1-refdt
        iv_hname        = ls_dashboard1-hierarchyid
        iv_arbpl        = ls_dashboard1-workcenterid
        is_inputobj     = is_inputobj
      IMPORTING
        ev_oee          = ls_dashboard1-oee
        ev_availability = ls_dashboard1-availability
        ev_performance  = ls_dashboard1-performance
        ev_quality      = ls_dashboard1-quality
        et_evolution    = ls_dashboard1-evolution
        et_return       = lt_return.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return CHANGING co_msg = co_msg ).

    DATA(lt_dashboard1) = VALUE tt_dashboard1( ( ls_dashboard1 ) ).

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_dashboard1 ).
  ENDMETHOD.


  METHOD get_dashboard2s.
    DATA :
      lt_return     TYPE bapiret2_t,
      ls_dashboard2 TYPE ty_dashboard2.

    ls_dashboard2-hierarchyid  = VALUE cr_hname( it_keys[ name = 'HIERARCHYID' ]-value OPTIONAL ).
    ls_dashboard2-refdt        = VALUE datum( it_keys[ name = 'REFDT' ]-value OPTIONAL ).
    ls_dashboard2-workcenterid = VALUE arbpl( it_keys[ name = 'WORKCENTERID' ]-value OPTIONAL ).

    IF ls_dashboard2-refdt IS INITIAL OR ls_dashboard2-refdt EQ '00000000'.
      ls_dashboard2-refdt = sy-datum.
    ENDIF.

    DATA(lv_refdt) = CONV sy-datum( ls_dashboard2-refdt ).


    CALL FUNCTION 'ZABSF_PP_GET_DASHBOARD2'
      EXPORTING
        iv_refdt        = lv_refdt
        iv_hname        = ls_dashboard2-hierarchyid
        iv_arbpl        = ls_dashboard2-workcenterid
        is_inputobj     = is_inputobj
      IMPORTING
        et_availability = ls_dashboard2-availability
        et_losts        = ls_dashboard2-losts
        et_performance  = ls_dashboard2-performance
        et_quality      = ls_dashboard2-quality
        et_stops        = ls_dashboard2-stops
        et_review       = ls_dashboard2-review
        et_return       = lt_return.

    "adicionar
*    APPEND VALUE #( workcenterid = 'AVCDSDS'
*                    availability    = '65%'
*                    minutes = '159'
*                    goal = '75%'
*                    delta = 'ASDFG' ) TO ls_dashboard2-availability.
*
*    APPEND VALUE #( workcenterid = 'AVCDSDS'
*                    quality = '97,8%'
*                    goal = '99,0%'
*                    delta = 'ASDFG' ) TO ls_dashboard2-quality.
*
*    APPEND VALUE #( workcenterid = 'AVCDSDS'
*                    performance = '97,8%'
*                    goal = '99,0%'
*                    delta = 'ASDFG' ) TO ls_dashboard2-performance.
*
*    APPEND VALUE #( reason = 'Mudança de Trabalho'
*                    percentage = '40%' ) TO ls_dashboard2-stops.
*
*    APPEND VALUE #( reason = 'Falta Operador'
*                     percentage = '20%' ) TO ls_dashboard2-stops.
*
*    APPEND VALUE #( reason = 'Falta Afinador'
*                    percentage = '40%' ) TO ls_dashboard2-stops.
*
*    APPEND VALUE #( defect = 'Desvio de Medidas'
*                    percentage = '40%' ) TO ls_dashboard2-losts.
*
*    APPEND VALUE #( defect = 'Preparação'
*                    percentage = '40%' ) TO ls_dashboard2-losts.
*
*    APPEND VALUE #( defect = 'Superficie Danificada'
*                    percentage = '20%' ) TO ls_dashboard2-losts.
*
*    APPEND VALUE #( workcenterid = 'ABCDF'
*                    shiftid = 'T1'
*                    percentage = '20%' ) TO ls_dashboard2-review.
*
*    APPEND VALUE #( workcenterid = 'ABCDF'
*                    shiftid = 'T2'
*                    percentage = '50%' ) TO ls_dashboard2-review.
*
*    APPEND VALUE #( workcenterid = 'ABCDF'
*                    shiftid = 'T3'
*                    percentage = '70%' ) TO ls_dashboard2-review.
*
*    APPEND VALUE #( workcenterid = '17547'
*                    shiftid = 'T1'
*                    percentage = '70%' ) TO ls_dashboard2-review.
*
*    APPEND VALUE #( workcenterid = '17547'
*                    shiftid = 'T2'
*                    percentage = '50%' ) TO ls_dashboard2-review.
*
*    APPEND VALUE #( workcenterid = '17547'
*                    shiftid = 'T3'
*                    percentage = '40%' ) TO ls_dashboard2-review.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return CHANGING co_msg = co_msg ).

    DATA(lt_dashboard2) = VALUE tt_dashboard2( ( ls_dashboard2 ) ).

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_dashboard2 ).
  ENDMETHOD.


  METHOD get_dashboardcolors.
    DATA :
      lt_return          TYPE bapiret2_t,
      lt_dashboardcolors TYPE tt_dashboardcolors.

    SELECT begpr endpr clrpr
      FROM zabsf_pp093
      INTO TABLE lt_dashboardcolors.

    LOOP AT lt_dashboardcolors ASSIGNING FIELD-SYMBOL(<ls_color>).
      <ls_color>-color =
        SWITCH #( <ls_color>-color
                  WHEN 'R' THEN 'Error'
                  WHEN 'B' THEN 'Normal'
                  WHEN 'Y' THEN 'Critical'
                  WHEN 'G' THEN 'Good' ).
    ENDLOOP.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return CHANGING co_msg = co_msg ).

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_dashboardcolors ).
  ENDMETHOD.


  METHOD get_defects.
    DATA: lv_arbpl   TYPE arbpl,
          lt_defects TYPE tt_defect.

    READ TABLE it_keys INTO DATA(ls_workcenterid) WITH KEY name = 'WORKCENTERID'.

    lv_arbpl = CONV arbpl( ls_workcenterid-value ).

*    SELECT defectid AS id, defect_desc AS defectDescription
*      FROM zabsf_pp026_t
*      INTO TABLE @DATA(lt_results)
*      WHERE areaid = @is_inputobj-areaid
*            AND werks = @is_inputobj-werks
*            AND arbpl = @lv_arbpl
*            AND spras = @sy-langu.

    SELECT dft~defectid AS id, dft~defect_desc AS defectdescription
      FROM zabsf_pp026 AS df
      INNER JOIN zabsf_pp026_t AS dft
          ON df~areaid EQ dft~areaid
          AND df~werks EQ dft~werks
          AND df~arbpl EQ dft~arbpl
          AND df~defectid EQ dft~defectid
      WHERE df~areaid = @is_inputobj-areaid
            AND df~werks = @is_inputobj-werks
            AND df~arbpl = @lv_arbpl
            AND dft~spras = @sy-langu
      INTO TABLE @DATA(lt_results).

    lt_defects = VALUE #( FOR ls_result IN lt_results ( id = ls_result-id defectdescription = ls_result-defectdescription ) ).

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_defects ).
  ENDMETHOD.


  METHOD GET_DEPOSITSAREAS.
    DATA: lt_return       TYPE bapiret2_t,
          lt_depositsarea TYPE ZABSF_PP_T_DEPOSITSAREA.

    DATA(lv_area) = VALUE ZABSF_PP_E_AREAID( it_keys[ name = 'AREA' ]-value OPTIONAL ).

    CALL FUNCTION 'ZABSF_PP_GET_DEPOSITSAREA'
      EXPORTING
        iv_area         = lv_area
        is_inputobj     = is_inputobj
      IMPORTING
        et_depositsarea = lt_depositsarea
        et_return       = lt_return.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return CHANGING co_msg = co_msg ).

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_depositsarea ).
  ENDMETHOD.


  METHOD GET_DEPOSITSPLANTS.
    DATA: lt_return       TYPE bapiret2_t,
          lt_depositwerks TYPE zabsf_pp_t_depositswerks.

    DATA(lv_werks) = VALUE werks_d( it_keys[ name = 'WERKS' ]-value OPTIONAL ).

    SELECT werks, lgort, lgobe
       FROM t001l
       INTO TABLE @lt_depositwerks
        WHERE werks EQ @lv_werks.

    SORT lt_depositwerks BY lgort ASCENDING.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return CHANGING co_msg = co_msg ).

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_depositwerks ).

  ENDMETHOD.


  METHOD get_depositspositions.
    DATA: lt_deposit_positions TYPE tt_deposit_positions,
          ls_deposit_positions TYPE ty_deposit_positions,
          lt_depositsarea      TYPE zabsf_pp_t_depositsarea,
          lt_return            TYPE bapiret2_t.

    DATA: rg_lgort TYPE RANGE OF lgort_d.

    DATA(lv_area) = VALUE zabsf_pp_e_areaid( it_keys[ name = 'AREA' ]-value OPTIONAL ).
    DATA(lv_werks) = VALUE werks_d( it_keys[ name = 'PLANT' ]-value OPTIONAL ).
    DATA(lv_lgort) = VALUE lgort_d( it_keys[ name = 'LGORT' ]-value OPTIONAL ).

    CALL FUNCTION 'ZABSF_PP_GET_DEPOSITSAREA'
      EXPORTING
        iv_area         = lv_area
        is_inputobj     = is_inputobj
      IMPORTING
        et_depositsarea = lt_depositsarea
        et_return       = lt_return.

    IF lv_lgort IS NOT INITIAL.
      APPEND INITIAL LINE TO rg_lgort ASSIGNING FIELD-SYMBOL(<fs_lgort>).
      <fs_lgort>-sign = 'I'.
      <fs_lgort>-option = 'EQ'.
      <fs_lgort>-low = lv_lgort.
    ELSE.
      LOOP AT lt_depositsarea INTO DATA(ls_depositsarea).
        APPEND INITIAL LINE TO rg_lgort ASSIGNING <fs_lgort>.
        <fs_lgort>-sign = 'I'.
        <fs_lgort>-option = 'EQ'.
        <fs_lgort>-low = ls_depositsarea-werks.
      ENDLOOP.
    ENDIF.

    SELECT DISTINCT lgpbe, werks, lgort
      FROM mard
      INTO TABLE @DATA(lt_mard)
      WHERE werks EQ @lv_werks
        AND lgort IN @rg_lgort.

    LOOP AT lt_mard ASSIGNING FIELD-SYMBOL(<fs_mard>).
      CLEAR: ls_deposit_positions.
      ls_deposit_positions = VALUE ty_deposit_positions( plant = <fs_mard>-werks
                                                         lgort = <fs_mard>-lgort
                                                         lgpbe = <fs_mard>-lgpbe ).

      APPEND ls_deposit_positions TO lt_deposit_positions.
    ENDLOOP.

    SORT lt_deposit_positions BY lgpbe ASCENDING.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return CHANGING co_msg = co_msg ).

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_deposit_positions ).
  ENDMETHOD.


  METHOD get_equipments.
    DATA lt_result TYPE tt_equipment.

    READ TABLE it_keys INTO DATA(ls_workcenter) WITH KEY name = 'WORKCENTERID'.

    SELECT * FROM zabsf_equipments
      INTO TABLE @DATA(lt_equipments)
      WHERE workcenterid EQ @ls_workcenter-value.

    lt_result = VALUE #( FOR ls_equipment IN lt_equipments ( areaid = ls_equipment-areaid
                                                             workcenterid = ls_equipment-workcenterid
                                                             equipmentid = ls_equipment-equipment ) ).

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_result ).
  ENDMETHOD.


  METHOD get_form.
    DATA: lv_msg            TYPE string,
          " Keys
          lv_materialid     TYPE string,
          lv_operationid    TYPE string,

          " Directories
          lv_directory_path TYPE epsf-epsdirnam,
          lt_directory_list TYPE STANDARD TABLE OF epsfili,
          lv_filename       TYPE string,

          " File
          lv_content        TYPE rcf_attachment_content,
          lt_binary_content TYPE sdokcntbins,
          lv_hex_container  TYPE xstring.

    lv_materialid = VALUE #( it_keys[ name = 'MATERIALID' ]-value OPTIONAL ).
    lv_operationid = VALUE #( it_keys[ name = 'OPERATIONID' ]-value OPTIONAL ).

    IF ( strlen( condense( val = lv_materialid from = `` ) ) EQ 0 )
    OR ( strlen( condense( val = lv_operationid from = `` ) ) EQ 0 ).
      lv_msg = `Empty keys are not allowed.`.

      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( lv_msg ).

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ENDIF.

    zcl_bc_fixed_values=>get_single_value( EXPORTING
                                          im_paramter_var = zcl_bc_fixed_values=>gc_default_pdf_directory
                                          im_modulesp_var = zcl_bc_fixed_values=>gc_productn_cst
                                        IMPORTING
                                          ex_prmvalue_var = DATA(lv_default_path) ).

    " Check if the parent directory exists
    CALL FUNCTION 'PFL_CHECK_DIRECTORY'
      EXPORTING
        directory = CONV btch0000-text80( lv_default_path )
      EXCEPTIONS
        OTHERS    = 6.
    IF sy-subrc NE 0.
      lv_msg = `Unable to read parent directory`.

      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( lv_msg ).

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ENDIF.

    " Check if the file directory exists
    lv_directory_path = |{ lv_default_path }/{ lv_materialid  }/{ lv_operationid }|.

    CALL FUNCTION 'EPS_GET_DIRECTORY_LISTING'
      EXPORTING
        dir_name               = lv_directory_path
      TABLES
        dir_list               = lt_directory_list
      EXCEPTIONS
        invalid_eps_subdir     = 1
        sapgparam_failed       = 1
        build_directory_failed = 1
        no_authorization       = 1
        read_directory_failed  = 1
        too_many_read_errors   = 1
        empty_directory_list   = 2
        OTHERS                 = 1.
    IF sy-subrc EQ 1.
      lv_msg = `Unable to read directory`.

      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( lv_msg ).

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ELSEIF sy-subrc EQ 2.
      lv_msg = `The directory is empty`.

      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( lv_msg ).

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ENDIF.

    " Get the file, read it, convert it and return it to the user
    lv_filename = |{ lv_directory_path }/{ lt_directory_list[ 1 ]-name }|.

    OPEN DATASET lv_filename FOR INPUT IN BINARY MODE.
    DO.
      READ DATASET lv_filename INTO lv_hex_container MAXIMUM LENGTH 1000.
      IF sy-subrc NE 0.
        EXIT.
      ELSE.
        CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
          EXPORTING
            buffer          = lv_hex_container
            append_to_table = 'X'
          TABLES
            binary_tab      = lt_binary_content.

      ENDIF.
    ENDDO.
    CLOSE DATASET lv_filename.

    CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
      EXPORTING
        input_length = 1000000000
      IMPORTING
        buffer       = lv_content
      TABLES
        binary_tab   = lt_binary_content
      EXCEPTIONS
        OTHERS       = 4.

    DATA: ls_stream TYPE /iwbep/if_mgw_appl_types=>ty_s_media_resource,
          ls_form   TYPE ty_form.
    ls_stream-value = lv_content.
    ls_stream-mime_type = 'application/pdf'.

    ls_form = VALUE ty_form( materialid = lv_materialid
                             operationid = lv_operationid
                             mime_type = 'application/pdf'
                             value    = cl_http_utility=>encode_x_base64( unencoded = lv_content ) ).

    er_entity = lcl_utils=>copy_data_to_ref( ls_form ).

*    er_stream = lcl_utils=>copy_data_to_ref( ls_stream ).
  ENDMETHOD.


  METHOD get_getform.
    DATA: lv_msg            TYPE string,
          " Keys
          lv_materialid     TYPE string,
          lv_operationid    TYPE string,

          " Directories
          lv_directory_path TYPE epsf-epsdirnam,
          lt_directory_list TYPE STANDARD TABLE OF epsfili,
          lv_filename       TYPE string,

          " File
          lv_content        TYPE rcf_attachment_content,
          lt_binary_content TYPE sdokcntbins,
          lv_hex_container  TYPE xstring.

    lv_materialid = VALUE #( it_keys[ name = 'MATERIALID' ]-value OPTIONAL ).
    lv_operationid = VALUE #( it_keys[ name = 'OPERATIONID' ]-value OPTIONAL ).

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input  = lv_materialid
      IMPORTING
        output = lv_materialid.

    IF ( strlen( condense( val = lv_materialid from = `` ) ) EQ 0 )
    OR ( strlen( condense( val = lv_operationid from = `` ) ) EQ 0 ).
      lv_msg = `Empty keys are not allowed.`.

      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( lv_msg ).

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ENDIF.

    " Get the file, read it, convert it and return it to the user
    lv_filename = `/leica/share/Eurotext/C_CORRISPETTIVI_BO_20180417_130344.pdf`.

    OPEN DATASET lv_filename FOR INPUT IN BINARY MODE.
    DO.
      READ DATASET lv_filename INTO lv_hex_container MAXIMUM LENGTH 1000.
      IF sy-subrc NE 0.
        EXIT.
      ELSE.
        CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
          EXPORTING
            buffer          = lv_hex_container
            append_to_table = 'X'
          TABLES
            binary_tab      = lt_binary_content.

      ENDIF.
    ENDDO.
    CLOSE DATASET lv_filename.

    CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
      EXPORTING
        input_length = 1000000000
      IMPORTING
        buffer       = lv_content
      TABLES
        binary_tab   = lt_binary_content
      EXCEPTIONS
        OTHERS       = 4.

    DATA: ls_stream TYPE /iwbep/if_mgw_appl_types=>ty_s_media_resource,
          ls_form   TYPE ty_form.
    ls_stream-value = lv_content.
    ls_stream-mime_type = 'application/pdf'.


    ls_form = VALUE ty_form(
    materialid = lv_materialid
                             operationid = lv_operationid
                             mime_type = 'application/pdf'
                             value    = 'aa' ).
*                              value    = cl_http_utility=>encode_x_base64( unencoded = lv_content ) ).

    er_entity = lcl_utils=>copy_data_to_ref( ls_form ).

*    er_stream = lcl_utils=>copy_data_to_ref( ls_stream ).
  ENDMETHOD.


  METHOD get_getworkcenters_1.
    DATA: lt_return_tab         TYPE bapiret2_t,
          ls_wrkctr_detail      TYPE zabsf_pp_s_wrkctr_detail,
          ls_production         TYPE zabsf_pp_s_prdord_detail,
          lv_endda              TYPE iwexfdate VALUE '00000000',
          lv_datesr             TYPE zabsf_pp_e_date,
          lv_workcenterid       TYPE arbpl,
          lv_langu              TYPE spras,
          "Pai
          ls_workcenter         TYPE ty_workcenter,
          lt_workcenter         TYPE tt_workcenter,
          "Filhos
          ls_operator           TYPE ty_operator,
          ls_productionorderobj TYPE ty_productionorder,
          ls_operationobj       TYPE ty_operation,
          ls_scrapmissing       TYPE ty_scrapmissing,
          ls_missingpart        TYPE ty_missingpart,
          ls_multimaterial      TYPE ty_multimaterial,
          ls_operationoperator  TYPE ty_operationoperator,
          lt_reason_tab         TYPE zabsf_pp_t_reason.

    READ TABLE it_keys INTO DATA(ls_shiftid) WITH KEY name = 'SHIFTID'.
    READ TABLE it_keys INTO DATA(ls_hierarchyid) WITH KEY name = 'HIERARCHYID'.
    READ TABLE it_keys INTO DATA(ls_workcenterid) WITH KEY name = 'WORKCENTERID'.
    READ TABLE it_keys INTO DATA(ls_operationid) WITH KEY name = 'OPERATIONID'.
    READ TABLE it_keys INTO DATA(ls_productionorderid) WITH KEY name = 'PRODUCTIONORDERID'.
    READ TABLE it_keys INTO DATA(ls_currenttime) WITH KEY name = 'CURRENTTIME'.
    READ TABLE it_keys INTO DATA(ls_currentday) WITH KEY name = 'CURRENTDAY'.
    READ TABLE it_keys INTO DATA(ls_headeronly) WITH KEY name = 'HEADERONLY'.

    CALL FUNCTION 'ZABSF_PP_GETWRKCENTER_DETAIL'
      EXPORTING
        areadid       = is_inputobj-areaid
        werks         = is_inputobj-werks
        hname         = CONV cr_hname( ls_hierarchyid-value )
        arbpl         = CONV arbpl( ls_workcenterid-value )
        refdt         = sy-datum
        inputobj      = is_inputobj
        aufnr         = CONV aufnr( ls_productionorderid-value )
        vornr         = CONV vornr( ls_operationid-value )
      IMPORTING
        wrkctr_detail = ls_wrkctr_detail
        return_tab    = lt_return_tab.

* Start Change ABACO(AON): 20.12.2022
    " Description: Only show certain control keys
    DATA(lt_control_keys) = VALUE string_table( ( `ZLP1` ) ( `ZLP3` ) ( `ZLPM` ) ).
* End Change ABACO(AON): 20.12.2022

***** BEGIN JOL - 07/12/2022 - get language - SPRAS field
    " Set language local for user
    lv_langu = sy-langu.

    IF lv_langu EQ ''.
      " Get alternative language
      SELECT SINGLE spras
        FROM zabsf_pp061
        INTO lv_langu
       WHERE werks      EQ is_inputobj-werks
         AND is_default NE space.
    ENDIF.
***** END JOL.

    ls_workcenter-id = ls_wrkctr_detail-arbpl.
    ls_workcenter-statusid = ls_wrkctr_detail-status.
    ls_workcenter-statusdescription = ls_wrkctr_detail-status_desc.
    ls_workcenter-workcenterdescription = ls_wrkctr_detail-ktext.

    ls_workcenter-showscraplist = COND #( WHEN ls_wrkctr_detail-flag_scrap_list EQ 'X'
                                          THEN abap_true
                                          ELSE abap_false ).
    ls_workcenter-checklistonly = COND #( WHEN ls_wrkctr_detail-checklist EQ 'X'
                                          THEN abap_true
                                          ELSE abap_false ).
    ls_workcenter-maintenanceorderid = ls_wrkctr_detail-pm_order.
    ls_workcenter-maintenancestageid = ls_wrkctr_detail-checklist_step.
    ls_workcenter-worktype = ls_wrkctr_detail-tip_trab.
    ls_workcenter-workcentertype = ls_wrkctr_detail-arbpl_type.

***** BEGIN ADR - 07/10/2022 - Add description stop workcenter
* add description stop workcenter when status id eq '0003' - STOP
    IF ls_workcenter-statusid EQ '0003'.

      REPLACE ALL OCCURRENCES OF '-' IN ls_currentday-value WITH ''.
      lv_datesr = ls_currentday-value.
      lv_workcenterid = ls_workcenterid-value.

      SELECT SINGLE stoptext~stprsn_desc
        FROM  zabsf_pp010 AS regstop
        INNER JOIN zabsf_pp011_t   AS stoptext
            ON stoptext~werks EQ regstop~werks AND stoptext~stprsnid EQ regstop~stprsnid
            AND stoptext~areaid EQ regstop~areaid AND stoptext~arbpl EQ regstop~arbpl
        WHERE regstop~arbpl EQ @lv_workcenterid
          AND regstop~werks EQ @is_inputobj-werks
          AND regstop~areaid EQ @is_inputobj-areaid
          AND regstop~endda  EQ @lv_endda
          AND stoptext~spras EQ @lv_langu
        INTO @DATA(statusstopdescription).
      IF sy-subrc = 0.
        ls_workcenter-statusstopdescription = statusstopdescription.
      ENDIF.
    ENDIF.
***** END ADR.

    LOOP AT ls_wrkctr_detail-oper_wrkctr_tab INTO DATA(ls_operatorobj).
      CLEAR ls_operator.
      ls_operator-id = ls_operatorobj-oprid.
      ls_operator-workcenterid = ls_wrkctr_detail-arbpl.
      ls_operator-operatorname = ls_operatorobj-nome.
      APPEND ls_operator TO ls_workcenter-availableoperators.
    ENDLOOP.

    LOOP AT ls_wrkctr_detail-prord_tab INTO DATA(ls_productionobj) WHERE status EQ 'INI' OR status EQ 'AGU'.
      CLEAR ls_productionorderobj.
      ls_productionorderobj-id = ls_productionobj-aufnr.
      ls_productionorderobj-workcenterid = ls_productionobj-arbpl.
      ls_productionorderobj-productionorderdescription = ls_productionobj-aufnr.
*      ls_productionorderobj-materialid = ls_productionobj-matnr.

      CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
        EXPORTING
          input  = ls_productionobj-matnr
        IMPORTING
          output = ls_productionorderobj-materialid.

      ls_productionorderobj-materialdescription = ls_productionobj-maktx.
      ls_productionorderobj-typeid = ls_productionobj-tipord.
      ls_productionorderobj-productionordertype = ls_productionobj-auart.
      "ls_productionorderobj-steus = ls_productionobj-steus.

      CLEAR ls_operationobj.
* Start Change ABACO(AON): 20.12.2022
* Description: Only show certain control keys
      ls_operationobj-steus = COND #( WHEN line_exists( lt_control_keys[ table_line = ls_productionobj-steus ] )
                                      THEN ls_productionobj-steus ).
* End Change ABACO(AON): 20.12.2022
      ls_operationobj-id = ls_productionobj-vornr.
      ls_operationobj-productionorderid = ls_productionobj-aufnr.
      ls_operationobj-workcenterid = ls_productionobj-arbpl.
      ls_operationobj-operationdescription = ls_productionobj-ltxa1.
*      ls_operationobj-materialid = CONV matn1( ls_productionobj-matnr ).
      CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
        EXPORTING
          input  = ls_productionobj-matnr
        IMPORTING
          output = ls_operationobj-materialid.
      ls_operationobj-materialdescription = ls_productionobj-maktx.
      ls_operationobj-programeddate = |{ ls_productionobj-gstrs DATE = ISO } { substring( val = ls_productionobj-gsuzs len = 2 ) && `:` && substring( val = ls_productionobj-gsuzs off = 2 len = 2 ) }|.
      "TODO: Verificar "{ ls_productionobj-gsuzs TIME = ISO }|.
      "TODO: Verificar
      ls_operationobj-statusid = ls_productionobj-status_oper.
      ls_operationobj-boxbundle = ls_productionobj-prdqty_box.
      ls_operationobj-bundlevalue = ls_productionobj-boxqty.
      ls_operationobj-quantitymade = ls_productionobj-lmnga.
      ls_operationobj-quantityrework = ls_productionobj-rmnga.
      ls_operationobj-quantityscrap = ls_productionobj-xmnga.
      ls_operationobj-goodquantity = COND #( WHEN ls_productionobj-missingqty LT 0
                                          THEN 0
                                          ELSE ls_productionobj-missingqty ).
*      ls_operationobj-reworkquantity = COND #( WHEN ls_productionobj-missingqty LT 0
*                                          THEN 0
*                                          ELSE ls_productionobj-missingqty ). "SELECT rework/l_rmnga

      ls_operationobj-quantitymissing = ls_productionobj-missingqty.
      ls_operationobj-quantitytomake = ls_productionobj-gamng.
*02/01/2023 ADR: on first operation the accumulatedQuantity is always the missingQuantity.
      IF ( ls_productionobj-aplzl EQ '00000001' ).
        ls_operationobj-accumulatedquantity = ls_productionobj-missingqty.
      ELSE.
        ls_operationobj-accumulatedquantity = ls_productionobj-qty_proc.
      ENDIF.
**ENDIF.
      ls_operationobj-numberoperationstoend = ls_productionobj-vornr_tot.
      ls_operationobj-typeid = ls_productionobj-tipord.
      ls_operationobj-productionordertype = ls_productionobj-auart.
      ls_operationobj-reprogproductionorder = COND #( WHEN ls_productionobj-date_reprog EQ 'X'
                                                   THEN abap_true
                                                   ELSE abap_false ).
      ls_operationobj-alerttext = ls_productionobj-zerma_txt.

      ls_operationobj-iinfo-arbpl = ls_productionobj-arbpl.
      ls_operationobj-iinfo-aplzl = ls_productionobj-aplzl.
      ls_operationobj-iinfo-aufpl = ls_productionobj-aufpl.
      ls_operationobj-iinfo-rueck = ls_productionobj-rueck.

      CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
        EXPORTING
          input  = ls_productionobj-matnr
        IMPORTING
          output = ls_operationobj-iinfo-matnr.

      ls_operationobj-iinfo-tipord = ls_productionobj-tipord.
      ls_operationobj-iinfo-wareid = ls_productionobj-wareid.

      ls_operationobj-initialcyclecounter = COND #( WHEN ls_productionobj-count_ini IS NOT INITIAL
                                                 THEN ls_productionobj-count_ini
                                                 ELSE 0 ).

      ls_operationobj-totalmissingquantity = ''.
      ls_operationobj-totalqtyalreadyregistered = ls_productionobj-total_qty.
      ls_operationobj-operatorid = COND #( WHEN ls_productionobj-cname IS NOT INITIAL
                                        THEN is_inputobj-oprid ).
      ls_operationobj-operatorname = ls_productionobj-cname.
      ls_operationobj-operatorqualificationid = ls_productionobj-quali.
      ls_operationobj-operatorqualificationdescripti = ls_productionobj-qtext.
      IF ls_productionobj-status_oper NE 'INI' AND ls_productionobj-status_oper NE 'AGU'.
        ls_operationobj-scheduleid = ls_productionobj-schedule_id.
        ls_operationobj-scheduledescription = ls_productionobj-schedule_desc.
        ls_operationobj-regimeid = ls_productionobj-regime_id.
        ls_operationobj-regimedescription = ls_productionobj-regime_desc.
      ENDIF.
      ls_operationobj-currenttheoreticalcyclecounter = ls_productionobj-time_mcycle.
      ls_operationobj-totaltheoreticalquantity = ls_productionobj-numb_mcycle.
      ls_operationobj-currentrealcyclecounter = COND #( WHEN ls_productionobj-numb_cycle IS NOT INITIAL
                                                     THEN ls_productionobj-numb_cycle ). "TODO: Verificar se podemos declarar de forma direta (ls_operationobj-currentrealcyclecounter = ls_productionobj-numb_cycle)
      ls_operationobj-theoreticalquantity = ls_productionobj-theoretical_qty.
      ls_operationobj-operationlot = ls_productionobj-batch.
      ls_operationobj-operationpallet = ls_productionobj-lenum.
      ls_operationobj-alternateunit = ls_productionobj-unit_alt.
      ls_operationobj-unitgmein = ls_productionobj-gmein.
      ls_operationobj-marcooperation = COND #( WHEN ls_productionobj-marco EQ 'X'
                                            THEN abap_true
                                            ELSE abap_false ).
      ls_operationobj-inksugestedtemperature = 20.
      ls_operationobj-mininktemperature = 18.
      ls_operationobj-maxinktemperature = 22.

      ls_operationobj-goodquantityoperator = ls_productionobj-lmnga_card.
      ls_operationobj-scrapquantityoperator = ls_productionobj-xmnga_card.
      ls_operationobj-islotoperation = COND #( WHEN ls_productionobj-autwe IS NOT INITIAL AND ls_productionobj-autwe EQ 'X'
                                            THEN abap_true
                                            ELSE abap_false ).
      ls_operationobj-unitvalue = COND #( WHEN ls_productionobj-units IS NOT INITIAL
                                          THEN ls_productionobj-units[ 1 ]-meinh ).
      ls_operationobj-unitgmein = COND #( WHEN ls_operationobj-unitvalue EQ 'KI'
                                       THEN 'CX'
                                       ELSE ls_operationobj-unitgmein ).
      ls_operationobj-unittype = 'NoRetribeBox'.
      ls_operationobj-traceability = COND #( WHEN ls_productionobj-traceability EQ 'X'
                                          THEN 'RAST' ).

      IF ls_headeronly-value NE 'true'.
        DATA: lv_username TYPE string,
              lv_name     TYPE string,
              ls_user     TYPE zsf_users.

        LOOP AT ls_productionobj-oprid_tab INTO ls_operatorobj.

          SELECT SINGLE *
            FROM zsf_users
            WHERE usererpid EQ @ls_operatorobj-oprid
            INTO @ls_user.

          IF ls_user IS NOT INITIAL.
            lv_username = ls_user-username.
            lv_name = ls_user-name.
          ELSE.
            SELECT SINGLE *
            FROM zsf_users
            WHERE username EQ @ls_operatorobj-oprid
            INTO @ls_user.

            lv_username = ls_user-username.
            lv_name = ls_user-name.
          ENDIF.

          "Loop OperationOperator, Defect, ScrapMissing
          CLEAR ls_operationoperator.
          ls_operationoperator-workcenterid = ls_wrkctr_detail-arbpl.
          ls_operationoperator-productionorderid = ls_productionobj-aufnr.
          ls_operationoperator-operationid = ls_productionobj-vornr.
          ls_operationoperator-operatorid = COND #( WHEN lv_username IS NOT INITIAL
                                          THEN lv_username
                                          ELSE ls_operatorobj-oprid ).
          ls_operationoperator-operatorname = COND #( WHEN lv_username IS NOT INITIAL
                                          THEN lv_name
                                          ELSE ls_operatorobj-nome ).
          ls_operationoperator-status = 'A'.
          APPEND ls_operationoperator TO ls_workcenter-assignedoperators.
        ENDLOOP.

        IF ( ls_operationobj-statusid EQ 'PREP' OR ls_operationobj-statusid EQ 'PROC' )
          AND ls_operationid-value EQ ls_productionobj-vornr
          AND ls_productionorderid-value EQ ls_productionobj-aufnr.

          CALL FUNCTION 'ZABSF_PP_GETDEFECTS'
            EXPORTING
              arbpl           = CONV arbpl( ls_workcenterid-value )
              matnr           = CONV matnr( ls_operationobj-materialid )
              aufnr           = CONV aufnr( ls_operationobj-productionorderid )
              vornr           = CONV vornr( ls_operationobj-id )
              reasontyp       = 'C'
              flag_scrap_list = 'X'
              refdt           = sy-datum
              inputobj        = is_inputobj
            IMPORTING
              reason_tab      = lt_reason_tab.

          LOOP AT lt_reason_tab INTO DATA(ls_scrap).
            CLEAR ls_scrapmissing.
            ls_scrapmissing-id = ls_scrap-grund.
            ls_scrapmissing-scrapdescription = ls_scrap-grdtx.
            ls_scrapmissing-operationid = ls_operationobj-id.
            ls_scrapmissing-productionorderid = ls_operationobj-productionorderid.
            ls_scrapmissing-scrapalreadyregistered = ls_scrap-scrap_qty.
            ls_scrapmissing-workcenterid = ls_workcenterid-value.
            APPEND ls_scrapmissing TO ls_operationobj-scrapsmissing.
          ENDLOOP.
        ENDIF.
      ENDIF.

      ls_operationobj-project = ls_productionobj-project.
      ls_operationobj-schematics = ls_productionobj-schematics.
      ls_operationobj-componentschecked = ls_productionobj-components_checked.
      ls_operationobj-availabilitystatus = ls_productionobj-missing_parts.
      ls_operationobj-availabilityoverride = ls_productionobj-override.
      ls_operationobj-availabilitycolour = ls_productionobj-status_color.
      ls_operationobj-pf = ls_productionobj-production_plan.
      ls_operationobj-productionplanid = ls_productionobj-program.
      ls_operationobj-workcenterpositionid = ls_productionobj-kapid.
      ls_operationobj-workcenterpositionname = ls_productionobj-name.
      ls_operationobj-workcenterpositiondescription = ls_productionobj-ktext.
      ls_operationobj-ordersequencenumber = ls_productionobj-cy_seqnr.
*** BEGIN JOL - 09/12/2022 - sequence operation
      ls_operationobj-sequence = ls_productionobj-sequence.
*      ls_operationobj-sequence = sy-tabix.
*** END JOL - 09/12/2022 - sequence operation
      ls_operationobj-traceability = COND #( WHEN ls_productionobj-traceability EQ 'X'
                                          THEN 'RAST' ).
      ls_operationobj-ismultimaterial = COND #( WHEN ls_productionobj-multimaterial EQ 'X'
                                             THEN abap_true
                                             ELSE abap_false ).
      ls_operationobj-ispreviousoperationnecessary = COND #( WHEN ls_productionobj-read_label EQ 'X'
                                                          THEN abap_true
                                                          ELSE abap_false ).
      ls_operationobj-ismmbatchvalidationnecessary = COND #( WHEN ls_productionobj-batch_validation EQ 'X'
                                                          THEN abap_true
                                                          ELSE abap_false ).

* Start Change ABACO(AON) : 21.10.2022
* Description: Added the stopreason
      IF ls_productionobj-status_oper EQ `STOP`.
        lcl_helper_operation=>get_stopreason( EXPORTING iv_arbpl = ls_productionobj-arbpl
                                                        iv_aufnr = ls_productionobj-aufnr
                                                        iv_vornr = ls_productionobj-vornr
                                                        iv_status_oper = ls_productionobj-status_oper
                                                        iv_spras = lv_langu
                                              IMPORTING ev_stopreason_id = ls_operationobj-operationstopreason-id
                                                        ev_stopreason_desc = ls_operationobj-operationstopreason-operationstopreasondescription
                                              ).
      ENDIF.
* End Change ABACO(AON) : 21.10.2022
      IF ls_headeronly-value NE 'true'.

        LOOP AT ls_productionobj-availability_information INTO DATA(ls_missingpart2).
          CLEAR ls_missingpart.
          ls_missingpart-materialid = sy-tabix - 1.
          ls_missingpart-operationid = ls_operationobj-id.
          ls_missingpart-productionorderid = ls_operationobj-productionorderid.
          ls_missingpart-workcenterid = ls_operationobj-workcenterid.
          ls_missingpart-materialdescription = ls_missingpart2-message.
          ls_missingpart-quantitymissing = 0.
          ls_missingpart-project = ls_operationobj-project.
          ls_missingpart-schematics = ls_operationobj-schematics.
          APPEND ls_missingpart TO ls_operationobj-missingparts.
        ENDLOOP.

        LOOP AT ls_productionobj-components INTO DATA(ls_component).
          CLEAR ls_multimaterial.
*          ls_multimaterial-materialid = CONV matn1( ls_component-matnr ).
          CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
            EXPORTING
              input  = ls_component-matnr
            IMPORTING
              output = ls_multimaterial-materialid.

          ls_multimaterial-reservenumber = ls_component-rsnum.
          ls_multimaterial-reserveitem = ls_component-rspos.
          ls_multimaterial-operationid = ls_operationobj-id.
          ls_multimaterial-productionorderid = ls_operationobj-productionorderid.
          ls_multimaterial-workcenterid = ls_operationobj-workcenterid.
          ls_multimaterial-batchid = ls_component-batch.
          ls_multimaterial-lgort = ls_component-lgort.
          ls_multimaterial-sobkz = ls_component-sobkz.
          ls_multimaterial-vornr = ls_operationobj-id.
          ls_multimaterial-materialdescription = ls_component-maktx.
          ls_multimaterial-quantitytomake = ls_component-bdmng * -1.
          ls_multimaterial-quantitymade = ls_component-enmng.
          ls_multimaterial-quantityrework  = 0.
          ls_multimaterial-quantityscrap = 0.
          ls_multimaterial-quantitymissing = ls_component-consqty.
          ls_multimaterial-bundlevalue = 0.
          ls_multimaterial-boxbundle = 0.
          ls_multimaterial-goodquantity = COND #( WHEN ls_component-consqty GT 0
                                                  THEN ls_component-consqty
                                                  ELSE 0 ).
          ls_multimaterial-unitgmein = ls_component-meins.
          ls_multimaterial-project = ls_operationobj-project.
          ls_multimaterial-schematics = ls_operationobj-schematics.
          APPEND ls_multimaterial TO ls_operationobj-multimaterials.
        ENDLOOP.

      ENDIF.

      APPEND ls_operationobj TO ls_workcenter-operations.
      APPEND ls_productionorderobj TO ls_workcenter-productionorders.
    ENDLOOP.

    ls_workcenter-outputsettings_batchgeneration = COND #( WHEN ls_wrkctr_detail-output_settings-batch_generation EQ 'X'
                                                           THEN abap_true
                                                           ELSE abap_false ).
    ls_workcenter-outputsettings_batchvalidation = COND #( WHEN ls_wrkctr_detail-output_settings-batch_validation EQ 'X'
                                                           THEN abap_true
                                                           ELSE abap_false ).
    ls_workcenter-outputsettings_btstart1stcycle = COND #( WHEN ls_wrkctr_detail-output_settings-bt_start_1st_cycle EQ 'X'
                                                           THEN abap_true
                                                           ELSE abap_false ).
    ls_workcenter-outputsettings_btstartlaunch = COND #( WHEN ls_wrkctr_detail-output_settings-bt_start_launch EQ 'X'
                                                         THEN abap_true
                                                         ELSE abap_false ).
    ls_workcenter-outputsettings_consumptions = COND #( WHEN ls_wrkctr_detail-output_settings-consumptions EQ 'X'
                                                        THEN abap_true
                                                        ELSE abap_false ).
    ls_workcenter-outputsettings_onlymarcoops = COND #( WHEN ls_wrkctr_detail-output_settings-only_marco_ops EQ 'X'
                                                        THEN abap_true
                                                        ELSE abap_false ).
    ls_workcenter-outputsettings_goodqttmarco = COND #( WHEN ls_wrkctr_detail-output_settings-good_qtt_marco EQ 'X'
                                                        THEN abap_true
                                                        ELSE abap_false ).
    ls_workcenter-outputsettings_scrapqttmarco = COND #( WHEN ls_wrkctr_detail-output_settings-scrap_qtt_marco EQ 'X'
                                                         THEN abap_true
                                                         ELSE abap_false ).
    ls_workcenter-outputsettings_prodinfo = COND #( WHEN ls_wrkctr_detail-output_settings-prod_info EQ 'X'
                                                    THEN abap_true
                                                    ELSE abap_false ).
    ls_workcenter-outputsettings_qualifications = COND #( WHEN ls_wrkctr_detail-output_settings-qualifications EQ 'X'
                                                          THEN abap_true
                                                          ELSE abap_false ).
    ls_workcenter-outputsettings_schedulesandreg = abap_true.
    ls_workcenter-showtransferlabel = COND #( WHEN ls_wrkctr_detail-print_label EQ 'X'
                                              THEN abap_true
                                              ELSE abap_false ).
    APPEND ls_workcenter TO lt_workcenter.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_workcenter ).
  ENDMETHOD.


  METHOD get_getworkcenters_2.
    DATA: lt_return_tab   TYPE bapiret2_t,
          lv_shiftid      TYPE zabsf_pp_e_shiftid,
          ls_hrchy_detail TYPE zabsf_pp_s_hrchy_detail,
          lt_workcenter   TYPE tt_workcenter.

    READ TABLE it_keys INTO DATA(ls_shiftid) WITH KEY name = 'SHIFTID'.
    READ TABLE it_keys INTO DATA(ls_hierarchyid) WITH KEY name = 'HIERARCHYID'.

    zcl_bc_fixed_values=>get_single_value( EXPORTING
                                          im_paramter_var = zcl_bc_fixed_values=>gc_default_shift_cst
                                          im_modulesp_var = zcl_bc_fixed_values=>gc_productn_cst
                                        IMPORTING
                                          ex_prmvalue_var = DATA(lv_default_shift) ).

    lv_shiftid = COND #( WHEN ls_shiftid-value IS NOT INITIAL
                         THEN CONV zabsf_pp_e_shiftid( ls_shiftid-value )
                         ELSE CONV zabsf_pp_e_shiftid( lv_default_shift ) ).

    CALL FUNCTION 'ZABSF_PP_GETHRCHY_DETAIL'
      EXPORTING
        areaid         = is_inputobj-areaid
        shiftid        = lv_shiftid
        hname          = CONV cr_hname( ls_hierarchyid-value )
        refdt          = sy-datum
        inputobj       = is_inputobj
        no_shift_check = abap_true
      IMPORTING
        hrchy_detail   = ls_hrchy_detail
        return_tab     = lt_return_tab.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

    lt_workcenter =
      VALUE #(
        FOR ls_wrkctr IN ls_hrchy_detail-wrkctr_tab (
          id                         = ls_wrkctr-arbpl
          workcenterdescription      = ls_wrkctr-ktext
          statusid                   = ls_wrkctr-status
          workcentertype             = ls_wrkctr-objty
          parenthierarchy            = ls_hrchy_detail-parent
          parenthierarchydescription = ls_hrchy_detail-ktext
          prdty                      = ls_wrkctr-prdty ) ).

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_workcenter ).
  ENDMETHOD.


  METHOD get_hierarchys.
    DATA : lt_hierarchies     TYPE tt_hierarchy,
           ls_shift_detail    TYPE zabsf_pp_s_shift_detail,
           lt_hierarchies_tab TYPE STANDARD TABLE OF zabsf_pp_s_hrchy.

    READ TABLE it_keys INTO DATA(ls_hierarhyid) WITH KEY name = 'HIERARCHYID'.
    READ TABLE it_keys INTO DATA(ls_shiftid) WITH KEY name = 'SHIFTID'.

    IF ls_shiftid-value IS NOT INITIAL.
      data(lv_shiftid) = CONV zabsf_pp_e_shiftid( ls_shiftid-value ).

      CALL FUNCTION 'ZABSF_PP_GETSHIFT_DETAIL'
        EXPORTING
          areaid       = is_inputobj-areaid
          werks        = is_inputobj-werks
          shiftid      = lv_shiftid
          refdt        = sy-datum
          refhr        = sy-uzeit
          inputobj     = is_inputobj
        IMPORTING
          shift_detail = ls_shift_detail.

      LOOP AT ls_shift_detail-hrchy_tab INTO DATA(ls_hrchy_tab).

        SELECT * FROM zsf_hierarchies
          INTO TABLE @DATA(lt_ohierarchies)
          WHERE ( areaid EQ @is_inputobj-areaid OR areaid IS NULL )
          AND ( shiftid EQ @ls_shiftid-value OR shiftid IS NULL )
          AND ( hierarchyid EQ @ls_hierarhyid-value OR hierarchyid IS NULL ).

        IF lt_ohierarchies IS NOT INITIAL.
          DATA(ls_hierarchystatus) = VALUE ty_hierarchystatus( areaid = lt_ohierarchies[ 1 ]-areaid
                                                               shiftid = lt_ohierarchies[ 1 ]-shiftid ).
        ENDIF.

        IF ( ls_hierarhyid-value IS NOT INITIAL AND ls_hrchy_tab-hname NE ls_hierarhyid-value )
          OR ( ls_hierarhyid-value IS INITIAL ).
          APPEND VALUE #( hierarchyid = ls_hrchy_tab-hname
                          hierarchydescription = ls_hrchy_tab-ktext
                          hstatus = VALUE #( ( ls_hierarchystatus ) ) ) TO lt_hierarchies.
        ENDIF.
      ENDLOOP.
    ELSE.
      CALL FUNCTION 'ZABSF_PP_GETHIERARCHIES'
        EXPORTING
          inputobj        = is_inputobj
          refdt           = sy-datum
        IMPORTING
          hierarchies_tab = lt_hierarchies_tab.

      lt_hierarchies = VALUE #( FOR ls_hierarchy IN lt_hierarchies_tab ( hierarchyid = ls_hierarchy-hname
                                                                         hierarchydescription = COND #( WHEN ls_hierarchy-ktext IS NOT INITIAL
                                                                                                        THEN ls_hierarchy-ktext ELSE ls_hierarchy-hname )
                                                                         status = 0 ) ).
    ENDIF.

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_hierarchies ).
  ENDMETHOD.


  METHOD get_label.
    DATA :
      lt_return TYPE bapiret2_t,
      ls_label  TYPE ty_label.

    ls_label-material              = VALUE matnr( it_keys[ name = 'MATERIAL' ]-value OPTIONAL ).
    ls_label-order                 = VALUE aufnr( it_keys[ name = 'ORDER' ]-value OPTIONAL ).
    ls_label-operation             = VALUE vornr( it_keys[ name = 'OPERATION' ]-value OPTIONAL ).
    ls_label-workcenter            = VALUE arbpl( it_keys[ name = 'WORKCENTER' ]-value OPTIONAL ).
    ls_label-type                  = VALUE char1( it_keys[ name = 'TYPE' ]-value OPTIONAL ).
    ls_label-qtyparc               = VALUE string( it_keys[ name = 'QTYPARC' ]-value OPTIONAL ).

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input        = ls_label-material
      IMPORTING
        output       = ls_label-material
      EXCEPTIONS
        length_error = 1
        OTHERS       = 2.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = ls_label-order
      IMPORTING
        output = ls_label-order.

    " Get Workcenter id
    SELECT SINGLE *
      FROM crhd
      INTO @DATA(ls_crhd)
        WHERE arbpl EQ @ls_label-workcenter
          AND werks EQ @is_inputobj-werks
          AND objty EQ 'A'.

    " Get Workcenter description
    SELECT SINGLE ktext
      FROM crtx
      INTO @ls_label-workcenterdescription
     WHERE objty EQ @ls_crhd-objty
       AND objid EQ @ls_crhd-objid
       AND spras EQ @sy-langu.

    " delete trailing zeros after decimal quantity field
    SHIFT ls_label-qtyparc RIGHT DELETING TRAILING '0'.

    CALL FUNCTION 'ZABSF_PP_GET_LABEL'
      EXPORTING
        iv_matnr                 = ls_label-material
        iv_aufnr                 = ls_label-order
        iv_vornr                 = ls_label-operation
        iv_arbpl                 = ls_label-workcenter
        iv_workcenterdescription = ls_label-workcenterdescription
        iv_type                  = ls_label-type
        iv_qtyparc               = ls_label-qtyparc
        iv_refdt                 = sy-datum
        is_inputobj              = is_inputobj
      IMPORTING
        ev_pdf                   = ls_label-pdf
        et_return                = lt_return.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return CHANGING co_msg = co_msg ).

    er_entity = lcl_utils=>copy_data_to_ref( ls_label ).
  ENDMETHOD.


  METHOD get_materialbatchs.
    DATA:
      lt_return         TYPE bapiret2_t,
      lt_materialbatchs TYPE zabsf_pp_t_materialbatch.

    DATA(lv_matnr) = VALUE matnr( it_keys[ name = 'MATERIAL' ]-value OPTIONAL ).
    DATA(lv_werks) = VALUE werks_d( it_keys[ name = 'PLANT' ]-value OPTIONAL ).

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input        = lv_matnr
      IMPORTING
        output       = lv_matnr
      EXCEPTIONS
        length_error = 1
        OTHERS       = 2.

    CALL FUNCTION 'ZABSF_PP_GET_MATERIAL_BATCHS'
      EXPORTING
        iv_matnr          = lv_matnr
        iv_werks          = lv_werks
        iv_refdt          = sy-datum
        is_inputobj       = is_inputobj
      IMPORTING
        et_materialbatchs = lt_materialbatchs
        et_return         = lt_return.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return CHANGING co_msg = co_msg ).

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_materialbatchs ).
  ENDMETHOD.


  METHOD get_materials.
    DATA : lt_return   TYPE bapiret2_t,
           lt_material TYPE zabsf_pp_t_materials,
           lt_result   TYPE tt_material.

    DATA(lv_werks) = VALUE werks_d( it_keys[ name = 'CENTER' ]-value OPTIONAL ).
    DATA(lv_matnr) = VALUE matnr( it_keys[ name = 'MATERIALID' ]-value OPTIONAL ).

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
        EXPORTING
          input        = lv_matnr
        IMPORTING
          output       = lv_matnr
        EXCEPTIONS
          length_error = 1
          OTHERS       = 2.

    CALL FUNCTION 'ZABSF_PP_GETMATERIALS'
      EXPORTING
        iv_werks      = CONV werks_d( lv_werks )
        iv_matnr      = lv_matnr
        is_inputobj   = is_inputobj
      IMPORTING
        et_materials  = lt_material
        et_return_tab = lt_return.

    LOOP AT lt_material ASSIGNING FIELD-SYMBOL(<fs_materials>).
      CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
        EXPORTING
          input        = <fs_materials>-matnr
        IMPORTING
          output       = <fs_materials>-matnr
        EXCEPTIONS
          length_error = 1
          OTHERS       = 2.
    ENDLOOP.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return CHANGING co_msg = co_msg ).

    lt_result = CORRESPONDING #( lt_material MAPPING center = werks
                                                     materialid = matnr
                                                     materialdesc = maktx ).

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_result ).
  ENDMETHOD.


  METHOD get_materialserials.
    DATA:
      lt_return         TYPE bapiret2_t,
      ls_materialserial TYPE zabsf_pp_s_materialserial,
      lt_materialserial TYPE zabsf_pp_t_materialserial.

    DATA(lv_matnr) = VALUE matnr( it_keys[ name = 'MATERIAL' ]-value OPTIONAL ).
    DATA(lv_werks) = VALUE werks_d( it_keys[ name = 'PLANT' ]-value OPTIONAL ).
    DATA(lv_aufnr) = VALUE aufnr( it_keys[ name = 'ORDER' ]-value OPTIONAL ).

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input        = lv_matnr
      IMPORTING
        output       = lv_matnr
      EXCEPTIONS
        length_error = 1
        OTHERS       = 2.

    CALL FUNCTION 'ZABSF_PP_GET_MATERIAL_SERIAL'
      EXPORTING
        iv_matnr          = lv_matnr
        iv_werks          = lv_werks
        iv_aufnr          = lv_aufnr
        iv_refdt          = sy-datum
        is_inputobj       = is_inputobj
      IMPORTING
        et_materialserial = lt_materialserial
        et_return         = lt_return.

    LOOP AT lt_materialserial ASSIGNING FIELD-SYMBOL(<fs_materialserial>).
      CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
        EXPORTING
          input  = <fs_materialserial>-material
        IMPORTING
          output = <fs_materialserial>-material.

    ENDLOOP.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return CHANGING co_msg = co_msg ).

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_materialserial ).
  ENDMETHOD.


  METHOD get_movimentslabel.
    DATA : lt_return        TYPE bapiret2_t,
           ls_movimentlabel TYPE ty_movimentlabel.

    ls_movimentlabel-materialid     = VALUE matnr( it_keys[ name = 'MATERIALID' ]-value OPTIONAL ).
    ls_movimentlabel-materialdesc   = VALUE maktx( it_keys[ name = 'MATERIALDESC' ]-value OPTIONAL ).
    ls_movimentlabel-lote           = VALUE charg_d( it_keys[ name = 'BATCH' ]-value OPTIONAL ).
    ls_movimentlabel-deporigem      = VALUE vornr( it_keys[ name = 'SOURCELGORT' ]-value OPTIONAL ).
    ls_movimentlabel-depdestino     = VALUE vornr( it_keys[ name = 'DESTINATIONLGORT' ]-value OPTIONAL ).

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input        = ls_movimentlabel-materialid
      IMPORTING
        output       = ls_movimentlabel-materialid
      EXCEPTIONS
        length_error = 1
        OTHERS       = 2.

    IF ls_movimentlabel-materialdesc EQ ''.
      SELECT SINGLE maktx
        FROM makt
        WHERE matnr EQ @ls_movimentlabel-materialid
        AND spras = @sy-langu
        INTO @ls_movimentlabel-materialdesc.
    ENDIF.

    CALL FUNCTION 'ZABSF_PP_GET_MOVIMENTLABEL'
      EXPORTING
        iv_matnr     = ls_movimentlabel-materialid
        iv_maktx     = ls_movimentlabel-materialdesc
        iv_charg     = ls_movimentlabel-lote
        iv_vornrori  = ls_movimentlabel-deporigem
        iv_vornrdest = ls_movimentlabel-depdestino
        iv_refdt     = sy-datum
        is_inputobj  = is_inputobj
      IMPORTING
        ev_pdf       = ls_movimentlabel-pdf
        et_return    = lt_return.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return CHANGING co_msg = co_msg ).

    er_entity = lcl_utils=>copy_data_to_ref( ls_movimentlabel ).
  ENDMETHOD.


  METHOD get_operation.
    DATA : lt_return_tab      TYPE bapiret2_t,
           lt_prdord_unassign TYPE STANDARD TABLE OF zabsf_pp_s_prodord_unassign,
           lt_operation       TYPE STANDARD TABLE OF ty_operation.

    READ TABLE it_keys INTO DATA(ls_workcenterid) WITH KEY name = 'WORKCENTERID'.

    CALL FUNCTION 'ZABSF_PP_GET_PRDORD_UNASSIGN'
      EXPORTING
        arbpl           = CONV arbpl( ls_workcenterid-value )
        refdt           = sy-datum
        inputobj        = is_inputobj
      IMPORTING
        prdord_unassign = lt_prdord_unassign
        return_tab      = lt_return_tab.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

    lt_operation = VALUE #( FOR ls_productionobj IN lt_prdord_unassign ( id = ls_productionobj-vornr
                                                                         productionorderid = ls_productionobj-aufnr
                                                                         workcenterid = ls_workcenterid-value
                                                                         operationdescription = ls_productionobj-ltxa1
                                                                         materialid = ls_productionobj-matnr
                                                                         materialdescription = ls_productionobj-maktx
                                                                         programeddate = |{ ls_productionobj-gstrs } { ls_productionobj-gsuzs }|
                                                                         typeid = `N`
                                                                         statusid = `INI`
                                                                         iinfo = VALUE ty_operationinfo( matnr = ls_productionobj-matnr )
                                                                         pf = ls_productionobj-production_plan
                                                                         productionplanid = ls_productionobj-program
                                                                         schematics = ls_productionobj-schematics ) ).

    er_entity = lcl_utils=>copy_data_to_ref( lt_operation[ 1 ] ).
  ENDMETHOD.


  METHOD get_operationalerts.
    DATA: lt_opalerts   TYPE tt_operationalert,
          rg_materialid TYPE RANGE OF matnr,
          rg_operation  TYPE RANGE OF vornr,
          rg_alertid    TYPE RANGE OF zabsf_pp_e_alertid.

    DATA(lv_materialid) = VALUE matnr( it_keys[ name = 'MATERIALID' ]-value OPTIONAL ).
    DATA(lv_operation) = VALUE vornr( it_keys[ name = 'OPERATION' ]-value OPTIONAL ).
    DATA(lv_alertid) = VALUE zabsf_pp_e_alertid( it_keys[ name = 'ALERTID' ]-value OPTIONAL ).

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input  = lv_materialid
      IMPORTING
        output = lv_materialid.

    IF lv_materialid IS NOT INITIAL.
      APPEND INITIAL LINE TO rg_materialid ASSIGNING FIELD-SYMBOL(<fs_materialid>).
      <fs_materialid>-sign = 'I'.
      <fs_materialid>-option = 'EQ'.
      <fs_materialid>-low = lv_materialid.
    ENDIF.

    IF lv_operation IS NOT INITIAL.
      APPEND INITIAL LINE TO rg_operation ASSIGNING FIELD-SYMBOL(<fs_operation>).
      <fs_operation>-sign = 'I'.
      <fs_operation>-option = 'EQ'.
      <fs_operation>-low = lv_operation.
    ENDIF.

    IF lv_alertid IS NOT INITIAL.
      APPEND INITIAL LINE TO rg_alertid ASSIGNING FIELD-SYMBOL(<fs_alertid>).
      <fs_alertid>-sign = 'I'.
      <fs_alertid>-option = 'EQ'.
      <fs_alertid>-low = lv_alertid.
    ENDIF.

    SELECT matnr AS materialid, vornr AS operation, alertid, maktr AS materialdesc, alerttitle, alertdesc, flag, username, ltxa1, areaid
      FROM zabsf_pp_alerts
      WHERE matnr IN @rg_materialid
      AND vornr IN @rg_operation
      AND alertid IN @rg_alertid
      INTO TABLE @DATA(lt_results).

    LOOP AT lt_results ASSIGNING FIELD-SYMBOL(<fs_results>).
      CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
        EXPORTING
          input  = <fs_results>-materialid
        IMPORTING
          output = <fs_results>-materialid.
    ENDLOOP.

    lt_opalerts = VALUE #( FOR ls_result IN lt_results ( materialid = ls_result-materialid
                                                         operation = ls_result-operation
                                                         alertid = ls_result-alertid
                                                         materialdesc = ls_result-materialdesc
                                                         alerttitle = ls_result-alerttitle
                                                         alertdesc = ls_result-alertdesc
                                                         flag = ls_result-flag
                                                         username = ls_result-username
                                                         operationdesc = ls_result-ltxa1
                                                         areaid = ls_result-areaid ) ).

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_opalerts ).
  ENDMETHOD.


  METHOD get_operationconsumption.
    DATA : lt_return_tab           TYPE bapiret2_t,
           lt_components_tab       TYPE STANDARD TABLE OF zabsf_pp_s_components,
           ls_operationconsumption TYPE ty_operationconsumption,
           lt_operationconsumption TYPE STANDARD TABLE OF ty_operationconsumption.

    READ TABLE it_keys INTO DATA(ls_workcenterid) WITH KEY name = 'WORKCENTERID'.
    READ TABLE it_keys INTO DATA(ls_productionorderid) WITH KEY name = 'PRODUCTIONORDERID'.
    READ TABLE it_keys INTO DATA(ls_operationid) WITH KEY name = 'OPERATIONID'.
    READ TABLE it_keys INTO DATA(ls_palletorderid) WITH KEY name = 'PALLETORDERID'.
    READ TABLE it_keys INTO DATA(ls_devolution) WITH KEY name = 'DEVOLUTION'.

    DATA: lv_productionorderid TYPE aufnr,
          lv_palletorderid     TYPE exidv,
          lv_for_devolutions   TYPE abap_bool,
          lv_operationid       TYPE vornr.

    IF ls_palletorderid-value IS NOT INITIAL.
      lv_productionorderid = ls_productionorderid-value.
      lv_palletorderid = ls_palletorderid-value.
    ELSE.
      IF ls_devolution-value EQ abap_true.
        lv_for_devolutions = 'X'.
      ENDIF.
      lv_productionorderid = ls_productionorderid-value.
      lv_operationid = ls_operationid-value.
    ENDIF.

    CALL FUNCTION 'ZABSF_PP_GETCOMPONENTS'
      EXPORTING
        aufnr           = lv_productionorderid
        vornr           = lv_operationid
        refdt           = sy-datum
        inputobj        = is_inputobj
        hu              = lv_palletorderid
        for_devolutions = lv_for_devolutions
      IMPORTING
        components_tab  = lt_components_tab
        return_tab      = lt_return_tab.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

    lt_operationconsumption = VALUE #( FOR ls_component IN lt_components_tab ( productionorderid = lv_productionorderid
                                                                               materialid = ls_component-matnr
                                                                               operationconsumptiontype = COND #( WHEN ls_component-rsnum IS NOT INITIAL AND ls_component-rsnum NE `0000000000`
                                                                                                                       THEN `C`
                                                                                                                       ELSE `A` )
                                                                               reservenumber = ls_component-rsnum
                                                                               reserveitem = ls_component-rspos
                                                                               batchid = ls_component-batch
                                                                               unitid = ls_component-meins
                                                                               materialdescription = ls_component-maktx
                                                                               ilgort = ls_component-lgort
                                                                               olgort = ``
                                                                               materialdescriptiondisplay = ls_component-maktx
                                                                               iunit = ls_component-meins
                                                                               iunit_output = ls_component-meins_output
                                                                               quantitynecessary = ls_component-bdmng
                                                                               quantityconsumed = ls_component-enmng
                                                                               quantitytoconsume = COND #( WHEN lv_palletorderid IS INITIAL
                                                                                                                THEN ls_component-bdmng
                                                                                                                ELSE '' )
                                                                               quantitytoconsumedisplay = ls_component-consqty
                                                                               displaymode = `READ`
                                                                               action = ``
                                                                               batchflag = ls_component-xchpf
                                                                               availablestock = ls_component-verme
                                                                               seqlantek = ls_component-seq_lantek
                                                                               quantitysuggested = ls_component-menge_unit
                                                                               unitsuggested = ls_component-meins_unit
                                                                               width = ls_component-width
                                                                               length = ls_component-length
                                                                               reference = ls_component-reference
                                                                               operationconsumed = ls_component-vornr ) ).

    LOOP AT lt_operationconsumption ASSIGNING FIELD-SYMBOL(<fs_item>) WHERE operationconsumptiontype EQ 'A'.
      READ TABLE lt_operationconsumption WITH KEY materialid = <fs_item>-materialid
                                                  materialdescription = <fs_item>-materialdescription
                                                  operationconsumptiontype = 'C' INTO DATA(ls_obj).
      IF sy-subrc EQ 0.
        <fs_item>-reservedmaterial = abap_true.
        <fs_item>-reservenumber = ls_obj-reservenumber.
        <fs_item>-reserveitem = ls_obj-reserveitem.
      ENDIF.
    ENDLOOP.

    er_entity = lcl_utils=>copy_data_to_ref( ls_operationconsumption ).
  ENDMETHOD.


  METHOD get_operationconsumptiondevol.
    DATA : lt_return_tab                 TYPE bapiret2_t,
           lt_components_tab             TYPE STANDARD TABLE OF zabsf_pp_s_components,
           ls_operationconsumptiondevolu TYPE ty_operationconsumptiondevolu,
           lt_operationconsumptiondevolu TYPE tt_operationconsumptiondevolu.

    READ TABLE it_keys INTO DATA(ls_workcenterid) WITH KEY name = 'WORKCENTERID'.
    READ TABLE it_keys INTO DATA(ls_productionorderid) WITH KEY name = 'PRODUCTIONORDERID'.
    READ TABLE it_keys INTO DATA(ls_operationid) WITH KEY name = 'OPERATIONID'.

    CALL FUNCTION 'ZABSF_PP_GETCOMPONENTS'
      EXPORTING
        aufnr           = CONV aufnr( ls_productionorderid-value )
        vornr           = CONV vornr( ls_operationid-value )
        refdt           = sy-datum
        inputobj        = is_inputobj
        for_devolutions = abap_true
      IMPORTING
        components_tab  = lt_components_tab
        return_tab      = lt_return_tab.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

    LOOP AT lt_components_tab INTO DATA(ls_component).
      IF ls_operationid-value IS INITIAL AND ls_component-vornr NE ls_operationid-value.
        CONTINUE.
      ENDIF.

      ls_operationconsumptiondevolu = VALUE #( productionorderid = ls_productionorderid-value
                                               materialid = ls_component-matnr
                                               operationconsumptiontype = `C`
                                               batchid = replace( val = ls_component-batch sub = `\` with = `_` )
                                               reservenumber = ls_component-rsnum
                                               reserveitem = ls_component-rspos
                                               unitid = ls_component-meins
                                               materialdescription = ls_component-maktx
                                               iunit = ls_component-meins
                                               iunit_output = ls_component-meins_output
                                               quantitynecessary = ls_component-bdmng
                                               quantityconsumed = ls_component-enmng
                                               quantitytoconsume = ``
                                               quantitytoconsumedisplay = ls_component-consqty
                                               ilgort = ls_component-lgort
                                               olgort = ``
                                               displaymode = `READ`
                                               action = ``
                                               batchflag = ls_component-xchpf
                                               availablestock = ls_component-verme
                                               characteristicvalid = abap_true
                                               characteristicvisible = abap_true ).

      ls_operationconsumptiondevolu-characteristics = VALUE #( FOR ls_characteristic IN ls_component-characteristics ( productionorderid = ls_operationconsumptiondevolu-productionorderid
                                                                                                                       materialid = ls_operationconsumptiondevolu-materialid
                                                                                                                       operationconsumptiontype = ls_operationconsumptiondevolu-operationconsumptiontype
                                                                                                                       batchid = ls_operationconsumptiondevolu-batchid
                                                                                                                       reservenumber = ls_operationconsumptiondevolu-reservenumber
                                                                                                                       reserveitem = ls_operationconsumptiondevolu-reserveitem
                                                                                                                       unitid = ls_component-meins
                                                                                                                       characteristictext = ls_characteristic-atnam
                                                                                                                       characteristictype = COND #( WHEN ls_characteristic-atflv GT 0
                                                                                                                                                         THEN 'ATFLV'
                                                                                                                                                         ELSE 'ATWRT' )
                                                                                                                       characteristicdescription = ls_characteristic-smbez
                                                                                                                       characteristicvalue = ls_characteristic-atwrt
                                                                                                                       characteristicunit = ls_characteristic-dime1 ) ).

      READ TABLE lt_operationconsumptiondevolu WITH KEY materialid = ls_operationconsumptiondevolu-materialid
                                                        batchid = ls_operationconsumptiondevolu-batchid
                                                        unitid = ls_operationconsumptiondevolu-unitid
                                              INTO DATA(ls_operation).
      IF ls_operation IS INITIAL.
        APPEND ls_operationconsumptiondevolu TO lt_operationconsumptiondevolu.
      ENDIF.
    ENDLOOP.

    er_entity = lcl_utils=>copy_data_to_ref( ls_operationconsumptiondevolu ).
  ENDMETHOD.


  METHOD get_operationconsumptionhisto.
    DATA : lt_return_tab               TYPE bapiret2_t,
           lt_batch_consumed_tab       TYPE STANDARD TABLE OF zabsf_pp_s_batch_consumed,
           lv_ficha                    TYPE zabsf_pp_e_ficha,
           lv_time                     TYPE ru_isdz,
           ls_consumptionhistoryinfo   TYPE ty_consumptionhistoryinfo,
           ls_operationconsumptionlist TYPE ty_operationconsumptionlist.

    READ TABLE it_keys INTO DATA(ls_workcenterid) WITH KEY name = 'WORKCENTERID'.
    READ TABLE it_keys INTO DATA(ls_productionorderid) WITH KEY name = 'PRODUCTIONORDERID'.
    READ TABLE it_keys INTO DATA(ls_operationid) WITH KEY name = 'OPERATIONID'.
    READ TABLE it_keys INTO DATA(ls_materialid) WITH KEY name = 'MATERIALID'.

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
      EXPORTING
        input  = ls_materialid-value
      IMPORTING
        output = ls_materialid-value.

    CALL FUNCTION 'ZABSF_PP_GET_BATCH_CONSUMED'
      EXPORTING
        aufnr              = CONV aufnr( ls_productionorderid-value )
        vornr              = CONV vornr( ls_operationid-value )
        refdt              = sy-datum
        inputobj           = is_inputobj
      IMPORTING
        ficha              = lv_ficha
        time               = lv_time
        batch_consumed_tab = lt_batch_consumed_tab
        return_tab         = lt_return_tab.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

    ls_consumptionhistoryinfo = VALUE #( workcenterid = ls_workcenterid-value
                                         productionorderid = ls_productionorderid-value
                                         operationid = ls_operationid-value
                                         materialid = ls_materialid-value
                                         card = lv_ficha
                                         starttime = lv_time ).

    ls_consumptionhistoryinfo-operationconsumptionlist = VALUE #( FOR ls_consumed IN lt_batch_consumed_tab ( id = sy-tabix
                                                                                                             componentid = ls_consumed-matnr
                                                                                                             componentdescription = ls_consumed-maktx
                                                                                                             batch = ls_consumed-batch
                                                                                                             quantity = ls_consumed-ivbsu
                                                                                                             unit = ls_consumed-meins
                                                                                                             workcenterid = ls_workcenterid-value
                                                                                                             productionorderid = ls_productionorderid-value
                                                                                                             operationid = ls_operationid-value
                                                                                                             materialid = ls_materialid-value ) ).
    er_entity = lcl_utils=>copy_data_to_ref( ls_consumptionhistoryinfo ).
  ENDMETHOD.


  METHOD get_operationconsumptionhistos.
    DATA : lt_return_tab               TYPE bapiret2_t,
           lt_batch_consumed_tab       TYPE zabsf_pp_t_batch_consumed,
           lv_ficha                    TYPE zabsf_pp_e_ficha,
           lv_time                     TYPE ru_isdz,
           ls_consumptionhistoryinfo   TYPE ty_consumptionhistoryinfo,
           lt_consumptionhistoryinfo   TYPE tt_consumptionhistoryinfo,
           ls_operationconsumptionlist TYPE ty_operationconsumptionlist.

    READ TABLE it_keys INTO DATA(ls_workcenterid) WITH KEY name = 'WORKCENTERID'.
    READ TABLE it_keys INTO DATA(ls_productionorderid) WITH KEY name = 'PRODUCTIONORDERID'.
    READ TABLE it_keys INTO DATA(ls_operationid) WITH KEY name = 'OPERATIONID'.
    READ TABLE it_keys INTO DATA(ls_materialid) WITH KEY name = 'MATERIALID'.

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
      EXPORTING
        input  = ls_materialid-value
      IMPORTING
        output = ls_materialid-value.

    CALL FUNCTION 'ZABSF_PP_GET_BATCH_CONSUMED'
      EXPORTING
        aufnr              = CONV aufnr( ls_productionorderid-value )
        vornr              = CONV vornr( ls_operationid-value )
        refdt              = sy-datum
        inputobj           = is_inputobj
      IMPORTING
        ficha              = lv_ficha
        time               = lv_time
        batch_consumed_tab = lt_batch_consumed_tab
        return_tab         = lt_return_tab.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

    ls_consumptionhistoryinfo = VALUE #( workcenterid = ls_workcenterid-value
                                         productionorderid = ls_productionorderid-value
                                         operationid = ls_operationid-value
                                         materialid = ls_materialid-value
                                         card = lv_ficha
                                         starttime = lv_time ).

    ls_consumptionhistoryinfo-operationconsumptionlist = VALUE #( FOR ls_consumed IN lt_batch_consumed_tab ( id = sy-tabix
                                                                                                             componentid = ls_consumed-matnr
                                                                                                             componentdescription = ls_consumed-maktx
                                                                                                             batch = ls_consumed-batch
                                                                                                             quantity = ls_consumed-ivbsu
                                                                                                             unit = ls_consumed-meins
                                                                                                             workcenterid = ls_workcenterid-value
                                                                                                             productionorderid = ls_productionorderid-value
                                                                                                             operationid = ls_operationid-value
                                                                                                             materialid = ls_materialid-value ) ).

* Start Change ABACO(AON): 26.12.2022
* Description: Convert unit to localized string
LOOP AT ls_consumptionhistoryinfo-operationconsumptionlist ASSIGNING FIELD-SYMBOL(<fs_operationconsumption>).
      CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
      EXPORTING
        input                = <fs_operationconsumption>-unit
        LANGUAGE             = SY-LANGU
     IMPORTING
       OUTPUT               = <fs_operationconsumption>-unit
     EXCEPTIONS
       UNIT_NOT_FOUND       = 1
       OTHERS               = 2
              .
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
    ENDLOOP.
* End Change ABACO(AON): 26.12.2022

    lt_consumptionhistoryinfo = VALUE #( ( ls_consumptionhistoryinfo ) ).

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_consumptionhistoryinfo ).
  ENDMETHOD.


  METHOD get_operationconsumptions.
    DATA : lt_return_tab           TYPE bapiret2_t,
           lt_components_tab       TYPE STANDARD TABLE OF zabsf_pp_s_components,
           ls_operationconsumption TYPE ty_operationconsumption,
           lt_operationconsumption TYPE STANDARD TABLE OF ty_operationconsumption.

    READ TABLE it_keys INTO DATA(ls_workcenterid) WITH KEY name = 'WORKCENTERID'.
    READ TABLE it_keys INTO DATA(ls_productionorderid) WITH KEY name = 'PRODUCTIONORDERID'.
    READ TABLE it_keys INTO DATA(ls_operationid) WITH KEY name = 'OPERATIONID'.
    READ TABLE it_keys INTO DATA(ls_palletorderid) WITH KEY name = 'PALLETORDERID'.
    READ TABLE it_keys INTO DATA(ls_devolution) WITH KEY name = 'DEVOLUTION'.

    DATA: lv_productionorderid TYPE aufnr,
          lv_palletorderid     TYPE exidv,
          lv_for_devolutions   TYPE abap_bool,
          lv_operationid       TYPE vornr.
    IF ls_palletorderid-value IS NOT INITIAL.
      lv_productionorderid = ls_productionorderid-value.
      lv_palletorderid = ls_palletorderid-value.
    ELSE.
      lv_for_devolutions = COND #( WHEN to_lower( val = ls_devolution-value ) EQ 'true'
                                 THEN abap_true
                                 ELSE abap_false ).
      lv_productionorderid = CONV aufnr( ls_productionorderid-value ).
      lv_operationid = CONV vornr( ls_operationid-value ).
    ENDIF.

    CALL FUNCTION 'ZABSF_PP_GETCOMPONENTS'
      EXPORTING
        aufnr           = lv_productionorderid
        vornr           = lv_operationid
        refdt           = sy-datum
        inputobj        = is_inputobj
        for_devolutions = lv_for_devolutions
      IMPORTING
        components_tab  = lt_components_tab
        return_tab      = lt_return_tab.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

    LOOP AT lt_components_tab INTO DATA(ls_component).
      CLEAR ls_operationconsumption.
      ls_operationconsumption-productionorderid = lv_productionorderid.

*      ls_operationconsumption-materialid = ls_component-matnr.
      CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
        EXPORTING
          input         = ls_component-matnr
       IMPORTING
         OUTPUT        = ls_operationconsumption-materialid.

      ls_operationconsumption-operationconsumptiontype = COND #( WHEN ls_component-rsnum IS NOT INITIAL AND ls_component-rsnum NE '0000000000'
                                                                 THEN 'C'
                                                                 ELSE 'A' ).
      ls_operationconsumption-reservenumber = ls_component-rsnum.
      ls_operationconsumption-reserveitem = ls_component-rspos.
      ls_operationconsumption-batchid = ls_component-batch.
      ls_operationconsumption-unitid = ls_component-meins.
      ls_operationconsumption-materialdescription = ls_component-maktx.
      ls_operationconsumption-ilgort = ls_component-lgort.
      ls_operationconsumption-olgort = ''.
      ls_operationconsumption-materialdescriptiondisplay = ls_component-maktx.
      ls_operationconsumption-iunit = ls_component-meins.
      ls_operationconsumption-iunit_output = ls_component-meins_output.
      ls_operationconsumption-quantitynecessary = ls_component-bdmng.
      ls_operationconsumption-quantityconsumed = ls_component-enmng.
      ls_operationconsumption-quantitytoconsume = COND #( WHEN lv_palletorderid IS NOT INITIAL
                                                          THEN ls_component-bdmng
                                                          ELSE '' ).
      ls_operationconsumption-quantitytoconsumedisplay = ls_component-consqty.
      ls_operationconsumption-displaymode = 'READ'.
      ls_operationconsumption-action = ''.
      ls_operationconsumption-batchflag = ls_component-xchpf.
      ls_operationconsumption-availablestock = ls_component-verme.
      ls_operationconsumption-seqlantek = ls_component-seq_lantek.
      ls_operationconsumption-quantitysuggested = ls_component-menge_unit.
      ls_operationconsumption-unitsuggested = ls_component-meins_unit.
      ls_operationconsumption-width = ls_component-width.
      ls_operationconsumption-length = ls_component-length.
      ls_operationconsumption-reference = ls_component-reference.
      ls_operationconsumption-operationconsumed = ls_component-vornr.

      APPEND ls_operationconsumption TO lt_operationconsumption.
    ENDLOOP.

    LOOP AT lt_operationconsumption ASSIGNING FIELD-SYMBOL(<fs_item>) WHERE operationconsumptiontype = 'A'.
      "IF <fs_item>-operationconsumptiontype EQ 'A'.
      READ TABLE lt_operationconsumption WITH KEY materialid = <fs_item>-materialid
                                                  materialdescription = <fs_item>-materialdescription
                                                  operationconsumptiontype = 'C' INTO DATA(ls_obj).

      IF ( ls_obj IS NOT INITIAL ) AND ( ls_obj-materialdescription EQ <fs_item>-materialdescription ).
        <fs_item>-reservedmaterial = abap_true.
        <fs_item>-reservenumber = ls_obj-reservenumber.
        <fs_item>-reserveitem = ls_obj-reserveitem.
      ENDIF.
      "ENDIF.
    ENDLOOP.

    SORT lt_operationconsumption BY materialdescriptiondisplay operationconsumptiontype DESCENDING.
    DELETE ADJACENT DUPLICATES FROM lt_operationconsumption COMPARING materialdescriptiondisplay.

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_operationconsumption ).
  ENDMETHOD.


  METHOD get_operationnumbers.
    DATA: lt_return         TYPE bapiret2_t,
          rg_werks          TYPE RANGE OF werks_d,
          rg_matnr          TYPE RANGE OF matnr,
          lt_operations     TYPE tt_operationnumber,
          lt_operations_tab TYPE TABLE OF capp_opr.

    DATA(lv_werks) = VALUE werks_d( it_keys[ name = 'WERKS' ]-value OPTIONAL ).
    DATA(lv_matnr) = VALUE matnr( it_keys[ name = 'MATNR' ]-value OPTIONAL ).

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input  = lv_matnr
      IMPORTING
        output = lv_matnr.

    IF lv_werks IS NOT INITIAL.
      APPEND INITIAL LINE TO rg_werks ASSIGNING FIELD-SYMBOL(<fs_werks>).
      <fs_werks>-sign = 'I'.
      <fs_werks>-option = 'EQ'.
      <fs_werks>-low = lv_werks.
    ENDIF.

    IF lv_matnr IS NOT INITIAL.
      APPEND INITIAL LINE TO rg_matnr ASSIGNING FIELD-SYMBOL(<fs_matnr>).
      <fs_matnr>-sign = 'I'.
      <fs_matnr>-option = 'EQ'.
      <fs_matnr>-low = lv_matnr.
    ENDIF.

    SELECT SINGLE *
      FROM mapl
      WHERE werks IN @rg_werks
      AND matnr IN @rg_matnr
      AND loekz <> 'X'
      INTO @DATA(ls_mapl).

    IF ls_mapl IS NOT INITIAL.

      CALL FUNCTION 'CARO_ROUTING_READ'
        EXPORTING
          date_from            = '19000101'
          date_to              = '99991231'
          plnty                = ls_mapl-plnty
          plnnr                = ls_mapl-plnnr
          plnal                = ls_mapl-plnal
          matnr                = ls_mapl-matnr
          buffer_del_flg       = 'X'
          delete_all_cal_flg   = 'X'
          adapt_flg            = 'X'
          iv_create_add_change = ' '
          werks                = ls_mapl-werks
        TABLES
*         TSK_TAB              = TSK_TAB
*         SEQ_TAB              = SEQ_TAB
          opr_tab              = lt_operations_tab
*         PHASE_TAB            = PHASE_TAB
*         SUBOPR_TAB           = SUBOPR_TAB
*         REL_TAB              = REL_TAB
*         COM_TAB              = COM_TAB
*         REFERR_TAB           = REFERR_TAB
*         REFMIS_TAB           = REFMIS_TAB
*         IT_AENR              = IT_AENR
        EXCEPTIONS
          not_found            = 1
          ref_not_exp          = 2
          not_valid            = 3
          no_authority         = 4
          OTHERS               = 5.
      IF sy-subrc EQ 0.
        lt_operations = VALUE #( FOR ls_operations_tab IN lt_operations_tab ( vornr = ls_operations_tab-vornr
                                                                              ltxa1 = ls_operations_tab-ltxa1 ) ).
      ENDIF.
    ENDIF.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return CHANGING co_msg = co_msg ).

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_operations ).
  ENDMETHOD.


  METHOD get_operationoperators.
  ENDMETHOD.


  METHOD get_operations.
    DATA : lt_return_tab      TYPE bapiret2_t,
           lt_prdord_unassign TYPE STANDARD TABLE OF zabsf_pp_s_prodord_unassign,
           lt_operation       TYPE STANDARD TABLE OF ty_operation.

    READ TABLE it_keys INTO DATA(ls_workcenterid) WITH KEY name = 'WORKCENTERID'.

    DATA(lt_steus_filters) = VALUE string_table( ( CONV #( 'PP01' ) ) ).

    CALL FUNCTION 'ZABSF_PP_GET_PRDORD_UNASSIGN'
      EXPORTING
        arbpl           = CONV arbpl( ls_workcenterid-value )
        refdt           = sy-datum
        inputobj        = is_inputobj
        it_steus_filters = lt_steus_filters
      IMPORTING
        prdord_unassign = lt_prdord_unassign
        return_tab      = lt_return_tab.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

    lt_operation = VALUE #( FOR ls_productionobj IN lt_prdord_unassign ( id = ls_productionobj-vornr
                                                                         productionorderid = ls_productionobj-aufnr
                                                                         workcenterid = ls_workcenterid-value
                                                                         operationdescription = ls_productionobj-ltxa1
                                                                         materialid = ls_productionobj-matnr
                                                                         materialdescription = ls_productionobj-maktx
                                                                         programeddate = |{ ls_productionobj-gstrs } { ls_productionobj-gsuzs }|
                                                                         typeid = 'N'
                                                                         statusid = 'INI'
                                                                         iinfo = VALUE ty_operationinfo( matnr = ls_productionobj-matnr )
                                                                         pf = ls_productionobj-production_plan
                                                                         productionplanid = ls_productionobj-program
                                                                         schematics = ls_productionobj-schematics
                                                                         quantitytomake =  ls_productionobj-quantitytomake ) ).

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_operation ).
  ENDMETHOD.


  METHOD get_operationstopreasons.
    DATA : lt_return_tab          TYPE bapiret2_t,
           lt_stop_reason_tab     TYPE STANDARD TABLE OF zabsf_pp_s_stop_reason,
           lt_operationstopreason TYPE tt_operationstopreason.

    READ TABLE it_keys INTO DATA(ls_workcenterid) WITH KEY name = 'WORKCENTERID'.

    CALL FUNCTION 'ZABSF_PP_GETSTOP_REASON_OPR'
      EXPORTING
        arbpl           = CONV arbpl( ls_workcenterid-value )
        werks           = is_inputobj-werks
        refdt           = sy-datum
        inputobj        = is_inputobj
      IMPORTING
        stop_reason_tab = lt_stop_reason_tab
        return_tab      = lt_return_tab.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

    lt_operationstopreason = VALUE #( FOR ls_stop_reason IN lt_stop_reason_tab ( id = ls_stop_reason-stprsnid
                                                                                 operationstopreasondescription = ls_stop_reason-stprsn_desc ) ).

    "er_entity = lcl_utils=>copy_data_to_ref( lt_operationstopreason[ 1 ] ).
    er_entity_set = lcl_utils=>copy_data_to_ref( lt_operationstopreason ).
  ENDMETHOD.


  METHOD get_orderoperations.
    DATA :
      lt_return          TYPE bapiret2_t,
      lt_orderoperations TYPE zabsf_pp_t_prodord_operations.

    DATA(lv_aufnr) = VALUE aufnr( it_keys[ name = 'ORDER' ]-value OPTIONAL ).


    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lv_aufnr
      IMPORTING
        output = lv_aufnr.

    CALL FUNCTION 'ZABSF_PP_GET_PRDORD_OPERATIONS'
      EXPORTING
        iv_aufnr           = lv_aufnr
        is_inputobj        = is_inputobj
      IMPORTING
        et_orderoperations = lt_orderoperations
        et_return          = lt_return.

    SORT lt_orderoperations BY operation ASCENDING.

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_orderoperations ).
  ENDMETHOD.


  METHOD get_parameters.
    DATA: lt_return_tab     TYPE bapiret2_t,
          ls_inputobj       TYPE zabsf_pp_s_inputobject,
          lt_parameters_tab TYPE zabsf_pp_t_parameters,
          lt_parameters     TYPE tt_parameter.

    zcl_bc_fixed_values=>get_single_value( EXPORTING
                                          im_paramter_var = zcl_bc_fixed_values=>gc_default_werks_cst
                                          im_modulesp_var = zcl_bc_fixed_values=>gc_productn_cst
                                        IMPORTING
                                          ex_prmvalue_var = DATA(lv_default_workcenter) ).

    ls_inputobj-werks = lv_default_workcenter.

    CALL FUNCTION 'ZABSF_ADM_GETPARAMETERS'
      EXPORTING
        refdt          = sy-datum
        inputobj       = ls_inputobj
      IMPORTING
        parameters_tab = lt_parameters_tab
        return_tab     = lt_return_tab.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

    lt_parameters = VALUE #( FOR ls_parameter IN lt_parameters_tab ( parameterid = ls_parameter-parid
                                                                     description = ls_parameter-partxt
                                                                     value = ls_parameter-parva ) ).

    lt_parameters = VALUE #( BASE lt_parameters ( parameterid = `Token`
                                                  value = |{ ZABSF_PP_CL_AUTHENTICATION=>NEW_GET_DEFAULT_SAP_USER_TOKEN( ) }| ) ).

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_parameters ).
  ENDMETHOD.


  METHOD get_params.
    DATA: lt_params TYPE tt_param,
          ls_params TYPE ty_param.

    " Flag registro de tempos no registro de quantidades de operação
    zcl_bc_fixed_values=>get_single_value( EXPORTING
                                          im_paramter_var = zcl_bc_fixed_values=>gc_reg_time_quant_cst
                                          im_modulesp_var = zcl_bc_fixed_values=>gc_productn_cst
                                       IMPORTING
                                          ex_prmvalue_var = DATA(lv_reg_time) ).

    ls_params-value = COND #( WHEN lv_reg_time EQ 'ABAP_TRUE'
                                        THEN abap_true
                                        ELSE abap_false ).

    " Tempo definido para refresh de objetos.
    zcl_bc_fixed_values=>get_single_value( EXPORTING
                                             im_paramter_var = zcl_bc_fixed_values=>gc_refresh_time
                                             im_modulesp_var = zcl_bc_fixed_values=>gc_productn_cst
                                           IMPORTING
                                             ex_prmvalue_var = DATA(lv_refresh_time) ).

    ls_params-refreshtime = lv_refresh_time.

    lt_params = VALUE #( ( ls_params ) ).

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_params ).
  ENDMETHOD.


  METHOD get_reportpointcomponents.
    DATA:
      lref_sf_consum TYPE REF TO zif_absf_pp_consumptions,
      lv_class       TYPE recaimplclname,
      lv_method      TYPE seocmpname,
      lt_components  TYPE zabsf_pp_t_components,
      lt_return      TYPE bapiret2_t.

    DATA(lv_matnr) = VALUE #( it_keys[ name = 'MATNR' ]-value OPTIONAL ).
    DATA(lv_vornr) = VALUE #( it_keys[ name = 'VORNR' ]-value OPTIONAL ).
    DATA(lv_lmnga) = VALUE #( it_keys[ name = 'LMNGA' ]-value OPTIONAL ).
    DATA(lv_meins) = VALUE #( it_keys[ name = 'MEINS' ]-value OPTIONAL ).
    DATA(lv_refdt) = VALUE #( it_keys[ name = 'REFDT' ]-value OPTIONAL ).

    TRANSLATE lv_refdt USING '- '.
    CONDENSE lv_refdt NO-GAPS.

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input  = lv_matnr
      IMPORTING
        output = lv_matnr.

    IF sy-subrc EQ 0.
*Get class of interface
      SELECT SINGLE imp_clname methodname
         FROM zabsf_pp003
         INTO (lv_class, lv_method)
         WHERE werks    EQ is_inputobj-werks
           AND id_class EQ '9'
           AND endda    GE lv_refdt
           AND begda    LE lv_refdt.

      TRY .
          CREATE OBJECT lref_sf_consum TYPE (lv_class)
            EXPORTING
              initial_refdt = CONV datum( lv_refdt )
              input_object  = is_inputobj.

        CATCH cx_sy_create_object_error INTO DATA(lo_exception).
*
          CALL METHOD zcl_lp_pp_sf_log=>add_message
            EXPORTING
              msgty      = 'E'
              msgno      = '019'
              msgv1      = lv_class
            CHANGING
              return_tab = lt_return.

          EXIT.
      ENDTRY.

      CALL METHOD lref_sf_consum->(lv_method)
        EXPORTING
          matnr          = CONV matnr( lv_matnr )
          vornr          = CONV pzpnr( lv_vornr )
          lmnga          = CONV lmnga( lv_lmnga )
          meins          = CONV meins( lv_meins )
        CHANGING
          components_tab = lt_components
          return_tab     = lt_return.

      DELETE ADJACENT DUPLICATES FROM lt_return.


    LOOP AT lt_components ASSIGNING FIELD-SYMBOL(<fs_component>).
      CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
        EXPORTING
          input  = <fs_component>-matnr
        IMPORTING
          output = <fs_component>-matnr.
    ENDLOOP.

      lcl_utils=>validatesapresponse(
        EXPORTING it_result = lt_return
        CHANGING  co_msg    = co_msg ).

    ELSE.
      MESSAGE e002(z_sf_messages) INTO DATA(lv_msg).

      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( lv_msg ).

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ENDIF.

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_components ).
  ENDMETHOD.


  METHOD get_reportpointdefects.
    DATA:
      ls_rpoint_defect TYPE ty_reportpointdefects,
      lt_defects       TYPE zabsf_pp_t_defects,
      lt_reason        TYPE zabsf_pp_t_reason,
      lt_return        TYPE bapiret2_t.

    DATA(lv_rpoint) = VALUE #( it_keys[ name = 'RPOINT' ]-value OPTIONAL ).
    DATA(lv_rtype)  = VALUE #( it_keys[ name = 'REASONTYPE' ]-value OPTIONAL ).
    DATA(lv_refdt)  = VALUE #( it_keys[ name = 'REFDT' ]-value OPTIONAL ).

    TRANSLATE lv_refdt USING '- '.
    CONDENSE lv_refdt NO-GAPS.

    DATA lref_sf_rpoint TYPE REF TO zabsf_pp_cl_rpoint.

    CREATE OBJECT lref_sf_rpoint
      EXPORTING
        initial_refdt = CONV #( lv_refdt )
        input_object  = CORRESPONDING #( is_inputobj ).

    CALL METHOD lref_sf_rpoint->get_defects_rpoint
      EXPORTING
        rpoint      = CONV #( lv_rpoint )
        reasontyp   = CONV #( lv_rtype )
      CHANGING
        defects_tab = lt_defects
        reason_tab  = lt_reason
        return_tab  = lt_return.

    SORT lt_defects BY defectid ASCENDING.
    SORT lt_reason BY grund ASCENDING.

    DELETE ADJACENT DUPLICATES FROM lt_return.

    lcl_utils=>validatesapresponse(
      EXPORTING it_result = lt_return
      CHANGING  co_msg    = co_msg ).

    ls_rpoint_defect =
      VALUE #(
        rpoint     = lv_rpoint
        reasontype = lv_rtype
        refdt      = lv_refdt
        defects    = VALUE #( FOR d IN lt_defects (
                       id                = d-defectid
                       defectdescription = d-defect_desc
                       exist             = d-flag_exist
                       ordernumber       = d-aufnr ) )
        reason     = VALUE #( FOR r IN lt_reason (
                       reasonid    = r-grund
                       description = r-grdtx
                       scrapqty    = r-scrap_qty ) ) ).

    DATA(lt_rpoint_defect) = VALUE tt_reportpointdefects( ( ls_rpoint_defect ) ).

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_rpoint_defect ).

  ENDMETHOD.


  METHOD get_reportpointpassage.
    DATA:
      lref_sf_rpoint TYPE REF TO zabsf_pp_cl_rpoint,
      ls_passage     TYPE ty_reportpointpassage,
      lt_defects     TYPE zabsf_pp_t_defects,
      lt_passage     TYPE zabsf_pp_t_passage,
      lt_return      TYPE bapiret2_t.

    ls_passage-hname  = VALUE #( it_keys[ name = 'HNAME' ]-value OPTIONAL ).
    ls_passage-rpoint = VALUE #( it_keys[ name = 'RPOINT' ]-value OPTIONAL ).
    ls_passage-matnr  = VALUE #( it_keys[ name = 'MATNR' ]-value OPTIONAL ).
    ls_passage-gernr  = VALUE #( it_keys[ name = 'GERNR' ]-value OPTIONAL ).
    DATA(lv_refdt)    = VALUE #( it_keys[ name = 'REFDT'  ]-value OPTIONAL ).

    TRANSLATE lv_refdt USING '- '.
    CONDENSE lv_refdt NO-GAPS.
    ls_passage-refdt = lv_refdt.

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input  = ls_passage-matnr
      IMPORTING
        output = ls_passage-matnr.

    IF sy-subrc EQ 0.

      CREATE OBJECT lref_sf_rpoint
        EXPORTING
          initial_refdt = ls_passage-refdt
          input_object  = is_inputobj.

      CALL METHOD lref_sf_rpoint->get_pass_material
        EXPORTING
          hname       = ls_passage-hname
          rpoint      = ls_passage-rpoint
          matnr       = ls_passage-matnr
          gernr       = ls_passage-gernr
        CHANGING
          passnumber  = ls_passage-passnumber
          defects_tab = lt_defects
          passage_tab = lt_passage
          return_tab  = lt_return.

      APPEND LINES OF
       VALUE tt_defect( FOR o IN lt_defects (
         id                 = o-defectid
         defectdescription  = o-defect_desc
         exist              = o-flag_exist
         ordernumber        = o-aufnr
        ) ) TO ls_passage-defects.

      APPEND LINES OF
     VALUE tt_passage( FOR p IN lt_passage (
        passnumber   = p-passnumber
        result_def   = p-result_def
        defect_desc  = p-defect_desc
      ) ) TO ls_passage-passages.

      DELETE ADJACENT DUPLICATES FROM lt_return.

      lcl_utils=>validatesapresponse(
        EXPORTING it_result = lt_return
        CHANGING  co_msg    = co_msg ).

    ELSE.
      MESSAGE e002(z_sf_messages) INTO DATA(lv_msg).

      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( lv_msg ).

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ENDIF.

    er_entity = lcl_utils=>copy_data_to_ref( ls_passage ).
  ENDMETHOD.


  METHOD get_reportpoints.
    DATA:
      ls_rpoint_detail TYPE zabsf_pp_s_rpoint_detail,
      lt_return        TYPE bapiret2_t.

    DATA(lv_hname)  = VALUE #( it_keys[ name = 'HNAME' ]-value OPTIONAL ).
    DATA(lv_rpoint) = VALUE #( it_keys[ name = 'RPOINT' ]-value OPTIONAL ).
    DATA(lv_refdt)  = VALUE #( it_keys[ name = 'REFDT' ]-value OPTIONAL ).

    TRANSLATE lv_refdt USING '- '.
    CONDENSE lv_refdt NO-GAPS.

    DATA lref_sf_rpoint TYPE REF TO zabsf_pp_cl_rpoint.

    CREATE OBJECT lref_sf_rpoint
      EXPORTING
        initial_refdt = CONV #( lv_refdt )
        input_object  = CORRESPONDING #( is_inputobj ).

    CALL METHOD lref_sf_rpoint->get_rpoint_detail
      EXPORTING
        hname         = CONV #( lv_hname )
        rpoint        = CONV #( lv_rpoint )
      CHANGING
        rpoint_detail = ls_rpoint_detail
        return_tab    = lt_return.

    DELETE ADJACENT DUPLICATES FROM lt_return.

    lcl_utils=>validatesapresponse(
      EXPORTING it_result = lt_return
      CHANGING  co_msg    = co_msg ).

    DATA(ls_reportpoint) =
      VALUE ty_reportpoint(
        hname       = ls_rpoint_detail-hname
        ktext       = ls_rpoint_detail-ktext
        endda       = ls_rpoint_detail-endda
        rpoint      = ls_rpoint_detail-rpoint
        takt        = ls_rpoint_detail-takt
        lmnga       = ls_rpoint_detail-lmnga
        lmngasm     = ls_rpoint_detail-lmngasm
        gsmng       = ls_rpoint_detail-gsmng
        status      = ls_rpoint_detail-status
        status_desc = ls_rpoint_detail-status_desc
        gmein       = ls_rpoint_detail-gmein
      ).

    APPEND LINES OF
     VALUE zabsf_pp_t_operador( FOR o IN ls_rpoint_detail-oper_rpoint_tab (
       oprid                = o-oprid
       nome                 = o-nome
       status               = o-status
      ) ) TO ls_reportpoint-operreportpoint.

    APPEND LINES OF
     VALUE zabsf_pp_t_operador( FOR o IN ls_rpoint_detail-opr_arpoint_tab (
       oprid                = o-oprid
       nome                 = o-nome
       status               = o-status
      ) ) TO ls_reportpoint-operareportpoint.

    APPEND LINES OF
      VALUE tt_reportpointoperations( FOR m IN ls_rpoint_detail-mat_plan_tab (
        rpoint                      = ls_rpoint_detail-rpoint
        reportpointoperationplanned = abap_true
        typeid                      = 'N'
        matnr                       = CONV matn1( m-matnr )
        maktx                       = m-maktx
        vornr                       = m-vornr
        ltxa1                       = m-ltxa1
        amount                      = m-amount
        lmnga                       = m-lmnga
        lmngasm                     = m-lmngasm
        gsmng                       = m-gsmng
        gsmngweek                   = m-gsmngweek
        gsmngdelay                  = m-gsmngdelay
        qtdrpoint                   = m-qtdrpoint
        gmein                       = m-gmein
        passage                     = m-passage
        stk0070                     = m-stk0070
        stk0079                     = m-stk0079
        info-matnr                  = m-matnr
        info-gmein                  = m-gmein
        info-vornr                  = m-vornr
        info-hname                  = ls_rpoint_detail-rpoint
      ) ) TO ls_reportpoint-reportpointoperations.


    SORT ls_reportpoint-reportpointoperations BY ltxa1 ASCENDING.

    APPEND LINES OF
      VALUE tt_reportpointoperations( FOR n IN ls_rpoint_detail-mat_nplan_tab (
        rpoint                      = ls_rpoint_detail-rpoint
        reportpointoperationplanned = abap_false
        typeid                      = 'N'
        matnr                       = n-matnr
        maktx                       = n-maktx
        vornr                       = n-vornr
        ltxa1                       = n-ltxa1
        amount                      = n-amount
        lmnga                       = n-lmnga
        lmngasm                     = n-lmngasm
        gsmng                       = n-gsmng
        gsmngweek                   = n-gsmngweek
        gsmngdelay                  = n-gsmngdelay
        qtdrpoint                   = n-qtdrpoint
        gmein                       = n-gmein
        passage                     = n-passage
        stk0070                     = n-stk0070
        stk0079                     = n-stk0079
        info-matnr                  = n-matnr
        info-gmein                  = n-gmein
        info-vornr                  = n-vornr
        info-hname                  = ls_rpoint_detail-rpoint
      ) ) TO ls_reportpoint-reportpointoperations.


    APPEND LINES OF
      VALUE tt_reportpointoperations( FOR p IN ls_rpoint_detail-prdord_tab (
        reportpointoperationplanned = abap_true
        typeid                      = 'R'
        aufnr                       = p-aufnr
        auart                       = p-auart
        vornr                       = p-vornr
        rueck                       = p-rueck
        ltxa1                       = p-ltxa1
        aufpl                       = p-aufpl
        aplzl                       = p-aufpl
        werks                       = p-werks
        arbpl                       = p-arbpl
        matnr                       = p-matnr
        maktx                       = p-maktx
        gamng                       = p-gamng
        rmnga                       = p-rmnga
        xmnga                       = p-xmnga
        lmnga                       = p-lmnga
        missingqty                  = p-missingqty
        prdqty_box                  = p-prdqty_box
        boxqty                      = p-boxqty
        gmein                       = p-gmein
        qty_proc                    = p-qty_proc
        vornr_tot                   = p-vornr_tot
        gstrs                       = p-gstrs
        oprid_tab                   = p-oprid_tab
        status                      = p-status
        status_desc                 = p-status_desc
        status_oper                 = p-status_oper
        date_reprog                 = p-date_reprog
        tipord                      = p-tipord
        wareid                      = p-wareid
        zerma_txt                   = p-zerma_txt
        info-arbpl                  = p-arbpl
        info-aplzl                  = p-aplzl
        info-aufpl                  = p-aufpl
        info-rueck                  = p-rueck
        info-matnr                  = p-matnr
        info-tipord                 = p-tipord
        info-wareid                 = p-wareid
        info-vornr                  = p-vornr
        info-aufnr                  = p-aufnr
      ) ) TO ls_reportpoint-reportpointoperations.

    LOOP AT ls_reportpoint-reportpointoperations ASSIGNING FIELD-SYMBOL(<fs_reportpointoperation>).
      CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
        EXPORTING
          input  = <fs_reportpointoperation>-matnr
        IMPORTING
          output = <fs_reportpointoperation>-matnr.

      CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
        EXPORTING
          input  = <fs_reportpointoperation>-info-matnr
        IMPORTING
          output = <fs_reportpointoperation>-info-matnr.
    ENDLOOP.

*BEGIN JOL - 21/10/2022 - Add description of reason for stop workcenter
    DATA: lv_endda     TYPE iwexfdate VALUE '00000000',
          workcenterid TYPE arbpl.

    workcenterid = lv_rpoint.

    SELECT SINGLE stoptext~stprsn_desc
      FROM  zabsf_pp010 AS regstop
      INNER JOIN zabsf_pp011_t   AS stoptext
        ON stoptext~werks EQ regstop~werks AND stoptext~stprsnid EQ regstop~stprsnid
        AND stoptext~areaid EQ regstop~areaid AND stoptext~arbpl EQ regstop~arbpl
        WHERE  regstop~arbpl EQ @workcenterid AND  regstop~werks EQ @is_inputobj-werks AND  regstop~areaid EQ @is_inputobj-areaid
        AND regstop~endda  EQ @lv_endda
      INTO @DATA(statusstopdescription).
    IF sy-subrc = 0.
      ls_reportpoint-statusstopdescription = statusstopdescription.
    ENDIF.
** END JOL.

    DELETE ADJACENT DUPLICATES FROM lt_return.

    lcl_utils=>validatesapresponse(
      EXPORTING it_result = lt_return
      CHANGING  co_msg    = co_msg ).

    DATA(lt_reportpoint) = VALUE tt_reportpoint( ( ls_reportpoint ) ).

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_reportpoint ).

  ENDMETHOD.


  METHOD get_roles.
    DATA lt_roles TYPE STANDARD TABLE OF ty_role.

    SELECT *
      FROM zsf_roles
      INTO TABLE @DATA(lt_roles_tab).

    lt_roles = VALUE #( FOR ls_role IN lt_roles_tab ( id = ls_role-id
                                                      roledescription = ls_role-description ) ).

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_roles ).
  ENDMETHOD.


  METHOD get_runexecs.

    DATA: lv_commandname   TYPE sxpgcolist-name,
          lt_exec_protocol TYPE STANDARD TABLE OF btcxpm,
          lv_msg           TYPE string.

    zcl_bc_fixed_values=>get_single_value( EXPORTING
                                          im_paramter_var = zcl_bc_fixed_values=>gc_default_executable_name
                                          im_modulesp_var = zcl_bc_fixed_values=>gc_productn_cst
                                        IMPORTING
                                          ex_prmvalue_var = DATA(lv_default_executable) ).

    lv_commandname  = CONV sxpgcolist-name( lv_default_executable ).

    CALL FUNCTION 'SXPG_COMMAND_EXECUTE'
      EXPORTING
        commandname                   = lv_commandname
      TABLES
        exec_protocol                 = lt_exec_protocol
      EXCEPTIONS
        no_permission                 = 1
        command_not_found             = 2
        parameters_too_long           = 3
        security_risk                 = 3
        wrong_check_call_interface    = 3
        program_start_error           = 3
        program_termination_error     = 3
        x_error                       = 3
        parameter_expected            = 3
        too_many_parameters           = 3
        illegal_command               = 3
        wrong_asynchronous_parameters = 3
        cant_enq_tbtco_entry          = 3
        jobcount_generation_error     = 3
        OTHERS                        = 3.
    lv_msg = COND #( WHEN sy-subrc EQ 1 THEN `Unable to execute due to insufficient permissions`
                     WHEN sy-subrc EQ 2 THEN `Requested executable does not exist or is not accessible`
                     WHEN sy-subrc EQ 3 THEN `Uncaught error while executing the requested executable` ).

    IF lv_msg IS NOT INITIAL.
      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( lv_msg ).

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ENDIF.

    er_entity_set = lcl_utils=>copy_data_to_ref( ( abap_true ) ).
  ENDMETHOD.


  METHOD get_shift.
    DATA ls_result TYPE ty_shift.

    READ TABLE it_keys INTO DATA(ls_shiftid) WITH KEY name = 'SHIFTID'.

    SELECT SINGLE a~shiftid, b~shift_desc
        FROM zabsf_pp001 AS a
        INNER JOIN zabsf_pp001_t AS b
        ON a~shiftid = b~shiftid
        INTO @DATA(ls_shift)
        WHERE a~shiftid EQ @ls_shiftid-value.

    ls_result = VALUE #( shiftid = ls_shift-shiftid shiftdescription = ls_shift-shift_desc ).

    er_entity = lcl_utils=>copy_data_to_ref( ls_result ).
  ENDMETHOD.


  METHOD get_shifts.
    DATA: lt_return_tab TYPE bapiret2_t,
          lv_all_shift  TYPE flag,
          lt_shift_tab  TYPE zabsf_pp_t_shift,
          lv_time       TYPE atime,
          lv_refdt      TYPE vvdatum,
          lt_shifts     TYPE tt_shift.

    READ TABLE it_keys INTO DATA(ls_getall) WITH KEY name = 'GETALL'.
    READ TABLE it_keys INTO DATA(ls_startday) WITH KEY name = 'STARTDAY'.
    READ TABLE it_keys INTO DATA(ls_starthour) WITH KEY name = 'STARTHOUR'.

    lv_all_shift = COND #( WHEN ls_getall-value EQ 'true'
                                THEN abap_true
                                ELSE abap_false ).

    lv_refdt = COND #( WHEN ls_startday IS NOT INITIAL
                            THEN replace( val = ls_startday-value sub = '-' with = '' occ = 0 )
                            ELSE sy-datum ).

    lv_time = COND #( WHEN ls_startday IS NOT INITIAL AND ls_starthour IS NOT INITIAL
                           THEN COND #( WHEN strlen( ls_starthour-value ) EQ 8
                                             THEN replace( val = ls_starthour-value sub = ':' with = '' occ = 0 )
                                             ELSE replace( val = |{ ls_starthour-value }{ '00' }| sub = ':' with = '' occ = 0 ) )
                           ELSE sy-uzeit ).

    CALL FUNCTION 'ZABSF_PP_GETSHIFTS'
      EXPORTING
        areaid     = is_inputobj-areaid
        all_shift  = lv_all_shift
        time       = lv_time
        refdt      = lv_refdt
        inputobj   = is_inputobj
      IMPORTING
        shift_tab  = lt_shift_tab
        return_tab = lt_return_tab.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

    lt_shifts = VALUE #( FOR ls_shift IN lt_shift_tab ( shiftid = ls_shift-shiftid
                                                        shiftdescription = ls_shift-shift_desc ) ).

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_shifts ).
  ENDMETHOD.


  METHOD get_stockreportcenters.
    DATA: lt_return        TYPE bapiret2_t,
          lt_stock_deposit TYPE zabsf_pp_t_stock_deposit.

    DATA(lv_matnr) = VALUE matnr( it_keys[ name = 'MATERIAL' ]-value OPTIONAL ).
    DATA(lv_werks) = VALUE werks_d( it_keys[ name = 'PLANT' ]-value OPTIONAL ).
    DATA(lv_lgort) = VALUE werks_d( it_keys[ name = 'DEPOSIT' ]-value OPTIONAL ).
    DATA(lv_lgpbe) = VALUE lgpbe( it_keys[ name = 'LGPBE' ]-value OPTIONAL ).

    CALL FUNCTION 'ZABSF_PP_GET_STOCK_DEPOSIT'
      EXPORTING
        iv_matnr        = lv_matnr
        iv_werks        = lv_werks
        iv_lgort        = lv_lgort
        iv_lgpbe        = lv_lgpbe
        is_inputobj     = is_inputobj
      IMPORTING
        et_stockdeposit = lt_stock_deposit
        et_return       = lt_return.

    LOOP AT lt_stock_deposit ASSIGNING FIELD-SYMBOL(<fs_stock_deposit>).
      CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
        EXPORTING
          input  = <fs_stock_deposit>-matnr
        IMPORTING
          output = <fs_stock_deposit>-matnr.
    ENDLOOP.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return CHANGING co_msg = co_msg ).

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_stock_deposit ).

  ENDMETHOD.


  METHOD get_stopreason.
    DATA : lt_return_tab      TYPE bapiret2_t,
           lt_stop_reason_tab TYPE zabsf_pp_t_stop_reason,
           lt_stopreason      TYPE tt_stopreason.

    READ TABLE it_keys INTO DATA(ls_workcenterid) WITH KEY name = 'WORKCENTERID'.

    CALL FUNCTION 'ZABSF_PP_GETSTOP_REASON_WRK'
      EXPORTING
        arbpl           = CONV arbpl( ls_workcenterid-value )
        refdt           = sy-datum
        inputobj        = is_inputobj
      IMPORTING
        stop_reason_tab = lt_stop_reason_tab
        return_tab      = lt_return_tab.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

    lt_stopreason = VALUE #( FOR ls_stop_reason IN lt_stop_reason_tab ( id = ls_stop_reason-stprsnid
                                                                        stopreasondescription = ls_stop_reason-stprsn_desc
                                                                        maintenancerequesttype = ls_stop_reason-notif_type ) ).

    er_entity = lcl_utils=>copy_data_to_ref( lt_stopreason[ 1 ] ).
  ENDMETHOD.


  METHOD get_stopreasons.
    DATA : lt_return_tab      TYPE bapiret2_t,
           lt_stop_reason_tab TYPE STANDARD TABLE OF zabsf_pp_s_stop_reason,
           ls_stopreason      TYPE ty_stopreason,
           lt_stopreason      TYPE STANDARD TABLE OF ty_stopreason.

    READ TABLE it_keys INTO DATA(ls_workcenterid) WITH KEY name = 'WORKCENTERID'.

    CALL FUNCTION 'ZABSF_PP_GETSTOP_REASON_WRK'
      EXPORTING
        arbpl           = CONV arbpl( ls_workcenterid-value )
        refdt           = sy-datum
        inputobj        = is_inputobj
      IMPORTING
        stop_reason_tab = lt_stop_reason_tab
        return_tab      = lt_return_tab.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

    lt_stopreason = VALUE #( FOR ls_stop_reason IN lt_stop_reason_tab ( id = ls_stop_reason-stprsnid
                                                                        stopreasondescription = ls_stop_reason-stprsn_desc
                                                                        maintenancerequesttype = ls_stop_reason-notif_type ) ).

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_stopreason ).
  ENDMETHOD.


  METHOD get_systeminfos.
    DATA: lt_systeminfo    TYPE tt_systeminfo.

    lt_systeminfo = VALUE #( ( mandt = sy-mandt sysid = sy-sysid ) ).

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_systeminfo ).
  ENDMETHOD.


  METHOD get_timereportcenter.
    DATA : lt_orders_tab       TYPE STANDARD TABLE OF zabsf_pp_order_time_s,
           ls_timereportcenter TYPE ty_timereportcenter,
           lt_timereportcenter TYPE STANDARD TABLE OF ty_timereportcenter,
           ls_timereportorder  TYPE ty_timereportorder.

    READ TABLE it_keys INTO DATA(ls_workcenter) WITH KEY name = 'WORKCENTER'.
    READ TABLE it_keys INTO DATA(ls_project) WITH KEY name = 'PROJECT'.
    READ TABLE it_keys INTO DATA(ls_schematic) WITH KEY name = 'SCHEMATIC'.
    READ TABLE it_keys INTO DATA(ls_material) WITH KEY name = 'MATERIAL'.
    READ TABLE it_keys INTO DATA(ls_filterpas) WITH KEY name = 'FILTERPAS'.
    READ TABLE it_keys INTO DATA(ls_filtersas) WITH KEY name = 'FILTERSAS'.
    READ TABLE it_keys INTO DATA(ls_orderid) WITH KEY name = 'ORDERID'.

    CALL METHOD lcl_helper_timereportcenter=>zabsf_pp_orders_time
      EXPORTING
        inputobj      = is_inputobj
        iv_pf_var     = `abc`
        iv_arbpl_var  = CONV arbpl( ls_workcenter-value )
      IMPORTING
        et_orders_tab = lt_orders_tab.

    ls_timereportcenter-centerid = is_inputobj-werks.

    LOOP AT lt_orders_tab INTO DATA(ls_order) WHERE aufnr = ls_orderid-value.
      CLEAR ls_timereportorder.
      ls_timereportorder-centerid = is_inputobj-werks.
      ls_timereportorder-workcenterid = ls_workcenter-value.
      ls_timereportorder-project = ls_order-projecto.
      ls_timereportorder-schematics = ls_order-pep.
      ls_timereportorder-orderid = ls_order-aufnr.
      MOVE ls_order-machine_time TO ls_timereportorder-accumulatedmachinetime.
      MOVE ls_order-labor_time TO ls_timereportorder-accumulatedlabortime.
      MOVE ls_order-qty_confirmed TO ls_timereportorder-confirmedquantity.
      MOVE ls_order-qty_expected TO ls_timereportorder-plannedquantity.

      APPEND ls_timereportorder TO ls_timereportcenter-timereportorders.

    ENDLOOP.

    APPEND ls_timereportcenter TO lt_timereportcenter.

    es_entity = ls_timereportcenter.
    er_entity = lcl_utils=>copy_data_to_ref( ls_timereportcenter ).
  ENDMETHOD.


  METHOD get_treehierarchys.
    DATA: lt_return_tab              TYPE bapiret2_t,
          ls_inputobj                TYPE zabsf_pp_s_inputobject,
          lt_hierarchies_and_workcts TYPE zabsf_pp_t_wrkctr,
          lt_treehierarchies         TYPE tt_treehierarchy.

    ls_inputobj = is_inputobj.

    DATA(lv_centerid) = VALUE WERKS_D( it_keys[ name = 'CENTERID' ]-value OPTIONAL ).

    IF lv_centerid IS NOT INITIAL.
      ls_inputobj-werks = lv_centerid.
    ENDIF.

    CALL FUNCTION 'ZABSF_ADM_GET_HIERARCHIES'
      EXPORTING
        inputobj                = ls_inputobj
        refdt                   = sy-datum
      IMPORTING
        hierarchies_and_workcts = lt_hierarchies_and_workcts
        return_tab              = lt_return_tab.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

    lt_treehierarchies = VALUE #( FOR ls_hierarchies_and_workcts IN lt_hierarchies_and_workcts ( id          = ls_hierarchies_and_workcts-arbpl
                                                                                                 parentid    = ls_hierarchies_and_workcts-parent
                                                                                                 description = ls_hierarchies_and_workcts-ktext
                                                                                                 objty       = ls_hierarchies_and_workcts-objty
                                                                                                 prdty       = ls_hierarchies_and_workcts-prdty ) ).

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_treehierarchies ).
  ENDMETHOD.


  METHOD get_user.
    DATA ls_result TYPE ty_user.

    READ TABLE it_keys INTO DATA(ls_username) WITH KEY name = 'USERNAME'.

    " Get user data
    SELECT SINGLE a~username, a~usersap, a~name, a~roleid, b~description AS role, a~validfrom, a~validto,
                  a~userarea, a~userlanguage, a~center, a~userdownloadfolder, a~useruploadfolder, a~hierarchies,
                  a~workcenters, a~userjsoninfo, a~usererpid, a~usersupplierid
      FROM zsf_users AS a
      LEFT JOIN zsf_roles AS b
        ON a~roleid EQ b~id
      INTO @DATA(ls_users)
      WHERE a~username EQ @ls_username-value.

    ls_result = VALUE ty_user(
                        username = ls_users-username
                        usersap = ls_users-usersap
                        name = ls_users-name
                        roleid = ls_users-roleid
                        roledescription = ls_users-role
                        validfrom = ls_users-validfrom
                        validto = ls_users-validto
                        userarea = ls_users-userarea
                        userlanguage = ls_users-userlanguage
                        center = ls_users-center
                        userdownloadfolder = ls_users-userdownloadfolder
                        useruploadfolder = ls_users-useruploadfolder
                        hierarchies = ls_users-hierarchies
*                        workcenters = ls_users-workcenters
                        workcenters = VALUE #( FOR w IN zabsf_pp_cl_user=>get_userworkcenters( ls_users-username ) (
                                        id          = COND #( WHEN w-objty EQ 'A' THEN w-arbpl ELSE w-hname )
                                        parentid    = COND #( WHEN w-objty EQ 'A' THEN w-hname ELSE '' )
                                        description = w-ktext
                                        objty       = w-objty ) )
                        userjsoninfo = ls_users-userjsoninfo
                        usererpid = ls_users-usererpid
                        usersupplierid = ls_users-usersupplierid ).

    " Get authorization roles by user and serialize to json
    " [{"UserName":"1","AuthorizationRoleId":"ProductionRole"}]
    zabsf_pp_cl_authentication=>get_authorizationrolesuser(
      EXPORTING
        iv_username       = ls_users-username
        iv_serializejson  = ''
      IMPORTING
        es_authrole       = ls_result-authorizationroleid
    ).

    er_entity = lcl_utils=>copy_data_to_ref( ls_result ).
  ENDMETHOD.


  METHOD get_userareas.
    DATA: lt_return_tab TYPE bapiret2_t,
          lt_areas_tab  TYPE zabsf_pp_t_area_type_a,
          lt_userareas  TYPE tt_userarea.

    READ TABLE it_keys INTO DATA(ls_centerid) WITH KEY name = 'CENTERID'.
    READ TABLE it_keys INTO DATA(ls_areaid) WITH KEY name = 'AREAID'.

    DATA(ls_inputobj) = is_inputobj.
    ls_inputobj-areaid = ls_areaid-value.
    ls_inputobj-werks = ls_Centerid-value.

    CALL FUNCTION 'ZABSF_ADM_GETAREAS'
      EXPORTING
        refdt      = sy-datum
        inputobj   = ls_inputobj
      IMPORTING
        area_tab   = lt_areas_tab
        return_tab = lt_return_tab.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

    lt_userareas = VALUE #( FOR ls_area IN lt_areas_tab ( areaid = condense( val = ls_area-areaid from = `` )
                                                          areadescription = condense( val = ls_area-area_desc from = `` )
                                                          areatype = condense( val = ls_area-tarea_id from = `` ) ) ).

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_userareas ).
  ENDMETHOD.


  METHOD get_userlanguages.
    DATA: lt_return_tab    TYPE bapiret2_t,
          ls_inputobj      TYPE zabsf_pp_s_inputobject,
          lt_languages_tab TYPE zabsf_pp_t_languages,
          lt_result        TYPE tt_userlanguage.

    ls_inputobj = is_inputobj.

    READ TABLE it_keys INTO DATA(ls_centerid) WITH KEY name = 'CENTERID'.

    IF ls_centerid-value IS NOT INITIAL.
      ls_inputobj-werks = ls_centerid-value.
    ENDIF.

    CALL FUNCTION 'ZABSF_ADM_GETLANGUAGES'
      EXPORTING
        refdt         = sy-datum
        inputobj      = ls_inputobj
      IMPORTING
        languages_tab = lt_languages_tab
        return_tab    = lt_return_tab.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

    lt_result = VALUE #( FOR ls_laguages IN lt_languages_tab ( languageid = ls_laguages-laiso
                                                               languagedescription = COND #( WHEN ls_laguages-laiso EQ 'PT'
                                                                                                  THEN 'Português'
                                                                                             WHEN ls_laguages-laiso EQ 'EN'
                                                                                                  THEN 'Inglês'
                                                                                             WHEN ls_laguages-laiso EQ 'RU'
                                                                                                  THEN 'Russo' ) ) ).

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_result ).
  ENDMETHOD.


  METHOD get_users.
    DATA: ls_result TYPE ty_user,
          lt_result TYPE tt_user.

    " Get user data
    SELECT a~username, a~usersap, a~name, a~roleid, b~description AS role, a~validfrom, a~validto,
           a~userarea, a~userlanguage, a~center, a~userdownloadfolder, a~useruploadfolder, a~hierarchies,
           a~workcenters, a~userjsoninfo, a~usererpid, a~usersupplierid
      FROM zsf_users AS a
      LEFT JOIN zsf_roles AS b
        ON a~roleid EQ b~id
      INTO TABLE @DATA(lt_users).

    CHECK lt_users[] IS NOT INITIAL.

    DATA(lt_workcenters) =
      zabsf_pp_cl_user=>get_usersworkcenters( VALUE #( FOR u IN lt_users ( sign = 'I' option = 'EQ' low = u-username  ) ) ).

    LOOP AT lt_users ASSIGNING FIELD-SYMBOL(<fs_user>).
      CLEAR: ls_result, ls_result-workcenters[].
      ls_result = VALUE ty_user( username = <fs_user>-username
                                 usersap = <fs_user>-usersap
                                 name = <fs_user>-name
                                 roleid = <fs_user>-roleid
                                 roledescription = <fs_user>-role
                                 validfrom = <fs_user>-validfrom
                                 validto = <fs_user>-validto
                                 userarea = <fs_user>-userarea
                                 userlanguage = <fs_user>-userlanguage
                                 center = <fs_user>-center
                                 userdownloadfolder = <fs_user>-userdownloadfolder
                                 useruploadfolder = <fs_user>-useruploadfolder
                                 hierarchies = <fs_user>-hierarchies
*                                 workcenters = <fs_user>-workcenters
                                 userjsoninfo = <fs_user>-userjsoninfo
                                 usererpid = <fs_user>-usererpid
                                 usersupplierid = <fs_user>-usersupplierid ).

      ls_result-workcenters =
        VALUE #(
          FOR w IN lt_workcenters
            WHERE ( username EQ <fs_user>-username )
            ( id          = COND #( WHEN w-objty EQ 'A' THEN w-arbpl ELSE w-hname )
              parentid    = COND #( WHEN w-objty EQ 'A' THEN w-hname ELSE '' )
              description = w-ktext
              objty       = w-objty ) ).

      " Get authorization roles by user and serialize to json
      " [{"UserName":"1","AuthorizationRoleId":"ProductionRole"}]
      zabsf_pp_cl_authentication=>get_authorizationrolesuser(
        EXPORTING
          iv_username  = <fs_user>-username
          iv_serializejson = ''
        IMPORTING
          es_authrole       = ls_result-authorizationroleid
      ).

      APPEND ls_result TO lt_result.
    ENDLOOP.

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_result ).
  ENDMETHOD.


  METHOD get_usersap.
    DATA ls_result TYPE ty_usersap.

    READ TABLE it_keys INTO DATA(ls_usersap) WITH KEY name = 'USERSAP'.

    SELECT SINGLE usersap
        FROM zsf_userssap
      INTO @DATA(lv_usersap)
        WHERE usersap EQ @ls_usersap-value.

    ls_result = VALUE #( usersap = lv_usersap ).

    er_entity = lcl_utils=>copy_data_to_ref( ls_result ).
  ENDMETHOD.


  METHOD get_usersaps.
    DATA: lt_result TYPE tt_usersap.

    READ TABLE it_keys INTO DATA(ls_userid) WITH KEY name = 'USERID'.

    SELECT usersap
      FROM zsf_userssap
        WHERE usersap LIKE @ls_userid-value
           OR usersap IS NOT NULL
      INTO TABLE @DATA(lt_userssap).

    lt_result = VALUE #( FOR ls_userssap IN lt_userssap ( usersap = ls_userssap-usersap ) ).

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_result ).
  ENDMETHOD.


  METHOD get_workcenter.
    DATA: lt_return_tab         TYPE bapiret2_t,
          ls_wrkctr_detail      TYPE zabsf_pp_s_wrkctr_detail,
          ls_production         TYPE zabsf_pp_s_prdord_detail,
          ls_workcenter         TYPE ty_workcenter,
          ls_operator           TYPE ty_operator,
          ls_productionorderobj TYPE ty_productionorder,
          ls_operationobj       TYPE ty_operation,
          ls_scrapmissing       TYPE ty_scrapmissing,
          ls_missingpart        TYPE ty_missingpart,
          ls_multimaterial      TYPE ty_multimaterial,
          ls_operationoperator  TYPE ty_operationoperator,
          lt_reason_tab         TYPE zabsf_pp_t_reason,
          lt_defects_tab        TYPE zabsf_pp_t_defects.



    READ TABLE it_keys INTO DATA(ls_shiftid) WITH KEY name = 'SHIFTID'.
    READ TABLE it_keys INTO DATA(ls_hierarchyid) WITH KEY name = 'HIERARCHYID'.
    READ TABLE it_keys INTO DATA(ls_workcenterid) WITH KEY name = 'WORKCENTERID'.
    READ TABLE it_keys INTO DATA(ls_operationid) WITH KEY name = 'OPERATIONID'.
    READ TABLE it_keys INTO DATA(ls_productionorderid) WITH KEY name = 'PRODUCTIONORDERID'.
    READ TABLE it_keys INTO DATA(ls_currenttime) WITH KEY name = 'CURRENTTIME'.
    READ TABLE it_keys INTO DATA(ls_currentday) WITH KEY name = 'CURRENTDAY'.
    READ TABLE it_keys INTO DATA(ls_headeronly) WITH KEY name = 'HEADERONLY'.

    CALL FUNCTION 'ZABSF_PP_GETWRKCENTER_DETAIL'
      EXPORTING
        areadid       = is_inputobj-areaid
        werks         = is_inputobj-werks
        hname         = CONV cr_hname( ls_hierarchyid-value )
        arbpl         = CONV arbpl( ls_workcenterid-value )
        refdt         = sy-datum
        inputobj      = is_inputobj
        aufnr         = CONV aufnr( ls_productionorderid-value )
        vornr         = CONV vornr( ls_operationid-value )
      IMPORTING
        wrkctr_detail = ls_wrkctr_detail
        return_tab    = lt_return_tab.


    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

    ls_workcenter-id = ls_wrkctr_detail-arbpl.
    ls_workcenter-statusid = ls_wrkctr_detail-status.
    ls_workcenter-statusdescription = ls_wrkctr_detail-status_desc.
    ls_workcenter-workcenterdescription = ls_wrkctr_detail-ktext.

    ls_workcenter-showscraplist = COND #( WHEN ls_wrkctr_detail-flag_scrap_list EQ 'X'
                                          THEN abap_true
                                          ELSE abap_false ).
    ls_workcenter-checklistonly = COND #( WHEN ls_wrkctr_detail-checklist EQ 'X'
                                          THEN abap_true
                                          ELSE abap_false ).
    ls_workcenter-maintenanceorderid = ls_wrkctr_detail-pm_order.
    ls_workcenter-maintenancestageid = ls_wrkctr_detail-checklist_step.
    ls_workcenter-worktype = ls_wrkctr_detail-tip_trab.
    ls_workcenter-workcentertype = ls_wrkctr_detail-arbpl_type.

    LOOP AT ls_wrkctr_detail-oper_wrkctr_tab INTO DATA(ls_operatorobj).
      CLEAR ls_operator.
      ls_operator-id = ls_operatorobj-oprid.
      ls_operator-workcenterid = ls_wrkctr_detail-arbpl.
      ls_operator-operatorname = ls_operatorobj-nome.
      APPEND ls_operator TO ls_workcenter-availableoperators.
    ENDLOOP.

    LOOP AT ls_wrkctr_detail-prord_tab INTO DATA(ls_productionobj) WHERE status EQ 'INI' OR status EQ 'AGU'.
      CLEAR ls_productionorderobj.
      ls_productionorderobj-id = ls_productionobj-aufnr.
      ls_productionorderobj-workcenterid = ls_productionobj-arbpl.
      ls_productionorderobj-productionorderdescription = ls_productionobj-aufnr.
*      ls_productionorderobj-materialid = ls_productionobj-matnr.
      CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
        EXPORTING
          input  = ls_productionobj-matnr
        IMPORTING
          output = ls_productionorderobj-materialid.

      ls_productionorderobj-materialdescription = ls_productionobj-maktx.
      ls_productionorderobj-typeid = ls_productionobj-tipord.
      ls_productionorderobj-productionordertype = ls_productionobj-auart.

      CLEAR ls_operationobj.



*BEGIN AON - 29/11/2022 - Get Equipment for Production order
      SELECT SINGLE equipment
      FROM  zabsf_pp_operequ
      WHERE  areaid EQ @is_inputobj-areaid AND  prodorder EQ @ls_productionorderid-value  AND  operation EQ @ls_operationid-value
      INTO @DATA(lv_equipmentop).
      IF sy-subrc = 0.
        ls_operationobj-equipment = lv_equipmentop.
      ENDIF.
** END ADR.

      ls_operationobj-id = ls_productionobj-vornr.
      ls_operationobj-productionorderid = ls_productionobj-aufnr.
      ls_operationobj-workcenterid = ls_productionobj-arbpl.
      ls_operationobj-operationdescription = ls_productionobj-ltxa1.
*      ls_operationobj-materialid = ls_productionobj-matnr.
      CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
        EXPORTING
          input  = ls_productionobj-matnr
        IMPORTING
          output = ls_operationobj-materialid.

      ls_operationobj-materialdescription = ls_productionobj-maktx.
      ls_operationobj-programeddate = |{ ls_productionobj-gstrs } { ls_productionobj-gsuzs }|.
      ls_operationobj-statusid = ls_productionobj-status_oper.
      ls_operationobj-boxbundle = ls_productionobj-prdqty_box.
      ls_operationobj-bundlevalue = ls_productionobj-boxqty.
      ls_operationobj-quantitymade = ls_productionobj-lmnga.
      ls_operationobj-quantityrework = ls_productionobj-rmnga.
      ls_operationobj-quantityscrap = ls_productionobj-xmnga.
      ls_operationobj-goodquantity = COND #( WHEN ls_productionobj-missingqty LT 0
                                          THEN 0
                                          ELSE '' ).



      ls_operationobj-quantitymissing = ls_productionobj-missingqty.
      ls_operationobj-quantitytomake = ls_productionobj-gamng.
      IF ( ls_productionobj-aplzl = '00000001') .
        ls_operationobj-accumulatedquantity = ls_productionobj-missingqty.
      ELSE.
        ls_operationobj-accumulatedquantity = ls_productionobj-qty_proc.
      ENDIF.

      ls_operationobj-numberoperationstoend = ls_productionobj-vornr_tot.
      ls_operationobj-typeid = ls_productionobj-tipord.
      ls_operationobj-productionordertype = ls_productionobj-auart.
      ls_operationobj-reprogproductionorder = COND #( WHEN ls_productionobj-date_reprog EQ 'X'
                                                   THEN abap_true
                                                   ELSE abap_false ).
      ls_operationobj-alerttext = ls_productionobj-zerma_txt.

      ls_operationobj-iinfo-arbpl = ls_productionobj-arbpl.
      ls_operationobj-iinfo-aplzl = ls_productionobj-aplzl.
      ls_operationobj-iinfo-aufpl = ls_productionobj-aufpl.
      ls_operationobj-iinfo-rueck = ls_productionobj-rueck.
*      ls_operationobj-iinfo-matnr = ls_productionobj-matnr.
      CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
        EXPORTING
          input  = ls_productionobj-matnr
        IMPORTING
          output = ls_operationobj-iinfo-matnr.

      ls_operationobj-iinfo-tipord = ls_productionobj-tipord.
      ls_operationobj-iinfo-wareid = ls_productionobj-wareid.

      ls_operationobj-initialcyclecounter = COND #( WHEN ls_productionobj-count_ini IS NOT INITIAL
                                                 THEN ls_productionobj-count_ini
                                                 ELSE 0 ).

      ls_operationobj-totalmissingquantity = ''.
      ls_operationobj-totalqtyalreadyregistered = ls_productionobj-total_qty.
      ls_operationobj-operatorid = COND #( WHEN ls_productionobj-cname IS NOT INITIAL
                                        THEN is_inputobj-oprid ).
      ls_operationobj-operatorname = ls_productionobj-cname.
      ls_operationobj-operatorqualificationid = ls_productionobj-quali.
      ls_operationobj-operatorqualificationdescripti = ls_productionobj-qtext.
      IF ls_productionobj-status_oper NE 'INI' AND ls_productionobj-status_oper NE 'AGU'.
        ls_operationobj-scheduleid = ls_productionobj-schedule_id.
        ls_operationobj-scheduledescription = ls_productionobj-schedule_desc.
        ls_operationobj-regimeid = ls_productionobj-regime_id.
        ls_operationobj-regimedescription = ls_productionobj-regime_desc.
      ENDIF.
      ls_operationobj-currenttheoreticalcyclecounter = ls_productionobj-time_mcycle.
      ls_operationobj-totaltheoreticalquantity = ls_productionobj-numb_mcycle.
      ls_operationobj-currentrealcyclecounter = ls_productionobj-numb_cycle.
      ls_operationobj-theoreticalquantity = ls_productionobj-theoretical_qty.
      ls_operationobj-operationlot = ls_productionobj-batch.
      ls_operationobj-operationpallet = ls_productionobj-lenum.
      ls_operationobj-alternateunit = ls_productionobj-unit_alt.
* Start Change ABACO(AON): 26.12.2022
* Description: Convert unit to localized string
*      ls_operationobj-unitgmein = ls_productionobj-gmein.
      CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
        EXPORTING
          input          = ls_productionobj-gmein
          language       = sy-langu
        IMPORTING
          output         = ls_operationobj-unitgmein
        EXCEPTIONS
          unit_not_found = 1
          OTHERS         = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
        ls_operationobj-unitgmein = ls_productionobj-gmein.
      ENDIF.
* End Change ABACO(AON): 26.12.2022
      ls_operationobj-marcooperation = COND #( WHEN ls_productionobj-marco EQ 'X'
                                            THEN abap_true
                                            ELSE abap_false ).
      ls_operationobj-inksugestedtemperature = 20.
      ls_operationobj-mininktemperature = 18.
      ls_operationobj-maxinktemperature = 22.

      ls_operationobj-goodquantityoperator = ls_productionobj-lmnga_card.
      ls_operationobj-scrapquantityoperator = ls_productionobj-xmnga_card.
      ls_operationobj-islotoperation = COND #( WHEN ls_productionobj-autwe IS NOT INITIAL AND ls_productionobj-autwe EQ 'X'
                                            THEN abap_true
                                            ELSE abap_false ).
      ls_operationobj-unitvalue = COND #( WHEN ls_productionobj-units IS NOT INITIAL
                                          THEN ls_productionobj-units[ 1 ]-meinh ).
      ls_operationobj-unitgmein = COND #( WHEN ls_operationobj-unitvalue EQ 'KI'
                                       THEN 'CX'
                                       ELSE ls_operationobj-unitgmein ).
      ls_operationobj-unittype = 'NoRetribeBox'.
      ls_operationobj-traceability = COND #( WHEN ls_productionobj-traceability EQ 'X'
                                          THEN 'RAST' ).

      IF ls_headeronly-value NE 'true'.
        DATA: lv_username TYPE string,
              lv_name     TYPE string,
              ls_user     TYPE zsf_users.

        LOOP AT ls_productionobj-oprid_tab INTO ls_operatorobj.
          CLEAR:
            lv_username,
            lv_name.

          SELECT SINGLE *
            FROM zsf_users
            WHERE usererpid EQ @ls_operatorobj-oprid
            INTO @ls_user.

          IF sy-subrc IS NOT INITIAL.
            SELECT SINGLE *
            FROM zsf_users
            WHERE username EQ @ls_operatorobj-oprid
            INTO @ls_user.
          ENDIF.

          IF sy-subrc IS INITIAL.
            lv_username = ls_user-username.
            lv_name = ls_user-name.
          ENDIF.

          "Loop OperationOperator, Defect, ScrapMissing
          CLEAR ls_operationoperator.
          ls_operationoperator-workcenterid = ls_wrkctr_detail-arbpl.
          ls_operationoperator-productionorderid = ls_productionobj-aufnr.
          ls_operationoperator-operationid = ls_productionobj-vornr.
          ls_operationoperator-operatorid = COND #( WHEN lv_username IS NOT INITIAL
                                          THEN lv_username
                                          ELSE ls_operatorobj-oprid ).
          ls_operationoperator-operatorname = COND #( WHEN lv_username IS NOT INITIAL
                                          THEN lv_name
                                          ELSE ls_operatorobj-nome ).
          ls_operationoperator-status = 'A'.
          APPEND ls_operationoperator TO ls_workcenter-assignedoperators.
        ENDLOOP.

        IF ( ls_operationobj-statusid EQ 'PREP' OR ls_operationobj-statusid EQ 'PROC' )
          AND ls_operationid-value EQ ls_productionobj-vornr
          AND ls_productionorderid-value EQ ls_productionobj-aufnr.

          CALL FUNCTION 'ZABSF_PP_GETDEFECTS'
            EXPORTING
              arbpl           = CONV arbpl( ls_workcenterid-value )
              matnr           = CONV matn1( ls_operationobj-materialid )
              aufnr           = CONV aufnr( ls_operationobj-productionorderid )
              vornr           = CONV vornr( ls_operationobj-id )
              reasontyp       = 'D'
              flag_scrap_list = 'X'
              refdt           = sy-datum
              inputobj        = is_inputobj
            IMPORTING
              reason_tab      = lt_reason_tab
              defects_tab     = lt_defects_tab.

          LOOP AT lt_reason_tab INTO DATA(ls_scrap).
            CLEAR ls_scrapmissing.
            ls_scrapmissing-id = ls_scrap-grund.
            ls_scrapmissing-scrapdescription = ls_scrap-grdtx.
            ls_scrapmissing-operationid = ls_operationobj-id.
            ls_scrapmissing-productionorderid = ls_operationobj-productionorderid.
            ls_scrapmissing-scrapalreadyregistered = ls_scrap-scrap_qty.
            ls_scrapmissing-workcenterid = ls_workcenterid-value.
            APPEND ls_scrapmissing TO ls_operationobj-scrapsmissing.
          ENDLOOP.
*ADR apanhar defetos da tabela de configurações que são agora retornados na tabela GetDefects
          LOOP AT lt_defects_tab INTO DATA(ls_defects).
            CLEAR ls_scrapmissing.
            ls_scrapmissing-id = ls_defects-defectid.
            ls_scrapmissing-scrapdescription = ls_defects-defect_desc.
            ls_scrapmissing-operationid = ls_operationobj-id.
            ls_scrapmissing-productionorderid = ls_operationobj-productionorderid.
            ls_scrapmissing-scrapalreadyregistered = 0.
            ls_scrapmissing-workcenterid = ls_workcenterid-value.
            APPEND ls_scrapmissing TO ls_operationobj-scrapsmissing.
          ENDLOOP.

        ENDIF.
      ENDIF.

      ls_operationobj-project = ls_productionobj-project.
      ls_operationobj-schematics = ls_productionobj-schematics.
      ls_operationobj-componentschecked = ls_productionobj-components_checked.
      ls_operationobj-availabilitystatus = ls_productionobj-missing_parts.
      ls_operationobj-availabilityoverride = ls_productionobj-override.
      ls_operationobj-availabilitycolour = ls_productionobj-status_color.
      ls_operationobj-pf = ls_productionobj-production_plan.
      ls_operationobj-productionplanid = ls_productionobj-program.
      ls_operationobj-workcenterpositionid = ls_productionobj-kapid.
      ls_operationobj-workcenterpositionname = ls_productionobj-name.
      ls_operationobj-workcenterpositiondescription = ls_productionobj-ktext.
      ls_operationobj-ordersequencenumber = ls_productionobj-cy_seqnr.
      ls_operationobj-sequence = sy-tabix.
      ls_operationobj-traceability = COND #( WHEN ls_productionobj-traceability EQ 'X'
                                          THEN 'RAST' ).
      ls_operationobj-ismultimaterial = COND #( WHEN ls_productionobj-multimaterial EQ 'X'
                                             THEN abap_true
                                             ELSE abap_false ).
      ls_operationobj-ispreviousoperationnecessary = COND #( WHEN ls_productionobj-read_label EQ 'X'
                                                          THEN abap_true
                                                          ELSE abap_false ).
      ls_operationobj-ismmbatchvalidationnecessary = COND #( WHEN ls_productionobj-batch_validation EQ 'X'
                                                          THEN abap_true
                                                          ELSE abap_false ).

      IF ls_headeronly-value NE 'true'.

        LOOP AT ls_productionobj-availability_information INTO DATA(ls_missingpart2).
          CLEAR ls_missingpart.
          ls_missingpart-materialid = sy-tabix - 1.
          ls_missingpart-operationid = ls_operationobj-id.
          ls_missingpart-productionorderid = ls_operationobj-productionorderid.
          ls_missingpart-workcenterid = ls_operationobj-workcenterid.
          ls_missingpart-materialdescription = ls_missingpart2-message.
          ls_missingpart-quantitymissing = 0.
          ls_missingpart-project = ls_operationobj-project.
          ls_missingpart-schematics = ls_operationobj-schematics.
          APPEND ls_missingpart TO ls_operationobj-missingparts.
        ENDLOOP.

        LOOP AT ls_productionobj-components INTO DATA(ls_component).
          CLEAR ls_multimaterial.
*          ls_multimaterial-materialid = ls_component-matnr.
          CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
            EXPORTING
              input  = ls_component-matnr
            IMPORTING
              output = ls_multimaterial-materialid.

          ls_multimaterial-reservenumber = ls_component-rsnum.
          ls_multimaterial-reserveitem = ls_component-rspos.
          ls_multimaterial-operationid = ls_operationobj-id.
          ls_multimaterial-productionorderid = ls_operationobj-productionorderid.
          ls_multimaterial-workcenterid = ls_operationobj-workcenterid.
          ls_multimaterial-batchid = ls_component-batch.
          ls_multimaterial-lgort = ls_component-lgort.
          ls_multimaterial-sobkz = ls_component-sobkz.
          ls_multimaterial-vornr = ls_operationobj-id.
          ls_multimaterial-materialdescription = ls_component-maktx.
          ls_multimaterial-quantitytomake = ls_component-bdmng * -1.
          ls_multimaterial-quantitymade = ls_component-enmng.
          ls_multimaterial-quantityrework  = 0.
          ls_multimaterial-quantityscrap = 0.
          ls_multimaterial-quantitymissing = ls_component-consqty.
          ls_multimaterial-bundlevalue = 0.
          ls_multimaterial-boxbundle = 0.
          ls_multimaterial-goodquantity = COND #( WHEN ls_component-consqty GT 0
                                                  THEN ls_component-consqty
                                                  ELSE 0 ).
          ls_multimaterial-unitgmein = ls_component-meins.
          ls_multimaterial-project = ls_operationobj-project.
          ls_multimaterial-schematics = ls_operationobj-schematics.
          APPEND ls_multimaterial TO ls_operationobj-multimaterials.
        ENDLOOP.

      ENDIF.

      APPEND ls_operationobj TO ls_workcenter-operations.
      APPEND ls_productionorderobj TO ls_workcenter-productionorders.
    ENDLOOP.

    ls_workcenter-outputsettings_batchgeneration = COND #( WHEN ls_wrkctr_detail-output_settings-batch_generation EQ 'X'
                                                           THEN abap_true
                                                           ELSE abap_false ).
    ls_workcenter-outputsettings_batchvalidation = COND #( WHEN ls_wrkctr_detail-output_settings-batch_validation EQ 'X'
                                                           THEN abap_true
                                                           ELSE abap_false ).
    ls_workcenter-outputsettings_btstart1stcycle = COND #( WHEN ls_wrkctr_detail-output_settings-bt_start_1st_cycle EQ 'X'
                                                           THEN abap_true
                                                           ELSE abap_false ).
    ls_workcenter-outputsettings_btstartlaunch = COND #( WHEN ls_wrkctr_detail-output_settings-bt_start_launch EQ 'X'
                                                         THEN abap_true
                                                         ELSE abap_false ).
    ls_workcenter-outputsettings_consumptions = COND #( WHEN ls_wrkctr_detail-output_settings-consumptions EQ 'X'
                                                        THEN abap_true
                                                        ELSE abap_false ).
    ls_workcenter-outputsettings_onlymarcoops = COND #( WHEN ls_wrkctr_detail-output_settings-only_marco_ops EQ 'X'
                                                        THEN abap_true
                                                        ELSE abap_false ).
    ls_workcenter-outputsettings_goodqttmarco = COND #( WHEN ls_wrkctr_detail-output_settings-good_qtt_marco EQ 'X'
                                                        THEN abap_true
                                                        ELSE abap_false ).
    ls_workcenter-outputsettings_scrapqttmarco = COND #( WHEN ls_wrkctr_detail-output_settings-scrap_qtt_marco EQ 'X'
                                                         THEN abap_true
                                                         ELSE abap_false ).
    ls_workcenter-outputsettings_prodinfo = COND #( WHEN ls_wrkctr_detail-output_settings-prod_info EQ 'X'
                                                    THEN abap_true
                                                    ELSE abap_false ).
    ls_workcenter-outputsettings_qualifications = COND #( WHEN ls_wrkctr_detail-output_settings-qualifications EQ 'X'
                                                          THEN abap_true
                                                          ELSE abap_false ).
    ls_workcenter-outputsettings_schedulesandreg = abap_true.
    ls_workcenter-showtransferlabel = COND #( WHEN ls_wrkctr_detail-print_label EQ 'X'
                                              THEN abap_true
                                              ELSE abap_false ).

    er_entity = lcl_utils=>copy_data_to_ref( ls_workcenter ).
  ENDMETHOD.


  METHOD get_workcenteroee.
    DATA : lt_return_tab           TYPE bapiret2_t,
           lt_workcenter_dashboard TYPE STANDARD TABLE OF zabsf_pp_s_workcenter_dashboar,
           ls_hierarchies          TYPE zabsf_pp_s_hrchy,
           lt_hierarchies          TYPE STANDARD TABLE OF zabsf_pp_s_hrchy,
           ls_workcenteroee        TYPE ty_workcenteroee,
           ls_operatoroee          TYPE ty_operatoroee.

    READ TABLE it_keys INTO DATA(ls_shiftid) WITH KEY name = 'SHIFTID'.
    READ TABLE it_keys INTO DATA(ls_hierarchyid) WITH KEY name = 'HIERARCHYID'.
    READ TABLE it_keys INTO DATA(ls_selectedhierarchies) WITH KEY name = 'SELECTEDHIERARCHIES'.

    SPLIT ls_selectedhierarchies-value AT ';' INTO TABLE DATA(lt_selectedhierarchies).

    LOOP AT lt_selectedhierarchies INTO DATA(ls_hf).
      CLEAR ls_hierarchies.
      ls_hierarchies-hname = ls_hf.
      REPLACE ALL OCCURRENCES OF '\' IN ls_hierarchies-hname WITH ''.
      REPLACE ALL OCCURRENCES OF '[' IN ls_hierarchies-hname WITH ''.
      REPLACE ALL OCCURRENCES OF ']' IN ls_hierarchies-hname WITH ''.
      CONDENSE ls_hierarchies-hname.
      APPEND ls_hierarchies TO lt_hierarchies.
    ENDLOOP.

    CALL FUNCTION 'ZABSF_PP_GET_WORKCENTER_DASH'
      EXPORTING
        inputobj             = is_inputobj
        arbpl                = ''
        refdt                = sy-datum
        hierarchies          = lt_hierarchies
        hname                = CONV cr_hname( ls_hierarchyid-value )
      IMPORTING
        workcenter_dashboard = lt_workcenter_dashboard
        return_tab           = lt_return_tab.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

    DATA: lv_username TYPE string,
          lv_name     TYPE string,
          ls_user     TYPE zsf_users.

    LOOP AT lt_workcenter_dashboard INTO DATA(ls_workcenter).
      CLEAR ls_workcenteroee.

      LOOP AT ls_workcenter-logged_users INTO DATA(ls_order_operator).
        CLEAR ls_operatoroee.
        SELECT SINGLE *
          FROM zsf_users
          WHERE usererpid EQ @ls_order_operator-oprid
          INTO @ls_user.

        IF ls_user IS NOT INITIAL.
          lv_username = ls_user-username.
          lv_name = ls_user-name.
        ELSE.
          SELECT SINGLE *
          FROM zsf_users
          WHERE username EQ @ls_order_operator-oprid
          INTO @ls_user.

          lv_username = ls_user-username.
          lv_name = ls_user-name.
        ENDIF.

        ls_operatoroee-id = COND #( WHEN lv_username IS NOT INITIAL
                                    THEN lv_username
                                    ELSE ls_order_operator-oprid ).
        ls_operatoroee-operatorname = COND #( WHEN lv_username IS NOT INITIAL
                                              THEN lv_name
                                              ELSE ls_order_operator-nome ).
        ls_operatoroee-workcenteroeeid = ls_workcenter-workcenter_id.
        APPEND ls_operatoroee TO ls_workcenteroee-operatorsoee.
      ENDLOOP.

      ls_workcenteroee-id = ls_workcenter-workcenter_id.
      ls_workcenteroee-workcenterdescription = ls_workcenter-workcenter_description.
      ls_workcenteroee-statusid = ls_workcenter-current_status.
      ls_workcenteroee-statusdescription = ''.

      DATA: lv_timestamp TYPE timestamp,
            lv_systemtz  TYPE timezone.

      CALL FUNCTION 'GET_SYSTEM_TIMEZONE'
        IMPORTING
          timezone = lv_systemtz.

      CONVERT DATE ls_workcenter-start_date TIME ls_workcenter-start_hour INTO TIME STAMP lv_timestamp TIME ZONE lv_systemtz.

      ls_workcenteroee-statusdate = |{ lv_timestamp TIMESTAMP = SPACE }|. "TODO: Verificar

      ls_workcenteroee-materialid = ls_workcenter-material_id.
      ls_workcenteroee-hierarchyid = ls_workcenter-hname.
      ls_workcenteroee-productionorderid = ls_workcenter-aufnr.
      ls_workcenteroee-operationid = ls_workcenter-vornr.
      ls_workcenteroee-qtydefectsinsheet = ls_workcenter-prd_sheet_defects.
      ls_workcenteroee-stoptime = ls_workcenter-status_hours_ago.
      ls_workcenteroee-stopreason = ls_workcenter-stop_reason_desc.
    ENDLOOP.

    er_entity = lcl_utils=>copy_data_to_ref( ls_workcenteroee ).
  ENDMETHOD.


  METHOD get_workcenteroees.
    DATA : lt_return_tab           TYPE bapiret2_t,
           lt_workcenter_dashboard TYPE STANDARD TABLE OF zabsf_pp_s_workcenter_dashboar,
           ls_hierarchies          TYPE zabsf_pp_s_hrchy,
           lt_hierarchies          TYPE STANDARD TABLE OF zabsf_pp_s_hrchy,
           ls_workcenteroee        TYPE ty_workcenteroee,
           lt_workcenteroee        TYPE tt_workcenteroee,
           ls_operatoroee          TYPE ty_operatoroee.

    DATA(lv_shiftid) = VALUE #( it_keys[ name = 'SHIFTID' ]-value OPTIONAL ).
    DATA(lv_hierarchyid) = VALUE #( it_keys[ name = 'HIERARCHYID' ]-value OPTIONAL ).
    DATA(lv_selectedhierarchies) = VALUE #( it_keys[ name = 'SELECTEDHIERARCHIES' ]-value OPTIONAL ).

    SPLIT lv_selectedhierarchies AT ';' INTO TABLE DATA(lt_selectedhierarchies).

    LOOP AT lt_selectedhierarchies INTO DATA(ls_hf).
      CLEAR ls_hierarchies.
      ls_hierarchies-hname = ls_hf.
      REPLACE ALL OCCURRENCES OF '\' IN ls_hierarchies-hname WITH ''.
      REPLACE ALL OCCURRENCES OF '[' IN ls_hierarchies-hname WITH ''.
      REPLACE ALL OCCURRENCES OF ']' IN ls_hierarchies-hname WITH ''.
      CONDENSE ls_hierarchies-hname.
      APPEND ls_hierarchies TO lt_hierarchies.
    ENDLOOP.

    CALL FUNCTION 'ZABSF_PP_GET_WORKCENTER_DASH'
      EXPORTING
        inputobj             = is_inputobj
        arbpl                = ''
        refdt                = sy-datum
        hierarchies          = lt_hierarchies
        hname                = CONV cr_hname( lv_hierarchyid )
      IMPORTING
        workcenter_dashboard = lt_workcenter_dashboard
        return_tab           = lt_return_tab.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

    DATA: lv_username TYPE string,
          lv_name     TYPE string,
          ls_user     TYPE zsf_users.

    LOOP AT lt_workcenter_dashboard INTO DATA(ls_workcenter).
      CLEAR ls_workcenteroee.

      LOOP AT ls_workcenter-logged_users INTO DATA(ls_order_operator).
        CLEAR ls_operatoroee.
        SELECT SINGLE *
          FROM zsf_users
          WHERE usererpid EQ @ls_order_operator-oprid
          INTO @ls_user.

        IF ls_user IS NOT INITIAL.
          lv_username = ls_user-username.
          lv_name = ls_user-name.
        ELSE.
          SELECT SINGLE *
          FROM zsf_users
          WHERE username EQ @ls_order_operator-oprid
          INTO @ls_user.

          lv_username = ls_user-username.
          lv_name = ls_user-name.
        ENDIF.

        ls_operatoroee-id = COND #( WHEN lv_username IS NOT INITIAL
                                    THEN lv_username
                                    ELSE ls_order_operator-oprid ).
        ls_operatoroee-operatorname = COND #( WHEN lv_username IS NOT INITIAL
                                              THEN lv_name
                                              ELSE ls_order_operator-nome ).
        ls_operatoroee-workcenteroeeid = ls_workcenter-workcenter_id.
        APPEND ls_operatoroee TO ls_workcenteroee-operatorsoee.
      ENDLOOP.

      DATA lv_endda TYPE iwexfdate VALUE '00000000'.
      DATA lv_datesr TYPE zabsf_pp_e_date.
      DATA workcenterid TYPE arbpl .

      workcenterid = ls_workcenter-workcenter_id.
*BEGIN ADR - 07/10/2022 - Add description stop workcenter
      SELECT SINGLE stoptext~stprsn_desc
                  FROM  zabsf_pp010   AS regstop
        INNER JOIN zabsf_pp011_t   AS stoptext ON stoptext~werks EQ regstop~werks AND stoptext~stprsnid EQ regstop~stprsnid AND stoptext~areaid EQ regstop~areaid AND stoptext~arbpl EQ regstop~arbpl
                  WHERE  regstop~arbpl EQ @workcenterid AND  regstop~werks EQ @is_inputobj-werks AND  regstop~areaid EQ @is_inputobj-areaid
          AND regstop~endda  EQ @lv_endda
                  INTO @DATA(statusstopdescription).
*AND regstop~datesr EQ @sy-datum
      IF sy-subrc = 0.
        ls_workcenteroee-statusstopdescription = statusstopdescription.
        CLEAR statusstopdescription.
      ENDIF.
** END ADR.

      ls_workcenteroee-id = ls_workcenter-workcenter_id.
      ls_workcenteroee-workcenterdescription = ls_workcenter-workcenter_description.
      ls_workcenteroee-statusid = ls_workcenter-current_status.
      ls_workcenteroee-statusdescription = ''.

      DATA: lv_timestamp TYPE timestamp,
            lv_systemtz  TYPE timezone.

      CALL FUNCTION 'GET_SYSTEM_TIMEZONE'
        IMPORTING
          timezone = lv_systemtz.

      CONVERT DATE ls_workcenter-start_date TIME ls_workcenter-start_hour INTO TIME STAMP lv_timestamp TIME ZONE lv_systemtz.

      ls_workcenteroee-statusdate = |{ lv_timestamp TIMESTAMP = SPACE }|. "TODO: Verificar

      ls_workcenteroee-materialid = ls_workcenter-material_id.
      ls_workcenteroee-hierarchyid = ls_workcenter-hname.
      ls_workcenteroee-productionorderid = ls_workcenter-aufnr.
      ls_workcenteroee-operationid = ls_workcenter-vornr.
      ls_workcenteroee-qtydefectsinsheet = ls_workcenter-prd_sheet_defects.
      ls_workcenteroee-stoptime = ls_workcenter-status_hours_ago.
      ls_workcenteroee-stopreason = ls_workcenter-stop_reason_desc.
      APPEND ls_workcenteroee TO lt_workcenteroee.
    ENDLOOP.

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_workcenteroee ).
  ENDMETHOD.


  METHOD get_workcenteroperation.
    DATA:
      lt_return     TYPE bapiret2_t,
      lv_langu      TYPE sy-langu,
      ls_workcenter TYPE ty_workcenteroperation.

    DATA(lv_operation) = VALUE vornr( it_keys[ name = 'OPERATIONID' ]-value OPTIONAL ).
    DATA(lv_productionorder) = VALUE aufnr( it_keys[ name = 'PRODUCTIONORDERID' ]-value OPTIONAL ).

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lv_productionorder
      IMPORTING
        output = lv_productionorder.

    IF lv_operation IS NOT INITIAL AND lv_productionorder IS NOT INITIAL.
      SELECT SINGLE afvc~arbid, crhd~arbpl
        INTO @DATA(ls_workcenter_aux)
        FROM afko AS afko
        INNER JOIN afvc AS afvc
        ON afvc~aufpl EQ afko~aufpl
        INNER JOIN crhd AS crhd
        ON crhd~objid EQ afvc~arbid
        WHERE afko~aufnr EQ @lv_productionorder
        AND afvc~vornr EQ @lv_operation.

      IF ls_workcenter_aux IS NOT INITIAL.
        ls_workcenter = VALUE ty_workcenteroperation( workcenterid = ls_workcenter_aux-arbpl ).

*get description of workcenter
        SELECT SINGLE ktext
          FROM crtx
          INTO ls_workcenter-workcenterdescription
         WHERE objty EQ 'A'
           AND objid EQ ls_workcenter_aux-arbid
           AND spras EQ sy-langu.

        IF ls_workcenter-workcenterdescription IS INITIAL.
          CLEAR lv_langu.

*  Get alternative language
          SELECT SINGLE spras
            FROM zabsf_pp061
            INTO lv_langu
           WHERE werks EQ is_inputobj-werks
             AND is_default NE space.

          IF sy-subrc EQ 0.
*    Get description of workcenter with alternative language
            SELECT SINGLE ktext
              FROM crtx
              INTO ls_workcenter-workcenterdescription
             WHERE objty EQ 'A'
               AND objid EQ ls_workcenter_aux-arbid
               AND spras EQ lv_langu.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return CHANGING co_msg = co_msg ).

    er_entity = lcl_utils=>copy_data_to_ref( ls_workcenter ).
  ENDMETHOD.


  METHOD get_workcenterposition.
    DATA : lt_return_tab         TYPE bapiret2_t,
           lt_work_stations      TYPE STANDARD TABLE OF zabsf_pp_s_workstation,
           lt_workcenterposition TYPE tt_workcenterposition.

    READ TABLE it_keys INTO DATA(ls_workcenterid) WITH KEY name = 'WORKCENTERID'.

    CALL FUNCTION 'ZABSF_PP_GET_WORK_STATIONS'
      EXPORTING
        arbpl         = CONV arbpl( ls_workcenterid-value )
        refdt         = sy-datum
        inputobj      = is_inputobj
      IMPORTING
        work_stations = lt_work_stations
        return_tab    = lt_return_tab.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

    lt_workcenterposition = VALUE #( FOR ls_workcenter_position IN lt_work_stations ( id = ls_workcenter_position-kapid
                                                                                      name = ls_workcenter_position-name
                                                                                      description = ls_workcenter_position-ktext ) ).

    er_entity = lcl_utils=>copy_data_to_ref( lt_workcenterposition[ 1 ] ).
  ENDMETHOD.


  METHOD get_workcenterpositions.
    DATA : lt_return_tab         TYPE bapiret2_t,
           lt_work_stations      TYPE STANDARD TABLE OF zabsf_pp_s_workstation,
           lt_workcenterposition TYPE tt_workcenterposition.

    READ TABLE it_keys INTO DATA(ls_workcenterid) WITH KEY name = 'WORKCENTERID'.

    CALL FUNCTION 'ZABSF_PP_GET_WORK_STATIONS'
      EXPORTING
        arbpl         = CONV arbpl( ls_workcenterid-value )
        refdt         = sy-datum
        inputobj      = is_inputobj
      IMPORTING
        work_stations = lt_work_stations
        return_tab    = lt_return_tab.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

    lt_workcenterposition = VALUE #( FOR ls_workcenter_position IN lt_work_stations ( id = ls_workcenter_position-kapid
                                                                                      name = ls_workcenter_position-name
                                                                                      description = ls_workcenter_position-ktext ) ).

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_workcenterposition ).
  ENDMETHOD.


  METHOD get_workcenters.
    DATA: lv_hname        TYPE cr_hname,
          lt_return_tab   TYPE bapiret2_t,
          ls_hrchy_detail TYPE zabsf_pp_s_hrchy_detail,
          lt_workcenter   TYPE tt_workcenter.

    CALL FUNCTION 'ZABSF_PP_GETHRCHY_DETAIL'
      EXPORTING
        areaid       = is_inputobj-areaid
        hname        = lv_hname
        refdt        = sy-datum
        inputobj     = is_inputobj
      IMPORTING
        hrchy_detail = ls_hrchy_detail
        return_tab   = lt_return_tab.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

    lt_workcenter = VALUE #( FOR ls_wrkctr IN ls_hrchy_detail-wrkctr_tab ( id                    = ls_wrkctr-arbpl
                                                                           workcenterdescription = ls_wrkctr-ktext
                                                                           prdty                 = ls_wrkctr-prdty ) ).

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_workcenter ).
  ENDMETHOD.


  METHOD GET_WORKCENTERSAREAS.
    DATA : lt_return          TYPE bapiret2_t,
           lt_workcentersarea TYPE zabsf_pp_t_workcentersarea.

    DATA(lv_area) = VALUE zabsf_pp_e_areaid( it_keys[ name = 'AREAID' ]-value OPTIONAL ).

    CALL FUNCTION 'ZABSF_PP_GET_WORKCENTERSAREA'
      EXPORTING
        iv_areaid          = CONV zabsf_pp_e_areaid( lv_area )
        iv_refdt           = sy-datum
        is_inputobj        = is_inputobj
      IMPORTING
        et_workcentersarea = lt_workcentersarea
        et_return          = lt_return.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return CHANGING co_msg = co_msg ).

    er_entity_set = lcl_utils=>copy_data_to_ref( lt_workcentersarea ).
  ENDMETHOD.


  METHOD OLD_CRE_TOKEN.
    DATA: ls_request_token TYPE ty_token,
          ls_token         TYPE ty_token,
          lv_msg           TYPE string.

    " Read input data
    io_data_provider->read_entry_data( IMPORTING es_data = ls_request_token ).

*    " Hash input password
*    DATA(lv_hashed_password) = zabsf_pp_cl_authentication=>get_hashed_password( EXPORTING iv_password = ls_request_token-password ).
*
**    DATA(lv_username_uppercase) = to_upper( val = ls_request_token-username ).
*
*    " Get user
*    SELECT SINGLE username
*      FROM zsf_auth
*      INTO @DATA(ls_auth)
*      WHERE username EQ @ls_request_token-username
*      AND passwordhash EQ @lv_hashed_password.
*
*    IF ls_auth IS NOT INITIAL.

    DATA(lv_valid) = lcl_helper_token=>authenticate( EXPORTING iv_username = ls_request_token-username
                                                               iv_password = ls_request_token-password ).

    IF lv_valid EQ abap_true.

      " Get user data
      SELECT SINGLE a~username, a~name, a~usersap, b~description AS role,
      a~center, a~userlanguage, a~userarea,
      a~hierarchies, a~workcenters, a~userjsoninfo,
      a~usererpid, a~usersupplierid
  FROM zsf_users AS a
  LEFT OUTER JOIN zsf_roles AS b
  ON a~roleid EQ b~id
  INTO @DATA(ls_user)
  WHERE username EQ @ls_request_token-username.

*BEGIN: JOL - 05/01/2023: Get active workcenters for the user
      DATA(lt_workcenters) = VALUE zabsf_pp_tt_user_workcenters( FOR w IN zabsf_pp_cl_user=>get_userworkcenters( ls_user-username ) (
                                                            id = COND #( WHEN w-objty EQ 'A' THEN w-arbpl ELSE w-hname )
                                                            parentid    = COND #( WHEN w-objty EQ 'A' THEN w-hname ELSE '' )
                                                            description = w-ktext
                                                            objty       = w-objty ) ).

      DATA(lt_workcenters_string) = /ui2/cl_json=>serialize( data = lt_workcenters compress = abap_false pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).
*END: JOL - 05/01/2023

      ls_token = VALUE ty_token( expires_in = 86399
                                 client_id = ``
                                 username = ls_request_token-username
                                 name = ls_user-name
                                 area = ls_user-userarea
                                 areatype = ``
                                 role = ls_user-role
                                 center = ls_user-center
                                 language = ls_user-userlanguage
                                 hierarchies = ls_user-hierarchies
                                 workcenters = lt_workcenters_string
                                 userjsoninfo = ls_user-userjsoninfo
                                 usererpid = ls_user-usererpid
                                 usersupplierid = ls_user-usersupplierid ).

      " Get actions/routes and serialize to json
      " [{"routename":"Launchpad","actionid":"ViewPermission","parentid":""}]
      zabsf_pp_cl_authentication=>get_actions(
        EXPORTING
          iv_username  = ls_user-username
        IMPORTING
          ev_actions   = ls_token-actions
      ).

      " Get authorizationActivityOfObjects and serialize to json
      zabsf_pp_cl_authentication=>get_activityofobjects(
        EXPORTING
          iv_username  = ls_user-username
        IMPORTING
          ev_authactobj = ls_token-authorizationactivityofobjects
      ).

      " Get authorization roles by user and serialize to json
      " [{"UserName":"1","AuthorizationRoleId":"ProductionRole"}]
      zabsf_pp_cl_authentication=>get_authorizationrolesuser(
        EXPORTING
          iv_username  = ls_user-username
          iv_serializejson = 'X'
        IMPORTING
          ev_authroleuser  = ls_token-authorizationrolesofusers
      ).

      " Get JWT Token and write it as a cookie
      DATA(lv_jwt_token) = zabsf_pp_cl_authentication=>create_token(
        EXPORTING
          iv_username   = CONV #( ls_request_token-username )
          iv_name       = CONV string( ls_user-name )
          iv_role       = CONV string( ls_user-role )
          iv_center     = CONV string( ls_user-center )
          iv_area       = CONV string( ls_user-userarea )
          iv_language   = CONV string( ls_user-userlanguage )
          iv_usererpid  = CONV string( ls_user-usererpid ) ).

      zabsf_pp_cl_authentication=>set_token_cookie( EXPORTING iv_token = lv_jwt_token ).

      CALL METHOD zabsf_pp_cl_authentication=>change_sap_user
        EXPORTING
          iv_username     = ls_request_token-username
        IMPORTING
          rv_access_token = DATA(lv_access_token).
      ls_token-access_token = |{ 'Basic' } { lv_access_token }|.

    ELSE.
      MESSAGE e011(z_sf_messages) INTO lv_msg.

      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( lv_msg ).

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ENDIF.

    er_entity = lcl_utils=>copy_data_to_ref( ls_token ).
  ENDMETHOD.


  METHOD OLD_CRE_USER.
    DATA: ls_request_user TYPE ty_user,
          lv_langu        TYPE spras.

    " Read input data
    io_data_provider->read_entry_data( IMPORTING es_data = ls_request_user ).

*    DATA(lv_username_uppercase) = ls_request_user-username.
*    TRANSLATE lv_username_uppercase TO UPPER CASE.

    SELECT SINGLE username
      FROM zsf_users
      INTO @DATA(ls_exist_user)
      WHERE username = @ls_request_user-username.

    IF sy-subrc <> 0.
      DATA(lv_validfrom) = cl_xlf_date_time=>parse( EXPORTING iso8601 = ls_request_user-validfrom ).
      DATA(lv_validto) = cl_xlf_date_time=>parse( EXPORTING iso8601 = ls_request_user-validto ).

      DATA(ls_user) = VALUE zsf_users( username = ls_request_user-username
                               center = ls_request_user-center
                               userarea = ls_request_user-userarea
                               name = ls_request_user-name
                               roleid = ls_request_user-roleid
                               usersap = ls_request_user-usersap
                               validfrom =  lv_validfrom
                               validto = lv_validto
                               userdownloadfolder =  ls_request_user-userdownloadfolder
                               useruploadfolder =  ls_request_user-useruploadfolder
*                               hierarchies =  ls_request_user-hierarchies
*                               workcenters =  ls_request_user-workcenters
                               userjsoninfo =  ls_request_user-userjsoninfo
                               usererpid =  ls_request_user-usererpid
                               usersupplierid =  ls_request_user-usersupplierid ).

***** BEGIN JOL - 07/12/2022 - set language - SPRAS field
*Set language local for user
      lv_langu = sy-langu.

      IF lv_langu EQ ''.
*  Get alternative language
        SELECT SINGLE spras
          FROM zabsf_pp061
          INTO lv_langu
         WHERE werks      EQ is_inputobj-werks
           AND is_default NE space.
      ENDIF.

      ls_user-language = lv_langu.
      ls_user-userlanguage = lv_langu.
***** END JOL - 07/12/2022

      " Hash input password
      DATA(lv_hashed_password) = zabsf_pp_cl_authentication=>get_hashed_password( EXPORTING iv_password = ls_request_user-password ).

      " increment ID
      SELECT SINGLE MAX( id ) FROM zsf_auth INTO @DATA(lv_amount_ids).

      DATA(ls_authorization) = VALUE zsf_auth( id = lv_amount_ids + 1
                                               username = ls_request_user-username
                                               passwordhash = lv_hashed_password ).

      DATA(ls_authroleuser) = VALUE zsf_authroleuser( username = ls_request_user-username
                                                      roleid = ls_request_user-authorizationroleid ).

      INSERT zsf_auth FROM ls_authorization.
      IF ( sy-subrc = 0 ).
        INSERT zsf_users FROM ls_user.
        IF ( sy-subrc = 0 ).
          INSERT zsf_authroleuser FROM ls_authroleuser.
          IF ( sy-subrc = 0 ).
* create completed
            COMMIT WORK AND WAIT.

            zabsf_pp_cl_user=>upd_userworkcenters(
              iv_username    = CONV #( ls_request_user-username )
              it_workcenters = ls_request_user-workcenters
            ).
          ELSE.
            MESSAGE e002(z_sf_messages) INTO DATA(lv_msg).

            CALL METHOD co_msg->add_message_text_only
              EXPORTING
                iv_msg_type = 'E'
                iv_msg_text = CONV #( lv_msg ).

            " Raising Exception
            RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
              EXPORTING
                message_container = co_msg.
          ENDIF.
        ELSE.
          MESSAGE e002(z_sf_messages) INTO lv_msg.

          CALL METHOD co_msg->add_message_text_only
            EXPORTING
              iv_msg_type = 'E'
              iv_msg_text = CONV #( lv_msg ).

          " Raising Exception
          RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
            EXPORTING
              message_container = co_msg.
        ENDIF.
      ELSE.
        MESSAGE e002(z_sf_messages) INTO lv_msg.

        CALL METHOD co_msg->add_message_text_only
          EXPORTING
            iv_msg_type = 'E'
            iv_msg_text = CONV #( lv_msg ).

        " Raising Exception
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            message_container = co_msg.
      ENDIF.
    ELSE.
      MESSAGE e004(z_sf_messages) INTO lv_msg.

      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( lv_msg ).

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ENDIF.
    er_entity = lcl_utils=>copy_data_to_ref( ls_request_user ).
  ENDMETHOD.


  METHOD OLD_CRE_USERSAP.
    " Data Declarations
    DATA: ls_request TYPE ty_usersap,
          ls_usersap TYPE zsf_userssap.

    " Read the input data
    io_data_provider->read_entry_data( IMPORTING es_data = ls_request ).

    SELECT SINGLE usersap
      FROM zsf_userssap
      INTO @DATA(ls_exist_usersap)
      WHERE usersap = @ls_request-usersap.

    IF ls_exist_usersap IS INITIAL.

      " Hash user password
      DATA(lv_hashed_password) = zabsf_pp_cl_authentication=>get_hashed_password( EXPORTING iv_password = ls_request-password ).

      " Update structure data and insert it into the table
      ls_usersap-usersap = ls_request-usersap.
      ls_usersap-password = lv_hashed_password.

      INSERT INTO zsf_userssap VALUES ls_usersap.

      IF ( sy-subrc = 0 ).
* delete completed
        COMMIT WORK AND WAIT.
      ELSE.
        MESSAGE e002(z_sf_messages) INTO DATA(lv_msg).

        CALL METHOD co_msg->add_message_text_only
          EXPORTING
            iv_msg_type = 'E'
            iv_msg_text = CONV #( lv_msg ).

        " Raising Exception
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            message_container = co_msg.
      ENDIF.
    ELSE.
      MESSAGE e008(z_sf_messages) INTO lv_msg.

      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( lv_msg ).

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ENDIF.
    er_entity = lcl_utils=>copy_data_to_ref( ls_request ).
  ENDMETHOD.


  METHOD OLD_UPD_USER.
    DATA: ls_user  TYPE ty_user,
          lv_msg   TYPE string,
          lv_langu TYPE spras.

    " Get the property values
    READ TABLE it_keys INTO DATA(ls_username) WITH KEY name = 'USERNAME'.
*    ls_username-value = to_upper( val = ls_username-value ).

    " Read input data
    io_data_provider->read_entry_data( IMPORTING es_data = ls_user ).

* BEGIN JOL - 07/12/2022: change password / change userlanguage / change other user data
    IF ls_user-password <> ''.
      " Hash input password
      DATA(lv_hashed_password) = zabsf_pp_cl_authentication=>get_hashed_password( EXPORTING iv_password = ls_user-password ).

      UPDATE zsf_auth SET passwordhash = lv_hashed_password
      WHERE username = ls_username-value.

      IF ( sy-subrc = 0 ).
        " update completed
        COMMIT WORK AND WAIT.
      ELSE.
        MESSAGE e002(z_sf_messages) INTO lv_msg.

        CALL METHOD co_msg->add_message_text_only
          EXPORTING
            iv_msg_type = 'E'
            iv_msg_text = CONV #( lv_msg ).

        " Raising Exception
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            message_container = co_msg.
      ENDIF.

    ELSEIF ls_user-userlanguage <> ''.
      UPDATE zsf_users SET userlanguage = ls_user-userlanguage
                           language     = ls_user-userlanguage
                       WHERE username   = ls_username-value.

      IF ( sy-subrc = 0 ).
        " update completed
        COMMIT WORK AND WAIT.
      ELSE.
        MESSAGE e002(z_sf_messages) INTO lv_msg.

        CALL METHOD co_msg->add_message_text_only
          EXPORTING
            iv_msg_type = 'E'
            iv_msg_text = CONV #( lv_msg ).

        " Raising Exception
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            message_container = co_msg.
      ENDIF.

    ELSE.
*      SPLIT ls_user-validfrom AT 'T' INTO DATA(lv_datevf) DATA(lv_timevf).
*      REPLACE ALL OCCURRENCES OF REGEX '-' IN lv_datevf WITH space.
*      SPLIT lv_timevf AT '.' INTO DATA(lv_time1vf) DATA(lv_time2vf).
*      REPLACE ALL OCCURRENCES OF REGEX ':' IN lv_time1vf WITH space.
*      CONVERT DATE lv_datevf TIME lv_time1vf DAYLIGHT SAVING TIME 'X'
*    INTO TIME STAMP DATA(time_stampvf) TIME ZONE 'EST'.
*
*      SPLIT ls_user-validto AT 'T' INTO DATA(lv_datevt) DATA(lv_timevt).
*      REPLACE ALL OCCURRENCES OF REGEX '-' IN lv_datevt WITH space.
*      SPLIT lv_timevt AT '.' INTO DATA(lv_time1vt) DATA(lv_time2vt).
*      REPLACE ALL OCCURRENCES OF REGEX ':' IN lv_time1vt WITH space.
*      CONVERT DATE lv_datevt TIME lv_time1vt DAYLIGHT SAVING TIME 'X'
*    INTO TIME STAMP DATA(time_stampvt) TIME ZONE 'EST'.

      DATA(lv_validfrom) = cl_xlf_date_time=>parse( EXPORTING iso8601 = ls_user-validfrom ).
      DATA(lv_validto) = cl_xlf_date_time=>parse( EXPORTING iso8601 = ls_user-validto ).

      UPDATE zsf_users SET center         = ls_user-center
                           usersap        = ls_user-usersap
                           hierarchies    = ls_user-hierarchies
                           name           = ls_user-name
*                           language       = ls_user-userlanguage
*                           userlanguage   = ls_user-userlanguage
                           userarea       = ls_user-userarea
                           roleid         = ls_user-roleid
*                          workcenters    = ls_user-workcenters
                           validfrom      = lv_validfrom
                           validto        = lv_validto
                           usererpid      = ls_user-usererpid
                           usersupplierid = ls_user-usersupplierid
                        WHERE username = ls_username-value.

      IF ( sy-subrc = 0 ).
        UPDATE zsf_authroleuser SET roleid = ls_user-authorizationroleid
                                WHERE username = ls_username-value.
        IF ( sy-subrc = 0 ).
          " update completed
          COMMIT WORK AND WAIT.

          " Update active workcenters
          zabsf_pp_cl_user=>upd_userworkcenters(
            iv_username    = CONV #( ls_username-value )
            it_workcenters = ls_user-workcenters
          ).
        ELSE.
          MESSAGE e002(z_sf_messages) INTO lv_msg.

          CALL METHOD co_msg->add_message_text_only
            EXPORTING
              iv_msg_type = 'E'
              iv_msg_text = CONV #( lv_msg ).

          " Raising Exception
          RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
            EXPORTING
              message_container = co_msg.
        ENDIF.
      ELSE.
        MESSAGE e002(z_sf_messages) INTO lv_msg.

        CALL METHOD co_msg->add_message_text_only
          EXPORTING
            iv_msg_type = 'E'
            iv_msg_text = CONV #( lv_msg ).

        " Raising Exception
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            message_container = co_msg.
      ENDIF.
    ENDIF.
* END JOL - 07/12/2022

    er_entity = lcl_utils=>copy_data_to_ref( ls_user ).
  ENDMETHOD.


  METHOD OLD_UPD_USERSAP.
    DATA: ls_update_usersap TYPE ty_usersap.

    " Read UserSAP key
    READ TABLE it_keys INTO DATA(ls_usersap) WITH KEY name = 'USERSAP'.

    " Read input data
    io_data_provider->read_entry_data( IMPORTING es_data = ls_update_usersap ).

*    " Hash user password
*    DATA(lv_hashed_password) = zabsf_pp_cl_authentication=>get_hashed_password( EXPORTING iv_password = ls_update_usersap-password ).
*
*    UPDATE zsf_userssap SET password = lv_hashed_password
*                         WHERE usersap = ls_usersap-value.
    zabsf_pp_cl_authentication=>update_sap_user_pwd( iv_username = ls_usersap-value iv_password = ls_update_usersap-password ).

    IF ( sy-subrc = 0 ).
      " update completed
      COMMIT WORK AND WAIT.
    ELSE.
      MESSAGE e002(z_sf_messages) INTO DATA(lv_msg).

      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( lv_msg ).

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ENDIF.
    er_entity = lcl_utils=>copy_data_to_ref( ls_update_usersap ).
  ENDMETHOD.


  METHOD upd_additionaltime.
    DATA:
      ls_pp116  TYPE zabsf_pp116,
      ls_addtim TYPE ty_additionaltime.

    " Get the property values
    ls_pp116-aufnr   = VALUE #( it_keys[ name = 'ORDERNUMBER' ]-value OPTIONAL ).
    ls_pp116-vornr   = VALUE #( it_keys[ name = 'OPERATION' ]-value OPTIONAL ).
    ls_pp116-arbpl   = VALUE #( it_keys[ name = 'WORKCENTER' ]-value OPTIONAL ).
    ls_pp116-shiftid = VALUE #( it_keys[ name = 'SHIFTID' ]-value OPTIONAL ).
    ls_pp116-oprid   = VALUE #( it_keys[ name = 'OPERATORID' ]-value OPTIONAL ).

    " Read input data
    io_data_provider->read_entry_data( IMPORTING es_data = ls_addtim ).

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = ls_pp116-aufnr
      IMPORTING
        output = ls_pp116-aufnr.

    SELECT SINGLE gmein
      FROM afko
      WHERE afko~aufnr EQ @ls_pp116-aufnr
      INTO @ls_addtim-unit.

    " Check counter number
    SELECT SINGLE counter
      FROM zabsf_pp116
      INTO ls_pp116-counter
      WHERE aufnr   EQ ls_pp116-aufnr
        AND arbpl   EQ ls_pp116-arbpl
        AND shiftid EQ ls_pp116-shiftid
        AND oprid   EQ ls_pp116-oprid.

    IF sy-subrc IS INITIAL.
      ADD 1 TO ls_pp116-counter.
    ENDIF.

    ls_pp116-begts = zabsf_pp_cl_utils=>convert_to_timestamp( ls_addtim-begintimestamp ).
    ls_pp116-endts = zabsf_pp_cl_utils=>convert_to_timestamp( ls_addtim-endtimestamp ).
    ls_pp116-quant = ls_addtim-quantity.
    ls_pp116-gmein = ls_addtim-unit.

    MODIFY zabsf_pp116 FROM ls_pp116.

    IF sy-subrc IS INITIAL.
      " update completed
      COMMIT WORK AND WAIT.
    ELSE.
      MESSAGE e002(z_sf_messages) INTO DATA(lv_msg).

      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( lv_msg ).

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ENDIF.

    er_entity = lcl_utils=>copy_data_to_ref( ls_addtim ).
  ENDMETHOD.


  METHOD upd_authorizationactivityofob.
    DATA ls_update_authactivities TYPE ty_authorizationactivityofobje.

*    Get the property values
    READ TABLE it_keys INTO DATA(ls_authorizationprofileid) WITH KEY name = 'AUTHORIZATIONPROFILEID'.
    READ TABLE it_keys INTO DATA(ls_authorizationobjectid) WITH KEY name = 'AUTHORIZATIONOBJECTID'.
    READ TABLE it_keys INTO DATA(ls_authorizationactivitytypeid) WITH KEY name = 'AUTHORIZATIONACTIVITYTYPEID'.

    " Read input data
    io_data_provider->read_entry_data( IMPORTING es_data = ls_update_authactivities ).

    UPDATE zsf_authactobj SET checked = ls_update_authactivities-checked
                          WHERE profileid = ls_update_authactivities-authorizationprofileid
                          AND objectid = ls_update_authactivities-authorizationobjectid
                          AND activitytypeid = ls_update_authactivities-authorizationactivitytypeid.

    IF ( sy-subrc = 0 ).
      " update completed
      COMMIT WORK AND WAIT.
    ELSE.
      MESSAGE e002(z_sf_messages) INTO DATA(lv_msg).

      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( lv_msg ).

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ENDIF.
    er_entity = lcl_utils=>copy_data_to_ref( ls_update_authactivities ).
  ENDMETHOD.


  METHOD upd_operation.
    DATA: lt_return_tab         TYPE bapiret2_t,
          ls_upd_operation      TYPE zabsf_cl_odata=>ty_operation,
          lt_upd_operation      TYPE tt_operation,
          ls_arbpl_print_st     TYPE zabsf_pp_s_arbpl_print,
          ls_qty_conf_tab       TYPE zabsf_pp_s_qty_conf,
          lt_qty_conf_tab       TYPE zabsf_pp_t_qty_conf,
          ls_print              TYPE zabsf_pp_s_arbpl_print,
          lt_tableordersequence TYPE STANDARD TABLE OF zabsf_pp_order_seq_s.

*    Get the property values
    READ TABLE it_keys INTO DATA(ls_id) WITH KEY name = 'ID'.
    READ TABLE it_keys INTO DATA(ls_productionorderid) WITH KEY name = 'PRODUCTIONORDERID'.
    READ TABLE it_keys INTO DATA(ls_workcenterid) WITH KEY name = 'WORKCENTERID'.
    READ TABLE it_keys INTO DATA(ls_offlineversion) WITH KEY name = 'OFFLINEVERSION'.
    READ TABLE it_keys INTO DATA(ls_shiftid) WITH KEY name = 'SHIFTID'.

    " Read input data
    io_data_provider->read_entry_data( IMPORTING es_data = ls_upd_operation ).

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input  = ls_upd_operation-materialid
      IMPORTING
        output = ls_upd_operation-materialid.

    ls_upd_operation-id = ls_id-value.
    ls_upd_operation-productionorderid = replace( val = ls_productionorderid-value sub = `'` with = `` ).
    ls_upd_operation-workcenterid = replace( val = ls_workcenterid-value sub = `'` with = `` ).
    ls_upd_operation-offlineversion = ls_offlineversion-value.

    IF ls_upd_operation-oinfo IS INITIAL.
      DATA(lv_method_name) = lcl_utils=>get_method_name( ).
      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_entity_type = lv_method_name
          iv_msg_type    = `E`
          iv_msg_text    = `OInfo is null. Please contact your System Administrator.`.

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ENDIF.

    IF ls_upd_operation-operationactivity IS NOT INITIAL AND ( ls_upd_operation-operationactivity EQ 'INIT_PRE' OR
                                                               ls_upd_operation-operationactivity EQ 'INIT_PRO' OR
                                                               ls_upd_operation-operationactivity EQ 'END_PARC' OR
                                                               ls_upd_operation-operationactivity EQ 'END_PROD' OR
                                                               ls_upd_operation-operationactivity EQ 'STOP_PRO' ).

      IF ls_upd_operation-operationaction EQ 'CONC' AND ls_upd_operation-operationaction EQ 'END_PROD'.
        DATA(lv_conf) = COND #( WHEN ls_upd_operation-blockstatusonclose EQ abap_true THEN abap_true ELSE abap_false ).
      ENDIF.

      CALL FUNCTION 'ZABSF_PP_CONF_TIME'
        EXPORTING
          arbpl       = CONV arbpl( ls_upd_operation-workcenterid )
          aufnr       = CONV aufnr( ls_upd_operation-productionorderid )
          vornr       = CONV vornr( ls_upd_operation-id )
          date        = sy-datum
          time        = CONV atime( sy-uzeit )
          rueck       = CONV co_rueck( ls_upd_operation-oinfo-rueck )
          aufpl       = CONV co_aufpl( ls_upd_operation-oinfo-aufpl )
          aplzl       = CONV co_aplzl( ls_upd_operation-oinfo-aplzl )
          actv_id     = CONV zabsf_pp_e_actv( ls_upd_operation-operationactivity )
          stprsnid    = CONV zabsf_pp_e_stprsnid( ls_upd_operation-operationstopreasonid )
          actionid    = CONV zabsf_pp_e_action( ls_upd_operation-operationaction )
          schedule_id = CONV zabsf_pp_e_schedule_id( ls_upd_operation-scheduleid )
          regime_id   = CONV zabsf_pp_e_regime_id( ls_upd_operation-regimeid )
          count_ini   = CONV zabsf_pp_e_count_ini( ls_upd_operation-initialcyclecounter )
          count_fin   = COND #( WHEN ls_upd_operation-finalcyclecounter GE 0 THEN CONV zabsf_pp_e_count_fin( ls_upd_operation-finalcyclecounter ) )
          refdt       = sy-datum
          inputobj    = is_inputobj
          conf        = CONV flag( lv_conf )
          kapid       = CONV kapid( ls_upd_operation-workcenterpositionid )
          shiftid     = CONV zabsf_pp_e_shiftid( ls_shiftid-value )
          equipment   = CONV char100( ls_upd_operation-equipment )
        IMPORTING
          return_tab  = lt_return_tab.

      lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

    ELSEIF ls_upd_operation-operationaction IS NOT INITIAL AND ( ls_upd_operation-operationaction EQ 'INIT' OR ls_upd_operation-operationaction EQ 'STOP' OR
                                                             ls_upd_operation-operationaction EQ 'AGU' ).
      CALL FUNCTION 'ZABSF_PP_STATUS'
        EXPORTING
          arbpl      = CONV arbpl( ls_upd_operation-workcenterid )
          aufnr      = CONV aufnr( ls_upd_operation-productionorderid )
          vornr      = CONV vornr( ls_upd_operation-id )
          objty      = 'OV'
          method     = 'S'
          actionid   = CONV char4( ls_upd_operation-operationaction )
          refdt      = sy-datum
          inputobj   = is_inputobj
          stprsnid   = CONV zabsf_pp_e_stprsnid( ls_upd_operation-operationstopreasonid )
        IMPORTING
          return_tab = lt_return_tab.

      lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

    ELSEIF ls_upd_operation-closebox EQ abap_true OR ls_upd_operation-changeoperationlot IS NOT INITIAL.

      CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
        EXPORTING
          input  = ls_upd_operation-oinfo-matnr
        IMPORTING
          output = ls_upd_operation-oinfo-matnr.


      ls_arbpl_print_st = VALUE #( arbpl = ls_upd_operation-workcenterid
                                   aufnr = ls_upd_operation-productionorderid
                                   matnr = ls_upd_operation-oinfo-matnr
                                   vornr = ls_upd_operation-id ).

      CALL FUNCTION 'ZABSF_PP_BATCH_OPERATIONS'
        EXPORTING
          arbpl_print_st      = ls_arbpl_print_st
          refdt               = sy-datum
          inputobj            = is_inputobj
          batch               = ls_upd_operation-changeoperationlot
          lenum               = ls_upd_operation-changeoperationpallet
          create_and_retreive = COND #( WHEN ls_upd_operation-unittype IS INITIAL THEN abap_true )
        IMPORTING
          return_tab          = lt_return_tab.

      lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

    ELSE.
      DATA lv_num TYPE i.
      IF ls_upd_operation-goodquantity LE 0 OR ls_upd_operation-workcentertype EQ `R`.
        IF ls_upd_operation-goodquantity LE 0 AND ls_upd_operation-adjustmentquantity IS NOT INITIAL.
          lv_num = 1.
          lcl_helper_operation=>helper_12( EXPORTING is_inputobj = is_inputobj iv_num = lv_num CHANGING cs_upd_operation = ls_upd_operation co_msg = co_msg ).
        ELSE.
          lv_num = COND #( WHEN ls_upd_operation-workcentertype NE `R` THEN 1 ELSE 0 ).
          lcl_helper_operation=>helper_12( EXPORTING is_inputobj = is_inputobj iv_num = lv_num CHANGING cs_upd_operation = ls_upd_operation co_msg = co_msg ).
        ENDIF.
      ELSE.
        ls_upd_operation-confday = ``.
        ls_upd_operation-conftime = ``.

        DATA(ls_inputobj) = is_inputobj.
        ls_inputobj-dateconf = sy-datum.

        zcl_bc_fixed_values=>get_single_value( EXPORTING
                                         im_paramter_var = zcl_bc_fixed_values=>gc_reg_time_quant_cst
                                         im_modulesp_var = zcl_bc_fixed_values=>gc_productn_cst
                                       IMPORTING
                                         ex_prmvalue_var = DATA(lv_reg_time) ).

        ls_inputobj-timeconf = COND #( WHEN lv_reg_time EQ 'ABAP_TRUE'
                                            THEN sy-uzeit ).

        CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
          EXPORTING
            input  = ls_upd_operation-oinfo-matnr
          IMPORTING
            output = ls_upd_operation-oinfo-matnr.

        lt_qty_conf_tab = VALUE #( ( aufnr = ls_upd_operation-productionorderid
                                     vornr = ls_upd_operation-id
                                     matnr = ls_upd_operation-oinfo-matnr
                                     lmnga = ls_upd_operation-goodquantity
                                     required_qtt = ls_upd_operation-quantitytomake
                                     confirmed_qtt = ls_upd_operation-quantitymade
                                     wareid = ls_upd_operation-oinfo-wareid
                                     numb_cycle = COND #( WHEN ls_upd_operation-goodnrcycles NE 0 THEN ls_upd_operation-goodnrcycles )
                                     rueck = COND #( WHEN ls_upd_operation-previousoperationconfirmation IS NOT INITIAL THEN ls_upd_operation-previousoperationconfirmation )
                                     rmzhl = COND #( WHEN ls_upd_operation-previousoperationcounter IS NOT INITIAL THEN ls_upd_operation-previousoperationcounter )
                                     gmein = ls_upd_operation-unitvalue ) ).

        CALL FUNCTION 'ZABSF_PP_SET_QUANTITY'
          EXPORTING
            arbpl          = CONV arbpl( ls_upd_operation-workcenterid )
            qty_conf_tab   = lt_qty_conf_tab
            tipord         = CONV zabsf_pp_e_tipord( ls_upd_operation-oinfo-tipord )
            refdt          = sy-datum
            inputobj       = ls_inputobj
            first_cycle    = CONV flag( |{ condense( val = ls_upd_operation-firstcycle from = `` ) }| )
            supervisor     = CONV flag( ls_upd_operation-areaadminvalidated )
            shiftid        = CONV zabsf_pp_e_shiftid( ls_shiftid-value )
            materialbatch  = ls_upd_operation-materialbatch[]
            materialserial = ls_upd_operation-materialserial[]
            equipment      = CONV char100( ls_upd_operation-equipment )
          IMPORTING
            return_tab     = lt_return_tab.

        lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).
      ENDIF.
    ENDIF.

    CALL METHOD lcl_helper_operation=>helper_81
      EXPORTING
        is_inputobj      = is_inputobj
      CHANGING
        cs_upd_operation = ls_upd_operation
        co_msg           = co_msg.

    er_entity = lcl_utils=>copy_data_to_ref( ls_upd_operation ).
  ENDMETHOD.


  METHOD upd_operationalert.
    DATA: ls_input   TYPE ty_operationalert,
          ls_alerts  TYPE zabsf_pp_alerts,
          ls_results TYPE zabsf_pp_alerts,
          lv_msg     TYPE string.

    DATA(lv_materialid) = VALUE matnr( it_keys[ name = 'MATERIALID' ]-value OPTIONAL ).
    DATA(lv_operation) = VALUE vornr( it_keys[ name = 'OPERATION' ]-value OPTIONAL ).
    DATA(lv_alertid) = VALUE zabsf_pp_e_alertid( it_keys[ name = 'ALERTID' ]-value OPTIONAL ).

    " Read input data
    io_data_provider->read_entry_data( IMPORTING es_data = ls_input ).

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input        = lv_materialid
      IMPORTING
        output       = lv_materialid
      EXCEPTIONS
        length_error = 1
        OTHERS       = 2.

    SELECT SINGLE *
      FROM zabsf_pp_alerts
         WHERE matnr EQ @lv_materialid
         AND vornr EQ @lv_operation
*         AND alertid EQ @lv_alertid
         AND flag EQ @abap_true
         INTO @DATA(ls_alert_active).

    IF ls_alert_active IS NOT INITIAL AND ls_input-flag EQ abap_true AND ls_alert_active-alertid <> lv_alertid.
      " exist active alert for material and operation.
      MESSAGE e166(zabsf_pp) WITH lv_materialid lv_operation INTO lv_msg.

      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( lv_msg ).

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.

    ELSE.
*    ENDIF.

*    IF ( ls_alert_active IS NOT INITIAL AND ls_input-flag EQ abap_true AND ls_alert_active-alertid EQ lv_alertid ) OR ls_input-flag EQ abap_false.
      ls_alerts-matnr = lv_materialid.
      ls_alerts-vornr = lv_operation.
      ls_alerts-alertid = lv_alertid.

      SELECT SINGLE maktx
        FROM makt
        WHERE matnr EQ @lv_materialid
        INTO @DATA(lv_maktx).

      ls_alerts-maktr = lv_maktx.
      ls_alerts-alerttitle = ls_input-alerttitle.
      ls_alerts-alertdesc = ls_input-alertdesc.
      ls_alerts-flag = ls_input-flag.
      ls_alerts-username = ls_input-username.
      ls_alerts-ltxa1 = ls_input-operationdesc.
      ls_alerts-areaid = is_inputobj-areaid.

      UPDATE zabsf_pp_alerts FROM ls_alerts.

      IF ( sy-subrc = 0 ).
        " update completed
        COMMIT WORK AND WAIT.
      ELSE.
        MESSAGE e002(z_sf_messages) INTO lv_msg.

        CALL METHOD co_msg->add_message_text_only
          EXPORTING
            iv_msg_type = 'E'
            iv_msg_text = CONV #( lv_msg ).

        " Raising Exception
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            message_container = co_msg.
      ENDIF.
    ENDIF.

    er_entity = lcl_utils=>copy_data_to_ref( ls_alerts ).
  ENDMETHOD.


  METHOD upd_operationconsumption.
    DATA: lt_return_tab               TYPE bapiret2_t,
          ls_components_st            TYPE zabsf_pp_s_components,
          ls_adit_matnr_st            TYPE zabsf_pp_s_adit_matnr,
          ls_charg_t                  TYPE zabsf_pp_s_batch_consumption,
          lt_charg_t                  TYPE STANDARD TABLE OF zabsf_pp_s_batch_consumption,
          ls_upd_operationconsumption TYPE ty_operationconsumption,
          lt_upd_operationconsumption TYPE tt_operationconsumption.

    " Get the property values
    READ TABLE it_keys INTO DATA(ls_productionorderid) WITH KEY name = 'PRODUCTIONORDERID'.
    READ TABLE it_keys INTO DATA(ls_materialid) WITH KEY name = 'MATERIALID'.
    READ TABLE it_keys INTO DATA(ls_operationconsumptiontype) WITH KEY name = 'OPERATIONCONSUMPTIONTYPE'.
    READ TABLE it_keys INTO DATA(ls_reservenumber) WITH KEY name = 'RESERVENUMBER'.
    READ TABLE it_keys INTO DATA(ls_reserveitem) WITH KEY name = 'RESERVEITEM'.
    READ TABLE it_keys INTO DATA(ls_batchid) WITH KEY name = 'BATCHID'.
    READ TABLE it_keys INTO DATA(ls_unitid) WITH KEY name = 'UNITID'.
    READ TABLE it_keys INTO DATA(ls_materialdescription) WITH KEY name = 'MATERIALDESCRIPTION'.
    READ TABLE it_keys INTO DATA(ls_ilgort) WITH KEY name = 'ILGORT'.

    " Read input data
    io_data_provider->read_entry_data( IMPORTING es_data = ls_upd_operationconsumption ).

    ls_upd_operationconsumption-productionorderid = ls_productionorderid-value.
    ls_upd_operationconsumption-materialid = ls_materialid-value.
    ls_upd_operationconsumption-operationconsumptiontype = ls_operationconsumptiontype-value.
    ls_upd_operationconsumption-reservenumber = ls_reservenumber-value.
    ls_upd_operationconsumption-reserveitem = ls_reserveitem-value.
    ls_upd_operationconsumption-batchid = ls_batchid-value.
    ls_upd_operationconsumption-unitid = ls_unitid-value.
    ls_upd_operationconsumption-materialdescription = cl_http_utility=>if_http_utility~escape_url( ls_materialdescription-value ).
    ls_upd_operationconsumption-ilgort = CONV #( ls_ilgort-value ).

    IF ls_upd_operationconsumption-quantitytoconsume IS NOT INITIAL AND ls_upd_operationconsumption-quantitytoconsume GT 0.
      ls_upd_operationconsumption-ilgort = COND #( WHEN ls_upd_operationconsumption-ilgort EQ '9999' THEN '' ELSE ls_upd_operationconsumption-ilgort ).
      IF ls_upd_operationconsumption-operationconsumptiontype EQ 'C' OR
              ( ls_upd_operationconsumption-operationconsumptiontype EQ 'A' AND ls_upd_operationconsumption-reservedmaterial EQ abap_true ).

        ls_components_st = VALUE #( consqty = ls_upd_operationconsumption-quantitytoconsume
*                                    lgort = ls_upd_operationconsumption-ilgort
                                    lgort = CONV #( ls_upd_operationconsumption-ilgort )
                                    matnr = ls_materialid-value
                                    meins = ls_upd_operationconsumption-ounit
                                    batch = COND #( WHEN ls_upd_operationconsumption-batchflag EQ 'X' THEN ls_upd_operationconsumption-batchid )
                                    rsnum = ls_upd_operationconsumption-reservenumber
                                    maktx = cl_http_utility=>if_http_utility~escape_url( ls_upd_operationconsumption-materialdescription ) ).

      ELSEIF ls_upd_operationconsumption-operationconsumptiontype EQ 'A'.
        ls_adit_matnr_st = VALUE #( consqty = ls_upd_operationconsumption-quantitytoconsume
*                                    lgort = ls_upd_operationconsumption-ilgort
                                    lgort = CONV #( ls_upd_operationconsumption-ilgort )
                                    matnr = ls_upd_operationconsumption-materialid
                                    meins = ls_upd_operationconsumption-ounit
                                    batch = COND #( WHEN ls_upd_operationconsumption-batchflag EQ 'X' THEN ls_upd_operationconsumption-batchid ) ).
      ENDIF.

*      CALL FUNCTION 'ZABSF_PP_SETGOODSMVT'
*        EXPORTING
*          aufnr         = CONV aufnr( ls_upd_operationconsumption-productionorderid )
*          components_st = ls_components_st
*          adit_matnr_st = ls_adit_matnr_st
*          refdt         = sy-datum
*          inputobj      = is_inputobj
*          lenum         = CONV lenum( ls_upd_operationconsumption-palletid )
*        IMPORTING
*          return_tab    = lt_return_tab.
      lt_return_tab = lcl_helper_operationconsumptio=>zabsf_pp_setgoodsmvt( EXPORTING inputobj = is_inputobj
                                                                                      refdt = sy-datum
                                                                                      aufnr = CONV aufnr( ls_upd_operationconsumption-productionorderid )
                                                                                      components_st = ls_components_st
                                                                                      adit_matnr_st = ls_adit_matnr_st
                                                                                      lenum = CONV lenum( ls_upd_operationconsumption-palletid ) ).

      lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).
    ENDIF.
    IF ls_upd_operationconsumption-action EQ 'VALIDATE' AND ls_upd_operationconsumption-batchid IS NOT INITIAL.

      lt_charg_t = VALUE #( ( charg = ls_upd_operationconsumption-batchid
                              matnr = ls_upd_operationconsumption-materialid
                              werks = is_inputobj-werks
                              maktx = cl_http_utility=>if_http_utility~escape_url( ls_upd_operationconsumption-materialdescription ) ) ).


      CALL FUNCTION 'ZABSF_PP_CHECK_BATCH_STOCK'
        EXPORTING
          arbpl      = CONV arbpl( ls_upd_operationconsumption-workcenterid )
          aufnr      = CONV aufnr( ls_upd_operationconsumption-productionorderid )
          vornr      = CONV vornr( ls_upd_operationconsumption-operationid )
          charg_t    = lt_charg_t
          refdt      = sy-datum
          inputobj   = is_inputobj
        IMPORTING
          return_tab = lt_return_tab.

      lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

    ELSEIF ls_upd_operationconsumption-action EQ 'VALIDATE' AND ls_upd_operationconsumption-batchid IS INITIAL.

      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( `Middleware: Batch is the same.` ).

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ENDIF.
    er_entity = lcl_utils=>copy_data_to_ref( ls_upd_operationconsumption ).
  ENDMETHOD.


  METHOD UPD_OPERATIONEQUIPMENT.
    DATA: ls_equipment TYPE ty_operationequipment,
          ls_operequ   TYPE zabsf_pp_operequ.

    " Read input data
    io_data_provider->read_entry_data( IMPORTING es_data = ls_equipment ).

    SELECT COUNT(*)
          FROM zabsf_equipments
          INTO @DATA(lv_equipment_exists)
          WHERE areaid = @ls_equipment-areaid
          AND equipment = @ls_equipment-equipment.

    IF lv_equipment_exists EQ 0.
      DATA(lv_msg) = `Invalid Equipment.`.

      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( lv_msg ).

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ELSE.
      SELECT COUNT(*)
        FROM zabsf_pp_operequ
        INTO @DATA(lv_operation_exists)
        WHERE areaid = @ls_equipment-areaid
        AND prodorder = @ls_equipment-prodorder
        AND operation = @ls_equipment-operation.

      IF lv_operation_exists EQ 0.
        "Does not exist, create it
        ls_operequ = VALUE #( areaid = ls_equipment-areaid
                              prodorder = ls_equipment-prodorder
                              operation = ls_equipment-operation
                              equipment = ls_equipment-equipment
                            ).

        INSERT zabsf_pp_operequ FROM ls_operequ.
      ELSE.
        "Already exists, update it
        UPDATE zabsf_pp_operequ
          SET equipment = @ls_equipment-equipment
          WHERE areaid = @ls_equipment-areaid
            AND prodorder = @ls_equipment-prodorder
            AND operation = @ls_equipment-operation.
      ENDIF.
    ENDIF.

    er_entity = lcl_utils=>copy_data_to_ref( ls_equipment ).
  ENDMETHOD.


  METHOD upd_operationoperator.
    DATA: lt_return_tab            TYPE bapiret2_t,
          ls_upd_operationoperator TYPE ty_operationoperator,
          lt_operator_tab          TYPE zabsf_pp_t_operador.

    DATA lref_sf_operator TYPE REF TO zif_absf_pp_operator.
    DATA: ld_class  TYPE recaimplclname,
          ld_method TYPE seocmpname.

    " Get the property values
    READ TABLE it_keys INTO DATA(ls_shiftid) WITH KEY name = 'SHIFTID'.
    READ TABLE it_keys INTO DATA(ls_operationid) WITH KEY name = 'OPERATIONID'.
    READ TABLE it_keys INTO DATA(ls_productionorderid) WITH KEY name = 'PRODUCTIONORDERID'.
    READ TABLE it_keys INTO DATA(ls_workcenterid) WITH KEY name = 'WORKCENTERID'.
    READ TABLE it_keys INTO DATA(ls_operatorid) WITH KEY name = 'OPERATORID'.

    " Read input data
    io_data_provider->read_entry_data( IMPORTING es_data = ls_upd_operationoperator ).

*BEGIN - JOL - 07/12/2022 - Check if exist user
    TRANSLATE ls_operatorid-value TO UPPER CASE.

    SELECT SINGLE COUNT(*) FROM zsf_users WHERE username EQ @ls_operatorid-value.
    IF sy-subrc <> 0.
      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( `OPERATOR DOES NOT EXIST` ).
      RETURN.
    ENDIF.
*END - JOL - 07/12/2022 - Check if exist user

    ls_upd_operationoperator-operationid = ls_operationid-value.
    ls_upd_operationoperator-productionorderid = ls_productionorderid-value.
    ls_upd_operationoperator-workcenterid = ls_workcenterid-value.
    ls_upd_operationoperator-operatorid = ls_operatorid-value.

    lt_operator_tab = VALUE #( ( oprid = ls_upd_operationoperator-operatorid status = ls_upd_operationoperator-status ) ).

*Get class of interface
    SELECT SINGLE imp_clname methodname
        FROM zabsf_pp003
        INTO (ld_class, ld_method)
       WHERE werks EQ is_inputobj-werks
         AND id_class EQ '11'
         AND endda GE sy-datum
         AND begda LE sy-datum.
    TRY .
        CREATE OBJECT lref_sf_operator TYPE (ld_class)
          EXPORTING
            initial_refdt = sy-datum
            input_object  = is_inputobj.
      CATCH cx_sy_create_object_error.
*    No data for object in customizing table
        CALL METHOD zabsf_pp_cl_log=>add_message
          EXPORTING
            msgty      = 'E'
            msgno      = '019'
            msgv1      = ld_class
          CHANGING
            return_tab = lt_return_tab.
        EXIT.
    ENDTRY.

    CALL METHOD lref_sf_operator->(ld_method)
      EXPORTING
        rpoint       = CONV zabsf_pp_e_rpoint( ls_upd_operationoperator-workcenterid )
        time         = CONV atime( sy-uzeit )
        operator_tab = CONV zabsf_pp_t_operador( lt_operator_tab )
        shiftid      = CONV zabsf_pp_e_shiftid( ls_shiftid-value )
      CHANGING
        return_tab   = lt_return_tab.

    lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

    IF ls_upd_operationoperator-operationrunning EQ abap_false.
      CALL FUNCTION 'ZABSF_PP_SETOPERATORS'
        EXPORTING
          arbpl        = CONV arbpl( ls_upd_operationoperator-workcenterid )
          aufnr        = CONV aufnr( ls_upd_operationoperator-productionorderid )
          vornr        = CONV vornr( ls_upd_operationoperator-operationid )
          operator_tab = lt_operator_tab
          refdt        = sy-datum
          inputobj     = is_inputobj
          kapid        = CONV kapid( ls_upd_operationoperator-workcenterpositionid )
        IMPORTING
          return_tab   = lt_return_tab.

      lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).
    ELSE.
      CALL FUNCTION 'ZABSF_PP_SET_OPRID_AND_RESTART'
        EXPORTING
          arbpl        = CONV arbpl( ls_upd_operationoperator-workcenterid )
          aufnr        = CONV aufnr( ls_upd_operationoperator-productionorderid )
          vornr        = CONV vornr( ls_upd_operationoperator-operationid )
          operator_tab = lt_operator_tab
          refdt        = sy-datum
          inputobj     = is_inputobj
          tipo         = 0 "TODO: Check
          date         = sy-datum
          time         = CONV atime( sy-uzeit )
          rueck        = CONV co_rueck( ls_upd_operationoperator-oinfo-rueck )
          aufpl        = CONV co_aufpl( ls_upd_operationoperator-oinfo-aufpl )
          aplzl        = CONV co_aplzl( ls_upd_operationoperator-oinfo-aplzl )
          kapid        = CONV kapid( ls_upd_operationoperator-workcenterpositionid )
        IMPORTING
          return_tab   = lt_return_tab.

      lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).
    ENDIF.

    er_entity = lcl_utils=>copy_data_to_ref( ls_upd_operationoperator ).
  ENDMETHOD.


  METHOD upd_operationrework.
    DATA: lt_return_tab         TYPE bapiret2_t,
          ls_upd_operation      TYPE zabsf_cl_odata=>ty_operationrework,
          lt_upd_operation      TYPE tt_operation,
          ls_arbpl_print_st     TYPE zabsf_pp_s_arbpl_print,
          ls_qty_conf_tab       TYPE zabsf_pp_s_qty_conf,
          lt_qty_conf_tab       TYPE zabsf_pp_t_qty_conf,
          ls_print              TYPE zabsf_pp_s_arbpl_print,
          lt_tableordersequence TYPE STANDARD TABLE OF zabsf_pp_order_seq_s.

*    Get the property values
    READ TABLE it_keys INTO DATA(ls_id) WITH KEY name = 'ID'.
    READ TABLE it_keys INTO DATA(ls_productionorderid) WITH KEY name = 'PRODUCTIONORDERID'.
    READ TABLE it_keys INTO DATA(ls_hierarchyid) WITH KEY name = 'HIERARCHYID'.
    READ TABLE it_keys INTO DATA(ls_workcenterid) WITH KEY name = 'WORKCENTERID'.
    READ TABLE it_keys INTO DATA(ls_offlineversion) WITH KEY name = 'OFFLINEVERSION'.
    READ TABLE it_keys INTO DATA(ls_shiftid) WITH KEY name = 'SHIFTID'.
    READ TABLE it_keys INTO DATA(ls_defectid) WITH KEY name = 'DEFECTID'.

    " Read input data
    io_data_provider->read_entry_data( IMPORTING es_data = ls_upd_operation ).

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input  = ls_upd_operation-materialid
      IMPORTING
        output = ls_upd_operation-materialid.

    ls_upd_operation-id = ls_id-value.
    ls_upd_operation-productionorderid = replace( val = ls_productionorderid-value sub = `'` with = `` ).
    ls_upd_operation-workcenterid = replace( val = ls_workcenterid-value sub = `'` with = `` ).
    ls_upd_operation-offlineversion = ls_offlineversion-value.

    IF ls_upd_operation-oinfo IS INITIAL.
      DATA(lv_method_name) = lcl_utils=>get_method_name( ).
      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_entity_type = lv_method_name
          iv_msg_type    = `E`
          iv_msg_text    = `OInfo is null. Please contact your System Administrator.`.

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ENDIF.

*    DATA: lv_storage_location TYPE string,
*          lv_arbpl            TYPE arbpl.
*
*    lv_arbpl = CONV arbpl( ls_workcenterid-value ).
    DATA(lv_arbpl) = CONV arbpl( ls_workcenterid-value ).


    SELECT SINGLE df~lgort
    FROM zabsf_pp026 AS df
    INNER JOIN zabsf_pp026_t   AS dft
    ON df~werks EQ dft~werks
    AND df~areaid EQ dft~areaid
    WHERE  df~areaid = @is_inputobj-areaid
        AND df~werks = @is_inputobj-werks
        AND df~arbpl = @lv_arbpl
        AND dft~spras = @sy-langu
        AND df~defectid = @ls_defectid-value
*     INTO @DATA(statusstopdescription).
    INTO @DATA(lv_storage_location).

    DATA lv_num TYPE i.
    IF ls_upd_operation-goodquantity LE 0 OR ls_upd_operation-workcentertype EQ `R`.
      IF ls_upd_operation-goodquantity LE 0 AND ls_upd_operation-adjustmentquantity IS NOT INITIAL.
        lv_num = 1.
        lcl_helper_operation=>helper_12( EXPORTING is_inputobj = is_inputobj iv_num = lv_num CHANGING cs_upd_operation = ls_upd_operation co_msg = co_msg ).
      ELSE.
        lv_num = COND #( WHEN ls_upd_operation-workcentertype NE `R` THEN 1 ELSE 0 ).
        lcl_helper_operation=>helper_12( EXPORTING is_inputobj = is_inputobj iv_num = lv_num CHANGING cs_upd_operation = ls_upd_operation co_msg = co_msg ).
      ENDIF.
    ELSE.
      ls_upd_operation-confday = ``.
      ls_upd_operation-conftime = ``.

      DATA(ls_inputobj) = is_inputobj.
      ls_inputobj-dateconf = sy-datum.

      zcl_bc_fixed_values=>get_single_value( EXPORTING
                                       im_paramter_var = zcl_bc_fixed_values=>gc_reg_time_quant_cst
                                       im_modulesp_var = zcl_bc_fixed_values=>gc_productn_cst
                                     IMPORTING
                                       ex_prmvalue_var = DATA(lv_reg_time) ).

      ls_inputobj-timeconf = COND #( WHEN lv_reg_time EQ 'ABAP_TRUE'
                                          THEN sy-uzeit ).

      CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
        EXPORTING
          input  = ls_upd_operation-oinfo-matnr
        IMPORTING
          output = ls_upd_operation-oinfo-matnr.

      lt_qty_conf_tab = VALUE #( ( aufnr = ls_upd_operation-productionorderid
                                   vornr = ls_upd_operation-id
                                   matnr = ls_upd_operation-oinfo-matnr
                                   lmnga = ls_upd_operation-goodquantity
                                   required_qtt = ls_upd_operation-quantitytomake
                                   confirmed_qtt = ls_upd_operation-quantitymade
                                   wareid = ls_upd_operation-oinfo-wareid
                                   numb_cycle = COND #( WHEN ls_upd_operation-goodnrcycles NE 0 THEN ls_upd_operation-goodnrcycles )
                                   rueck = COND #( WHEN ls_upd_operation-previousoperationconfirmation IS NOT INITIAL THEN ls_upd_operation-previousoperationconfirmation )
                                   rmzhl = COND #( WHEN ls_upd_operation-previousoperationcounter IS NOT INITIAL THEN ls_upd_operation-previousoperationcounter )
                                   gmein = ls_upd_operation-unitvalue ) ).
      " Get storage location
      CALL METHOD lcl_helper_operation=>set_quantity_stor_location(
        EXPORTING
          arbpl            = CONV arbpl( ls_upd_operation-workcenterid )
          qty_conf_tab     = lt_qty_conf_tab
          tipord           = CONV zabsf_pp_e_tipord( ls_upd_operation-oinfo-tipord )
          refdt            = sy-datum
          inputobj         = ls_inputobj
          first_cycle      = CONV flag( |{ condense( val = ls_upd_operation-firstcycle from = `` ) }| )
          supervisor       = CONV flag( ls_upd_operation-areaadminvalidated )
          shiftid          = CONV zabsf_pp_e_shiftid( ls_shiftid-value )
          materialbatch    = ls_upd_operation-materialbatch[]
          materialserial   = ls_upd_operation-materialserial[]
          storage_location = CONV string( lv_storage_location )
        IMPORTING
          return_tab       = lt_return_tab ).

      lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

* Start Change ABACO(AON) : 10.01.2023
* Description: Insert into zabsf_pp004
      DATA(ls_zabsf_pp004) = VALUE zabsf_pp004( seqid = |{ lcl_helper_operationrework=>get_seqid( ) }|
                                                hname = CONV cr_hname( ls_hierarchyid-value )
                                                arbpl = CONV arbpl( ls_workcenterid-value )
                                                aufnr = CONV aufnr( ls_upd_operation-productionorderid  )
                                                defectid = CONV zabsf_pp_e_defectid( ls_defectid-value )
                                                rework = CONV ru_rmnga( ls_upd_operation-goodquantity )
                                                vorme = CONV ru_vorme( ls_upd_operation-oinfo-vorne )
                                                oprid = CONV ru_exnam( is_inputobj-oprid )
                                                data = sy-datum
                                                timer  = sy-uzeit ).
      INSERT zabsf_pp004 FROM ls_zabsf_pp004.
* End Change ABACO(AON) : 10.01.2022
    ENDIF.

    CALL METHOD lcl_helper_operation=>helper_81
      EXPORTING
        is_inputobj      = is_inputobj
      CHANGING
        cs_upd_operation = ls_upd_operation
        co_msg           = co_msg.

    er_entity = lcl_utils=>copy_data_to_ref( ls_upd_operation ).
  ENDMETHOD.


  METHOD upd_reportpointgoodsmvt.
    DATA:
      lref_sf_consum TYPE REF TO zif_absf_pp_consumptions,
      ls_goodsmvt    TYPE ty_reportpointgoodsmvt,
      lt_return      TYPE bapiret2_t.

    DATA(lv_matnr)     = VALUE #( it_keys[ name = 'MATNR' ]-value OPTIONAL ).
    DATA(lv_vorne)     = VALUE #( it_keys[ name = 'VORNE' ]-value OPTIONAL ).
    DATA(lv_refdt)     = VALUE #( it_keys[ name = 'REFDT' ]-value OPTIONAL ).

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input        = lv_matnr
      IMPORTING
        output       = lv_matnr
      EXCEPTIONS
        length_error = 1
        OTHERS       = 2.

    IF sy-subrc EQ 0.
      " Read input data
      io_data_provider->read_entry_data( IMPORTING es_data = ls_goodsmvt ).

      TRANSLATE lv_refdt USING '- '.
      CONDENSE lv_refdt NO-GAPS.

      CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
        EXPORTING
          input        = ls_goodsmvt-matnr
        IMPORTING
          output       = ls_goodsmvt-matnr
        EXCEPTIONS
          length_error = 1
          OTHERS       = 2.

      IF ls_goodsmvt-components[] IS NOT INITIAL.
        LOOP AT ls_goodsmvt-components ASSIGNING FIELD-SYMBOL(<fs_components>).
          CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
            EXPORTING
              input  = <fs_components>-matnr
            IMPORTING
              output = <fs_components>-matnr.
        ENDLOOP.
      ENDIF.

*Get class of interface
      SELECT id_class, imp_clname, methodname
          FROM zabsf_pp003
          INTO TABLE @DATA(lt_pp003)
         WHERE werks    EQ @is_inputobj-werks
           AND id_class IN ( '7', '25' )
           AND endda    GE @lv_refdt
           AND begda    LE @lv_refdt.
      CHECK sy-subrc IS INITIAL.

      DATA(lv_class)   = lt_pp003[ 1 ]-imp_clname.
      DATA(lv_method)  = VALUE #( lt_pp003[ id_class = '7' ]-methodname OPTIONAL ).
      DATA(lv_method2) = VALUE #( lt_pp003[ id_class = '25' ]-methodname OPTIONAL ).

      TRY .
          CREATE OBJECT lref_sf_consum TYPE (lv_class)
            EXPORTING
              initial_refdt = CONV datum( lv_refdt )
              input_object  = is_inputobj.

        CATCH cx_sy_create_object_error.
*
          CALL METHOD zcl_lp_pp_sf_log=>add_message
            EXPORTING
              msgty      = 'E'
              msgno      = '019'
              msgv1      = lv_class
            CHANGING
              return_tab = lt_return.

          EXIT.
      ENDTRY.

      IF ls_goodsmvt-lmnga > 0.

        CALL METHOD lref_sf_consum->(lv_method)
          EXPORTING
            matnr          = CONV matnr( lv_matnr )
            vorne          = CONV pzpnr( lv_vorne )
            lmnga          = CONV lmnga( ls_goodsmvt-lmnga )
            meins          = CONV meins( ls_goodsmvt-meins )
            planorder      = CONV plnum( ls_goodsmvt-planorder )
            components_tab = ls_goodsmvt-components
            materialbatch  = ls_goodsmvt-materialbatch
            materialserial = ls_goodsmvt-materialserial
          CHANGING
            return_tab     = lt_return.
      ELSEIF ls_goodsmvt-mlmnga > 0.
        CALL METHOD lref_sf_consum->(lv_method2)
          EXPORTING
            iv_matnr  = CONV matnr( ls_goodsmvt-matnr )
            iv_lmnga  = CONV lmnga( ls_goodsmvt-mlmnga )
            iv_meins  = CONV meins( ls_goodsmvt-meins )
            iv_slgort = CONV lgort_d( ls_goodsmvt-slgort )
            iv_dlgort = CONV lgort_d( ls_goodsmvt-dlgort )
          CHANGING
            ct_return = lt_return.
      ENDIF.

      DELETE ADJACENT DUPLICATES FROM lt_return.

      lcl_utils=>validatesapresponse(
        EXPORTING it_result = lt_return
        CHANGING  co_msg    = co_msg ).

    ELSE.
      MESSAGE e002(z_sf_messages) INTO DATA(lv_msg).

      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( lv_msg ).

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ENDIF.

    er_entity = lcl_utils=>copy_data_to_ref( ls_goodsmvt ).
  ENDMETHOD.


  METHOD upd_reportpointoperation.
    DATA:
      lref_sf_rpoint          TYPE REF TO zabsf_pp_cl_rpoint,
      ls_reportpointoperation TYPE ty_reportpointoperations,
      lt_return_tab           TYPE bapiret2_t.

    DATA(lv_rpoint)  = VALUE #( it_keys[ name = 'RPOINT'  ]-value OPTIONAL ).
    DATA(lv_matnr)   = VALUE #( it_keys[ name = 'MATNR'   ]-value OPTIONAL ).
    DATA(lv_vornr)   = VALUE #( it_keys[ name = 'VORNR'   ]-value OPTIONAL ).

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input        = lv_matnr
      IMPORTING
        output       = lv_matnr
      EXCEPTIONS
        length_error = 1
        OTHERS       = 2.

    IF sy-subrc EQ 0.
      " Read input data
      io_data_provider->read_entry_data( IMPORTING es_data = ls_reportpointoperation ).

      TRANSLATE ls_reportpointoperation-refdt USING '- '.
      CONDENSE ls_reportpointoperation-refdt NO-GAPS.

      CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
        EXPORTING
          input        = ls_reportpointoperation-matnr
        IMPORTING
          output       = ls_reportpointoperation-matnr
        EXCEPTIONS
          length_error = 1
          OTHERS       = 2.

      CREATE OBJECT lref_sf_rpoint
        EXPORTING
          initial_refdt = CONV #( ls_reportpointoperation-refdt )
          input_object  = CORRESPONDING #( is_inputobj ).

      CALL METHOD lref_sf_rpoint->add_rem_matnr
        EXPORTING
          hname      = CONV #( ls_reportpointoperation-hname )
          rpoint     = CONV #( lv_rpoint )
          matnr      = CONV #( lv_matnr )
          add_rem    = CONV #( ls_reportpointoperation-add_rem )
          vornr      = CONV #( lv_vornr )
        CHANGING
          return_tab = lt_return_tab.

      DELETE ADJACENT DUPLICATES FROM lt_return_tab.

      lcl_utils=>validatesapresponse(
        EXPORTING it_result = lt_return_tab
        CHANGING  co_msg    = co_msg ).
    ELSE.
      MESSAGE e002(z_sf_messages) INTO DATA(lv_msg).

      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( lv_msg ).

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ENDIF.

    er_entity = lcl_utils=>copy_data_to_ref( ls_reportpointoperation ).
  ENDMETHOD.


  METHOD upd_reportpointpassage.
    DATA:
      lref_sf_rpoint TYPE REF TO zabsf_pp_cl_rpoint,
      ls_passage     TYPE ty_reportpointpassage,
      lt_return      TYPE bapiret2_t.

    DATA(lv_hname)      = VALUE #( it_keys[ name = 'HNAME' ]-value OPTIONAL ).
    DATA(lv_rpoint)     = VALUE #( it_keys[ name = 'RPOINT' ]-value OPTIONAL ).
    DATA(lv_matnr)      = VALUE #( it_keys[ name = 'MATNR' ]-value OPTIONAL ).
    DATA(lv_gernr)      = VALUE #( it_keys[ name = 'GERNR' ]-value OPTIONAL ).
    DATA(lv_refdt)      = VALUE #( it_keys[ name = 'REFDT'  ]-value OPTIONAL ).

    " Read input data
    io_data_provider->read_entry_data( IMPORTING es_data = ls_passage ).

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input  = lv_matnr
      IMPORTING
        output = lv_matnr.

    IF sy-subrc EQ 0.

      TRANSLATE lv_refdt USING '- '.
      CONDENSE lv_refdt NO-GAPS.

      CREATE OBJECT lref_sf_rpoint
        EXPORTING
          initial_refdt = CONV vvdatum( lv_refdt )
          input_object  = is_inputobj.

      CALL METHOD lref_sf_rpoint->set_pass_material
        EXPORTING
          hname      = CONV #( lv_hname )
          rpoint     = CONV #( lv_rpoint )
          matnr      = CONV #( lv_matnr )
          gernr      = CONV #( lv_gernr )
          passnumber = CONV #( ls_passage-passnumber )
          flag_def   = CONV #( ls_passage-flag_def )
          defectid   = ls_passage-defectid
        CHANGING
          return_tab = lt_return.

      DELETE ADJACENT DUPLICATES FROM lt_return.

      lcl_utils=>validatesapresponse(
        EXPORTING it_result = lt_return
        CHANGING  co_msg    = co_msg ).

    ELSE.
      MESSAGE e002(z_sf_messages) INTO DATA(lv_msg).

      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( lv_msg ).

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ENDIF.

    er_entity = lcl_utils=>copy_data_to_ref( ls_passage ).
  ENDMETHOD.


  METHOD upd_reportpointquality.
    DATA:
      lref_sf_rpoint TYPE REF TO zabsf_pp_cl_rpoint,
      ls_quality     TYPE ty_reportpointquality,
      lt_return      TYPE bapiret2_t.

    DATA(lv_rpoint) = VALUE #( it_keys[ name = 'RPOINT' ]-value OPTIONAL ).
    DATA(lv_matnr)  = VALUE #( it_keys[ name = 'MATNR' ]-value OPTIONAL ).
    DATA(lv_refdt)  = VALUE #( it_keys[ name = 'REFDT' ]-value OPTIONAL ).

    " Read input data
    io_data_provider->read_entry_data( IMPORTING es_data = ls_quality ).

    TRANSLATE lv_refdt USING '- '.
    CONDENSE lv_refdt NO-GAPS.

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input        = lv_matnr
      IMPORTING
        output       = lv_matnr
      EXCEPTIONS
        length_error = 1
        OTHERS       = 2.

    IF sy-subrc EQ 0.

      CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
        EXPORTING
          input        = ls_quality-matnr
        IMPORTING
          output       = ls_quality-matnr
        EXCEPTIONS
          length_error = 1
          OTHERS       = 2.

      CREATE OBJECT lref_sf_rpoint
        EXPORTING
          initial_refdt = CONV #( lv_refdt )
          input_object  = is_inputobj.

      IF ls_quality-rework[] IS NOT INITIAL.
        " Defect registration by Report Point
        CALL METHOD lref_sf_rpoint->set_quality_rpoint
          EXPORTING
            rpoint     = CONV #( lv_rpoint )
            matnr      = CONV #( lv_matnr )
            rework_tab = ls_quality-rework
            scrap_qty  = ''
            grund      = ''
          CHANGING
            return_tab = lt_return.
      ELSE.
*BEGIN JOL - 04/11/2022 - quantity scrap by material
        CALL METHOD lref_sf_rpoint->set_scrap_rpoint
          EXPORTING
            rpoint      = CONV #( lv_rpoint )
            matnr       = CONV #( lv_matnr )
*           planorder   = planorder  " Nº ordem planejada
            refdt       = CONV #( lv_refdt )
            is_inputobj = is_inputobj
            scrap_tab   = ls_quality-scrap  " Shopfloor - Quantidade de SUCATA e tipo de defeito
          CHANGING
            return_tab  = lt_return.
      ENDIF.
** END JOL.

      DELETE ADJACENT DUPLICATES FROM lt_return.

      lcl_utils=>validatesapresponse(
        EXPORTING it_result = lt_return
        CHANGING  co_msg    = co_msg ).
    ELSE.
      MESSAGE e002(z_sf_messages) INTO DATA(lv_msg).

      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( lv_msg ).

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ENDIF.

    er_entity = lcl_utils=>copy_data_to_ref( ls_quality ).
  ENDMETHOD.


  METHOD upd_reportpointsetoperator.
    DATA:
      lref_sf_operator    TYPE REF TO zabsf_pp_cl_operator,
      ls_operators        TYPE ty_reportpointsetoperator,
      lt_return           TYPE bapiret2_t,
      lv_class            TYPE recaimplclname,
      lv_method           TYPE seocmpname,
      lv_msg              TYPE string.

    DATA(lv_rpoint) = VALUE #( it_keys[ name = 'RPOINT' ]-value OPTIONAL ).
    DATA(lv_time)   = VALUE #( it_keys[ name = 'TIME'   ]-value OPTIONAL ).
    DATA(lv_refdt)  = VALUE #( it_keys[ name = 'REFDT'  ]-value OPTIONAL ).
    DATA(lv_shiftid)  = VALUE #( it_keys[ name = 'SHIFTID'  ]-value OPTIONAL ).

    " Read input data
    io_data_provider->read_entry_data( IMPORTING es_data = ls_operators ).

    TRANSLATE lv_refdt USING '- '.
    CONDENSE lv_refdt NO-GAPS.

    TRANSLATE lv_time USING ': '.
    CONDENSE lv_time NO-GAPS.

    DATA(lv_valid) = lcl_helper_token=>authenticate( EXPORTING iv_username = CONV #( ls_operators-operators[ 1 ]-oprid )
                                                               iv_password = CONV #( ls_operators-operators[ 1 ]-password ) ).

" validar se o utilizador está assignado ao centro de trabalho.
    IF lv_valid EQ abap_true.
      DATA(lt_workcenters) = VALUE zabsf_pp_tt_user_workcenters( FOR w IN zabsf_pp_cl_user=>get_userworkcenters( CONV #( ls_operators-operators[ 1 ]-oprid ) ) (
                                                            id = COND #( WHEN w-objty EQ 'A' THEN w-arbpl ELSE w-hname )
                                                            parentid    = COND #( WHEN w-objty EQ 'A' THEN w-hname ELSE '' )
                                                            description = w-ktext
                                                            objty       = w-objty ) ).

      IF NOT line_exists( lt_workcenters[ id = lv_rpoint ] ).
        lv_msg = `Utilizador não está associado ao Centro de Trabalho.`.

        co_msg->add_message_text_only( EXPORTING iv_msg_type = 'E'
                                        iv_msg_text = CONV #( lv_msg ) ).

        " Raising Exception
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            message_container = co_msg.
      ENDIF.

      " Get class of interface
      SELECT SINGLE imp_clname methodname
          FROM zabsf_pp003
          INTO (lv_class, lv_method)
         WHERE werks    EQ is_inputobj-werks
           AND id_class EQ '11'
           AND endda    GE lv_refdt
           AND begda    LE lv_refdt.

      TRY .
          CREATE OBJECT lref_sf_operator TYPE (lv_class)
            EXPORTING
              initial_refdt = CONV datum( lv_refdt )
              input_object  = is_inputobj.

          CALL METHOD lref_sf_operator->(lv_method)
            EXPORTING
              rpoint       = CONV zabsf_pp_e_rpoint( lv_rpoint )
              time         = CONV atime( lv_time )
              shiftid      = CONV zabsf_pp_e_shiftid( lv_shiftid )
              operator_tab = ls_operators-operators
            CHANGING
              return_tab   = lt_return.

        CATCH cx_sy_create_object_error.
          IF 1 = 2. MESSAGE e019(zabsf_pp). ENDIF.
          " No data for object in customizing table
          CALL METHOD zabsf_pp_cl_log=>add_message
            EXPORTING
              msgty      = 'E'
              msgno      = '019'
              msgv1      = lv_class
            CHANGING
              return_tab = lt_return.
      ENDTRY.

      DELETE ADJACENT DUPLICATES FROM lt_return.

      lcl_utils=>validatesapresponse(
        EXPORTING it_result = lt_return
        CHANGING  co_msg    = co_msg ).

    ELSE.
      MESSAGE e011(z_sf_messages) INTO lv_msg.

      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( lv_msg ).

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ENDIF.

    er_entity = lcl_utils=>copy_data_to_ref( ls_operators ).
  ENDMETHOD.


  METHOD upd_scrapmissing.
    DATA: ls_scrapmissing TYPE ty_scrapmissing,
          lt_return_tab   TYPE bapiret2_t,
          wa_zabsf_pp034  TYPE zabsf_pp034.

    READ TABLE it_keys INTO DATA(ls_productionorderid) WITH KEY name = 'PRODUCTIONORDERID'.
    READ TABLE it_keys INTO DATA(ls_operationid) WITH KEY name = 'OPERATIONID'.
    READ TABLE it_keys INTO DATA(ls_hierarchyid) WITH KEY name = 'HIERARCHYID'.
    READ TABLE it_keys INTO DATA(ls_workcenterid) WITH KEY name = 'WORKCENTERID'.
    READ TABLE it_keys INTO DATA(ls_id) WITH KEY name = 'ID'.
    READ TABLE it_keys INTO DATA(ls_material) WITH KEY name = 'MATERIAL'.
    READ TABLE it_keys INTO DATA(ls_unit) WITH KEY name = 'UNIT'.
    READ TABLE it_keys INTO DATA(ls_shiftid) WITH KEY name = 'SHIFTID'.

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input  = ls_material-value
      IMPORTING
        output = ls_material-value.

    " Read input data
    io_data_provider->read_entry_data( IMPORTING es_data = ls_scrapmissing ).

    ls_scrapmissing-workcenterid = ls_workcenterid-value.
    ls_scrapmissing-id = ls_id-value.

    IF ls_scrapmissing-scrapquantity GT 0.
      DATA(ls_inputobj) = is_inputobj.
      ls_inputobj-dateconf = sy-datum.
      ls_inputobj-timeconf = sy-uzeit.

      CALL FUNCTION 'ZABSF_PP_SETQUANTITY_REWORK'
        EXPORTING
          arbpl           = CONV arbpl( ls_workcenterid-value )
          aufnr           = CONV aufnr( ls_productionorderid-value )
          vornr           = CONV vornr( ls_operationid-value )
          matnr           = CONV matnr( ls_material-value )
          scrap_qty       = CONV ru_xmnga( ls_scrapmissing-scrapquantity )
          numb_cycle      = COND #( WHEN ls_scrapmissing-goodnrcycles IS NOT INITIAL AND ls_scrapmissing-goodnrcycles GT 0 THEN CONV numc10( ls_scrapmissing-goodnrcycles ) )
          grund           = CONV co_agrnd( ls_scrapmissing-id )
          flag_scrap_list = abap_true
          refdt           = sy-datum
          shiftid         = CONV zabsf_pp_e_shiftid( ls_shiftid-value )
          inputobj        = ls_inputobj
        IMPORTING
          return_tab      = lt_return_tab.

      lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

      IF sy-subrc IS INITIAL AND ls_scrapmissing-scrapquantity GT 0.
* Start Change ABACO(AON) : 10.01.2023
* Description: Insert into zabsf_pp034
        DATA(ls_zabsf_pp034) = VALUE zabsf_pp034( areaid = ls_inputobj-areaid
                                                  hname = ls_hierarchyid-value
                                                  arbpl = ls_workcenterid-value
                                                  matnr = ls_material-value
                                                  data = ls_inputobj-dateconf
                                                  time = ls_inputobj-timeconf
                                                  grund = ls_id-value
                                                  oprid = CONV ru_exnam( is_inputobj-oprid )
                                                  scrap_qty = ls_scrapmissing-scrapquantity
                                                  gmein = ls_unit-value ).
        INSERT zabsf_pp034 FROM ls_zabsf_pp034.
* End Change ABACO(AON) : 10.01.2022
      ENDIF.
    ENDIF.
    er_entity = lcl_utils=>copy_data_to_ref( ls_scrapmissing ).
  ENDMETHOD.


  METHOD upd_shift.
    " Data Declarations
    DATA: lt_return_tab   TYPE bapiret2_t,
          ls_update_shift TYPE ty_shift.

    READ TABLE it_keys INTO DATA(ls_shift) WITH KEY name = 'SHIFTID'.

    " Read input data
    io_data_provider->read_entry_data( IMPORTING es_data = ls_update_shift ).

    DATA shiftid TYPE zabsf_pp_e_shiftid.
    shiftid = ls_update_shift-shiftid.

    IF ls_update_shift-active EQ abap_true.
      CALL FUNCTION 'ZABSF_PP_SETUSER'
        EXPORTING
          shiftid    = shiftid
          refdt      = sy-datum
          inputobj   = is_inputobj
        IMPORTING
          return_tab = lt_return_tab.
    ELSE.
      CALL FUNCTION 'ZABSF_PP_UNSETUSER'
        EXPORTING
          shiftid    = shiftid
          refdt      = sy-datum
          inputobj   = is_inputobj
        IMPORTING
          return_tab = lt_return_tab.
    ENDIF.

    IF ( sy-subrc = 0 ).
      " update completed
      COMMIT WORK AND WAIT.
    ELSE.
      MESSAGE e002(z_sf_messages) INTO DATA(lv_msg).

      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( lv_msg ).

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ENDIF.
    er_entity = lcl_utils=>copy_data_to_ref( ls_update_shift ).
  ENDMETHOD.


METHOD upd_user.
    DATA: ls_user  TYPE ty_user,
          lv_msg   TYPE string,
          lv_langu TYPE spras.

    " Get the property values
    READ TABLE it_keys INTO DATA(ls_username) WITH KEY name = 'USERNAME'.

    " Read input data
    io_data_provider->read_entry_data( IMPORTING es_data = ls_user ).

* BEGIN JOL - 07/12/2022: change password / change userlanguage / change other user data
    IF ls_user-password <> ''.
      " Hash input password
      DATA(lv_hashed_password) = zabsf_pp_cl_authentication=>get_hashed_password( EXPORTING iv_password = ls_user-password ).

      UPDATE zsf_auth SET passwordhash = lv_hashed_password
      WHERE username = ls_username-value.

      IF ( sy-subrc = 0 ).
        " update completed
        COMMIT WORK AND WAIT.
      ELSE.
        MESSAGE e002(z_sf_messages) INTO lv_msg.

        CALL METHOD co_msg->add_message_text_only
          EXPORTING
            iv_msg_type = 'E'
            iv_msg_text = CONV #( lv_msg ).

        " Raising Exception
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            message_container = co_msg.
      ENDIF.

    ELSEIF ls_user-userlanguage <> ''.
      UPDATE zsf_users SET userlanguage = ls_user-userlanguage
                           language     = ls_user-userlanguage
                       WHERE username   = ls_username-value.

      IF ( sy-subrc = 0 ).
        " update completed
        COMMIT WORK AND WAIT.
      ELSE.
        MESSAGE e002(z_sf_messages) INTO lv_msg.

        CALL METHOD co_msg->add_message_text_only
          EXPORTING
            iv_msg_type = 'E'
            iv_msg_text = CONV #( lv_msg ).

        " Raising Exception
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            message_container = co_msg.
      ENDIF.

    ELSE.
      DATA(lv_validfrom) = cl_xlf_date_time=>parse( EXPORTING iso8601 = ls_user-validfrom ).
      DATA(lv_validto) = cl_xlf_date_time=>parse( EXPORTING iso8601 = ls_user-validto ).

      UPDATE zsf_users SET center         = ls_user-center
                           usersap        = ls_user-usersap
                           hierarchies    = ls_user-hierarchies
                           name           = ls_user-name
                           userarea       = ls_user-userarea
                           roleid         = ls_user-roleid
                           validfrom      = lv_validfrom
                           validto        = lv_validto
                           usererpid      = ls_user-usererpid
                           usersupplierid = ls_user-usersupplierid
                        WHERE username = ls_username-value.

      IF ( sy-subrc = 0 ).
        UPDATE zsf_authroleuser SET roleid = ls_user-authorizationroleid
                                WHERE username = ls_username-value.
        IF ( sy-subrc = 0 ).
          COMMIT WORK AND WAIT.

          zabsf_pp_cl_user=>upd_userworkcenters(
            iv_username    = CONV #( ls_username-value )
            it_workcenters = ls_user-workcenters
          ).
        ELSE.
          MESSAGE e002(z_sf_messages) INTO lv_msg.

          CALL METHOD co_msg->add_message_text_only
            EXPORTING
              iv_msg_type = 'E'
              iv_msg_text = CONV #( lv_msg ).

          " Raising Exception
          RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
            EXPORTING
              message_container = co_msg.
        ENDIF.
      ELSE.
        MESSAGE e002(z_sf_messages) INTO lv_msg.

        CALL METHOD co_msg->add_message_text_only
          EXPORTING
            iv_msg_type = 'E'
            iv_msg_text = CONV #( lv_msg ).

        " Raising Exception
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            message_container = co_msg.
      ENDIF.
    ENDIF.
* END JOL - 07/12/2022

    er_entity = lcl_utils=>copy_data_to_ref( ls_user ).
  ENDMETHOD.


METHOD upd_usersap.
    DATA: ls_update_usersap TYPE ty_usersap.

    " Read UserSAP key
    READ TABLE it_keys INTO DATA(ls_usersap) WITH KEY name = 'USERSAP'.

    " Read input data
    io_data_provider->read_entry_data( IMPORTING es_data = ls_update_usersap ).

*    " Hash user password
    zabsf_pp_cl_authentication=>new_update_sap_user_pwd( iv_username = CONV #( ls_usersap-value ) iv_password = CONV #( ls_update_usersap-password ) ).

    IF ( sy-subrc = 0 ).
      " update completed
      COMMIT WORK AND WAIT.
    ELSE.
      MESSAGE e002(z_sf_messages) INTO DATA(lv_msg).

      CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = CONV #( lv_msg ).

      " Raising Exception
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = co_msg.
    ENDIF.
    er_entity = lcl_utils=>copy_data_to_ref( ls_update_usersap ).
  ENDMETHOD.


  METHOD upd_workcenter.
    DATA: lt_return_tab     TYPE bapiret2_t,
          ls_upd_workcenter TYPE ty_workcenter,
          lt_upd_workcenter TYPE tt_workcenter,
          lt_count_fin      TYPE zabsf_pp_t_counters.

    " Read input data
    io_data_provider->read_entry_data( IMPORTING es_data = ls_upd_workcenter ).

    IF ls_upd_workcenter-stopreasonid IS NOT INITIAL.
      TYPES:
        BEGIN OF ty_finalcyclebyoperation,
          orderid           TYPE string,
          operationid       TYPE string,
          finalcyclecounter TYPE string,
        END OF ty_finalcyclebyoperation .

      TYPES:
        tt_finalcyclebyoperation TYPE STANDARD TABLE OF ty_finalcyclebyoperation WITH DEFAULT KEY .

      DATA lt_finalcyclebyoperation TYPE tt_finalcyclebyoperation.

      /ui2/cl_json=>deserialize( EXPORTING json = ls_upd_workcenter-finalcyclesbyoperation pretty_name = /ui2/cl_json=>pretty_mode-low_case CHANGING data = lt_finalcyclebyoperation ).

      lt_count_fin = VALUE #( FOR ls_finalcyclesbyoperation IN lt_finalcyclebyoperation ( aufnr = ls_finalcyclesbyoperation-orderid
                                                                                          vornr = ls_finalcyclesbyoperation-operationid
                                                                                          count_fin = ls_finalcyclesbyoperation-finalcyclecounter ) ).

      CALL FUNCTION 'ZABSF_PP_SETSTOP_REASON_WRK'
        EXPORTING
          arbpl         = CONV arbpl( ls_upd_workcenter-id )
          datesr        = CONV zabsf_pp_e_date( sy-datum )
          time          = CONV atime( sy-uzeit )
          stprsnid      = CONV zabsf_pp_e_stprsnid( ls_upd_workcenter-stopreasonid )
          actionid      = CONV zabsf_pp_e_action( 'STOP' )
          shiftid       = CONV zabsf_pp_e_shiftid( ls_upd_workcenter-shiftid )
          hname         = CONV cr_hname( ls_upd_workcenter-hierarchyid )
          count_fin_tab = lt_count_fin
          refdt         = sy-datum
          inputobj      = is_inputobj
        IMPORTING
          return_tab    = lt_return_tab.

      lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

    ELSEIF ls_upd_workcenter-statusid IS NOT INITIAL.

      DATA(lv_actionid) = COND #( WHEN ls_upd_workcenter-statusid EQ '0002' THEN 'NEXT' ).

      CALL FUNCTION 'ZABSF_PP_SETSTOP_REASON_WRK'
        EXPORTING
          arbpl      = CONV arbpl( ls_upd_workcenter-id )
          datesr     = CONV zabsf_pp_e_date( sy-datum )
          time       = CONV atime( sy-uzeit )
          stprsnid   = CONV zabsf_pp_e_stprsnid( '' )
          actionid   = CONV zabsf_pp_e_action( lv_actionid )
          shiftid    = CONV zabsf_pp_e_shiftid( ls_upd_workcenter-shiftid )
          hname      = CONV cr_hname( ls_upd_workcenter-hierarchyid )
          refdt      = sy-datum
          inputobj   = is_inputobj
        IMPORTING
          return_tab = lt_return_tab.

      lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).
    ENDIF.
    er_entity = lcl_utils=>copy_data_to_ref( ls_upd_workcenter ).
  ENDMETHOD.


  METHOD upd_workday.
    DATA:
      ls_workday TYPE ty_workday.

    TRY.
        " Read input data
        io_data_provider->read_entry_data( IMPORTING es_data = ls_workday ).

        DATA(lo_workday) = NEW lcl_workday( is_inputobj ).

        lo_workday->parse_file(
          EXPORTING it_content = ls_workday-content
          IMPORTING et_workday = DATA(lt_workday) ).

        " Check if file have at least a header and one entry
        CHECK lines( lt_workday ) GE 2.
        DELETE lt_workday INDEX 1.

        " Get order types
        lo_workday->get_order_type( lt_workday ).

        LOOP AT lt_workday ASSIGNING FIELD-SYMBOL(<ls_workday>).
          lo_workday->set_tabix( sy-tabix ).

          " Check if all necessaries fields was filled
          CHECK lo_workday->check_required_field( iv_field = TEXT-f03 iv_value = <ls_workday>-arbpl )
            AND lo_workday->check_required_field( iv_field = TEXT-f04 iv_value = <ls_workday>-isdd )
            AND lo_workday->check_required_field( iv_field = TEXT-f05 iv_value = <ls_workday>-isbz )
            AND lo_workday->check_required_field( iv_field = TEXT-f06 iv_value = <ls_workday>-iebz )
            AND lo_workday->check_required_field( iv_field = TEXT-f07 iv_value = <ls_workday>-oprid ).

          lo_workday->convert_date( CHANGING cv_date = <ls_workday>-isdd ).
          lo_workday->convert_time( CHANGING cv_time = <ls_workday>-isbz ).
          lo_workday->convert_time( CHANGING cv_time = <ls_workday>-iebz ).

          " Try to get the shift id
          CHECK lo_workday->set_shiftid( <ls_workday> ).

          lo_workday->add_stop( <ls_workday> ).
          lo_workday->add_good_quantity( <ls_workday> ).
          lo_workday->add_rework_scrap_quantity( <ls_workday> ).
        ENDLOOP.

      CATCH /iwbep/cx_mgw_tech_exception.
    ENDTRY.

    lo_workday->save_stops( ).

    lcl_utils=>validatesapresponse( EXPORTING it_result = lo_workday->gt_return CHANGING co_msg = co_msg ).

    er_entity = lcl_utils=>copy_data_to_ref( ls_workday ).
  ENDMETHOD.
ENDCLASS.
