package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.AttributeBoosterUpdateCommand;
   import net.bigpoint.darkorbit.mvc.booster.BoosterNotifications;
   import net.bigpoint.darkorbit.mvc.booster.model.BoosterProxy;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class AttributeBoosterUpdateHandler extends BaseHandler
   {
      
      public function AttributeBoosterUpdateHandler()
      {
         super();
      }
      
      public static function run(param1:AttributeBoosterUpdateCommand) : void
      {
         _facade.sendNotification(BoosterNotifications.CREATE);
         var _loc2_:BoosterProxy = _facade.retrieveProxy(BoosterProxy.NAME) as BoosterProxy;
         _loc2_.updateCategories(param1);
      }
   }
}

