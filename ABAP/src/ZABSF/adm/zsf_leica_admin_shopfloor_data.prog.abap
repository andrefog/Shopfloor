*&---------------------------------------------------------------------*
*& Report ZSF_LEICA_ADMIN_SHOPFLOOR_DATA
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsf_leica_admin_shopfloor_data.

PARAMETERS:
  p_auth   AS CHECKBOX,
  p_autha  AS CHECKBOX,
  p_authao AS CHECKBOX,
  p_autho  AS CHECKBOX,
  p_authp  AS CHECKBOX,
  p_authpr AS CHECKBOX,
  p_authr  AS CHECKBOX,
  p_authru AS CHECKBOX,
  p_users  AS CHECKBOX,
  p_userss AS CHECKBOX,
  p_action AS CHECKBOX,
  p_roles  AS CHECKBOX,
  p_permi  AS CHECKBOX.

DATA(lv_do_zsf_auth) = abap_false.
DATA(lv_do_zsf_authact) = abap_false.
DATA(lv_do_zsf_authactobj) = abap_false.
DATA(lv_do_zsf_authobj) = abap_false.
DATA(lv_do_zsf_authprof) = abap_false.
DATA(lv_do_zsf_authprofrole) = abap_false.
DATA(lv_do_zsf_authrole) = abap_false.
DATA(lv_do_zsf_authroleuser) = abap_false.
DATA(lv_do_zsf_users) = abap_false.
DATA(lv_do_zsf_userssap) = abap_false.
DATA(lv_do_zsf_actions) = abap_false.
DATA(lv_do_zsf_roles) = abap_false.
DATA(lv_do_zsf_permissions) = abap_false.

lv_do_zsf_auth         = p_auth.
lv_do_zsf_authact      = p_autha.
lv_do_zsf_authactobj   = p_authao.
lv_do_zsf_authobj      = p_autho.
lv_do_zsf_authprof     = p_authp.
lv_do_zsf_authprofrole = p_authpr.
lv_do_zsf_authrole     = p_authr.
lv_do_zsf_authroleuser = p_authru.
lv_do_zsf_users        = p_users.
lv_do_zsf_userssap     = p_userss.
lv_do_zsf_actions      = p_action.
lv_do_zsf_roles        = p_roles.
lv_do_zsf_permissions  = p_permi.

IF lv_do_zsf_auth EQ abap_true.
  DELETE FROM zsf_auth.
  DATA ls_auth TYPE zsf_auth.

  DATA lv_passwd TYPE string VALUE 'abaco1'.
  DATA(lv_hashed_password) = zabsf_pp_cl_authentication=>new_get_hashed_password( EXPORTING iv_password = lv_passwd ).

  ls_auth-id = '1'.
  ls_auth-emailconfirmed = abap_false.
  ls_auth-passwordhash = lv_hashed_password.
  ls_auth-twofactorenabled = abap_false.
  ls_auth-accessfailedcount = '0'.
  ls_auth-username = 'MEC'.
  INSERT INTO zsf_auth VALUES ls_auth.
  CLEAR ls_auth.

  ls_auth-id = '2'.
  ls_auth-emailconfirmed = abap_false.
  ls_auth-passwordhash = lv_hashed_password.
  ls_auth-twofactorenabled = abap_false.
  ls_auth-accessfailedcount = '0'.
  ls_auth-username = 'ADMIN'.
  INSERT INTO zsf_auth VALUES ls_auth.
  CLEAR ls_auth.

  ls_auth-id = '3'.
  ls_auth-emailconfirmed = abap_false.
  ls_auth-passwordhash = lv_hashed_password.
  ls_auth-twofactorenabled = abap_false.
  ls_auth-accessfailedcount = '0'.
  ls_auth-username = 'JV'.
  INSERT INTO zsf_auth VALUES ls_auth.
  CLEAR ls_auth.

  ls_auth-id = '4'.
  ls_auth-emailconfirmed = abap_false.
  ls_auth-passwordhash = lv_hashed_password.
  ls_auth-twofactorenabled = abap_false.
  ls_auth-accessfailedcount = '0'.
  ls_auth-username = 'OP_MEC'.
  INSERT INTO zsf_auth VALUES ls_auth.
  CLEAR ls_auth.

  ls_auth-id = '5'.
  ls_auth-emailconfirmed = abap_false.
  ls_auth-passwordhash = lv_hashed_password.
  ls_auth-twofactorenabled = abap_false.
  ls_auth-accessfailedcount = '0'.
  ls_auth-username = 'OP_MTG'.
  INSERT INTO zsf_auth VALUES ls_auth.
  CLEAR ls_auth.

  ls_auth-id = '6'.
  ls_auth-emailconfirmed = abap_false.
  ls_auth-passwordhash = lv_hashed_password.
  ls_auth-twofactorenabled = abap_false.
  ls_auth-accessfailedcount = '0'.
  ls_auth-username = 'TL_D_MEC'.
  INSERT INTO zsf_auth VALUES ls_auth.
  CLEAR ls_auth.

  ls_auth-id = '7'.
  ls_auth-emailconfirmed = abap_false.
  ls_auth-passwordhash = lv_hashed_password.
  ls_auth-twofactorenabled = abap_false.
  ls_auth-accessfailedcount = '0'.
  ls_auth-username = 'TL_MTG'.
  INSERT INTO zsf_auth VALUES ls_auth.
  CLEAR ls_auth.

  ls_auth-id = '8'.
  ls_auth-emailconfirmed = abap_false.
  ls_auth-passwordhash = lv_hashed_password.
  ls_auth-twofactorenabled = abap_false.
  ls_auth-accessfailedcount = '0'.
  ls_auth-username = 'TL_OPT'.
  INSERT INTO zsf_auth VALUES ls_auth.
  CLEAR ls_auth.
