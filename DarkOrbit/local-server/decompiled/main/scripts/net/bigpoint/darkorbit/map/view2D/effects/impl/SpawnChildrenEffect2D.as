package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.impl.SpawnChildrenEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class SpawnChildrenEffect2D extends AbstractMapObjectEffect2D
   {
      
      private var _fadeInOut:Boolean = false;
      
      private var _disposed:Boolean;
      
      public function SpawnChildrenEffect2D(param1:MapView2D, param2:SpawnChildrenEffect)
      {
         if(Boolean(param2.source) && Settings.qualityShip.value == Settings.QUALITY_HIGH)
         {
            param2.pattern = new EffectPattern(EffectIDList.SPAWN_CHILDREN_EFFECT,"startSpawnChildrenShip" + Ship(param2.source).shipPattern.getPatternID());
         }
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
            SpawnChildrenEffect(effect).source.position.changed.add(this.updateClipPosition);
            this.updateClipPosition();
            this.playAnimation(false,1,this._fadeInOut,false);
         }
      }
      
      private function updateClipPosition() : void
      {
         this.clip.x = SpawnChildrenEffect(effect).source.x;
         this.clip.y = SpawnChildrenEffect(effect).source.y;
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         SpawnChildrenEffect(effect).source.position.changed.remove(this.updateClipPosition);
         if(mapObjectView)
         {
            mapObjectView.visible = true;
         }
         if(Boolean(!param1) && Boolean(effectMc) && !this._disposed)
         {
            this._disposed = true;
            this.playAnimation(false,effectMc.totalFrames,this._fadeInOut,true,true);
         }
         else
         {
            super.disposeView(param1);
         }
      }
   }
}

