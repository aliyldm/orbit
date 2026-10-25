package net.bigpoint.darkorbit.mvc.tdm.statusWindow.controler
{
   import net.bigpoint.darkorbit.com.module.TeamDeathMatchStatusUpdateCommand;
   import net.bigpoint.darkorbit.mvc.tdm.statusWindow.model.TDMStatusProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class UpdateTdmStatusWindowCommand extends SimpleCommand
   {
      
      public function UpdateTdmStatusWindowCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:TDMStatusProxy = facade.retrieveProxy(TDMStatusProxy.NAME) as TDMStatusProxy;
         var _loc3_:TeamDeathMatchStatusUpdateCommand = param1.getBody() as TeamDeathMatchStatusUpdateCommand;
         _loc2_.update(_loc3_);
      }
   }
}

