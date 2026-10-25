package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import flash.geom.Vector3D;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.ShipLightTrait;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.display.ship.decorators.ShipLight2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractShipEffect2D;
   
   public class SolaceEffect2D extends AbstractShipEffect2D
   {
      
      private static const PARTICLES_FILE_PLUS:String = "solace_plus_striker_skill";
      
      private const NUMBER_OF_LIGHT_FLASHES_SOLACE:int = 11;
      
      private var is_solace_plus_striker:Boolean = false;
      
      private const _tmp:Vector3D = new Vector3D();
      
      public function SolaceEffect2D(param1:MapView2D, param2:MapObjectEffect)
      {
         var _loc3_:Ship = param2.source as Ship;
         if(Boolean(_loc3_) && _loc3_.is_solace_plus_striker())
         {
            if(Boolean(param2.pattern) && Boolean(param2.pattern.resKey))
            {
               param2.pattern.resKey = PARTICLES_FILE_PLUS;
               this.is_solace_plus_striker = true;
            }
         }
         super(param1,param2);
      }
      
      override protected function initEffectVisuals() : void
      {
         if(this.is_solace_plus_striker)
         {
            this.fps = 30;
            this.plusEffect();
            return;
         }
         this.normalEffect();
      }
      
      private function normalEffect() : void
      {
         var _loc1_:ShipLightTrait = null;
         var _loc2_:ShipLight2D = null;
         playInstantAnimation(1,true,true,3);
         if(shipView)
         {
            _loc1_ = (effect as MapObjectEffect).source.getFirstTrait(ShipLightTrait) as ShipLightTrait;
            if(_loc1_)
            {
               _loc2_ = shipView.getDecoratorForTrait(_loc1_) as ShipLight2D;
               if(_loc2_.numberOfFlashes < 0)
               {
                  _loc2_.startFlashes(this.NUMBER_OF_LIGHT_FLASHES_SOLACE);
               }
            }
         }
      }
      
      private function plusEffect() : void
      {
         playAnimation(false,1,false);
      }
      
      private function updateRotation() : void
      {
         var _loc2_:String = null;
         var _loc1_:Vector.<Vector.<String>> = shipView.ship.attackTrait.laser.positionsProvider.getSalvos();
         for each(_loc2_ in _loc1_)
         {
            shipView.ship.attackTrait.laser.positionsProvider.getLaserCannonLocalPosition(_loc2_,this._tmp);
            this.x = this._tmp.x;
            this.y = this._tmp.y;
            this.rotation = shipView.base.clipRotation - 180;
         }
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         if(this.is_solace_plus_striker)
         {
            shipView.base.changed.remove(this.updateRotation);
            if(this.parent)
            {
               this.parent.removeChild(this);
            }
         }
         super.disposeView(param1);
      }
   }
}

