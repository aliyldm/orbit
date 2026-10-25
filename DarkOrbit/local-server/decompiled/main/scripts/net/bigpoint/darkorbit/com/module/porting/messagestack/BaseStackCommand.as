package net.bigpoint.darkorbit.com.module.porting.messagestack
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class BaseStackCommand implements IModule
   {
      
      private static var _instance:BaseStackCommand;
      
      public static const BASEKEY_empty:int = 0;
      
      public static const BASEKEY_eqt_error_generic:int = 1;
      
      public static const BASEKEY_info_text_switch_hangar_station_only:int = 2;
      
      public static const BASEKEY_hangar_switchship_cooldown:int = 3;
      
      public static const BASEKEY_info_text_switch_active_hangar_success:int = 4;
      
      public static const BASEKEY_eqt_error_playerMayNotEquipWithoutHangarFacility:int = 5;
      
      public static const BASEKEY_banking_error_no_Uridium:int = 6;
      
      public static const BASEKEY_error_pet_name_length:int = 7;
      
      public static const BASEKEY_error_pet_name_char:int = 8;
      
      public static const BASEKEY_items_hangarSlot_max_favs:int = 9;
      
      public static const BASEKEY_err_no_pearls:int = 10;
      
      public static const BASEKEY_err_no_gold:int = 11;
      
      public static const BASEKEY_error_unknown:int = 12;
      
      public static const BASEKEY_err_support:int = 13;
      
      public static const BASEKEY_err_eventitem_not_available:int = 14;
      
      public static const BASEKEY_items_booster_bought:int = 15;
      
      public static const BASEKEY_items_drone_formation_already_in_use:int = 16;
      
      public static const BASEKEY_label_empty_pet_tab:int = 17;
      
      public static const BASEKEY_pet_gear_shop_level_limit:int = 18;
      
      public static const BASEKEY_pet_gear_requirement:int = 19;
      
      public static const BASEKEY_err_no_ship:int = 20;
      
      public static const BASEKEY_items_error_ship_owned:int = 21;
      
      public static const BASEKEY_skylab_message_transport_isNotActive:int = 22;
      
      public static const BASEKEY_items_shop_buy_error_unique:int = 23;
      
      public static const BASEKEY_buy_pet_invalidFuelAmount:int = 24;
      
      public static const BASEKEY_Internal_error:int = 25;
      
      public static const BASEKEY_hangar_overview_no_pet:int = 26;
      
      public static const BASEKEY_shop_item_not_found:int = 27;
      
      public static const BASEKEY_items_shop_buy_error_infected:int = 28;
      
      public static const BASEKEY_captain_popup_nova_roster_full:int = 29;
      
      public static const BASEKEY_skylab_message_upgrade_maximumLevel:int = 30;
      
      public static const BASEKEY_skylab_message_upgrade_basemoduleLevel:int = 31;
      
      public static const BASEKEY_skylab_message_upgrade_credits:int = 32;
      
      public static const BASEKEY_skylab_message_upgrade_prometium:int = 33;
      
      public static const BASEKEY_skylab_message_upgrade_endurium:int = 34;
      
      public static const BASEKEY_skylab_message_upgrade_terbium:int = 35;
      
      public static const BASEKEY_skylab_history_module_activate_notBuiltYet:int = 36;
      
      public static const BASEKEY_skylab_history_module_deactivated:int = 37;
      
      public static const BASEKEY_skylab_history_module_activated:int = 38;
      
      public static const BASEKEY_skylab_history_module_activate_lowpower:int = 39;
      
      public static const BASEKEY_skylab_message_upgrade_success:int = 40;
      
      public static const BASEKEY_skylab_history_module_upgrade_lowpower:int = 41;
      
      public static const BASEKEY_skylab_message_upgrade_inProgress:int = 42;
      
      public static const BASEKEY_skylab_history_upgrade_canceled:int = 43;
      
      public static const BASEKEY_skylab_message_upgrade_uridium:int = 44;
      
      public static const BASEKEY_skylab_history_upgrade_instant:int = 45;
      
      public static const BASEKEY_skylab_history_upgrade_finished:int = 46;
      
      public static const BASEKEY_skylab_message_transport_notEnoughUridium:int = 47;
      
      public static const BASEKEY_skylab_message_transport_alreadyActive:int = 48;
      
      public static const BASEKEY_skylab_message_transport_requestedOreAmountIsZero:int = 49;
      
      public static const BASEKEY_skylab_message_transport_notEnoughSpaceInShipStorage:int = 50;
      
      public static const BASEKEY_skylab_message_transport_isEmpty:int = 51;
      
      public static const BASEKEY_skylab_history_transfer_ship_started:int = 52;
      
      public static const BASEKEY_skylab_history_transfer_ship_finished:int = 53;
      
      public static const BASEKEY_messaging_errorLayer_restrictionUnknownUser_text:int = 54;
      
      public static const BASEKEY_messaging_errorLayer_spam_title:int = 55;
      
      public static const BASEKEY_messaging_errorLayer_spam_text:int = 56;
      
      public static const BASEKEY_messaging_errorLayer_noRecipient_title:int = 57;
      
      public static const BASEKEY_messaging_errorLayer_noRecipient_text:int = 58;
      
      public static const BASEKEY_messaging_errorLayer_tooManyRecipients_title:int = 59;
      
      public static const BASEKEY_messaging_errorLayer_tooManyRecipients_text:int = 60;
      
      public static const BASEKEY_messaging_captcha_msg_info:int = 61;
      
      public static const BASEKEY_messaging_errorLayer_blacklisted_title:int = 62;
      
      public static const BASEKEY_messaging_errorLayer_blacklisted_text:int = 63;
      
      public static const BASEKEY_messaging_errorLayer_blocked_title:int = 64;
      
      public static const BASEKEY_messaging_errorLayer_blocked_text:int = 65;
      
      public static const BASEKEY_messaging_successLayer_messageSent_title:int = 66;
      
      public static const BASEKEY_messaging_successLayer_messageSent_text:int = 67;
      
      public static const BASEKEY_messaging_errorLayer_system_title:int = 68;
      
      public static const BASEKEY_messaging_errorLayer_system_text:int = 69;
      
      public static const BASEKEY_messaging_errorLayer_notesLimitReached_title:int = 70;
      
      public static const BASEKEY_messaging_errorLayer_notesLimitReached_text:int = 71;
      
      public static const BASEKEY_messaging_successLayer_messageSavedAsNote_title:int = 72;
      
      public static const BASEKEY_messaging_successLayer_messageSavedAsNote_text:int = 73;
      
      public static const BASEKEY_messaging_errorLayer_subjectTooShort_title:int = 74;
      
      public static const BASEKEY_messaging_errorLayer_subjectTooShort_text:int = 75;
      
      public static const BASEKEY_messaging_errorLayer_subjectTooLong_title:int = 76;
      
      public static const BASEKEY_messaging_errorLayer_subjectTooLong_text:int = 77;
      
      public static const BASEKEY_messaging_errorLayer_bodyTooShort_title:int = 78;
      
      public static const BASEKEY_messaging_errorLayer_bodyTooShort_text:int = 79;
      
      public static const BASEKEY_messaging_errorLayer_bodyTooLong_title:int = 80;
      
      public static const BASEKEY_messaging_errorLayer_bodyTooLong_text:int = 81;
      
      public static const BASEKEY_auction_error_generic:int = 82;
      
      public static const BASEKEY_drone_have_max:int = 83;
      
      public static const BASEKEY_items_shop_error_ship_contains_ship:int = 84;
      
      public static const BASEKEY_items_design_already_in_use:int = 85;
      
      public static const BASEKEY_auction_buy_instant_invalid:int = 86;
      
      public static const BASEKEY_too_fast:int = 87;
      
      public static const BASEKEY_not_enough_uridium:int = 88;
      
      public static const BASEKEY_auction_bid_toofast:int = 89;
      
      public static const BASEKEY_auction_buy_toofast:int = 90;
      
      public static const BASEKEY_auction_bid_max:int = 91;
      
      public static const BASEKEY_captcha:int = 92;
      
      public static const BASEKEY_auction_bid_credits_to_little:int = 93;
      
      public static const BASEKEY_auction_bid_minBid_not_reached:int = 94;
      
      public static const BASEKEY_auction_bid_saved:int = 95;
      
      public static const BASEKEY_err_user_in_clan:int = 96;
      
      public static const BASEKEY_clan_errmsg_required:int = 97;
      
      public static const BASEKEY_clan_errmsg_to_long:int = 98;
      
      public static const BASEKEY_clan_errmsg_desc_to_long:int = 99;
      
      public static const BASEKEY_clan_errmsg_clanname_exists:int = 100;
      
      public static const BASEKEY_clan_name_not_allowed:int = 101;
      
      public static const BASEKEY_clan_errmsg_clantag_exists:int = 102;
      
      public static const BASEKEY_clan_errmsg_clantag_not_allowed:int = 103;
      
      public static const BASEKEY_clan_user_2dayblock:int = 104;
      
      public static const BASEKEY_clan_errmsg_user_not_enough_money:int = 105;
      
      public static const BASEKEY_not_enough_credits:int = 106;
      
      public static const BASEKEY_err_select_clan:int = 107;
      
      public static const BASEKEY_err_clan_apply:int = 108;
      
      public static const BASEKEY_err_clan_apply_send:int = 109;
      
      public static const BASEKEY_err_clan_exist:int = 110;
      
      public static const BASEKEY_err_clan_noRights:int = 111;
      
      public static const BASEKEY_err_clan_full:int = 112;
      
      public static const BASEKEY_clan_not_your_clan:int = 113;
      
      public static const BASEKEY_clan_user_in_clan:int = 114;
      
      public static const BASEKEY_err_clan_decline:int = 115;
      
      public static const BASEKEY_err_clan_no_access:int = 116;
      
      public static const BASEKEY_clan_remove_member:int = 117;
      
      public static const BASEKEY_clan_errmsg_leave_at_station:int = 118;
      
      public static const BASEKEY_clan_changed_tax:int = 119;
      
      public static const BASEKEY_clan_err_wrong_value:int = 120;
      
      public static const BASEKEY_err_clan_user_not_in_clan:int = 121;
      
      public static const BASEKEY_err_clan_no_money:int = 122;
      
      public static const BASEKEY_clan_message_error_payout_userMax_reached:int = 123;
      
      public static const BASEKEY_success_clan_payout:int = 124;
      
      public static const BASEKEY_clan_msg_send:int = 125;
      
      public static const BASEKEY_clan_msg_delete:int = 126;
      
      public static const BASEKEY_clan_msg_all_delete:int = 127;
      
      public static const BASEKEY_success_clan_change_descr:int = 128;
      
      public static const BASEKEY_err_no_clanname:int = 129;
      
      public static const BASEKEY_err_clantag_exist:int = 130;
      
      public static const BASEKEY_clan_tag_not_allowed:int = 131;
      
      public static const BASEKEY_err_clannameChange2Days:int = 132;
      
      public static const BASEKEY_err_clan_other_fractionID:int = 133;
      
      public static const BASEKEY_success_change_data:int = 134;
      
      public static const BASEKEY_err_clan_no_rank:int = 135;
      
      public static const BASEKEY_err_clan_no_change_rank:int = 136;
      
      public static const BASEKEY_success_clan_change_rank:int = 137;
      
      public static const BASEKEY_err_clan_emptyRankNotAllowed:int = 138;
      
      public static const BASEKEY_err_clan_maxRank:int = 139;
      
      public static const BASEKEY_err_clan_rankExist:int = 140;
      
      public static const BASEKEY_clan_new_rank_insert:int = 141;
      
      public static const BASEKEY_clan_delete_my_rank_success:int = 142;
      
      public static const BASEKEY_success_clan_edit_rank:int = 143;
      
      public static const BASEKEY_firmChange_notavailable:int = 144;
      
      public static const BASEKEY_err_clan_firmchange_closeQuest:int = 145;
      
      public static const BASEKEY_firmChange_done:int = 146;
      
      public static const BASEKEY_err_diplo_default:int = 147;
      
      public static const BASEKEY_clan_message_report_to_admin:int = 148;
      
      public static const BASEKEY_err_clan_you_are_leader:int = 149;
      
      public static const BASEKEY_success_clan_changeLeader:int = 150;
      
      public static const BASEKEY_err_clan_noClanID:int = 151;
      
      public static const BASEKEY_err_diplo_not_with_own_clan:int = 152;
      
      public static const BASEKEY_err_clan_diploRequest_exist:int = 153;
      
      public static const BASEKEY_err_diplo_war_is_running:int = 154;
      
      public static const BASEKEY_err_diplo_applyIsRunning:int = 155;
      
      public static const BASEKEY_err_diplo_isRunning:int = 156;
      
      public static const BASEKEY_clan_newDiploOffer:int = 157;
      
      public static const BASEKEY_err_clan_firmchange_notSpacestation_notMapX1:int = 158;
      
      public static const BASEKEY_success_war_is_closed:int = 159;
      
      public static const BASEKEY_diplo_new_allow:int = 160;
      
      public static const BASEKEY_diplo_new_deny:int = 161;
      
      public static const BASEKEY_diplo_request_delete:int = 162;
      
      public static const BASEKEY_diplo_end_success:int = 163;
      
      public static const BASEKEY_change_pilotname_error_signs_number:int = 164;
      
      public static const BASEKEY_change_pilotname_error_signs_illegal:int = 165;
      
      public static const BASEKEY_change_pilotname_error_user_blocked:int = 166;
      
      public static const BASEKEY_change_pilotname_error_inUse:int = 167;
      
      public static const BASEKEY_change_pilotname_success:int = 168;
      
      public static const BASEKEY_messaging_confirmLayer_blockAllInvites_title:int = 169;
      
      public static const BASEKEY_messaging_successLayer_blockAllInvites_text:int = 170;
      
      public static const BASEKEY_messaging_successLayer_unblockAllInvites_text:int = 171;
      
      public static const BASEKEY_eqt_error_playerMayNotEquip2:int = 172;
      
      public static const BASEKEY_special_generic_hint:int = 173;
      
      public static const BASEKEY_error_can_not_equip_to_slot:int = 174;
      
      public static const BASEKEY_captain_error_unhandled:int = 175;
      
      public static const BASEKEY_captain_error_not_near_spacestation:int = 176;
      
      public static const BASEKEY_captain_error_captain_no_energy:int = 177;
      
      public static const BASEKEY_captain_popup_dismiss_active_nova:int = 178;
      
      public static const BASEKEY_captain_hangar_error_perk_lvl_cap:int = 179;
      
      public static const BASEKEY_captain_hangar_error_not_enough_resources:int = 180;
      
      public static const BASEKEY_popup_save_success_title:int = 181;
      
      public static const BASEKEY_popup_save_success_description:int = 182;
      
      public static const BASEKEY_popup_load_success_title:int = 183;
      
      public static const BASEKEY_popup_load_success_description:int = 184;
      
      public static const BASEKEY_eqt_error_playerMayNotRepair:int = 185;
      
      public static const BASEKEY_err_changing_company_tips:int = 186;
      
      public static const BASEKEY_window_a_new_hope_answer_popup_full:int = 187;
      
      public static const BASEKEY_window_a_new_hope_answer_popup_unvalid:int = 188;
      
      public static const BASEKEY_dse_ticket_lack:int = 189;
      
      public static const BASEKEY_dse_ship_not_exist:int = 190;
      
      public static const BASEKEY_dse_ship_destroy:int = 191;
      
      public static const BASEKEY_dse_skip_unavailable:int = 192;
      
      public static const BASEKEY_dse_ship_num_fault:int = 193;
      
      public static const BASEKEY__MAX:int = 194;
      
      public var type:int = 0;
      
      public var enumBaseKey:int = 0;
      
      public var stringBasekey:String = "";
      
      public var argsList:Vector.<ArgStackCommand>;
      
      public function BaseStackCommand(param1:int = 0, param2:String = "", param3:int = 0, param4:Vector.<ArgStackCommand> = null)
      {
         super();
         this.type = param3;
         this.enumBaseKey = param1;
         this.stringBasekey = param2;
         if(param4 == null)
         {
            this.argsList = new Vector.<ArgStackCommand>();
         }
         else
         {
            this.argsList = param4;
         }
      }
      
      public static function get instance() : BaseStackCommand
      {
         return _instance || (_instance = new BaseStackCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 25698;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 10;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:ArgStackCommand = null;
         this.type = param1.readInt();
         this.type = this.type >>> 7 % 32 | this.type << 32 - 7 % 32;
         this.enumBaseKey = param1.readShort();
         this.stringBasekey = param1.readUTF();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.argsList.length > 0)
         {
            this.argsList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = ArgStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.argsList.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:ArgStackCommand = null;
         param1.writeShort(25698);
         param1.writeInt(this.type << 7 % 32 | this.type >>> 32 - 7 % 32);
         param1.writeShort(this.enumBaseKey);
         param1.writeUTF(this.stringBasekey);
         param1.writeByte(this.argsList.length);
         for each(_loc2_ in this.argsList)
         {
            _loc2_.write(param1);
         }
      }
   }
}

