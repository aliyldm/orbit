package net.bigpoint.darkorbit.mvc.ccCommands.control
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.ccCommands.model.CCCommandsProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CCClearHistoryCommand extends DOAbstractSimpleCommand
   {
      
      public function CCClearHistoryCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:CCCommandsProxy = retrieveProxy(CCCommandsProxy.NAME) as CCCommandsProxy;
         _loc2_.clearHistory();
      }
   }
}

