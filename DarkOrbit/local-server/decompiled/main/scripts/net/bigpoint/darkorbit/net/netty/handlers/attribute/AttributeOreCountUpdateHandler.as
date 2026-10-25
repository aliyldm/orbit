package net.bigpoint.darkorbit.net.netty.handlers.attribute
{
   import net.bigpoint.darkorbit.com.module.AttributeOreCountUpdateCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class AttributeOreCountUpdateHandler extends BaseHandler
   {
      
      public function AttributeOreCountUpdateHandler()
      {
         super();
      }
      
      public static function run(param1:AttributeOreCountUpdateCommand) : void
      {
         _main.getConnectionManager().getShipAssembly().assembleOreUpdate(param1.oreCountList);
      }
   }
}

