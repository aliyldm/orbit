package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import away3d.entities.Mesh;
   import away3d.materials.TextureMaterial;
   import away3d.primitives.PlaneGeometry;
   import away3d.textures.BitmapTexture;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Expo;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.SpreadMethod;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.model.effects.impl.MapObjectGlowRingEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
   
   public class MapObjectGlowRingEffect3D implements IDisposable, IUpdatable
   {
      
      private static var BITMAP_TEXTURE:BitmapTexture;
      
      private static const PLANE:PlaneGeometry = new PlaneGeometry(1,1,1,1);
      
      private const TYPE:String = "radial";
      
      private const ALPHAS:Array = [0,1,0];
      
      private const RATIOS:Array = [0,220,255];
      
      private const COLORS:Array = [4473924,16777215,13672553];
      
      private var _effect:MapObjectGlowRingEffect;
      
      private var _startRadius:Number = 80;
      
      private var _startAlpha:Number = 0.6;
      
      private var _radius:Number = 1024;
      
      private var _mesh:Mesh;
      
      private var _material:TextureMaterial;
      
      public function MapObjectGlowRingEffect3D(param1:MapView3D, param2:MapObjectGlowRingEffect)
      {
         var _loc4_:Shape = null;
         var _loc5_:Graphics = null;
         var _loc6_:Matrix = null;
         var _loc7_:Rectangle = null;
         var _loc8_:BitmapData = null;
         super();
         this._effect = param2;
         this._startRadius = this._effect.startDiameter;
         this._effect.source.entityDeactivated.add(this.removeSelf);
         this.ALPHAS[1] = param2.peakAlpha;
         if(BITMAP_TEXTURE == null)
         {
            _loc4_ = new Shape();
            _loc5_ = _loc4_.graphics;
            _loc6_ = new Matrix();
            _loc6_.createGradientBox(this._radius << 1,this._radius << 1,0,-this._radius,-this._radius);
            _loc5_.beginGradientFill(this.TYPE,this.COLORS,this.ALPHAS,this.RATIOS,_loc6_,SpreadMethod.PAD);
            _loc5_.drawCircle(0,0,this._radius);
            _loc5_.endFill();
            _loc7_ = _loc4_.getBounds(_loc4_);
            _loc8_ = new BitmapData(_loc4_.width,_loc4_.height,true,0);
            _loc8_.draw(_loc4_,new Matrix(1,0,0,1,-_loc7_.x,-_loc7_.y));
            BITMAP_TEXTURE = new BitmapTexture(_loc8_);
         }
         this._material = new TextureMaterial(BITMAP_TEXTURE);
         var _loc3_:ColorTransform = new ColorTransform(this.red,this.green,this.blue);
         this._material.colorTransform = _loc3_;
         this._mesh = new Mesh(PLANE,this._material);
         World3D.instance.mapView.gameWorld.addChild(this._mesh);
         this._mesh.moveTo(this._effect.position.x,this._effect.position.z,-this._effect.position.y);
         World3D.instance.mapView.addUpdatable(this);
         this.play();
      }
      
      private function get red() : Number
      {
         return (this._effect.ringColor >> 16 & 0xFF) / 255;
      }
      
      private function get green() : Number
      {
         return (this._effect.ringColor >> 8 & 0xFF) / 255;
      }
      
      private function get blue() : Number
      {
         return (this._effect.ringColor & 0xFF) / 255;
      }
      
      private function play() : void
      {
         this._material.alpha = this._startAlpha;
         this._mesh.scaleX = this._mesh.scaleZ = this._startRadius;
         if(this._effect.cycleTime <= 0)
         {
            this._mesh.scaleX = this._effect.endDiameter;
            this._mesh.scaleZ = this._effect.endDiameter;
         }
         else if(this._effect.explosionLike)
         {
            TweenMax.to(this._mesh,this._effect.cycleTime,{
               "ease":Expo.easeOut,
               "scaleX":this._effect.endDiameter,
               "scaleZ":this._effect.endDiameter,
               "onComplete":this.handleEffectComplete
            });
            TweenMax.to(this._material,this._effect.cycleTime,{
               "ease":Expo.easeOut,
               "alpha":this._effect.endAlpha
            });
         }
         else
         {
            TweenMax.to(this._mesh,this._effect.cycleTime,{
               "scaleX":this._effect.endDiameter,
               "scaleZ":this._effect.endDiameter,
               "onComplete":this.handleEffectComplete
            });
            TweenMax.to(this._material,this._effect.cycleTime,{"alpha":this._effect.endAlpha});
         }
      }
      
      private function handleEffectComplete() : void
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
      
      public function disposeView(param1:Boolean = false) : void
      {
         World3D.instance.mapView.removeUpdatable(this);
         TweenLite.killTweensOf(this._mesh);
         TweenLite.killTweensOf(this._material);
         if(param1 == false)
         {
            TweenMax.to(this._material,0.5,{
               "alpha":0,
               "onComplete":this.removeMesh
            });
         }
         else
         {
            this.removeMesh();
         }
      }
      
      private function removeMesh() : void
      {
         if(this._mesh.parent)
         {
            this._mesh.parent.removeChild(this._mesh);
         }
      }
      
      public function updateObj(param1:Number) : void
      {
         if(this._effect.source)
         {
            this._mesh.moveTo(this._effect.source.x3D,this._effect.source.y3D,this._effect.source.z3D);
         }
      }
      
      protected function removeSelf() : *
      {
         this._effect.source.entityDeactivated.remove(this.removeSelf);
         this.disposeView(true);
      }
   }
}

