package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.SpacePlagueBossSummoningProgressCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.plagueWindow.model.PlagueWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class SpacePlagueBossSummoningProgressHandler extends DOAbstractSimpleCommand
   {
      
      public function SpacePlagueBossSummoningProgressHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:SpacePlagueBossSummoningProgressCommand = param1.getBody() as SpacePlagueBossSummoningProgressCommand;
         var _loc3_:PlagueWindowProxy = facade.retrieveProxy(PlagueWindowProxy.NAME) as PlagueWindowProxy;
         _loc3_.setBossSummoningInfos(new <SpacePlagueBossSummoningProgressCommand>[_loc2_]);
      }
   }
}

