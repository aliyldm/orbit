package net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.handler
{
   import net.bigpoint.darkorbit.com.module.porting.trinitytrials.TrinityTrialsDropLevelCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.model.TrinityTrialsMainProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class TrinityTrialsDropLevelCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function TrinityTrialsDropLevelCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:TrinityTrialsDropLevelCommand = param1.getBody() as TrinityTrialsDropLevelCommand;
         var _loc3_:TrinityTrialsMainProxy = TrinityTrialsMainProxy.getProxy();
         _loc3_.rcvUpLevelData(_loc2_);
      }
   }
}

