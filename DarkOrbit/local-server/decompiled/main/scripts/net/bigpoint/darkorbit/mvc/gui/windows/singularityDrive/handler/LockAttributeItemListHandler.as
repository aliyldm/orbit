package net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.handler
{
   import net.bigpoint.darkorbit.com.module.porting.lockattributeitem.LockAttributeItemListCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.model.SingularityDriveProxy;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class LockAttributeItemListHandler extends BaseHandler
   {
      
      public function LockAttributeItemListHandler()
      {
         super();
      }
      
      public static function run(param1:LockAttributeItemListCommand) : void
      {
         SingularityDriveProxy.getProxy().setViewData(param1.moduleList,param1.remove);
      }
   }
}

