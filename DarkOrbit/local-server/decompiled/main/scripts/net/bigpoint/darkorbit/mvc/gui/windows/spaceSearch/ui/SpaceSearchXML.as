package net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.ui
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.ui.model.BoundPackage;
   
   public class SpaceSearchXML
   {
      
      public static var xmls:Dictionary = new Dictionary();
      
      public function SpaceSearchXML()
      {
         super();
      }
      
      public static function createPlanetIdToResKeyMap(param1:XML) : Dictionary
      {
         var _loc3_:XMLList = null;
         var _loc4_:XML = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc2_:Dictionary = new Dictionary();
         if(Boolean(param1) && Boolean(param1.category) && Boolean(param1.category.planets) && Boolean(param1.category.planets.planet))
         {
            _loc3_ = param1.category.planets.planet;
            for each(_loc4_ in _loc3_)
            {
               _loc5_ = int(_loc4_.@planetId);
               _loc6_ = String(_loc4_.@resKey);
               _loc2_[_loc5_] = _loc6_;
            }
         }
         return _loc2_;
      }
      
      public static function createEventIdToResKeyMap(param1:XML) : Dictionary
      {
         var _loc3_:XMLList = null;
         var _loc4_:XML = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc2_:Dictionary = new Dictionary();
         if(Boolean(param1) && Boolean(param1.category) && Boolean(param1.category.planetEvents) && Boolean(param1.category.planetEvents.planetEvent))
         {
            _loc3_ = param1.category.planetEvents.planetEvent;
            for each(_loc4_ in _loc3_)
            {
               _loc5_ = int(_loc4_.@eventId);
               _loc6_ = String(_loc4_.@resKey);
               _loc2_[_loc5_] = _loc6_;
            }
         }
         return _loc2_;
      }
      
      public static function createRangeRewardToResKeyMap(param1:XML) : Dictionary
      {
         var _loc3_:XML = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:BoundPackage = null;
         var _loc2_:Dictionary = new Dictionary();
         if(Boolean(param1) && Boolean(param1.category) && Boolean(param1.category.rangeBoundPackageEntry))
         {
            for each(_loc3_ in param1.category.rangeBoundPackageEntry)
            {
               _loc4_ = String(_loc3_["package"].item.@lootId);
               _loc5_ = int(_loc3_["package"].item.@amount);
               _loc6_ = String(_loc3_["package"].title.@name);
               _loc7_ = int(_loc3_["package"].range.@from);
               _loc8_ = int(_loc3_["package"].range.@to);
               _loc9_ = int(_loc3_.@special);
               _loc10_ = new BoundPackage(_loc4_,_loc6_,_loc7_,_loc8_,_loc9_,_loc5_);
               _loc2_[_loc7_] = _loc10_;
            }
         }
         return _loc2_;
      }
      
      public static function createEventIdToDegreeMap(param1:XML) : Dictionary
      {
         var _loc3_:XMLList = null;
         var _loc4_:XML = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc2_:Dictionary = new Dictionary();
         if(Boolean(param1) && Boolean(param1.category) && Boolean(param1.category.planetEvents) && Boolean(param1.category.planetEvents.planetEvent))
         {
            _loc3_ = param1.category.planetEvents.planetEvent;
            for each(_loc4_ in _loc3_)
            {
               _loc5_ = int(_loc4_.@eventId);
               _loc6_ = String(_loc4_.@degree);
               _loc2_[_loc5_] = _loc6_;
            }
         }
         return _loc2_;
      }
   }
}

