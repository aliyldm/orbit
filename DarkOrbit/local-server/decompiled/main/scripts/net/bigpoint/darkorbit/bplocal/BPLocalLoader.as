package net.bigpoint.darkorbit.bplocal
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import net.bigpoint.eventstream.EventStreamClient;
   
   public class BPLocalLoader
   {
      
      private var returnvalues:Vector.<XML>;
      
      private var len:uint;
      
      private var callback:Function;
      
      private var callbackAdditionalParams:Array;
      
      public function BPLocalLoader()
      {
         super();
      }
      
      public function loaderMultipleURLs(param1:Vector.<BPLocalLoadVO>, param2:Function, param3:Array = null) : void
      {
         var _loc4_:BPlocalInternalLoader = null;
         this.callback = param2;
         this.callbackAdditionalParams = param3 || [];
         this.len = param1.length;
         this.returnvalues = new Vector.<XML>();
         var _loc5_:int = 0;
         while(_loc5_ < this.len)
         {
            _loc4_ = new BPlocalInternalLoader();
            _loc4_.addEventListener(Event.COMPLETE,this.handleFileLoaded);
            _loc4_.addEventListener(IOErrorEvent.IO_ERROR,this.onError);
            _loc4_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
            _loc4_.loadVO(param1[_loc5_]);
            _loc5_++;
         }
      }
      
      private function onSecurityError(param1:SecurityErrorEvent) : void
      {
         EventStreamClient.track("flash.debug BPLocalLoader onSecurityError " + param1.toString());
      }
      
      private function onError(param1:IOErrorEvent) : void
      {
         EventStreamClient.track("flash.debug BPLocalLoader onError " + param1.toString());
      }
      
      private function handleFileLoaded(param1:Event) : void
      {
         var _loc2_:BPlocalInternalLoader = param1.target as BPlocalInternalLoader;
         var _loc3_:XML = XML(_loc2_.data);
         _loc3_ = new XML("<root><category name=\'" + _loc2_.vo.category + "\'>" + _loc3_.children() + "</category></root>");
         this.returnvalues.push(_loc3_);
         _loc2_.removeEventListener(Event.COMPLETE,this.handleFileLoaded);
         _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
         _loc2_.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
         if(this.returnvalues.length == this.len)
         {
            this.callback.apply(this,[this.returnvalues].concat(this.callbackAdditionalParams));
            this.returnvalues = null;
            param1 = null;
            this.callback = null;
         }
      }
   }
}

import flash.net.URLLoader;
import flash.net.URLRequest;
import net.bigpoint.darkorbit.bplocal.BPLocalLoadVO;

class BPlocalInternalLoader extends URLLoader
{
   
   public var vo:BPLocalLoadVO;
   
   public function BPlocalInternalLoader()
   {
      super();
   }
   
   public function loadVO(param1:BPLocalLoadVO) : void
   {
      this.vo = param1;
      load(new URLRequest(param1.url));
   }
}
