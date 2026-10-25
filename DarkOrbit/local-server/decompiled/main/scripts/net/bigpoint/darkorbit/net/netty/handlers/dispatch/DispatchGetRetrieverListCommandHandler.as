package net.bigpoint.darkorbit.net.netty.handlers.dispatch
{
   import net.bigpoint.darkorbit.com.module.DispatchGetRetrieverListCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.dispatch.retriever.model.DispatchRetrieverProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class DispatchGetRetrieverListCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function DispatchGetRetrieverListCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:DispatchRetrieverProxy = retrieveProxy(GuiConstants.DISPATCH_RETRIEVER) as DispatchRetrieverProxy;
         if(!_loc2_)
         {
            _loc4_ = SimpleWindowCreationMap.getById(GuiConstants.DISPATCH);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc2_ = retrieveProxy(GuiConstants.DISPATCH_RETRIEVER) as DispatchRetrieverProxy;
         }
         var _loc3_:DispatchGetRetrieverListCommand = param1.getBody() as DispatchGetRetrieverListCommand;
         _loc2_.updateRetrieverList(_loc3_);
      }
   }
}