ENDIF.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

IF lv_do_zsf_authact EQ abap_true.
  DELETE FROM zsf_authact.
  DATA ls_authact TYPE zsf_authact.

  ls_authact-id = 1.
  ls_authact-description = 'Display'.
  INSERT INTO zsf_authact VALUES ls_authact.
  CLEAR ls_authact.

  ls_authact-id = 2.
  ls_authact-description = 'Insert'.
  INSERT INTO zsf_authact VALUES ls_authact.
  CLEAR ls_authact.

  ls_authact-id = 3.
  ls_authact-description = 'Update'.
  INSERT INTO zsf_authact VALUES ls_authact.
  CLEAR ls_authact.

  ls_authact-id = 4.
  ls_authact-description = 'Delete'.
  INSERT INTO zsf_authact VALUES ls_authact.
  CLEAR ls_authact.
ENDIF.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

IF lv_do_zsf_authactobj EQ abap_true.
  DELETE FROM zsf_authactobj.
  DATA ls_authactobj TYPE zsf_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'ActivitiesObjectsOfProfileManagement'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'ActivitiesObjectsOfProfileManagement'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'ActivitiesObjectsOfProfileManagement'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'ActivitiesObjectsOfProfileManagement'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'AdminMain'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'AdminMain'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'AdminMain'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'AdminMain'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'Launchpad'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'Launchpad'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'Launchpad'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'Launchpad'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'PPMain'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'PPMain'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'PPMain'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'PPMain'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'ProfileManagement'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'ProfileManagement'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'ProfileManagement'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'ProfileManagement'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'ProfilesOfRoleManagement'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'ProfilesOfRoleManagement'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'ProfilesOfRoleManagement'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'ProfilesOfRoleManagement'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'RoleManagement'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'RoleManagement'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'RoleManagement'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'RoleManagement'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'UsersManagement'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'UsersManagement'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'UsersManagement'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'UsersManagement'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'UsersManagementDetail'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'UsersManagementDetail'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'UsersManagementDetail'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'UsersManagementDetail'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'UsersSap'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'UsersSap'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'UsersSap'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'UsersSap'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'WorkcentersOverview'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'WorkcentersOverview'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'WorkcentersOverview'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'AdministrationProfile'.
  ls_authactobj-objectid = 'WorkcentersOverview'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'Launchpad'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'Launchpad'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'Launchpad'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'Launchpad'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'NavigationType'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'NavigationType'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'NavigationType'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'NavigationType'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'OperationsConsumption'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'OperationsConsumption'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'OperationsConsumption'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'OperationsConsumption'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'OperationsConsumptionDevolution'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'OperationsConsumptionDevolution'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'OperationsConsumptionDevolution'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'OperationsConsumptionDevolution'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'PPMain'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'PPMain'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'PPMain'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'PPMain'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'ShiftsList'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'ShiftsList'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'ShiftsList'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'ShiftsList'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'StockReport'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'StockReport'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'StockReport'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'StockReport'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'TimeReport'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'TimeReport'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'TimeReport'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'TimeReport'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'TreeNavigation'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'TreeNavigation'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'TreeNavigation'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'TreeNavigation'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'WorkcenterDetail'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'WorkcenterDetail'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'WorkcenterDetail'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'WorkcenterDetail'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'WorkcenterDetailDetail'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'WorkcenterDetailDetailMultimaterial'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'WorkcenterDetailDetailMultimaterial'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'WorkcenterDetailDetailMultimaterial'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'WorkcenterDetailDetailMultimaterial'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'WorkcenterDetailDetailNoMultimaterial'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'WorkcenterDetailDetailNoMultimaterial'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'WorkcenterDetailDetailNoMultimaterial'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'WorkcenterDetailDetailNoMultimaterial'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'WorkcentersOverview'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'WorkcentersOverview'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'WorkcentersOverview'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'WorkcentersOverview'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'StockConfirmatedReport'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'StockConfirmatedReport'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'StockConfirmatedReport'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'StockConfirmatedReport'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'Stock'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'Stock'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'Stock'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'Stock'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'StockReport'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'StockReport'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'StockReport'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'StockReport'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'StockReport'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'StockReport'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'StockReport'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'StockReport'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'AlertsManagement'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'AlertsManagement'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'AlertsManagement'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'AlertsManagement'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'Dashboard'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'Dashboard'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'Dashboard'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'Dashboard'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'Dashboard1'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'Dashboard1'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'Dashboard1'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'Dashboard1'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'Dashboard2'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'Dashboard2'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'Dashboard2'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'Dashboard2'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'DepositTransferLabel'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'DepositTransferLabel'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'DepositTransferLabel'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'DepositTransferLabel'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'LabelPrinting'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'LabelPrinting'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'LabelPrinting'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'LabelPrinting'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'OperationQuantityLabel'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'OperationQuantityLabel'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'OperationQuantityLabel'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'OperationQuantityLabel'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'TileNavigation'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'TileNavigation'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'TileNavigation'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'TileNavigation'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'WorkcenterDetailDetailDiscreta'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'WorkcenterDetailDetailDiscreta'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'WorkcenterDetailDetailDiscreta'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'WorkcenterDetailDetailDiscreta'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'WorkcenterDetailDiscreta'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'WorkcenterDetailDiscreta'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'WorkcenterDetailDiscreta'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'WorkcenterDetailDiscreta'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'WorkcenterDetailRepetitiva'.
  ls_authactobj-activitytypeid = 1.
  ls_authactobj-checked = abap_true.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'WorkcenterDetailRepetitiva'.
  ls_authactobj-activitytypeid = 2.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'WorkcenterDetailRepetitiva'.
  ls_authactobj-activitytypeid = 3.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.

  ls_authactobj-profileid = 'ProductionProfile'.
  ls_authactobj-objectid = 'WorkcenterDetailRepetitiva'.
  ls_authactobj-activitytypeid = 4.
  ls_authactobj-checked = abap_false.
  INSERT INTO zsf_authactobj VALUES ls_authactobj.
  CLEAR ls_authactobj.
