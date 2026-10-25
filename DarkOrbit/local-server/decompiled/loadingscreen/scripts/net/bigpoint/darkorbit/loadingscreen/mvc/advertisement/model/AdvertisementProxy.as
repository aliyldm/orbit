package net.bigpoint.darkorbit.loadingscreen.mvc.advertisement.model
{
   import com.greensock.events.LoaderEvent;
   import com.greensock.loading.ImageLoader;
   import com.greensock.loading.LoaderMax;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.net.navigateToURL;
   import net.bigpoint.darkorbit.loadingscreen.mvc.advertisement.model.vo.AdvertisementVO;
   import net.bigpoint.darkorbit.loadingscreen.mvc.advertisement.notifications.AdvertisementNotification;
   import net.bigpoint.darkorbit.loadingscreen.utils.Session;
   import org.puremvc.as3.interfaces.IProxy;
   import org.puremvc.as3.patterns.proxy.Proxy;
   
   public class AdvertisementProxy extends Proxy implements IProxy
   {
      
      public static const PROXY_NAME:String = "AdvertisementProxy";
      
      private var loadedEventName:String;
      
      private var loader:URLLoader;
      
      private var jsonData:Object;
      
      public var queue:LoaderMax;
      
      private var partner:AdvertisementVO;
      
      public function AdvertisementProxy(param1:String, param2:String)
      {
         super(param1,null);
         this.loadedEventName = param2;
      }
      
      public function loadAdvertisement() : void
      {
         var _loc1_:String = Session.host + "flashAPI/loadingScreen.php";
         this.loader = new URLLoader();
         this.addLoaderListener();
         var _loc2_:URLRequest = new URLRequest(_loc1_);
         var _loc3_:String = "showAdvertisement";
         var _loc4_:int = 0;
         var _loc5_:URLVariables = new URLVariables();
         _loc5_.action = _loc3_;
         _loc5_.isEncodeMessage = _loc4_;
         _loc5_.params = null;
         _loc2_.data = _loc5_;
         _loc2_.method = URLRequestMethod.POST;
         this.loader.load(_loc2_);
      }
      
      private function handleAdvertisementLoaded(param1:Event) : void
      {
         var jsonString:String;
         var e:Event = param1;
         this.removeLoaderListener();
         jsonString = this.loader.data as String;
         try
         {
            this.jsonData = JSON.parse(jsonString);
         }
         catch(error:Error)
         {
            sendNotification(AdvertisementNotification.DISABLED);
            return;
         }
         try
         {
            this.parseJSON();
         }
         catch(error:Error)
         {
            sendNotification(AdvertisementNotification.DISABLED);
            return;
         }
         if(this.partner == null || !this.partner.active)
         {
            sendNotification(AdvertisementNotification.DISABLED);
         }
         else
         {
            sendNotification(this.loadedEventName,this.partner);
         }
      }
      
      private function handlePartnerLoadingIOError(param1:IOErrorEvent) : void
      {
         sendNotification(AdvertisementNotification.DISABLED);
         this.removeLoaderListener();
      }
      
      private function handleAdvertisementLoadingSecurityError(param1:SecurityErrorEvent) : void
      {
         sendNotification(AdvertisementNotification.DISABLED);
         this.removeLoaderListener();
      }
      
      private function parseJSON() : void
      {
         var _loc1_:Boolean = int(this.jsonData.isError) == 1 ? true : false;
         if(_loc1_)
         {
            sendNotification(AdvertisementNotification.DISABLED);
            return;
         }
         this.partner = new AdvertisementVO();
         if(String(this.jsonData.data.ret.active) == "on")
         {
            this.partner.active = true;
         }
         else
         {
            this.partner.active = false;
         }
         this.partner.src = Session.cdnHost + String(this.jsonData.data.ret.img);
         this.partner.url = String(this.jsonData.data.ret.url);
      }
      
      public function showPartner() : void
      {
         sendNotification(AdvertisementNotification.SHOW_VISUAL,[this.partner]);
      }
      
      public function referToUrl() : void
      {
         var _loc1_:URLRequest = new URLRequest(this.partner.url);
         try
         {
            navigateToURL(_loc1_,"_blank");
         }
         catch(e:Error)
         {
         }
      }
      
      public function loadPartnerVisual() : void
      {
         this.queue = new LoaderMax({
            "name":"visualsQueue",
            "onComplete":this.handleVisualsQueueLoaded,
            "onError":this.handleVisualsQueueLoadingError,
            "onFail":this.handleVisualsQueueLoadingError,
            "onIOError":this.handleVisualsQueueLoadingError,
            "onSecurityError":this.handleVisualsQueueLoadingError
         });
         this.queue.append(new ImageLoader(this.partner.src,{
            "name":"image",
            "estimatedBytes":50,
            "container":this.partner.container,
            "onComplete":this.handleImageLoaded,
            "onError":this.handleImageLoadingError,
            "onFail":this.handleImageLoadingError,
            "onIOError":this.handleImageLoadingError,
            "onSecurityError":this.handleImageLoadingError
         }));
         this.queue.load();
      }
      
      private function handleVisualsQueueLoaded(param1:LoaderEvent) : void
      {
         sendNotification(AdvertisementNotification.VISUAL_LOADED);
         this.showPartner();
      }
      
      private function handleImageLoaded(param1:LoaderEvent) : void
      {
      }
      
      private function handleVisualsQueueLoadingError(param1:LoaderEvent) : void
      {
      }
      
      private function handleImageLoadingError(param1:LoaderEvent) : void
      {
      }
      
      private function addLoaderListener() : void
      {
         this.loader.addEventListener(Event.COMPLETE,this.handleAdvertisementLoaded);
         this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.handlePartnerLoadingIOError);
         this.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleAdvertisementLoadingSecurityError);
      }
      
      private function removeLoaderListener() : void
      {
         this.loader.removeEventListener(Event.COMPLETE,this.handleAdvertisementLoaded);
         this.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.handlePartnerLoadingIOError);
         this.loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleAdvertisementLoadingSecurityError);
      }
      
      public function cleanup() : void
      {
         if(this.loader)
         {
            this.removeLoaderListener();
            this.loader = null;
         }
         if(this.queue)
         {
            this.queue.dispose(true);
            this.queue = null;
         }
         this.jsonData = null;
         this.partner = null;
      }
   }
}

