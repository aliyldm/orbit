package net.bigpoint.darkorbit.map.model.poizones.polygon
{
   import com.bigpoint.utils.PointLite;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.model.minimap.traits.AbstractMiniMapTrait;
   import net.bigpoint.darkorbit.map.model.poizones.POIZone;
   import net.bigpoint.darkorbit.map.model.poizones.POIZoneStyle;
   
   public class PoligonZoneMinimapTrait extends AbstractMiniMapTrait
   {
      
      private static const GLOW_FILTER:Array = [new GlowFilter(16777215)];
      
      private var _factionIcon:DisplayObject;
      
      public function PoligonZoneMinimapTrait()
      {
         super(new Sprite(),false,false);
      }
      
      override protected function update() : void
      {
         var _loc1_:Sprite = null;
         var _loc3_:Point = null;
         var _loc11_:BitmapData = null;
         var _loc12_:Point = null;
         var _loc13_:int = 0;
         var _loc14_:PointLite = null;
         var _loc15_:PointLite = null;
         var _loc16_:int = 0;
         var _loc17_:PointLite = null;
         var _loc18_:int = 0;
         super.update();
         _loc1_ = _icon as Sprite;
         var _loc2_:PoligonZone = owner as PoligonZone;
         _loc3_ = new Point(_loc2_.position.x * _scale,_loc2_.position.y * _scale);
         var _loc4_:uint = POIZoneStyle.getMinimapFillTypeForZoneType(_loc2_);
         var _loc5_:uint = POIZoneStyle.getFillColorForZoneType(_loc2_);
         var _loc6_:Number = POIZoneStyle.getMinimapFillAlphaForZoneType(_loc2_);
         var _loc7_:uint = POIZoneStyle.getLineColorForZoneType(_loc2_);
         var _loc8_:Number = POIZoneStyle.getLineAlphaForZoneType(_loc2_);
         var _loc9_:Number = POIZoneStyle.getLineThicknessForZoneType(_loc2_);
         _loc1_.graphics.clear();
         _loc1_.graphics.lineStyle(_loc9_,_loc7_,_loc8_);
         if(_loc4_ == POIZoneStyle.FILLTYPE_BITMAP)
         {
            _loc11_ = ResourceManager.getBitmapData("poizone_patterns",_loc2_.zoneType);
            _loc1_.graphics.beginBitmapFill(_loc11_,null,true);
         }
         else
         {
            _loc1_.graphics.beginFill(_loc5_,_loc6_);
         }
         if(!(_loc2_.zoneType == POIZone.ZONE_TYPE_SECTOR_CONTROL_HOME_ZONE || _loc2_.zoneType == POIZone.ZONE_TYPE_SECTOR_CONTROL_SECTOR_ZONE))
         {
            _loc1_.alpha = 0.7;
         }
         var _loc10_:uint = _loc2_.borderSize.value * _scale;
         if(_loc2_.inverted)
         {
            _loc12_ = new Point(_loc2_.bounds.width * _scale,_loc2_.bounds.width * _scale);
            if(_loc2_.zoneType == POIZone.ZONE_TYPE_NOA)
            {
               _loc13_ = int(_loc2_.points.length);
               _loc14_ = _loc2_.points[_loc13_ - 1];
               _loc15_ = _loc14_.subtract(_loc2_.center);
               _loc15_.normalize(_loc15_.length + _loc10_);
               _loc14_ = _loc15_.add(_loc14_);
               _loc1_.graphics.moveTo(_loc14_.x * _scale,_loc14_.y * _scale);
               _loc16_ = 0;
               while(_loc16_ < _loc13_)
               {
                  _loc17_ = _loc2_.points[_loc16_];
                  _loc15_ = _loc17_.subtract(_loc2_.center);
                  _loc15_.normalize(_loc15_.length + _loc10_);
                  _loc15_ = _loc15_.add(_loc17_);
                  _loc1_.graphics.lineTo(_loc15_.x * _scale,_loc15_.y * _scale);
                  _loc16_++;
               }
               _loc13_ = int(_loc2_.points.length);
               _loc1_.graphics.moveTo(_loc2_.points[_loc13_ - 1].x * _scale,_loc2_.points[_loc13_ - 1].y * _scale);
               _loc16_ = 0;
               while(_loc16_ < _loc13_)
               {
                  _loc17_ = _loc2_.points[_loc16_];
                  _loc1_.graphics.lineTo(_loc17_.x * _scale,_loc17_.y * _scale);
                  _loc16_++;
               }
            }
            else
            {
               _loc1_.graphics.drawRect(0,0,1000,1000);
               _loc13_ = int(_loc2_.points.length);
               _loc1_.graphics.moveTo(_loc2_.points[_loc13_ - 1].x * _scale,_loc2_.points[_loc13_ - 1].y * _scale);
               _loc16_ = 0;
               while(_loc16_ < _loc13_)
               {
                  _loc17_ = _loc2_.points[_loc16_];
                  _loc1_.graphics.lineTo(_loc17_.x * _scale,_loc17_.y * _scale);
                  _loc16_++;
               }
            }
         }
         else
         {
            _loc13_ = int(_loc2_.points.length);
            _loc1_.graphics.moveTo(_loc2_.points[_loc13_ - 1].x * _scale,_loc2_.points[_loc13_ - 1].y * _scale);
            _loc16_ = 0;
            while(_loc16_ < _loc13_)
            {
               _loc17_ = _loc2_.points[_loc16_];
               _loc1_.graphics.lineTo(_loc17_.x * _scale,_loc17_.y * _scale);
               _loc16_++;
            }
         }
         _loc1_.graphics.endFill();
         if(this._factionIcon)
         {
            _loc1_.removeChild(this._factionIcon);
            this._factionIcon = null;
         }
         if(_loc2_.zoneType == POIZone.ZONE_TYPE_SECTOR_CONTROL_HOME_ZONE)
         {
            _loc18_ = InGameCatalog.getFactionIdByName(_loc2_.zoneTypeSpecification.value);
            if(_loc18_ != -1)
            {
               this._factionIcon = ResourceManager.getBitmap("icons","fraction" + _loc18_);
               if(this._factionIcon != null)
               {
                  this._factionIcon.x = _loc3_.x - this._factionIcon.width / 2;
                  this._factionIcon.y = _loc3_.y - this._factionIcon.height / 2;
                  this._factionIcon.filters = GLOW_FILTER;
                  _loc1_.addChild(this._factionIcon);
               }
            }
         }
      }
      
      private function debug__drawPos(param1:Number, param2:Number) : void
      {
         var _loc3_:Sprite = _icon as Sprite;
         var _loc4_:PoligonZone = owner as PoligonZone;
         var _loc5_:Point = new Point(_loc4_.position.x * _scale,_loc4_.position.y * _scale);
         var _loc6_:uint = POIZoneStyle.getMinimapFillTypeForZoneType(_loc4_);
         var _loc7_:uint = POIZoneStyle.getFillColorForZoneType(_loc4_);
         var _loc8_:Number = POIZoneStyle.getMinimapFillAlphaForZoneType(_loc4_);
         var _loc9_:uint = POIZoneStyle.getLineColorForZoneType(_loc4_);
         var _loc10_:Number = POIZoneStyle.getLineAlphaForZoneType(_loc4_);
         var _loc11_:Number = POIZoneStyle.getLineThicknessForZoneType(_loc4_);
         _loc3_.graphics.endFill();
         _loc3_.graphics.beginFill(_loc7_,_loc8_);
         _loc3_.graphics.lineStyle(_loc11_,_loc9_,_loc10_);
         _loc3_.graphics.drawCircle(param1,param2,2 * _loc11_);
         _loc3_.graphics.endFill();
      }
      
      private function getNormal(param1:PointLite, param2:PointLite) : PointLite
      {
         var _loc3_:Number = param2.x - param1.x;
         var _loc4_:Number = param2.y - param1.y;
         return new PointLite(_loc4_,_loc3_);
      }
      
      private function getNormal4Points(param1:PointLite, param2:PointLite, param3:PointLite, param4:PointLite) : PointLite
      {
         return this.getNormal(param1,param2).subtract(this.getNormal(param3,param4));
      }
   }
}

