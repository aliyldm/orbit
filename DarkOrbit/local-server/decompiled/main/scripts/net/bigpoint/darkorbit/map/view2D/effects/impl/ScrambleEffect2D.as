package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.greensock.TweenMax;
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.darkorbit.map.model.effects.impl.ScrambleEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   
   public class ScrambleEffect2D extends AbstractMapObjectEffect2D
   {
      
      private var _shipContainer:DisplayObjectContainer;
      
      public function ScrambleEffect2D(param1:MapView2D, param2:ScrambleEffect)
      {
         super(param1,param2);
         if(mapObjectView != null)
         {
            this._shipContainer = mapObjectView;
            if(this._shipContainer != null)
            {
               TweenMax.to(this._shipContainer,1,{
                  "alpha":0.2,
                  "repeat":-1,
                  "yoyo":true
               });
            }
         }
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         TweenMax.killTweensOf(this._shipContainer);
         this._shipContainer.alpha = 1;
         super.disposeView(param1);
      }
   }
}

