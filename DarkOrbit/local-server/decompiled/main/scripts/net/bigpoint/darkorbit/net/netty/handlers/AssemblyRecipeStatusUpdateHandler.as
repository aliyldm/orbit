package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeStatusUpdateCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class AssemblyRecipeStatusUpdateHandler extends DOAbstractSimpleCommand
   {
      
      public function AssemblyRecipeStatusUpdateHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:AssemblyProxy = retrieveProxy(AssemblyProxy.NAME) as AssemblyProxy;
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:AssemblyRecipeStatusUpdateCommand = param1.getBody() as AssemblyRecipeStatusUpdateCommand;
         _loc2_.updateSingleItem(_loc3_);
      }
   }
}

