package net.bigpoint.darkorbit.loadingscreen.mvc.assets.controller
{
   import net.bigpoint.darkorbit.loadingscreen.mvc.assets.model.ids.LibId;
   import net.bigpoint.darkorbit.loadingscreen.mvc.assets.notifications.AssetNotification;
   import org.puremvc.as3.interfaces.ICommand;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.command.SimpleCommand;
   
   public class LoadAssetsCommand extends SimpleCommand implements ICommand
   {
      
      public function LoadAssetsCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         sendNotification(AssetNotification.LOAD_SWFFINISHER,[LibId.UI_ASSETS,AssetNotification.UI_LOADED]);
         sendNotification(AssetNotification.LOAD_SWFFINISHER,[LibId.BG_ASSETS,AssetNotification.BG_LOADED]);
      }
   }
}

