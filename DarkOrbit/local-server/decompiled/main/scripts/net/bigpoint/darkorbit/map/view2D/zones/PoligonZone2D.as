package net.bigpoint.darkorbit.map.view2D.zones
{
   import com.bigpoint.utils.PointLite;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import net.bigpoint.darkorbit.map.model.poizones.POIZone;
   import net.bigpoint.darkorbit.map.model.poizones.POIZoneStyle;
   import net.bigpoint.darkorbit.map.model.poizones.polygon.PoligonZone;
   import net.bigpoint.darkorbit.map.model.poizones.polygon.PoligonZoneDisplayTrait;
   
   public class PoligonZone2D extends AbstractZoneView2D
   {
      
      public function PoligonZone2D(param1:PoligonZoneDisplayTrait)
      {
         super(param1.owner as POIZone);
      }
      
      override protected function drawZone(param1:uint, param2:BitmapData, param3:Boolean) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Matrix = null;
         var _loc7_:uint = 0;
         var _loc8_:Number = NaN;
         graphics.clear();
         if(param1 == POIZoneStyle.FILLTYPE_BITMAP)
         {
            _loc4_ = 1;
            _loc5_ = 1;
            if(param3)
            {
            }
            _loc6_ = new Matrix();
            _loc6_.scale(_loc4_,_loc5_);
            graphics.beginBitmapFill(param2,_loc6_,param3);
         }
         else
         {
            graphics.lineStyle(POIZoneStyle.getLineThicknessForZoneType(zone),POIZoneStyle.getLineColorForZoneType(zone));
            _loc7_ = POIZoneStyle.getFillColorForZoneType(zone);
            _loc8_ = POIZoneStyle.getFillAlphaForZoneType(zone);
            graphics.beginFill(_loc7_,_loc8_);
         }
         if(zone.inverted)
         {
            this.drawInverted();
         }
         else
         {
            this.drawNormalZone();
         }
         graphics.endFill();
      }
      
      private function drawInverted() : void
      {
      }
      
      private function drawNormalZone() : void
      {
         var _loc3_:PointLite = null;
         var _loc1_:int = int(this.polyZone.points.length);
         graphics.moveTo(this.polyZone.points[_loc1_ - 1].x,this.polyZone.points[_loc1_ - 1].y);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.polyZone.points[_loc2_];
            graphics.lineTo(_loc3_.x,_loc3_.y);
            _loc2_++;
         }
      }
      
      protected function get polyZone() : PoligonZone
      {
         return zone as PoligonZone;
      }
   }
}

