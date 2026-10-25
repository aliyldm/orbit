package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.greensock.TweenLite;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.map.model.effects.impl.SphereShieldEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractShipEffect2D;
   import org.osflash.signals.ISignal;
   
   public class SphereShieldEffect2D extends AbstractShipEffect2D
   {
      
      private var _percentageSignal:ISignal;
      
      public var _percentageValue:Number = 0;
      
      private var _radius:uint;
      
      private var _fx:SphereShieldEffect;
      
      private var _percentageContainer:Sprite;
      
      private var _outerRingContainer:Sprite;
      
      private var _percentageMaskContainer:Sprite;
      
      public function SphereShieldEffect2D(param1:MapView2D, param2:SphereShieldEffect)
      {
         super(param1,param2,true,true,true);
         this._fx = param2;
         this._radius = param2.radius;
         this._percentageSignal = param2.percentageSignal;
         this._percentageSignal.add(this.updatePercentageValue);
         this._outerRingContainer = new Sprite();
         this._percentageContainer = new Sprite();
         this._percentageMaskContainer = new Sprite();
         shipView.addChild(this._outerRingContainer);
         shipView.addChild(this._percentageContainer);
         shipView.addChild(this._percentageMaskContainer);
         this._percentageContainer.cacheAsBitmap = true;
         this._percentageMaskContainer.cacheAsBitmap = true;
         this._percentageContainer.mask = this._percentageMaskContainer;
         this.updatePercentageValue(0);
      }
      
      private function updatePercentageValue(param1:uint) : void
      {
         TweenLite.to(this,1,{
            "_percentageValue":param1 / 100,
            "onUpdate":this.draw
         });
      }
      
      private function draw() : void
      {
         var _loc1_:Graphics = null;
         _loc1_ = this._outerRingContainer.graphics;
         _loc1_.clear();
         _loc1_.lineStyle(3,this._fx.OUTER_RING_COLOR,this._fx.OUTER_RING_ALPHA);
         _loc1_.drawCircle(0,0,this._radius);
         var _loc2_:Number = this._radius - 20;
         _loc1_ = this._percentageContainer.graphics;
         _loc1_.clear();
         _loc1_.lineStyle(16,this._fx.INNER_PERCENTAGE_RING_COLOR,this._fx.INNER_PERCENTAGE_RING_ALPHA);
         _loc1_.drawCircle(0,0,_loc2_);
         var _loc3_:Number = 1 - this._percentageValue;
         _loc1_ = this._percentageMaskContainer.graphics;
         _loc1_.clear();
         _loc1_.lineStyle(0,0,0);
         _loc1_.beginFill(16711680);
         _loc1_.moveTo(0,0);
         _loc1_.lineTo(-(this._radius * _loc3_),-this._radius);
         _loc1_.lineTo(-this._radius,-this._radius);
         _loc1_.lineTo(-this._radius,-(this._radius * _loc3_));
         _loc1_.endFill();
         _loc1_.beginFill(16711680);
         _loc1_.moveTo(0,0);
         _loc1_.lineTo(this._radius * _loc3_,-this._radius);
         _loc1_.lineTo(this._radius,-this._radius);
         _loc1_.lineTo(this._radius,-(this._radius * _loc3_));
         _loc1_.endFill();
         _loc1_.beginFill(16711680);
         _loc1_.moveTo(0,0);
         _loc1_.lineTo(this._radius * _loc3_,this._radius);
         _loc1_.lineTo(this._radius,this._radius);
         _loc1_.lineTo(this._radius,this._radius * _loc3_);
         _loc1_.endFill();
         _loc1_.beginFill(16711680);
         _loc1_.moveTo(0,0);
         _loc1_.lineTo(-(this._radius * _loc3_),this._radius);
         _loc1_.lineTo(-this._radius,this._radius);
         _loc1_.lineTo(-this._radius,this._radius * _loc3_);
         _loc1_.endFill();
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         TweenLite.killTweensOf(this);
         if(this._percentageSignal)
         {
            this._percentageSignal.removeAll();
            this._percentageSignal = null;
         }
         if(this._outerRingContainer)
         {
            shipView.removeChild(this._outerRingContainer);
            this._outerRingContainer = null;
         }
         if(this._percentageContainer)
         {
            shipView.removeChild(this._percentageContainer);
            this._percentageContainer = null;
         }
         if(this._percentageMaskContainer)
         {
            shipView.removeChild(this._percentageMaskContainer);
            this._percentageMaskContainer = null;
         }
         super.disposeView(param1);
      }
   }
}

