package net.bigpoint.darkorbit.loadingscreen.mvc.assets.controller
{
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.BpEventStreamUtil;
   import net.bigpoint.darkorbit.loadingscreen.mvc.application.model.JavascriptProxy;
   import net.bigpoint.darkorbit.loadingscreen.mvc.assets.model.AssetsProxy;
   import net.bigpoint.darkorbit.loadingscreen.mvc.assets.notifications.AssetNotification;
   import org.puremvc.as3.interfaces.ICommand;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.command.SimpleCommand;
   
   public class LoadSWFFinisherCommand extends SimpleCommand implements ICommand
   {
      
      private var libID:String;
      
      private var assetsProxy:AssetsProxy;
      
      private var notification:String;
      
      public function LoadSWFFinisherCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:Array = null;
         JavascriptProxy.log("loading swfs");
         _loc2_ = param1.getBody() as Array;
         this.libID = String(_loc2_[0]);
         this.notification = AssetNotification.SWFFINISHER_LOADED;
         if(_loc2_[1] != null)
         {
            this.notification = String(_loc2_[1]);
         }
         this.assetsProxy = facade.retrieveProxy(AssetsProxy.PROXY_NAME) as AssetsProxy;
         if(this.assetsProxy.isLoaded(this.libID))
         {
            this.deliverSWFFinisher();
         }
         else
         {
            this.assetsProxy.load(this.libID,this.handleSWFFinisherLoaded,this.handleSWFFinisherLoadingError);
         }
      }
      
      private function deliverSWFFinisher() : void
      {
         var _loc1_:SWFFinisher = this.assetsProxy.getLib(this.libID);
         sendNotification(this.notification,[this.libID,_loc1_]);
      }
      
      private function handleSWFFinisherLoaded(param1:SWFFinisher = null) : void
      {
         this.deliverSWFFinisher();
      }
      
      private function handleSWFFinisherLoadingError(param1:String = null) : void
      {
         BpEventStreamUtil.rawTrack("flash_loadingscreen_swfFinisherLoadError",{"libID":this.libID});
      }
   }
}

