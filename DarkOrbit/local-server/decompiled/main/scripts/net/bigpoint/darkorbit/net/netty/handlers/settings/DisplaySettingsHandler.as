package net.bigpoint.darkorbit.net.netty.handlers.settings
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.com.module.DisplaySettingsModule;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.settingsFUI.SettingsWindowNotifications;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class DisplaySettingsHandler extends BaseHandler
   {
      
      public function DisplaySettingsHandler()
      {
         super();
      }
      
      public static function run(param1:DisplaySettingsModule) : void
      {
         var _loc3_:Object = null;
         var _loc4_:SimpleWindow = null;
         var _loc5_:Boolean = false;
         var _loc6_:SimpleWindow = null;
         Settings.dragWindowsAlways = param1.alwaysDraggableWindows;
         var _loc2_:Dictionary = _main.getGuiManager().windows;
         for(_loc3_ in _loc2_)
         {
            _loc6_ = _loc2_[_loc3_] as SimpleWindow;
            _loc6_.updateDraggerButtonMode();
         }
         Settings.displayPlayerNames.value = param1.displayPlayerName;
         Settings.displayResources.value = param1.displayResources;
         Settings.displayBonusBoxes.value = param1.displayBoxes;
         Settings.displayHitpointBubbles = param1.displayHitpointBubbles;
         Settings.displayChat.value = param1.displayChat;
         Settings.showDrones.value = param1.displayDrones;
         Settings.showMyDrones.value = param1.displayMyDrones;
         Settings.displayFreeCargoBoxes.value = param1.displayCargoboxes;
         Settings.displayNotFreeCargoBoxes.value = param1.displayPenaltyCargoboxes;
         Settings.displayWindowsBackground.value = param1.displayWindowBackground;
         for each(_loc4_ in _loc2_)
         {
            if(Settings.displayWindowsBackground.value)
            {
               _loc4_.removeListeners();
               _loc4_.fadeInWindow();
            }
            else
            {
               _loc4_.setListeners();
               _loc4_.fadeOutWindow();
            }
         }
         Settings.displayNotifications.value = param1.displayNotifications;
         Settings.dragWindowsAlways = param1.alwaysDraggableWindows;
         Settings.preloadUserShips = param1.preloadUserShips;
         Settings.allowAutoQuality.value = param1.useAutoQuality;
         Settings.hoverShips.value = param1.shipHovering;
         Settings.showPremiumQuickslotBar = param1.showSecondQuickslotBar;
         Settings.proActionBarEnabled.value = param1.proActionBarEnabled;
         Settings.proActionBarAutohideEnabled = param1.proActionBarAutohideEnabled;
         Settings.proActionBarKeyboardInputEnabled = param1.proActionBarKeyboardInputEnabled;
         Settings.showNotOwnedItems = param1.showNotOwnedItems;
         Settings.displayMiniMapBackgroundImage.value = param1.displayMinimapBackground;
         Settings.displaySettingPixelationMode.value = param1.pixelatedRenderingEnabled;
         _loc5_ = false;
         if(!Settings.localSettingsAvailable())
         {
            if(param1.displaySetting3DqualityAntialias > 0)
            {
               Settings.displaySetting3DqualityAntialias.value = param1.displaySetting3DqualityAntialias - 1;
               Settings.qualityBackground.value = param1.displaySetting3DqualityBackground - 1;
               Settings.displaySetting3DqualityEffects.value = param1.displaySetting3DqualityEffects - 1;
               Settings.displaySetting3DqualityLights.value = param1.displaySetting3DqualityLights - 1;
               Settings.displaySetting3DqualityTextures.value = param1.displaySetting3DqualityTextures - 1;
               Settings.qualityPoizone.value = param1.displaySetting3DqualityZones - 1;
               Settings.displaySetting3DsizeTextures.value = param1.displaySetting3DsizeTextures - 1;
               Settings.displaySetting3DtextureFiltering.value = param1.displaySetting3DtextureFiltering - 1;
               _facade.sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_APPLY_SETTINGS_FROM_SERVER);
            }
            else
            {
               applyAndSave3DSettings();
               _loc5_ = true;
            }
         }
         _facade.sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_APPLY_SETTINGS_FROM_SERVER);
         if(_loc5_ == false && (Settings.userType == Settings.USER_TYPE_NEW || Settings.userType == Settings.USER_TYPE_NOT_SELECTED))
         {
            applyAndSave3DSettings(false);
         }
      }
      
      private static function applyAndSave3DSettings(param1:Boolean = true) : void
      {
         Settings.userType = Settings.FORCE_2D.value ? Settings.USER_TYPE_2D : Settings.USER_TYPE_3D;
         if(param1)
         {
            Settings.displaySetting3DqualityAntialias.value = 3;
            Settings.qualityBackground.value = 3;
            Settings.displaySetting3DqualityEffects.value = 3;
            Settings.displaySetting3DqualityLights.value = 3;
            Settings.displaySetting3DqualityTextures.value = 3;
            Settings.qualityPoizone.value = 3;
            Settings.displaySetting3DsizeTextures.value = 3;
            Settings.displaySetting3DtextureFiltering.value = 3;
            Settings.displaySettingPixelationMode.value = false;
         }
         _facade.sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_APPLY_SETTINGS_FROM_SERVER);
         _main.getGuiManager().saveDisplaySettings();
      }
   }
}

