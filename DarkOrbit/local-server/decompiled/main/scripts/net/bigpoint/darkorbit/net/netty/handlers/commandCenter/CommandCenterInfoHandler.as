package net.bigpoint.darkorbit.net.netty.handlers.commandCenter
{
   import net.bigpoint.darkorbit.com.module.CommandCenterInfoCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.commandCenter.model.CommandCenterProxy;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CommandCenterInfoHandler extends DOAbstractSimpleCommand
   {
      
      public function CommandCenterInfoHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:CommandCenterInfoCommand = param1.getBody() as CommandCenterInfoCommand;
         var _loc3_:CommandCenterProxy = retrieveProxy(GuiConstants.COMMAND_CENTER) as CommandCenterProxy;
         _loc3_.updateViewCounts(_loc2_);
      }
   }
}

