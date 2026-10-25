package net.bigpoint.darkorbit.map.view3D.display3D.zones
{
   import away3d.materials.MaterialBase;
   import away3d.textures.Texture2DBase;
   import flash.display.BlendMode;
   
   public class POIZoneMaterial extends MaterialBase
   {
      
      private var _pass:POIZoneMaterialPass;
      
      public function POIZoneMaterial(param1:Texture2DBase)
      {
         super();
         this._pass = new POIZoneMaterialPass();
         addPass(this._pass);
         this._pass.diffuse = param1;
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
      
      public function set scaling(param1:Number) : void
      {
         this._pass.scaling = param1;
      }
      
      public function set offsetX(param1:Number) : void
      {
         this._pass.offsetX = param1;
      }
      
      public function set movingSpeedX(param1:Number) : void
      {
         this._pass.movingSpeedX = param1;
      }
      
      public function set movingSpeedY(param1:Number) : void
      {
         this._pass.movingSpeedY = param1;
      }
      
      public function set rotationSpeed(param1:Number) : void
      {
         this._pass.rotationSpeed = param1;
      }
      
      public function set pulseSpeed(param1:Number) : void
      {
         this._pass.pulseSpeed = param1;
      }
   }
}

import away3d.arcane;
import away3d.cameras.Camera3D;
import away3d.core.base.IRenderable;
import away3d.core.managers.Stage3DProxy;
import away3d.materials.passes.MaterialPassBase;
import away3d.textures.Texture2DBase;
import flash.display3D.Context3D;
import flash.display3D.Context3DBlendFactor;
import flash.display3D.Context3DCompareMode;
import flash.display3D.Context3DProgramType;
import flash.geom.Matrix3D;
import flash.geom.Vector3D;
import flash.utils.getTimer;

use namespace arcane;

class POIZoneMaterialPass extends MaterialPassBase
{
   
   private var _matrix:Matrix3D = new Matrix3D();
   
   private var _rotationMatrix:Matrix3D = new Matrix3D();
   
   private var _texture:Texture2DBase;
   
   private var _scaling:Number = 0.002;
   
   private var _offsetX:Number = 0;
   
   private var _offsetY:Number = 0;
   
   private var _movingSpeedX:Number = 0;
   
   private var _movingSpeedY:Number = 0;
   
   private var _rotationSpeed:Number = 3;
   
   private var _vertexData:Vector.<Number>;
   
   private var _fragmentData:Vector.<Number>;
   
   private var _delta:Number = 0;
   
   private var _pulseTimer:Number = 0;
   
   private var _pulseSpeed:Number = 0;
   
   private var _startTime:Number = 0;
   
   public function POIZoneMaterialPass()
   {
      super();
      this._vertexData = new Vector.<Number>(4);
      this._fragmentData = new Vector.<Number>(4);
      this._fragmentData[0] = 1;
      this._startTime = getTimer();
   }
   
   public function get diffuse() : Texture2DBase
   {
      return this._texture;
   }
   
   public function set diffuse(param1:Texture2DBase) : void
   {
      if(Boolean(param1) != Boolean(this._texture) || Boolean(param1 && this._texture) && (Boolean(param1.hasMipMaps != this._texture.hasMipMaps || param1.format != this._texture.format)))
      {
         arcane::invalidateShaderProgram();
      }
      this._texture = param1;
   }
   
   override arcane function getVertexCode() : String
   {
      var _loc1_:String = "";
      return _loc1_ + ("m44 op, va0, vc0\n" + "m44 vt0, va0, vc4\n" + "mul vt0, vt0, vc12.xxxx\n" + "add vt1, vt0, vc12.yzzz\n" + "m44 v0, vt1, vc8\n");
   }
   
   override arcane function getFragmentCode(param1:String) : String
   {
      var _loc2_:String = "";
      _loc2_ += "mov ft0, v0.xzzz\n";
      _loc2_ += "tex ft1, ft0, fs0 <2d, linear, repeat>\n";
      _loc2_ += "mul ft1.xyz, ft1.xyz, fc0.x\n";
      return _loc2_ + "mov oc, ft1\n";
   }
   
   override arcane function activate(param1:Stage3DProxy, param2:Camera3D) : void
   {
      super.arcane::activate(param1,param2);
      param1._context3D.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
      param1._context3D.setDepthTest(false,Context3DCompareMode.LESS_EQUAL);
      param1._context3D.setTextureAt(0,this._texture.getTextureForStage3D(param1));
   }
   
   override arcane function render(param1:IRenderable, param2:Stage3DProxy, param3:Camera3D, param4:Matrix3D) : void
   {
      var _loc5_:Context3D = param2._context3D;
      var _loc6_:Number = getTimer();
      this._delta = (_loc6_ - this._startTime) * 0.001;
      if(this._pulseSpeed > 0)
      {
         this._pulseTimer += this._delta * this._pulseSpeed;
         if(this._pulseTimer >= 2 * Math.PI)
         {
            this._pulseTimer = 0;
         }
         this._fragmentData[0] = Math.min(1,1 + Math.sin(this._pulseTimer) * 0.5);
      }
      this._vertexData[0] = 1 / this._scaling;
      this._vertexData[1] = this._offsetX;
      this._vertexData[2] = this._offsetY;
      this._offsetX += this._delta * this._movingSpeedX;
      this._offsetY += this._delta * this._movingSpeedY;
      this._rotationMatrix.appendRotation(this._delta * this._rotationSpeed,Vector3D.Y_AXIS,param1.sceneTransform.position);
      this._startTime = getTimer();
      this._matrix.copyFrom(param1.sceneTransform);
      this._matrix.append(param3.viewProjection);
      _loc5_.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,0,this._matrix,true);
      _loc5_.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,4,param1.sceneTransform,true);
      _loc5_.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,8,this._rotationMatrix,true);
      _loc5_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,12,this._vertexData);
      _loc5_.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,this._fragmentData);
      param1.activateVertexBuffer(0,param2);
      _loc5_.drawTriangles(param1.getIndexBuffer(param2),0,param1.numTriangles);
   }
   
   override arcane function deactivate(param1:Stage3DProxy) : void
   {
      super.arcane::deactivate(param1);
      var _loc2_:Context3D = param1._context3D;
      _loc2_.setTextureAt(0,null);
      _loc2_.setVertexBufferAt(1,null);
      _loc2_.setDepthTest(true,Context3DCompareMode.LESS_EQUAL);
      _loc2_.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ZERO);
   }
   
   public function set scaling(param1:Number) : void
   {
      this._scaling = param1;
   }
   
   public function set offsetX(param1:Number) : void
   {
      this._offsetX = param1;
   }
   
   public function set offsetY(param1:Number) : void
   {
      this._offsetY = param1;
   }
   
   public function set movingSpeedX(param1:Number) : void
   {
      this._movingSpeedX = param1;
   }
   
   public function set movingSpeedY(param1:Number) : void
   {
      this._movingSpeedY = param1;
   }
   
   public function set rotationSpeed(param1:Number) : void
   {
      this._rotationSpeed = param1;
   }
   
   public function set pulseSpeed(param1:Number) : void
   {
      this._pulseSpeed = param1;
   }
}
