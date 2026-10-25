package net.bigpoint.darkorbit.net
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.net.netty.handlers.BeaconHandler;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class SettingsAssembly extends BaseAssembly
   {
      
      private static var _instance:SettingsAssembly;
      
      private var delegateDict:Dictionary;
      
      private var main:Main;
      
      public function SettingsAssembly(param1:Function)
      {
         super();
         if(param1 !== hidden)
         {
            throw new Error("SettingsAssembly is a Singleton and can only be accessed through SettingsAssembly.getInstance()");
         }
         this.main = _main;
         this.initDelegateDict();
      }
      
      public static function getInstance() : SettingsAssembly
      {
         if(_instance == null)
         {
            _instance = new SettingsAssembly(hidden);
         }
         return _instance;
      }
      
      private static function hidden() : void
      {
      }
      
      public function assembleSetting(param1:Array) : void
      {
         var _loc2_:String = param1[0];
         var _loc3_:String = param1[1];
         if(this.delegateDict[_loc2_] != null)
         {
            this.delegateDict[_loc2_](_loc3_);
         }
      }
      
      private function initDelegateDict() : void
      {
         this.delegateDict = new Dictionary();
         this.delegateDict[ServerCommands.SET_DISPLAY_HITPOINT_BUBBLES] = this.assembleSetDisplayHitpointBubbles;
         this.delegateDict[ServerCommands.SET_DISPLAY_PLAYER_NAMES] = this.assembleSetDisplayPlayerNames;
         this.delegateDict[ServerCommands.SET_PLAY_SFX] = this.assembleSetPlaySFX;
         this.delegateDict[ServerCommands.SET_PLAY_MUSIC] = this.assembleSetPlayMusic;
         this.delegateDict[ServerCommands.SET_PLAY_COMBAT_MUSIC] = this.assembleSetPlayCombatMusic;
         this.delegateDict[ServerCommands.SET_DOUBLECLICK_ATTACK] = this.assembleSetDoubleClickAttack;
         this.delegateDict[ServerCommands.SET_DISPLAY_BATTLERAY_NOTIFICATIONS] = this.assembleSetDisplayBattleRayNotifications;
         this.delegateDict[ServerCommands.SET_SHOW_LOW_HP_WARNINGS] = this.assembleSetShowLowHPWarnings;
         this.delegateDict[ServerCommands.SET_AUTO_BUY_BOOTY_KEYS] = this.assembleSetAutoBuyBootyKeys;
         this.delegateDict[ServerCommands.SET_QUICKSLOT_STOP_ATTACK] = this.assembleSetQuickSlotStopAttack;
         this.delegateDict[ServerCommands.SET_SHOW_DRONES] = this.assembleSetDisplayDrones;
         this.delegateDict[ServerCommands.SET_SHOW_MY_DRONES] = this.assembleSetDisplayMyDrones;
         this.delegateDict[ServerCommands.SET_DISPLAY_NOTIFICATIONS] = this.assembleSetDisplayNotifications;
         this.delegateDict[ServerCommands.SET_DISPLAY_CHAT] = this.assembleSetDisplayChat;
         this.delegateDict[ServerCommands.SET_AUTO_REFINEMENT] = this.assembleSetAutoRefinement;
         this.delegateDict[ServerCommands.SET_AUTO_BOOST] = this.assembleSetAutoBoost;
         this.delegateDict[ServerCommands.SET_DISPLAY_ORE] = this.assembleSetDisplayOre;
         this.delegateDict[ServerCommands.SET_DISPLAY_BONUS_BOXES] = this.assembleSetDisplayBonusBoxes;
         this.delegateDict[ServerCommands.SET_DISPLAY_FREE_CARGO_BOXES] = this.assembleSetDisplayFreeCargoBoxes;
         this.delegateDict[ServerCommands.SET_DISPLAY_NOT_FREE_CARGO_BOXES] = this.assembleSetDisplayNotFreeCargoBoxes;
         this.delegateDict[ServerCommands.SET_DISPLAY_MINIMAP_BACKGROUND_IMAGE] = this.assembleSetDisplayMiniMapBackgroundImage;
         this.delegateDict[ServerCommands.SET_AUTO_AMMO_CHANGE] = this.assembleSetAutoChangeAmmo;
         this.delegateDict[ServerCommands.SET_AUTO_START] = this.assembleSetAutostart;
         this.delegateDict[ServerCommands.SET_DISPLAY_WINDOW_BACKGROUND] = this.assembleSetDisplayWindowsBackground;
         this.delegateDict[ServerCommands.SET_ALWAYS_DRAGGABLE_WINDOWS] = this.assembleSetWindowsAlwaysDraggable;
         this.delegateDict[ServerCommands.SET_PRELOAD_USER_SHIPS] = this.assembleSetPreloadUserShips;
         this.delegateDict[ServerCommands.SET_RESOLUTION] = this.assembleSetResolution;
         this.delegateDict[ServerCommands.SET_QUALITY_PRESETTING] = this.assembleSetQualityPresetting;
         this.delegateDict[ServerCommands.SET_QUALITY_CUSTOMIZED] = this.assembleSetQualityCustomized;
         this.delegateDict[ServerCommands.SET_QUALITY_BACKGROUND] = this.assembleSetQualityBackground;
         this.delegateDict[ServerCommands.SET_QUALITY_POIZONE] = this.assembleSetQualityPoizone;
         this.delegateDict[ServerCommands.SET_QUALITY_SHIP] = this.assembleSetQualityShip;
         this.delegateDict[ServerCommands.SET_QUALITY_ENGINE] = this.assembleSetQualityEngine;
         this.delegateDict[ServerCommands.SET_QUALITY_COLLECTABLE] = this.assembleSetQualityCollectable;
         this.delegateDict[ServerCommands.SET_QUALITY_ATTACK] = this.assembleSetQualityAttack;
         this.delegateDict[ServerCommands.SET_QUALITY_EFFECT] = this.assembleSetQualityEffect;
         this.delegateDict[ServerCommands.SET_QUALITY_EXPLOSION] = this.assembleSetQualityExplosion;
         this.delegateDict[ServerCommands.SET_ALLOW_AUTO_QUALITY] = this.assembleSetAllowAutoQuality;
         this.delegateDict[ServerCommands.SET_HOVER_SHIPS] = this.assembleSetWhipShips;
         this.delegateDict[ServerCommands.SET_PREMIUM_QUICKSLOT_VISIBILITY] = this.assemblePremiumQuickslotVisibility;
         this.delegateDict[ServerCommands.SET_DISPLAY_NOT_OWNED_ITEMS] = this.assembleShowNotOwnedItems;
         this.delegateDict[ServerCommands.SET_DISPLAY_NOT_OWNED_ITEMS] = this.assembleShowNotOwnedItems;
      }
      
      private function assembleSetResolution(param1:String) : void
      {
      }
      
      private function assembleSetPreloadUserShips(param1:String) : void
      {
         Settings.preloadUserShips = Boolean(int(param1));
      }
      
      private function assembleSetQualityPresetting(param1:String) : void
      {
         Settings.qualityPresetting = int(param1);
      }
      
      private function assembleSetQualityCustomized(param1:String) : void
      {
         Settings.qualityCustomized = Boolean(int(param1));
      }
      
      private function assembleSetQualityBackground(param1:String) : void
      {
         Settings.qualityBackground.value = int(param1);
      }
      
      private function assembleSetQualityPoizone(param1:String) : void
      {
         Settings.qualityPoizone.value = int(param1);
      }
      
      private function assembleSetQualityShip(param1:String) : void
      {
         Settings.qualityShip.value = int(param1);
      }
      
      private function assembleSetQualityEngine(param1:String) : void
      {
         Settings.qualityEngine.value = int(param1);
      }
      
      private function assembleSetQualityCollectable(param1:String) : void
      {
         Settings.qualityCollectable.value = int(param1);
      }
      
      private function assembleSetQualityAttack(param1:String) : void
      {
         Settings.qualityAttack.value = int(param1);
      }
      
      private function assembleSetQualityEffect(param1:String) : void
      {
         Settings.qualityEffect.value = int(param1);
      }
      
      private function assembleSetQualityExplosion(param1:String) : void
      {
         Settings.qualityExplosion.value = int(param1);
      }
      
      private function assembleSetQuickSlotStopAttack(param1:String) : void
      {
         Settings.quickSlotStopAttack = Boolean(int(param1));
      }
      
      private function assembleSetDisplayDrones(param1:String) : void
      {
         Settings.showDrones.value = Boolean(int(param1));
      }
      
      private function assembleSetDisplayMyDrones(param1:String) : void
      {
         Settings.showMyDrones.value = Boolean(int(param1));
      }
      
      private function assembleSetAutostart(param1:String) : void
      {
         Settings.autoStartEnabled = Boolean(int(param1));
      }
      
      private function assembleSetDisplayWindowsBackground(param1:String) : void
      {
         var _loc3_:Object = null;
         var _loc4_:SimpleWindow = null;
         Settings.displayWindowsBackground.value = Boolean(int(param1));
         var _loc2_:Dictionary = _main.getGuiManager().windows;
         for(_loc3_ in _loc2_)
         {
            _loc4_ = _loc2_[_loc3_] as SimpleWindow;
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
      }
      
      private function assembleSetWindowsAlwaysDraggable(param1:String) : void
      {
         var _loc3_:Object = null;
         var _loc4_:SimpleWindow = null;
         Settings.dragWindowsAlways = Boolean(int(param1));
         var _loc2_:Dictionary = _main.getGuiManager().windows;
         for(_loc3_ in _loc2_)
         {
            _loc4_ = _loc2_[_loc3_] as SimpleWindow;
            _loc4_.updateDraggerButtonMode();
         }
      }
      
      private function assembleSetDisplayBattleRayNotifications(param1:String) : void
      {
         Settings.displayBattlerayNotifications = Boolean(int(param1));
      }
      
      private function assembleSetShowLowHPWarnings(param1:String) : void
      {
         Settings.showLowHpWarnings = Boolean(int(param1));
         BeaconHandler.updateWarnings();
      }
      
      private function assembleSetDoubleClickAttack(param1:String) : void
      {
         Settings.doubleclickAttackEnabled = Boolean(int(param1));
      }
      
      private function assembleSetAutoBuyBootyKeys(param1:String) : void
      {
         Settings.autoBuyBootyKeys = Boolean(int(param1));
      }
      
      private function assembleSetAutoRefinement(param1:String) : void
      {
         Settings.autoRefinement = Boolean(int(param1));
      }
      
      private function assembleSetAutoChangeAmmo(param1:String) : void
      {
         Settings.autochangeAmmo = Boolean(int(param1));
      }
      
      private function assembleSetDisplayNotFreeCargoBoxes(param1:String) : void
      {
         Settings.displayNotFreeCargoBoxes.value = Boolean(int(param1));
      }
      
      private function assembleSetDisplayFreeCargoBoxes(param1:String) : void
      {
         Settings.displayFreeCargoBoxes.value = Boolean(int(param1));
      }
      
      private function assembleSetDisplayNotifications(param1:String) : void
      {
         Settings.displayNotifications.value = Boolean(int(param1));
      }
      
      private function assembleSetDisplayChat(param1:String) : void
      {
         Settings.displayChat.value = Boolean(int(param1));
      }
      
      private function assembleSetPlayMusic(param1:String) : void
      {
         Settings.playMusic.value = Boolean(int(param1));
      }
      
      private function assembleSetPlayCombatMusic(param1:String) : void
      {
         Settings.playCombatMusic.value = Boolean(int(param1));
      }
      
      private function assembleSetPlaySFX(param1:String) : void
      {
         Settings.playSFX.value = Boolean(int(param1));
      }
      
      private function assembleSetAutoBoost(param1:String) : void
      {
         Settings.autoBoost = Boolean(int(param1));
      }
      
      private function assembleSetDisplayPlayerNames(param1:String) : void
      {
         Settings.displayPlayerNames.value = Boolean(int(param1));
      }
      
      private function assembleSetDisplayOre(param1:String) : void
      {
         Settings.displayResources.value = Boolean(int(param1));
      }
      
      private function assembleSetDisplayBonusBoxes(param1:String) : void
      {
         Settings.displayBonusBoxes.value = Boolean(int(param1));
      }
      
      private function assembleSetDisplayMiniMapBackgroundImage(param1:String) : void
      {
         Settings.displayMiniMapBackgroundImage.value = Boolean(int(param1));
      }
      
      private function assembleSetDisplayHitpointBubbles(param1:String) : void
      {
         Settings.displayHitpointBubbles = Boolean(int(param1));
      }
      
      private function assembleSetAllowAutoQuality(param1:String) : void
      {
         Settings.allowAutoQuality.value = Boolean(int(param1));
      }
      
      private function assembleSetWhipShips(param1:String) : void
      {
         Settings.hoverShips.value = Boolean(int(param1));
      }
      
      private function assemblePremiumQuickslotVisibility(param1:String) : void
      {
         Settings.showPremiumQuickslotBar = Boolean(int(param1));
      }
      
      private function assembleShowNotOwnedItems(param1:String) : void
      {
         Settings.showNotOwnedItems = Boolean(int(param1));
      }
   }
}

