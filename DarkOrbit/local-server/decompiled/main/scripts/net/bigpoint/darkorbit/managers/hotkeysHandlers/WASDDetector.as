package net.bigpoint.darkorbit.managers.hotkeysHandlers
{
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import flash.utils.getTimer;
   import net.bigpoint.darkorbit.managers.hotkeysHandlers.general.AbstractKeyboardEventHandler;
   import net.bigpoint.eventstream.EventStreamClient;
   
   public class WASDDetector extends AbstractKeyboardEventHandler
   {
      
      private static var _instance:WASDDetector;
      
      private var _timestampByKeyCode:Object = {};
      
      public function WASDDetector()
      {
         super();
      }
      
      public static function get instance() : WASDDetector
      {
         if(_instance == null)
         {
            _instance = new WASDDetector();
         }
         return _instance;
      }
      
      override public function handle(param1:KeyboardEvent) : void
      {
         switch(param1.keyCode)
         {
            case Keyboard.W:
            case Keyboard.A:
            case Keyboard.S:
            case Keyboard.D:
               this._timestampByKeyCode[param1.keyCode] = getTimer();
               if(int(this.checkKey(Keyboard.W)) + int(this.checkKey(Keyboard.A)) + int(this.checkKey(Keyboard.S)) + int(this.checkKey(Keyboard.D)) >= 2)
               {
                  EventStreamClient.track("wasd_attempt");
               }
         }
      }
      
      private function checkKey(param1:uint) : Boolean
      {
         return getTimer() - int(this._timestampByKeyCode[param1] || int.MIN_VALUE) < 3000;
      }
   }
}

