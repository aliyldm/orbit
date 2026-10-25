package net.bigpoint.darkorbit.map.view3D.display3D.zones
{
   import away3d.containers.ObjectContainer3D;
   import away3d.core.base.Geometry;
   import away3d.core.base.SubGeometry;
   import away3d.entities.Mesh;
   import away3d.materials.MaterialBase;
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.map.model.poizones.POIZone;
   import net.bigpoint.darkorbit.map.model.poizones.polygon.PoligonZone;
   import net.bigpoint.darkorbit.map.model.poizones.polygon.PoligonZoneDisplayTrait;
   
   public class PoligonZone3D extends AbstractZoneView3D
   {
      
      private var _zone:PoligonZone;
      
      private var _view:ObjectContainer3D;
      
      public function PoligonZone3D(param1:PoligonZoneDisplayTrait)
      {
         this._zone = param1.owner as PoligonZone;
         super(param1.owner as POIZone);
      }
      
      override protected function drawZone(param1:MaterialBase) : void
      {
         if(this._view)
         {
            if(this._view.parent)
            {
               this._view.parent.removeChild(this._view);
            }
            this._view = null;
         }
         this.update(param1);
      }
      
      private function update(param1:MaterialBase) : void
      {
         var _loc12_:PointLite = null;
         var _loc2_:Vector.<Number> = new Vector.<Number>();
         var _loc3_:Vector.<Number> = new Vector.<Number>();
         var _loc4_:Vector.<Number> = new Vector.<Number>();
         var _loc5_:Vector.<uint> = new Vector.<uint>();
         var _loc6_:Number = 0;
         var _loc7_:Number = this._zone.points.length;
         var _loc8_:Number = 0;
         while(_loc8_ < _loc7_)
         {
            _loc12_ = this._zone.points[_loc8_];
            _loc2_.push(_loc12_.x,_loc12_.z,-_loc12_.y);
            _loc3_.push(0,1,0);
            _loc4_.push(0,1);
            if(_loc8_ > 1)
            {
               _loc5_.push(0,_loc6_ + 2,_loc6_ + 1);
               _loc5_.push(0,_loc6_ + 1,_loc6_ + 2);
               _loc6_++;
            }
            _loc8_++;
         }
         var _loc9_:SubGeometry = new SubGeometry();
         _loc9_.updateVertexData(_loc2_);
         _loc9_.updateVertexNormalData(_loc3_);
         _loc9_.updateUVData(_loc4_);
         _loc9_.updateIndexData(_loc5_);
         var _loc10_:Geometry = new Geometry();
         _loc10_.addSubGeometry(_loc9_);
         var _loc11_:Mesh = new Mesh(_loc10_,param1);
         this.addChild(_loc11_);
         this._view = _loc11_;
      }
   }
}

