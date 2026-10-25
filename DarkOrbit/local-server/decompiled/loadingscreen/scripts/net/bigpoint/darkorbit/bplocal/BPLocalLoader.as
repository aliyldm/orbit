package net.bigpoint.darkorbit.bplocal
{
   import flash.events.Event;
   
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
            _loc4_.loadVO(param1[_loc5_]);
            _loc5_++;
         }
      }
      
      private function handleFileLoaded(param1:Event) : void
      {
         var loader:BPlocalInternalLoader = null;
         var xml:XML = null;
         var evt:Event = param1;
         try
         {
            loader = evt.target as BPlocalInternalLoader;
            xml = XML(loader.data);
            xml = new XML("<root><category name=\'" + loader.vo.category + "\'>" + xml.children() + "</category></root>");
            this.returnvalues.push(xml);
            loader.removeEventListener(Event.COMPLETE,this.handleFileLoaded);
            if(this.returnvalues.length == this.len)
            {
               this.callback.apply(this,[this.returnvalues].concat(this.callbackAdditionalParams));
               this.returnvalues = null;
               evt = null;
               this.callback = null;
            }
         }
         catch(error:Error)
         {
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
