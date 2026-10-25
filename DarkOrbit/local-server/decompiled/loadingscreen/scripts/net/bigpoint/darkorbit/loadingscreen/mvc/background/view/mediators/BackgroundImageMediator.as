package net.bigpoint.darkorbit.loadingscreen.mvc.background.view.mediators
{
   import flash.display.Bitmap;
   import net.bigpoint.darkorbit.loadingscreen.mvc.application.notifications.ApplicationNotification;
   import net.bigpoint.darkorbit.loadingscreen.mvc.application.view.StageMediator;
   import net.bigpoint.darkorbit.loadingscreen.mvc.assets.notifications.AssetNotification;
   import net.bigpoint.darkorbit.loadingscreen.mvc.background.view.components.FlashBackgroundImage;
   import org.puremvc.as3.interfaces.IMediator;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.mediator.Mediator;
   
   public class BackgroundImageMediator extends Mediator implements IMediator
   {
      
      public static const NAME:String = "BackgroundImageMediator";
      
      public function BackgroundImageMediator(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [AssetNotification.READY,AssetNotification.BACKGROUND_IMAGE_LOADED,AssetNotification.IMAGE_LOADED,ApplicationNotification.RESIZE];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:Bitmap = null;
         switch(param1.getName())
         {
            case AssetNotification.READY:
               sendNotification(AssetNotification.LOAD_BACKGROUND_IMAGE);
               break;
            case AssetNotification.BACKGROUND_IMAGE_LOADED:
               _loc4_ = Bitmap(param1.getBody());
               this.backgroundImage.setBackground(_loc4_);
            case ApplicationNotification.RESIZE:
               this.resized();
         }
      }
      
      private function resized() : void
      {
         var _loc1_:StageMediator = facade.retrieveMediator(StageMediator.NAME) as StageMediator;
         this.backgroundImage.setSize(_loc1_.stage.stageWidth,_loc1_.stage.stageHeight);
      }
      
      private function get backgroundImage() : FlashBackgroundImage
      {
         return viewComponent as FlashBackgroundImage;
      }
      
      public function cleanup() : void
      {
         this.backgroundImage.cleanup();
         viewComponent = null;
      }
   }
}

