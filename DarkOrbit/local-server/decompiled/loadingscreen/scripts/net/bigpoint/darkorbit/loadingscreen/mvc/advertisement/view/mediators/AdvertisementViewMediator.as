package net.bigpoint.darkorbit.loadingscreen.mvc.advertisement.view.mediators
{
   import net.bigpoint.darkorbit.loadingscreen.mvc.advertisement.model.vo.AdvertisementVO;
   import net.bigpoint.darkorbit.loadingscreen.mvc.advertisement.notifications.AdvertisementNotification;
   import net.bigpoint.darkorbit.loadingscreen.mvc.advertisement.view.components.FlashAdvertismentView;
   import net.bigpoint.darkorbit.loadingscreen.mvc.advertisement.view.events.AdvertisementEvent;
   import org.puremvc.as3.interfaces.IMediator;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.mediator.Mediator;
   
   public class AdvertisementViewMediator extends Mediator implements IMediator
   {
      
      public static const NAME:String = "AdvertisementViewMediator";
      
      public function AdvertisementViewMediator(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [AdvertisementNotification.SHOW_VISUAL];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:Array = null;
         var _loc3_:AdvertisementVO = null;
         switch(param1.getName())
         {
            case AdvertisementNotification.SHOW_VISUAL:
               _loc2_ = param1.getBody() as Array;
               _loc3_ = _loc2_[0] as AdvertisementVO;
               this.partnerView.showPartner(_loc3_.container);
               if(_loc3_.url != "")
               {
                  this.partnerView.addEventListener(AdvertisementEvent.CLICKED,this.handlePartnerClicked);
               }
         }
      }
      
      private function handlePartnerClicked(param1:AdvertisementEvent) : void
      {
         sendNotification(AdvertisementNotification.PARTNER_CLICK);
      }
      
      private function get partnerView() : FlashAdvertismentView
      {
         return viewComponent as FlashAdvertismentView;
      }
   }
}

