package net.bigpoint.darkorbit.mvc.settingsFUI.model
{
   public class SettingsDropDownBoxItemVO
   {
      
      public static const SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_2D_QUALITY_BACKGROUND:int = 1001;
      
      public static const SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_2D_QUALITY_ZONES:int = 1002;
      
      public static const SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_2D_QUALITY_SHIPS:int = 1003;
      
      public static const SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_2D_QUALITY_ENGINES:int = 1004;
      
      public static const SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_2D_QUALITY_EXPLOSIONS:int = 1005;
      
      public static const SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_2D_QUALITY_RESOURCES_AND_BOXES:int = 1006;
      
      public static const SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_3D_QUALITY_ANTIALIAS:int = 1501;
      
      public static const SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_3D_QUALITY_LIGHTS:int = 1502;
      
      public static const SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_3D_QUALITY_TEXTURES:int = 1503;
      
      public static const SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_3D_SIZE_TEXTURES:int = 1504;
      
      public static const SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_3D_QUALITY_EFFECTS:int = 1505;
      
      public static const SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_3D_TEXTURE_FILTERING:int = 1506;
      
      public static const SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_3D_QUALITY_BACKGROUND:int = 1507;
      
      public static const SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_3D_QUALITY_ZONES:int = 1508;
      
      private var _dropDownBoxId:int;
      
      private var _selectedIndex:int;
      
      public function SettingsDropDownBoxItemVO(param1:int, param2:int)
      {
         super();
         this._dropDownBoxId = param1;
         this._selectedIndex = param2;
      }
      
      public function get dropDownBoxId() : int
      {
         return this._dropDownBoxId;
      }
      
      public function get selectedIndex() : int
      {
         return this._selectedIndex;
      }
   }
}

