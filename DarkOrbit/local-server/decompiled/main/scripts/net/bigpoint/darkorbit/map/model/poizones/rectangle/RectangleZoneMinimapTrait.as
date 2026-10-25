package net.bigpoint.darkorbit.map.model.poizones.rectangle
{
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
   
   public class RectangleZoneMinimapTrait extends AbstractMiniMapTrait
   {
      
      private static const GLOW_FILTER:Array = [new GlowFilter(16777215)];
      
      private var _factionIcon:DisplayObject;
      
      public function RectangleZoneMinimapTrait()
      {
         super(new Sprite(),false,false);
      }
      
      override protected function update() : void
      {
         var _loc1_:Sprite = null;
         var _loc3_:Point = null;
         var _loc11_:BitmapData = null;
         var _loc12_:uint = 0;
         var _loc13_:int = 0;
         super.update();
         _loc1_ = _icon as Sprite;
         var _loc2_:RectangleZone = owner as RectangleZone;
         _loc3_ = new Point(_loc2_.position.x * _scale,_loc2_.position.y * _scale);
         var _loc4_:uint = POIZoneStyle.getMinimapFillTypeForZoneType(_loc2_);
         var _loc5_:uint = POIZoneStyle.getFillColorForZoneType(_loc2_);
         var _loc6_:Number = POIZoneStyle.getMinimapFillAlphaForZoneType(_loc2_);
         var _loc7_:uint = POIZoneStyle.getLineColorForZoneType(_loc2_);
         var _loc8_:Number = POIZoneStyle.getLineAlphaForZoneType(_loc2_);
         var _loc9_:Number = POIZoneStyle.getLineThicknessForZoneType(_loc2_);
         _loc1_.graphics.clear();
         _loc1_.graphics.lineStyle(_loc9_,_loc7_,Math.min(_loc8_,1));
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
         var _loc10_:Point = new Point(_loc2_.width * _scale,_loc2_.height * _scale);
         if(_loc2_.inverted)
         {
            _loc12_ = _loc2_.borderSize.value * _scale;
            if(_loc2_.zoneType == POIZone.ZONE_TYPE_NOA)
            {
               _loc1_.graphics.drawRect(_loc3_.x - Math.round(_loc12_ / 2),_loc3_.y - Math.round(_loc12_ / 2),_loc10_.x + _loc12_,_loc10_.y + _loc12_);
               _loc1_.graphics.drawRect(_loc3_.x + _loc10_.x,_loc3_.y + _loc10_.y,-_loc10_.x,-_loc10_.y);
            }
            else
            {
               _loc1_.graphics.drawRect(0,0,1000,1000);
               _loc1_.graphics.drawRect(_loc3_.x + _loc10_.x,_loc3_.y + _loc10_.y,-_loc10_.x,-_loc10_.y);
            }
         }
         else
         {
            _loc1_.graphics.drawRect(_loc3_.x,_loc3_.y,_loc10_.x,_loc10_.y);
         }
         _loc1_.graphics.endFill();
         if(this._factionIcon)
         {
            _loc1_.removeChild(this._factionIcon);
            this._factionIcon = null;
         }
         if(_loc2_.zoneType == POIZone.ZONE_TYPE_SECTOR_CONTROL_HOME_ZONE)
         {
            _loc13_ = InGameCatalog.getFactionIdByName(_loc2_.zoneTypeSpecification.value);
            if(_loc13_ != -1)
            {
               this._factionIcon = ResourceManager.getBitmap("icons","fraction" + _loc13_);
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
   }
}

