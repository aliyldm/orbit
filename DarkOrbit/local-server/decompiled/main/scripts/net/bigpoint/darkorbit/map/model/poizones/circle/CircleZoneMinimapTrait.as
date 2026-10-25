package net.bigpoint.darkorbit.map.model.poizones.circle
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
   
   public class CircleZoneMinimapTrait extends AbstractMiniMapTrait
   {
      
      private static const GLOW_FILTER:Array = [new GlowFilter(16777215)];
      
      private var _factionIcon:DisplayObject;
      
      public function CircleZoneMinimapTrait()
      {
         super(new Sprite(),false,false);
      }
      
      override public function activateTrait() : void
      {
         super.activateTrait();
         CircleZone(owner).radius.changed.add(this.update);
         CircleZone(owner).zoneTypeSpecification.changed.add(this.update);
         CircleZone(owner).zoneTargetTypeSpecification.changed.add(this.update);
      }
      
      override public function deactivateTrait() : void
      {
         CircleZone(owner).radius.changed.remove(this.update);
         CircleZone(owner).zoneTypeSpecification.changed.remove(this.update);
         CircleZone(owner).zoneTargetTypeSpecification.changed.remove(this.update);
         super.deactivateTrait();
      }
      
      override protected function update() : void
      {
         var _loc1_:Sprite = null;
         var _loc3_:Point = null;
         var _loc12_:BitmapData = null;
         var _loc13_:int = 0;
         super.update();
         _loc1_ = _icon as Sprite;
         var _loc2_:CircleZone = owner as CircleZone;
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
            _loc12_ = ResourceManager.getBitmapData("poizone_patterns",_loc2_.zoneType);
            _loc1_.graphics.beginBitmapFill(_loc12_,null,true);
         }
         else
         {
            _loc1_.graphics.beginFill(_loc5_,_loc6_);
         }
         var _loc10_:uint = _loc2_.borderSize.value * _scale;
         var _loc11_:Number = _loc2_.radius.value * _scale;
         if(!(_loc2_.zoneType == POIZone.ZONE_TYPE_SECTOR_CONTROL_HOME_ZONE || _loc2_.zoneType == POIZone.ZONE_TYPE_SECTOR_CONTROL_SECTOR_ZONE))
         {
            _loc1_.alpha = 0.7;
         }
         else
         {
            _loc11_ *= 1.8;
         }
         if(_loc2_.inverted)
         {
            if(_loc2_.zoneType == POIZone.ZONE_TYPE_NOA)
            {
               _loc1_.graphics.drawEllipse(_loc3_.x - _loc11_ - Math.round(_loc10_ / 2),_loc3_.y - _loc11_ - Math.round(_loc10_ / 2),_loc11_ * 2 + _loc10_,_loc11_ * 2 + _loc10_);
               _loc1_.graphics.drawEllipse(_loc3_.x + _loc11_,_loc3_.y + _loc11_,-(_loc11_ * 2),-(_loc11_ * 2));
            }
            else
            {
               _loc1_.graphics.drawRect(0,0,100000 * _scale,100000 * _scale);
               _loc1_.graphics.drawEllipse(_loc3_.x + _loc11_,_loc3_.y + _loc11_,-(_loc11_ * 2),-(_loc11_ * 2));
            }
         }
         else
         {
            _loc1_.graphics.drawEllipse(_loc3_.x - _loc11_,_loc3_.y - _loc11_,_loc11_ * 2,_loc11_ * 2);
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

