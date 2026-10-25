package net.bigpoint.darkorbit.map.view3D.display3D
{
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import net.bigpoint.darkorbit.ctb.BeaconTrait;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   import net.bigpoint.darkorbit.map.model.ship.PodCarrierTrait;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.display3D.decorators.BattleStationDecorator3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.decorators.CollectableDecorator3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.decorators.HeroDecorator3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.decorators.HeroPetDecorator3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.decorators.IMapUberAssetDecorator3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.decorators.MimesisDecorator3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.decorators.MineDecorator3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.decorators.NpcBeaconDecorator3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.decorators.PortalDecorator3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.decorators.RelayDecorator3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.decorators.SectorControlBeaconDecorator3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.decorators.TurretDecorator3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.decorators.trait.BeaconDecorator3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.decorators.trait.PodDecorator3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.ship.Ship3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.ship.drones.DronesFormation3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.UberAsset3D;
   import net.bigpoint.darkorbit.settings.CrowdedCombatPreset;
   
   public class MapUberAsset3D extends UberAsset3D
   {
      
      private static const DECORATORS:Object = {};
      
      private static const TRAIT_DECORATORS:Dictionary = new Dictionary();
      
      DECORATORS["hero"] = HeroDecorator3D;
      DECORATORS["heroPet"] = HeroPetDecorator3D;
      DECORATORS["ship"] = Ship3D;
      DECORATORS["drones"] = DronesFormation3D;
      DECORATORS["portal"] = PortalDecorator3D;
      DECORATORS["battleStation"] = BattleStationDecorator3D;
      DECORATORS["sectorControlBeacon"] = SectorControlBeaconDecorator3D;
      DECORATORS["collectable"] = CollectableDecorator3D;
      DECORATORS["relay"] = RelayDecorator3D;
      DECORATORS["mine"] = MineDecorator3D;
      DECORATORS["turret"] = TurretDecorator3D;
      DECORATORS["mimesisTurret"] = TurretDecorator3D;
      DECORATORS["mimesis"] = MimesisDecorator3D;
      DECORATORS["npcbeacon"] = NpcBeaconDecorator3D;
      TRAIT_DECORATORS[PodCarrierTrait] = PodDecorator3D;
      TRAIT_DECORATORS[BeaconTrait] = BeaconDecorator3D;
      
      private var _trait:UberDisplayTrait;
      
      private var _decorators:Vector.<Object> = new Vector.<Object>();
      
      private var _trait2decorator:Dictionary = new Dictionary();
      
      public var updatePositionFromModel:Boolean = true;
      
      public var drones:DronesFormation3D;
      
      private var _droneUpdating:Boolean = false;
      
      public function MapUberAsset3D(param1:UberDisplayTrait)
      {
         var _loc2_:Object = null;
         var _loc3_:IMapUberAssetDecorator3D = null;
         this._trait = param1;
         super(param1.descriptor.display3D[0],param1.state,param1.owner,param1.debug,"uid " + param1.owner.id + " " + param1.owner);
         this._trait.playAnimationSignal.add(playAnimation);
         x = this._trait.owner.x3D;
         y = this._trait.owner.y3D;
         z = this._trait.owner.z3D;
         for each(_loc2_ in this._trait.decorators)
         {
            if(!this.shouldSkipCrowdedOtherShipDecorator(_loc2_.id))
            {
               if(DECORATORS[_loc2_.id] != null)
               {
                  _loc3_ = new DECORATORS[_loc2_.id]();
                  if(_loc2_.id == "drones")
                  {
                     this.drones = _loc3_ as DronesFormation3D;
                  }
                  _loc3_.initialize(this._trait,this,_loc2_);
                  this._decorators.push(_loc3_);
                  if(_loc3_ is IUpdatable && !(_loc3_ is DronesFormation3D))
                  {
                     _manager.addUpdatable(_loc3_ as IUpdatable);
                  }
                  if(_loc3_ is IDisposable)
                  {
                     _manager.addDisposable(_loc3_ as IDisposable);
                  }
               }
               else
               {
                  log("unknown decorator " + _loc2_.id);
               }
            }
         }
      }
      
      private function shouldSkipCrowdedOtherShipDecorator(param1:String) : Boolean
      {
         var _loc2_:Ship = this._trait.owner as Ship;
         return param1 == "drones" && CrowdedCombatPreset.enabled && _loc2_ != null && !_loc2_.isHeroShip();
      }
      
      public function setDroneUpdates(param1:DronesFormation3D, param2:Boolean) : void
      {
         if(this._droneUpdating == param2)
         {
            return;
         }
         this._droneUpdating = param2;
         if(param2)
         {
            _manager.addUpdatable(param1);
         }
         else
         {
            _manager.removeUpdatable(param1);
         }
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         var _loc2_:EntityTraitBase = null;
         this._trait.playAnimationSignal.remove(playAnimation);
         this._trait.owner.traitAdded.remove(this.handleTraitAdded);
         this._trait.owner.traitRemoved.remove(this.handleTraitRemoved);
         if(param1)
         {
            for each(_loc2_ in this._trait.owner.traits)
            {
               this.handleTraitRemoved(_loc2_,param1);
            }
         }
         super.disposeView(param1);
      }
      
      override protected function finish() : void
      {
         var _loc1_:IMapUberAssetDecorator3D = null;
         var _loc2_:EntityTraitBase = null;
         super.finish();
         for each(_loc1_ in this._decorators)
         {
            _loc1_.decorate();
         }
         this._trait.owner.traitAdded.add(this.handleTraitAdded);
         this._trait.owner.traitRemoved.add(this.handleTraitRemoved);
         for each(_loc2_ in this._trait.owner.traits)
         {
            this.handleTraitAdded(_loc2_);
         }
      }
      
      private function handleTraitAdded(param1:EntityTraitBase) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:Object = null;
         for(_loc2_ in TRAIT_DECORATORS)
         {
            if(param1 is (_loc2_ as Class))
            {
               _loc3_ = new TRAIT_DECORATORS[_loc2_](param1,this);
               this._trait2decorator[param1] = _loc3_;
               if(_loc3_ is IUpdatable && !(_loc3_ is DronesFormation3D))
               {
                  _manager.addUpdatable(_loc3_ as IUpdatable);
               }
               if(_loc3_ is IDisposable)
               {
                  _manager.addDisposable(_loc3_ as IDisposable);
               }
            }
         }
      }
      
      private function handleTraitRemoved(param1:EntityTraitBase, param2:Boolean = false) : void
      {
         var _loc3_:Object = null;
         if(this._trait2decorator[param1])
         {
            _loc3_ = this._trait2decorator[param1];
            if(_loc3_ is IDisposable)
            {
               IDisposable(_loc3_).disposeView(param2);
               _manager.removeDisposable(_loc3_ as IDisposable);
            }
            if(_loc3_ is IUpdatable && !(_loc3_ is DronesFormation3D))
            {
               _manager.removeUpdatable(_loc3_ as IUpdatable);
            }
         }
      }
      
      override public function updateObj(param1:Number) : void
      {
         super.updateObj(param1);
         if(this.updatePositionFromModel)
         {
            moveTo(this._trait.owner.x3D,this._trait.owner.y3D,this._trait.owner.z3D);
         }
      }
   }
}

