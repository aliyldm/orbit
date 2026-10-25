package net.bigpoint.darkorbit.map.common
{
   import flash.utils.getTimer;
   
   public final class EffectRangeTicker
   {
      
      private static var fast:Array = [];
      
      private static var slow:Array = [];
      
      private static var fastDue:int = 0;
      
      private static var slowDue:int = 0;
      
      private static var epoch:uint = 0;
      
      public function EffectRangeTicker()
      {
         super();
      }
      
      public static function add(param1:Function, param2:int = 250) : Object
      {
         var _loc3_:Object = {
            "callback":param1,
            "active":true
         };
         (param2 == 100 ? fast : slow).push(_loc3_);
         return _loc3_;
      }
      
      public static function remove(param1:Object) : void
      {
         if(param1)
         {
            param1.active = false;
            param1.callback = null;
         }
      }
      
      public static function tick(param1:int = -1) : void
      {
         if(!fast.length && !slow.length)
         {
            return;
         }
         if(param1 < 0)
         {
            param1 = getTimer();
         }
         if(param1 >= fastDue)
         {
            fastDue = param1 + 100;
            run(fast);
         }
         if(param1 >= slowDue)
         {
            slowDue = param1 + 250;
            run(slow);
         }
      }
      
      private static function run(param1:Array) : void
      {
         var i:int = 0;
         var token:Object = null;
         var write:int = 0;
         var list:Array = param1;
         var generation:uint = epoch;
         var limit:int = int(list.length);
         try
         {
            i = 0;
            while(i < limit && generation == epoch)
            {
               token = list[i];
               if(Boolean(token) && Boolean(token.active))
               {
                  token.callback();
               }
               i++;
            }
         }
         finally
         {
            if(generation == epoch)
            {
               write = 0;
               i = 0;
               while(i < list.length)
               {
                  if(list[i].active)
                  {
                     var _loc5_:Number;
                     list[_loc5_ = write++] = list[i];
                  }
                  i++;
               }
               list.length = write;
            }
         }
      }
      
      public static function clear() : void
      {
         var _loc1_:Object = null;
         ++epoch;
         for each(_loc1_ in fast)
         {
            remove(_loc1_);
         }
         for each(_loc1_ in slow)
         {
            remove(_loc1_);
         }
         fast = [];
         slow = [];
         fastDue = slowDue = 0;
      }
   }
}

