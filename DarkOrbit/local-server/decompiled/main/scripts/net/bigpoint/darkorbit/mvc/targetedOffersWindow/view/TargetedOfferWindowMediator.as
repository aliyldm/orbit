package net.bigpoint.darkorbit.mvc.targetedOffersWindow.view
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.delete_in_eic.ItemsDataUtility;
   import net.bigpoint.darkorbit.mvc.abstract.view.DOAbstractMediator;
   import net.bigpoint.darkorbit.mvc.common.AssetNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.common.view.ScreenNotifications;
   import net.bigpoint.darkorbit.mvc.targetedOffersWindow.TargetedOfferNotifications;
   import net.bigpoint.darkorbit.mvc.targetedOffersWindow.controller.TargetedOfferEvent;
   import net.bigpoint.darkorbit.mvc.targetedOffersWindow.model.TargetedOfferPattern;
   import net.bigpoint.darkorbit.mvc.targetedOffersWindow.model.TargetedOfferProxy;
   import net.bigpoint.darkorbit.net.JavascriptProxy;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class TargetedOfferWindowMediator extends DOAbstractMediator
   {
      
      public static const NAME:String = "TargetedOfferWindowMediator";
      
      public function TargetedOfferWindowMediator(param1:TargetedOfferWindow)
      {
         super(NAME,param1);
         mapNotificationToMethod(ScreenNotifications.SCREEN_VIEWPORT_RESIZED,this.handleScreenResized);
      }
      
      override public function onRegister() : void
      {
         this.window.addEventListener(TargetedOfferEvent.OFFER_DECLINED,this.handleOfferDeclined);
         this.offer.addEventListener(TargetedOfferEvent.OFFER_ACCEPTED,this.handleOfferAccepted);
         this.offer.addEventListener(TargetedOfferEvent.OFFER_CREATED,this.handleOfferAdded);
         this.offer.addEventListener(TargetedOfferEvent.OFFER_COREPONENTS_CREATED,this.loadBackgroundImage);
         this.offer.addEventListener(TargetedOfferEvent.OFFER_BG_ADDED,this.loadHooverImage);
         var _loc1_:Array = this.proxy.getItemRewards();
         this.offer.setUrlList(this.getVideoURLs(_loc1_));
         this.offer.setRewards(_loc1_);
      }
      
      private function getVideoURLs(param1:Array) : Array
      {
         var _loc3_:ItemVO = null;
         var _loc4_:String = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in param1)
         {
            _loc4_ = ItemsDataUtility.getVideoURLbyItem(_loc3_.item);
            if(_loc4_)
            {
               _loc2_.push(_loc4_);
            }
         }
         return _loc2_;
      }
      
      private function handleOfferAdded(param1:TargetedOfferEvent) : void
      {
         this.window.show();
      }
      
      private function loadBackgroundImage(param1:TargetedOfferEvent) : void
      {
         var _loc2_:TargetedOfferPattern = PatternManager.targetedOffersPatterns[this.offer.offerKey] as TargetedOfferPattern || PatternManager.targetedOffersPatterns["default"] as TargetedOfferPattern;
         var _loc3_:String = _loc2_.gfxKey;
         facade.sendNotification(AssetNotifications.LOAD_ASSET,[_loc3_,this.offer.createOffer,null,AssetsProxy.GAME]);
      }
      
      private function loadHooverImage(param1:TargetedOfferEvent) : void
      {
         var _loc2_:String = "targeted_offer_hover";
         facade.sendNotification(AssetNotifications.LOAD_ASSET,[_loc2_,this.offer.addHoverImage,null,AssetsProxy.GAME]);
      }
      
      private function handleOfferAccepted(param1:TargetedOfferEvent) : void
      {
         JavascriptProxy.call(JavascriptProxy.FUNCTION_OPEN_PAYMENT_POPUP_WITH_LINK,[this.proxy.paymentLink]);
         this.remove();
      }
      
      public function handleScreenResized(param1:INotification = null) : void
      {
         this.window.initAlignment();
         this.window.x = this.window.targetX;
         this.window.y = this.window.targetY;
      }
      
      private function handleOfferDeclined(param1:Event) : void
      {
         this.remove();
      }
      
      private function remove() : void
      {
         this.removeEventListeners();
         this.offer.cleanup();
         this.window.cleanup(true);
         sendNotification(TargetedOfferNotifications.CLEANUP);
         onRemove();
      }
      
      private function removeEventListeners() : void
      {
         this.window.removeEventListener(TargetedOfferEvent.OFFER_DECLINED,this.handleOfferDeclined);
         this.offer.removeEventListener(TargetedOfferEvent.OFFER_ACCEPTED,this.handleOfferAccepted);
         this.offer.removeEventListener(TargetedOfferEvent.OFFER_CREATED,this.handleOfferAdded);
         this.offer.removeEventListener(TargetedOfferEvent.OFFER_COREPONENTS_CREATED,this.loadBackgroundImage);
      }
      
      private function get window() : TargetedOfferWindow
      {
         return viewComponent as TargetedOfferWindow;
      }
      
      private function get offer() : TargetedOffer
      {
         return this.window.offer as TargetedOffer;
      }
      
      protected function get proxy() : TargetedOfferProxy
      {
         return retrieveProxy(TargetedOfferProxy.NAME) as TargetedOfferProxy;
      }
   }
}

