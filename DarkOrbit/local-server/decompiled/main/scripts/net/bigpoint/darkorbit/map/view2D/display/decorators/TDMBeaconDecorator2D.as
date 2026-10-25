package net.bigpoint.darkorbit.map.view2D.display.decorators
{
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view2D.display.IMapUberAssetDecorator2D;
   import net.bigpoint.darkorbit.map.view2D.display.uber.UberAsset2D;
   import net.bigpoint.darkorbit.map.view2D.display.uber.UberDisplayObject2D;
   
   public class TDMBeaconDecorator2D extends Sprite implements IMapUberAssetDecorator2D, IUpdatable, IDisposable
   {
      
      private var phase1:Number;
      
      private var phase2:Number;
      
      private var frameSwitchTimer:uint;
      
      private var _viewOwner:UberAsset2D;
      
      private var _startY:Number;
      
      private var _target:MovieClip;
      
      private var _data:Object;
      
      public function TDMBeaconDecorator2D()
      {
         super();
      }
      
      public function decorateUberAsset(param1:UberDisplayTrait, param2:UberAsset2D, param3:Object) : void
      {
         this._viewOwner = param2;
         this._data = param3;
         this.phase1 = Math.random() * 10;
         this.phase2 = Math.random() * 10;
         this.frameSwitchTimer = this.getRandomTimeForFrame1();
         var _loc4_:UberDisplayObject2D = UberDisplayObject2D(this._viewOwner.getViewElement(String(this._data.xml.@target)));
         if(_loc4_)
         {
            this._target = _loc4_.asset as MovieClip;
            if(this._target)
            {
               this._startY = this._target.y;
               this.tintIn();
            }
         }
         else
         {
            TweenLite.killTweensOf(this._target);
            this._target = null;
         }
      }
      
      public function updateObj(param1:Number) : void
      {
         var _loc4_:MovieClip = null;
         var _loc5_:uint = 0;
         if(this._target == null)
         {
            return;
         }
         this.phase1 += 0.1;
         this.phase2 += 0.03;
         var _loc2_:Number = Math.cos(this.phase2) * 1.5;
         var _loc3_:Number = Math.sin(this.phase1) * 2.8;
         this._target.y = this._startY + _loc3_ - _loc2_;
         if(this.frameSwitchTimer > 0)
         {
            --this.frameSwitchTimer;
         }
         else if(this.frameSwitchTimer == 0)
         {
            _loc4_ = MovieClip(this._target.getChildByName("logo"));
            if(!_loc4_)
            {
               return;
            }
            if(_loc4_.currentFrame == 1)
            {
               _loc5_ = 2;
               this.frameSwitchTimer = this.getRandomTimeForFrame2();
            }
            else if(_loc4_.currentFrame == 2)
            {
               _loc5_ = 1;
               this.frameSwitchTimer = this.getRandomTimeForFrame1();
            }
            _loc4_.gotoAndStop(_loc5_);
         }
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         if(this._target)
         {
            TweenLite.killTweensOf(this._target);
         }
      }
      
      private function tintIn() : void
      {
         TweenMax.to(this._target,0.2,{
            "delay":1 + Math.random() * 3,
            "colorMatrixFilter":{
               "amount":1.3,
               "contrast":1.7,
               "brightness":1.5
            },
            "onComplete":this.tintOut
         });
      }
      
      private function tintOut() : void
      {
         TweenMax.to(this._target,0.8,{
            "colorMatrixFilter":{
               "amount":1,
               "contrast":1,
               "brightness":1
            },
            "onComplete":this.tintIn
         });
      }
      
      private function getRandomTimeForFrame1() : uint
      {
         return 10 + uint(Math.random() * 120);
      }
      
      private function getRandomTimeForFrame2() : uint
      {
         return 3 + uint(Math.random() * 10);
      }
   }
}

