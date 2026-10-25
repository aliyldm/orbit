package net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.handler
{
   import net.bigpoint.darkorbit.com.module.porting.trinitytrials.TrinityTrialsPassCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.model.TrinityTrialsMainProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class TrinityTrialsPassCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function TrinityTrialsPassCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:TrinityTrialsPassCommand = param1.getBody() as TrinityTrialsPassCommand;
         var _loc3_:TrinityTrialsMainProxy = TrinityTrialsMainProxy.getProxy();
         _loc3_.rcvRewardPass(_loc2_);
      }
   }
}

