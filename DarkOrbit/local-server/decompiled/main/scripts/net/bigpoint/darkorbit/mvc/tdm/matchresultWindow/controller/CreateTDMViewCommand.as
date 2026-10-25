package net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.controller
{
   import net.bigpoint.darkorbit.gui.windows.FlexWindowManager;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.mediator.TDMResultWindowMediator;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.TDMMatchResultWindow;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
   
   public class CreateTDMViewCommand extends AsyncCommand
   {
      
      public function CreateTDMViewCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:FlexWindowManager = null;
         var _loc3_:TDMMatchResultWindow = null;
         var _loc4_:TDMResultWindowMediator = null;
         super.execute(param1);
         if(!facade.hasMediator(TDMResultWindowMediator.NAME))
         {
            _loc2_ = FlexWindowManager.getInstance();
            _loc3_ = _loc2_.createWindow(FlexWindowManager.TEAMDEATHMATCH_RESULT_WINDOW) as TDMMatchResultWindow;
            _loc4_ = new TDMResultWindowMediator(_loc3_);
            facade.registerMediator(_loc4_);
         }
         commandComplete();
      }
   }
}

