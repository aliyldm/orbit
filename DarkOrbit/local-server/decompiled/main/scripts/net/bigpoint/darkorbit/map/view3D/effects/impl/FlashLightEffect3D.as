package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import away3d.entities.Mesh;
   import away3d.primitives.PlaneGeometry;
   import com.greensock.easing.Quad;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.effects.impl.FlashLightEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.utils.ExtMath;
   
   public class FlashLightEffect3D implements IUpdatable, IDisposable
   {
      
      private const FRAME_SIZE:Number = 10000;
      
      private var _view:MapView3D;
      
      private var _effect:FlashLightEffect;
      
      private var _overlay:Mesh;
      
      public function FlashLightEffect3D(param1:MapView3D, param2:FlashLightEffect)
      {
         super();
         this._effect = param2;
         this._view = param1;
         this._overlay = new Mesh(new PlaneGeometry(this.FRAME_SIZE,this.FRAME_SIZE,1,1,true,false),new FlashLightMaterial());
         this._overlay.zOffset = int.MAX_VALUE;
         this._overlay.shaderParams = {};
         this._overlay.shaderParams.rotation = this.map.hero.moveTrait.rotation.radians + Math.PI / 2;
         this._view.overlay.addChild(this._overlay);
         this._view.addUpdatable(this);
      }
      
      private function get map() : Map
      {
         return ScreenManager.getInstance().map;
      }
      
      public function updateObj(param1:Number) : void
      {
         if(this.map.hero)
         {
            this._overlay.x = this.map.hero.x3D;
            this._overlay.y = this.map.hero.y3D;
            this._overlay.z = this.map.hero.z3D;
            this._overlay.shaderParams.offsetU = 0;
            this._overlay.shaderParams.offsetV = -0.5 + 0.156;
            this._overlay.shaderParams.scaleU = this._overlay.shaderParams.scaleV = this.FRAME_SIZE / this._effect.range;
            this._overlay.shaderParams.rotation = Quad.easeOut(param1,this._overlay.shaderParams.rotation,ExtMath.getShortAngleRadians(this._overlay.shaderParams.rotation,this.map.hero.moveTrait.rotation.radians + Math.PI / 2),0.25);
         }
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         if(this._overlay)
         {
            this._overlay.parent.removeChild(this._overlay);
            this._overlay = null;
         }
         this._view.removeUpdatable(this);
      }
   }
}

import away3d.arcane;
import away3d.cameras.Camera3D;
import away3d.core.base.IRenderable;
import away3d.core.managers.Stage3DProxy;
import away3d.core.math.Matrix3DUtils;
import away3d.materials.MaterialBase;
import away3d.materials.passes.MaterialPassBase;
import away3d.textures.ATFTexture;
import away3d.textures.Texture2DBase;
import away3d.textures.TextureProxyBase;
import flash.display.BlendMode;
import flash.display3D.Context3D;
import flash.display3D.Context3DCompareMode;
import flash.display3D.Context3DProgramType;
import flash.display3D.Context3DTextureFormat;
import flash.geom.Matrix;
import flash.geom.Matrix3D;

use namespace arcane;

class FlashLightMaterial extends MaterialBase
{
   
   private static const TEX:Class = FlashLightMaterial_TEX;
   
   private var _pass:FlashLightMaterialPass;
   
   public function FlashLightMaterial()
   {
      super();
      this._pass = new FlashLightMaterialPass(new ATFTexture(new TEX()));
      addPass(this._pass);
      this.blendMode = BlendMode.LAYER;
      alphaPremultiplied = true;
      depthCompareMode = Context3DCompareMode.ALWAYS;
   }
   
   override public function set blendMode(param1:String) : void
   {
      super.blendMode = param1;
      this._pass.setBlendMode(blendMode == BlendMode.NORMAL && Boolean(requiresBlending) ? BlendMode.LAYER : blendMode);
   }
}

class FlashLightMaterialPass extends MaterialPassBase
{
   
   private var _texture:Texture2DBase;
   
   private const _uvTransform:Matrix = new Matrix();
   
   private const _matrix2d:Vector.<Number> = Vector.<Number>([1,0,0,0,1,0,0,0]);
   
   private const _translate:Vector.<Number> = Vector.<Number>([0,0,0.5,0.5]);
   
   private var _fragmentData:Vector.<Number> = new Vector.<Number>(4,true);
   
   public function FlashLightMaterialPass(param1:Texture2DBase)
   {
      super();
      this._texture = param1;
   }
   