ENDIF.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

IF lv_do_zsf_authobj EQ abap_true.
  DELETE FROM zsf_authobj.
  DATA ls_authobj TYPE zsf_authobj.

  ls_authobj-profileid = 'AdministrationProfile'.
  ls_authobj-objectid = 'ActivitiesObjectsOfProfileManagement'.
  INSERT INTO zsf_authobj VALUES ls_authobj.
  CLEAR ls_authobj.

  ls_authobj-profileid = 'AdministrationProfile'.
  ls_authobj-objectid = 'AdminMain'.
  INSERT INTO zsf_authobj VALUES ls_authobj.
  CLEAR ls_authobj.

  ls_authobj-profileid = 'AdministrationProfile'.
  ls_authobj-objectid = 'Launchpad'.
  INSERT INTO zsf_authobj VALUES ls_authobj.
  CLEAR ls_authobj.

  ls_authobj-profileid = 'AdministrationProfile'.
  ls_authobj-objectid = 'PPMain'.
  INSERT INTO zsf_authobj VALUES ls_authobj.
  CLEAR ls_authobj.

  ls_authobj-profileid = 'AdministrationProfile'.
  ls_authobj-objectid = 'ProfileManagement'.
  INSERT INTO zsf_authobj VALUES ls_authobj.
  CLEAR ls_authobj.

  ls_authobj-profileid = 'AdministrationProfile'.
  ls_authobj-objectid = 'ProfilesOfRoleManagement'.
  INSERT INTO zsf_authobj VALUES ls_authobj.
  CLEAR ls_authobj.

  ls_authobj-profileid = 'AdministrationProfile'.
  ls_authobj-objectid = 'RoleManagement'.
  INSERT INTO zsf_authobj VALUES ls_authobj.
  CLEAR ls_authobj.

  ls_authobj-profileid = 'AdministrationProfile'.
  ls_authobj-objectid = 'UsersManagement'.
  INSERT INTO zsf_authobj VALUES ls_authobj.
  CLEAR ls_authobj.

  ls_authobj-profileid = 'AdministrationProfile'.
  ls_authobj-objectid = 'UsersManagementDetail'.
  INSERT INTO zsf_authobj VALUES ls_authobj.
  CLEAR ls_authobj.

  ls_authobj-profileid = 'AdministrationProfile'.
  ls_authobj-objectid = 'UsersSap'.
  INSERT INTO zsf_authobj VALUES ls_authobj.
  CLEAR ls_authobj.

  ls_authobj-profileid = 'AdministrationProfile'.
  ls_authobj-objectid = 'WorkcentersOverview'.
  INSERT INTO zsf_authobj VALUES ls_authobj.
  CLEAR ls_authobj.

  ls_authobj-profileid = 'ProductionProfile'.
  ls_authobj-objectid = 'Launchpad'.
  INSERT INTO zsf_authobj VALUES ls_authobj.
  CLEAR ls_authobj.

  ls_authobj-profileid = 'ProductionProfile'.
  ls_authobj-objectid = 'NavigationType'.
  INSERT INTO zsf_authobj VALUES ls_authobj.
  CLEAR ls_authobj.

  ls_authobj-profileid = 'ProductionProfile'.
  ls_authobj-objectid = 'OperationsConsumption'.
  INSERT INTO zsf_authobj VALUES ls_authobj.
  CLEAR ls_authobj.

  ls_authobj-profileid = 'ProductionProfile'.
  ls_authobj-objectid = 'OperationsConsumptionDevolution'.
  INSERT INTO zsf_authobj VALUES ls_authobj.
  CLEAR ls_authobj.

  ls_authobj-profileid = 'ProductionProfile'.
  ls_authobj-objectid = 'PPMain'.
  INSERT INTO zsf_authobj VALUES ls_authobj.
  CLEAR ls_authobj.

  ls_authobj-profileid = 'ProductionProfile'.
  ls_authobj-objectid = 'ShiftsList'.
  INSERT INTO zsf_authobj VALUES ls_authobj.
  CLEAR ls_authobj.

  ls_authobj-profileid = 'ProductionProfile'.
  ls_authobj-objectid = 'StockReport'.
  INSERT INTO zsf_authobj VALUES ls_authobj.
  CLEAR ls_authobj.

  ls_authobj-profileid = 'ProductionProfile'.
  ls_authobj-objectid = 'TimeReport'.
  INSERT INTO zsf_authobj VALUES ls_authobj.
  CLEAR ls_authobj.

  ls_authobj-profileid = 'ProductionProfile'.
  ls_authobj-objectid = 'TreeNavigation'.
  INSERT INTO zsf_authobj VALUES ls_authobj.
  CLEAR ls_authobj.

  ls_authobj-profileid = 'ProductionProfile'.
  ls_authobj-objectid = 'WorkcenterDetail'.
  INSERT INTO zsf_authobj VALUES ls_authobj.
  CLEAR ls_authobj.

  ls_authobj-profileid = 'ProductionProfile'.
  ls_authobj-objectid = 'WorkcenterDetailDetail'.
  INSERT INTO zsf_authobj VALUES ls_authobj.
  CLEAR ls_authobj.

  ls_authobj-profileid = 'ProductionProfile'.
  ls_authobj-objectid = 'WorkcenterDetailDetailMultimaterial'.
  INSERT INTO zsf_authobj VALUES ls_authobj.
  CLEAR ls_authobj.

  ls_authobj-profileid = 'ProductionProfile'.
  ls_authobj-objectid = 'WorkcenterDetailDetailNoMultimaterial'.
  INSERT INTO zsf_authobj VALUES ls_authobj.
  CLEAR ls_authobj.

  ls_authobj-profileid = 'ProductionProfile'.
  ls_authobj-objectid = 'WorkcentersOverview'.
  INSERT INTO zsf_authobj VALUES ls_authobj.
  CLEAR ls_authobj.

  ls_authobj-profileid = 'ProductionProfile'.
  ls_authobj-objectid = 'AlertsManagement'.
  INSERT INTO zsf_authobj VALUES ls_authobj.
  CLEAR ls_authobj.

  ls_authobj-profileid = 'ProductionProfile'.
  ls_authobj-objectid = 'Dashboard'.
  INSERT INTO zsf_authobj VALUES ls_authobj.
  CLEAR ls_authobj.

  ls_authobj-profileid = 'ProductionProfile'.
  ls_authobj-objectid = 'Dashboard1'.
  INSERT INTO zsf_authobj VALUES ls_authobj.
  CLEAR ls_authobj.

  ls_authobj-profileid = 'ProductionProfile'.
  ls_authobj-objectid = 'Dashboard2'.
  INSERT INTO zsf_authobj VALUES ls_authobj.
  CLEAR ls_authobj.

  ls_authobj-profileid = 'ProductionProfile'.
  ls_authobj-objectid = 'DepositTransferLabel'.
  INSERT INTO zsf_authobj VALUES ls_authobj.
  CLEAR ls_authobj.

  ls_authobj-profileid = 'ProductionProfile'.
  ls_authobj-objectid = 'LabelPrinting'.
  INSERT INTO zsf_authobj VALUES ls_authobj.
  CLEAR ls_authobj.

  ls_authobj-profileid = 'ProductionProfile'.
  ls_authobj-objectid = 'OperationQuantityLabel'.
  INSERT INTO zsf_authobj VALUES ls_authobj.
  CLEAR ls_authobj.

  ls_authobj-profileid = 'ProductionProfile'.
  ls_authobj-objectid = 'Stock'.
  INSERT INTO zsf_authobj VALUES ls_authobj.
  CLEAR ls_authobj.

  ls_authobj-profileid = 'ProductionProfile'.
  ls_authobj-objectid = 'StockConfirmatedReport'.
  INSERT INTO zsf_authobj VALUES ls_authobj.
  CLEAR ls_authobj.

  ls_authobj-profileid = 'ProductionProfile'.
  ls_authobj-objectid = 'TileNavigation'.
  INSERT INTO zsf_authobj VALUES ls_authobj.
  CLEAR ls_authobj.

  ls_authobj-profileid = 'ProductionProfile'.
  ls_authobj-objectid = 'WorkcenterDetailDetailDiscreta'.
  INSERT INTO zsf_authobj VALUES ls_authobj.
  CLEAR ls_authobj.

  ls_authobj-profileid = 'ProductionProfile'.
  ls_authobj-objectid = 'WorkcenterDetailDiscreta'.
  INSERT INTO zsf_authobj VALUES ls_authobj.
  CLEAR ls_authobj.

  ls_authobj-profileid = 'ProductionProfile'.
  ls_authobj-objectid = 'WorkcenterDetailRepetitiva'.
  INSERT INTO zsf_authobj VALUES ls_authobj.
  CLEAR ls_authobj.
