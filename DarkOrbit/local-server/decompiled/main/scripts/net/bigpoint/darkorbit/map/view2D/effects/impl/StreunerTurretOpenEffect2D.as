package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.StreunerTurretOpenEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   
   public class StreunerTurretOpenEffect2D extends AbstractMapObjectEffect2D
   {
      
      public function StreunerTurretOpenEffect2D(param1:MapView2D, param2:StreunerTurretOpenEffect)
      {
         super(param1,param2,false);
      }
      
      override protected function initEffectVisuals() : void
      {
         if(this.clip)
         {
            if(mapObjectView)
            {
               mapObjectView.visible = false;
            }
            mapView.entitiesLayer.addChild(this.clip);
            StreunerTurretOpenEffect(effect).source.position.changed.add(this.updateClipPosition);
            this.updateClipPosition();
            this.playAnimation(false,1,false,true);
         }
      }
      
      private function updateClipPosition() : void
      {
         this.clip.x = StreunerTurretOpenEffect(effect).source.x;
         this.clip.y = StreunerTurretOpenEffect(effect).source.y;
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         StreunerTurretOpenEffect(effect).source.position.changed.remove(this.updateClipPosition);
         if(mapObjectView)
         {
            mapObjectView.visible = true;
         }
         super.disposeView(param1);
      }
   }
}

