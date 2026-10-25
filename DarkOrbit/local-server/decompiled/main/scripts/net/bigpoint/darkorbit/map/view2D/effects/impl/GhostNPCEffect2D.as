package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.greensock.TweenMax;
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   
   public class GhostNPCEffect2D extends AbstractMapObjectEffect2D
   {
      
      private var _tween:TweenMax;
      
      public function GhostNPCEffect2D(param1:MapView2D, param2:MapObjectEffect)
      {
         super(param1,param2);
         this.startTween();
      }
      
      private function startTween() : void
      {
         this.forwardTween();
      }
      
      private function forwardTween() : void
      {
         var _loc1_:DisplayObjectContainer = null;
         if(mapObjectView != null)
         {
            if(this._tween != null)
            {
               this._tween.kill();
               this._tween = null;
            }
            _loc1_ = mapObjectView;
            if(_loc1_ != null)
            {
               this._tween = TweenMax.to(_loc1_,2,{
                  "alpha":0.4,
                  "onComplete":this.rewindTween
               });
            }
         }
      }
      
      private function rewindTween() : void
      {
         var _loc1_:DisplayObjectContainer = null;
         if(mapObjectView != null)
         {
            if(this._tween != null)
            {
               this._tween.kill();
               this._tween = null;
            }
            _loc1_ = mapObjectView;
            if(_loc1_ != null)
            {
               this._tween = TweenMax.to(_loc1_,2,{
                  "alpha":0.4,
                  "onComplete":this.forwardTween
               });
            }
         }
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         if(mapObjectView != null)
         {
            if(this._tween != null)
            {
               this._tween.kill();
               this._tween = null;
            }
            TweenMax.to(mapObjectView,1,{"alpha":1});
         }
         super.disposeView(param1);
      }
   }
}