ENDIF.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

IF lv_do_zsf_authprof EQ abap_true.
  DELETE FROM zsf_authprof.
  DATA ls_authprof TYPE zsf_authprof.

  ls_authprof-id = 'AdministrationProfile'.
  ls_authprof-description = 'Administration Profile'.
  INSERT INTO zsf_authprof VALUES ls_authprof.
  CLEAR ls_authprof.

  ls_authprof-id = 'ProductionProfile'.
  ls_authprof-description = 'Production Profile'.
  INSERT INTO zsf_authprof VALUES ls_authprof.
  CLEAR ls_authprof.
ENDIF.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

IF lv_do_zsf_authprofrole EQ abap_true.
  DELETE FROM zsf_authprofrole.
  DATA ls_authprofrole TYPE zsf_authprofrole.

  ls_authprofrole-roleid = 'AdministrationRole'.
  ls_authprofrole-profileid = 'AdministrationProfile'.
  INSERT INTO zsf_authprofrole VALUES ls_authprofrole.
  CLEAR ls_authprofrole.

  ls_authprofrole-roleid = 'AdministrationRole'.
  ls_authprofrole-profileid = 'ProductionProfile'.
  INSERT INTO zsf_authprofrole VALUES ls_authprofrole.
  CLEAR ls_authprofrole.

  ls_authprofrole-roleid = 'AllFunctionalitiesRole'.
  ls_authprofrole-profileid = 'AdministrationProfile'.
  INSERT INTO zsf_authprofrole VALUES ls_authprofrole.
  CLEAR ls_authprofrole.

  ls_authprofrole-roleid = 'AllFunctionalitiesRole'.
  ls_authprofrole-profileid = 'ProductionProfile'.
  INSERT INTO zsf_authprofrole VALUES ls_authprofrole.
  CLEAR ls_authprofrole.

  ls_authprofrole-roleid = 'ProductionRole'.
  ls_authprofrole-profileid = 'ProductionProfile'.
  INSERT INTO zsf_authprofrole VALUES ls_authprofrole.
  CLEAR ls_authprofrole.