   override arcane function activate(param1:Stage3DProxy, param2:Camera3D) : void
   {
      super.arcane::activate(param1,param2);
      param1._context3D.setTextureAt(0,this._texture.getTextureForStage3D(param1));
   }
   
   override arcane function render(param1:IRenderable, param2:Stage3DProxy, param3:Camera3D, param4:Matrix3D) : void
   {
      var _loc5_:Matrix3D = Matrix3DUtils.CALCULATION_MATRIX;
      _loc5_.copyFrom(param1.getRenderSceneTransform(param3));
      _loc5_.append(param4);
      param2._context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,0,_loc5_,true);
      var _loc6_:Object = param1.shaderParams;
      this._translate[0] = Number(_loc6_.offsetU) || 0;
      this._translate[1] = Number(_loc6_.offsetV) || 0;
      param2._context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,4,this._translate);
      this._uvTransform.identity();
      if(_loc6_.rotation != 0)
      {
         this._uvTransform.rotate(_loc6_.rotation);
      }
      if(_loc6_.scaleU != 1 || _loc6_.scaleV != 1)
      {
         this._uvTransform.scale(_loc6_.scaleU,_loc6_.scaleV);
      }
      this._matrix2d[0] = this._uvTransform.a;
      this._matrix2d[1] = this._uvTransform.b;
      this._matrix2d[3] = this._uvTransform.tx;
      this._matrix2d[4] = this._uvTransform.c;
      this._matrix2d[5] = this._uvTransform.d;
      this._matrix2d[7] = this._uvTransform.ty;
      param2._context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,8,this._matrix2d);
      this._fragmentData[0] = 0.5;
      this._fragmentData[1] = 0;
      param2._context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,this._fragmentData);
      param1.activateVertexBuffer(0,param2);
      param1.activateUVBuffer(1,param2);
      param2._context3D.drawTriangles(param1.getIndexBuffer(param2),0,param1.numTriangles);
   }
   
   override arcane function deactivate(param1:Stage3DProxy) : void
   {
      var _loc2_:Context3D = param1._context3D;
      _loc2_.setTextureAt(0,null);
      _loc2_.setVertexBufferAt(0,null);
      _loc2_.setVertexBufferAt(1,null);
      super.arcane::deactivate(param1);
   }
   
   override arcane function getVertexCode() : String
   {
      var _loc1_:String = "vt0";
      var _loc2_:String = "vc4";
      var _loc3_:String = "vc8";
      var _loc4_:String = "va1";
      var _loc5_:String = "v0";
      return ["mov " + _loc1_ + ", " + _loc4_,"sub " + _loc1_ + ".xy, " + _loc1_ + ".xy, " + _loc2_ + ".zw","m44 " + _loc1_ + ", " + _loc1_ + ", " + _loc3_,"add " + _loc1_ + ".xy, " + _loc1_ + ".xy, " + _loc2_ + ".xy","add " + _loc1_ + ".xy, " + _loc1_ + ".xy, " + _loc2_ + ".zw","mov " + _loc5_ + ", " + _loc1_,"m44 op, va0, vc0"].join("\n");
   }
   
   override arcane function getFragmentCode(param1:String) : String
   {
      return [this.getTex2DSampleCode("ft0","fs0",this._texture,"v0","clamp"),"sub ft0.w, fc0.xxxx, ft0.xxxx","mov ft0.xyz, fc0.yyyy","mov oc, ft0"].join("\n");
   }
   
   protected function getTex2DSampleCode(param1:String, param2:String, param3:TextureProxyBase, param4:String, param5:String) : String
   {
      var _loc7_:String = null;
      var _loc6_:String = param5;
      var _loc8_:String = this.getFormatStringForTexture(param3);
      var _loc9_:Boolean = Boolean(_mipmap) && param3.hasMipMaps;
      if(_smooth)
      {
         _loc7_ = _loc9_ ? "linear,miplinear" : "linear";
      }
      else
      {
         _loc7_ = _loc9_ ? "nearest,mipnearest" : "nearest";
      }
      return "tex " + param1 + ", " + param4 + ", " + param2 + " <2d," + _loc7_ + "," + _loc8_ + _loc6_ + ">\n";
   }
   
   private function getFormatStringForTexture(param1:TextureProxyBase) : String
   {
      switch(param1.format)
      {
         case Context3DTextureFormat.COMPRESSED:
            return "dxt1,";
         case "compressedAlpha":
            return "dxt5,";
         default:
            return "";
      }
   }
}
