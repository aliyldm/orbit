package net.bigpoint.darkorbit.net
{
   import mx.utils.StringUtil;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.com.module.EggTriggerRequest;
   import net.bigpoint.darkorbit.com.module.EventActivationStateCommand;
   import net.bigpoint.darkorbit.com.module.MinimapStrategyModule;
   import net.bigpoint.darkorbit.com.module.OreCountModule;
   import net.bigpoint.darkorbit.com.module.OreTypeModule;
   import net.bigpoint.darkorbit.com.module.ShipCreateCommand;
   import net.bigpoint.darkorbit.com.module.ShipInitializationCommand;
   import net.bigpoint.darkorbit.com.module.VisualModifierCommand;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   import net.bigpoint.darkorbit.gui.windows.components.Killscreen;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.env.rabbit.Rabbit;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.pet.Pet;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.chatclient.DOChatClientNotifications;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.events.control.notifications.EventNotifications;
   import net.bigpoint.darkorbit.mvc.events.model.EventProxy;
   import net.bigpoint.darkorbit.mvc.events.model.eventVOs.MapReplacementEvent;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.MessageCommandParams;
   import net.bigpoint.darkorbit.mvc.gui.messages.model.MessageIDs;
   import net.bigpoint.darkorbit.mvc.gui.messages.view.GlobalNotificationsMediator;
   import net.bigpoint.darkorbit.mvc.gui.messages.view.LogWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.messages.view.MessagesMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.cli.view.CLIWindowMediator;
   import net.bigpoint.darkorbit.mvc.map.MapNotification;
   import net.bigpoint.darkorbit.mvc.mapElements.assets.MapAssetNotification;
   import net.bigpoint.darkorbit.mvc.sectorControl.SectorControlNotifications;
   import net.bigpoint.darkorbit.net.netty.handlers.VisualModifierHandler;
   import net.bigpoint.darkorbit.pattern.OrePattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.settings.CrowdedCombatPreset;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class ShipAssembly
   {
      
      private var main:Main;
      
      private var _facade:GameFacade;
      
      private var _shipsBuffer:Vector.<ShipCreateCommand> = new Vector.<ShipCreateCommand>();
      
      private var pacManEasterEggFoundThisSession:Boolean = false;
      
      public function ShipAssembly()
      {
         super();
      }
      
      public function setMain(param1:Main) : void
      {
         this.main = param1;
         this._facade = GameFacade.getInstance();
      }
      
      public function assembleShipDestroy(param1:int, param2:int) : void
      {
         if(param1 == Hero.userID)
         {
            Hero.isKilled = true;
            this._facade.sendNotification(HeroNotifications.HERO_DIED);
            GuiManager.instance.createEndSequence();
         }
         if(this.map != null)
         {
            this.map.getShipManager().removeShip(param1,true);
         }
      }
      
      private function get map() : Map
      {
         return this.main.screenManager.map;
      }
      
      public function assembleShipRemoval(param1:int) : void
      {
         if(this.map != null)
         {
            this.map.getShipManager().removeShip(param1,false);
         }
      }
      
      public function assembleShipCreation(param1:ShipCreateCommand) : void
      {
         var _loc6_:int = 0;
         var _loc7_:VisualModifierCommand = null;
         if(Killscreen.getInstance().visibleStatus)
         {
            return;
         }
         if(!Settings.createOpponents)
         {
            return;
         }
         if(param1.userId == Hero.userID)
         {
            return;
         }
         if(this.map == null)
         {
            this._shipsBuffer.push(param1);
            return;
         }
         var _loc2_:String = param1.typeId;
         var _loc3_:Vector.<VisualModifierCommand> = param1.modifier;
         var _loc4_:int = int(_loc3_.length);
         if(_loc3_ != null)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc4_)
            {
               _loc7_ = _loc3_[_loc6_];
               if(_loc7_.modifier == VisualModifierCommand.VISUALMODIFIER_CHANGE_SHIP_DESIGN)
               {
                  _loc2_ = _loc7_.additionalAttribute;
               }
               _loc6_++;
            }
         }
         if(_loc2_ == Rabbit.RABBIT_TYPE)
         {
            this.map.addRabbit(new Rabbit(param1.userId,param1.x,param1.y));
            this.playVisualModifiers(_loc3_);
            return;
         }
         var _loc5_:Ship = this.map.getShipManager().createShip(_loc2_,param1.userId,param1.x,param1.y,1,param1.userName,param1.clanTag,this.validateFactionID(param1.factionId),param1.clanId,param1.clanDiplomacy.type,param1.dailyRank,param1.warnBox,param1.minimapStrategyModule.minimapStrategy,param1.galaxyGatesDone,param1.npc,param1.motherShipId,param1.positionIndex,param1.specialNpcType);
         if(_loc5_ != null)
         {
            _loc5_.laserExpansionStage.value = param1.expansionStage;
            _loc5_.cloaked.value = param1.cloaked;
            this.playVisualModifiers(_loc3_);
            _loc5_.hasDesignSet.value = param1.designSet != null;
         }
         this.findPetForShipOnMap(_loc5_);
      }
      
      private function playVisualModifiers(param1:Vector.<VisualModifierCommand>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:VisualModifierCommand = null;
         if(param1 != null)
         {
            _loc2_ = int(param1.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = param1[_loc3_];
               VisualModifierHandler.run(_loc4_);
               _loc3_++;
            }
         }
      }
      
      private function findPetForShipOnMap(param1:Ship) : void
      {
         var _loc2_:Vector.<MapEntity> = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(!param1.isNPC)
         {
            _loc2_ = this.map.getEntityByType(Pet);
            _loc3_ = int(_loc2_.length);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               if((_loc2_[_loc4_] as Pet).ownerID == param1.id)
               {
                  param1.pet = _loc2_[_loc4_] as Pet;
                  return;
               }
               _loc4_++;
            }
         }
      }
      
      public function validateFactionID(param1:int) : int
      {
         if(param1 > 4)
         {
            param1 = 0;
         }
         return param1;
      }
      
      public function assembleHeroInit(param1:ShipInitializationCommand) : void
      {
         var _loc29_:VisualModifierCommand = null;
         var _loc30_:MessagesMediator = null;
         var _loc2_:GuiManager = this.main.getGuiManager();
         _loc2_.addGUI();
         var _loc3_:int = param1.userId;
         Hero.userID = _loc3_;
         var _loc4_:String = param1.userName;
         var _loc5_:String = param1.typeId;
         if(param1.modifier != null)
         {
            for each(_loc29_ in param1.modifier)
            {
               if(_loc29_.modifier == VisualModifierCommand.VISUALMODIFIER_CHANGE_SHIP_DESIGN)
               {
                  _loc5_ = _loc29_.additionalAttribute;
               }
            }
         }
         var _loc6_:Number = param1.speed * 0.97;
         var _loc7_:int = param1.shield;
         var _loc8_:int = param1.shieldMax;
         var _loc9_:int = param1.hitPoints;
         var _loc10_:int = param1.hitMax;
         var _loc11_:int = param1.nanoHull;
         var _loc12_:int = param1.maxNanoHull;
         var _loc13_:int = param1.cargoSpace;
         var _loc14_:int = param1.cargoSpaceMax;
         var _loc15_:int = param1.x;
         var _loc16_:int = param1.y;
         var _loc17_:int = param1.mapId;
         var _loc18_:int = param1.factionId;
         _loc18_ = this.validateFactionID(_loc18_);
         var _loc19_:int = param1.clanId;
         var _loc20_:Boolean = param1.refreshMap;
         var _loc21_:int = param1.captainEnergy;
         var _loc22_:int = param1.maxCaptainEnergy;
         Hero.clanID = _loc19_;
         Hero.premium.value = param1.premium;
         Hero.experiencePoints = param1.ep;
         Hero.honorPoints = param1.honourPoints;
         Hero.level = param1.level;
         Hero.creditsAmount = param1.credits;
         Hero.uridiumAmount = param1.uridium;
         Hero.jackpotAmount = param1.jackpot;
         var _loc23_:int = param1.dailyRank;
         var _loc24_:String = param1.clanTag;
         var _loc25_:int = param1.galaxyGatesDone;
         Hero.shipType = _loc5_;
         var _loc26_:Boolean = param1.cloaked;
         Hero.isKilled = false;
         if(_loc23_ == 6000)
         {
            Hero.admin = true;
         }
         else
         {
            Hero.admin = false;
         }
         Hero.username = _loc4_;
         if(Boolean(Hero.username) && Hero.username != _loc4_)
         {
            this._facade.forwardNotification(DOChatClientNotifications.RECONNECT);
            this._facade.forwardNotification(HeroNotifications.UPDATE_USERNAME,Hero.username);
         }
         if(StringUtil.trim(_loc24_).length > 0)
         {
            Hero.clanTag = _loc24_;
         }
         Hero.calculateGearScore;
         Hero.faction = _loc18_;
         if(Settings.lastMapID != -1 && Settings.lastMapID != _loc17_)
         {
            AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_PORTAL_DONE);
         }
         if(_loc20_)
         {
            if(Settings.lastMapID != _loc17_)
            {
               this.createMap(_loc17_);
               Settings.lastMapID = _loc17_;
            }
            else
            {
               ScreenManager.getInstance().map = this.map;
               GameFacade.getInstance().forwardNotification(MapAssetNotification.CLEANUP);
               this.main.getConnectionManager().isMapLoaded = true;
            }
            GameFacade.getInstance().forwardNotification(SectorControlNotifications.RESET,GuiConstants.SECTOR_CONTROL_WINDOW);
         }
         var _loc27_:Ship = this.main.screenManager.map.getShipManager().createShip(_loc5_,_loc3_,_loc15_,_loc16_,_loc6_,_loc4_,_loc24_,_loc18_,_loc19_,-1,_loc23_,false,MinimapStrategyModule.MINIMAPSTRATEGY_DEFAULT,_loc25_,false);
         if(_loc27_)
         {
            _loc27_.laserExpansionStage.value = param1.expansionStage;
         }
         if(_loc27_ == null)
         {
            return;
         }
         _loc27_.hp.hp.value = _loc9_;
         _loc27_.hp.maxHP.value = _loc10_;
         _loc27_.hp.nanohullHP.value = _loc11_;
         _loc27_.hp.nanohullMaxHP.value = _loc12_;
         Hero.cargo.value = _loc14_ - _loc13_;
         Hero.maxCargo.value = _loc14_;
         Hero.captainEnergy.value = _loc21_;
         Hero.maxCaptainEnergy.value = _loc22_;
         _loc27_.hp.shield.value = _loc7_;
         _loc27_.hp.maxShield.value = _loc8_;
         _loc27_.position.changed.add(this.checkPacmanEasterEgg);
         _loc27_.moveTrait.lookAt(_loc15_,_loc16_);
         _loc2_.removeConnectionWindow();
         this.main.screenManager.eventManager.unlockControls();
         GameFacade.getInstance().registerMediator(new LogWindowMediator());
         _loc2_.createWindow(GuiConstants.USER_WINDOW);
         _loc2_.createWindow(GuiConstants.SHIP_WINDOW);
         _loc2_.createQuestWindow();
         if(Settings.showInstantLog)
         {
            _loc30_ = GameFacade.getInstance().retrieveMediator(MessagesMediator.NAME) as MessagesMediator;
            _loc30_.setUp();
         }
         var _loc28_:GlobalNotificationsMediator = GameFacade.getInstance().retrieveMediator(GlobalNotificationsMediator.NAME) as GlobalNotificationsMediator;
         _loc28_.setUp();
         _loc2_.updateInfoField(GuiConstants.USER_WINDOW,SimpleContainer.CONTAINER_CLASS_HERO_INFO_3,SimpleElement.TYPE_CREDITS);
         _loc2_.updateInfoField(GuiConstants.USER_WINDOW,SimpleContainer.CONTAINER_CLASS_HERO_INFO_3,SimpleElement.TYPE_URIDIUM);
         _loc2_.updateInfoField(GuiConstants.USER_WINDOW,SimpleContainer.CONTAINER_CLASS_HERO_INFO_2,SimpleElement.TYPE_EXPERIENCE);
         _loc2_.updateInfoField(GuiConstants.USER_WINDOW,SimpleContainer.CONTAINER_CLASS_HERO_INFO_2,SimpleElement.TYPE_HONOR);
         _loc2_.updateInfoField(GuiConstants.USER_WINDOW,SimpleContainer.CONTAINER_CLASS_HERO_INFO_2,SimpleElement.TYPE_LEVEL);
         _loc2_.updateInfoField(GuiConstants.USER_WINDOW,SimpleContainer.CONTAINER_CLASS_HERO_INFO_2,SimpleElement.TYPE_JUMP_VOUCHERS);
         _loc2_.updateInfoField(GuiConstants.USER_WINDOW,SimpleContainer.CONTAINER_CLASS_HERO_INFO_2,SimpleElement.TYPE_CAPTAIN_ENERGY);
         _loc2_.updateInfoField(GuiConstants.SHIP_WINDOW,SimpleContainer.CONTAINER_CLASS_HERO_INFO_0,SimpleElement.TYPE_HITPOINTS);
         _loc2_.updateInfoField(GuiConstants.SHIP_WINDOW,SimpleContainer.CONTAINER_CLASS_HERO_INFO_0,SimpleElement.TYPE_NANOHULL);
         _loc2_.updateInfoField(GuiConstants.SHIP_WINDOW,SimpleContainer.CONTAINER_CLASS_HERO_INFO_0,SimpleElement.TYPE_SHIELD);
         _loc2_.updateInfoField(GuiConstants.SHIP_WINDOW,SimpleContainer.CONTAINER_CLASS_HERO_INFO_1,SimpleElement.TYPE_CARGO);
         this.main.setScheduledDisconnect(false);
         if(Hero.admin)
         {
            GameFacade.getInstance().sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,new SimpleWindowCreationVO(GuiConstants.COMMAND_LINE_WINDOW).setMediatorClass(CLIWindowMediator));
         }
         _loc2_.unlockWindow(GuiConstants.LOGOUT_WINDOW);
         _loc27_.cloaked.value = _loc26_;
         this.main.getConnectionManager().isHeroLoaded = true;
         if(_loc20_)
         {
            this.main.getConnectionManager().dispatchSpacemapLoaded();
         }
         while(this._shipsBuffer.length > 0)
         {
            this.assembleShipCreation(this._shipsBuffer.pop());
         }
         this.findPetForShipOnMap(_loc27_);
         this.checkActiveMapReplacements();
      }
      
      private function checkActiveMapReplacements() : void
      {
         var _loc2_:MapReplacementEvent = null;
         var _loc1_:EventProxy = GameFacade.getInstance().retrieveProxy(EventProxy.NAME) as EventProxy;
         if(_loc1_.isEventActive(EventActivationStateCommand.EVENTTYPE_MAP_REPLACEMENT))
         {
            _loc2_ = _loc1_.getEventWithId(EventActivationStateCommand.EVENTTYPE_MAP_REPLACEMENT) as MapReplacementEvent;
            GameFacade.getInstance().sendNotification(EventNotifications.EXCHANGE_MAP,_loc2_);
         }
      }
      
      private function checkPacmanEasterEgg() : void
      {
         var _loc1_:Ship = null;
         if(this.map)
         {
            _loc1_ = this.map.hero;
            if(_loc1_.x < -6100 || _loc1_.x > this.map.serious_width + 6100 || _loc1_.y < -6100 || _loc1_.y > this.map.serious_height + 6100)
            {
               GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new EggTriggerRequest(EggTriggerRequest.EGGTRIGGERTYPE_GOING_ROUND_THE_MAP));
               if(!this.pacManEasterEggFoundThisSession)
               {
                  GameFacade.getInstance().sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams().setMessage(BPLocale.getItem("msg_easter_egg_found")));
                  this.pacManEasterEggFoundThisSession = true;
               }
            }
         }
      }
      
      private function createMap(param1:int) : void
      {
         var _loc3_:String = null;
         GameFacade.getInstance().forwardNotification(MapNotification.CLEANUP);
         Settings.mapID = param1;
         CrowdedCombatPreset.applyForMap(param1);
         var _loc2_:Map = new Map(param1);
         ScreenManager.getInstance().map = _loc2_;
         this.main.getConnectionManager().isMapLoaded = true;
         GameFacade.getInstance().sendNotification(MapNotification.NEW_MAP_INIT_FINISHED,param1);
         if(Settings.lastMapID != param1)
         {
            _loc3_ = BPLocale.getItem("map_map") + " " + ScreenManager.getInstance().map.getName();
            GameFacade.getInstance().sendNotification(GuiNotifications.SHOW_MESSAGE_BIG,new MessageCommandParams(_loc3_).setId(MessageIDs.BIG_MESSAGE__MAP).setFadeOutDelay(2).setFadeInDelay(2));
         }
      }
      
      public function assembleOreUpdate(param1:Vector.<OreCountModule>) : void
      {
         var _loc3_:OreCountModule = null;
         var _loc4_:OrePattern = null;
         var _loc5_:Boolean = false;
         var _loc6_:String = null;
         var _loc2_:Array = [];
         _loc2_[OreTypeModule.ORETYPE_PROMETIUM] = 0;
         _loc2_[OreTypeModule.ORETYPE_ENDURIUM] = 0;
         _loc2_[OreTypeModule.ORETYPE_TERBIUM] = 0;
         _loc2_[OreTypeModule.ORETYPE_XENOMIT] = 0;
         _loc2_[OreTypeModule.ORETYPE_PROMETID] = 0;
         _loc2_[OreTypeModule.ORETYPE_DURANIUM] = 0;
         _loc2_[OreTypeModule.ORETYPE_PROMERIUM] = 0;
         _loc2_[OreTypeModule.ORETYPE_SEPROM] = 0;
         _loc2_[OreTypeModule.ORETYPE_PALLADIUM] = 0;
         _loc2_[OreTypeModule.ORETYPE_OSMIUM] = 0;
         for each(_loc3_ in param1)
         {
            _loc2_[_loc3_.oreType.typeValue] = _loc3_.count;
         }
         _loc5_ = false;
         for(_loc6_ in _loc2_)
         {
            _loc4_ = OrePattern(PatternManager.orePatterns[_loc6_]);
            if(_loc2_[_loc6_] != _loc4_.count)
            {
               _loc5_ = true;
               _loc4_.count = _loc2_[_loc6_];
            }
         }
         if(!_loc5_)
         {
            return;
         }
         var _loc7_:GuiManager = this.main.getGuiManager();
         _loc7_.updateTradeWindow();
         _loc7_.updateRefinementWindow();
         var _loc8_:Map = this.main.screenManager.map;
         if(_loc8_ != null)
         {
            _loc8_.getShipManager().updateHeroCargo();
         }
      }
      
      public function assembleShipDeselection() : void
      {
         var _loc1_:Map = this.main.screenManager.map;
         if(_loc1_ != null)
         {
            _loc1_.getShipManager().deselectSelectedShip();
         }
         this._facade.forwardNotification(MapAssetNotification.DESELECT_TARGET);
      }
   }
}

