package net.bigpoint.darkorbit.settings
{
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   
   public class CrowdedNameplateCuller
   {
      
      public static const MAX_VISIBLE:int = 60;
      
      private static const KEEP_RANK:int = 80;
      
      private static const REBUILD_INTERVAL_MS:int = 250;
      
      private static var _visibleIds:Object = {};
      
      private static var _nextRebuildAt:int = 0;
      
      public function CrowdedNameplateCuller()
      {
         super();
      }
      
      public static function shouldShowNameplate(param1:Ship) : Boolean
      {
         if(param1 == null)
         {
            return true;
         }
         if(!CrowdedCombatPreset.enabled)
         {
            return true;
         }
         if(param1.isNPC || param1.isHeroShip())
         {
            return true;
         }
         ensureRebuilt();
         return _visibleIds[param1.id] == true;
      }
      
      private static function ensureRebuilt() : void
      {
         var _loc1_:int = ScreenManager.getInstance().frameTime;
         if(_loc1_ < _nextRebuildAt)
         {
            return;
         }
         _nextRebuildAt = _loc1_ + REBUILD_INTERVAL_MS;
         rebuild();
      }
      
      private static function rebuild() : void
      {
         var _loc9_:Ship = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Object = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:Boolean = false;
         var _loc1_:Map = ScreenManager.getInstance().map;
         if(_loc1_ == null || _loc1_.hero == null)
         {
            _visibleIds = {};
            return;
         }
         var _loc2_:Number = _loc1_.hero.position.x;
         var _loc3_:Number = _loc1_.hero.position.y;
         var _loc4_:Array = [];
         var _loc5_:Vector.<MapEntity> = _loc1_.entities;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc9_ = _loc5_[_loc6_] as Ship;
            if(!(_loc9_ == null || _loc9_.isNPC || _loc9_.isHeroShip()))
            {
               _loc10_ = _loc9_.position.x - _loc2_;
               _loc11_ = _loc9_.position.y - _loc3_;
               _loc4_.push({
                  "id":_loc9_.id,
                  "d":_loc10_ * _loc10_ + _loc11_ * _loc11_
               });
            }
            _loc6_++;
         }
         if(_loc4_.length <= MAX_VISIBLE)
         {
            _loc12_ = {};
            _loc13_ = 0;
            while(_loc13_ < _loc4_.length)
            {
               _loc12_[_loc4_[_loc13_].id] = true;
               _loc13_++;
            }
            _visibleIds = _loc12_;
            return;
         }
         _loc4_.sortOn("d",Array.NUMERIC);
         var _loc7_:Object = {};
         var _loc8_:int = 0;
         while(_loc8_ < _loc4_.length)
         {
            _loc14_ = int(_loc4_[_loc8_].id);
            _loc15_ = _loc8_ < MAX_VISIBLE || _loc8_ < KEEP_RANK && _visibleIds[_loc14_] == true;
            if(_loc15_)
            {
               _loc7_[_loc14_] = true;
            }
            _loc8_++;
         }
         _visibleIds = _loc7_;
      }
   }
}

