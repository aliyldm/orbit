package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.greensock.TweenNano;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   import net.bigpoint.darkorbit.mvc.battleStation.BattleStation;
   import net.bigpoint.darkorbit.mvc.battleStation.BattleStationModule;
   
   public class DeflectorShieldEffect2D extends AbstractMapObjectEffect2D
   {
      
      public function DeflectorShieldEffect2D(param1:MapView2D, param2:MapObjectEffect)
      {
         super(param1,param2,true,true,true);
      }
      
      override protected function initEffectVisuals() : void
      {
         if(mapObject is BattleStation)
         {
            effectMc.scaleX = 1.94;
            effectMc.scaleY = 1.94;
         }
         else if(mapObject is BattleStationModule)
         {
            effectMc.scaleX = 1.16;
            effectMc.scaleY = 1.16;
         }
         else
         {
            effectMc.scaleX = 1;
            effectMc.scaleY = 1;
         }
         start();
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         TweenNano.killTweensOf(clip);
         TweenNano.killTweensOf(this);
         TweenNano.to(this,0.5,{
            "alpha":0,
            "onComplete":super.disposeView
         });
      }
      
      override public function playAnimation(param1:Boolean = true, param2:int = 1, param3:Boolean = true, param4:Boolean = false, param5:Boolean = false) : void
      {
         if(mapObject is BattleStation)
         {
            super.playAnimation(param1,param2,param3,param4,param5);
         }
         else
         {
            TweenNano.killTweensOf(clip);
            clip.visible = true;
            clip.alpha = 0;
            this.fadeInAndOut();
         }
      }
      
      public function fadeInAndOut() : void
      {
         TweenNano.to(clip,3,{
            "alpha":(clip.alpha == 1 ? 0.2 : 1),
            "onComplete":this.fadeInAndOut
         });
      }
   }
}

