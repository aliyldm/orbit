package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.bigpoint.utils.PointLite;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Expo;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.SpreadMethod;
   import flash.geom.Matrix;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.impl.MapObjectGlowRingEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractEffect2D;
   
   public class MapObjectGlowRingEffect2D extends AbstractEffect2D
   {
      
      private const TYPE:String = "radial";
      
      private const ALPHAS:Array = [0,1,0];
      
      private const RATIOS:Array = [0,220,255];
      
      private var _colors:Array = [4473924,16777215,13672553];
      
      private var _ringColor:uint;
      
      private var _startRadius:Number = 80;
      
      private var _startAlpha:Number = 0.6;
      
      private var _endDiameter:Number = 3500;
      
      private var _radius:Number = 2048;
      
      private var _position:PointLite;
      
      private var _cycleTime:Number = 4;
      
      private var _activate:Boolean;
      
      private var _explosionLike:Boolean = false;
      
      private var _view:MapView2D;
      
      private var _ringContainer:Shape;
      
      private var _effect:MapObjectGlowRingEffect;
      
      public function MapObjectGlowRingEffect2D(param1:MapView2D, param2:MapObjectGlowRingEffect)
      {
         this._view = param1;
         this._position = param2.position;
         this._endDiameter = param2.endDiameter;
         this._ringColor = param2.ringColor;
         this._explosionLike = param2.explosionLike;
         this._cycleTime = param2.cycleTime;
         this._colors[1] = param2.ringColor;
         this.ALPHAS[1] = param2.peakAlpha;
         this._startRadius = (param2 as MapObjectGlowRingEffect).startDiameter;
         this._effect = param2;
         if(param2.loop)
         {
            param2.source.entityDeactivated.add(this.removeSelf);
         }
         super(param1,param2);
      }
      
      override protected function initEffectVisuals() : void
      {
         this.start();
      }
      
      private function addAndPosition() : void
      {
         if(parent == null && this._view != null)
         {
            if((effect as MapObjectGlowRingEffect).source)
            {
               (effect as MapObjectGlowRingEffect).source.position.changed.add(this.handlePositionChanged);
               this.handlePositionChanged();
            }
            this._view.fxLayer.addChild(this);
         }
         if(this._view != null)
         {
            x = this._position.x;
            y = this._position.y;
         }
      }
      
      private function handlePositionChanged() : void
      {
         if(this.mapObject)
         {
            this.x = this.mapObject.position.x;
            this.y = this.mapObject.position.y;
         }
      }
      
      override protected function start() : void
      {
         var _loc1_:Graphics = null;
         var _loc2_:Matrix = null;
         var _loc3_:String = null;
         this._activate = true;
         if(this._ringContainer == null)
         {
            this._ringContainer = new Shape();
            _loc1_ = this._ringContainer.graphics;
            _loc2_ = new Matrix();
            _loc2_.createGradientBox(this._radius << 1,this._radius << 1,0,-this._radius,-this._radius);
            _loc3_ = SpreadMethod.PAD;
            _loc1_.beginGradientFill(this.TYPE,this._colors,this.ALPHAS,this.RATIOS,_loc2_,_loc3_);
            _loc1_.drawCircle(0,0,this._radius);
            _loc1_.endFill();
            addChild(this._ringContainer);
         }
         this.play();
      }
      
      private function play() : void
      {
         this.addAndPosition();
         this._ringContainer.alpha = this._startAlpha;
         this._ringContainer.width = this._startRadius;
         this._ringContainer.height = this._startRadius;
         if((effect as MapObjectGlowRingEffect).cycleTime <= 0)
         {
            this._ringContainer.width = this._endDiameter;
            this._ringContainer.height = this._endDiameter;
         }
         else if(this._explosionLike)
         {
            TweenLite.to(this._ringContainer,this._cycleTime,{
               "ease":Expo.easeOut,
               "width":this._endDiameter,
               "height":this._endDiameter,
               "alpha":this._effect.endAlpha,
               "onComplete":this.handleEffectComplete
            });
         }
         else
         {
            TweenLite.to(this._ringContainer,this._cycleTime,{
               "width":this._endDiameter,
               "height":this._endDiameter,
               "alpha":this._effect.endAlpha,
               "onComplete":this.handleEffectComplete
            });
         }
      }
      
      protected function handleEffectComplete() : void
      {
         if(this._effect.loop)
         {
            this.play();
         }
         else
         {
            this.disposeView();
         }
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         if(this.mapObject)
         {
            this.mapObject.position.changed.remove(this.handlePositionChanged);
         }
         TweenLite.killTweensOf(this._ringContainer);
         if(param1 == false)
         {
            TweenMax.to(this._ringContainer,0.5,{
               "alpha":0,
               "onComplete":this.remove
            });
         }
         else
         {
            this.remove();
         }
      }
      
      private function remove() : void
      {
         super.disposeView(false);
      }
      
      public function get activate() : Boolean
      {
         return this._activate;
      }
      
      public function set activate(param1:Boolean) : void
      {
         this._activate = param1;
      }
      
      protected function get mapObject() : MapEntity
      {
         return (effect as MapObjectGlowRingEffect).source;
      }
      
      protected function removeSelf() : void
      {
         (effect as MapObjectGlowRingEffect).source.entityDeactivated.remove(this.removeSelf);
         this.disposeView(true);
      }
   }
}

