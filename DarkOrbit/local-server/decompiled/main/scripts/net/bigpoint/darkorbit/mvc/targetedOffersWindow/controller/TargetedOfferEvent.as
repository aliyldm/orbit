package net.bigpoint.darkorbit.mvc.targetedOffersWindow.controller
{
   import flash.events.Event;
   
   public class TargetedOfferEvent extends Event
   {
      
      public static const OFFER_ACCEPTED:String = "Targeted offer accepted";
      
      public static const OFFER_DECLINED:String = "Targeted offer declined";
      
      public static const OFFER_CREATED:String = "Targeted offer added";
      
      public static const OFFER_COREPONENTS_CREATED:String = "Targeted offer content created";
      
      public static const OFFER_BG_ADDED:String = "Targeted offer background added";
      
      public function TargetedOfferEvent(param1:String)
      {
         super(param1);
      }
   }
}

