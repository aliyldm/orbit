package net.bigpoint.darkorbit.mvc.gui.windows.birthdaygate2025.model
{
   import com.bigpoint.utils.BitmapAtlas;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.XMLFinisher;
   import net.bigpoint.darkorbit.com.module.porting.birthday2025.Birthday2025PointRewardCommand;
   import net.bigpoint.darkorbit.com.module.porting.birthday2025.Birthday2025PointRewardRequest;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.birthdaygate2025.model.vo.Birthday2025PointRewardViewData;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.puremvc.as3.multicore.interfaces.IFacade;
   
   public class BirthdayGate2025Proxy extends SimpleWindowProxy
   {
      
      public static const NAME:String = "AnniversaryEventProxy";
      
      public var isFirst:Boolean = true;
      
      private var _viewData:Birthday2025PointRewardViewData = null;
      
      private var is_xml_ready:Boolean = false;
      
      private var is_texture_ready:Boolean = false;
      
      public function BirthdayGate2025Proxy()
      {
         super(BirthdayGate2025Proxy.NAME);
         this.initBitmapAtlases();
         Settings.displayMiniMapBackgroundImage.changed.add(this.sendViewInitRequest);
      }
      
      public static function getProxy(param1:IFacade) : BirthdayGate2025Proxy
      {
         var _loc2_:BirthdayGate2025Proxy = param1.retrieveProxy(BirthdayGate2025Proxy.NAME) as BirthdayGate2025Proxy;
         if(!_loc2_)
         {
            _loc2_ = new BirthdayGate2025Proxy();
            param1.registerProxy(_loc2_);
         }
         return _loc2_;
      }
      
      public function initBitmapAtlases() : void
      {
         ResourceManager.fileCollection.load(BirthdayGate2025Constants.UI_ATLASXML,this.handleResourcesXMLReady);
         ResourceManager.fileCollection.load(BirthdayGate2025Constants.UI_TEXTURE,this.handleResourcesReady);
      }
      
      public function sendViewInitRequest() : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new Birthday2025PointRewardRequest());
      }
      
      public function rcvViewData(param1:Birthday2025PointRewardCommand) : void
      {
         if(!this._viewData)
         {
            this._viewData = new Birthday2025PointRewardViewData();
         }
         this._viewData.update(param1);
         sendNotification(BirthdayGate2025Constants.INIT_VIEW_DATA);
      }
      
      public function get viewData() : Birthday2025PointRewardViewData
      {
         return this._viewData;
      }
      
      private function handleResourcesXMLReady(param1:XMLFinisher) : void
      {
         this.is_xml_ready = true;
         this.setTextureBitmapData();
      }
      
      private function handleResourcesReady(param1:ImageFinisher) : void
      {
         this.is_texture_ready = true;
         this.setTextureBitmapData();
      }
      
      public function get xmlReady() : Boolean
      {
         return this.is_xml_ready;
      }
      
      public function get textureReady() : Boolean
      {
         return this.is_texture_ready;
      }
      
      private function setTextureBitmapData() : void
      {
         var _loc1_:AssetsProxy = null;
         if(this.is_texture_ready && this.is_xml_ready)
         {
            _loc1_ = GameFacade.getInstance().retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
            _loc1_.addBitmapAtlas(BirthdayGate2025Constants.UI_ATLASXML,this.createBitmapAtlas(BirthdayGate2025Constants.UI_TEXTURE,BirthdayGate2025Constants.UI_ATLASXML));
            sendNotification(BirthdayGate2025Constants.INIT_UI_RESOURCE_COMPLETE);
         }
      }
      
      private function createBitmapAtlas(param1:String, param2:String) : BitmapAtlas
      {
         var _loc3_:ImageFinisher = getFinisher(param1) as ImageFinisher;
         var _loc4_:XMLFinisher = getFinisher(param2) as XMLFinisher;
         return new BitmapAtlas(_loc3_.getBitmap(),_loc4_.getXML());
      }
   }
}

