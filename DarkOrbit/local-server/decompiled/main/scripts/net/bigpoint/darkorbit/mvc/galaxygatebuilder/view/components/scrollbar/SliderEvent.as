package net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.components.scrollbar
{
   import flash.events.Event;
   
   public class SliderEvent extends Event
   {
      
      public static const CHANGE:String = "change";
      
      protected var percentage:Number;
      
      public function SliderEvent(param1:String, param2:Number)
      {
         super(param1);
         this.percentage = param2;
      }
      
      public function get percent() : Number
      {
         return this.percentage;
      }
   }
}

