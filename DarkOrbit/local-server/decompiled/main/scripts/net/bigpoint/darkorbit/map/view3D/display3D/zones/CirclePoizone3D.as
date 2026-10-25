package net.bigpoint.darkorbit.map.view3D.display3D.zones
{
   import away3d.entities.Mesh;
   import away3d.materials.MaterialBase;
   import away3d.primitives.CylinderGeometry;
   import net.bigpoint.darkorbit.map.model.poizones.POIZone;
   import net.bigpoint.darkorbit.map.model.poizones.circle.CircleZone;
   import net.bigpoint.darkorbit.map.model.poizones.circle.CircleZoneDisplayTrait;
   
   public class CirclePoizone3D extends AbstractZoneView3D
   {
      
      private var _zone:CircleZone;
      
      private var _mesh:Mesh;
      
      public function CirclePoizone3D(param1:CircleZoneDisplayTrait)
      {
         this._zone = param1.owner as CircleZone;
         super(param1.owner as POIZone);
      }
      
      override protected function drawZone(param1:MaterialBase) : void
      {
         if(this._mesh)
         {
            if(this._mesh.parent)
            {
               this._mesh.parent.removeChild(this._mesh);
            }
            this._mesh = null;
         }
         var _loc2_:int = this._zone.radius.value;
         var _loc3_:CylinderGeometry = new CylinderGeometry(_loc2_,0,0,64);
         x = this._zone.x3D;
         y = this._zone.y3D;
         z = this._zone.z3D;
         if(this._zone.inverted)
         {
            _loc3_.topClosed = false;
            _loc3_.bottomClosed = false;
            _loc3_.bottomRadius = _loc2_ + this._zone.borderSize.value;
         }
         this._mesh = new Mesh(_loc3_,param1);
         addChild(this._mesh);
      }
   }
}

