package net.bigpoint.darkorbit.map.view3D.display3D.materials
{
   import away3d.materials.MaterialBase;
   import away3d.textures.BitmapTexture;
   import away3d.textures.Texture2DBase;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import org.osflash.signals.ISignal;
   
   public class AnimatedCloudMaterial extends MaterialBase implements ITextureMaterial
   {
      
      public static const offsetBitmapData:BitmapData = new BitmapData(128,128,false,0);
      
      offsetBitmapData.perlinNoise(128,128,4,Math.random() * 1000,true,true,7,true);
      
      private const SUPPORTED_TEXTURES:Vector.<String> = Vector.<String>(["diffuse"]);
      
      private var _pass:AnimatedCloudMaterialPass;
      
      public function AnimatedCloudMaterial()
      {
         super();
         this._pass = new AnimatedCloudMaterialPass(new BitmapTexture(offsetBitmapData,true));
         addPass(this._pass);
         this.blendMode = BlendMode.LAYER;
         alphaPremultiplied = false;
      }
      
      override public function set blendMode(param1:String) : void
      {
         super.blendMode = param1;
         this._pass.setBlendMode(blendMode == BlendMode.NORMAL && this.requiresBlending ? BlendMode.LAYER : blendMode);
      }
      
      override public function get requiresBlending() : Boolean
      {
         return true;
      }
      
      public function get supportedTextures() : Vector.<String>
      {
         return this.SUPPORTED_TEXTURES;
      }
      
      public function get supportedTexturesChanged() : ISignal
      {
         return null;
      }
      
      public function setShaderParams(param1:XML) : void
      {
      }
      
      public function setTexture(param1:String, param2:Texture2DBase) : void
      {
         if(param1 == "diffuse")
         {
            this._pass.diffuse = param2;
         }
      }
      
      public function get pass() : AnimatedCloudMaterialPass
      {
         return this._pass;
      }
   }
}

import away3d.arcane;
import away3d.cameras.Camera3D;
import away3d.core.base.IRenderable;
import away3d.core.managers.Stage3DProxy;
import away3d.core.math.Matrix3DUtils;
import away3d.materials.passes.MaterialPassBase;
import away3d.textures.Texture2DBase;
import away3d.textures.TextureProxyBase;
import flash.display3D.Context3D;
import flash.display3D.Context3DCompareMode;
import flash.display3D.Context3DProgramType;
import flash.display3D.Context3DTextureFormat;
import flash.geom.Matrix3D;
import flash.utils.getTimer;

use namespace arcane;

class AnimatedCloudMaterialPass extends MaterialPassBase
{
   
   public var timeScale:Number = 180;
   
   public var border:Number = 0.1;
   
   private var _offsetTex:Texture2DBase;
   
   private var _texture:Texture2DBase;
   
   private var _fragmentData:Vector.<Number> = new Vector.<Number>(4,true);
   
   public function AnimatedCloudMaterialPass(param1:Texture2DBase)
   {
      super();
      this._offsetTex = param1;
      writeDepth = false;
      depthCompareMode = Context3DCompareMode.LESS_EQUAL;
   }
   
   override arcane function getVertexCode() : String
   {
      return ["m44 op, va0, vc0","mov v0, va1"].join("\n") + "\n";
   }
   
   public function set diffuse(param1:Texture2DBase) : void
   {
      if(Boolean(param1) != Boolean(this._texture) || Boolean(param1 && this._texture) && (Boolean(param1.hasMipMaps != this._texture.hasMipMaps || param1.format != this._texture.format)))
      {
         arcane::invalidateShaderProgram();
      }
      this._texture = param1;
   }
   
   public function get diffuse() : Texture2DBase
   {
      return this._texture;
   }
   
   override arcane function activate(param1:Stage3DProxy, param2:Camera3D) : void
   {
      super.arcane::activate(param1,param2);
      if(this._texture)
      {
         param1._context3D.setTextureAt(0,this._texture.getTextureForStage3D(param1));
         param1._context3D.setTextureAt(1,this._offsetTex.getTextureForStage3D(param1));
         this._fragmentData[0] = getTimer() / 1000 / this.timeScale;
         this._fragmentData[1] = this.border;
         this._fragmentData[2] = 1;
      }
      else
      {
         this._fragmentData[0] = 1;
         this._fragmentData[1] = 0;
         this._fragmentData[2] = 0;
         this._fragmentData[3] = 1;
      }
      param1._context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,this._fragmentData);
   }
   
   override arcane function render(param1:IRenderable, param2:Stage3DProxy, param3:Camera3D, param4:Matrix3D) : void
   {
      var _loc5_:Matrix3D = Matrix3DUtils.CALCULATION_MATRIX;
      _loc5_.copyFrom(param1.getRenderSceneTransform(param3));
      _loc5_.append(param4);
      param2._context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,0,_loc5_,true);
      param1.activateVertexBuffer(0,param2);
      param1.activateUVBuffer(1,param2);
      param2._context3D.drawTriangles(param1.getIndexBuffer(param2),0,param1.numTriangles);
   }
   
   override arcane function deactivate(param1:Stage3DProxy) : void
   {
      var _loc2_:Context3D = param1._context3D;
      if(this._texture)
      {
         _loc2_.setTextureAt(0,null);
         _loc2_.setTextureAt(1,null);
      }
      _loc2_.setVertexBufferAt(0,null);
      _loc2_.setVertexBufferAt(1,null);
      super.arcane::deactivate(param1);
   }
   
   override arcane function getFragmentCode(param1:String) : String
   {
      var _loc3_:String = null;
      var _loc4_:String = null;
      var _loc5_:String = null;
      var _loc6_:String = null;
      var _loc7_:String = null;
      var _loc8_:String = null;
      var _loc2_:String = "fc0";
      if(this._texture)
      {
         _loc3_ = "fs0";
         _loc4_ = "fs1";
         _loc5_ = "ft0";
         _loc6_ = "ft1";
         _loc7_ = "v0";
         _loc8_ = [this.getTex2DSampleCode(_loc5_,_loc4_,this._offsetTex,_loc7_,"clamp"),"mul " + _loc5_ + ", " + _loc5_ + ", " + _loc7_,"add " + _loc5_ + ".x, " + _loc5_ + ".xy, " + _loc2_ + ".xx",this.getTex2DSampleCode(_loc6_,_loc3_,this._texture,_loc5_,"repeat"),"div " + _loc5_ + ".xy, v0.xy, " + _loc2_ + ".yy","sub " + _loc5_ + ".zw," + _loc2_ + ".zzzz, " + _loc7_ + ".xxxy","div " + _loc5_ + ".zw," + _loc5_ + ".xxzw, " + _loc2_ + ".yyyy","sat " + _loc5_ + ", " + _loc5_,"mul " + _loc6_ + ".w, " + _loc6_ + ".w" + _loc5_ + ".x","mul " + _loc6_ + ".w, " + _loc6_ + ".w" + _loc5_ + ".y","mul " + _loc6_ + ".w, " + _loc6_ + ".w" + _loc5_ + ".z","mul " + _loc6_ + ".w, " + _loc6_ + ".w" + _loc5_ + ".w","mov oc, " + _loc6_].join("\n");
         return _loc8_ + "\n";
      }
      return "mov oc, " + _loc2_ + "\n";
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
