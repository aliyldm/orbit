package net.bigpoint.darkorbit.loadingscreen.mvc.assets.controller
{
   import flash.display.DisplayObject;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.loadingscreen.mvc.application.model.JavascriptProxy;
   import net.bigpoint.darkorbit.loadingscreen.mvc.assets.model.AssetsProxy;
   import net.bigpoint.darkorbit.loadingscreen.mvc.assets.notifications.AssetNotification;
   import org.puremvc.as3.interfaces.ICommand;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.command.SimpleCommand;
   
   public class LoadImageCommand extends SimpleCommand implements ICommand
   {
      
      private var libID:String;
      
      private var assetsProxy:AssetsProxy;
      
      public function LoadImageCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:Array = null;
         JavascriptProxy.log("loading images ");
         _loc2_ = param1.getBody() as Array;
         this.libID = String(_loc2_[0]);
         this.assetsProxy = facade.retrieveProxy(AssetsProxy.PROXY_NAME) as AssetsProxy;
         if(this.assetsProxy.isLoaded(this.libID))
         {
            this.deliverImage();
         }
         else
         {
            this.assetsProxy.load(this.libID,this.handleImageLoaded,this.handleImageLoadingError);
         }
      }
      
      private function deliverImage() : void
      {
         var _loc1_:DisplayObject = this.assetsProxy.getImage(this.libID);
         sendNotification(AssetNotification.IMAGE_LOADED,[this.libID,_loc1_]);
      }
      
      private function handleImageLoaded(param1:ImageFinisher = null) : void
      {
         this.deliverImage();
      }
      
      private function handleImageLoadingError(param1:String = null) : void
      {
      }
   }
}

