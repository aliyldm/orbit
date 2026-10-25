package net.bigpoint.darkorbit.map.view2D.zones
{
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import net.bigpoint.darkorbit.map.model.poizones.POIZone;
   import net.bigpoint.darkorbit.map.model.poizones.POIZoneStyle;
   import net.bigpoint.darkorbit.map.model.poizones.circle.CircleZone;
   import net.bigpoint.darkorbit.map.model.poizones.circle.CircleZoneDisplayTrait;
   
   public class CirclePoizone2D extends AbstractZoneView2D
   {
      
      public function CirclePoizone2D(param1:CircleZoneDisplayTrait)
      {
         super(param1.owner as POIZone);
         CircleZone(zone).radius.changed.add(redraw);
         redraw();
      }
      
      override protected function drawZone(param1:uint, param2:BitmapData, param3:Boolean) : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Matrix = null;
         var _loc9_:uint = 0;
         var _loc10_:Number = NaN;
         x = zone.position.x;
         y = zone.position.y;
         graphics.clear();
         var _loc4_:CircleZone = zone as CircleZone;
         var _loc5_:int = _loc4_.radius.value;
         if(param1 == POIZoneStyle.FILLTYPE_BITMAP)
         {
            _loc6_ = 1;
            _loc7_ = 1;
            if(!param3)
            {
               _loc6_ = _loc5_ * 2 / param2.width;
               _loc7_ = _loc5_ * 2 / param2.height;
            }
            _loc8_ = new Matrix();
            _loc8_.scale(_loc6_,_loc7_);
            _loc8_.translate(-_loc5_,-_loc5_);
            graphics.beginBitmapFill(param2,_loc8_,param3);
         }
         else
         {
            graphics.lineStyle(POIZoneStyle.getLineThicknessForZoneType(zone),POIZoneStyle.getLineColorForZoneType(zone));
            _loc9_ = POIZoneStyle.getFillColorForZoneType(zone);
            _loc10_ = POIZoneStyle.getFillAlphaForZoneType(zone);
            graphics.beginFill(_loc9_,_loc10_);
         }
         if(zone.inverted)
         {
            graphics.drawCircle(0,0,_loc5_ + _loc4_.borderSize.value);
         }
         graphics.drawCircle(0,0,_loc5_);
         graphics.endFill();
      }
   }
}

