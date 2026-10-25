package away3d.materials.passes
{
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.Geometry;
   import away3d.core.base.IRenderable;
   import away3d.core.base.ISubGeometry;
   import away3d.core.base.SubGeometry;
   import away3d.core.base.SubMesh;
   import away3d.core.managers.Stage3DProxy;
   import away3d.core.math.Matrix3DUtils;
   import away3d.entities.Mesh;
   import flash.display.BlendMode;
   import flash.display3D.Context3D;
   import flash.display3D.Context3DCompareMode;
   import flash.display3D.Context3DProgramType;
   import flash.display3D.Context3DTriangleFace;
   import flash.geom.Matrix3D;
   import flash.utils.Dictionary;
   
   use namespace arcane;
   
   public class OutlinePass extends MaterialPassBase
   {
      
      private var _outlineColor:uint;
      
      private var _colorData:Vector.<Number>;
      
      private var _offsetData:Vector.<Number>;
      
      private var _showInnerLines:Boolean;
      
      private var _outlineMeshes:Dictionary;
      
      private var _dedicatedMeshes:Boolean;
      
      private var _alpha:Number = 1;
      
      public function OutlinePass(param1:uint = 0, param2:Number = 20, param3:Boolean = false, param4:Boolean = false)
      {
         super();
         mipmap = false;
         this._colorData = new Vector.<Number>(4,true);
         this._colorData[3] = 1;
         this._offsetData = new Vector.<Number>(4,true);
         this.outlineColor = param1;
         this.outlineSize = param2;
         _defaultCulling = Context3DTriangleFace.FRONT;
         _numUsedStreams = 2;
         _numUsedVertexConstants = 6;
         this._showInnerLines = param3;
         this._dedicatedMeshes = param4;
         if(param4)
         {
            this._outlineMeshes = new Dictionary();
         }
         setBlendMode(BlendMode.LAYER);
         _animatableAttributes = Vector.<String>(["va0","va1"]);
         _animationTargetRegisters = Vector.<String>(["vt0","vt1"]);
      }
      
      public function clearDedicatedMesh(param1:Mesh) : void
      {
         var _loc2_:int = 0;
         if(this._dedicatedMeshes)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.subMeshes.length)
            {
               this.disposeDedicated(param1.subMeshes[_loc2_]);
               _loc2_++;
            }
         }
      }
      
      private function disposeDedicated(param1:Object) : void
      {
         var _loc2_:Mesh = null;
         _loc2_ = Mesh(this._dedicatedMeshes[param1]);
         _loc2_.geometry.dispose();
         _loc2_.dispose();
         delete this._dedicatedMeshes[param1];
      }
      
      override public function dispose() : void
      {
         var _loc1_:Object = null;
         super.dispose();
         if(this._dedicatedMeshes)
         {
            for(_loc1_ in this._outlineMeshes)
            {
               this.disposeDedicated(_loc1_);
            }
         }
      }
      
      public function get showInnerLines() : Boolean
      {
         return this._showInnerLines;
      }
      
      public function set showInnerLines(param1:Boolean) : void
      {
         this._showInnerLines = param1;
      }
      
      public function get outlineColor() : uint
      {
         return this._outlineColor;
      }
      
      public function set outlineColor(param1:uint) : void
      {
         this._outlineColor = param1;
         this._colorData[0] = (param1 >> 16 & 0xFF) / 255;
         this._colorData[1] = (param1 >> 8 & 0xFF) / 255;
         this._colorData[2] = (param1 & 0xFF) / 255;
         this._colorData[3] = this._alpha;
      }
      
      public function get outlineSize() : Number
      {
         return this._offsetData[0];
      }
      
      public function set outlineSize(param1:Number) : void
      {
         this._offsetData[0] = param1;
      }
      
      override arcane function getVertexCode() : String
      {
         var _loc1_:String = null;
         return "mul vt7, vt1, vc5.x\n" + "add vt7, vt7, vt0\n" + "mov vt7.w, vt0.w\n" + "m44 op, vt7, vc0\t\t\n";
      }
      
      override arcane function getFragmentCode(param1:String) : String
      {
         return "mov oc, fc0\n";
      }
      
      override arcane function activate(param1:Stage3DProxy, param2:Camera3D) : void
      {
         var _loc3_:Context3D = param1._context3D;
         super.arcane::activate(param1,param2);
         if(!this._showInnerLines)
         {
            _loc3_.setDepthTest(false,Context3DCompareMode.LESS);
         }
         _loc3_.setCulling(_defaultCulling);
         _loc3_.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,this._colorData,1);
         _loc3_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,5,this._offsetData,1);
      }
      
      override arcane function deactivate(param1:Stage3DProxy) : void
      {
         super.arcane::deactivate(param1);
         if(!this._showInnerLines)
         {
            param1._context3D.setDepthTest(true,Context3DCompareMode.LESS);
         }
      }
      
      override arcane function render(param1:IRenderable, param2:Stage3DProxy, param3:Camera3D, param4:Matrix3D) : void
      {
         var _loc5_:Mesh = null;
         var _loc6_:IRenderable = null;
         var _loc7_:Context3D = param2._context3D;
         var _loc8_:Matrix3D = Matrix3DUtils.CALCULATION_MATRIX;
         _loc8_.copyFrom(param1.getRenderSceneTransform(param3));
         _loc8_.append(param4);
         if(this._dedicatedMeshes)
         {
            _loc5_ = this._outlineMeshes[param1] = this._outlineMeshes[param1] || this.createDedicatedMesh(SubMesh(param1).subGeometry);
            _loc6_ = _loc5_.subMeshes[0];
            _loc7_.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,0,_loc8_,true);
            _loc6_.activateVertexBuffer(0,param2);
            _loc6_.activateVertexNormalBuffer(1,param2);
            _loc7_.drawTriangles(_loc6_.getIndexBuffer(param2),0,_loc6_.numTriangles);
         }
         else
         {
            param1.activateVertexNormalBuffer(1,param2);
            _loc7_.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,0,_loc8_,true);
            param1.activateVertexBuffer(0,param2);
            _loc7_.drawTriangles(param1.getIndexBuffer(param2),0,param1.numTriangles);
         }
      }
      
      private function createDedicatedMesh(param1:ISubGeometry) : Mesh
      {
         var _loc9_:int = 0;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:String = null;
         var _loc14_:* = 0;
         var _loc15_:* = 0;
         var _loc17_:int = 0;
         var _loc2_:Mesh = new Mesh(new Geometry(),null);
         var _loc3_:SubGeometry = new SubGeometry();
         var _loc4_:Array = [];
         var _loc5_:Vector.<uint> = param1.indexData;
         var _loc6_:Vector.<Number> = param1.vertexData;
         var _loc7_:Vector.<uint> = new Vector.<uint>();
         var _loc8_:Vector.<Number> = new Vector.<Number>();
         var _loc16_:int = int(_loc5_.length);
         var _loc18_:int = int(param1.vertexStride);
         var _loc19_:int = param1.vertexOffset;
         var _loc20_:int = 0;
         while(_loc20_ < _loc16_)
         {
            _loc9_ = _loc19_ + _loc5_[_loc20_] * _loc18_;
            _loc10_ = _loc6_[_loc9_];
            _loc11_ = _loc6_[_loc9_ + 1];
            _loc12_ = _loc6_[_loc9_ + 2];
            _loc13_ = _loc10_.toPrecision(5) + "/" + _loc11_.toPrecision(5) + "/" + _loc12_.toPrecision(5);
            if(_loc4_[_loc13_])
            {
               _loc9_ = _loc4_[_loc13_] - 1;
            }
            else
            {
               _loc9_ = _loc15_ / 3;
               _loc4_[_loc13_] = _loc9_ + 1;
               var _loc21_:Number;
               _loc8_[_loc21_ = _loc15_++] = _loc10_;
               var _loc22_:Number;
               _loc8_[_loc22_ = _loc15_++] = _loc11_;
               var _loc23_:Number;
               _loc8_[_loc23_ = _loc15_++] = _loc12_;
            }
            if(_loc9_ > _loc17_)
            {
               _loc17_ = _loc9_;
            }
            _loc7_[_loc21_ = _loc14_++] = _loc9_;
            _loc20_++;
         }
         _loc3_.autoDeriveVertexNormals = true;
         _loc3_.updateVertexData(_loc8_);
         _loc3_.updateIndexData(_loc7_);
         _loc2_.geometry.addSubGeometry(_loc3_);
         return _loc2_;
      }
      
      public function get alpha() : Number
      {
         return this._alpha;
      }
      
      public function set alpha(param1:Number) : void
      {
         this._alpha = param1;
         this._colorData[3] = this._alpha;
      }
   }
}

