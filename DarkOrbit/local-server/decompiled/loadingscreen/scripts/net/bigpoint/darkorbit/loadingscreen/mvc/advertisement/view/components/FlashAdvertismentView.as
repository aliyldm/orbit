package net.bigpoint.darkorbit.loadingscreen.mvc.advertisement.view.components
{
   import com.greensock.TweenLite;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.loadingscreen.mvc.advertisement.view.events.AdvertisementEvent;
   
   public class FlashAdvertismentView extends Sprite
   {
      
      private var containerImage:Sprite;
      
      public function FlashAdvertismentView()
      {
         super();
      }
      
      public function initializeComponent() : void
      {
         this.containerImage = new Sprite();
         this.addChild(this.containerImage);
      }
      
      public function showPartner(param1:Sprite) : void
      {
         param1.name = "image";
         param1.alpha = 0;
         this.containerImage.addChild(param1);
         this.containerImage.buttonMode = true;
         TweenLite.to(param1,1,{"alpha":1});
         this.width = this.containerImage.width;
         this.height = this.containerImage.height;
         this.containerImage.addEventListener(MouseEvent.MOUSE_DOWN,this.handlePartnerLogoClicked);
      }
      
      private function handlePartnerLogoClicked(param1:MouseEvent) : void
      {
         var _loc2_:AdvertisementEvent = new AdvertisementEvent(AdvertisementEvent.CLICKED);
         dispatchEvent(_loc2_);
      }
   }
}

