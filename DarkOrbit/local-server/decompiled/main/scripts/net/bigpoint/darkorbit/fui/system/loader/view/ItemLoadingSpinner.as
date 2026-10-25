package net.bigpoint.darkorbit.fui.system.loader.view
{
   import com.greensock.TweenLite;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import net.bigpoint.darkorbit.fui.UISystem;
   
   public class ItemLoadingSpinner extends Sprite
   {
      
      private const _timer:Timer = new Timer(40);
      
      private var _libraryID:String = "gameclientCommonUI";
      
      private var _linkageID:String = "preloader_item30x30";
      
      private var _rotationContainer:Sprite;
      
      private var _displayObject:Bitmap;
      
      public function ItemLoadingSpinner()
      {
         super();
         this.create();
      }
      
      public function start() : void
      {
         TweenLite.to(this._displayObject,0.2,{"alpha":1});
         this._timer.start();
      }
      
      public function finished() : void
      {
         TweenLite.to(this._displayObject,0.2,{
            "alpha":0,
            "onComplete":this.handleFadedOut
         });
      }
      
      protected function handleFadedOut() : void
      {
         this.dispose();
      }
      
      public function dispose() : void
      {
         this._timer.stop();
         this._timer.removeEventListener(TimerEvent.TIMER,this.handleTimerEvent);
         if(this._displayObject)
         {
            this._displayObject.bitmapData.dispose();
            this._displayObject = null;
         }
      }
      
      protected function create() : void
      {
         this._rotationContainer = new Sprite();
         addChild(this._rotationContainer);
         this._displayObject = UISystem.getInstance().uiloader.getBitmap(this._libraryID,this._linkageID) as Bitmap;
         this._displayObject.alpha = 0;
         this._displayObject.x = -this._displayObject.width >> 1;
         this._displayObject.y = -this._displayObject.height >> 1;
         this._rotationContainer.addChild(this._displayObject);
         this._rotationContainer.y = 3 + (this._displayObject.width >> 1);
         this._rotationContainer.x = 3 + (this._displayObject.height >> 1);
         this._timer.addEventListener(TimerEvent.TIMER,this.handleTimerEvent);
      }
      
      private function handleTimerEvent(param1:TimerEvent) : void
      {
         this._rotationContainer.rotation += 4;
      }
   }
}

