package net.bigpoint.darkorbit.map.model.poizones
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class POIZoneStyle
   {
      
      public static const DEFAULT_ZONETYPE_FILLTYPE:uint = 0;
      
      public static const DEFAULT_ZONETYPE_FILLCOLOR:uint = 4289352960;
      
      public static const DEFAULT_ZONETYPE_MINIMAP_FILLALPHA:Number = 1;
      
      public static const DEFAULT_ZONETYPE_FILLALPHA:Number = 0.4;
      
      public static const DEFAULT_ZONETYPE_LINECOLOR:uint = 4294940928;
      
      public static const DEFAULT_ZONETYPE_LINEALPHA:Number = 0;
      
      public static const DEFAULT_ZONETYPE_LINETHICKNESS:Number = 1;
      
      public static const COLOR_RED:uint = 16711680;
      
      public static const COLOR_GREEN:uint = 65280;
      
      public static const COLOR_BLUE:uint = 255;
      
      public static const COLOR_YELLOW:uint = 16776960;
      
      public static const COLOR_WHITE:uint = 16777215;
      
      public static const COLOR_BLACK:uint = 0;
      
      public static const FILLTYPE_COLOR:uint = 0;
      
      public static const FILLTYPE_BITMAP:uint = 1;
      
      public static const DEFAULT_UNDEFINED_VALUE:uint = 4294967295;
      
      public static const zoneTypeColorDict:Dictionary = new Dictionary();
      
      createPOIColorReference();
      
      public var fillTypeMap:uint = 0;
      
      public var fillTypeMinimap:uint = 0;
      
      public var lineColor:uint = 4294940928;
      
      public var lineAlpha:Number = 0;
      
      public var fillColor:uint = 4289352960;
      
      public var minimapFillAlpha:Number = 1;
      
      public var lineThickness:Number = 1;
      
      public var fillAlpha:Number = 0.4;
      
      public function POIZoneStyle()
      {
         super();
      }
      
      public static function getFillColorForZoneType(param1:POIZone) : uint
      {
         var _loc5_:int = 0;
         var _loc2_:String = createZoneTypeKey(param1);
         var _loc3_:POIZoneStyle = POIZoneStyle.zoneTypeColorDict[_loc2_] as POIZoneStyle;
         var _loc4_:uint = POIZoneStyle.DEFAULT_UNDEFINED_VALUE;
         if(_loc3_)
         {
            _loc4_ = _loc3_.fillColor;
         }
         if(param1.zoneType == POIZone.ZONE_TYPE_SECTOR_CONTROL_HOME_ZONE || param1.zoneType == POIZone.ZONE_TYPE_SECTOR_CONTROL_SECTOR_ZONE)
         {
            _loc5_ = InGameCatalog.getFactionIdByName(param1.zoneTypeSpecification.value);
            if(_loc5_ != -1)
            {
               _loc4_ = uint(InGameCatalog.getInstance().factions_colours[_loc5_]);
            }
         }
         if(_loc4_ == POIZoneStyle.DEFAULT_UNDEFINED_VALUE)
         {
            _loc4_ = POIZoneStyle.DEFAULT_ZONETYPE_FILLCOLOR;
         }
         return _loc4_;
      }
      
      public static function getMinimapFillTypeForZoneType(param1:POIZone) : uint
      {
         var _loc2_:String = createZoneTypeKey(param1);
         var _loc3_:POIZoneStyle = POIZoneStyle.zoneTypeColorDict[_loc2_] as POIZoneStyle;
         var _loc4_:Number = POIZoneStyle.DEFAULT_ZONETYPE_FILLTYPE;
         if(_loc3_)
         {
            _loc4_ = _loc3_.fillTypeMinimap;
         }
         return _loc4_;
      }
      
      public static function getMapFillTypeForZoneType(param1:POIZone) : uint
      {
         var _loc2_:String = createZoneTypeKey(param1);
         var _loc3_:POIZoneStyle = POIZoneStyle.zoneTypeColorDict[_loc2_] as POIZoneStyle;
         var _loc4_:Number = POIZoneStyle.DEFAULT_ZONETYPE_FILLTYPE;
         if(_loc3_)
         {
            _loc4_ = _loc3_.fillTypeMap;
         }
         return _loc4_;
      }
      
      public static function getMinimapFillAlphaForZoneType(param1:POIZone) : Number
      {
         var _loc2_:String = createZoneTypeKey(param1);
         var _loc3_:POIZoneStyle = POIZoneStyle.zoneTypeColorDict[_loc2_] as POIZoneStyle;
         var _loc4_:Number = POIZoneStyle.DEFAULT_ZONETYPE_MINIMAP_FILLALPHA;
         if(_loc3_)
         {
            _loc4_ = _loc3_.minimapFillAlpha;
         }
         return _loc4_;
      }
      
      public static function getFillAlphaForZoneType(param1:POIZone) : Number
      {
         var _loc2_:String = createZoneTypeKey(param1);
         var _loc3_:POIZoneStyle = POIZoneStyle.zoneTypeColorDict[_loc2_] as POIZoneStyle;
         var _loc4_:Number = POIZoneStyle.DEFAULT_ZONETYPE_MINIMAP_FILLALPHA;
         if(_loc3_)
         {
            _loc4_ = _loc3_.fillAlpha;
         }
         return _loc4_;
      }
      
      public static function getLineColorForZoneType(param1:POIZone) : uint
      {
         var _loc5_:int = 0;
         var _loc2_:String = createZoneTypeKey(param1);
         var _loc3_:POIZoneStyle = POIZoneStyle.zoneTypeColorDict[_loc2_] as POIZoneStyle;
         var _loc4_:uint = POIZoneStyle.DEFAULT_ZONETYPE_LINECOLOR;
         if(_loc3_)
         {
            _loc4_ = _loc3_.lineColor;
         }
         if(param1.zoneType == POIZone.ZONE_TYPE_SECTOR_CONTROL_SECTOR_ZONE)
         {
            _loc5_ = InGameCatalog.getFactionIdByName(param1.zoneTypeSpecification.value);
            if(_loc5_ != -1)
            {
               _loc4_ = uint(InGameCatalog.getInstance().factions_colours[_loc5_]);
            }
            else
            {
               _loc4_ = POIZoneStyle.DEFAULT_UNDEFINED_VALUE;
            }
         }
         return _loc4_;
      }
      
      public static function getLineAlphaForZoneType(param1:POIZone) : Number
      {
         var _loc2_:String = createZoneTypeKey(param1);
         var _loc3_:POIZoneStyle = POIZoneStyle.zoneTypeColorDict[_loc2_] as POIZoneStyle;
         var _loc4_:Number = POIZoneStyle.DEFAULT_ZONETYPE_LINEALPHA;
         if(_loc3_)
         {
            _loc4_ = _loc3_.lineAlpha;
         }
         return _loc4_;
      }
      
      public static function getLineThicknessForZoneType(param1:POIZone) : Number
      {
         var _loc2_:String = createZoneTypeKey(param1);
         var _loc3_:POIZoneStyle = POIZoneStyle.zoneTypeColorDict[_loc2_] as POIZoneStyle;
         var _loc4_:Number = POIZoneStyle.DEFAULT_ZONETYPE_LINETHICKNESS;
         if(_loc3_)
         {
            _loc4_ = _loc3_.lineThickness;
         }
         return _loc4_;
      }
      
      private static function createZoneTypeKey(param1:POIZone) : String
      {
         var _loc2_:String = param1.zoneType;
         if(Boolean(param1.zoneTypeSpecification.value) && Boolean(param1.zoneTypeSpecification.value.length > 1) && param1.zoneType == POIZone.ZONE_TYPE_BST)
         {
            _loc2_ += "_" + param1.zoneTypeSpecification;
         }
         return _loc2_;
      }
      
      public static function getZoneTypeColorAttributes(param1:String) : POIZoneStyle
      {
         return POIZoneStyle.zoneTypeColorDict[param1] as POIZoneStyle;
      }
      
      private static function createPOIColorReference() : void
      {
         var _loc1_:POIZoneStyle = null;
         _loc1_ = new POIZoneStyle();
         _loc1_.fillTypeMap = FILLTYPE_BITMAP;
         _loc1_.fillTypeMinimap = FILLTYPE_BITMAP;
         _loc1_.fillAlpha = 0.2;
         _loc1_.lineColor = COLOR_WHITE;
         _loc1_.lineAlpha = 0.4;
         _loc1_.fillColor = COLOR_RED;
         _loc1_.minimapFillAlpha = 1;
         zoneTypeColorDict[POIZone.ZONE_TYPE_NOA] = _loc1_;
         _loc1_ = new POIZoneStyle();
         _loc1_.fillColor = COLOR_GREEN;
         _loc1_.lineColor = COLOR_BLACK;
         _loc1_.minimapFillAlpha = 1;
         zoneTypeColorDict[POIZone.ZONE_TYPE_HEA] = _loc1_;
         _loc1_ = new POIZoneStyle();
         _loc1_.fillColor = COLOR_BLUE;
         _loc1_.lineColor = COLOR_BLACK;
         _loc1_.minimapFillAlpha = 1;
         zoneTypeColorDict[POIZone.ZONE_TYPE_TRG] = _loc1_;
         _loc1_ = new POIZoneStyle();
         _loc1_.fillTypeMap = FILLTYPE_BITMAP;
         _loc1_.fillColor = COLOR_BLUE;
         _loc1_.lineColor = COLOR_BLACK;
         _loc1_.minimapFillAlpha = 1;
         zoneTypeColorDict[POIZone.ZONE_TYPE_DMG] = _loc1_;
         _loc1_ = new POIZoneStyle();
         _loc1_.fillTypeMap = FILLTYPE_BITMAP;
         _loc1_.fillTypeMinimap = FILLTYPE_BITMAP;
         _loc1_.lineColor = COLOR_RED;
         _loc1_.lineAlpha = 0.4;
         _loc1_.fillColor = COLOR_RED;
         _loc1_.minimapFillAlpha = 0.4;
         zoneTypeColorDict[POIZone.ZONE_TYPE_RAD] = _loc1_;
         _loc1_ = new POIZoneStyle();
         _loc1_.minimapFillAlpha = 0.25;
         zoneTypeColorDict[POIZone.ZONE_TYPE_SECTOR_CONTROL_HOME_ZONE] = _loc1_;
         _loc1_ = new POIZoneStyle();
         _loc1_.lineAlpha = 1;
         _loc1_.lineThickness = 1;
         _loc1_.minimapFillAlpha = 0.25;
         zoneTypeColorDict[POIZone.ZONE_TYPE_SECTOR_CONTROL_SECTOR_ZONE] = _loc1_;
         _loc1_ = new POIZoneStyle();
         _loc1_.lineColor = COLOR_WHITE;
         _loc1_.fillColor = COLOR_GREEN;
         _loc1_.minimapFillAlpha = 0;
         _loc1_.lineAlpha = 0;
         zoneTypeColorDict[POIZone.ZONE_TYPE_ACTIVATION_ZONE] = _loc1_;
         _loc1_ = new POIZoneStyle();
         _loc1_.fillColor = COLOR_GREEN;
         _loc1_.minimapFillAlpha = 1;
         _loc1_.fillAlpha = 0;
         _loc1_.lineColor = COLOR_WHITE;
         _loc1_.lineAlpha = 0.5;
         _loc1_.lineThickness = 1;
         zoneTypeColorDict[POIZone.ZONE_TYPE_ACTIVATION_ZONE_OUTLINE] = _loc1_;
         _loc1_ = new POIZoneStyle();
         _loc1_.lineColor = COLOR_RED;
         _loc1_.lineAlpha = 0.4;
         _loc1_.fillColor = COLOR_RED;
         _loc1_.fillAlpha = 0.5;
         _loc1_.minimapFillAlpha = 0.4;
         zoneTypeColorDict[POIZone.ZONE_TYPE_PET_DISRUPTION] = _loc1_;
      }
   }
}

