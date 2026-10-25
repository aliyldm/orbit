package net.bigpoint.darkorbit.utils
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   
   public class URLLoaderUtils
   {
      
      private static var _instance:URLLoaderUtils;
      
      private var _loader:URLLoader;
      
      private var _dict:Dictionary;
      
      public function URLLoaderUtils()
      {
         super();
         this._dict = new Dictionary();
      }
      
      public static function getInstance() : URLLoaderUtils
      {
         return _instance = _instance || new URLLoaderUtils();
      }
      
      public function load(param1:String, param2:Function) : void
      {
         var _loc3_:URLLoader = new URLLoader();
         this._dict[_loc3_] = param2;
         _loc3_.addEventListener(Event.COMPLETE,this.loadedHandle);
         _loc3_.addEventListener(IOErrorEvent.IO_ERROR,this.errorHandler);
         _loc3_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
         _loc3_.load(new URLRequest(param1));
      }
      
      public function loadedHandle(param1:Event) : void
      {
         var _loc2_:URLLoader = param1.target as URLLoader;
         var _loc3_:Function = this._dict[_loc2_];
         _loc3_(_loc2_.data);
         this.cleanupLoader(_loc2_);
      }
      
      private function cleanupLoader(param1:URLLoader) : void
      {
         param1.removeEventListener(Event.COMPLETE,this.loadedHandle);
         param1.removeEventListener(IOErrorEvent.IO_ERROR,this.errorHandler);
         param1.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
         delete this._dict[param1];
         param1.close();
         param1 = null;
      }
      
      private function errorHandler(param1:IOErrorEvent) : void
      {
         this.cleanupLoader(param1.target as URLLoader);
      }
      
      private function securityErrorHandler(param1:SecurityErrorEvent) : void
      {
         this.cleanupLoader(param1.target as URLLoader);
      }
   }
}

