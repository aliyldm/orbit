package away3d.tools.helpers
{
   import away3d.arcane;
   import away3d.containers.ObjectContainer3D;
   import away3d.core.base.CompactSubGeometry;
   import away3d.core.base.Geometry;
   import away3d.core.base.ISubGeometry;
   import away3d.core.base.Object3D;
   import away3d.core.base.SubGeometry;
   import away3d.core.base.data.UV;
   import away3d.core.base.data.Vertex;
   import away3d.entities.Mesh;
   import away3d.materials.MaterialBase;
   import away3d.materials.utils.DefaultMaterialManager;
   import away3d.tools.utils.Bounds;
   import away3d.tools.utils.GeomUtil;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   
   use namespace arcane;
   
   public class MeshHelper
   {
      
      private static const LIMIT:uint = 196605;
      
      public function MeshHelper()
      {
         super();
      }
      
      public static function boundingRadius(param1:Mesh) : Number
      {
         var radius:Number = NaN;
         var mesh:Mesh = param1;
         try
         {
            radius = Math.max((mesh.maxX - mesh.minX) * Object3D(mesh).scaleX,(mesh.maxY - mesh.minY) * Object3D(mesh).scaleY,(mesh.maxZ - mesh.minZ) * Object3D(mesh).scaleZ);
         }
         catch(e:Error)
         {
            Bounds.getMeshBounds(mesh);
            radius = Math.max((Bounds.maxX - Bounds.minX) * Object3D(mesh).scaleX,(Bounds.maxY - Bounds.minY) * Object3D(mesh).scaleY,(Bounds.maxZ - Bounds.minZ) * Object3D(mesh).scaleZ);
         }
         return radius * 0.5;
      }
      
      public static function boundingRadiusContainer(param1:ObjectContainer3D) : Number
      {
         Bounds.getObjectContainerBounds(param1);
         var _loc2_:Number = Math.max((Bounds.maxX - Bounds.minX) * Object3D(param1).scaleX,(Bounds.maxY - Bounds.minY) * Object3D(param1).scaleY,(Bounds.maxZ - Bounds.minZ) * Object3D(param1).scaleZ);
         return _loc2_ * 0.5;
      }
      
      public static function recenter(param1:Mesh, param2:Boolean = true) : void
      {
         Bounds.getMeshBounds(param1);
         var _loc3_:Number = (Bounds.minX + Bounds.maxX) * 0.5;
         var _loc4_:Number = (Bounds.minY + Bounds.maxY) * 0.5;
         var _loc5_:Number = (Bounds.minZ + Bounds.maxZ) * 0.5;
         applyPosition(param1,-_loc3_,-_loc4_,-_loc5_);
         if(!param2)
         {
            param1.x -= _loc3_;
            param1.y -= _loc4_;
            param1.z -= _loc5_;
         }
      }
      
      public static function recenterContainer(param1:ObjectContainer3D, param2:Boolean = true) : void
      {
         var _loc3_:ObjectContainer3D = null;
         if(param1 is Mesh && ObjectContainer3D(param1).numChildren == 0)
         {
            recenter(Mesh(param1),param2);
         }
         var _loc4_:uint = 0;
         while(_loc4_ < ObjectContainer3D(param1).numChildren)
         {
            _loc3_ = ObjectContainer3D(param1).getChildAt(_loc4_);
            recenterContainer(_loc3_,param2);
            _loc4_++;
         }
      }
      
      public static function applyRotations(param1:Mesh) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc11_:Vector.<Number> = null;
         var _loc12_:Vector.<Number> = null;
         var _loc14_:ISubGeometry = null;
         var _loc9_:Geometry = param1.geometry;
         var _loc10_:Vector.<ISubGeometry> = _loc9_.subGeometries;
         var _loc13_:uint = _loc10_.length;
         var _loc15_:Matrix3D = param1.transform.clone();
         _loc15_.appendScale(1 / param1.scaleX,1 / param1.scaleY,1 / param1.scaleZ);
         var _loc16_:Vector3D = new Vector3D();
         _loc2_ = 0;
         while(_loc2_ < _loc13_)
         {
            _loc14_ = ISubGeometry(_loc10_[_loc2_]);
            _loc11_ = _loc14_.vertexData;
            _loc6_ = uint(_loc14_.vertexOffset);
            _loc5_ = _loc14_.vertexStride;
            _loc12_ = _loc14_.vertexNormalData;
            _loc8_ = uint(_loc14_.vertexNormalOffset);
            _loc7_ = _loc14_.vertexNormalStride;
            _loc4_ = _loc14_.numVertices;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc16_.x = _loc11_[_loc6_ + _loc3_ * _loc5_ + 0];
               _loc16_.y = _loc11_[_loc6_ + _loc3_ * _loc5_ + 1];
               _loc16_.z = _loc11_[_loc6_ + _loc3_ * _loc5_ + 2];
               _loc16_ = _loc15_.deltaTransformVector(_loc16_);
               _loc11_[_loc6_ + _loc3_ * _loc5_ + 0] = _loc16_.x;
               _loc11_[_loc6_ + _loc3_ * _loc5_ + 1] = _loc16_.y;
               _loc11_[_loc6_ + _loc3_ * _loc5_ + 2] = _loc16_.z;
               _loc16_.x = _loc12_[_loc8_ + _loc3_ * _loc7_ + 0];
               _loc16_.y = _loc12_[_loc8_ + _loc3_ * _loc7_ + 1];
               _loc16_.z = _loc12_[_loc8_ + _loc3_ * _loc7_ + 2];
               _loc16_ = _loc15_.deltaTransformVector(_loc16_);
               _loc16_.normalize();
               _loc12_[_loc8_ + _loc3_ * _loc7_ + 0] = _loc16_.x;
               _loc12_[_loc8_ + _loc3_ * _loc7_ + 1] = _loc16_.y;
               _loc12_[_loc8_ + _loc3_ * _loc7_ + 2] = _loc16_.z;
               _loc3_++;
            }
            if(_loc14_ is CompactSubGeometry)
            {
               CompactSubGeometry(_loc14_).updateData(_loc11_);
            }
            else
            {
               SubGeometry(_loc14_).updateVertexData(_loc11_);
               SubGeometry(_loc14_).updateVertexNormalData(_loc12_);
            }
            _loc2_++;
         }
         param1.rotationX = param1.rotationY = param1.rotationZ = 0;
      }
      
      public static function applyRotationsContainer(param1:ObjectContainer3D) : void
      {
         var _loc2_:ObjectContainer3D = null;
         if(param1 is Mesh && ObjectContainer3D(param1).numChildren == 0)
         {
            applyRotations(Mesh(param1));
         }
         var _loc3_:uint = 0;
         while(_loc3_ < ObjectContainer3D(param1).numChildren)
         {
            _loc2_ = ObjectContainer3D(param1).getChildAt(_loc3_);
            applyRotationsContainer(_loc2_);
            _loc3_++;
         }
      }
      
      public static function applyScales(param1:Mesh, param2:Number, param3:Number, param4:Number, param5:ObjectContainer3D = null) : void
      {
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc13_:Vector.<Number> = null;
         var _loc15_:ISubGeometry = null;
         if(param2 == 1 && param3 == 1 && param4 == 1)
         {
            return;
         }
         if(param1.animator)
         {
            param1.scaleX = param2;
            param1.scaleY = param3;
            param1.scaleZ = param4;
            return;
         }
         var _loc11_:Geometry = param1.geometry;
         var _loc12_:Vector.<ISubGeometry> = _loc11_.subGeometries;
         var _loc14_:uint = _loc12_.length;
         _loc6_ = 0;
         while(_loc6_ < _loc14_)
         {
            _loc15_ = ISubGeometry(_loc12_[_loc6_]);
            _loc10_ = uint(_loc15_.vertexOffset);
            _loc9_ = _loc15_.vertexStride;
            _loc13_ = _loc15_.vertexData;
            _loc8_ = _loc15_.numVertices;
            _loc7_ = 0;
            while(_loc7_ < _loc8_)
            {
               _loc13_[_loc10_ + _loc7_ * _loc9_ + 0] *= param2;
               _loc13_[_loc10_ + _loc7_ * _loc9_ + 1] *= param3;
               _loc13_[_loc10_ + _loc7_ * _loc9_ + 2] *= param4;
               _loc7_++;
            }
            if(_loc15_ is CompactSubGeometry)
            {
               CompactSubGeometry(_loc15_).updateData(_loc13_);
            }
            else
            {
               SubGeometry(_loc15_).updateVertexData(_loc13_);
            }
            _loc6_++;
         }
         param1.scaleX = param1.scaleY = param1.scaleZ = 1;
         if(param5)
         {
            param1.x *= param2;
            param1.y *= param3;
            param1.z *= param4;
         }
      }
      
      public static function applyScalesContainer(param1:ObjectContainer3D, param2:Number, param3:Number, param4:Number, param5:ObjectContainer3D = null) : void
      {
         var _loc6_:ObjectContainer3D = null;
         param5 = param5;
         if(param1 is Mesh && ObjectContainer3D(param1).numChildren == 0)
         {
            applyScales(Mesh(param1),param2,param3,param4,param1);
         }
         var _loc7_:uint = 0;
         while(_loc7_ < ObjectContainer3D(param1).numChildren)
         {
            _loc6_ = ObjectContainer3D(param1).getChildAt(_loc7_);
            applyScalesContainer(_loc6_,param2,param3,param4,param1);
            _loc7_++;
         }
      }
      
      public static function applyPosition(param1:Mesh, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc12_:Vector.<Number> = null;
         var _loc14_:ISubGeometry = null;
         var _loc10_:Geometry = param1.geometry;
         var _loc11_:Vector.<ISubGeometry> = _loc10_.subGeometries;
         var _loc13_:uint = _loc11_.length;
         _loc5_ = 0;
         while(_loc5_ < _loc13_)
         {
            _loc14_ = ISubGeometry(_loc11_[_loc5_]);
            _loc9_ = uint(_loc14_.vertexOffset);
            _loc8_ = _loc14_.vertexStride;
            _loc12_ = _loc14_.vertexData;
            _loc7_ = _loc14_.numVertices;
            _loc6_ = 0;
            while(_loc6_ < _loc7_)
            {
               _loc12_[_loc9_ + _loc6_ * _loc8_ + 0] += param2;
               _loc12_[_loc9_ + _loc6_ * _loc8_ + 1] += param3;
               _loc12_[_loc9_ + _loc6_ * _loc8_ + 2] += param4;
               _loc6_++;
            }
            if(_loc14_ is CompactSubGeometry)
            {
               CompactSubGeometry(_loc14_).updateData(_loc12_);
            }
            else
            {
               SubGeometry(_loc14_).updateVertexData(_loc12_);
            }
            _loc5_++;
         }
         param1.x -= param2;
         param1.y -= param3;
         param1.z -= param4;
      }
      
      public static function clone(param1:Mesh, param2:String = "") : Mesh
      {
         var _loc3_:Geometry = param1.geometry.clone();
         var _loc4_:Mesh = new Mesh(_loc3_,param1.material);
         _loc4_.name = param2;
         return _loc4_;
      }
      
      public static function invertFacesInContainer(param1:ObjectContainer3D) : void
      {
         var _loc2_:ObjectContainer3D = null;
         if(param1 is Mesh && ObjectContainer3D(param1).numChildren == 0)
         {
            invertFaces(Mesh(param1));
         }
         var _loc3_:uint = 0;
         while(_loc3_ < ObjectContainer3D(param1).numChildren)
         {
            _loc2_ = ObjectContainer3D(param1).getChildAt(_loc3_);
            invertFacesInContainer(_loc2_);
            _loc3_++;
         }
      }
      
      public static function invertFaces(param1:Mesh, param2:Boolean = false) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc14_:Vector.<uint> = null;
         var _loc15_:Vector.<uint> = null;
         var _loc16_:Vector.<Number> = null;
         var _loc17_:Vector.<Number> = null;
         var _loc18_:Vector.<Number> = null;
         var _loc20_:ISubGeometry = null;
         var _loc12_:Geometry = param1.geometry;
         var _loc13_:Vector.<ISubGeometry> = _loc12_.subGeometries;
         var _loc19_:uint = _loc13_.length;
         _loc3_ = 0;
         while(_loc3_ < _loc19_)
         {
            _loc20_ = ISubGeometry(_loc13_[_loc3_]);
            _loc14_ = _loc20_.indexData;
            _loc15_ = _loc20_.indexData.concat();
            _loc16_ = _loc20_.vertexNormalData;
            _loc9_ = uint(_loc20_.vertexNormalOffset);
            _loc8_ = _loc20_.vertexNormalStride;
            _loc18_ = _loc20_.UVData;
            _loc11_ = uint(_loc20_.UVOffset);
            _loc10_ = _loc20_.UVStride;
            _loc5_ = _loc20_.numVertices;
            _loc17_ = _loc20_.vertexTangentData;
            _loc7_ = uint(_loc20_.vertexTangentOffset);
            _loc6_ = _loc20_.vertexTangentStride;
            _loc3_ = 0;
            while(_loc3_ < _loc14_.length)
            {
               _loc14_[_loc3_ + 0] = _loc15_[_loc3_ + 2];
               _loc14_[_loc3_ + 1] = _loc15_[_loc3_ + 1];
               _loc14_[_loc3_ + 2] = _loc15_[_loc3_ + 0];
               _loc3_ += 3;
            }
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc16_[_loc9_ + _loc4_ * _loc8_ + 0] *= -1;
               _loc16_[_loc9_ + _loc4_ * _loc8_ + 1] *= -1;
               _loc16_[_loc9_ + _loc4_ * _loc8_ + 2] *= -1;
               _loc17_[_loc7_ + _loc4_ * _loc6_ + 0] *= -1;
               _loc17_[_loc7_ + _loc4_ * _loc6_ + 1] *= -1;
               _loc17_[_loc7_ + _loc4_ * _loc6_ + 2] *= -1;
               if(param2)
               {
                  _loc18_[_loc11_ + _loc4_ * _loc10_ + 0] = 1 - _loc18_[_loc11_ + _loc4_ * _loc10_ + 0];
               }
               _loc4_++;
            }
            if(_loc20_ is CompactSubGeometry)
            {
               CompactSubGeometry(_loc20_).updateData(_loc20_.vertexData);
            }
            else
            {
               SubGeometry(_loc20_).updateIndexData(_loc14_);
               SubGeometry(_loc20_).updateVertexNormalData(_loc16_);
               SubGeometry(_loc20_).updateVertexTangentData(_loc17_);
               SubGeometry(_loc20_).updateUVData(_loc18_);
            }
            _loc3_++;
         }
      }
      
      public static function build(param1:Vector.<Number>, param2:Vector.<uint>, param3:Vector.<Number> = null, param4:String = "", param5:MaterialBase = null, param6:Boolean = true, param7:Boolean = true, param8:Boolean = true) : Mesh
      {
         var _loc9_:uint = 0;
         var _loc10_:Vector.<ISubGeometry> = null;
         var _loc11_:Geometry = null;
         var _loc12_:Mesh = null;
         var _loc13_:SubGeometry = null;
         var _loc14_:Vector.<Number> = null;
         var _loc15_:Vector.<Number> = null;
         var _loc16_:Vector.<uint> = null;
         var _loc17_:Vector.<Number> = null;
         var _loc18_:uint = 0;
         var _loc19_:uint = 0;
         var _loc20_:uint = 0;
         var _loc21_:uint = 0;
         var _loc22_:Vertex = null;
         var _loc23_:Dictionary = null;
         var _loc24_:UV = null;
         var _loc25_:String = null;
         if(param8)
         {
            _loc10_ = GeomUtil.fromVectors(param1,param2,param3,null,null,null,null);
            _loc11_ = new Geometry();
            _loc9_ = 0;
            while(_loc9_ < _loc10_.length)
            {
               _loc10_[_loc9_].autoDeriveVertexNormals = true;
               _loc10_[_loc9_].autoDeriveVertexTangents = true;
               _loc11_.addSubGeometry(_loc10_[_loc9_]);
               _loc9_++;
            }
            param5 = !param5 ? DefaultMaterialManager.getDefaultMaterial() : param5;
            _loc12_ = new Mesh(_loc11_,param5);
            if(param4 != "")
            {
               _loc12_.name = param4;
            }
            return _loc12_;
         }
         _loc13_ = new SubGeometry();
         _loc13_.autoDeriveVertexNormals = true;
         _loc13_.autoDeriveVertexTangents = true;
         _loc11_ = new Geometry();
         _loc11_.addSubGeometry(_loc13_);
         param5 = !param5 && param7 ? DefaultMaterialManager.getDefaultMaterial() : param5;
         _loc12_ = new Mesh(_loc11_,param5);
         if(param4 != "")
         {
            _loc12_.name = param4;
         }
         _loc14_ = new Vector.<Number>();
         _loc15_ = new Vector.<Number>();
         _loc16_ = new Vector.<uint>();
         _loc17_ = Vector.<Number>([0,1,0.5,0,1,1,0.5,0]);
         _loc18_ = 0;
         if(param6)
         {
            _loc23_ = new Dictionary();
            _loc24_ = new UV();
         }
         _loc22_ = new Vertex();
         _loc9_ = 0;
         for(; _loc9_ < param2.length; _loc9_++)
         {
            _loc21_ = param2[_loc9_] * 3;
            _loc22_.x = param1[_loc21_];
            _loc22_.y = param1[_loc21_ + 1];
            _loc22_.z = param1[_loc21_ + 2];
            if(_loc14_.length == LIMIT)
            {
               _loc13_.updateVertexData(_loc14_);
               _loc13_.updateIndexData(_loc16_);
               _loc13_.updateUVData(_loc15_);
               if(param6)
               {
                  _loc23_ = null;
                  _loc23_ = new Dictionary();
               }
               _loc13_ = new SubGeometry();
               _loc13_.autoDeriveVertexNormals = true;
               _loc13_.autoDeriveVertexTangents = true;
               _loc11_.addSubGeometry(_loc13_);
               _loc18_ = 0;
               _loc14_ = new Vector.<Number>();
               _loc16_ = new Vector.<uint>();
               _loc15_ = new Vector.<Number>();
            }
            _loc20_ = _loc14_.length / 3;
            _loc19_ = param2[_loc9_] * 2;
            if(param6)
            {
               _loc24_.u = param3[_loc19_];
               _loc24_.v = param3[_loc19_ + 1];
               _loc25_ = _loc22_.toString() + _loc24_.toString();
               if(_loc23_[_loc25_])
               {
                  _loc16_[_loc16_.length] = _loc23_[_loc25_];
                  continue;
               }
               _loc23_[_loc25_] = _loc20_;
            }
            _loc16_[_loc16_.length] = _loc20_;
            _loc14_.push(_loc22_.x,_loc22_.y,_loc22_.z);
            if(!param3 || _loc19_ > param3.length - 2)
            {
               _loc15_.push(_loc17_[_loc18_],_loc17_[_loc18_ + 1]);
               _loc18_ = _loc18_ + 2;
               _loc18_ = _loc18_ + 2 > 3 ? 0 : (_loc18_);
            }
            else
            {
               _loc15_.push(param3[_loc19_],param3[_loc19_ + 1]);
            }
         }
         if(param6)
         {
            _loc23_ = null;
         }
         _loc13_.updateVertexData(_loc14_);
         _loc13_.updateIndexData(_loc16_);
         _loc13_.updateUVData(_loc15_);
         return _loc12_;
      }
      
      public static function splitMesh(param1:Mesh, param2:Boolean = false) : Vector.<Mesh>
      {
         var i:uint;
         var vertices:Vector.<Number> = null;
         var indices:Vector.<uint> = null;
         var uvs:Vector.<Number> = null;
         var normals:Vector.<Number> = null;
         var tangents:Vector.<Number> = null;
         var subGeom:ISubGeometry = null;
         var nGeom:Geometry = null;
         var nSubGeom:SubGeometry = null;
         var nm:Mesh = null;
         var nMeshMat:MaterialBase = null;
         var j:uint = 0;
         var mesh:Mesh = param1;
         var disposeSource:Boolean = param2;
         var meshes:Vector.<Mesh> = new Vector.<Mesh>();
         var geometries:Vector.<ISubGeometry> = mesh.geometry.subGeometries;
         var numSubGeoms:uint = geometries.length;
         if(numSubGeoms == 1)
         {
            meshes.push(mesh);
            return meshes;
         }
         if(geometries[0] is CompactSubGeometry)
         {
            return splitMeshCsg(mesh,disposeSource);
         }
         j = 0;
         i = 0;
         while(i < numSubGeoms)
         {
            if(geometries[0] is SubGeometry)
            {
               subGeom = SubGeometry(geometries[i]);
            }
            vertices = subGeom.vertexData;
            indices = subGeom.indexData;
            uvs = subGeom.UVData;
            try
            {
               normals = subGeom.vertexNormalData;
               subGeom.autoDeriveVertexNormals = false;
            }
            catch(e:Error)
            {
               subGeom.autoDeriveVertexNormals = true;
               normals = new Vector.<Number>();
               j = 0;
               while(j < vertices.length)
               {
                  var _loc5_:uint;
                  normals[_loc5_ = j++] = 0;
               }
            }
            try
            {
               tangents = subGeom.vertexTangentData;
               subGeom.autoDeriveVertexTangents = false;
            }
            catch(e:Error)
            {
               subGeom.autoDeriveVertexTangents = true;
               tangents = new Vector.<Number>();
               j = 0;
               while(j < vertices.length)
               {
                  tangents[_loc5_ = j++] = 0;
               }
            }
            vertices.fixed = false;
            indices.fixed = false;
            uvs.fixed = false;
            normals.fixed = false;
            tangents.fixed = false;
            nGeom = new Geometry();
            nm = new Mesh(nGeom,mesh.subMeshes[i].material ? mesh.subMeshes[i].material : nMeshMat);
            nSubGeom = new SubGeometry();
            nSubGeom.updateVertexData(vertices);
            nSubGeom.updateIndexData(indices);
            nSubGeom.updateUVData(uvs);
            nSubGeom.updateVertexNormalData(normals);
            nSubGeom.updateVertexTangentData(tangents);
            nGeom.addSubGeometry(nSubGeom);
            meshes.push(nm);
            i++;
         }
         if(disposeSource)
         {
            mesh = null;
         }
         return meshes;
      }
      
      private static function splitMeshCsg(param1:Mesh, param2:Boolean = false) : Vector.<Mesh>
      {
         var _loc6_:ISubGeometry = null;
         var _loc7_:Geometry = null;
         var _loc8_:CompactSubGeometry = null;
         var _loc9_:Mesh = null;
         var _loc10_:MaterialBase = null;
         var _loc3_:Vector.<Mesh> = new Vector.<Mesh>();
         var _loc4_:Vector.<ISubGeometry> = param1.geometry.subGeometries;
         var _loc5_:uint = _loc4_.length;
         if(_loc5_ == 1)
         {
            _loc3_.push(param1);
            return _loc3_;
         }
         var _loc11_:uint = 0;
         while(_loc11_ < _loc5_)
         {
            _loc6_ = CompactSubGeometry(_loc4_[_loc11_]);
            _loc7_ = new Geometry();
            _loc9_ = new Mesh(_loc7_,param1.subMeshes[_loc11_].material ? param1.subMeshes[_loc11_].material : _loc10_);
            _loc8_ = new CompactSubGeometry();
            _loc8_.updateData(_loc6_.vertexData);
            _loc8_.updateIndexData(_loc6_.indexData);
            _loc7_.addSubGeometry(_loc8_);
            _loc3_.push(_loc9_);
            _loc11_++;
         }
         if(param2)
         {
            param1 = null;
         }
         return _loc3_;
      }
   }
}

