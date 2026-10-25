package net.bigpoint.darkorbit.net.netty.handlers.refinement
{
   import net.bigpoint.darkorbit.com.module.LabUpdateItemCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class LabUpdateItemHandler extends BaseHandler
   {
      
      public function LabUpdateItemHandler()
      {
         super();
      }
      
      public static function run(param1:LabUpdateItemCommand) : void
      {
         _main.getConnectionManager().getRefinementAssembly().assembleRefinementUpdate(param1.itemsUpdatedInfo);
      }
   }
}

