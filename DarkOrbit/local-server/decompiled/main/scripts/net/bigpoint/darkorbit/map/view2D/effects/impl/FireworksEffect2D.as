package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.bitmapclip.BitmapClip;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.impl.FireworksEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractEffect2D;
   
   public class FireworksEffect2D extends AbstractEffect2D
   {
      
      public function FireworksEffect2D(param1:MapView2D, param2:Effect, param3:Boolean = true)
      {
         super(param1,param2,param3);
      }
      
      override protected function initEffectVisuals() : void
      {
         var _loc1_:FireworksEffect = effect as FireworksEffect;
         this.attachClip(mapView.fxLayer,_loc1_.patterns.concat(),_loc1_.x,_loc1_.y);
      }
      
      private function attachClip(param1:Sprite, param2:Vector.<String>, param3:int, param4:int) : void
      {
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:DisplayObject = null;
         var _loc9_:int = 0;
         var _loc10_:Number = NaN;
         if(param2.length > 0)
         {
            _loc6_ = param2[0];
            if(!ResourceManager.isLoaded(_loc6_))
            {
               ResourceManager.loadAndCall(_loc6_,this.attachClip,arguments);
               return;
            }
            _loc7_ = param2.shift();
            _loc8_ = new BitmapClip(ResourceManager.getMovieClip(_loc7_,"mc"),_loc7_);
            _loc9_ = (_loc8_ as BitmapClip).framesLoaded;
            _loc8_.x = param3;
            _loc8_.y = param4;
            param1.addChild(_loc8_);
            _loc10_ = _loc9_ / 30;
            TweenLite.to(_loc8_,_loc10_,{
               "ease":Linear.easeNone,
               "frame":_loc9_,
               "onComplete":this.handleAnimationFinished,
               "onCompleteParams":[_loc8_,param2,param3,param4]
            });
            AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_FIREWORK);
         }
      }
      
      private function handleAnimationFinished(param1:DisplayObject, param2:Vector.<String>, param3:int, param4:int) : void
      {
         var _loc5_:Sprite = param1.parent as Sprite;
         _loc5_.removeChild(param1);
         this.attachClip(_loc5_,param2,param3,param4);
      }
   }
}

