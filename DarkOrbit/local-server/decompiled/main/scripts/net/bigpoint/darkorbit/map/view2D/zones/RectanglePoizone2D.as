package net.bigpoint.darkorbit.map.view2D.zones
{
   import flash.display.BitmapData;
   import flash.display.GraphicsPathCommand;
   import flash.geom.Matrix;
   import net.bigpoint.darkorbit.map.model.poizones.POIZone;
   import net.bigpoint.darkorbit.map.model.poizones.POIZoneStyle;
   import net.bigpoint.darkorbit.map.model.poizones.rectangle.RectangleZone;
   import net.bigpoint.darkorbit.map.model.poizones.rectangle.RectangleZoneDisplayTrait;
   
   public class RectanglePoizone2D extends AbstractZoneView2D
   {
      
      private static const CORNER_OFFSET:int = 40;
      
      private static const DRAW_COMMANDS:Vector.<int> = new <int>[GraphicsPathCommand.MOVE_TO,GraphicsPathCommand.LINE_TO,GraphicsPathCommand.LINE_TO,GraphicsPathCommand.LINE_TO,GraphicsPathCommand.LINE_TO,GraphicsPathCommand.LINE_TO,GraphicsPathCommand.LINE_TO,GraphicsPathCommand.LINE_TO,GraphicsPathCommand.LINE_TO];
      
      public function RectanglePoizone2D(param1:RectangleZoneDisplayTrait)
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
            if(!param3)
            {
               _loc4_ = this.rectangleZone.width / param2.width;
               _loc5_ = this.rectangleZone.height / param2.height;
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
         var _loc1_:int = zone.borderSize.value;
         var _loc2_:int = zone.position.x - _loc1_;
         var _loc3_:int = zone.position.y - _loc1_;
         var _loc4_:int = zone.position.x + this.rectangleZone.width + _loc1_;
         var _loc5_:int = zone.position.y + this.rectangleZone.height + _loc1_;
         var _loc6_:Vector.<Number> = new <Number>[_loc2_,_loc3_,_loc4_,_loc3_,_loc4_,_loc5_,_loc2_,_loc5_,_loc2_,_loc3_];
         var _loc7_:int = zone.position.x;
         var _loc8_:int = zone.position.y;
         var _loc9_:int = zone.position.x + this.rectangleZone.width;
         var _loc10_:int = zone.position.y + this.rectangleZone.height;
         var _loc11_:Vector.<Number> = new <Number>[_loc7_ + CORNER_OFFSET,_loc8_,_loc9_ - CORNER_OFFSET,_loc8_,_loc9_,_loc8_ + CORNER_OFFSET,_loc9_,_loc10_ - CORNER_OFFSET,_loc9_ - CORNER_OFFSET,_loc10_,_loc7_ + CORNER_OFFSET,_loc10_,_loc7_,_loc10_ - CORNER_OFFSET,_loc7_,_loc8_ + CORNER_OFFSET,_loc7_ + CORNER_OFFSET,_loc8_];
         graphics.drawPath(DRAW_COMMANDS,_loc6_);
         graphics.drawPath(DRAW_COMMANDS,_loc11_);
      }
      
      private function drawNormalZone() : void
      {
         graphics.drawRect(zone.position.x,zone.position.y,this.rectangleZone.width,this.rectangleZone.height);
      }
      
      protected function get rectangleZone() : RectangleZone
      {
         return zone as RectangleZone;
      }
   }
}

