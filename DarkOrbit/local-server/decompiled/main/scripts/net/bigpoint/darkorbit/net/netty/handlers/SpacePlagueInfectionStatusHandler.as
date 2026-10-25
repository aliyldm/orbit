package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.SpacePlagueInfectionStatusCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.plagueWindow.model.PlagueWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class SpacePlagueInfectionStatusHandler extends DOAbstractSimpleCommand
   {
      
      public function SpacePlagueInfectionStatusHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:SpacePlagueInfectionStatusCommand = param1.getBody() as SpacePlagueInfectionStatusCommand;
         var _loc3_:PlagueWindowProxy = facade.retrieveProxy(PlagueWindowProxy.NAME) as PlagueWindowProxy;
         _loc3_.setInfection(_loc2_);
      }
   }
}

