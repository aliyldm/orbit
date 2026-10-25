package net.bigpoint.darkorbit.loadingscreen.mvc.assets.controller
{
   import flash.display.Bitmap;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import net.bigpoint.darkorbit.loadingscreen.mvc.application.model.JavascriptProxy;
   import net.bigpoint.darkorbit.loadingscreen.mvc.assets.model.AssetsProxy;
   import net.bigpoint.darkorbit.loadingscreen.mvc.assets.notifications.AssetNotification;
   import net.bigpoint.darkorbit.loadingscreen.utils.Session;
   import org.puremvc.as3.interfaces.ICommand;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.command.SimpleCommand;
   
   public class LoadBackgroundCommand extends SimpleCommand implements ICommand
   {
      
      public function LoadBackgroundCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:String = null;
         JavascriptProxy.log("loading backgrounds");
         _loc2_ = Session.theme;
         AssetsProxy.loadResource(_loc2_,this.handleResourceLoaded);
      }
      
      private function handleResourceLoaded(param1:Event) : void
      {
         var _loc2_:LoaderInfo = LoaderInfo(param1.target);
         var _loc3_:Bitmap = Bitmap(_loc2_.content);
         sendNotification(AssetNotification.BACKGROUND_IMAGE_LOADED,_loc3_);
      }
   }
}

