package net.bigpoint.darkorbit.loadingscreen.mvc.application.view
{
   import net.bigpoint.darkorbit.loadingscreen.mvc.application.notifications.ApplicationNotification;
   import net.bigpoint.darkorbit.loadingscreen.mvc.application.notifications.LoadingAnimationNotification;
   import net.bigpoint.darkorbit.loadingscreen.mvc.application.view.components.FlashLoadingAnimation;
   import net.bigpoint.darkorbit.loadingscreen.mvc.assets.model.ids.LibId;
   import net.bigpoint.darkorbit.loadingscreen.mvc.assets.notifications.AssetNotification;
   import org.puremvc.as3.interfaces.IMediator;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.mediator.Mediator;
   
   public class LoadingAnimationViewMediator extends Mediator implements IMediator
   {
      
      public static const NAME:String = "LoadingAnimationViewMediator";
      
      public function LoadingAnimationViewMediator(param1:FlashLoadingAnimation)
      {
         super(NAME,param1);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ApplicationNotification.STARTUP,ApplicationNotification.RESIZE,AssetNotification.UI_LOADED,LoadingAnimationNotification.SHOW,LoadingAnimationNotification.HIDE];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         _loc2_ = param1.getBody() as Array;
         switch(param1.getName())
         {
            case ApplicationNotification.STARTUP:
               this.loadingAnimationView.init();
               this.resized();
               break;
            case ApplicationNotification.RESIZE:
               this.resized();
               break;
            case AssetNotification.UI_LOADED:
               _loc3_ = _loc2_[0] as String;
               if(_loc3_ == LibId.UI_ASSETS)
               {
                  this.loadingAnimationView.hide();
               }
               break;
            case LoadingAnimationNotification.SHOW:
               this.loadingAnimationView.show();
               this.resized();
               break;
            case LoadingAnimationNotification.HIDE:
               this.loadingAnimationView.hide();
         }
      }
      
      private function resized() : void
      {
         var _loc1_:StageMediator = facade.retrieveMediator(StageMediator.NAME) as StageMediator;
         this.loadingAnimationView.x = _loc1_.stage.stageWidth >> 1;
         this.loadingAnimationView.y = _loc1_.stage.stageHeight >> 1;
      }
      
      private function get loadingAnimationView() : FlashLoadingAnimation
      {
         return viewComponent as FlashLoadingAnimation;
      }
   }
}

