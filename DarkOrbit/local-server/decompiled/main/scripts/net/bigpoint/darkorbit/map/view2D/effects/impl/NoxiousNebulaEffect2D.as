package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.greensock.TweenMax;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.SpreadMethod;
   import flash.geom.Matrix;
   import net.bigpoint.darkorbit.map.model.effects.impl.NoxiousNebulaEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractEffect2D;
   
   public class NoxiousNebulaEffect2D extends AbstractEffect2D
   {
      
      private const TYPE:String = "radial";
      
      private const ALPHAS:Array = [0,NoxiousNebulaEffect.PEAK_ALPHA,0];
      
      private const RATIOS:Array = [0,220,255];
      
      private const COLOURS:Array = [4473924,NoxiousNebulaEffect.RING_COLOUR,13672553];
      
      private const RADIUS:Number = 2048;
      
      private const START_ALPHA:Number = 0.6;
      
      private var _mapView:MapView2D;
      
      private var _effect:NoxiousNebulaEffect;
      
      private var _ringContainer:Shape;
      
      public function NoxiousNebulaEffect2D(param1:MapView2D, param2:NoxiousNebulaEffect)
      {
         this._mapView = param1;
         this._effect = param2;
         super(this._mapView,this._effect);
      }
      
      override protected function initEffectVisuals() : void
      {
         this.start();
      }
      
      override protected function start() : void
      {
         var _loc1_:Graphics = null;
         var _loc2_:Matrix = null;
         var _loc3_:String = null;
         if(this._ringContainer == null)
         {
            this._ringContainer = new Shape();
            _loc1_ = this._ringContainer.graphics;
            _loc2_ = new Matrix();
            _loc2_.createGradientBox(this.RADIUS << 1,this.RADIUS << 1,0,-this.RADIUS,-this.RADIUS);
            _loc3_ = SpreadMethod.PAD;
            _loc1_.beginGradientFill(this.TYPE,this.COLOURS,this.ALPHAS,this.RATIOS,_loc2_,_loc3_);
            _loc1_.drawCircle(0,0,this.RADIUS);
            _loc1_.endFill();
            addChild(this._ringContainer);
         }
         this.play();
      }
      
      private function play() : void
      {
         this.addAndPosition();
         this._ringContainer.alpha = this.START_ALPHA;
         this._ringContainer.width = this._effect.diameter;
         this._ringContainer.height = this._effect.diameter;
      }
      
      private function addAndPosition() : void
      {
         if(this._mapView != null)
         {
            this._mapView.fxLayer.addChild(this);
            this.x = this._effect.position.x;
            this.y = this._effect.position.y;
            this.z = this._effect.position.z;
         }
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         if(param1 == false && this._ringContainer != null)
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
   }
}