ENDIF.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

IF lv_do_zsf_authrole EQ abap_true.
  DELETE FROM zsf_authrole.
  DATA ls_authrole TYPE zsf_authrole.

  ls_authrole-id = 'AdministrationRole'.
  ls_authrole-description = 'Administration Role'.
  INSERT INTO zsf_authrole VALUES ls_authrole.
  CLEAR ls_authrole.

  ls_authrole-id = 'AllFunctionalitiesRole'.
  ls_authrole-description = 'All Functionalities Role'.
  INSERT INTO zsf_authrole VALUES ls_authrole.
  CLEAR ls_authrole.

  ls_authrole-id = 'ProductionRole'.
  ls_authrole-description = 'Production Role'.
  INSERT INTO zsf_authrole VALUES ls_authrole.
  CLEAR ls_authrole.
ENDIF.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

IF lv_do_zsf_authroleuser EQ abap_true.
  DELETE FROM zsf_authroleuser.
  DATA ls_authroleuser TYPE zsf_authroleuser.

  ls_authroleuser-username = 'MEC'.
  ls_authroleuser-roleid = 'ProductionRole'.
  INSERT INTO zsf_authroleuser VALUES ls_authroleuser.
  CLEAR ls_authroleuser.

  ls_authroleuser-username = 'ADMIN'.
  ls_authroleuser-roleid = 'AdministrationRole'.
  INSERT INTO zsf_authroleuser VALUES ls_authroleuser.
  CLEAR ls_authroleuser.
ENDIF.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

IF lv_do_zsf_users EQ abap_true.
  DELETE FROM zsf_users.
  DATA ls_users TYPE zsf_users.

  ls_users-username = 'MEC'.
  ls_users-usersap = 'MCOSTA'.
  ls_users-name = 'User Mec'.
  ls_users-area = 0.
  ls_users-roleid = 101.
  ls_users-language = 0.
  ls_users-validfrom = 20180101000000.
  ls_users-validto = 20991231000000.
  ls_users-center = '0070'.
  ls_users-language = 'PT'.
  ls_users-userlanguage = 'PT'.
  ls_users-userarea = 'MEC'.
  ls_users-usererpid = '11'.
  INSERT INTO zsf_users VALUES ls_users.
  CLEAR ls_users.

  ls_users-username = 'ADMIN'.
  ls_users-usersap = 'MCOSTA'.
  ls_users-name = 'Administrador Shopfloor'.
  ls_users-area = 4.
  ls_users-roleid = 1.
  ls_users-language = 1.
  ls_users-validfrom = 20141212000000.
  ls_users-validto = 20991231000000.
  ls_users-center = '0070'.
  ls_users-language = 'PT'.
  ls_users-userlanguage = 'PT'.
  ls_users-userarea = 'ADM'.
  INSERT INTO zsf_users VALUES ls_users.
  CLEAR ls_users.
ENDIF.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

IF lv_do_zsf_userssap EQ abap_true.
  DELETE FROM zsf_userssap.
  DATA ls_userssap TYPE zsf_userssap.

  ls_userssap-usersap = 'MCOSTA'.
  INSERT INTO zsf_userssap VALUES ls_userssap.

  CALL METHOD zabsf_pp_cl_authentication=>update_sap_user_pwd
    EXPORTING
      iv_username = CONV string( ls_userssap-usersap )
      iv_password = 'password'.

  CLEAR ls_userssap.
ENDIF.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

