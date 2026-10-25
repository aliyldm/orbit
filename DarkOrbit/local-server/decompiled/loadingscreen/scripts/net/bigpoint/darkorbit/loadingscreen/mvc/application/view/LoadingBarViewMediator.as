package net.bigpoint.darkorbit.loadingscreen.mvc.application.view
{
   import flash.events.Event;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.BpEventStreamUtil;
   import net.bigpoint.darkorbit.loadingscreen.mvc.application.notifications.ApplicationNotification;
   import net.bigpoint.darkorbit.loadingscreen.mvc.assets.model.ids.LibId;
   import net.bigpoint.darkorbit.loadingscreen.mvc.assets.notifications.AssetNotification;
   import net.bigpoint.darkorbit.loadingscreen.mvc.bonuscalendar.notifications.BonusCalendarNotifications;
   import org.puremvc.as3.interfaces.IMediator;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.mediator.Mediator;
   
   public class LoadingBarViewMediator extends Mediator implements IMediator
   {
      
      public static const NAME:String = "LoadingBarViewMediator";
      
      public function LoadingBarViewMediator(param1:FlashLoadingBarView)
      {
         super(NAME,param1);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ApplicationNotification.GAMECLIENT_LOAD_PROGRESS,ApplicationNotification.GAMECLIENT_LOADED,AssetNotification.UI_LOADED,BonusCalendarNotifications.DAILY_LOGIN_BONUS_ACTIVE];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:SWFFinisher = null;
         switch(param1.getName())
         {
            case AssetNotification.UI_LOADED:
               _loc2_ = param1.getBody() as Array;
               _loc3_ = _loc2_[0] as String;
               if(_loc3_ == LibId.UI_ASSETS)
               {
                  _loc4_ = _loc2_[1] as SWFFinisher;
                  this.loadingBarView.initComponent(_loc4_);
               }
               break;
            case ApplicationNotification.GAMECLIENT_LOAD_PROGRESS:
               _loc2_ = param1.getBody() as Array;
               this.loadingBarView.updateLoadPercentage(int(_loc2_[0]));
               break;
            case ApplicationNotification.GAMECLIENT_LOADED:
               this.gameClientLoaded();
               break;
            case BonusCalendarNotifications.DAILY_LOGIN_BONUS_ACTIVE:
               this.loadingBarView.dailyLoginBonusActive();
         }
      }
      
      private function gameClientLoaded() : void
      {
         this.loadingBarView.addEventListener(Event.COMPLETE,this.handleStartBtnClicked);
         this.loadingBarView.clientFullyLoaded();
      }
      
      private function handleStartBtnClicked(param1:Event) : void
      {
         BpEventStreamUtil.rawTrack("flash_loadingscreen_startButtonClicked");
         sendNotification(ApplicationNotification.START_GAME);
      }
      
      private function get loadingBarView() : FlashLoadingBarView
      {
         return viewComponent as FlashLoadingBarView;
      }
   }
}

