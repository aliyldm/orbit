package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.DesignSetUpdateCommand;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class DesignSetUpdateHander extends BaseHandler
   {
      
      public function DesignSetUpdateHander()
      {
         super();
      }
      
      public static function run(param1:DesignSetUpdateCommand) : void
      {
         var _loc2_:Ship = ScreenManager.getInstance().map.getEntityById(param1.userId) as Ship;
         if(_loc2_)
         {
            _loc2_.hasDesignSet.value = param1.active;
            if(_loc2_.pet)
            {
               _loc2_.pet.hasDesignSet.value = param1.active;
            }
         }
      }
   }
}

