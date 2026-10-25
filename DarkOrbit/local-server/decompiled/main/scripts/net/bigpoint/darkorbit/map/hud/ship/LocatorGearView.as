package net.bigpoint.darkorbit.map.hud.ship
{
   import com.bigpoint.utils.PointLite;
   import com.greensock.TweenLite;
   import com.greensock.easing.Strong;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.LocatorGearEffect;
   import net.bigpoint.darkorbit.map.model.traits.LocatorGearTrait;
   
   public class LocatorGearView extends Sprite implements IDisposable
   {
      
      private const RADTODEG:Number = 57.29577951308232;
      
      private var effectMc:MovieClip;
      
      private var _effect:LocatorGearEffect;
      
      public function LocatorGearView(param1:LocatorGearTrait, param2:DisplayObject)
      {
         super();
         this._effect = param1.effect;
         this.load();
      }
      
      private function load() : void
      {
         ResourceManager.fileCollection.load("locator",this.resourceLoadedHandler);
      }
      
      private function resourceLoadedHandler(param1:SWFFinisher) : void
      {
         var _loc2_:Bitmap = null;
         var _loc3_:Sprite = null;
         var _loc4_:MovieClip = null;
         if(param1.hasEmbeddedObject("mc"))
         {
            this.effectMc = param1.getEmbeddedMovieClip("mc");
            addChild(this.effectMc);
            this.alpha = 0;
            TweenLite.to(this.effectMc,0.5,{"autoAlpha":1});
            _loc2_ = this._effect.icon;
            _loc3_ = new Sprite();
            _loc4_ = SWFFinisher(ResourceManager.fileCollection.getFinisher("locator")).getEmbeddedMovieClip("iconframe");
            _loc2_.x = -_loc2_.width * 0.5;
            _loc2_.y = -_loc2_.height * 0.5;
            _loc3_.y = -110;
            _loc3_.addChild(_loc4_);
            _loc3_.addChild(_loc2_);
            this.effectMc.addChild(_loc3_);
            this.y = -20;
            this.effectMc.addChild(_loc3_);
            this._effect.update.add(this.updateTargetPosition);
         }
      }
      
      public function updateTargetPosition(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc8_:int = 0;
         _loc3_ = param1;
         var _loc4_:int = param2;
         var _loc5_:PointLite = (this._effect as MapObjectEffect).source.position;
         var _loc6_:int = _loc5_.x;
         var _loc7_:int = _loc5_.y;
         var _loc9_:Number = 0.2;
         if(_loc3_ == -1 && _loc4_ == -1)
         {
            this.alpha = _loc9_;
         }
         else
         {
            this.alpha = 1;
            _loc8_ = Math.round(Math.atan2(_loc4_ - _loc7_,_loc6_ - _loc3_) * this.RADTODEG) + 90;
            if(_loc8_ != Math.round(this.effectMc.rotation) && _loc8_ != 360 + Math.round(this.effectMc.rotation))
            {
               TweenLite.to(this.effectMc,1,{
                  "rotation":-_loc8_,
                  "ease":Strong.easeOut
               });
            }
         }
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         TweenLite.killTweensOf(this._effect);
         this._effect.update.remove(this.updateTargetPosition);
      }
   }
}

