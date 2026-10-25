package away3d.core.base
{
   import away3d.arcane;
   import away3d.events.GeometryEvent;
   import away3d.library.assets.AssetType;
   import away3d.library.assets.IAsset;
   import away3d.library.assets.NamedAssetBase;
   import flash.geom.Matrix3D;
   
   use namespace arcane;
   
   public class Geometry extends NamedAssetBase implements IAsset
   {
      
      private var _subGeometries:Vector.<ISubGeometry>;
      
      public function Geometry()
      {
         super();
         this._subGeometries = new Vector.<ISubGeometry>();
      }
      
      public function get assetType() : String
      {
         return AssetType.GEOMETRY;
      }
      
      public function get subGeometries() : Vector.<ISubGeometry>
      {
         return this._subGeometries;
      }
      
      public function applyTransformation(param1:Matrix3D) : void
      {
         var _loc2_:uint = this._subGeometries.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this._subGeometries[_loc3_].applyTransformation(param1);
            _loc3_++;
         }
      }
      
      public function addSubGeometry(param1:ISubGeometry) : void
      {
         this._subGeometries.push(param1);
         param1.parentGeometry = this;
         if(hasEventListener(GeometryEvent.SUB_GEOMETRY_ADDED))
         {
            dispatchEvent(new GeometryEvent(GeometryEvent.SUB_GEOMETRY_ADDED,param1));
         }
         this.invalidateBounds(param1);
      }
      
      public function removeSubGeometry(param1:ISubGeometry) : void
      {
         this._subGeometries.splice(this._subGeometries.indexOf(param1),1);
         param1.parentGeometry = null;
         if(hasEventListener(GeometryEvent.SUB_GEOMETRY_REMOVED))
         {
            dispatchEvent(new GeometryEvent(GeometryEvent.SUB_GEOMETRY_REMOVED,param1));
         }
         this.invalidateBounds(param1);
      }
      
      public function clone() : Geometry
      {
         var _loc1_:Geometry = new Geometry();
         var _loc2_:uint = this._subGeometries.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_.addSubGeometry(this._subGeometries[_loc3_].clone());
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function scale(param1:Number) : void
      {
         var _loc2_:uint = this._subGeometries.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            this._subGeometries[_loc3_].scale(param1);
            _loc3_++;
         }
      }
      
      public function dispose() : void
      {
         var _loc3_:ISubGeometry = null;
         var _loc1_:uint = this._subGeometries.length;
         var _loc2_:uint = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._subGeometries[0];
            this.removeSubGeometry(_loc3_);
            _loc3_.dispose();
            _loc2_++;
         }
      }
      
      public function scaleUV(param1:Number = 1, param2:Number = 1) : void
      {
         var _loc3_:uint = this._subGeometries.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            this._subGeometries[_loc4_].scaleUV(param1,param2);
            _loc4_++;
         }
      }
      
      public function convertToSeparateBuffers() : void
      {
         var _loc1_:ISubGeometry = null;
         var _loc5_:CompactSubGeometry = null;
         var _loc2_:int = int(this._subGeometries.length);
         var _loc3_:Vector.<CompactSubGeometry> = new Vector.<CompactSubGeometry>();
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc1_ = this._subGeometries[_loc4_];
            if(!(_loc1_ is SubGeometry))
            {
               _loc3_.push(_loc1_);
               this.addSubGeometry(_loc1_.cloneWithSeperateBuffers());
            }
            _loc4_++;
         }
         for each(_loc5_ in _loc3_)
         {
            this.removeSubGeometry(_loc5_);
            _loc5_.dispose();
         }
      }
      
      arcane function validate() : void
      {
      }
      
      arcane function invalidateBounds(param1:ISubGeometry) : void
      {
         if(hasEventListener(GeometryEvent.BOUNDS_INVALID))
         {
            dispatchEvent(new GeometryEvent(GeometryEvent.BOUNDS_INVALID,param1));
         }
      }
   }
}

