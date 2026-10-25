package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeRemoveCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.AssemblyNotifications;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class AssemblyRecipeRemoveHandler extends DOAbstractSimpleCommand
   {
      
      public function AssemblyRecipeRemoveHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:AssemblyRecipeRemoveCommand = param1.getBody() as AssemblyRecipeRemoveCommand;
         sendNotification(AssemblyNotifications.INIT);
         var _loc3_:AssemblyProxy = retrieveProxy(AssemblyProxy.NAME) as AssemblyProxy;
         _loc3_.removeFromServer(_loc2_);
      }
   }
}

