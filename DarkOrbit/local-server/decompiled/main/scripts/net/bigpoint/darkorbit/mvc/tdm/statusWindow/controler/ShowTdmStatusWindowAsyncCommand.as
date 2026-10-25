package net.bigpoint.darkorbit.mvc.tdm.statusWindow.controler
{
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.common.model.GuiProxy;
   import net.bigpoint.darkorbit.mvc.tdm.statusWindow.model.TDMStatusModel;
   import net.bigpoint.darkorbit.mvc.tdm.statusWindow.model.TDMStatusProxy;
   import net.bigpoint.darkorbit.mvc.tdm.statusWindow.view.decorator.TDMStatusUiDecorator;
   import net.bigpoint.darkorbit.mvc.tdm.statusWindow.view.mediator.TDMStatusUiMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
   
   public class ShowTdmStatusWindowAsyncCommand extends AsyncCommand
   {
      
      public function ShowTdmStatusWindowAsyncCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:GuiProxy = null;
         var _loc5_:SimpleWindow = null;
         var _loc6_:TDMStatusModel = null;
         super.execute(param1);
         var _loc2_:TDMStatusUiMediator = facade.retrieveMediator(TDMStatusUiMediator.NAME) as TDMStatusUiMediator;
         if(!_loc2_)
         {
            _loc4_ = facade.retrieveProxy(GuiProxy.NAME) as GuiProxy;
            _loc5_ = _loc4_.getWindowById(GuiConstants.TDM_STATUS_UI_WINDOW);
            if(!_loc5_)
            {
               sendNotification(GuiNotifications.CREATE_WINDOW,GuiConstants.TDM_STATUS_UI_WINDOW);
               _loc5_ = _loc4_.getWindowById(GuiConstants.TDM_STATUS_UI_WINDOW);
            }
            _loc5_.maximize();
            _loc2_ = new TDMStatusUiMediator(new TDMStatusUiDecorator(_loc5_));
            facade.registerMediator(_loc2_);
         }
         var _loc3_:TDMStatusProxy = facade.retrieveProxy(TDMStatusProxy.NAME) as TDMStatusProxy;
         if(!_loc3_)
         {
            _loc6_ = new TDMStatusModel();
            facade.registerProxy(new TDMStatusProxy(_loc6_));
         }
         commandComplete();
      }
   }
}

