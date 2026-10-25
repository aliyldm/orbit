package net.bigpoint.darkorbit.mvc.application.controller.init
{
   import net.bigpoint.darkorbit.mvc.application.model.vo.StartupVO;
   import net.bigpoint.darkorbit.mvc.common.model.ConnectionProxy;
   import net.bigpoint.darkorbit.net.ConnectionManager;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
   
   public class InitConnectionCommand extends AsyncCommand
   {
      
      public function InitConnectionCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:StartupVO = param1.getBody() as StartupVO;
         var _loc3_:ConnectionManager = new ConnectionManager(_loc2_.main);
         var _loc4_:ConnectionProxy = facade.retrieveProxy(ConnectionProxy.NAME) as ConnectionProxy;
         _loc4_.setData(_loc3_);
         commandComplete();
      }
   }
}

