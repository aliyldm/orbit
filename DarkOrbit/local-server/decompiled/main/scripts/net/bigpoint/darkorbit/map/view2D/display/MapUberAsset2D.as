package net.bigpoint.darkorbit.map.view2D.display
{
   import flash.utils.getDefinitionByName;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.common.ILayerChild;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view2D.display.decorators.BattleStationDecorator2D;
   import net.bigpoint.darkorbit.map.view2D.display.decorators.BillboardDecorator2D;
   import net.bigpoint.darkorbit.map.view2D.display.decorators.CollectableDecorator2D;
   import net.bigpoint.darkorbit.map.view2D.display.decorators.HealthStationDecorator2D;
   import net.bigpoint.darkorbit.map.view2D.display.decorators.MimesisTurretDecorator2D;
   import net.bigpoint.darkorbit.map.view2D.display.decorators.MineDecorator2D;
   import net.bigpoint.darkorbit.map.view2D.display.decorators.NpcBeaconDecorator2D;
   import net.bigpoint.darkorbit.map.view2D.display.decorators.PlagueRangeDecorator2D;
   import net.bigpoint.darkorbit.map.view2D.display.decorators.RelayDecorator2D;
   import net.bigpoint.darkorbit.map.view2D.display.decorators.SectorControlBeaconDecorator2D;
   import net.bigpoint.darkorbit.map.view2D.display.decorators.TDMBeaconDecorator2D;
   import net.bigpoint.darkorbit.map.view2D.display.decorators.TridentDecorator2D;
   import net.bigpoint.darkorbit.map.view2D.display.decorators.TurretDecorator2D;
   import net.bigpoint.darkorbit.map.view2D.display.decorators.portal.PortalDecorator2D;
   import net.bigpoint.darkorbit.map.view2D.display.uber.UberAsset2D;
   
   public class MapUberAsset2D extends UberAsset2D implements ILayerChild
   {
      
      private static const DECORATORS:Object = {};
      
      DECORATORS["relay"] = RelayDecorator2D;
      DECORATORS["plague"] = PlagueRangeDecorator2D;
      DECORATORS["collectable"] = CollectableDecorator2D;
      DECORATORS["healthStation"] = HealthStationDecorator2D;
      DECORATORS["sectorControlBeacon"] = SectorControlBeaconDecorator2D;
      DECORATORS["trident"] = TridentDecorator2D;
      DECORATORS["battleStation"] = BattleStationDecorator2D;
      DECORATORS["tdmLogo"] = TDMBeaconDecorator2D;
      DECORATORS["billboard"] = BillboardDecorator2D;
      DECORATORS["portal"] = PortalDecorator2D;
      DECORATORS["mine"] = MineDecorator2D;
      DECORATORS["turret"] = TurretDecorator2D;
      DECORATORS["mimesisTurret"] = MimesisTurretDecorator2D;
      DECORATORS["npcbeacon"] = NpcBeaconDecorator2D;
      
      private var _layer:int = 0;
      
      private var _trait:UberDisplayTrait;
      
      private var _decorators:Vector.<IMapUberAssetDecorator2D> = new Vector.<IMapUberAssetDecorator2D>();
      
      public function MapUberAsset2D(param1:UberDisplayTrait)
      {
         this._trait = param1;
         var _loc2_:XML = param1.descriptor.display2D[0];
         if(param1.owner is Ship)
         {
            _loc2_ = null;
         }
         else if(Boolean(_loc2_) && _loc2_[0].@layer.length() > 0)
         {
            this._layer = int(_loc2_[0].@layer);
         }
         super(_loc2_,true,param1.state,param1.owner,param1.debug);
         x = this._trait.owner.x;
         y = this._trait.owner.y;
         this._trait.playAnimationSignal.add(playAnimation);
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         this._trait.playAnimationSignal.remove(playAnimation);
         super.disposeView(param1);
      }
      
      override protected function finish() : void
      {
         var _loc1_:Object = null;
         var _loc2_:IMapUberAssetDecorator2D = null;
         super.finish();
         for each(_loc1_ in this._trait.decorators)
         {
            if(DECORATORS[_loc1_.id] != null)
            {
               _loc2_ = new DECORATORS[_loc1_.id]();
               this._decorators.push(_loc2_);
               if(_loc2_ is IUpdatable)
               {
                  _manager.addUpdatable(_loc2_ as IUpdatable);
               }
               if(_loc2_ is IDisposable)
               {
                  _manager.addDisposable(_loc2_ as IDisposable);
               }
               _loc2_.decorateUberAsset(this._trait,this,_loc1_);
            }
            else
            {
               log("unknown decorator");
            }
         }
      }
      
      public function get layer() : int
      {
         return this._layer;
      }
   }
}

