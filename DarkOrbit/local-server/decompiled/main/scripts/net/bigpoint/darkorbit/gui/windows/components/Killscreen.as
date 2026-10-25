package net.bigpoint.darkorbit.gui.windows.components
{
   import com.bigpoint.utils.TextFormatter;
   import com.greensock.TweenLite;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.com.module.KillScreenOptionTypeModule;
   import net.bigpoint.darkorbit.com.module.KillScreenRepairRequest;
   import net.bigpoint.darkorbit.com.module.PriceModule;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.killscreen.vos.KillScreenOptionDetailVo;
   import net.bigpoint.darkorbit.gui.killscreen.vos.KillscreenOptionVO;
   import net.bigpoint.darkorbit.gui.windows.components.repair.KillScreenWindow;
   import net.bigpoint.darkorbit.gui.windows.components.repair.RepairEvent;
   import net.bigpoint.darkorbit.interfaces.IFrameObserver;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.net.JavascriptProxy;
   import net.bigpoint.darkorbit.net.netty.handlers.KillScreenOptionHandler;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.darkorbit.utils.math.FastMath;
   
   public final class Killscreen implements IFrameObserver
   {
      
      public static const PLAYER:int = 0;
      
      public static const NPC:int = 1;
      
      public static const RADIATION:int = 2;
      
      public static const MINE:int = 3;
      
      public static const MISC:int = 4;
      
      private static var _instance:Killscreen = new Killscreen();
      
      private static const destructionTypes:Dictionary = new Dictionary();
      
      destructionTypes[PLAYER] = "head_killscreen_destroyer_player";
      destructionTypes[NPC] = "head_killscreen_destroyer_npc";
      destructionTypes[RADIATION] = "head_killscreen_destroyer_radiation_zone";
      destructionTypes[MINE] = "head_killscreen_destroyer_mine";
      destructionTypes[MISC] = "head_killscreen_destroyer_unknown";
      
      private var repairWindow:KillScreenWindow;
      
      private var selectedOption:int;
      
      private var guiManager:GuiManager;
      
      private var _main:Main;
      
      private var blocker:Sprite;
      
      private var targetMaps:Dictionary = new Dictionary();
      
      private var _optionType:int;
      
      private var _optionTypes:Array;
      
      private var optionVOs:Vector.<KillscreenOptionVO>;
      
      private var _showRepairWindow:Boolean = false;
      
      private var _killerName:String;
      
      private var _killerEpppLink:String;
      
      private var explosionTimer:Timer;
      
      private var _tpf:Number = 0;
      
      private var cooldown:int = 0;
      
      public function Killscreen()
      {
         super();
         if(_instance)
         {
            throw new Error("Singleton and can only access with Singleton.getInstance()");
         }
      }
      
      public static function getInstance() : Killscreen
      {
         return _instance;
      }
      
      private function initWindow() : void
      {
         this.defineOptions();
         this.repairWindow = new KillScreenWindow(this.optionVOs);
         this.setRepairButtonLabel("btn_killscreen_default",0);
         this.initWindowListeners();
      }
      
      private function defineOptions() : void
      {
         this.optionVOs = new Vector.<KillscreenOptionVO>(13);
         this.optionVOs[KillScreenOptionTypeModule.OPTIONTYPE_FREE_PHOENIX] = new KillscreenOptionVO("icon_freeRepair","ttip_killscreen_basic_repair",Styles.repairWindowWhite,"","");
         this.optionVOs[KillScreenOptionTypeModule.OPTIONTYPE_BASIC_REPAIR] = new KillscreenOptionVO("icon_freeRepair","ttip_killscreen_basic_repair",Styles.repairWindowWhite,"","");
         this.optionVOs[KillScreenOptionTypeModule.OPTIONTYPE_AT_JUMPGATE_REPAIR] = new KillscreenOptionVO("icon_gate","ttip_killscreen_repair_jumpgate",Styles.repairWindowGreen,"","");
         this.optionVOs[KillScreenOptionTypeModule.OPTIONTYPE_AT_DEATHLOCATION_REPAIR] = new KillscreenOptionVO("icon_location","ttip_killscreen_repair_location",Styles.repairWindowGreen,"","");
         this.optionVOs[KillScreenOptionTypeModule.OPTIONTYPE_AT_SECTOR_CONTROL_SPAWNPOINT] = new KillscreenOptionVO("icon_spawnPoint","ttip_killscreen_repair_spawnpoint",Styles.repairWindowWhite,"","");
         this.optionVOs[KillScreenOptionTypeModule.OPTIONTYPE_EXIT_SECTOR_CONTROL] = new KillscreenOptionVO("icon_freeRepair","ttip_killscreen_basic_repair",Styles.repairWindowWhite,"","");
         this.optionVOs[KillScreenOptionTypeModule.OPTIONTYPE_BASIC_FULL_REPAIR] = new KillscreenOptionVO("icon_freeRepair","ttip_killscreen_basic_repair",Styles.repairWindowWhite,"","");
         this.optionVOs[KillScreenOptionTypeModule.OPTIONTYPE_RAID_GATE_REPAIR] = new KillscreenOptionVO("icon_spawnPoint","ttip_killscreen_repair_hadesgate",Styles.repairWindowWhite,"","");
         this.optionVOs[KillScreenOptionTypeModule.OPTIONTYPE_TDM_REPAIR] = new KillscreenOptionVO("icon_spawnPoint","ttip_killscreen_repair_tdm",Styles.repairWindowWhite,"","");
         this.optionVOs[KillScreenOptionTypeModule.OPTIONTYPE_PAYMENT] = new KillscreenOptionVO("icon_payment","ttip_killscreen_linkTo_payment",Styles.repairWindowRed,"","");
         this.optionVOs[KillScreenOptionTypeModule.OPTIONTYPE_REFRACTION_ZONE_DEATH_LOCATION] = new KillscreenOptionVO("icon_location","ttip_killscreen_repair_location",Styles.repairWindowGreen,"","");
         this.optionVOs[KillScreenOptionTypeModule.OPTIONTYPE_REFRACTION_ZONE_FACTION_BASE] = new KillscreenOptionVO("icon_spawnPoint","ttip_killscreen_rzone_repair_factionbase",Styles.repairWindowWhite,"","");
         this.optionVOs[KillScreenOptionTypeModule.OPTIONTYPE_WAR_GAME_REPAIR] = new KillscreenOptionVO("icon_spawnPoint","ttip_killscreen_repair_wargame",Styles.repairWindowWhite,"","");
         this.optionVOs[KillScreenOptionTypeModule.OPTIONTYPE_STRIKE_AND_EXIT] = new KillscreenOptionVO("icon_spawnPoint","ttip_killscreen_repair_tdm",Styles.repairWindowWhite,"","");
      }
      
      private function repair(param1:RepairEvent) : void
      {
         var _loc2_:KillScreenRepairRequest = null;
         switch(this.selectedOption)
         {
            case KillScreenOptionTypeModule.OPTIONTYPE_FREE_PHOENIX:
               this.linkToShop();
               this.logout(param1);
               break;
            case KillScreenOptionTypeModule.OPTIONTYPE_PAYMENT:
               this.linkToPaymentPage();
               this.logout(param1);
               break;
            case KillScreenOptionTypeModule.OPTIONTYPE_BASIC_REPAIR:
            case KillScreenOptionTypeModule.OPTIONTYPE_AT_JUMPGATE_REPAIR:
            case KillScreenOptionTypeModule.OPTIONTYPE_AT_DEATHLOCATION_REPAIR:
            case KillScreenOptionTypeModule.OPTIONTYPE_AT_SECTOR_CONTROL_SPAWNPOINT:
            case KillScreenOptionTypeModule.OPTIONTYPE_RAID_GATE_REPAIR:
            case KillScreenOptionTypeModule.OPTIONTYPE_TDM_REPAIR:
            case KillScreenOptionTypeModule.OPTIONTYPE_STRIKE_AND_EXIT:
            default:
               Settings.nextMapID = this.targetMaps[this._optionType];
               _loc2_ = new KillScreenRepairRequest();
               _loc2_.selection.repairTypeValue = this.selectedOption;
               _loc2_.requestModule.userID = Hero.userID;
               _loc2_.requestModule.sessionID = Hero.sessionID;
               _loc2_.requestModule.factionID = Hero.factionID.value;
               Settings.lastMapID = -1;
               this._main.getConnectionManager().sendRequest(_loc2_);
         }
         this.cleanup();
      }
      
      private function linkToShop() : void
      {
         JavascriptProxy.referToURL("internalDock","seo_tittle_ships","internalDockShips");
      }
      
      private function linkToProfilePage(param1:RepairEvent) : void
      {
         var _loc2_:String = this._killerEpppLink + "/?lang=" + Settings.language;
         JavascriptProxy.call(JavascriptProxy.FUNCTION_DO_REDIRECT,[Settings.dynamicHost + _loc2_,true]);
      }
      
      private function linkToPaymentPage() : void
      {
         JavascriptProxy.referToURL("internalPayment","seo_tittle_uridium");
      }
      
      private function logout(param1:RepairEvent) : void
      {
         this.guiManager.handleCloseClientButtonClicked();
      }
      
      private function setSelected(param1:RepairEvent) : void
      {
         this.selectedOption = param1.selectedID;
         if(this.optionVOs[this.selectedOption].affordable || !this.isCreditRepair(this.optionVOs[this.selectedOption]))
         {
            if(this.selectedOption == KillScreenOptionTypeModule.OPTIONTYPE_STRIKE_AND_EXIT && this.cooldown > 0)
            {
               return;
            }
            this.setRepairButtonLabel(this.optionVOs[this.selectedOption].buttonKey,this.optionVOs[this.selectedOption].repairCost,this.optionVOs[this.selectedOption].currency);
         }
         else
         {
            this.repairWindow.disableRepairButton();
         }
         this.repairWindow.setDetailText(this.optionVOs[this.selectedOption].detailText.replace(/%COUNTDOWN%/,"<font color=\'#FF0000\' size=\'+6\'>" + this.optionVOs[this.selectedOption].cooldown + "</font>"));
      }
      
      private function isCreditRepair(param1:KillscreenOptionVO) : Boolean
      {
         return param1.currency == KillScreenOptionHandler.getCurrencyByPriceModule(PriceModule.CURRENCYTYPE_CREDITS);
      }
      
      private function cutSingleLine(param1:String, param2:int) : String
      {
         if(param1.length <= param2)
         {
            return param1;
         }
         return param1.substring(0,param2) + "...";
      }
      
      private function initWindowListeners() : void
      {
         this.repairWindow.addEventListener(RepairEvent.SET_SELECTED,this.setSelected);
         this.repairWindow.addEventListener(RepairEvent.LOGOUT,this.logout);
         this.repairWindow.addEventListener(RepairEvent.REPAIR,this.repair);
         this.repairWindow.addEventListener(RepairEvent.OPEN_PROFILE_PAGE,this.linkToProfilePage);
         this.repairWindow.initListeners();
      }
      
      private function handleExplosionComplete(param1:TimerEvent) : void
      {
         this.explosionTimer.stop();
         this.explosionTimer.reset();
         this.explosionTimer.removeEventListener(TimerEvent.TIMER,this.handleExplosionComplete);
         this.repairWindow.alpha = 0;
         this._showRepairWindow = true;
         if(!this._main.screenManager.getWindowLayer2().contains(this.repairWindow))
         {
            this._main.screenManager.getWindowLayer2().addChild(this.repairWindow);
         }
         this.centerKillScreenWindow();
         TweenLite.to(this.repairWindow,1,{"alpha":1});
      }
      
      public function centerKillScreenWindow() : void
      {
         if(this.repairWindow)
         {
            this.repairWindow.x = ScreenManager.getHalfScreenWidth() - (this.repairWindow.width >> 1);
            this.repairWindow.y = ScreenManager.getHalfScreenHeight() - (this.repairWindow.height >> 1);
         }
      }
      
      public function showRepairWindow(param1:Main, param2:String, param3:String = "", param4:String = "") : void
      {
         this._optionTypes = [];
         this.initWindow();
         this._main = param1;
         this.setTitle(param2);
         this._killerName = param3;
         this._killerEpppLink = param4;
         this.guiManager = param1.getGuiManager();
         if(this._main.screenManager.map)
         {
            if(this.blocker != null && Boolean(this.blocker.parent))
            {
               this.blocker.parent.removeChild(this.blocker);
            }
            this.blocker = new Sprite();
            this.blocker.graphics.beginFill(4278190080);
            this.blocker.graphics.drawRect(0,0,ScreenManager.getScreenWidth(),ScreenManager.getScreenHeight());
            this.blocker.alpha = 0;
            TweenLite.to(this.blocker,6,{"alpha":0.85});
            this._main.screenManager.getWindowLayer2().addChild(this.blocker);
         }
         if(this._main.screenManager.map)
         {
            this.explosionTimer = new Timer(1000 * 4,1);
         }
         else
         {
            this.explosionTimer = new Timer(20,1);
         }
         this.explosionTimer.addEventListener(TimerEvent.TIMER,this.handleExplosionComplete);
         this.explosionTimer.start();
      }
      
      public function removeRepairWindow() : void
      {
         if(this.repairWindow)
         {
            if(Boolean(this.explosionTimer) && this.explosionTimer.running)
            {
               this.handleExplosionComplete(new TimerEvent(TimerEvent.TIMER));
            }
            if(ScreenManager.getInstance().getWindowLayer2().contains(this.repairWindow))
            {
               ScreenManager.getInstance().getWindowLayer2().removeChild(this.repairWindow);
            }
            if(Boolean(this.blocker) && ScreenManager.getInstance().getWindowLayer2().contains(this.blocker))
            {
               ScreenManager.getInstance().getWindowLayer2().removeChild(this.blocker);
            }
            this.repairWindow.removeEventListener(RepairEvent.SET_SELECTED,this.setSelected);
            this.repairWindow.removeEventListener(RepairEvent.LOGOUT,this.logout);
            this.repairWindow.removeEventListener(RepairEvent.REPAIR,this.repair);
            this.repairWindow.removeEventListener(RepairEvent.OPEN_PROFILE_PAGE,this.linkToProfilePage);
            this.repairWindow.removeListeners();
            this.repairWindow = null;
         }
         ScreenManager.removeObserver(this);
         this._showRepairWindow = false;
      }
      
      public function displayOptions() : void
      {
         this.repairWindow.setOptionTypes(this._optionTypes);
      }
      
      public function clearOptions() : void
      {
         ScreenManager.removeObserver(this);
         this._optionTypes = [];
         this.repairWindow.removeOptionTypes();
      }
      
      public function addOption(param1:int, param2:int, param3:int, param4:String, param5:String, param6:Boolean, param7:int, param8:int) : void
      {
         var _loc9_:String = KillScreenOptionHandler.getCurrencyByPriceModule(param3);
         if(param6 == true)
         {
            if(param2 == 0)
            {
               this.optionVOs[param1].priceColor = Styles.repairWindowWhite;
            }
            else
            {
               this.optionVOs[param1].priceColor = Styles.repairWindowGreen;
            }
         }
         else
         {
            this.optionVOs[param1].priceColor = Styles.repairWindowRed;
         }
         this.optionVOs[param1].priceType = param8;
         this.optionVOs[param1].buttonKey = param4;
         this.optionVOs[param1].wildcard = param5;
         this.optionVOs[param1].affordable = param6;
         this.optionVOs[param1].repairCost = param2;
         this.optionVOs[param1].cooldown = param7;
         this.optionVOs[param1].currency = _loc9_;
         this._optionTypes.push(param1);
         if(param7 > 0 && !ScreenManager.containsObserver(this))
         {
            ScreenManager.addObserver(this);
         }
      }
      
      public function setOptionDetailText(param1:int, param2:KillScreenOptionDetailVo = null, param3:KillScreenOptionDetailVo = null) : void
      {
         var _loc7_:String = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc4_:String = "";
         var _loc5_:String = "";
         var _loc6_:String = "";
         if(Boolean(param2) && param2.baseKey != "")
         {
            _loc9_ = BPLocale.getItem(param2.baseKey);
            if(FastMath.isNumeric(param2.replacement))
            {
               _loc7_ = TextFormatter.roundInteger(parseInt(param2.replacement));
            }
            else
            {
               _loc7_ = param2.replacement;
            }
            _loc4_ = _loc9_.replace(param2.wildcard,_loc7_).replace("%CURRENCY%",param2.currency);
         }
         if(Boolean(param3) && param3.baseKey != "")
         {
            _loc10_ = BPLocale.getItem(param3.baseKey);
            if(FastMath.isNumeric(param3.replacement))
            {
               _loc7_ = TextFormatter.roundInteger(parseInt(param3.replacement));
            }
            else
            {
               _loc7_ = param3.replacement;
            }
            _loc5_ = _loc10_.replace(param3.wildcard,_loc7_).replace("%CURRENCY%",param3.currency);
         }
         else if(param1 == KillScreenOptionTypeModule.OPTIONTYPE_AT_SECTOR_CONTROL_SPAWNPOINT)
         {
            _loc5_ = "\n" + BPLocale.getItem("desc_killscreen_option_available_countdown_spawnpoint");
         }
         else if(param1 == KillScreenOptionTypeModule.OPTIONTYPE_RAID_GATE_REPAIR)
         {
            _loc5_ = "\n" + BPLocale.getItem("desc_killscreen_option_available_countdown_hadesgate");
         }
         else if(param1 == KillScreenOptionTypeModule.OPTIONTYPE_TDM_REPAIR)
         {
            _loc5_ = "\n" + BPLocale.getItem("desc_killscreen_option_available_countdown_tdm");
         }
         else if(param1 == KillScreenOptionTypeModule.OPTIONTYPE_STRIKE_AND_EXIT)
         {
            _loc5_ = "\n" + BPLocale.getItem("desc_killscreen_option_available_countdown_sae");
         }
         if(param1 == KillScreenOptionTypeModule.OPTIONTYPE_AT_JUMPGATE_REPAIR || param1 == KillScreenOptionTypeModule.OPTIONTYPE_AT_DEATHLOCATION_REPAIR)
         {
            _loc6_ = BPLocale.getItem("ttip_killscreen_logout_1");
         }
         else if(param1 == KillScreenOptionTypeModule.OPTIONTYPE_AT_SECTOR_CONTROL_SPAWNPOINT)
         {
            _loc6_ = BPLocale.getItem("ttip_killscreen_logout_spawnpoint");
         }
         else if(param1 == KillScreenOptionTypeModule.OPTIONTYPE_RAID_GATE_REPAIR)
         {
            _loc6_ = BPLocale.getItem("ttip_killscreen_logout_hadesgate");
         }
         else if(param1 == KillScreenOptionTypeModule.OPTIONTYPE_TDM_REPAIR)
         {
            _loc6_ = BPLocale.getItem("ttip_killscreen_logout_tdm");
         }
         else if(param1 == KillScreenOptionTypeModule.OPTIONTYPE_STRIKE_AND_EXIT)
         {
            _loc6_ = BPLocale.getItem("ttip_killscreen_logout_sae");
         }
         else if(param1 == KillScreenOptionTypeModule.OPTIONTYPE_REFRACTION_ZONE_DEATH_LOCATION || param1 == KillScreenOptionTypeModule.OPTIONTYPE_REFRACTION_ZONE_FACTION_BASE)
         {
            _loc6_ = BPLocale.getItem("ttip_killscreen_logout_rzone");
         }
         var _loc8_:String = _loc4_ + " " + _loc5_ + "\n \n" + _loc6_;
         this.optionVOs[param1].detailText = _loc8_;
      }
      
      public function setTitle(param1:String) : void
      {
         var _loc2_:String = BPLocale.getItem("head_killscreen_you_have_been_destroyed");
         var _loc3_:String = _loc2_.replace("%SHIP%",param1);
         this.repairWindow.setTitle(_loc3_);
         this.repairWindow.setDescription(BPLocale.getItem("subhead_killscreen_repair_now"));
      }
      
      public function get visibleStatus() : Boolean
      {
         return this._showRepairWindow;
      }
      
      public function setRepairButtonLabel(param1:String, param2:int, param3:String = "") : void
      {
         var _loc4_:String = BPLocale.getItem(param1);
         var _loc5_:String = _loc4_.replace("%COUNT%",TextFormatter.roundInteger(param2)).replace("%CURRENCY%",param3);
         var _loc6_:String = this.cutSingleLine(_loc5_,37);
         this.repairWindow.setRepairButtonText(_loc6_,_loc5_);
      }
      
      public function setDestructionType(param1:int) : void
      {
         var _loc4_:Boolean = false;
         var _loc2_:String = BPLocale.getItem(destructionTypes[param1]);
         var _loc3_:String = "";
         var _loc5_:Array = _loc2_.split("<b>");
         var _loc6_:Array = (_loc5_[1] as String).split("</b>");
         var _loc7_:String = "";
         _loc7_ = _loc5_[0] + _loc6_[1];
         var _loc8_:String = "";
         _loc8_ = _loc6_[0];
         if(param1 == PLAYER || param1 == NPC)
         {
            _loc3_ = _loc8_.replace("%VALUE%",this._killerName);
            if(param1 == PLAYER)
            {
               _loc4_ = true;
            }
            else
            {
               _loc4_ = false;
            }
         }
         else
         {
            _loc3_ = _loc8_;
            _loc4_ = false;
         }
         this.repairWindow.setDestructionText(_loc7_,_loc3_,_loc4_);
      }
      
      public function updateTimer(param1:Number) : void
      {
         var _loc2_:KillscreenOptionVO = null;
         var _loc3_:int = 0;
         this._tpf += param1;
         if(this._tpf > 1000)
         {
            _loc3_ = 0;
            while(_loc3_ < this.optionVOs.length)
            {
               _loc2_ = this.optionVOs[_loc3_];
               if(_loc2_.cooldown > 0)
               {
                  --_loc2_.cooldown;
                  if(Boolean(this.repairWindow) && Boolean(_loc3_ == this.selectedOption) && (this.selectedOption == KillScreenOptionTypeModule.OPTIONTYPE_AT_SECTOR_CONTROL_SPAWNPOINT || this.selectedOption == KillScreenOptionTypeModule.OPTIONTYPE_RAID_GATE_REPAIR || this.selectedOption == KillScreenOptionTypeModule.OPTIONTYPE_TDM_REPAIR || this.selectedOption == KillScreenOptionTypeModule.OPTIONTYPE_WAR_GAME_REPAIR || this.selectedOption == KillScreenOptionTypeModule.OPTIONTYPE_STRIKE_AND_EXIT))
                  {
                     this.repairWindow.setDetailText(_loc2_.detailText.replace(/%COUNTDOWN%/,"<font color=\'#FF0000\' size=\'+6\'>" + _loc2_.cooldown + "</font>"));
                     if(this.selectedOption == KillScreenOptionTypeModule.OPTIONTYPE_STRIKE_AND_EXIT)
                     {
                        this.cooldown = _loc2_.cooldown;
                        if(_loc2_.cooldown <= 0)
                        {
                           this.repairWindow.enableRepairButton();
                        }
                        else
                        {
                           this.repairWindow.disableRepairButton();
                        }
                     }
                  }
               }
               _loc3_++;
            }
            this._tpf = 0;
         }
      }
      
      private function cleanup() : void
      {
         if(this._main.screenManager.map)
         {
            this._main.screenManager.map.cleanup();
         }
         this.clearOptions();
         this.repairWindow.cleanup();
      }
      
      public function setShowRepairWindow(param1:Boolean) : void
      {
         this._showRepairWindow = param1;
      }
   }
}

