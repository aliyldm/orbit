package net.bigpoint.darkorbit.fui.components.text.label
{
   import flash.events.Event;
   
   public class LabelSkinEvent extends Event
   {
      
      public static const SKIN_HEIGHT_CHANGED:String = "heightChanged";
      
      private var _value:Number;
      
      public function LabelSkinEvent(param1:String, param2:Number)
      {
         super(param1,false,false);
         this._value = param2;
      }
      
      public function get value() : Number
      {
         return this._value;
      }
   }
}

