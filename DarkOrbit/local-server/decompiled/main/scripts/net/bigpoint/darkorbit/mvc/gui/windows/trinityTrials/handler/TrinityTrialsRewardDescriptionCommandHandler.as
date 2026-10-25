package net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.handler
{
   import net.bigpoint.darkorbit.com.module.porting.trinitytrials.TrinityTrialsRewardDescriptionCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.model.TrinityTrialsMainProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class TrinityTrialsRewardDescriptionCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function TrinityTrialsRewardDescriptionCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:TrinityTrialsRewardDescriptionCommand = param1.getBody() as TrinityTrialsRewardDescriptionCommand;
         var _loc3_:TrinityTrialsMainProxy = TrinityTrialsMainProxy.getProxy();
         _loc3_.rcvDropInfoData(_loc2_);
      }
   }
}

