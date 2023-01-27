*&---------------------------------------------------------------------*
*& Report  Z_LP_PP_SF_COCKPIT
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zabsf_pp_sf_cockpit.

INCLUDE zabsf_pp_cockpit_top.

*Call Screen of cockpit
CALL SCREEN 100.

INCLUDE zabsf_pp_cockpit_o01.
INCLUDE zabsf_pp_cockpit_i01.
