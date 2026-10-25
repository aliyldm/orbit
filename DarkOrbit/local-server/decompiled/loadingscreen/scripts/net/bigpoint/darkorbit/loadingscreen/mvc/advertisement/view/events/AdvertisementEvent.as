package net.bigpoint.darkorbit.loadingscreen.mvc.advertisement.view.events
{
   import flash.events.Event;
   
   public class AdvertisementEvent extends Event
   {
      
      public static const NAME:String = "AdvertisementEvent";
      
      public static const CLICKED:String = NAME + "Clicked";
      
      public function AdvertisementEvent(param1:String)
      {
         super(param1);
      }
      
      override public function clone() : Event
      {
         return new AdvertisementEvent(type);
      }
   }
}

