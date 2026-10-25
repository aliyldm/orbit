package net.bigpoint.darkorbit.mvc.hintSystem.controller.model
{
   import net.bigpoint.darkorbit.com.module.HintWindowAddComand;
   import net.bigpoint.darkorbit.mvc.hintSystem.HintSystemNotifications;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.HintSystemContentProvider;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.HintSystemWindowsProxy;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.IHintSystemContentDescription;
   import net.bigpoint.darkorbit.utils.TimeMeasuring;
   import net.bigpoint.eventstream.EventStreamClient;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
   
   public class HintSystemAddHintCommand extends AsyncCommand
   {
      
      public function HintSystemAddHintCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc6_:String = null;
         super.execute(param1);
         var _loc2_:HintWindowAddComand = param1.getBody() as HintWindowAddComand;
         var _loc3_:HintSystemWindowsProxy = facade.retrieveProxy(HintSystemWindowsProxy.NAME) as HintSystemWindowsProxy;
         var _loc4_:uint = uint(_loc2_.window.content);
         var _loc5_:IHintSystemContentDescription = HintSystemContentProvider.get(_loc4_);
         if(_loc5_)
         {
            _loc5_.wasOpenedFromArchive = _loc2_.openedFromArchive;
            _loc5_.content.viewState = _loc2_.visibility;
            _loc5_.content.addToOverviewList = _loc2_.addToList;
            if(_loc2_.addToList)
            {
               _loc3_.addWindow(_loc4_,_loc5_);
            }
            TimeMeasuring.start(_loc4_.toString());
            sendNotification(HintSystemNotifications.SHOW_HINTWINDOW,_loc5_);
            _loc6_ = _loc5_.contentName;
            EventStreamClient.track("hint_displayed",{
               "hintIdentifier":_loc6_,
               "source":(_loc5_.wasOpenedFromArchive ? "archive" : "server")
            });
         }
         commandComplete();
      }
   }
}

