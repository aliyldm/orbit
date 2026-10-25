package away3d.events
{
   import flash.events.Event;
   
   public class ParserEvent extends Event
   {
      
      public static const PARSE_COMPLETE:String = "parseComplete";
      
      public static const PARSE_ERROR:String = "parseError";
      
      public static const READY_FOR_DEPENDENCIES:String = "readyForDependencies";
      
      private var _message:String;
      
      public function ParserEvent(param1:String, param2:String = "")
      {
         super(param1);
         this._message = param2;
      }
      
      public function get message() : String
      {
         return this._message;
      }
      
      override public function clone() : Event
      {
         return new ParserEvent(type,this.message);
      }
   }
}

