package net.bigpoint.darkorbit.fui.components.text.input.validators
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.text.TextField;
   
   public class TextLengthInputValidator extends EventDispatcher implements IInputValidator
   {
      
      public static const EVENT_TEXT_IS_VALID:String = "event.isvalid";
      
      public static const EVENT_TEXT_TOO_SHORT:String = "event.shortName";
      
      public static const EVENT_TEXT_TOO_LONG:String = "event.long";
      
      protected var _instance:TextField;
      
      protected var _valid:Boolean = true;
      
      protected var _max:uint = 52;
      
      protected var _min:uint = 3;
      
      public function TextLengthInputValidator(param1:uint = 3, param2:uint = 52)
      {
         super();
         this._max = param2;
         this._min = param1;
      }
      
      public function isValid() : Boolean
      {
         var _loc1_:Boolean = this.validate();
         if(_loc1_)
         {
            dispatchEvent(new Event(EVENT_TEXT_IS_VALID));
         }
         return _loc1_;
      }
      
      protected function validate() : Boolean
      {
         var _loc1_:uint = 0;
         this._valid = false;
         if(this._instance)
         {
            _loc1_ = uint(this._instance.text.length);
            if(_loc1_ >= this._min && _loc1_ <= this._max)
            {
               this._valid = true;
            }
            else
            {
               this._valid = false;
               if(_loc1_ < this._min)
               {
                  dispatchEvent(new Event(EVENT_TEXT_TOO_SHORT));
               }
               if(_loc1_ > this._max)
               {
                  dispatchEvent(new Event(EVENT_TEXT_TOO_LONG));
               }
            }
         }
         return this._valid;
      }
      
      public function set source(param1:Object) : void
      {
         this._instance = param1 as TextField;
      }
      
      public function get source() : Object
      {
         return null;
      }
      
      public function dispose() : void
      {
      }
   }
}

