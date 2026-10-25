package away3d.events
{
   import flash.events.Event;
   
   public class LoaderEvent extends Event
   {
      
      public static const LOAD_ERROR:String = "loadError";
      
      public static const RESOURCE_COMPLETE:String = "resourceComplete";
      
      public static const DEPENDENCY_COMPLETE:String = "dependencyComplete";
      
      private var _url:String;
      
      private var _message:String;
      
      private var _isDependency:Boolean;
      
      private var _isDefaultPrevented:Boolean;
      
      public function LoaderEvent(param1:String, param2:String = null, param3:Boolean = false, param4:String = null)
      {
         super(param1);
         this._url = param2;
         this._message = param4;
         this._isDependency = param3;
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      public function get message() : String
      {
         return this._message;
      }
      
      public function get isDependency() : Boolean
      {
         return this._isDependency;
      }
      
      override public function preventDefault() : void
      {
         this._isDefaultPrevented = true;
      }
      
      override public function isDefaultPrevented() : Boolean
      {
         return this._isDefaultPrevented;
      }
      
      override public function clone() : Event
      {
         return new LoaderEvent(type,this._url,this._isDependency,this._message);
      }
   }
}