IF lv_do_zsf_actions EQ abap_true.
  DELETE FROM zsf_actions.
  DATA ls_actions TYPE zsf_actions.
  DATA lv_zsf_actions_iterator TYPE i VALUE 0.

  ls_actions-routename = 'Launchpad'.
  ls_actions-actionid = 'ViewPermission'.
  ls_actions-username = 'ADMIN'.
  ls_actions-id = lv_zsf_actions_iterator.
  INSERT INTO zsf_actions VALUES ls_actions.
  CLEAR ls_actions.
  lv_zsf_actions_iterator = lv_zsf_actions_iterator + 1.

  ls_actions-routename = 'AdminMain'.
  ls_actions-actionid = 'ViewPermission'.
  ls_actions-parentid = 'Launchpad'.
  ls_actions-username = 'ADMIN'.
  ls_actions-id = lv_zsf_actions_iterator.
  INSERT INTO zsf_actions VALUES ls_actions.
  CLEAR ls_actions.
  lv_zsf_actions_iterator = lv_zsf_actions_iterator + 1.

  ls_actions-routename = 'PPMain'.
  ls_actions-actionid = 'ViewPermission'.
  ls_actions-parentid = 'Launchpad'.
  ls_actions-username = 'ADMIN'.
  ls_actions-id = lv_zsf_actions_iterator.
  INSERT INTO zsf_actions VALUES ls_actions.
  CLEAR ls_actions.
  lv_zsf_actions_iterator = lv_zsf_actions_iterator + 1.

  ls_actions-routename = 'PMMain'.
  ls_actions-actionid = 'ViewPermission'.
  ls_actions-parentid = 'Launchpad'.
  ls_actions-username = 'ADMIN'.
  ls_actions-id = lv_zsf_actions_iterator.
  INSERT INTO zsf_actions VALUES ls_actions.
  CLEAR ls_actions.
  lv_zsf_actions_iterator = lv_zsf_actions_iterator + 1.

  ls_actions-routename = 'shiftslist'.
  ls_actions-actionid = 'ViewPermission'.
  ls_actions-parentid = 'PPMain'.
  ls_actions-username = 'ADMIN'.
  ls_actions-id = lv_zsf_actions_iterator.
  INSERT INTO zsf_actions VALUES ls_actions.
  CLEAR ls_actions.
  lv_zsf_actions_iterator = lv_zsf_actions_iterator + 1.

  ls_actions-routename = 'UsersManagement'.
  ls_actions-actionid = 'ViewPermission'.
  ls_actions-parentid = 'AdminMain'.
  ls_actions-username = 'ADMIN'.
  ls_actions-id = lv_zsf_actions_iterator.
  INSERT INTO zsf_actions VALUES ls_actions.
  CLEAR ls_actions.
  lv_zsf_actions_iterator = lv_zsf_actions_iterator + 1.

  ls_actions-routename = 'UsersManagementDetail'.
  ls_actions-actionid = 'ViewPermission'.
  ls_actions-parentid = 'UsersManagement'.
  ls_actions-username = 'ADMIN'.
  ls_actions-id = lv_zsf_actions_iterator.
  INSERT INTO zsf_actions VALUES ls_actions.
  CLEAR ls_actions.
  lv_zsf_actions_iterator = lv_zsf_actions_iterator + 1.

  ls_actions-routename = 'TimeSheetMain'.
  ls_actions-actionid = 'ViewPermission'.
  ls_actions-parentid = 'Launchpad'.
  ls_actions-username = 'ADMIN'.
  ls_actions-id = lv_zsf_actions_iterator.
  INSERT INTO zsf_actions VALUES ls_actions.
  CLEAR ls_actions.
  lv_zsf_actions_iterator = lv_zsf_actions_iterator + 1.

  ls_actions-routename = 'TimeSheet'.
  ls_actions-actionid = 'ViewPermission'.
  ls_actions-parentid = 'TimeSheetMain'.
  ls_actions-username = 'ADMIN'.
  ls_actions-id = lv_zsf_actions_iterator.
  INSERT INTO zsf_actions VALUES ls_actions.
  CLEAR ls_actions.
  lv_zsf_actions_iterator = lv_zsf_actions_iterator + 1.

  ls_actions-routename = 'TimeSheetAdmin'.
  ls_actions-actionid = 'ViewPermission'.
  ls_actions-parentid = 'TimeSheetMain'.
  ls_actions-username = 'ADMIN'.
  ls_actions-id = lv_zsf_actions_iterator.
  INSERT INTO zsf_actions VALUES ls_actions.
  CLEAR ls_actions.
  lv_zsf_actions_iterator = lv_zsf_actions_iterator + 1.

  ls_actions-routename = 'ExpensesMain'.
  ls_actions-actionid = 'ViewPermission'.
  ls_actions-parentid = 'Launchpad'.
  ls_actions-username = 'ADMIN'.
  ls_actions-id = lv_zsf_actions_iterator.
  INSERT INTO zsf_actions VALUES ls_actions.
  CLEAR ls_actions.
  lv_zsf_actions_iterator = lv_zsf_actions_iterator + 1.

  ls_actions-routename = 'Expenses'.
  ls_actions-actionid = 'ViewPermission'.
  ls_actions-parentid = 'ExpensesMain'.
  ls_actions-username = 'ADMIN'.
  ls_actions-id = lv_zsf_actions_iterator.
  INSERT INTO zsf_actions VALUES ls_actions.
  CLEAR ls_actions.
  lv_zsf_actions_iterator = lv_zsf_actions_iterator + 1.

  ls_actions-routename = 'ExpensesAdmin'.
  ls_actions-actionid = 'ViewPermission'.
  ls_actions-parentid = 'ExpensesMain'.
  ls_actions-username = 'ADMIN'.
  ls_actions-id = lv_zsf_actions_iterator.
  INSERT INTO zsf_actions VALUES ls_actions.
  CLEAR ls_actions.
  lv_zsf_actions_iterator = lv_zsf_actions_iterator + 1.

  ls_actions-routename = 'ProfileManagement'.
  ls_actions-actionid = 'ViewPermission'.
  ls_actions-parentid = 'AdminMain'.
  ls_actions-username = 'ADMIN'.
  ls_actions-id = lv_zsf_actions_iterator.
  INSERT INTO zsf_actions VALUES ls_actions.
  CLEAR ls_actions.
  lv_zsf_actions_iterator = lv_zsf_actions_iterator + 1.

  ls_actions-routename = 'ActivitiesObjectsOfProfileManagement'.
  ls_actions-actionid = 'ViewPermission'.
  ls_actions-parentid = 'ProfileManagement'.
  ls_actions-username = 'ADMIN'.
  ls_actions-id = lv_zsf_actions_iterator.
  INSERT INTO zsf_actions VALUES ls_actions.
  CLEAR ls_actions.
  lv_zsf_actions_iterator = lv_zsf_actions_iterator + 1.

  ls_actions-routename = 'RoleManagement'.
  ls_actions-actionid = 'ViewPermission'.
  ls_actions-parentid = 'AdminMain'.
  ls_actions-username = 'ADMIN'.
  ls_actions-id = lv_zsf_actions_iterator.
  INSERT INTO zsf_actions VALUES ls_actions.
  CLEAR ls_actions.
  lv_zsf_actions_iterator = lv_zsf_actions_iterator + 1.

  ls_actions-routename = 'ProfilesOfRoleManagement'.
  ls_actions-actionid = 'ViewPermission'.
  ls_actions-parentid = 'RoleManagement'.
  ls_actions-username = 'ADMIN'.
  ls_actions-id = lv_zsf_actions_iterator.
  INSERT INTO zsf_actions VALUES ls_actions.
  CLEAR ls_actions.
  lv_zsf_actions_iterator = lv_zsf_actions_iterator + 1.

  ls_actions-routename = 'Launchpad'.
  ls_actions-actionid = 'ViewPermission'.
  ls_actions-username = 'MEC'.
  ls_actions-id = lv_zsf_actions_iterator.
  INSERT INTO zsf_actions VALUES ls_actions.
  CLEAR ls_actions.
  lv_zsf_actions_iterator = lv_zsf_actions_iterator + 1.

  ls_actions-routename = 'PPMain'.
  ls_actions-actionid = 'ViewPermission'.
  ls_actions-parentid = 'Launchpad'.
  ls_actions-username = 'MEC'.
  ls_actions-id = lv_zsf_actions_iterator.
  INSERT INTO zsf_actions VALUES ls_actions.
  CLEAR ls_actions.
  lv_zsf_actions_iterator = lv_zsf_actions_iterator + 1.

  ls_actions-routename = 'shiftslist'.
  ls_actions-actionid = 'ViewPermission'.
  ls_actions-parentid = 'PPMain'.
  ls_actions-username = 'MEC'.
  ls_actions-id = lv_zsf_actions_iterator.
  INSERT INTO zsf_actions VALUES ls_actions.
  CLEAR ls_actions.
  lv_zsf_actions_iterator = lv_zsf_actions_iterator + 1.

  ls_actions-routename = 'hierarchies'.
  ls_actions-actionid = 'ViewPermission'.
  ls_actions-parentid = 'shiftslist'.
  ls_actions-username = 'MEC'.
  ls_actions-id = lv_zsf_actions_iterator.
  INSERT INTO zsf_actions VALUES ls_actions.
  CLEAR ls_actions.
  lv_zsf_actions_iterator = lv_zsf_actions_iterator + 1.

  ls_actions-routename = 'workCentersMain'.
  ls_actions-actionid = 'ViewPermission'.
  ls_actions-parentid = 'hierarchies'.
  ls_actions-username = 'MEC'.
  ls_actions-id = lv_zsf_actions_iterator.
  INSERT INTO zsf_actions VALUES ls_actions.
  CLEAR ls_actions.
  lv_zsf_actions_iterator = lv_zsf_actions_iterator + 1.

  ls_actions-routename = 'workCentersMaster'.
  ls_actions-actionid = 'ViewPermission'.
  ls_actions-parentid = 'workCentersMain'.
  ls_actions-username = 'MEC'.
  ls_actions-id = lv_zsf_actions_iterator.
  INSERT INTO zsf_actions VALUES ls_actions.
  CLEAR ls_actions.
  lv_zsf_actions_iterator = lv_zsf_actions_iterator + 1.

  ls_actions-routename = 'ppworkcenters'.
  ls_actions-actionid = 'ViewPermission'.
  ls_actions-parentid = 'workCentersMaster'.
  ls_actions-username = 'MEC'.
  ls_actions-id = lv_zsf_actions_iterator.
  INSERT INTO zsf_actions VALUES ls_actions.
  CLEAR ls_actions.
  lv_zsf_actions_iterator = lv_zsf_actions_iterator + 1.
