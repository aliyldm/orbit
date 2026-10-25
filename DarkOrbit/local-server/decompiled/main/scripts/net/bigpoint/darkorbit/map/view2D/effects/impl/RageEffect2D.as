package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.greensock.TweenMax;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   
   public class RageEffect2D extends AbstractMapObjectEffect2D
   {
      
      private var _tween:TweenMax;
      
      public function RageEffect2D(param1:MapView2D, param2:MapObjectEffect)
      {
         super(param1,param2);
      }
      
      override protected function initEffectVisuals() : void
      {
         var _loc1_:Sprite = mapObjectView;
         if(_loc1_ != null)
         {
            this._tween = TweenMax.to(_loc1_,0.5,{
               "yoyo":true,
               "repeat":-1,
               "glowFilter":{
                  "color":16711680,
                  "alpha":1,
                  "blurX":20,
                  "blurY":20
               }
            });
         }
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         if(this._tween != null)
         {
            this._tween.kill();
            this._tween = null;
         }
         var _loc2_:Sprite = mapObjectView;
         if(_loc2_ != null)
         {
            _loc2_.filters = null;
         }
         super.disposeView(param1);
      }
   }
}

