package net.bigpoint.darkorbit.net.netty.handlers.attribute
{
   import net.bigpoint.darkorbit.com.module.AttributeShieldUpdateCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class AttributeShieldUpdateHandler extends BaseHandler
   {
      
      public function AttributeShieldUpdateHandler()
      {
         super();
      }
      
      public static function run(param1:AttributeShieldUpdateCommand) : void
      {
         _main.getConnectionManager().getAttributeAssembly().assembleShieldInfo(param1.shieldNow,param1.shieldMax);
      }
   }
}

