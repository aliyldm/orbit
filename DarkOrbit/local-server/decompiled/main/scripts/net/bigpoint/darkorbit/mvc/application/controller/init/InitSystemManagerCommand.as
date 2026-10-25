package net.bigpoint.darkorbit.mvc.application.controller.init
{
   import net.bigpoint.darkorbit.mvc.application.model.SystemManagerProxy;
   import net.bigpoint.darkorbit.mvc.application.model.vo.StartupVO;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
   
   public class InitSystemManagerCommand extends AsyncCommand
   {
      
      public function InitSystemManagerCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:StartupVO = param1.getBody() as StartupVO;
         this.initializeSystemManager(_loc2_);
         commandComplete();
      }
      
      private function initializeSystemManager(param1:StartupVO) : void
      {
         var _loc2_:SystemManagerProxy = facade.retrieveProxy(SystemManagerProxy.NAME) as SystemManagerProxy;
         _loc2_.initialize(param1);
      }
   }
}

