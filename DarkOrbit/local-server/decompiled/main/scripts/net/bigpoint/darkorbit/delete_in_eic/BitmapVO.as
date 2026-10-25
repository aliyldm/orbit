package net.bigpoint.darkorbit.delete_in_eic
{
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class BitmapVO extends Event
   {
      
      public static const EVENT_COMPLETE:String = "net.bigpoint.darkorbit.delete_in_eic.event_complete";
      
      private var obj:*;
      
      private var url:String;
      
      public function BitmapVO(param1:String, param2:*)
      {
         super(EVENT_COMPLETE);
         this.obj = param2;
         this.url = param1;
      }
      
      public function getURL() : String
      {
         return this.url;
      }
      
      public function getBitmapData() : BitmapData
      {
         return this.obj as BitmapData;
      }
      
      public function getMovieClip() : MovieClip
      {
         return this.obj as MovieClip;
      }
   }
}

