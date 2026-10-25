package net.bigpoint.darkorbit.map.model.ship
{
   import com.bigpoint.utils.PointLite;
   import com.bigpoint.utils.bindables.BindableBoolean;
   import com.bigpoint.utils.bindables.BindableInt;
   import com.bigpoint.utils.bindables.BindableRotation;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.VisualModifierCommand;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.minimap.traits.AbstractMiniMapTrait;
   import net.bigpoint.darkorbit.map.model.minimap.traits.MiniMapIconTrait;
   import net.bigpoint.darkorbit.map.model.ship.drones.Drones;
   import net.bigpoint.darkorbit.map.model.ship.patterns.ShipPattern;
   import net.bigpoint.darkorbit.map.model.ship.pet.Pet;
   import net.bigpoint.darkorbit.map.model.ship.pet.PetTrait;
   import net.bigpoint.darkorbit.map.model.traits.AttackTargetTrait;
   import net.bigpoint.darkorbit.map.model.traits.AttackerTrait;
   import net.bigpoint.darkorbit.map.model.traits.HPTrait;
   import net.bigpoint.darkorbit.map.model.traits.MouseHitAreaTrait;
   import net.bigpoint.darkorbit.map.model.traits.MoveTrait;
   import net.bigpoint.darkorbit.map.model.traits.ShipDisplayTrait;
   import net.bigpoint.darkorbit.map.model.traits.ShipUpgradesTrait;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.model.traits.hud.MapObjectInfoTrait;
   import net.bigpoint.darkorbit.map.model.traits.weapons.LaserCannon;
   import net.bigpoint.darkorbit.map.model.traits.weapons.RocketLauncher;
   import net.bigpoint.darkorbit.map.view3D.display3D.ship.Slot3D;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class Ship extends MapEntity
   {
      
      public const laserExpansionStage:BindableInt = new BindableInt(1);
      
      public const isGroupMember:BindableBoolean = new BindableBoolean(false);
      
      public const legendary:BindableBoolean = new BindableBoolean(false);
      
      public const hasSpeedBuff:BindableBoolean = new BindableBoolean(false);
      
      public const changeEnginePositions:ISignal = new Signal(Vector.<Slot3D>);
      
      public const cloaked:BindableBoolean = new BindableBoolean(false);
      
      public const debug:BindableBoolean = new BindableBoolean(false);
      
      public var pet:Pet;
      
      private var _isNPC:Boolean = false;
      
      private var _hpTrait:HPTrait;
      
      private var _shipPattern:ShipPattern;
      
      private var _shipPatternChanged:ISignal = new Signal();
      
      public const activeVisualModifiers:Vector.<VisualModifierCommand> = new Vector.<VisualModifierCommand>();
      
      private var _displayTrait:ShipDisplayTrait;
      
      private var _uberDisplayTrait:UberDisplayTrait;
      
      private var _moveTrait:MoveTrait;
      
      private var _assetIdExtension:String = "";
      
      private var _allowRotation:Boolean = true;
      
      private var _visible:Boolean = true;
      
      private var _info:MapObjectInfoTrait;
      
      private var _hitArea:MouseHitAreaTrait;
      
      private var _hasDesignSet:BindableBoolean = new BindableBoolean(false);
      
      private var _patternTraits:Vector.<EntityTraitBase>;
      
      private var _drones:Drones = new Drones();
      
      private var _tmpPattern:ShipPattern;
      
      private var _patternLocked:Boolean = false;
      
      public function Ship(param1:int, param2:ShipPattern, param3:AbstractMiniMapTrait)
      {
         super(param1,new PointLite());
         this._hpTrait = new HPTrait();
         addTrait(this._hpTrait);
         this._displayTrait = new ShipDisplayTrait();
         addTrait(this._displayTrait);
         addTrait(this._hitArea = new MouseHitAreaTrait(0,2));
         addTrait(new AttackTargetTrait());
         addTrait(new AttackerTrait(new LaserCannon(),new RocketLauncher()));
         addTrait(this._info = new MapObjectInfoTrait());
         if(param3)
         {
            addTrait(param3);
         }
         if(!this.isNPC)
         {
            addTrait(new ShipUpgradesTrait());
         }
         this.setMoveTrait();
         this.info.factionID.changed.add(this.updateDisplay);
         this.shipPattern = param2;
         this.cloaked.changed.add(this.updateVisibility);
         this.updateVisibility();
      }
      
      override public function deactivateEntity() : void
      {
         super.deactivateEntity();
      }
      
      public function setMoveTrait() : void
      {
         addTrait(this._moveTrait = new MoveTrait());
      }
      
      public function set visible(param1:Boolean) : void
      {
         this._visible = param1;
         this.moveTrait.updateRotation();
         this.updateVisibility();
      }
      
      public function get visible() : Boolean
      {
         return this._visible;
      }
      
      protected function updateVisibility() : void
      {
         if(this.isHeroShip() == false)
         {
            if(this._visible && this.cloaked.value == false)
            {
               if(this._uberDisplayTrait)
               {
                  addTrait(this._uberDisplayTrait);
               }
               addTrait(this._displayTrait);
               addTrait(this._info);
               ScreenManager.getInstance().map.effects.reactivateEffectsForId(id);
            }
            else
            {
               ScreenManager.getInstance().map.effects.moveEffectsToCacheForId(id);
               if(this._uberDisplayTrait)
               {
                  removeTrait(this._uberDisplayTrait);
               }
               removeTrait(this._displayTrait);
               removeTrait(this._info);
            }
         }
      }
      
      public function set shipPattern(param1:ShipPattern) : void
      {
         var _loc2_:AttackerTrait = null;
         if(this._patternLocked)
         {
            this._tmpPattern = param1;
            return;
         }
         this._shipPattern = param1;
         if(this._shipPattern)
         {
            this.hitArea.clickRadius = this._shipPattern.clickRadius;
            this.hitArea.clickScreenOffset.x = this._shipPattern.getClickOffsetX();
            this.hitArea.clickScreenOffset.y = this._shipPattern.getClickOffsetY();
            if(this._shipPattern.clickPriority != -1)
            {
               this.hitArea.clickPriority = this._shipPattern.clickPriority;
            }
            AttackTargetTrait(getFirstTrait(AttackTargetTrait)).explosionTypeID = this._shipPattern.explodeTypeID;
            _loc2_ = getFirstTrait(AttackerTrait) as AttackerTrait;
            if(_loc2_.laser)
            {
               _loc2_.laser.laserClassID = this._shipPattern.laserClassID;
            }
            if(_loc2_.rocketLauncher)
            {
               _loc2_.rocketLauncher.rocketClassId = this._shipPattern.rocketClassID;
            }
            if(this.shipPattern.minimapIcon)
            {
               if(getFirstTrait(MiniMapIconTrait))
               {
                  MiniMapIconTrait(getFirstTrait(MiniMapIconTrait)).resKey = this.shipPattern.minimapIcon;
               }
               else
               {
                  addTrait(new MiniMapIconTrait(this.shipPattern.minimapIcon));
               }
            }
         }
         this.updateDisplay();
         this._shipPatternChanged.dispatch();
      }
      
      protected function updateDisplay() : void
      {
         var _loc1_:EntityTraitBase = null;
         if(!this._shipPattern)
         {
            return;
         }
         while(Boolean(this._patternTraits) && Boolean(this._patternTraits.length))
         {
            removeTrait(this._patternTraits.pop());
         }
         this._patternTraits = UberAssetsLib.instance.getTraits(this,this.getUberDescriptor());
         for each(_loc1_ in this._patternTraits)
         {
            if(_loc1_ is UberDisplayTrait)
            {
               this.addDisplayDecorators(UberDisplayTrait(_loc1_).decorators);
            }
            if(_loc1_ is MouseHitAreaTrait)
            {
               MouseHitAreaTrait(_loc1_).enabled.value = this.hitArea.enabled.value;
            }
            addTrait(_loc1_);
         }
         this._uberDisplayTrait = getFirstTrait(UberDisplayTrait) as UberDisplayTrait;
         removeTrait(this._displayTrait);
         addTrait(this._displayTrait);
         this.updateVisibility();
      }
      
      protected function getUberDescriptor() : XML
      {
         return UberAssetsLib.instance.getDescriptor(this._shipPattern.assetId + "_" + this.info.factionID.value + "_" + this._assetIdExtension,UberAssetsLib.LIB_SHIPS,false) || UberAssetsLib.instance.getDescriptor(this._shipPattern.assetId + "_" + this._assetIdExtension,UberAssetsLib.LIB_SHIPS,false) || UberAssetsLib.instance.getDescriptor(this._shipPattern.assetId + "_" + this.info.factionID.value,UberAssetsLib.LIB_SHIPS,false) || UberAssetsLib.instance.getDescriptor(this._shipPattern.assetId,UberAssetsLib.LIB_SHIPS) || this.getPetDescriptor() || UberAssetsLib.instance.getDebugDescription();
      }
      
      private function getPetDescriptor() : XML
      {
         var _loc2_:Vector.<String> = null;
         var _loc3_:XML = null;
         var _loc4_:int = 0;
         var _loc1_:PetTrait = getFirstTrait(PetTrait) as PetTrait;
         if(_loc1_)
         {
            _loc2_ = Vector.<String>([this.shipPattern.typeId,"pet-basic-" + Math.max(1,_loc1_.level.value)]);
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc3_ = UberAssetsLib.instance.getDescriptor(_loc2_[_loc4_],UberAssetsLib.LIB_SHIPS,false);
               if(_loc3_ != null)
               {
                  return _loc3_;
               }
               _loc4_++;
            }
         }
         return null;
      }
      
      protected function addDisplayDecorators(param1:Vector.<Object>) : void
      {
         param1.push({"id":"ship"});
         param1.push({"id":"drones"});
         if(this.isHeroShip())
         {
            param1.push({"id":"hero"});
         }
      }
      
      public function get drones() : Drones
      {
         return this._drones;
      }
      
      public function get hitArea() : MouseHitAreaTrait
      {
         return this._hitArea;
      }
      
      public function get attackTarget() : AttackTargetTrait
      {
         return getFirstTrait(AttackTargetTrait) as AttackTargetTrait;
      }
      
      public function get shipPattern() : ShipPattern
      {
         return this._shipPattern;
      }
      
      public function get hp() : HPTrait
      {
         return this._hpTrait;
      }
      
      public function get shipPatternChanged() : ISignal
      {
         return this._shipPatternChanged;
      }
      
      public function get attackTrait() : AttackerTrait
      {
         return getFirstTrait(AttackerTrait) as AttackerTrait;
      }
      
      public function isHeroShip() : Boolean
      {
         if(id == Hero.userID)
         {
            return true;
         }
         return false;
      }
      
      public function get info() : MapObjectInfoTrait
      {
         return this._info;
      }
      
      public function get isNPC() : Boolean
      {
         return this._isNPC;
      }
      
      public function set isNPC(param1:Boolean) : void
      {
         this.moveTrait.randomRotationEnabled = param1;
         this._isNPC = param1;
      }
      
      public function get rotation() : BindableRotation
      {
         return this.moveTrait.rotation;
      }
      
      public function get uberDisplayTrait() : UberDisplayTrait
      {
         return this._uberDisplayTrait;
      }
      
      public function get moveTrait() : MoveTrait
      {
         if(this._moveTrait == null)
         {
            this._moveTrait = getFirstTrait(MoveTrait) as MoveTrait;
         }
         return this._moveTrait;
      }
      
      public function set assetIdExtension(param1:String) : void
      {
         var _loc2_:XML = null;
         if(this._assetIdExtension == param1)
         {
            return;
         }
         this._assetIdExtension = param1;
         if(param1 != "")
         {
            _loc2_ = this.getUberDescriptor();
            if(String(_loc2_.@replacementName).length > 0)
            {
               this.shipPattern.replacementName = String(_loc2_.@replacementName);
            }
         }
         else
         {
            this.shipPattern.replacementName = "";
         }
         this.updateDisplay();
         this._shipPatternChanged.dispatch();
      }
      
      public function lockPattern() : void
      {
         this._patternLocked = true;
      }
      
      public function unlockPattern() : void
      {
         this._patternLocked = false;
         if(Boolean(this._tmpPattern) && this._shipPattern != this._tmpPattern)
         {
            this.shipPattern = this._tmpPattern;
         }
      }
      
      public function get hasDesignSet() : BindableBoolean
      {
         return this._hasDesignSet;
      }
      
      public function is_solace_plus_striker() : Boolean
      {
         return this._shipPattern.typeId == "ship_solace-plus_design_solace-plus-striker";
      }
   }
}

