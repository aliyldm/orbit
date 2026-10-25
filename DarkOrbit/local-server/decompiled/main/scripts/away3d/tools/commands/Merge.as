package away3d.tools.commands
{
   import away3d.containers.*;
   import away3d.core.base.*;
   import away3d.core.math.Matrix3DUtils;
   import away3d.entities.*;
   import away3d.materials.*;
   import away3d.tools.utils.*;
   
   public class Merge
   {
      
      private var _objectSpace:Boolean;
      
      private var _keepMaterial:Boolean;
      
      private var _disposeSources:Boolean;
      
      private var _geomVOs:Vector.<GeometryVO>;
      
      private var _toDispose:Vector.<Mesh>;
      
      public function Merge(param1:Boolean = false, param2:Boolean = false, param3:Boolean = false)
      {
         super();
         this._keepMaterial = param1;
         this._disposeSources = param2;
         this._objectSpace = param3;
      }
      
      public function set disposeSources(param1:Boolean) : void
      {
         this._disposeSources = param1;
      }
      
      public function get disposeSources() : Boolean
      {
         return this._disposeSources;
      }
      
      public function set keepMaterial(param1:Boolean) : void
      {
         this._keepMaterial = param1;
      }
      
      public function get keepMaterial() : Boolean
      {
         return this._keepMaterial;
      }
      
      public function set objectSpace(param1:Boolean) : void
      {
         this._objectSpace = param1;
      }
      
      public function get objectSpace() : Boolean
      {
         return this._objectSpace;
      }
      
      public function applyToContainer(param1:Mesh, param2:ObjectContainer3D) : void
      {
         this.reset();
         this.parseContainer(param1,param2);
         this.collect(param1,false);
         this.merge(param1,this._disposeSources);
      }
      
      public function applyToMeshes(param1:Mesh, param2:Vector.<Mesh>) : void
      {
         this.reset();
         if(!param2.length)
         {
            return;
         }
         var _loc3_:uint = 0;
         while(_loc3_ < param2.length)
         {
            if(param2[_loc3_] != param1)
            {
               this.collect(param2[_loc3_],this._disposeSources);
            }
            _loc3_++;
         }
         this.collect(param1,false);
         this.merge(param1,this._disposeSources);
      }
      
      public function apply(param1:Mesh, param2:Mesh) : void
      {
         this.reset();
         this.collect(param2,this._disposeSources);
         this.collect(param1,false);
         this.merge(param1,this._disposeSources);
      }
      
      private function reset() : void
      {
         this._toDispose = new Vector.<Mesh>();
         this._geomVOs = new Vector.<GeometryVO>();
      }
      
      private function merge(param1:Mesh, param2:Boolean) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:Geometry = null;
         var _loc6_:Geometry = null;
         var _loc7_:Boolean = false;
         var _loc8_:uint = 0;
         var _loc9_:GeometryVO = null;
         var _loc10_:Vector.<ISubGeometry> = null;
         var _loc11_:Mesh = null;
         _loc5_ = param1.geometry;
         _loc6_ = param1.geometry = new Geometry();
         _loc4_ = param1.subMeshes.length;
         _loc7_ = this._geomVOs.length > 1;
         _loc3_ = 0;
         while(_loc3_ < this._geomVOs.length)
         {
            _loc9_ = this._geomVOs[_loc3_];
            _loc10_ = GeomUtil.fromVectors(_loc9_.vertices,_loc9_.indices,_loc9_.uvs,_loc9_.normals,null,null,null);
            _loc8_ = 0;
            while(_loc8_ < _loc10_.length)
            {
               _loc6_.addSubGeometry(_loc10_[_loc8_]);
               if(this._keepMaterial && _loc7_)
               {
                  param1.subMeshes[_loc4_].material = _loc9_.material;
               }
               _loc4_++;
               _loc8_++;
            }
            _loc3_++;
         }
         if(this._keepMaterial && !_loc7_ && Boolean(this._geomVOs.length))
         {
            param1.material = this._geomVOs[0].material;
         }
         if(param2)
         {
            for each(_loc11_ in this._toDispose)
            {
               _loc11_.geometry.dispose();
               _loc11_.dispose();
            }
            _loc5_.dispose();
         }
         this._toDispose = null;
      }
      
      private function collect(param1:Mesh, param2:Boolean) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:Vector.<ISubGeometry> = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:ISubGeometry = null;
         var _loc14_:GeometryVO = null;
         var _loc15_:Vector.<Number> = null;
         var _loc16_:Vector.<Number> = null;
         var _loc17_:uint = 0;
         var _loc18_:uint = 0;
         var _loc19_:uint = 0;
         var _loc20_:uint = 0;
         var _loc21_:uint = 0;
         var _loc22_:uint = 0;
         var _loc23_:Vector.<Number> = null;
         var _loc24_:Vector.<Number> = null;
         var _loc25_:Vector.<Number> = null;
         if(param1.geometry)
         {
            _loc4_ = param1.geometry.subGeometries;
            _loc3_ = 0;
            while(_loc3_ < _loc4_.length)
            {
               _loc13_ = _loc4_[_loc3_];
               _loc23_ = _loc13_.vertexData;
               _loc17_ = _loc13_.vertexStride;
               _loc20_ = uint(_loc13_.vertexOffset);
               _loc24_ = _loc13_.vertexNormalData;
               _loc18_ = _loc13_.vertexNormalStride;
               _loc21_ = uint(_loc13_.vertexNormalOffset);
               _loc25_ = _loc13_.UVData;
               _loc19_ = _loc13_.UVStride;
               _loc22_ = uint(_loc13_.UVOffset);
               _loc14_ = this.getSubGeomData(param1.subMeshes[_loc3_].material || param1.material);
               _loc15_ = this._objectSpace ? _loc14_.vertices : new Vector.<Number>();
               _loc16_ = this._objectSpace ? _loc14_.normals : new Vector.<Number>();
               _loc9_ = _loc15_.length;
               _loc10_ = _loc16_.length;
               _loc11_ = _loc14_.uvs.length;
               _loc7_ = _loc13_.numVertices;
               _loc6_ = 0;
               while(_loc6_ < _loc7_)
               {
                  _loc5_ = _loc20_ + _loc6_ * _loc17_;
                  var _loc26_:uint;
                  _loc15_[_loc26_ = _loc9_++] = _loc23_[_loc5_];
                  var _loc27_:uint;
                  _loc15_[_loc27_ = _loc9_++] = _loc23_[_loc5_ + 1];
                  var _loc28_:uint;
                  _loc15_[_loc28_ = _loc9_++] = _loc23_[_loc5_ + 2];
                  _loc5_ = _loc21_ + _loc6_ * _loc18_;
                  var _loc29_:uint;
                  _loc16_[_loc29_ = _loc10_++] = _loc24_[_loc5_];
                  var _loc30_:uint;
                  _loc16_[_loc30_ = _loc10_++] = _loc24_[_loc5_ + 1];
                  var _loc31_:uint;
                  _loc16_[_loc31_ = _loc10_++] = _loc24_[_loc5_ + 2];
                  _loc5_ = _loc22_ + _loc6_ * _loc19_;
                  var _loc32_:uint;
                  _loc14_.uvs[_loc32_ = _loc11_++] = _loc25_[_loc5_];
                  var _loc33_:uint;
                  _loc14_.uvs[_loc33_ = _loc11_++] = _loc25_[_loc5_ + 1];
                  _loc6_++;
               }
               _loc12_ = !this._objectSpace ? uint(_loc14_.vertices.length / 3) : 0;
               _loc8_ = _loc14_.indices.length;
               _loc7_ = _loc13_.numTriangles;
               _loc6_ = 0;
               while(_loc6_ < _loc7_)
               {
                  _loc5_ = _loc6_ * 3;
                  _loc14_.indices[_loc26_ = _loc8_++] = _loc13_.indexData[_loc5_] + _loc12_;
                  _loc14_.indices[_loc27_ = _loc8_++] = _loc13_.indexData[_loc5_ + 1] + _loc12_;
                  _loc14_.indices[_loc28_ = _loc8_++] = _loc13_.indexData[_loc5_ + 2] + _loc12_;
                  _loc6_++;
               }
               if(!this._objectSpace)
               {
                  param1.sceneTransform.transformVectors(_loc15_,_loc15_);
                  Matrix3DUtils.deltaTransformVectors(param1.sceneTransform,_loc16_,_loc16_);
                  _loc9_ = _loc14_.vertices.length;
                  _loc10_ = _loc14_.normals.length;
                  _loc7_ = _loc15_.length;
                  _loc6_ = 0;
                  while(_loc6_ < _loc7_)
                  {
                     _loc14_.vertices[_loc26_ = _loc9_++] = _loc15_[_loc6_];
                     _loc14_.normals[_loc27_ = _loc10_++] = _loc16_[_loc6_];
                     _loc6_++;
                  }
               }
               _loc3_++;
            }
            if(param2)
            {
               this._toDispose.push(param1);
            }
         }
      }
      
      private function getSubGeomData(param1:MaterialBase) : GeometryVO
      {
         var _loc2_:GeometryVO = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         if(this._keepMaterial)
         {
            _loc4_ = this._geomVOs.length;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               if(this._geomVOs[_loc3_].material == param1)
               {
                  _loc2_ = this._geomVOs[_loc3_];
                  break;
               }
               _loc3_++;
            }
         }
         else if(this._geomVOs.length)
         {
            _loc2_ = this._geomVOs[0];
         }
         if(!_loc2_)
         {
            _loc2_ = new GeometryVO();
            _loc2_.vertices = new Vector.<Number>();
            _loc2_.normals = new Vector.<Number>();
            _loc2_.uvs = new Vector.<Number>();
            _loc2_.indices = new Vector.<uint>();
            _loc2_.material = param1;
            this._geomVOs.push(_loc2_);
         }
         return _loc2_;
      }
      
      private function parseContainer(param1:Mesh, param2:ObjectContainer3D) : void
      {
         var _loc3_:ObjectContainer3D = null;
         var _loc4_:uint = 0;
         if(param2 is Mesh && param2 != param1)
         {
            this.collect(Mesh(param2),this._disposeSources);
         }
         _loc4_ = 0;
         while(_loc4_ < param2.numChildren)
         {
            _loc3_ = param2.getChildAt(_loc4_);
            this.parseContainer(param1,_loc3_);
            _loc4_++;
         }
      }
   }
}

import away3d.materials.MaterialBase;

class GeometryVO
{
   
   public var uvs:Vector.<Number>;
   
   public var vertices:Vector.<Number>;
   
   public var normals:Vector.<Number>;
   
   public var indices:Vector.<uint>;
   
   public var material:MaterialBase;
   
   public function GeometryVO()
   {
      super();
   }
}
