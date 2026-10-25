package net.bigpoint.darkorbit.mvc.gui.windows.spacemap.model
{
   import flash.geom.Point;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.utils.XMLUtils;
   
   public class SpaceMapConfig
   {
      
      private static var _spaceMapConfig:XML;
      
      public static const NORMAL_MAP:String = "normal";
      
      public static const PIRATE_MAP:String = "pirate";
      
      public function SpaceMapConfig()
      {
         super();
      }
      
      public static function get spaceMapConfig() : XML
      {
         return _spaceMapConfig;
      }
      
      public static function set spaceMapConfig(param1:XML) : void
      {
         _spaceMapConfig = param1;
      }
      
      public static function getEnemyMaps(param1:int) : Array
      {
         var _loc3_:XML = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(_spaceMapConfig == null)
         {
            return null;
         }
         var _loc2_:XMLList = XMLUtils.getChildByAttributeName(_spaceMapConfig.maps.map,"type",NORMAL_MAP);
         var _loc6_:Array = [];
         var _loc7_:int = _loc2_.length();
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            _loc3_ = _loc2_[_loc8_];
            if(_loc3_.attribute("home") > 0)
            {
               _loc4_ = parseInt(_loc3_.attribute("home")[0]);
               if(_loc4_ != param1)
               {
                  _loc5_ = parseInt(_loc3_.attribute("id")[0]);
                  _loc6_.push(_loc5_);
               }
            }
            _loc8_++;
         }
         return _loc6_;
      }
      
      public static function getMapType(param1:int) : String
      {
         var _loc2_:XMLList = Map.getStaticMapDescriptor(param1).child("spacemapInfo");
         var _loc3_:XMLList = _loc2_.attribute("type");
         return _loc3_.length() >= 1 ? String(_loc3_) : null;
      }
      
      public static function getMapIds(param1:String) : Array
      {
         var _loc4_:uint = 0;
         if(_spaceMapConfig == null)
         {
            return null;
         }
         var _loc2_:Array = [];
         var _loc3_:XMLList = XMLUtils.getChildByAttributeName(_spaceMapConfig.maps.map,"type",param1);
         var _loc5_:uint = uint(_loc3_.length());
         var _loc6_:uint = 0;
         while(_loc6_ < _loc5_)
         {
            _loc4_ = parseInt(_loc3_[_loc6_].attribute("id")[0]);
            _loc2_.push(_loc4_);
            _loc6_++;
         }
         return _loc2_;
      }
      
      public static function getGatesOnMap(param1:int) : Array
      {
         var _loc4_:int = 0;
         var _loc5_:XML = null;
         if(_spaceMapConfig == null)
         {
            return null;
         }
         var _loc2_:Array = [];
         var _loc3_:XMLList = XMLUtils.getChildByAttributeName(_spaceMapConfig.jumpgates.jumpgate,"ref",param1.toString());
         if(_loc3_.length() > 0)
         {
            for each(_loc5_ in _loc3_)
            {
               _loc4_ = parseInt(_loc5_.attribute("key"));
               _loc2_.push(_loc4_);
            }
         }
         return _loc2_;
      }
      
      public static function getGatePosition(param1:int) : Point
      {
         if(_spaceMapConfig == null)
         {
            return null;
         }
         var _loc2_:Point = null;
         var _loc3_:XMLList = XMLUtils.getChildByAttributeName(_spaceMapConfig.jumpgates.jumpgate,"key",param1.toString());
         if(_loc3_.length() == 0)
         {
            return null;
         }
         if(_loc3_.length() > 1)
         {
            throw new Error("Duplicate GATE with the same key: (" + param1.toString() + ") defined in spacemap-config.xml.");
         }
         var _loc4_:int = parseInt(_loc3_[0].position.attribute("x"));
         var _loc5_:int = parseInt(_loc3_[0].position.attribute("y"));
         return new Point(_loc4_,_loc5_);
      }
      
      public static function getGateFactionId(param1:int) : int
      {
         if(_spaceMapConfig == null)
         {
            return 0;
         }
         var _loc2_:XMLList = XMLUtils.getChildByAttributeName(_spaceMapConfig.jumpgates.jumpgate,"key",param1.toString());
         if(_loc2_.length() == 0)
         {
            return 0;
         }
         if(_loc2_.length() > 1)
         {
            throw new Error("Duplicate GATE with the same key: (" + param1.toString() + ") defined in spacemap-config.xml.");
         }
         return InGameCatalog.getFactionIdByName(_loc2_.faction);
      }
      
      public static function getGateFactionName(param1:int) : String
      {
         if(_spaceMapConfig == null)
         {
            return null;
         }
         var _loc2_:XMLList = XMLUtils.getChildByAttributeName(_spaceMapConfig.jumpgates.jumpgate,"key",param1.toString());
         if(_loc2_.length() == 0)
         {
            return null;
         }
         if(_loc2_.length() > 1)
         {
            throw new Error("Duplicate GATE with the same key: (" + param1.toString() + ") defined in spacemap-config.xml.");
         }
         return _loc2_.faction;
      }
      
      public static function gateVisibleToFaction(param1:int) : Boolean
      {
         if(_spaceMapConfig == null)
         {
            return false;
         }
         var _loc2_:XMLList = XMLUtils.getChildByAttributeName(_spaceMapConfig.jumpgates.jumpgate,"key",param1.toString());
         if(_loc2_.length() == 0)
         {
            return false;
         }
         if(_loc2_.length() > 1)
         {
            throw new Error("Duplicate GATE with the same key: (" + param1.toString() + ") defined in spacemap-config.xml.");
         }
         var _loc3_:String = _loc2_.visibleOwnFaction[0];
         return _loc3_ == "true" ? true : false;
      }
      
      public static function gateLeadsToMapId(param1:int) : int
      {
         if(_spaceMapConfig == null)
         {
            return 0;
         }
         var _loc2_:XMLList = XMLUtils.getChildByAttributeName(_spaceMapConfig.jumpgates.jumpgate,"key",param1.toString());
         if(_loc2_.length() == 0)
         {
            return 0;
         }
         if(_loc2_.length() > 1)
         {
            throw new Error("Duplicate GATE with the same key: (" + param1.toString() + ") defined in spacemap-config.xml.");
         }
         return int(parseInt(_loc2_.leadsToMap[0]));
      }
      
      public static function gateLabelPosition(param1:int) : String
      {
         if(_spaceMapConfig == null)
         {
            return null;
         }
         var _loc2_:XMLList = XMLUtils.getChildByAttributeName(_spaceMapConfig.jumpgates.jumpgate,"key",param1.toString());
         if(_loc2_.length() == 0)
         {
            return null;
         }
         if(_loc2_.length() > 1)
         {
            throw new Error("Duplicate GATE with the same key: (" + param1.toString() + ") defined in spacemap-config.xml.");
         }
         return _loc2_.labelPosition[0];
      }
      
      public static function getMapNPCs(param1:int) : Array
      {
         var _loc4_:int = 0;
         var _loc5_:XML = null;
         if(_spaceMapConfig == null)
         {
            return null;
         }
         var _loc2_:XML = XMLUtils.getChildByAttributeName(_spaceMapConfig.npcs.map,"ref",param1.toString())[0];
         var _loc3_:Array = [];
         if(_loc2_ != null && _loc2_.length() > 0)
         {
            for each(_loc5_ in _loc2_..npc)
            {
               _loc4_ = parseInt(_loc5_.attribute("id"));
               _loc3_.push(_loc4_);
            }
         }
         return _loc3_;
      }
   }
}