ENDIF.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

IF lv_do_zsf_roles EQ abap_true.
  DELETE FROM zsf_roles.
  DATA ls_roles TYPE zsf_roles.

  ls_roles-id = 1.
  ls_roles-description = 'Admin'.
  INSERT INTO zsf_roles VALUES ls_roles.
  CLEAR ls_roles.

  ls_roles-id = 101.
  ls_roles-description = 'AreaAdmin'.
  INSERT INTO zsf_roles VALUES ls_roles.
  CLEAR ls_roles.

  ls_roles-id = 102.
  ls_roles-description = 'User'.
  INSERT INTO zsf_roles VALUES ls_roles.
  CLEAR ls_roles.

  ls_roles-id = 105.
  ls_roles-description = 'Production_Supplier'.
  INSERT INTO zsf_roles VALUES ls_roles.
  CLEAR ls_roles.

  ls_roles-id = 106.
  ls_roles-description = 'Production_Planner'.
  INSERT INTO zsf_roles VALUES ls_roles.
  CLEAR ls_roles.

ENDIF.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

IF lv_do_zsf_permissions EQ abap_true.
  DELETE FROM zsf_permissions.
  DATA ls_permissions TYPE zsf_permissions.

  ls_permissions-endpoint = to_upper( 'AuthorizationActivityOfObjects' ).
  ls_permissions-authobj = 'ActivitiesObjectsOfProfileManagement'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'AuthorizationProfiles' ).
  ls_permissions-authobj = 'ActivitiesObjectsOfProfileManagement'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'AuthorizationProfiles' ).
  ls_permissions-authobj = 'ProfileManagement'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'AuthorizationProfiles' ).
  ls_permissions-authobj = 'ProfilesOfRoleManagement'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'AuthorizationProfilesOfRoles' ).
  ls_permissions-authobj = 'ProfilesOfRoleManagement'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'AuthorizationRoles' ).
  ls_permissions-authobj = 'ProfilesOfRoleManagement'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'AuthorizationRoles' ).
  ls_permissions-authobj = 'RoleManagement'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'AuthorizationRoles' ).
  ls_permissions-authobj = 'UsersManagement'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'AuthorizationRoles' ).
  ls_permissions-authobj = 'UsersManagementDetail'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'TreeHierarchies' ).
  ls_permissions-authobj = 'UsersManagement'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'TreeHierarchies' ).
  ls_permissions-authobj = 'UsersManagementDetail'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'Users' ).
  ls_permissions-authobj = 'UsersManagement'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'Users' ).
  ls_permissions-authobj = 'UsersManagementDetail'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'Centers' ).
  ls_permissions-authobj = 'UsersManagement'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'Centers' ).
  ls_permissions-authobj = 'UsersManagementDetail'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'UsersSAP' ).
  ls_permissions-authobj = 'UsersManagementDetail'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'UsersSAP' ).
  ls_permissions-authobj = 'UsersSap'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'UserAreas' ).
  ls_permissions-authobj = 'UsersManagement'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'UserAreas' ).
  ls_permissions-authobj = 'UsersManagementDetail'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'UserLanguages' ).
  ls_permissions-authobj = 'UsersManagement'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'UserLanguages' ).
  ls_permissions-authobj = 'UsersManagementDetail'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'Roles' ).
  ls_permissions-authobj = 'UsersManagementDetail'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'WorkCenters' ).
  ls_permissions-authobj = 'OperationsConsumption'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'WorkCenters' ).
  ls_permissions-authobj = 'OperationsConsumptionDevolution'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'WorkCenters' ).
  ls_permissions-authobj = 'WorkcenterDetail'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'WorkCenters' ).
  ls_permissions-authobj = 'WorkcenterDetailDetail'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'OperationsConsumptions' ).
  ls_permissions-authobj = 'OperationsConsumption'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'OperationsConsumptions' ).
  ls_permissions-authobj = 'WorkcenterDetailDetail'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'OperationConsumptionDevolutions' ).
  ls_permissions-authobj = 'OperationsConsumptionDevolution'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'StockReportCenters' ).
  ls_permissions-authobj = 'StockReport'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'TimeReportCenters' ).
  ls_permissions-authobj = 'TimeReport'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'Operations' ).
  ls_permissions-authobj = 'WorkcenterDetail'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'Operations' ).
  ls_permissions-authobj = 'WorkcenterDetailDetail'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'StopReasons' ).
  ls_permissions-authobj = 'WorkcenterDetail'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'OperationConsumptionHistoryInformations' ).
  ls_permissions-authobj = 'WorkcenterDetailDetail'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'OperationOperators' ).
  ls_permissions-authobj = 'WorkcenterDetailDetail'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'OperationStopReasons' ).
  ls_permissions-authobj = 'WorkcenterDetailDetail'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'WorkCenterPositions' ).
  ls_permissions-authobj = 'WorkcenterDetailDetail'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'Hierarchies' ).
  ls_permissions-authobj = 'WorkcentersOverview'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'WorkCentersOEE' ).
  ls_permissions-authobj = 'WorkcentersOverview'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

  ls_permissions-endpoint = to_upper( 'Shifts' ).
  ls_permissions-authobj = 'ShiftsList'.
  INSERT INTO zsf_permissions VALUES ls_permissions.
  CLEAR ls_permissions.

ENDIF.
