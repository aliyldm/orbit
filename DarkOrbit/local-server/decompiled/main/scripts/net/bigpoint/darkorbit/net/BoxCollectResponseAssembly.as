package net.bigpoint.darkorbit.net
{
   import com.bigpoint.utils.TextFormatter;
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.catalog.SysItem;
   import net.bigpoint.darkorbit.com.module.MessageKeyListWildcardModule;
   import net.bigpoint.darkorbit.com.module.MessageWildcardReplacementModule;
   import net.bigpoint.darkorbit.com.module.OreCountModule;
   import net.bigpoint.darkorbit.com.module.ReplacementTypeModule;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.impl.CollectorBeamEffect;
   import net.bigpoint.darkorbit.map.model.env.collectable.Ore;
   import net.bigpoint.darkorbit.map.model.env.mine.MineCommon;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.utils.TextUtils;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.MessageCommandParams;
   import net.bigpoint.darkorbit.mvc.gui.messages.model.LogMessageProfileVOFactory;
   import net.bigpoint.darkorbit.utils.BPLocaleUtils;
   
   public class BoxCollectResponseAssembly extends BaseAssembly
   {
      
      private static var _instance:BoxCollectResponseAssembly;
      
      private var param1:String;
      
      private var param2:String;
      
      private var delegateDict:Dictionary;
      
      private var main:Main;
      
      public function BoxCollectResponseAssembly(param1:Function)
      {
         super();
         if(param1 !== hidden)
         {
            throw new Error("SettingsAssembly is a Singleton and can only be accessed through BoxCollectResponseAssembly.getInstance()");
         }
         this.main = _main;
         this.initDelegateDict();
      }
      
      public static function getInstance() : BoxCollectResponseAssembly
      {
         if(_instance == null)
         {
            _instance = new BoxCollectResponseAssembly(hidden);
         }
         return _instance;
      }
      
      private static function hidden() : void
      {
      }
      
      public static function log(param1:String, param2:String = "LO") : void
      {
         GameFacade.getInstance().sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams().setMessage(param1));
      }
      
      private function initDelegateDict() : void
      {
         this.delegateDict = new Dictionary();
         this.delegateDict[ServerCommands.BOX_CONTENT_ORE] = this.assembleOre;
         this.delegateDict[ServerCommands.BOX_CONTENT_CREDITS] = this.assembleCredits;
         this.delegateDict[ServerCommands.BOX_CONTENT_URIDIUM] = this.assembleUridium;
         this.delegateDict[ServerCommands.BOX_CONTENT_EVENT_PROGRESS_POINTS] = this.assembleEventProgressPoints;
         this.delegateDict[ServerCommands.BOX_CONTENT_EXPERIENCE_POINTS] = this.assembleExperiencePoints;
         this.delegateDict[ServerCommands.BOX_CONTENT_HONOR_POINTS] = this.assembleHonorPoints;
         this.delegateDict[ServerCommands.BOX_CONTENT_HITPOINTS] = this.assembleHitPoints;
         this.delegateDict[ServerCommands.BOX_CONTENT_FIREWORK] = this.assembleFireworks;
         this.delegateDict[ServerCommands.BOX_CONTENT_ROCKETS] = this.assembleRockets;
         this.delegateDict[ServerCommands.BOX_CONTENT_SLU] = this.assembleSlu;
         this.delegateDict[ServerCommands.BOX_CONTENT_LASER_BATTERIES] = this.assembleLaserBatteries;
         this.delegateDict[ServerCommands.BOX_CONTENT_BANKING_MULTIPLIKATOR] = this.assembleBankingMultiplier;
         this.delegateDict[ServerCommands.BOX_CONTENT_DEDUCTION_HITPOINTS] = this.assembleHitpointDeduct;
         this.delegateDict[ServerCommands.BOX_CONTENT_EXTRA_ENERGY] = this.assembleExtraEnergy;
         this.delegateDict[ServerCommands.BOX_CONTENT_JUMP_VOUCHERS] = this.assembleJumpVoucherLoot;
         this.delegateDict[ServerCommands.BOX_CONTENT_MINE] = this.assembleItemLoot;
         this.delegateDict[ServerCommands.BOX_CONTENT_PET_FUEL] = this.assemblePetFuelLoot;
         this.delegateDict[ServerCommands.ITEM_LOOT] = this.assembleItemLoot;
         this.delegateDict[ServerCommands.BOX_TOO_BIG] = this.assembleBoxTooBig;
         this.delegateDict[ServerCommands.BOX_ALREADY_COLLECTED] = this.assembleAlreadyCollectedBox;
         this.delegateDict[ServerCommands.MINE_EXPLODE] = this.assembleMineExplode;
         this.delegateDict[ServerCommands.AVAILABLE_SHIPS_ON_MAP] = this.assembleAvailableShipsOnMap;
         this.delegateDict[ServerCommands.ROCKETLAUNCHER] = this.assembleRocketLauncher;
         this.delegateDict[ServerCommands.LOGFILE] = this.assembleLogFile;
         this.delegateDict[ServerCommands.DISCOUNT_MESSAGE] = this.assembleDiscountMessage;
         this.delegateDict[ServerCommands.SET_ITEM_LOOTING_ACTIVE] = this.assembleItemLootActive;
         this.delegateDict[ServerCommands.SET_ITEM_LOOTING_CANCELLED] = this.assembleItemLootCancelling;
         this.delegateDict[ServerCommands.NEWBIE_BOOSTER] = this.assembleBoosterMessage;
         this.delegateDict[ServerCommands.QUANTUM_FLUID_CORE] = this.assembleQuantumFluidCoreMessage;
         this.delegateDict[ServerCommands.VOYAGERS_SPL] = this.assembleSpl;
      }
      
      private function assembleQuantumFluidCoreMessage(param1:Array) : void
      {
         var _loc4_:ItemVO = null;
         var _loc2_:String = "";
         var _loc3_:String = param1[2];
         switch(_loc3_)
         {
            case ServerCommands.QFC_FORGED:
               _loc4_ = ItemDataProviderHelper.getItem(param1[4]);
               _loc2_ = BPLocale.getItem("log_message_core_forge_finished").replace(/%NAME%/,_loc4_.fullname);
               _loc2_ = _loc2_.replace(/%LEVEL%/,param1[5]);
               break;
            case ServerCommands.QFC_RECYCLED:
               _loc4_ = ItemDataProviderHelper.getItem(param1[4]);
               _loc2_ = BPLocale.getItem("log_message_core_recycle_finished").replace(/%NAME%/,_loc4_.fullname);
               _loc2_ = _loc2_.replace(/%COUNT%/,param1[5]);
         }
         GameFacade.getInstance().sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams().setMessage(_loc2_).setType(_loc3_));
      }
      
      private function assembleBoosterMessage(param1:Array) : void
      {
         var _loc5_:String = null;
         var _loc2_:String = param1[2];
         var _loc3_:String = param1[4];
         var _loc4_:int = int(param1[5]);
         switch(_loc3_)
         {
            case ServerCommands.BOOSTER_QUEST_REWARD:
               _loc5_ = "msg_info_booster_quest_reward_higher_loot_level";
               break;
            case ServerCommands.BOOSTER_BONUS_BOX:
               _loc5_ = "msg_info_booster_bonus_box_higher_box_content_level";
         }
         if(_loc4_ > 0)
         {
            GameFacade.getInstance().sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams().setMessage(BPLocale.getItem(_loc5_).replace(/%AMOUNT%/,_loc4_)).setType(_loc2_));
         }
      }
      
      private function assembleDiscountMessage(param1:Array) : void
      {
         var _loc5_:String = null;
         var _loc2_:String = param1[2];
         var _loc3_:String = param1[4];
         var _loc4_:int = int(param1[5]);
         switch(_loc3_)
         {
            case ServerCommands.LOOT_DISCOUNT:
               if(_loc4_ > 0)
               {
                  _loc5_ = "msg_warning_less_box_content_level";
               }
               else
               {
                  _loc5_ = "msg_warning_no_box_content_level";
               }
               break;
            case ServerCommands.REWARD_DISCOUNT:
               if(_loc4_ > 0)
               {
                  _loc5_ = "msg_warning_less_loot_level";
               }
               else
               {
                  _loc5_ = "msg_warning_no_loot_level";
               }
         }
         var _loc6_:String = BPLocale.getItem(_loc5_).replace(/%AMOUNT%/,_loc4_);
         GameFacade.getInstance().sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams().setMessage(_loc6_).setType(_loc2_));
      }
      
      private function assembleLogFile(param1:Array) : void
      {
         var _loc4_:String = null;
         var _loc2_:int = int(param1[4]);
         var _loc3_:String = param1[2];
         if(_loc2_ == 1)
         {
            _loc4_ = BPLocale.getItem("log_msg_gather_log-file_s");
         }
         else
         {
            _loc4_ = BPLocale.getItem("log_msg_gather_log-file_p").replace(/%COUNT%/,_loc2_);
         }
         log(_loc4_,_loc3_);
      }
      
      private function assembleRocketLauncher(param1:Array) : void
      {
         var _loc5_:String = null;
         var _loc2_:String = TextUtils.getTranslationByType(param1[4],ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_CODE);
         var _loc3_:int = int(param1[5]);
         var _loc4_:String = param1[2];
         _loc5_ = BPLocale.getItem("getbonusrok").replace(/%!/,TextFormatter.roundInteger(_loc3_)).replace(/%2!/,_loc2_);
         log(_loc5_,_loc4_);
      }
      
      private function assembleMineLoot(param1:Array) : void
      {
         var _loc6_:String = null;
         var _loc2_:String = TextUtils.getTranslationByType(param1[4],ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_CODE);
         var _loc3_:int = int(param1[5]);
         var _loc4_:String = "log_msg_gather_mine_";
         var _loc5_:String = param1[2];
         if(_loc3_ == 1)
         {
            _loc6_ = BPLocale.getItem(_loc4_ + "s");
         }
         else
         {
            _loc6_ = BPLocale.getItem(_loc4_ + "p").replace(/%COUNT%/,TextFormatter.roundInteger(_loc3_));
         }
         _loc6_ = _loc6_.replace(/%TYPE%/,_loc2_);
         log(_loc6_,_loc5_);
      }
      
      private function assembleAvailableShipsOnMap(param1:Array) : void
      {
         var _loc2_:String = param1[2];
         log(BPLocale.getItem("msg_jackpot_players_left").replace(/%COUNT%/,param1[4]),_loc2_);
      }
      
      private function assembleMineExplode(param1:Array) : void
      {
         var _loc2_:String = param1[4];
         var _loc3_:MineCommon = map.getEntityByHash(_loc2_) as MineCommon;
         if(_loc3_)
         {
            _loc3_.bang();
            map.removeEntity(_loc3_);
         }
      }
      
      private function assembleAlreadyCollectedBox(param1:Array) : void
      {
         var _loc2_:String = param1[2];
         var _loc3_:Map = this.main.screenManager.map;
         if(_loc3_ != null)
         {
         }
         log(BPLocale.getItem("boxdisabled"),_loc2_);
      }
      
      private function assembleBoxTooBig(param1:Array) : void
      {
         var _loc2_:String = param1[2];
         var _loc3_:Map = this.main.screenManager.map;
         if(_loc3_ != null)
         {
         }
         log(BPLocale.getItem("boxtoobig"),_loc2_);
      }
      
      private function assembleExtraEnergy(param1:Array) : void
      {
         var _loc5_:String = null;
         var _loc2_:int = int(param1[4]);
         var _loc3_:String = param1[2];
         var _loc4_:String = "log_msg_gather_extra-energy_";
         if(_loc2_ > 1)
         {
            _loc5_ = BPLocale.getItem(_loc4_ + "p").replace(/%COUNT%/,_loc2_);
         }
         else
         {
            _loc5_ = BPLocale.getItem(_loc4_ + "s");
         }
         log(_loc5_,_loc3_);
      }
      
      private function assembleJumpVoucherLoot(param1:Array) : void
      {
         var _loc5_:String = null;
         var _loc2_:int = int(param1[4]);
         var _loc3_:String = param1[2];
         var _loc4_:String = "log_msg_gather_jump-voucher_";
         if(_loc2_ == 1)
         {
            _loc5_ = BPLocale.getItem(_loc4_ + "s");
         }
         else
         {
            _loc5_ = BPLocale.getItem(_loc4_ + "p").replace(/%COUNT%/,_loc2_);
         }
         log(_loc5_,_loc3_);
      }
      
      private function assemblePetFuelLoot(param1:Array) : void
      {
         var _loc5_:String = null;
         var _loc2_:int = int(param1[4]);
         var _loc3_:String = param1[2];
         var _loc4_:String = "log_msg_gather_pet-fuel_";
         if(_loc2_ == 1)
         {
            _loc5_ = BPLocale.getItem(_loc4_ + "s");
         }
         else
         {
            _loc5_ = BPLocale.getItem(_loc4_ + "p").replace(/%COUNT%/,_loc2_);
         }
         log(_loc5_,_loc3_);
      }
      
      private function assembleItemLoot(param1:Array) : void
      {
         var _loc7_:String = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc2_:String = param1[4];
         var _loc3_:int = int(param1[5]);
         var _loc4_:String = param1[2];
         var _loc5_:String = "log_msg_gather_";
         var _loc6_:SysItem = InGameCatalog.getInstance().sysItems[_loc2_] as SysItem;
         var _loc8_:String = TextUtils.getTranslationByType(_loc2_,ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_FULLNAME);
         if(_loc6_ != null)
         {
            if(_loc3_ == 1)
            {
               _loc9_ = _loc5_ + _loc6_.category + "_s";
               if(!BPLocaleUtils.hasTranslation(_loc9_))
               {
                  _loc9_ = _loc5_ + "ore_s";
               }
               _loc7_ = BPLocale.getItem(_loc9_).replace(/%TYPE%/,_loc8_);
            }
            else
            {
               _loc10_ = _loc5_ + _loc6_.category + "_p";
               if(!BPLocaleUtils.hasTranslation(_loc10_))
               {
                  _loc10_ = _loc5_ + "ore_p";
               }
               _loc7_ = BPLocale.getItem(_loc10_).replace(/%TYPE%/,_loc8_).replace(/%COUNT%/,TextFormatter.roundInteger(_loc3_));
            }
            log(_loc7_,_loc4_);
         }
         else
         {
            if(_loc3_ == 1)
            {
               _loc7_ = BPLocale.getItem(_loc5_ + "ore_s").replace(/%TYPE%/,_loc8_);
            }
            else
            {
               _loc7_ = BPLocale.getItem(_loc5_ + "ore_p").replace(/%TYPE%/,_loc8_).replace(/%COUNT%/,TextFormatter.roundInteger(_loc3_));
            }
            log(_loc7_,_loc4_);
         }
      }
      
      private function assembleItemLootActive(param1:Array) : void
      {
         var _loc2_:int = int(param1[4]);
         var _loc3_:Ship = this.main.screenManager.map.hero;
         ScreenManager.getInstance().map.effects.addEffect(new CollectorBeamEffect(_loc3_,_loc2_,true));
         var _loc4_:String = BPLocale.getItem("msg_loot_harvest_init");
         log(_loc4_);
      }
      
      private function assembleItemLootCancelling(param1:Array) : void
      {
         var _loc2_:Ship = this.main.screenManager.map.hero;
         ScreenManager.getInstance().map.effects.removeEffectFromMapObject(_loc2_.id,EffectIDList.COLLECTOR_BEAM);
         var _loc3_:String = BPLocale.getItem("msg_loot_error_generic");
         log(_loc3_);
      }
      
      private function assembleHitpointDeduct(param1:Array) : void
      {
         var _loc2_:String = param1[2];
         var _loc3_:int = int(param1[4]);
         log(BPLocale.getItem("minushp").replace(this.param1,_loc3_),_loc2_);
      }
      
      private function assembleBankingMultiplier(param1:Array) : void
      {
         var _loc2_:String = param1[2];
         var _loc3_:int = int(param1[4]);
         log(BPLocale.getItem("banking_multiplier_active").replace(this.param1,_loc3_),_loc2_);
      }
      
      private function assembleLaserBatteries(param1:Array) : void
      {
         var _loc2_:String = param1[2];
         var _loc3_:String = TextUtils.getTranslationByType(param1[4],ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_CODE);
         var _loc4_:int = int(param1[5]);
         log(BPLocale.getItem("getbonuslas").replace(this.param1,TextFormatter.round(_loc4_)).replace(this.param2,_loc3_),_loc2_);
      }
      
      private function assembleRockets(param1:Array) : void
      {
         var _loc2_:String = param1[2];
         var _loc3_:String = TextUtils.getTranslationByType(param1[4],ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_CODE);
         var _loc4_:int = int(param1[5]);
         log(BPLocale.getItem("getbonusrok").replace(this.param1,_loc4_).replace(this.param2,_loc3_),_loc2_);
      }
      
      private function assembleSlu(param1:Array) : void
      {
         var _loc2_:String = param1[2];
         var _loc3_:String = TextUtils.getTranslationByType(param1[4],ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_CODE);
         var _loc4_:int = int(param1[5]);
         log(BPLocale.getItem("getbonusslug").replace(this.param1,_loc4_).replace(this.param2,_loc3_),_loc2_);
      }
      
      private function assembleSpl(param1:Array) : void
      {
         var _loc2_:String = param1[2];
         var _loc3_:String = TextUtils.getTranslationByType(param1[4],ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_CODE);
         var _loc4_:int = int(param1[5]);
         log(BPLocale.getItem("getbonusspool").replace(this.param1,_loc4_).replace(this.param2,_loc3_),_loc2_);
      }
      
      private function assembleFireworks(param1:Array) : void
      {
         var _loc2_:String = param1[2];
         var _loc3_:String = TextUtils.getTranslationByType(param1[4],ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_CODE);
         var _loc4_:int = int(param1[5]);
         log(BPLocale.getItem("log_collected_firework").replace(this.param1,_loc4_).replace(this.param2,_loc3_),_loc2_);
      }
      
      private function assembleHitPoints(param1:Array) : void
      {
         var _loc2_:String = param1[2];
         var _loc3_:Number = parseFloat(param1[4]);
         log(BPLocale.getItem("gethp").replace(this.param1,_loc3_),_loc2_);
      }
      
      private function assembleHonorPoints(param1:Array) : void
      {
         var _loc2_:String = param1[2];
         var _loc3_:Number = Number(param1[4]);
         log(BPLocale.getItem("gatherep").replace(this.param1,TextFormatter.round(_loc3_)),_loc2_);
         Hero.honorPoints = param1[5];
         this.updateInfoField(GuiConstants.USER_WINDOW,SimpleContainer.CONTAINER_CLASS_HERO_INFO_2,SimpleElement.TYPE_HONOR);
      }
      
      private function assembleExperiencePoints(param1:Array) : void
      {
         var _loc2_:String = param1[2];
         var _loc3_:Number = parseFloat(param1[4]);
         log(BPLocale.getItem("getexp").replace(this.param1,TextFormatter.roundInteger(_loc3_)),_loc2_);
         Hero.experiencePoints = parseFloat(param1[5]);
         this.updateInfoField(GuiConstants.USER_WINDOW,SimpleContainer.CONTAINER_CLASS_HERO_INFO_2,SimpleElement.TYPE_EXPERIENCE);
         Hero.level = int(param1[6]);
         this.updateInfoField(GuiConstants.USER_WINDOW,SimpleContainer.CONTAINER_CLASS_HERO_INFO_2,SimpleElement.TYPE_LEVEL);
      }
      
      private function assembleUridium(param1:Array) : void
      {
         var _loc2_:String = param1[2];
         var _loc3_:Number = parseFloat(param1[4]);
         if(_loc3_ > 0)
         {
            log(BPLocale.getItem("geturidium").replace(this.param1,TextFormatter.roundInteger(_loc3_)),_loc2_);
         }
         else
         {
            log(TextUtils.translateMessageKeyListWildcardModule(new MessageKeyListWildcardModule(0,"log_message_item_deducted",new ReplacementTypeModule(ReplacementTypeModule.REPLACEMENTTYPE_LOCALIZED),new <MessageWildcardReplacementModule>[new MessageWildcardReplacementModule("%lootId%","currency_uridium",new ReplacementTypeModule(ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_FULLNAME)),new MessageWildcardReplacementModule("%count%",TextFormatter.roundInteger(Math.abs(_loc3_)),new ReplacementTypeModule(ReplacementTypeModule.REPLACEMENTTYPE_PLAIN))]),true));
         }
         Hero.uridiumAmount = parseFloat(param1[5]);
         this.updateInfoField(GuiConstants.USER_WINDOW,SimpleContainer.CONTAINER_CLASS_HERO_INFO_3,SimpleElement.TYPE_URIDIUM);
      }
      
      private function assembleCredits(param1:Array) : void
      {
         var _loc2_:String = param1[2];
         var _loc3_:Number = parseFloat(param1[4]);
         if(_loc3_ > 0)
         {
            log(BPLocale.getItem("getcredits").replace(this.param1,TextFormatter.roundInteger(_loc3_)),_loc2_);
         }
         else
         {
            log(TextUtils.translateMessageKeyListWildcardModule(new MessageKeyListWildcardModule(0,"log_message_item_deducted",new ReplacementTypeModule(ReplacementTypeModule.REPLACEMENTTYPE_LOCALIZED),new <MessageWildcardReplacementModule>[new MessageWildcardReplacementModule("%lootId%","currency_credits",new ReplacementTypeModule(ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_FULLNAME)),new MessageWildcardReplacementModule("%count%",TextFormatter.roundInteger(Math.abs(_loc3_)),new ReplacementTypeModule(ReplacementTypeModule.REPLACEMENTTYPE_PLAIN))]),true));
         }
         Hero.creditsAmount = Number(param1[5]);
         this.updateInfoField(GuiConstants.USER_WINDOW,SimpleContainer.CONTAINER_CLASS_HERO_INFO_3,SimpleElement.TYPE_CREDITS);
      }
      
      private function assembleEventProgressPoints(param1:Array) : void
      {
         var _loc2_:String = param1[2];
         var _loc3_:Number = parseFloat(param1[4]);
         log(BPLocale.getItem("geteventprogresspoints").replace(this.param1,TextFormatter.roundInteger(_loc3_)),_loc2_);
      }
      
      private function assembleJackpot(param1:Array) : void
      {
         var _loc2_:String = param1[2];
         var _loc3_:Number = parseFloat(param1[4]);
         log(BPLocale.getItem("getjackpot").replace(this.param1,TextFormatter.round(_loc3_,2)),_loc2_);
         Hero.jackpotAmount = parseFloat(param1[5]);
         this.updateInfoField(GuiConstants.USER_WINDOW,SimpleContainer.CONTAINER_CLASS_HERO_INFO_3,SimpleElement.TYPE_JACKPOT);
      }
      
      public function assembleOre(param1:uint, param2:Vector.<OreCountModule>) : void
      {
         var _loc4_:OreCountModule = null;
         var _loc5_:int = 0;
         var _loc3_:String = BPLocale.getItem("farmresult");
         for each(_loc4_ in param2)
         {
            _loc5_ = _loc4_.count;
            if(_loc5_ > 0)
            {
               _loc3_ += "\n" + _loc5_ + " " + BPLocale.getItem(Ore.loot_ore_keys[_loc4_.oreType.typeValue]);
            }
         }
         if(_loc3_.length != BPLocale.getItem("farmresult").length)
         {
            log(_loc3_,this.getProfileTypeFromUint(param1));
         }
      }
      
      private function getProfileTypeFromUint(param1:uint) : String
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case 0:
               _loc2_ = "ST";
               break;
            case 1:
               _loc2_ = "HP";
         }
         return _loc2_;
      }
      
      private function updateInfoField(param1:String, param2:int, param3:int) : void
      {
         this.main.getGuiManager().updateInfoField(param1,param2,param3);
      }
      
      public function assembleBoxCollectResponse(param1:Array) : void
      {
         var _loc3_:String = null;
         param1 = this.formatLegacy(param1);
         var _loc2_:String = param1[3];
         if(this.delegateDict[_loc2_] != null)
         {
            this.delegateDict[_loc2_](param1);
         }
         else
         {
            _loc3_ = BPLocale.getItem(_loc2_);
            if(_loc3_.length > 0)
            {
               log(_loc3_,param1[2]);
            }
         }
      }
      
      private function formatLegacy(param1:Array) : Array
      {
         if(param1[1] == ServerCommands.BOX_COLLECT_RESPONSE)
         {
            param1[0] = ServerCommands.LOG_MESSAGE;
            param1[1] = LogMessageProfileVOFactory.STANDARD_MESSAGE;
            param1.unshift("0");
         }
         return param1;
      }
      
      public function setParams(param1:String, param2:String) : void
      {
         this.param1 = param1;
         this.param2 = param2;
      }
   }
}

