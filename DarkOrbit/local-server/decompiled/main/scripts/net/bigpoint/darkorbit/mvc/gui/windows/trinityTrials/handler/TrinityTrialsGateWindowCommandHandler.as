package net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.handler
{
   import net.bigpoint.darkorbit.com.module.porting.trinitytrials.TrinityTrialsGateWindowCommand;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.model.TrinityTrialsConst;
   import net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.model.TrinityTrialsMainProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class TrinityTrialsGateWindowCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function TrinityTrialsGateWindowCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         GuiManager.instance.tryCreateAndOpen(TrinityTrialsConst.DIFFICULTY_SELECT);
         var _loc2_:TrinityTrialsGateWindowCommand = param1.getBody() as TrinityTrialsGateWindowCommand;
         var _loc3_:TrinityTrialsMainProxy = TrinityTrialsMainProxy.getProxy();
         _loc3_.viewData.updateGateData(_loc2_);
      }
   }
}

