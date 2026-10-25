package away3d.tools.utils
{
   import away3d.arcane;
   import away3d.containers.ObjectContainer3D;
   import away3d.entities.Entity;
   import away3d.entities.Mesh;
   import away3d.lights.LightBase;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   
   use namespace arcane;
   
   public class Bounds
   {
      
      private static var _minX:Number;
      
      private static var _minY:Number;
      
      private static var _minZ:Number;
      
      private static var _maxX:Number;
      
      private static var _maxY:Number;
      
      private static var _maxZ:Number;
      
      private static var _containers:Dictionary;
      
      private static var _defaultPosition:Vector3D = new Vector3D(0,0,0);
      
      public function Bounds()
      {
         super();
      }
      
      public static function getMeshBounds(param1:Mesh) : void
      {
         getObjectContainerBounds(param1);
      }
      
      public static function getObjectContainerBounds(param1:ObjectContainer3D, param2:Boolean = true) : void
      {
         var _loc3_:Vector.<Number> = null;
         var _loc4_:Vector.<Number> = null;
         reset();
         parseObjectContainerBounds(param1);
         if(isInfinite(_minX) || isInfinite(_minY) || isInfinite(_minZ) || isInfinite(_maxX) || isInfinite(_maxY) || isInfinite(_maxZ))
         {
            return;
         }
         if(param2)
         {
            _loc3_ = Vector.<Number>([Infinity,Infinity,Infinity,-Infinity,-Infinity,-Infinity]);
            _loc4_ = getBoundsCorners(_minX,_minY,_minZ,_maxX,_maxY,_maxZ);
            transformContainer(_loc3_,_loc4_,param1.sceneTransform);
            _minX = _loc3_[0];
            _minY = _loc3_[1];
            _minZ = _loc3_[2];
            _maxX = _loc3_[3];
            _maxY = _loc3_[4];
            _maxZ = _loc3_[5];
         }
      }
      
      public static function getVerticesVectorBounds(param1:Vector.<Number>) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         reset();
         var _loc2_:uint = param1.length;
         if(_loc2_ % 3 != 0)
         {
            return;
         }
         var _loc6_:uint = 0;
         while(_loc6_ < _loc2_)
         {
            _loc3_ = param1[_loc6_];
            _loc4_ = param1[_loc6_ + 1];
            _loc5_ = param1[_loc6_ + 2];
            if(_loc3_ < _minX)
            {
               _minX = _loc3_;
            }
            if(_loc3_ > _maxX)
            {
               _maxX = _loc3_;
            }
            if(_loc4_ < _minY)
            {
               _minY = _loc4_;
            }
            if(_loc4_ > _maxY)
            {
               _maxY = _loc4_;
            }
            if(_loc5_ < _minZ)
            {
               _minZ = _loc5_;
            }
            if(_loc5_ > _maxZ)
            {
               _maxZ = _loc5_;
            }
            _loc6_ += 3;
         }
      }
      
      public static function getCenter(param1:Vector3D = null) : Vector3D
      {
         var _loc2_:Vector3D = param1 || new Vector3D();
         _loc2_.x = _minX + (_maxX - _minX) * 0.5;
         _loc2_.y = _minY + (_maxY - _minY) * 0.5;
         _loc2_.z = _minZ + (_maxZ - _minZ) * 0.5;
         return _loc2_;
      }
      
      public static function get minX() : Number
      {
         return _minX;
      }
      
      public static function get minY() : Number
      {
         return _minY;
      }
      
      public static function get minZ() : Number
      {
         return _minZ;
      }
      
      public static function get maxX() : Number
      {
         return _maxX;
      }
      
      public static function get maxY() : Number
      {
         return _maxY;
      }
      
      public static function get maxZ() : Number
      {
         return _maxZ;
      }
      
      public static function get width() : Number
      {
         return _maxX - _minX;
      }
      
      public static function get height() : Number
      {
         return _maxY - _minY;
      }
      
      public static function get depth() : Number
      {
         return _maxZ - _minZ;
      }
      
      private static function reset() : void
      {
         _containers = new Dictionary();
         _minX = _minY = _minZ = Infinity;
         _maxX = _maxY = _maxZ = -Infinity;
         _defaultPosition.x = 0;
         _defaultPosition.y = 0;
         _defaultPosition.z = 0;
      }
      
      private static function parseObjectContainerBounds(param1:ObjectContainer3D, param2:Matrix3D = null) : void
      {
         var _loc4_:ObjectContainer3D = null;
         var _loc9_:Matrix3D = null;
         if(!param1.visible)
         {
            return;
         }
         var _loc3_:Vector.<Number> = _containers[param1] = _containers[param1] || Vector.<Number>([Infinity,Infinity,Infinity,-Infinity,-Infinity,-Infinity]);
         var _loc5_:Entity = param1 as Entity;
         var _loc6_:Matrix3D = new Matrix3D();
         if(Boolean(_loc5_) && Boolean(param2))
         {
            parseObjectBounds(param1,param2);
            _loc6_ = param1.transform.clone();
            if(param2)
            {
               _loc6_.append(param2);
            }
         }
         else if(Boolean(_loc5_) && !param2)
         {
            _loc9_ = param1.transform.clone();
            _loc9_.invert();
            parseObjectBounds(param1,_loc9_);
         }
         var _loc7_:uint = 0;
         while(_loc7_ < param1.numChildren)
         {
            _loc4_ = param1.getChildAt(_loc7_);
            parseObjectContainerBounds(_loc4_,_loc6_);
            _loc7_++;
         }
         var _loc8_:Vector.<Number> = _containers[param1.parent];
         if(!_loc5_ && Boolean(param2))
         {
            parseObjectBounds(param1,param2,true);
         }
         if(_loc8_)
         {
            _loc8_[0] = Math.min(_loc8_[0],_loc3_[0]);
            _loc8_[1] = Math.min(_loc8_[1],_loc3_[1]);
            _loc8_[2] = Math.min(_loc8_[2],_loc3_[2]);
            _loc8_[3] = Math.max(_loc8_[3],_loc3_[3]);
            _loc8_[4] = Math.max(_loc8_[4],_loc3_[4]);
            _loc8_[5] = Math.max(_loc8_[5],_loc3_[5]);
         }
         else
         {
            _minX = _loc3_[0];
            _minY = _loc3_[1];
            _minZ = _loc3_[2];
            _maxX = _loc3_[3];
            _maxY = _loc3_[4];
            _maxZ = _loc3_[5];
         }
      }
      
      private static function isInfinite(param1:Number) : Boolean
      {
         return param1 == Number.POSITIVE_INFINITY || param1 == Number.NEGATIVE_INFINITY;
      }
      
      private static function parseObjectBounds(param1:ObjectContainer3D, param2:Matrix3D = null, param3:Boolean = false) : void
      {
         var _loc5_:Vector.<Number> = null;
         if(param1 is LightBase)
         {
            return;
         }
         var _loc4_:Entity = param1 as Entity;
         var _loc6_:Matrix3D = param1.transform.clone();
         var _loc7_:Vector.<Number> = _containers[param1];
         if(_loc4_)
         {
            if(isInfinite(_loc4_.minX) || isInfinite(_loc4_.minY) || isInfinite(_loc4_.minZ) || isInfinite(_loc4_.maxX) || isInfinite(_loc4_.maxY) || isInfinite(_loc4_.maxZ))
            {
               return;
            }
            _loc5_ = getBoundsCorners(_loc4_.minX,_loc4_.minY,_loc4_.minZ,_loc4_.maxX,_loc4_.maxY,_loc4_.maxZ);
            if(param2)
            {
               _loc6_.append(param2);
            }
         }
         else
         {
            _loc5_ = getBoundsCorners(_loc7_[0],_loc7_[1],_loc7_[2],_loc7_[3],_loc7_[4],_loc7_[5]);
            if(param2)
            {
               _loc6_.prepend(param2);
            }
         }
         if(param3)
         {
            _loc7_[0] = _loc7_[1] = _loc7_[2] = Infinity;
            _loc7_[3] = _loc7_[4] = _loc7_[5] = -Infinity;
         }
         transformContainer(_loc7_,_loc5_,_loc6_);
      }
      
      private static function getBoundsCorners(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : Vector.<Number>
      {
         return Vector.<Number>([param1,param2,param3,param1,param2,param6,param1,param5,param3,param1,param5,param6,param4,param2,param3,param4,param2,param6,param4,param5,param3,param4,param5,param6]);
      }
      
      private static function transformContainer(param1:Vector.<Number>, param2:Vector.<Number>, param3:Matrix3D) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         param3.transformVectors(param2,param2);
         var _loc7_:* = 0;
         while(_loc7_ < param2.length)
         {
            _loc4_ = param2[_loc7_++];
            _loc5_ = param2[_loc7_++];
            _loc6_ = param2[_loc7_++];
            if(_loc4_ < param1[0])
            {
               param1[0] = _loc4_;
            }
            if(_loc4_ > param1[3])
            {
               param1[3] = _loc4_;
            }
            if(_loc5_ < param1[1])
            {
               param1[1] = _loc5_;
            }
            if(_loc5_ > param1[4])
            {
               param1[4] = _loc5_;
            }
            if(_loc6_ < param1[2])
            {
               param1[2] = _loc6_;
            }
            if(_loc6_ > param1[5])
            {
               param1[5] = _loc6_;
            }
         }
      }
   }
}

