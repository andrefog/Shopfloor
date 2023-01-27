*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

*Temp order detail
types: begin of ty_prdord_temp,
         aufnr    type aufnr,
         objnr    type j_objnr,
         auart    type auart,
         gstrp    type pm_ordgstrp,
         gltrp    type co_gltrp,
         gstrs    type co_gstrs,
         gsuzs    type co_gsuzs,
         gltrs    type co_gltrs,
         ftrmi    type co_ftrmi,
         gamng    type gamng,
         gmein    type meins,
         plnbez   type matnr,
         plnty    type plnty,
         plnnr    type plnnr,
         stlbez   type matnr,
         aufpl    type co_aufpl,
         aplzl    type co_aplzl,
         trmdt    type trmdt,
         vornr    type vornr,
         ltxa1    type ltxa1,
         steus    type steus,
         rueck    type co_rueck,
         rmzhl    type co_rmzhl,
         lmnga    type ru_lmnga,
         stat     type j_status,
         zerma    type dzerma,
         autwe    type autwe,
         ruek     type ruek,
         marco    type flag,
         cy_seqnr type cy_seqnr,
       end of ty_prdord_temp.

*Unassign order detail
types: begin of ty_prdord_unassign,
         aufnr  type aufnr,
         gstrs  type co_gstrs,
         gsuzs  type co_gsuzs,
         plnbez type matnr,
         stlbez type matnr,
         vornr  type vornr,
         ltxa1  type ltxa1,
         stat   type j_status,
       end of ty_prdord_unassign.
