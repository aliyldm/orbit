package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.MimesisTurretOpenEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   
   public class MimesisTurretOpenEffect2D extends AbstractMapObjectEffect2D
   {
      
      public function MimesisTurretOpenEffect2D(param1:MapView2D, param2:MimesisTurretOpenEffect)
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
            MimesisTurretOpenEffect(effect).source.position.changed.add(this.updateClipPosition);
            this.updateClipPosition();
            this.playAnimation(false,1,false,true);
         }
      }
      
      private function updateClipPosition() : void
      {
         this.clip.x = MimesisTurretOpenEffect(effect).source.x;
         this.clip.y = MimesisTurretOpenEffect(effect).source.y;
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         MimesisTurretOpenEffect(effect).source.position.changed.remove(this.updateClipPosition);
         if(mapObjectView)
         {
            mapObjectView.visible = true;
         }
         super.disposeView(param1);
      }
   }
}

