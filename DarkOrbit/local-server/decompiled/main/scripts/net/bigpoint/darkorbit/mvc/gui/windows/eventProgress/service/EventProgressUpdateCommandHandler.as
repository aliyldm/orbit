package net.bigpoint.darkorbit.mvc.gui.windows.eventProgress.service
{
   import net.bigpoint.darkorbit.com.module.EventProgressUpdateCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.eventProgress.model.EventProgressProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.eventProgress.view.EventProgressWindowMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class EventProgressUpdateCommandHandler extends AbstractEventProgressCommandHandler
   {
      
      public function EventProgressUpdateCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:EventProgressUpdateCommand = null;
         super.execute(param1);
         var _loc2_:EventProgressProxy = this.retrieveProxy(GuiConstants.EVENT_PROGRESS_WINDOW) as EventProgressProxy;
         if(_loc2_ == null)
         {
            sendWindowCreateNotififcation();
         }
         _loc2_ = this.retrieveProxy(GuiConstants.EVENT_PROGRESS_WINDOW) as EventProgressProxy;
         if(_loc2_)
         {
            _loc4_ = param1.getBody() as EventProgressUpdateCommand;
            _loc2_.load(_loc4_.id.replace(".xml",""));
            _loc2_.updateProgress(_loc4_.progress);
         }
         var _loc3_:EventProgressWindowMediator = this.retrieveMediator(GuiConstants.EVENT_PROGRESS_WINDOW) as EventProgressWindowMediator;
         if(_loc3_)
         {
            _loc3_.updateCollectedStatus(_loc4_.statusCode);
         }
      }
   }
}

