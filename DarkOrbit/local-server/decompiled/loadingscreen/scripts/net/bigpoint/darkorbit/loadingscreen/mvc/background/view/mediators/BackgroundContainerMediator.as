package net.bigpoint.darkorbit.loadingscreen.mvc.background.view.mediators
{
   import flash.display.Bitmap;
   import flash.events.Event;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.loadingscreen.mvc.application.notifications.ApplicationNotification;
   import net.bigpoint.darkorbit.loadingscreen.mvc.application.view.StageMediator;
   import net.bigpoint.darkorbit.loadingscreen.mvc.assets.model.ids.LinkageId;
   import net.bigpoint.darkorbit.loadingscreen.mvc.assets.notifications.AssetNotification;
   import net.bigpoint.darkorbit.loadingscreen.mvc.background.view.components.FlashBackgroundContainer;
   import org.puremvc.as3.interfaces.IMediator;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.mediator.Mediator;
   
   public class BackgroundContainerMediator extends Mediator implements IMediator
   {
      
      public static const NAME:String = "BackgroundContainerMediator";
      
      public function BackgroundContainerMediator(param1:FlashBackgroundContainer)
      {
         super(NAME,param1);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [AssetNotification.BG_LOADED,AssetNotification.IMAGE_LOADED,ApplicationNotification.RESIZE,ApplicationNotification.GAMECLIENT_LOADED];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:Array = null;
         var _loc3_:SWFFinisher = null;
         switch(param1.getName())
         {
            case AssetNotification.BG_LOADED:
               _loc2_ = param1.getBody() as Array;
               _loc3_ = _loc2_[1] as SWFFinisher;
               this.backgroundContainer.logo = _loc3_.getEmbeddedBitmapData(LinkageId.BG_LOGO);
               this.resized();
               break;
            case ApplicationNotification.RESIZE:
               this.resized();
               break;
            case ApplicationNotification.GAMECLIENT_LOADED:
               this.backgroundContainer.addEventListener(Event.COMPLETE,this.handleBackgroundClicked);
               this.backgroundContainer.clientFullyLoaded();
         }
      }
      
      private function resized() : void
      {
         var _loc1_:StageMediator = facade.retrieveMediator(StageMediator.NAME) as StageMediator;
         this.backgroundContainer.setSize(_loc1_.stage.stageWidth,_loc1_.stage.stageHeight);
      }
      
      public function scaleLogo(param1:int) : void
      {
         this.backgroundContainer.scaleLogo(param1);
      }
      
      private function handleBackgroundClicked(param1:Event) : void
      {
      }
      
      private function get backgroundContainer() : FlashBackgroundContainer
      {
         return viewComponent as FlashBackgroundContainer;
      }
      
      public function cleanup() : void
      {
         this.backgroundContainer.cleanup();
         viewComponent = null;
      }
      
      public function getLogoAsDisplayObject() : Bitmap
      {
         return this.backgroundContainer.getLogoAsDisplayObject();
      }
   }
}

