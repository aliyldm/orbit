package net.bigpoint.darkorbit.map.hud.effects.impl
{
   import com.greensock.easing.Quad;
   import flash.display.Bitmap;
   import flash.display.BlendMode;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.IMapView;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.effects.impl.FlashLightEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view3D.utils.ExtMath;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class FlashLightEffect2D extends Sprite implements IUpdatable, IDisposable
   {
      
      private static const TEX:Class = FlashLightEffect2D_TEX;
      
      private var _effect:FlashLightEffect;
      
      private var _overlay:Sprite;
      
      private var _mapView:IMapView;
      
      public function FlashLightEffect2D(param1:IMapView, param2:FlashLightEffect)
      {
         var _loc3_:Bitmap = null;
         super();
         this._effect = param2;
         this._mapView = param1;
         this._overlay = new Sprite();
         this._overlay.blendMode = BlendMode.LAYER;
         this._overlay.transform.colorTransform = new ColorTransform(1,1,1,-1,0,0,0,255);
         this._overlay.graphics.beginFill(0,0.4);
         this._overlay.graphics.drawCircle(0,0,4000);
         this._overlay.graphics.endFill();
         _loc3_ = new TEX();
         _loc3_.smoothing = true;
         _loc3_.scaleX = _loc3_.scaleY = this._effect.range / _loc3_.width;
         _loc3_.x = -128 * _loc3_.scaleX;
         _loc3_.y = -40 * _loc3_.scaleY;
         this._overlay.addChild(_loc3_);
         MapView2D.fxLayer.addChild(this._overlay);
         this._mapView.addUpdatable(this);
      }
      
      private function get map() : Map
      {
         return ScreenManager.getInstance().map;
      }
      
      public function updateObj(param1:Number) : void
      {
         if(this.map.hero)
         {
            this._overlay.x = this.map.hero.x;
            this._overlay.y = this.map.hero.y;
            this._overlay.rotation = Quad.easeOut(param1,this._overlay.rotation,ExtMath.getShortAngleDegrees(this._overlay.rotation,this.map.hero.moveTrait.rotation.degrees + 90),0.25);
            MapView2D.fxLayer.addChild(this._overlay);
         }
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         MovieClipUtils.removeDisplayObject(this._overlay);
         this._overlay = null;
         this._mapView.removeUpdatable(this);
      }
   }
}

