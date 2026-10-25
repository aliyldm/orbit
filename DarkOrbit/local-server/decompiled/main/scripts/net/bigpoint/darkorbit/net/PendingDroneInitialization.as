package net.bigpoint.darkorbit.net
{
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.drones.Drone;
   
   public class PendingDroneInitialization
   {
      
      private static const MAX_PENDING:int = 1024;
      
      private static const MAX_AGE_MS:uint = 30000;
      
      private static var maps:Dictionary = new Dictionary(true);
      
      private static var serial:Number = 0;
      
      public function PendingDroneInitialization()
      {
         super();
      }
      
      public static function save(param1:Object, param2:int, param3:Vector.<Drone>, param4:int) : void
      {
         var _loc6_:String = null;
         var _loc7_:String = null;
         if(!param1)
         {
            return;
         }
         var _loc5_:Object = maps[param1];
         if(!_loc5_)
         {
            _loc5_ = {
               "entries":{},
               "count":0
            };
            maps[param1] = _loc5_;
         }
         if(!_loc5_.entries[param2])
         {
            if(_loc5_.count >= MAX_PENDING)
            {
               _loc6_ = null;
               for(_loc7_ in _loc5_.entries)
               {
                  if(_loc6_ == null || _loc5_.entries[_loc7_].serial < _loc5_.entries[_loc6_].serial)
                  {
                     _loc6_ = _loc7_;
                  }
               }
               delete _loc5_.entries[_loc6_];
               --_loc5_.count;
            }
            ++_loc5_.count;
         }
         _loc5_.entries[param2] = {
            "drones":param3,
            "formation":param4,
            "ms":getTimer(),
            "serial":++serial
         };
      }
      
      public static function take(param1:Object, param2:int) : Object
      {
         var _loc3_:Object = remove(param1,param2);
         if(Boolean(_loc3_) && uint(getTimer() - _loc3_.ms) > MAX_AGE_MS)
         {
            return null;
         }
         return _loc3_;
      }
      
      public static function discard(param1:Object, param2:int) : void
      {
         remove(param1,param2);
      }
      
      private static function remove(param1:Object, param2:int) : Object
      {
         if(!param1)
         {
            return null;
         }
         var _loc3_:Object = maps[param1];
         if(!_loc3_)
         {
            return null;
         }
         var _loc4_:Object = _loc3_.entries[param2];
         if(!_loc4_)
         {
            return null;
         }
         delete _loc3_.entries[param2];
         --_loc3_.count;
         if(!_loc3_.count)
         {
            delete maps[param1];
         }
         return _loc4_;
      }
      
      public static function applyTo(param1:Ship, param2:Object) : void
      {
         if(!param2)
         {
            return;
         }
         if(param2.formation >= 0)
         {
            param1.drones.droneFormationId.value = param2.formation;
         }
         param1.drones.drones = param2.drones as Vector.<Drone>;
      }
   }
}

