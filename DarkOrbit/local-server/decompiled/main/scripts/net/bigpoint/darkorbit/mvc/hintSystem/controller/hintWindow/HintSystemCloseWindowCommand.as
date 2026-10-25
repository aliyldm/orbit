package net.bigpoint.darkorbit.mvc.hintSystem.controller.hintWindow
{
   import flash.geom.Point;
   import net.bigpoint.darkorbit.com.module.HintWindowClosedRequest;
   import net.bigpoint.darkorbit.com.module.HintWindowModule;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.view.FeaturesMenuMediator;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.view.components.FeatureBtn;
   import net.bigpoint.darkorbit.mvc.hintSystem.HintSystemNotifications;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.IHintSystemContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.vo.HintSystemHintWindowOnActionVO;
   import net.bigpoint.darkorbit.mvc.hintSystem.view.hintWindow.HintSystemHintWindowMediator;
   import net.bigpoint.darkorbit.utils.TimeMeasuring;
   import net.bigpoint.eventstream.EventStreamClient;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class HintSystemCloseWindowCommand extends SimpleCommand
   {
      
      public function HintSystemCloseWindowCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc7_:int = 0;
         var _loc8_:HintWindowModule = null;
         var _loc9_:HintWindowClosedRequest = null;
         var _loc10_:Number = NaN;
         var _loc11_:Class = null;
         var _loc12_:String = null;
         var _loc13_:HintSystemHintWindowOnActionVO = null;
         var _loc14_:String = null;
         var _loc15_:Point = null;
         super.execute(param1);
         var _loc2_:Array = param1.getBody() as Array;
         var _loc3_:IHintSystemContentDescription = _loc2_[0] as IHintSystemContentDescription;
         var _loc4_:HintSystemHintWindowMediator = facade.retrieveMediator(HintSystemHintWindowMediator.NAME) as HintSystemHintWindowMediator;
         _loc4_.cleanUpView();
         if(_loc3_)
         {
            _loc7_ = int(_loc3_.id);
            _loc8_ = new HintWindowModule(_loc7_);
            _loc9_ = new HintWindowClosedRequest(_loc8_);
            _loc9_.wasOpenedFromArchive = _loc3_.wasOpenedFromArchive;
            sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc9_);
            if(_loc3_.content.onClosedTriggeredMVCCommand != null)
            {
               _loc11_ = _loc3_.content.onClosedTriggeredMVCCommand;
               _loc12_ = HintSystemNotifications.ON_CLOSE_HINTWINDOW;
               _loc13_ = new HintSystemHintWindowOnActionVO();
               _loc13_.notificationName = _loc12_;
               facade.registerCommand(_loc12_,_loc11_);
               facade.sendNotification(_loc12_,_loc13_);
            }
            _loc10_ = TimeMeasuring.stop(_loc7_.toString(),TimeMeasuring.TIMEFORMAT_SECONDS);
            _loc10_ = _loc10_ > 0 ? _loc10_ : 0;
            if(_loc10_ > 0)
            {
               _loc14_ = _loc3_.contentName;
               if(!_loc14_)
               {
                  throw new Error("ContentDescription::ContentName is missing! You have to specify the contentName for the content with the following ID = " + _loc7_);
               }
               EventStreamClient.track("hint_closed",{
                  "hintIdentifier":_loc14_,
                  "timeSinceOpen":_loc10_
               });
            }
         }
         var _loc5_:FeaturesMenuMediator = facade.retrieveMediator(FeaturesMenuMediator.NAME) as FeaturesMenuMediator;
         var _loc6_:FeatureBtn = _loc5_.getGameFeatureBtnById(GuiConstants.HELP_WINDOW);
         if(_loc6_)
         {
            _loc15_ = _loc6_.localToGlobal(new Point(0,0));
            _loc4_.startCloseAnimation(_loc15_);
         }
      }
   }
}

