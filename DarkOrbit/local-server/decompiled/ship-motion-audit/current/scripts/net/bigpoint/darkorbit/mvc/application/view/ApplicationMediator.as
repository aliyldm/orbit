package net.bigpoint.darkorbit.mvc.application.view
{
   import flash.display.Stage;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import net.bigpoint.darkorbit.mvc.application.notification.ApplicationNotifications;
   import net.bigpoint.darkorbit.mvc.common.view.WindowMediator;
   import org.puremvc.as3.multicore.interfaces.IMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.mediator.Mediator;
   
   public class ApplicationMediator extends Mediator implements IMediator
   {
      
      public static const NAME:String = "ApplicationMediator";
      
      public function ApplicationMediator(param1:Object)
      {
         super(NAME,param1);
         this.stage.align = StageAlign.TOP_LEFT;
         this.stage.scaleMode = StageScaleMode.NO_SCALE;
         this.stage.frameRate = 60;
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ApplicationNotifications.INIT];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = param1.getName();
         var _loc4_:Object = param1.getBody();
         switch(_loc3_)
         {
            case ApplicationNotifications.INIT:
               facade.registerMediator(new WindowMediator(WindowMediator.NAME,viewComponent));
         }
      }
      
      protected function get stage() : Stage
      {
         return viewComponent.stage as Stage;
      }
   }
}

