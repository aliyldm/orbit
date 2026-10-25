package net.bigpoint.darkorbit.mvc.gui.windows.eventProgress.service
{
   import net.bigpoint.darkorbit.com.module.EventProgressInfoCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.eventProgress.view.EventProgressWindowMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class EventProgressInfoCommandHandler extends AbstractEventProgressCommandHandler
   {
      
      public function EventProgressInfoCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc3_:EventProgressInfoCommand = null;
         super.execute(param1);
         var _loc2_:EventProgressWindowMediator = this.retrieveMediator(GuiConstants.EVENT_PROGRESS_WINDOW) as EventProgressWindowMediator;
         if(_loc2_ == null)
         {
            sendWindowCreateNotififcation();
         }
         _loc2_ = this.retrieveMediator(GuiConstants.EVENT_PROGRESS_WINDOW) as EventProgressWindowMediator;
         if(_loc2_)
         {
            _loc3_ = param1.getBody() as EventProgressInfoCommand;
            _loc2_.remainingTime = _loc3_.remainingTimeInMS;
         }
      }
   }
}

