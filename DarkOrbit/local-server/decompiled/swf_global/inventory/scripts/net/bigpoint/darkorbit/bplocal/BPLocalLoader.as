package net.bigpoint.darkorbit.bplocal
{
   import flash.events.Event;
   
   public class BPLocalLoader
   {
      
      private var returnvalues:Vector.<XML>;
      
      private var len:uint;
      
      private var callback:Function;
      
      public function BPLocalLoader()
      {
         super();
      }
      
      public function loaderMultipleURLs(param1:Vector.<BPLocalLoadVO>, param2:Function) : void
      {
         var _loc3_:BPlocalInternalLoader = null;
         this.callback = param2;
         this.len = param1.length;
         this.returnvalues = new Vector.<XML>();
         var _loc4_:int = 0;
         while(_loc4_ < this.len)
         {
            _loc3_ = new BPlocalInternalLoader();
            _loc3_.addEventListener(Event.COMPLETE,this.handleFileLoaded);
            _loc3_.loadVO(param1[_loc4_]);
            _loc4_++;
         }
      }
      
      private function handleFileLoaded(param1:Event) : void
      {
         var _loc2_:BPlocalInternalLoader = param1.target as BPlocalInternalLoader;
         var _loc3_:XML = XML(_loc2_.data);
         _loc3_ = new XML("<root><category name=\'" + _loc2_.vo.category + "\'>" + _loc3_.children() + "</category></root>");
         this.returnvalues.push(_loc3_);
         _loc2_.removeEventListener(Event.COMPLETE,this.handleFileLoaded);
         if(this.returnvalues.length == this.len)
         {
            this.callback(this.returnvalues);
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
