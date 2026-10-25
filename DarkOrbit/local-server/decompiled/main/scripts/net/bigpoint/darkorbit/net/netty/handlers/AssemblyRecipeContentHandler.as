package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeContentModule;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.AssemblyNotifications;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyProxy;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class AssemblyRecipeContentHandler extends DOAbstractSimpleCommand
   {
      
      public function AssemblyRecipeContentHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:AssemblyRecipeContentModule = param1.getBody() as AssemblyRecipeContentModule;
         sendNotification(AssemblyNotifications.INIT);
         var _loc3_:AssemblyProxy = retrieveProxy(AssemblyProxy.NAME) as AssemblyProxy;
         _loc3_.updateFromServer(_loc2_);
         sendNotification(GuiNotifications.WARP_CONTROLS_UPDATE);
      }
   }
}

