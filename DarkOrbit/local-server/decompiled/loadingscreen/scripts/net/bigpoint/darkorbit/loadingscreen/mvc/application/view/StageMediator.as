package net.bigpoint.darkorbit.loadingscreen.mvc.application.view
{
   import flash.display.Stage;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import net.bigpoint.darkorbit.loadingscreen.GameclientLoaderApplication;
   import net.bigpoint.darkorbit.loadingscreen.mvc.advertisement.view.mediators.AdvertisementViewMediator;
   import net.bigpoint.darkorbit.loadingscreen.mvc.application.notifications.ApplicationNotification;
   import net.bigpoint.darkorbit.loadingscreen.mvc.background.view.mediators.BackgroundContainerMediator;
   import net.bigpoint.darkorbit.loadingscreen.mvc.background.view.mediators.BackgroundImageMediator;
   import net.bigpoint.darkorbit.loadingscreen.mvc.bonuscalendar.view.BonusCalendarMediator;
   import net.bigpoint.darkorbit.loadingscreen.utils.Session;
   import org.puremvc.as3.interfaces.IMediator;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.mediator.Mediator;
   
   public class StageMediator extends Mediator implements IMediator
   {
      
      public static const NAME:String = "StageMediator";
      
      private var application:GameclientLoaderApplication;
      
      public function StageMediator(param1:Stage, param2:GameclientLoaderApplication)
      {
         super(NAME,param1);
         this.application = param2;
         param1.align = StageAlign.TOP_LEFT;
         param1.scaleMode = StageScaleMode.NO_SCALE;
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this.stage.addEventListener(Event.RESIZE,this.handleResize);
      }
      
      override public function onRemove() : void
      {
         this.stage.removeEventListener(Event.RESIZE,this.handleResize);
         super.onRemove();
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ApplicationNotification.INIT_APPLICATION];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         switch(param1.getName())
         {
            case ApplicationNotification.INIT_APPLICATION:
               facade.registerMediator(new LoadingAnimationViewMediator(this.application.loadingAnimation));
               facade.registerMediator(new BackgroundContainerMediator(this.application.backgroundContainer));
               facade.registerMediator(new BackgroundImageMediator(BackgroundImageMediator.NAME,this.application.backgroundImage));
               facade.registerMediator(new LoadingBarViewMediator(this.application.loadingBar));
               facade.registerMediator(new AdvertisementViewMediator(AdvertisementViewMediator.NAME,this.application.partnerView));
               facade.registerMediator(new BonusCalendarMediator(this.application.bonusCalendarView));
         }
      }
      
      private function handleResize(param1:Event) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(this.stage != null && this.application != null)
         {
            _loc2_ = this.stage.stageWidth > Session.minWidth ? uint(this.stage.stageWidth) : Session.minWidth;
            _loc3_ = this.stage.stageHeight > Session.minHeight ? uint(this.stage.stageHeight) : Session.minHeight;
            facade.sendNotification(ApplicationNotification.RESIZE,[_loc2_,_loc3_]);
         }
      }
      
      public function get stage() : Stage
      {
         return viewComponent as Stage;
      }
   }
}

