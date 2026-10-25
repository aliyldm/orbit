package net.bigpoint.darkorbit.map.view2D.effects.impl.drive
{
   import com.greensock.TweenMax;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.map.model.effects.impl.drive.DriveAreaEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.CompactEffectGeometry2D;
   import net.bigpoint.darkorbit.map.view2D.effects.EffectRange2D;
   import net.bigpoint.darkorbit.map.view2D.effects.SharedAreaAnimation2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.PersistentEffect2D;
   
   public class DriveAreaEffect2D extends PersistentEffect2D
   {
      
      private var areaEffect:DriveAreaEffect;
      
      public function DriveAreaEffect2D(param1:MapView2D, param2:DriveAreaEffect)
      {
         this.areaEffect = param2;
         super(param1,param2,param2.pattern.resKey,param2.source.position);
         TweenMax.delayedCall(0.25,this.pollRange);
         if(param1.entitiesLayer.parent)
         {
            param1.entitiesLayer.parent.addChildAt(this,param1.entitiesLayer.parent.getChildIndex(param1.entitiesLayer));
         }
      }
      
      override protected function shouldRender() : Boolean
      {
         return Boolean(this.areaEffect) && Boolean(this.areaEffect.source) && EffectRange2D.near(this.areaEffect.source.position,800);
      }
      
      private function pollRange() : void
      {
         if(disposed)
         {
            return;
         }
         refreshRange();
         TweenMax.delayedCall(0.25,this.pollRange);
      }
      
      override protected function onResourceLoaded(param1:SWFFinisher) : void
      {
         super.onResourceLoaded(param1);
         if(disposed || !_mc || !this.areaEffect)
         {
            return;
         }
         this._mc.scaleX = this._mc.scaleY = this.areaEffect.scale * this.areaEffect.pattern.scale2D;
         CompactEffectGeometry2D.area(this,_mc,this.areaEffect.pattern.resKey);
         SharedAreaAnimation2D.attach(this,_mc);
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         TweenMax.killTweensOf(this.pollRange);
         this.areaEffect = null;
         super.disposeView(param1);
      }
   }
}

