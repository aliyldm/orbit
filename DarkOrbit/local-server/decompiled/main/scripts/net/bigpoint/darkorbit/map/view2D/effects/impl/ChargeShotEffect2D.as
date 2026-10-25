package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import flash.display.MovieClip;
   import flash.geom.Vector3D;
   import net.bigpoint.darkorbit.map.model.effects.impl.ChargeShotEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractShipEffect2D;
   
   public class ChargeShotEffect2D extends AbstractShipEffect2D
   {
      
      private const scaleToMaxSuration:Number = 30;
      
      private const _particleZOffSet:Number = 1.5;
      
      private const _tmp:Vector3D = new Vector3D();
      
      public function ChargeShotEffect2D(param1:MapView2D, param2:ChargeShotEffect)
      {
         super(param1,param2);
         fps = 24;
      }
      
      override protected function initEffectVisuals() : void
      {
         var _loc1_:MovieClip = shipView.base.clip;
         playAnimation(true);
         this.clip.scaleX = this.clip.scaleY = this.clip.scaleZ = 0;
         scaleClip(this.scaleToMaxSuration,1,1,1);
         shipView.base.changed.add(this.updateRotation);
         this.updateRotation();
      }
      
      private function updateRotation() : void
      {
         var _loc2_:String = null;
         var _loc1_:Vector.<Vector.<String>> = shipView.ship.attackTrait.laser.positionsProvider.getSalvos();
         for each(_loc2_ in _loc1_)
         {
            shipView.ship.attackTrait.laser.positionsProvider.getLaserCannonLocalPosition(_loc2_,this._tmp);
            this._tmp.scaleBy(this._particleZOffSet);
            this.x = this._tmp.x;
            this.y = this._tmp.y;
         }
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         shipView.base.changed.remove(this.updateRotation);
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
         super.disposeView(param1);
      }
   }
}

