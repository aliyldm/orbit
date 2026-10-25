package net.bigpoint.darkorbit.map.view2D.effects.impl.retiarus
{
   import flash.display.MovieClip;
   import flash.geom.Vector3D;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectPersistantEffect;
   import net.bigpoint.darkorbit.map.model.traits.weapons.ILaserPositionProvider;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.display.ship.ShipClip;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractShipEffect2D;
   
   public class LastPersistantEffect2D extends AbstractShipEffect2D
   {
      
      private var observedBase:ShipClip;
      
      private var released:Boolean = false;
      
      private const scaleToMaxSuration:Number = 10;
      
      private const _particleZOffSet:Number = 1;
      
      private const _tmp:Vector3D = new Vector3D();
      
      public function LastPersistantEffect2D(param1:MapView2D, param2:MapObjectPersistantEffect)
      {
         super(param1,param2);
         fps = 24;
      }
      
      override protected function initEffectVisuals() : void
      {
         var _loc1_:MovieClip = shipView.base.clip;
         if(effect.type == Effect.PERSISTANT)
         {
            playAnimation(true);
            this.clip.scaleX = this.clip.scaleY = this.clip.scaleZ = 0;
            scaleClip(this.scaleToMaxSuration,1,1,1);
         }
         else
         {
            this.clip.scaleX = this.clip.scaleY = this.clip.scaleZ = 1;
            playAnimation(false);
         }
         this.observedBase = shipView.base;
         this.observedBase.changed.add(this.updateRotation);
         this.updateRotation();
      }
      
      private function updateRotation() : void
      {
         var _loc3_:Vector.<String> = null;
         var _loc4_:String = null;
         if(this.released || !effect || !ship || !ship.attackTrait || !ship.attackTrait.laser)
         {
            return;
         }
         var _loc1_:ILaserPositionProvider = ship.attackTrait.laser.positionsProvider;
         if(!_loc1_)
         {
            return;
         }
         var _loc2_:Vector.<Vector.<String>> = _loc1_.getSalvos();
         for each(_loc3_ in _loc2_)
         {
            for each(_loc4_ in _loc3_)
            {
               _loc1_.getLaserCannonLocalPosition(_loc4_,this._tmp);
               this._tmp.scaleBy(this._particleZOffSet);
               x = this._tmp.x;
               y = this._tmp.y;
            }
         }
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         this.released = true;
         if(this.observedBase)
         {
            this.observedBase.changed.remove(this.updateRotation);
         }
         this.observedBase = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
         super.disposeView(param1);
      }
   }
}

