package net.bigpoint.darkorbit.map.view3D.display3D.background
{
   import away3d.arcane;
   import away3d.containers.ObjectContainer3D;
   import away3d.core.managers.Stage3DProxy;
   import away3d.core.traverse.EntityCollector;
   import away3d.entities.Mesh;
   import away3d.textures.Texture2DBase;
   import flash.display.BlendMode;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
   
   use namespace arcane;
   
   public class DOSkybox
   {
      
      private var _mesh:Mesh;
      
      private var _material:DOSkyBoxMaterialPass;
      
      private var _loading:Boolean = false;
      
      public function DOSkybox()
      {
         super();
         this._material = new DOSkyBoxMaterialPass();
      }
      
      public function set bgColor(param1:uint) : void
      {
         if(this._material)
         {
            this._material.bgColor = param1;
         }
      }
      
      public function render(param1:Stage3DProxy, param2:EntityCollector, param3:Matrix3D) : void
      {
         var _loc4_:Vector3D = null;
         if(this._mesh)
         {
            _loc4_ = World3D.instance.mapView.cam.lookAtPosition;
            this._mesh.moveTo(_loc4_.x,_loc4_.y,_loc4_.z);
            this._material.setBlendMode(BlendMode.ADD);
            this._material.arcane::activate(param1,param2.camera);
            this._material.render(this._mesh.subMeshes[0],param1,param2.camera,param3);
            this._material.deactivate(param1);
         }
         else if(!this._loading)
         {
            World3D.instance.textureLoader.loadTexture("skybox_stars",World3D.LIFETIME_GLOBAL).addOnce(this.handleStarsReady);
            this._loading = true;
         }
      }
      
      private function handleStarsReady(param1:Texture2DBase) : void
      {
         World3D.instance.textureLoader.useTexture(param1);
         this._material.starsTexture = param1;
         World3D.instance.textureLoader.loadTexture("skybox_mask",World3D.LIFETIME_GLOBAL).addOnce(this.handleMaskReady);
      }
      
      private function handleMaskReady(param1:Texture2DBase) : void
      {
         World3D.instance.textureLoader.useTexture(param1);
         this._material.starsMaskTexture = param1;
         World3D.instance.geometryLoader.loadGeometry("skybox_geometry",World3D.LIFETIME_GLOBAL).addOnce(this.handleGeometryReady);
      }
      
      private function handleGeometryReady(param1:ObjectContainer3D) : void
      {
         World3D.instance.geometryLoader.useGeometry(param1);
         this._mesh = param1.getChildAt(0) as Mesh;
         this._mesh.scale(100000);
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

class DOSkyBoxMaterialPass extends MaterialPassBase
{
   
   public var starsTexture:Texture2DBase;
   
   public var starsMaskTexture:Texture2DBase;
   
   public var timeScale:Number = 120;
   
   public var bgColor:uint;
   
   private const _fragmentData:Vector.<Number> = new Vector.<Number>(4,true);
   
   private const _fragmentData2:Vector.<Number> = new Vector.<Number>(4,true);
   
   public function DOSkyBoxMaterialPass()
   {
      super();
      writeDepth = false;
      depthCompareMode = Context3DCompareMode.LESS_EQUAL;
      alphaPremultiplied = false;
      _smooth = true;
   }
   
   override arcane function render(param1:IRenderable, param2:Stage3DProxy, param3:Camera3D, param4:Matrix3D) : void
   {
      var _loc5_:Matrix3D = Matrix3DUtils.CALCULATION_MATRIX;
      _loc5_.copyFrom(param1.getRenderSceneTransform(param3));
      _loc5_.append(param4);
      param2._context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,0,_loc5_,true);
      param1.activateVertexBuffer(0,param2);
      param1.activateUVBuffer(1,param2);
      var _loc6_:Number = getTimer() / 1000 / this.timeScale;
      this._fragmentData[0] = _loc6_ * 2;
      this._fragmentData[1] = _loc6_ + 1;
      this._fragmentData[2] = -_loc6_ * 1.5;
      this._fragmentData[3] = _loc6_ + 0.3;
      this._fragmentData2[0] = (this.bgColor >> 16 & 0xFF) / 100;
      this._fragmentData2[1] = (this.bgColor >> 8 & 0xFF) / 100;
      this._fragmentData2[2] = (this.bgColor & 0xFF) / 100;
      this._fragmentData2[3] = 0;
      param2._context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,this._fragmentData);
      param2._context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,1,this._fragmentData2);
      param2._context3D.setTextureAt(0,this.starsTexture.getTextureForStage3D(param2));
      param2._context3D.setTextureAt(1,this.starsMaskTexture.getTextureForStage3D(param2));
      param2._context3D.drawTriangles(param1.getIndexBuffer(param2));
   }
   
   override arcane function deactivate(param1:Stage3DProxy) : void
   {
      var _loc2_:Context3D = param1._context3D;
      _loc2_.setTextureAt(0,null);
      _loc2_.setTextureAt(1,null);
      _loc2_.setTextureAt(2,null);
      _loc2_.setVertexBufferAt(0,null);
      _loc2_.setVertexBufferAt(1,null);
      super.arcane::deactivate(param1);
   }
   
   override arcane function getVertexCode() : String
   {
      return ["m44 op, va0, vc0","mov v0, va1"].join("\n") + "\n";
   }
   
   override arcane function getFragmentCode(param1:String) : String
   {
      var _loc2_:String = "fc0";
      var _loc3_:String = "fc1";
      var _loc4_:String = "fs0";
      var _loc5_:String = "fs1";
      var _loc6_:String = "v0";
      var _loc7_:String = "ft0";
      var _loc8_:String = "ft2";
      var _loc9_:String = "oc";
      var _loc10_:String = ["add " + _loc7_ + ", " + _loc6_ + ", " + _loc2_,this.getTex2DSampleCode(_loc7_,_loc5_,this.starsMaskTexture,_loc7_,"repeat"),"add " + _loc8_ + ", " + _loc6_ + ", " + _loc2_ + ".zw",this.getTex2DSampleCode(_loc8_,_loc5_,this.starsMaskTexture,_loc8_,"repeat"),"mul " + _loc7_ + ", " + _loc7_ + ", " + _loc8_,this.getTex2DSampleCode(_loc8_,_loc4_,this.starsTexture,_loc6_,"clamp"),"mul " + _loc7_ + ", " + _loc7_ + ", " + _loc8_,"mov " + _loc9_ + ", " + _loc7_].join("\n");
      return _loc10_ + "\n";
   }
   
   private function getTex2DSampleCode(param1:String, param2:String, param3:TextureProxyBase, param4:String, param5:String) : String
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
