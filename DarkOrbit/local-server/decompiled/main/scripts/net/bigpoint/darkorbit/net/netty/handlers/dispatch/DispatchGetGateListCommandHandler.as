package net.bigpoint.darkorbit.net.netty.handlers.dispatch
{
   import net.bigpoint.darkorbit.com.module.DispatchGetGateListCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.dispatch.gate.model.DispatchGateProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class DispatchGetGateListCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function DispatchGetGateListCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:DispatchGateProxy = retrieveProxy(GuiConstants.DISPATCH_GATE) as DispatchGateProxy;
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:DispatchGetGateListCommand = param1.getBody() as DispatchGetGateListCommand;
         _loc2_.updateGateList(_loc3_);
      }
   }
}

