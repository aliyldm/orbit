package net.bigpoint.darkorbit.mvc.settingsFUI.model
{
   public class SettingsCheckBoxItemVO
   {
      
      public static const SETTINGS_CHECK_BOX_ID_USE2D:int = 1001;
      
      public static const SETTINGS_CHECK_BOX_ID_PRELOAD_SHIPS:int = 1002;
      
      public static const SETTINGS_CHECK_BOX_ID_ADVANCED:int = 1003;
      
      public static const SETTINGS_3D_CHECK_BOX_ID_PIXELATION_MODE:int = 1004;
      
      public static const SETTINGS_CHECK_BOX_ID_AUTO_WEAPONS_UPGRADE:int = 2001;
      
      public static const SETTINGS_CHECK_BOX_ID_AUTO_AMMO_SWITCH:int = 2002;
      
      public static const SETTINGS_CHECK_BOX_ID_AUTO_REFINE:int = 2003;
      
      public static const SETTINGS_CHECK_BOX_ID_START_STOP_ATTACKS_QUICKBAR:int = 2004;
      
      public static const SETTINGS_CHECK_BOX_ID_AUTO_LOGIN:int = 2005;
      
      public static const SETTINGS_CHECK_BOX_ID_DOUBLECLICK_ATTACK:int = 2006;
      
      public static const SETTINGS_CHECK_BOX_ID_AUTO_PURCHASE_GREEN_BOOTYKEYS:int = 2007;
      
      public static const SETTINGS_CHECK_BOX_ID_SHOW_BATTLERAY_NOTIFICATIONS:int = 2008;
      
      public static const SETTINGS_CHECK_BOX_ID_SHOW_LOW_HP_WARNING:int = 2009;
      
      public static const SETTINGS_CHECK_BOX_ID_SHOW_PLAYER_NAMES:int = 3001;
      
      public static const SETTINGS_CHECK_BOX_ID_SHOW_RESOURCES:int = 3002;
      
      public static const SETTINGS_CHECK_BOX_ID_SHOW_BONUS_BOXES:int = 3003;
      
      public static const SETTINGS_CHECK_BOX_ID_SHOW_ASCENDING_HIT_COUNT:int = 3004;
      
      public static const SETTINGS_CHECK_BOX_ID_SHOW_DRONES:int = 3005;
      
      public static const SETTINGS_CHECK_BOX_ID_SHOW_CARGO_BOXES:int = 3006;
      
      public static const SETTINGS_CHECK_BOX_ID_SHOW_CARGO_BOXES_NOT_FREE:int = 3007;
      
      public static const SETTINGS_CHECK_BOX_ID_SHOW_MINIMAP_BACKGROUND:int = 3008;
      
      public static const SETTINGS_CHECK_BOX_ID_DISPLAY_GAME_PERFORMANCE_MESSAGES:int = 3009;
      
      public static const SETTINGS_CHECK_BOX_ID_AUTO_QUALITY_REDUCTION:int = 3010;
      
      public static const SETTINGS_CHECK_BOX_ID_HOVER_SHIPS:int = 3011;
      
      public static const SETTINGS_CHECK_BOX_ID_SHOW_CHAT:int = 3012;
      
      public static const SETTINGS_CHECK_BOX_ID_ALWAYS_DRAGGABLE_WINDOWS:int = 3013;
      
      public static const SETTINGS_CHECK_BOX_ID_SHOW_WINDOW_BACKGROUNDS:int = 3014;
      
      public static const SETTINGS_CHECK_BOX_ID_DISPLAY_PREMIUM_QUICKSLOT_BAR:int = 3015;
      
      public static const SETTINGS_CHECK_BOX_ID_SHOW_ITEMS_NOT_OWNED:int = 3016;
      
      public static const SETTINGS_CHECK_BOX_ID_PRO_ACTION_BAR_ENABLED:int = 3017;
      
      public static const SETTINGS_CHECK_BOX_ID_PRO_ACTION_BAR_AUTOHIDE_ENABLED:int = 3018;
      
      public static const SETTINGS_CHECK_BOX_ID_PRO_ACTION_BAR_KEYBOARD_INPUT_ENABLED:int = 3019;
      
      public static const SETTINGS_CHECK_BOX_ID_SHOW_MY_DRONES:int = 3020;
      
      public static const SETTINGS_CHECK_BOX_ID_PLAY_COMBAT_MUSIC:int = 4001;
      
      private var _checkBoxId:int = -1;
      
      private var _checkBoxSelected:Boolean = false;
      
      private var _labelTextKey:String = "";
      
      private var _infoToolTipKey:String = "";
      
      public function SettingsCheckBoxItemVO(param1:int, param2:Boolean, param3:String = null, param4:String = null)
      {
         super();
         this._checkBoxId = param1;
         this._checkBoxSelected = param2;
         this._labelTextKey = param3;
         this._infoToolTipKey = param4;
      }
      
      public function get checkBoxSelected() : Boolean
      {
         return this._checkBoxSelected;
      }
      
      public function get labelTextKey() : String
      {
         return this._labelTextKey;
      }
      
      public function get infoToolTipKey() : String
      {
         return this._infoToolTipKey;
      }
      
      public function set checkBoxSelected(param1:Boolean) : void
      {
         this._checkBoxSelected = param1;
      }
      
      public function get checkBoxId() : int
      {
         return this._checkBoxId;
      }
   }
}

