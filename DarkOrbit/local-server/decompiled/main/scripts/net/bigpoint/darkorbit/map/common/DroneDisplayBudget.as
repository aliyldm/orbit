package net.bigpoint.darkorbit.map.common
{
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.pet.Pet;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class DroneDisplayBudget
   {
      
      private static var map:Map;
      
      public static const RADIUS:Number = 800;
      
      public static const LIMIT:int = 30;
      
      public static const POLL_MS:int = 250;
      
      public static const RECOVERY_MS:int = 5000;
      
      public static var nearby:int = 0;
      
      public static var revision:uint = 0;
      
      private static var entries:Vector.<DroneDisplayEntry> = new Vector.<DroneDisplayEntry>();
      
      private static var selected:Dictionary = new Dictionary();
      
      private static var pending:Vector.<DroneDisplayEntry> = new Vector.<DroneDisplayEntry>();
      
      private static var nextPoll:int = 0;
      
      private static var belowSince:int = -1;
      
      private static var listening:Boolean = false;
      
      private static var suppressed:Boolean = false;
      
      public function DroneDisplayBudget()
      {
         super();
      }
      
      public static function get trailsAllowed() : Boolean
      {
         return !suppressed;
      }
      
      public static function begin(param1:Map) : void
      {
         if(map === param1)
         {
            return;
         }
         reset();
         map = param1;
      }
      
      public static function end(param1:Map) : void
      {
         if(map === param1)
         {
            reset();
         }
      }
      
      public static function add(param1:Ship, param2:Function) : DroneDisplayEntry
      {
         if(!listening)
         {
            Settings.showDrones.changed.add(settingsChanged);
            Settings.showMyDrones.changed.add(settingsChanged);
            listening = true;
         }
         var _loc3_:DroneDisplayEntry = new DroneDisplayEntry(param1,param2);
         entries.push(_loc3_);
         nextPoll = 0;
         _loc3_.apply(param1.isHeroShip() ? Settings.showMyDrones.value : !_loc3_.player && Settings.showDrones.value,!suppressed);
         return _loc3_;
      }
      
      public static function remove(param1:DroneDisplayEntry) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc2_:int = entries.indexOf(param1);
         if(_loc2_ >= 0)
         {
            entries.splice(_loc2_,1);
         }
         _loc2_ = pending.indexOf(param1);
         if(_loc2_ >= 0)
         {
            pending.splice(_loc2_,1);
         }
         param1.dispose();
         if(!entries.length)
         {
            if(listening)
            {
               Settings.showDrones.changed.remove(settingsChanged);
               Settings.showMyDrones.changed.remove(settingsChanged);
               listening = false;
            }
            selected = new Dictionary();
            nearby = 0;
            nextPoll = 0;
         }
      }
      
      public static function update(param1:Map, param2:int = -1) : void
      {
         var _loc5_:Vector.<Ship> = null;
         var _loc6_:Vector.<Number> = null;
         var _loc7_:int = 0;
         var _loc8_:MapEntity = null;
         var _loc9_:DroneDisplayEntry = null;
         var _loc10_:Ship = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:int = 0;
         if(param1 !== map || !Settings.showDrones.value || !entries.length)
         {
            return;
         }
         var _loc3_:Ship = map.hero;
         if(!_loc3_)
         {
            return;
         }
         if(param2 < 0)
         {
            param2 = getTimer();
         }
         if(param2 >= nextPoll)
         {
            nextPoll = param2 + POLL_MS;
            _loc5_ = new Vector.<Ship>();
            _loc6_ = new Vector.<Number>();
            _loc7_ = 0;
            for each(_loc8_ in map.entities)
            {
               _loc10_ = _loc8_ as Ship;
               if(!(!_loc10_ || _loc10_ === _loc3_ || _loc10_.isNPC || _loc10_ is Pet))
               {
                  _loc11_ = _loc10_.position.x - _loc3_.position.x;
                  _loc12_ = _loc10_.position.y - _loc3_.position.y;
                  _loc13_ = _loc11_ * _loc11_ + _loc12_ * _loc12_;
                  if(_loc13_ <= RADIUS * RADIUS)
                  {
                     _loc7_++;
                     _loc14_ = 0;
                     while(_loc14_ < _loc6_.length && (_loc6_[_loc14_] < _loc13_ || _loc6_[_loc14_] == _loc13_ && _loc5_[_loc14_].id < _loc10_.id))
                     {
                        _loc14_++;
                     }
                     if(_loc14_ < LIMIT)
                     {
                        _loc5_.splice(_loc14_,0,_loc10_);
                        _loc6_.splice(_loc14_,0,_loc13_);
                        if(_loc5_.length > LIMIT)
                        {
                           _loc5_.pop();
                           _loc6_.pop();
                        }
                     }
                  }
               }
            }
            nearby = _loc7_;
            if(_loc7_ > LIMIT)
            {
               suppressed = true;
               belowSince = -1;
            }
            else if(suppressed)
            {
               if(belowSince < 0)
               {
                  belowSince = param2;
               }
               else if(param2 - belowSince >= RECOVERY_MS)
               {
                  suppressed = false;
                  belowSince = -1;
               }
            }
            selected = new Dictionary();
            pending.length = 0;
            for each(_loc10_ in _loc5_)
            {
               selected[_loc10_] = true;
            }
            ++revision;
            for each(_loc9_ in entries)
            {
               if(_loc9_.ship.isHeroShip())
               {
                  _loc9_.apply(Settings.showMyDrones.value,!suppressed);
               }
               else if(!_loc9_.player)
               {
                  _loc9_.apply(true,!suppressed);
               }
               else if(!selected[_loc9_.ship])
               {
                  _loc9_.apply(false,false);
               }
               else if(_loc9_.allowed)
               {
                  _loc9_.apply(true,!suppressed);
               }
               else
               {
                  pending.push(_loc9_);
               }
            }
         }
         var _loc4_:int = 0;
         while(_loc4_ < 2 && Boolean(pending.length))
         {
            _loc9_ = pending.shift();
            if(Boolean(_loc9_.player && !_loc9_.ship.isHeroShip()) && Boolean(selected[_loc9_.ship]) && !_loc9_.allowed)
            {
               _loc9_.apply(true,!suppressed);
               _loc4_++;
            }
         }
      }
      
      private static function reset() : void
      {
         var _loc1_:DroneDisplayEntry = null;
         for each(_loc1_ in entries)
         {
            _loc1_.apply(false,false);
         }
         entries.length = 0;
         pending.length = 0;
         selected = new Dictionary();
         map = null;
         nextPoll = 0;
         nearby = 0;
         belowSince = -1;
         suppressed = false;
         ++revision;
         if(listening)
         {
            Settings.showDrones.changed.remove(settingsChanged);
            Settings.showMyDrones.changed.remove(settingsChanged);
            listening = false;
         }
      }
      
      private static function settingsChanged() : void
      {
         var _loc1_:DroneDisplayEntry = null;
         nextPoll = 0;
         if(!Settings.showDrones.value)
         {
            pending.length = 0;
            selected = new Dictionary();
            nearby = 0;
            suppressed = false;
            belowSince = -1;
            ++revision;
         }
         for each(_loc1_ in entries)
         {
            if(_loc1_.ship.isHeroShip())
            {
               _loc1_.apply(Settings.showMyDrones.value,!suppressed);
            }
            else if(!Settings.showDrones.value)
            {
               _loc1_.apply(false,false);
            }
         }
      }
   }
}

