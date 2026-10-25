package net.bigpoint.darkorbit.net
{
   import flash.display.Bitmap;
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.com.module.PetBuffCommand;
   import net.bigpoint.darkorbit.com.module.PetGearTypeModule;
   import net.bigpoint.darkorbit.com.module.PetIsDestroyedCommand;
   import net.bigpoint.darkorbit.com.module.PetRequest;
   import net.bigpoint.darkorbit.gui.BuffCoolDown;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   import net.bigpoint.darkorbit.gui.windows.components.buff.BuffItem;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.impl.LevelUpEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.LocatorGearEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.pet.Pet;
   import net.bigpoint.darkorbit.map.model.traits.hud.IconTrait;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.pattern.BuffPattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class PetAssembly extends BaseAssembly
   {
      
      private static var instance:PetAssembly;
      
      public static const DELIMITER:String = "-";
      
      private var main:Main;
      
      private var delegateDict:Dictionary;
      
      private var _petWindow:PetWindowAssembly;
      
      private var _tradeWindow:TradeWindowAssembly;
      
      private var _messageDict:Dictionary;
      
      public function PetAssembly(param1:Function)
      {
         super();
         if(param1 !== hidden)
         {
            throw new Error("PetAssembly is a Singleton and can only be accessed through PetAssembly.getInstance()");
         }
         this.main = _main;
         this.initDelegateDict();
         this.initMessageDict();
      }
      
      public static function getInstance() : PetAssembly
      {
         if(instance == null)
         {
            instance = new PetAssembly(hidden);
         }
         return instance;
      }
      
      private static function hidden() : void
      {
      }
      
      public function assembleCommand(param1:Array) : void
      {
         var _loc2_:String = param1[2];
         if(this.delegateDict[_loc2_] != null)
         {
            this.delegateDict[_loc2_](param1);
         }
         else
         {
            this.playSound(InGameCatalog.SOUND_ID_PET_ERROR);
         }
      }
      
      public function assembleSubCommand(param1:Array) : void
      {
         var _loc2_:String = param1[2];
         var _loc3_:String = param1[3];
         if(this.delegateDict[_loc2_ + DELIMITER + _loc3_] != null)
         {
            this.delegateDict[_loc2_ + DELIMITER + _loc3_](param1);
         }
         else
         {
            this.playSound(InGameCatalog.SOUND_ID_PET_ERROR);
         }
      }
      
      private function initMessageDict() : void
      {
         this._messageDict = new Dictionary();
         this._messageDict[PetIsDestroyedCommand.DESTROYEDTYPE_NONE] = "msg_pet_is_dead";
         this._messageDict[PetIsDestroyedCommand.DESTROYEDTYPE_USED_KAMIKAZE] = "msg_pet_kamikaze-used";
      }
      
      private function initDelegateDict() : void
      {
         this.delegateDict = new Dictionary();
         this.delegateDict[ServerCommands.PET_INIT] = this.assemblePetInitilization;
         this.delegateDict[ServerCommands.PET_ACQUIRED] = this.assembleRemoveBanner;
         this.delegateDict[ServerCommands.DEACTIVATE_PET] = this.assemblePetDeactivation;
         this.delegateDict[ServerCommands.PET_DISTROYED] = this.assemblePetDestroyed;
         this.delegateDict[ServerCommands.PET_STATUS] = this.assemblePetStatus;
         this.delegateDict[ServerCommands.REPAIR_PET] = this.assemblePetRepair;
         this.delegateDict[ServerCommands.BLOCK_PET_WINDOW] = this.assembleLockWindow;
         this.delegateDict[ServerCommands.TRADE_WINDOW_ACTIVATION] = this.assembleActivateTradeWindow;
         this.delegateDict[ServerCommands.OUT_OF_FUEL] = this.assembleFuelMissingMode;
         this.delegateDict[ServerCommands.PET_IDLE] = this.assembleInvisibleMode;
         this.delegateDict[ServerCommands.PET_STOP_LASER_ATTACK] = this.assembleStopLaserAttack;
         this.delegateDict[ServerCommands.PET_RESET] = this.assembleGearReset;
         this.delegateDict[ServerCommands.PET_REPAIR_BUTTON] = this.assembleSetRepairButtonState;
         this.delegateDict[ServerCommands.PET_ATTRIBUTE_INFO] = this.assembleSubCommand;
         this.delegateDict[ServerCommands.PET_GEAR_INFO] = this.assembleSubCommand;
         this.delegateDict[ServerCommands.PET_BUFF_INFO] = this.assembleSubCommand;
         this.delegateDict[ServerCommands.PET_FUEL_AVAILABLE] = this.assembleFuelAvailableMode;
         this.delegateDict[ServerCommands.PET_ATTRIBUTE_INFO + DELIMITER + ServerCommands.EXPERIENCE_POINTS_UPDATE] = this.assemblePetXPInfo;
         this.delegateDict[ServerCommands.PET_ATTRIBUTE_INFO + DELIMITER + ServerCommands.HITPOINTS_INFO] = this.assemblePetHPInfo;
         this.delegateDict[ServerCommands.PET_ATTRIBUTE_INFO + DELIMITER + ServerCommands.SHIELD_INFO] = this.assemblePetShieldInfo;
         this.delegateDict[ServerCommands.PET_ATTRIBUTE_INFO + DELIMITER + ServerCommands.FUEL_INFO] = this.assemblePetFuelInfo;
         this.delegateDict[ServerCommands.PET_ATTRIBUTE_INFO + DELIMITER + ServerCommands.PET_LEVEL_UP] = this.assembleLevelUp;
         this.delegateDict[ServerCommands.EVASION_PROTOCOL_INFO] = this.assembleEvasionProtocolInfo;
         this.delegateDict[ServerCommands.PET_GEAR_INFO + DELIMITER + ServerCommands.LOCATOR_GEAR_INFO] = this.assembleLocatorGearInfo;
         this.delegateDict[ServerCommands.PET_GEAR_INFO + DELIMITER + ServerCommands.GEAR_TARGET_LIST] = this.assembleGearTargetsList;
         this.delegateDict[ServerCommands.PET_GEAR_INFO + DELIMITER + ServerCommands.SELECT] = this.assembleSelectGear;
         this.delegateDict[ServerCommands.PET_GEAR_INFO + DELIMITER + ServerCommands.ADD_TO_PET] = this.assembleAddGear;
         this.delegateDict[ServerCommands.PET_BUFF_INFO + DELIMITER + ServerCommands.ADD_TO_PET] = this.assembleAddBuff;
         this.delegateDict[ServerCommands.PET_GEAR_INFO + DELIMITER + ServerCommands.REMOVE_FROM_PET] = this.assembleRemoveGear;
         this.delegateDict[ServerCommands.PET_BUFF_INFO + DELIMITER + ServerCommands.REMOVE_FROM_PET] = this.assembleRemoveBuff;
      }
      
      public function assembleSetRepairButtonState(param1:Boolean, param2:int) : void
      {
         this.petWindow.setRepairButtonState(param1,param2);
      }
      
      public function sendPetRequest(param1:int) : void
      {
         var _loc2_:PetRequest = new PetRequest(param1);
         this.sendRequest(_loc2_);
      }
      
      public function sendRequest(param1:IModule) : void
      {
         this.main.getConnectionManager().sendRequest(param1);
      }
      
      public function togglePetActivation() : void
      {
         if(Boolean(this.heroPet) && this.heroPet.idleState)
         {
            return;
         }
         this.sendPetRequest(PetRequest.PETREQUESTTYPE_TOGGLE_ACTIVATION);
      }
      
      private function get heroPet() : Pet
      {
         return this.hero ? this.hero.pet : null;
      }
      
      public function switchToGuardMode() : void
      {
         if(Boolean(this.heroPet) && this.heroPet.idleState)
         {
            return;
         }
         this.sendPetRequest(PetRequest.PETREQUESTTYPE_HOTKEY_GUARD_MODE);
      }
      
      public function switchToShipRepairMode() : void
      {
         if(Boolean(this.heroPet) && this.heroPet.idleState)
         {
            return;
         }
         this.sendPetRequest(PetRequest.PETREQUESTTYPE_HOTKEY_REPAIR_SHIP);
      }
      
      public function assembleFuelMissingMode() : void
      {
         this.petWindow.setFuelMissingMode();
      }
      
      private function assembleFuelAvailableMode(param1:Array) : void
      {
         this.petWindow.setFuelAvailableMode();
      }
      
      public function assemblePetInitilization(param1:Boolean, param2:Boolean, param3:Boolean) : void
      {
         Hero.ownsPet = param1;
         Hero.isPetDestroyed = !param3;
         this.petWindow.init(param2,!param3);
      }
      
      public function assembleLockWindow(param1:Boolean, param2:Boolean) : void
      {
         this.petWindow.blockWindow(param1,param2);
      }
      
      public function assembleGearReset() : void
      {
         this.petWindow.resetGears();
         if(ScreenManager.getInstance().map == null || this.hero == null || this.hero.pet == null)
         {
            return;
         }
         this.petWindow.removeAllGears();
         this.clearHeroPetEffects();
      }
      
      public function assembleStopLaserAttack(param1:int) : void
      {
         var _loc2_:Map = ScreenManager.getInstance().map;
         if(!_loc2_)
         {
         }
      }
      
      public function assembleInvisibleMode(param1:int, param2:Boolean) : void
      {
         var _loc3_:Pet = null;
         if(ScreenManager.getInstance().map != null)
         {
            _loc3_ = ScreenManager.getInstance().map.getShipManager().getPet(param1);
            if(_loc3_ != null)
            {
               _loc3_.idleState = param2;
               _loc3_.visible = !param2;
            }
         }
      }
      
      public function assembleActivateTradeWindow() : void
      {
         this.tradeWindow.activate();
      }
      
      public function assembleLevelUp(param1:int, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:Pet = this.hero.pet;
         if(_loc5_)
         {
            ScreenManager.getInstance().map.effects.addMapObjectEffectOnce(new LevelUpEffect(_loc5_));
            _loc5_.level = param1;
            _loc5_.shipPattern = PatternManager.shipPatterns[param3];
         }
         log(BPLocale.getItem("msg_pet_level_up").replace("%LEVEL%",param1));
         this.playSound(InGameCatalog.SOUND_ID_PET_LEVELUP);
      }
      
      public function assembleEvasionProtocolInfo(param1:int, param2:Boolean) : void
      {
         var _loc3_:Pet = map.getEntityById(param1) as Pet;
         if(_loc3_)
         {
            _loc3_.evasionProtocolEquiped = param2;
         }
      }
      
      public function assembleLocatorGearInfo(param1:int, param2:int) : void
      {
         var _loc3_:LocatorGearEffect = ScreenManager.getInstance().map.effects.getEffectForMapObject(Hero.userID,EffectIDList.LOCATOR) as LocatorGearEffect;
         if(_loc3_)
         {
            _loc3_.updateEffect(param1,param2);
         }
      }
      
      public function assemblePetDestroyed(param1:int) : void
      {
         this.petWindow.petDestroyed();
         this.clearHeroPetEffects();
         this.playSound(InGameCatalog.SOUND_ID_PET_DESTRUCTION);
         var _loc2_:String = this._messageDict[param1];
         if(_loc2_ != "")
         {
            log(BPLocale.getItem(_loc2_));
         }
      }
      
      public function assemblePetRepair() : void
      {
         this.playSound(InGameCatalog.SOUND_ID_PET_HEALING);
         this.petWindow.toggleRepairButtonVisbility(false);
      }
      
      public function assemblePetStatus(param1:String, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int, param9:int, param10:int, param11:int, param12:int, param13:String) : void
      {
         this.petWindow.updateWindoValues(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12,param13);
      }
      
      public function assemblePetDeactivation(param1:Boolean = false) : void
      {
         var _loc2_:Map = ScreenManager.getInstance().map;
         if(!_loc2_)
         {
            return;
         }
         if(this.petWindow.getPetWindowContainer() != null)
         {
            this.clearHeroPetEffects();
            this.petWindow.petDeactivation();
            if(param1)
            {
               this.playSound(InGameCatalog.SOUND_ID_PET_DEACTIVATION);
            }
         }
      }
      
      public function assembleGearTargetsList(param1:int, param2:Vector.<int>) : void
      {
         this.petWindow.addTargetsForGear(param1,param2);
      }
      
      public function assembleRemoveGear(param1:int) : void
      {
         this.petWindow.removeGear(param1);
      }
      
      public function assembleAddGear(param1:int, param2:int, param3:int, param4:Boolean) : void
      {
         this.petWindow.addGear(param1,param2,param3,param4);
      }
      
      public function assembleSelectGear(param1:int, param2:Vector.<int>) : void
      {
         this.petWindow.selectGear(param1,param2);
      }
      
      public function assemblePetGearActivationChange(param1:Boolean, param2:PetGearTypeModule) : void
      {
         this.petWindow.gearActivationChange(param1,param2);
      }
      
      private function clearHeroPetEffects() : void
      {
         if(this.hero)
         {
            map.effects.removeEffectFromMapObject(this.hero.id,EffectIDList.PET_SPAWN);
            map.effects.removeEffectFromMapObject(this.hero.id,EffectIDList.LOCATOR);
         }
      }
      
      public function assembleRemoveBanner() : void
      {
         this.petWindow.removeBanner();
      }
      
      public function assemblePetHPInfo(param1:int, param2:int) : void
      {
         var _loc3_:Pet = null;
         if(ScreenManager.getInstance().map == null)
         {
            return;
         }
         if(this.hero)
         {
            _loc3_ = this.hero.pet;
            if(_loc3_ != null)
            {
               _loc3_.hp.hp.value = param1;
               _loc3_.hp.maxHP.value = param2;
               this.petWindow.updateBar(SimpleElement.PET_WINDOW_HP_BAR,param1,param2);
               this.playSound(InGameCatalog.SOUND_ID_PET_HEALING);
            }
         }
      }
      
      public function assemblePetXPInfo(param1:int, param2:int) : void
      {
         this.petWindow.updateBar(SimpleElement.PET_WINDOW_XP_BAR,param1,param2);
      }
      
      public function assemblePetShieldInfo(param1:Number, param2:Number) : void
      {
         var _loc3_:Pet = null;
         if(Boolean(ScreenManager.getInstance().map) && Boolean(ScreenManager.getInstance().map.getShipManager()) && Boolean(this.hero))
         {
            _loc3_ = this.hero.pet;
            if(_loc3_ != null)
            {
               _loc3_.hp.shield.value = param1;
               _loc3_.hp.maxShield.value = param2;
            }
            this.petWindow.updateBar(SimpleElement.PET_WINDOW_SHIELD_BAR,param1,param2);
         }
      }
      
      public function assemblePetHeatInfo(param1:int, param2:Number, param3:Number, param4:int) : void
      {
         this.petWindow.updateHeatBar(param2,param3,param1);
         this.petWindow.updateHeatText(param1,param4);
         this.toggleHeatIcon(param1 >= 5);
      }
      
      public function assemblePetFuelInfo(param1:int, param2:int) : void
      {
         this.petWindow.updateBar(SimpleElement.PET_WINDOW_FUEL_BAR,param1,param2);
      }
      
      public function assembleRemoveBuff(param1:PetBuffCommand) : void
      {
         var _loc2_:int = param1.effectId;
         this.petWindow.removeBuffById(_loc2_);
      }
      
      public function assembleAddBuff(param1:int, param2:Vector.<int>) : void
      {
         var _loc4_:int = 0;
         var _loc3_:BuffItem = this.petWindow.addBuff(param1);
         if(_loc3_ == null)
         {
            return;
         }
         switch(param1)
         {
            case BuffPattern.SINGULARITY_BUFF:
            case BuffPattern.WEAKENSHIELD_BUFF:
            case BuffPattern.SPEEDLEACH_BUFF:
               break;
            case BuffPattern.TRADE_BUFF:
            case BuffPattern.KAMIKAZE_BUFF:
            case BuffPattern.SHIP_REPAIR_BUFF:
            case BuffPattern.FRIENDLY_SACRIFICE:
            case BuffPattern.PET_RETARGETING_GEAR:
            case BuffPattern.PET_HP_LINK_GEAR:
            case BuffPattern.PET_MEGA_MINE_GEAR:
            case BuffPattern.PET_COMBAT_BEACON_GEAR:
            case BuffPattern.PET_HP_BEACON_GEAR:
            case BuffPattern.PET_HEAT_RELEASE_GEAR:
            case BuffPattern.PET_SIMPLE_BLOCKING_WINDOW:
               _loc4_ = int(param2[0]);
               this.addCooldown(param1,_loc4_);
         }
      }
      
      public function addCooldown(param1:int, param2:int) : void
      {
         var _loc3_:BuffItem = this.petWindow.getBuff(param1);
         var _loc4_:BuffCoolDown = new BuffCoolDown(_loc3_,param2,_loc3_.tooltip,_loc3_.pattern.languageKey,this.petWindow.removeBuff);
         _loc4_.addCoolDown();
      }
      
      public function toggleHeatIcon(param1:Boolean) : void
      {
         var _loc5_:IconTrait = null;
         var _loc2_:IconTrait = null;
         var _loc3_:Vector.<IconTrait> = Vector.<IconTrait>(this.heroPet.getTraits(IconTrait));
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = _loc3_[_loc4_];
            if(_loc5_.iconId == "maxHeatLevel")
            {
               _loc2_ = _loc5_;
               break;
            }
            _loc4_++;
         }
         if(param1 && _loc2_ == null)
         {
            this.heroPet.addTrait(new IconTrait("maxHeatLevel"));
         }
         else if(!param1 && _loc2_ != null)
         {
            this.heroPet.removeTrait(_loc2_);
         }
      }
      
      public function playSound(param1:int) : void
      {
         if(Settings.playSFX.value)
         {
            AudioManager.playSoundEffect(param1);
         }
      }
      
      private function addEffect(param1:int, param2:Bitmap) : void
      {
         this.clearHeroPetEffects();
         if(param1 == EffectIDList.LOCATOR)
         {
            ScreenManager.getInstance().map.effects.addMapObjectEffectOnce(new LocatorGearEffect(this.hero,param2));
         }
      }
      
      private function removePetHeroEffects() : void
      {
         if(this.hero)
         {
            ScreenManager.getInstance().map.effects.removeEffectFromMapObject(this.hero.id,EffectIDList.PET_SPAWN);
            ScreenManager.getInstance().map.effects.removeEffectFromMapObject(this.hero.id,EffectIDList.LOCATOR);
         }
      }
      
      private function get hero() : Ship
      {
         return ScreenManager.getInstance().map.hero;
      }
      
      public function get petWindow() : PetWindowAssembly
      {
         if(this._petWindow == null)
         {
            this._petWindow = new PetWindowAssembly(this.main.getConnectionManager(),this.main.getGuiManager().createPetWindow());
            this._petWindow.removePetHeroEffectsSignal.add(this.removePetHeroEffects);
            this._petWindow.addEffectSignal.add(this.addEffect);
            this._petWindow.sendRequestSignal.add(this.sendRequest);
         }
         return this._petWindow;
      }
      
      private function get tradeWindow() : TradeWindowAssembly
      {
         if(this._tradeWindow == null)
         {
            this._tradeWindow = new TradeWindowAssembly(this.main.getConnectionManager(),this.main.getGuiManager().getWindow(GuiConstants.TRADE_WINDOW));
         }
         return this._tradeWindow;
      }
   }
}

