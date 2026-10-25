package net.bigpoint.darkorbit.map.view3D.display3D.zones
{
   import away3d.containers.ObjectContainer3D;
   import away3d.entities.Mesh;
   import away3d.materials.MaterialBase;
   import away3d.primitives.PlaneGeometry;
   import net.bigpoint.darkorbit.map.model.poizones.POIZone;
   import net.bigpoint.darkorbit.map.model.poizones.rectangle.RectangleZone;
   import net.bigpoint.darkorbit.map.model.poizones.rectangle.RectangleZoneDisplayTrait;
   
   public class RectanglePoizone3D extends AbstractZoneView3D
   {
      
      public static var test:Number = 0;
      
      private static const CORNER_OFFSET:int = 40;
      
      private var _zone:RectangleZone;
      
      private var _view:ObjectContainer3D;
      
      public function RectanglePoizone3D(param1:RectangleZoneDisplayTrait)
      {
         this._zone = param1.owner as RectangleZone;
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
         var _loc3_:Mesh = null;
         var _loc4_:Mesh = null;
         var _loc5_:Mesh = null;
         var _loc6_:Mesh = null;
         var _loc7_:ObjectContainer3D = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Mesh = null;
         var _loc2_:PlaneGeometry = new PlaneGeometry(1,1);
         if(this._zone.inverted)
         {
            _loc3_ = new Mesh(_loc2_,param1);
            _loc4_ = new Mesh(_loc2_,param1);
            _loc5_ = new Mesh(_loc2_,param1);
            _loc6_ = new Mesh(_loc2_,param1);
            _loc7_ = new ObjectContainer3D();
            _loc7_.addChildren(_loc4_,_loc3_,_loc5_,_loc6_);
            _loc8_ = this._zone.borderSize.value;
            _loc9_ = this._zone.borderSize.value;
            _loc4_.scaleX = this._zone.width;
            _loc4_.scaleZ = _loc8_;
            _loc4_.z -= this._zone.height / 2 + _loc8_ / 2;
            _loc3_.scaleX = this._zone.width;
            _loc3_.scaleZ = _loc8_;
            _loc3_.z += this._zone.height / 2 + _loc8_ / 2;
            _loc5_.scaleX = _loc9_;
            _loc5_.scaleZ = this._zone.height + _loc8_ * 2;
            _loc5_.x += this._zone.width / 2 + _loc8_ / 2;
            _loc6_.scaleX = _loc9_;
            _loc6_.scaleZ = this._zone.height + _loc8_ * 2;
            _loc6_.x -= this._zone.width / 2 + _loc8_ / 2;
            x = this._zone.x3D + this._zone.width / 2;
            y = this._zone.y3D;
            z = this._zone.z3D - this._zone.height / 2;
            this._view = _loc7_;
            this.addChild(_loc7_);
         }
         else
         {
            _loc10_ = new Mesh(_loc2_,param1);
            x = this._zone.x3D + this._zone.width / 2;
            y = this._zone.y3D;
            z = this._zone.z3D - this._zone.height / 2;
            _loc10_.scaleX = this._zone.width;
            _loc10_.scaleZ = this._zone.height;
            this.addChild(_loc10_);
            this._view = _loc10_;
         }
      }
   }
}

