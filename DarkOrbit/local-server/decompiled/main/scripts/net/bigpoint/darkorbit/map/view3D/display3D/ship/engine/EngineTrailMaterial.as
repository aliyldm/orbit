package net.bigpoint.darkorbit.map.view3D.display3D.ship.engine
{
   import away3d.materials.MaterialBase;
   import away3d.textures.ATFTexture;
   import flash.utils.ByteArray;
   
   public class EngineTrailMaterial extends MaterialBase
   {
      
      private static const TEXTURE:Class = EngineTrailMaterial_TEXTURE;
      
      public static const SEGMENTS_PER_TRAIL:int = 12;
      
      public function EngineTrailMaterial()
      {
         super();
         addPass(new EngineTrailMaterialPass(new ATFTexture(new TEXTURE() as ByteArray)));
         bothSides = true;
      }
      
      override public function get requiresBlending() : Boolean
      {
         return true;
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
import flash.display3D.IndexBuffer3D;
import flash.display3D.VertexBuffer3D;
import flash.geom.Matrix3D;
import net.bigpoint.darkorbit.map.view3D.display3D.ship.engine.EngineTrailMaterial;

use namespace arcane;

class EngineTrailMaterialPass extends MaterialPassBase
{
   
   private static const VIEW_PROJECTION_MATRIX_INDEX:uint = 0;
   
   private static const PARAMS_INDEX:uint = 4;
   
   private static const TRAIL_DATA_INDEX:uint = 6;
   
   public static const PARAM_REGISTERS_PER_TRAIL:int = EngineTrailMaterial.SEGMENTS_PER_TRAIL * 2;
   
   public static const MAX_TRAILS_PER_DRAW_CALL:int = int((128 - TRAIL_DATA_INDEX) / PARAM_REGISTERS_PER_TRAIL);
   
   private var _texture:Texture2DBase;
   
   private var _vertexShaderParams:Vector.<Number> = new Vector.<Number>((TRAIL_DATA_INDEX - PARAMS_INDEX) * 4,true);
   
   private var _fragmentShaderParams:Vector.<Number> = new Vector.<Number>(8,true);
   
   private var _vertices:Vector.<Number> = new Vector.<Number>();
   
   private var _indices:Vector.<uint> = new Vector.<uint>();
   
   private var _indexBuffer:IndexBuffer3D;
   
   private var _vertexBuffer:VertexBuffer3D;
   
   private var _context:Context3D;
   
   private const varyingUV:String = "v0";
   
   public function EngineTrailMaterialPass(param1:Texture2DBase)
   {
      super();
      this._texture = param1;
      this.generateGeometry();
   }
   
   private function generateGeometry() : void
   {
      var _loc2_:int = 0;
      var _loc3_:int = 0;
      var _loc4_:int = 0;
      var _loc1_:int = 0;
      while(_loc1_ < MAX_TRAILS_PER_DRAW_CALL)
      {
         _loc4_ = TRAIL_DATA_INDEX + 2 * _loc1_ * EngineTrailMaterial.SEGMENTS_PER_TRAIL;
         _loc3_ = 0;
         while(_loc3_ < EngineTrailMaterial.SEGMENTS_PER_TRAIL)
         {
            _loc2_ = this._vertices.length / 4;
            this._vertices.push(_loc4_ + _loc3_ * 2,-1,0,0);
            this._vertices.push(_loc4_ + _loc3_ * 2,1,0,1);
            if(_loc3_ < EngineTrailMaterial.SEGMENTS_PER_TRAIL - 1)
            {
               this._indices.push(_loc2_,_loc2_ + 2,_loc2_ + 1);
               this._indices.push(_loc2_ + 2,_loc2_ + 3,_loc2_ + 1);
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < EngineTrailMaterial.SEGMENTS_PER_TRAIL)
         {
            _loc2_ = this._vertices.length / 4;
            this._vertices.push(_loc4_ + _loc3_ * 2,0,-1,0);
            this._vertices.push(_loc4_ + _loc3_ * 2,0,1,1);
            if(_loc3_ < EngineTrailMaterial.SEGMENTS_PER_TRAIL - 1)
            {
               this._indices.push(_loc2_,_loc2_ + 2,_loc2_ + 1);
               this._indices.push(_loc2_ + 2,_loc2_ + 3,_loc2_ + 1);
            }
            _loc3_++;
         }
         _loc1_++;
      }
   }
   
   override arcane function activate(param1:Stage3DProxy, param2:Camera3D) : void
   {
      super.arcane::activate(param1,param2);
      param1._context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA,Context3DBlendFactor.ONE);
      param1._context3D.setDepthTest(false,Context3DCompareMode.LESS_EQUAL);
      param1._context3D.setTextureAt(0,this._texture.getTextureForStage3D(param1));
   }
   
   override arcane function render(param1:IRenderable, param2:Stage3DProxy, param3:Camera3D, param4:Matrix3D) : void
   {
      var _loc5_:Object = param1.shaderParams;
      this._vertexShaderParams[0] = _loc5_.trailThickness;
      this._vertexShaderParams[1] = 0;
      this._vertexShaderParams[2] = 1;
      this._vertexShaderParams[3] = 0;
      this._vertexShaderParams[4] = _loc5_.t;
      this._vertexShaderParams[5] = _loc5_.timeScale;
      this._vertexShaderParams[6] = 0;
      this._vertexShaderParams[7] = 0;
      param2._context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,PARAMS_INDEX,this._vertexShaderParams);
      param2._context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,TRAIL_DATA_INDEX,_loc5_.trailData);
      this._fragmentShaderParams[0] = _loc5_.colorTransform.redMultiplier;
      this._fragmentShaderParams[1] = _loc5_.colorTransform.greenMultiplier;
      this._fragmentShaderParams[2] = _loc5_.colorTransform.blueMultiplier;
      this._fragmentShaderParams[3] = _loc5_.colorTransform.alphaMultiplier;
      var _loc6_:Number = 1 / 255;
      this._fragmentShaderParams[4] = _loc5_.colorTransform.redOffset * _loc6_;
      this._fragmentShaderParams[5] = _loc5_.colorTransform.greenOffset * _loc6_;
      this._fragmentShaderParams[6] = _loc5_.colorTransform.blueOffset * _loc6_;
      this._fragmentShaderParams[7] = _loc5_.colorTransform.alphaOffset * _loc6_;
      param2._context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,this._fragmentShaderParams);
      if(this._context != param2._context3D)
      {
         if(this._indexBuffer)
         {
            this._indexBuffer.dispose();
            this._indexBuffer = null;
         }
         if(this._vertexBuffer)
         {
            this._vertexBuffer.dispose();
            this._vertexBuffer = null;
         }
         this._context = param2._context3D;
      }
      if(this._indexBuffer == null)
      {
         this._indexBuffer = param2._context3D.createIndexBuffer(this._indices.length);
         this._indexBuffer.uploadFromVector(this._indices,0,this._indices.length);
      }
      if(this._vertexBuffer == null)
      {
         this._vertexBuffer = param2._context3D.createVertexBuffer(this._vertices.length / 4,4);
         this._vertexBuffer.uploadFromVector(this._vertices,0,this._vertices.length / 4);
      }
      param2._context3D.setVertexBufferAt(0,this._vertexBuffer);
      param2._context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,VIEW_PROJECTION_MATRIX_INDEX,param4,true);
      var _loc7_:int = Math.min(_loc5_.trailsNum,MAX_TRAILS_PER_DRAW_CALL) * 4 * (EngineTrailMaterial.SEGMENTS_PER_TRAIL - 1);
      param2._context3D.drawTriangles(this._indexBuffer,0,_loc7_);
   }
   
   override arcane function getVertexCode() : String
   {
      var _loc1_:String = "va0";
      var _loc2_:String = "vt0";
      var _loc3_:String = "vt1";
      var _loc4_:String = "vt2";
      var _loc5_:String = "vt3";
      var _loc6_:String = "vc" + PARAMS_INDEX;
      var _loc7_:String = "vc" + (PARAMS_INDEX + 1);
      var _loc8_:String = "vc" + VIEW_PROJECTION_MATRIX_INDEX;
      return ["mov " + _loc2_ + ", vc[" + _loc1_ + ".x]","mov " + _loc3_ + ", vc[" + _loc1_ + ".x+1]","mov " + _loc4_ + ", " + _loc6_ + ".yyyz","mul " + _loc4_ + ".yz, " + _loc1_ + ".yyzz, " + _loc6_ + ".xxxx","cos " + _loc5_ + ".x, " + _loc2_ + ".wwww","sin " + _loc5_ + ".y, " + _loc2_ + ".wwww","mul " + _loc5_ + ", " + _loc4_ + ".xzxz, " + _loc5_ + ".xyyx","sub " + _loc4_ + ".x, " + _loc5_ + ".xxxx, " + _loc5_ + ".yyyy","add " + _loc4_ + ".z, " + _loc5_ + ".zzzz, " + _loc5_ + ".wwww","add " + _loc4_ + ".xyz, " + _loc4_ + ", " + _loc2_,"m44 op, " + _loc4_ + ", " + _loc8_,"sub " + _loc5_ + ".x, " + _loc7_ + ".xxxx, " + _loc3_ + ".xxxx","div " + _loc5_ + ".x, " + _loc5_ + ".xxxx, " + _loc7_ + ".yyyy","sub " + _loc5_ + ".x, " + _loc6_ + ".zzzz, " + _loc5_ + ".xxxx","mov " + _loc5_ + ".y, " + _loc1_ + ".wwww","mov " + _loc5_ + ".zw, " + _loc6_ + ".yyyy","mov " + this.varyingUV + ", " + _loc5_].join("\n");
   }
   
   override arcane function getFragmentCode(param1:String) : String
   {
      return ["tex ft0, " + this.varyingUV + ", fs0 <2d, clamp, linear, miplinear>","mul ft0, ft0, fc0","add oc, ft0, fc1"].join("\n");
   }
   
   override arcane function deactivate(param1:Stage3DProxy) : void
   {
      var _loc2_:Context3D = param1._context3D;
      _loc2_.setTextureAt(0,null);
      _loc2_.setDepthTest(true,Context3DCompareMode.LESS_EQUAL);
      _loc2_.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ZERO);
      super.arcane::deactivate(param1);
   }
   
   override public function dispose() : void
   {
      if(this._indexBuffer)
      {
         this._indexBuffer.dispose();
         this._indexBuffer = null;
      }
      if(this._vertexBuffer)
      {
         this._vertexBuffer.dispose();
         this._vertexBuffer = null;
      }
      this._context = null;
      super.dispose();
   }
}
