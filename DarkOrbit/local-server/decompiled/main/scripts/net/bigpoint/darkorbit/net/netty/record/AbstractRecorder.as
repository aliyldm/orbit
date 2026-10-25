package net.bigpoint.darkorbit.net.netty.record
{
   import flash.desktop.Clipboard;
   import flash.desktop.ClipboardFormats;
   import flash.events.EventDispatcher;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import flash.utils.describeType;
   import flash.utils.getQualifiedClassName;
   import net.bigpoint.com.module.IModule;
   
   public class AbstractRecorder extends EventDispatcher
   {
      
      public static const RECORD_ADDED:String = "RECORD_ADDED";
      
      private static var START_TMPSTMP:Number = new Date().valueOf();
      
      protected const records:Vector.<RecordVO> = new Vector.<RecordVO>();
      
      public function AbstractRecorder()
      {
         super();
      }
      
      public function clear() : void
      {
         this.records.length = 0;
      }
      
      public function getRecords() : Vector.<RecordVO>
      {
         return this.records;
      }
      
      public function handle(param1:KeyboardEvent) : void
      {
         if(param1.ctrlKey)
         {
            if(param1.altKey)
            {
               if(param1.keyCode == Keyboard.X)
               {
                  this.output();
                  this.clear();
               }
            }
         }
      }
      
      public function output() : void
      {
         var _loc1_:String = "";
         _loc1_ = this.createOutput(_loc1_);
         this.outputToLogger(_loc1_);
         this.outputToClipboard(_loc1_);
      }
      
      protected function createOutput(param1:String) : String
      {
         return null;
      }
      
      protected function outputToLogger(param1:String) : void
      {
      }
      
      protected function outputToClipboard(param1:String) : void
      {
         Clipboard.generalClipboard.clear();
         Clipboard.generalClipboard.clearData(ClipboardFormats.TEXT_FORMAT);
         Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT,param1);
      }
      
      protected function _record(param1:IModule, param2:RecordVO) : void
      {
         var _loc3_:String = this.getClazzName(param1);
         if(!this.isRecordable(_loc3_))
         {
            return;
         }
         param2.clazzname = _loc3_;
         param2.id = param1.getLibcomModuleId().toString();
         param2.timestamp = this.getTimeStamp();
         param2.milliseconds = this.getMS();
         param2.params = this.getParams(param1);
         this.records.push(param2);
         dispatchEvent(new RecordEvent(RECORD_ADDED,param2));
      }
      
      protected function isRecordable(param1:String) : Boolean
      {
         var _loc3_:String = null;
         var _loc2_:Array = this.blackFilterList;
         for each(_loc3_ in _loc2_)
         {
            if(param1 == _loc3_)
            {
               return false;
            }
         }
         return true;
      }
      
      protected function get blackFilterList() : Array
      {
         throw new Error("You have to implement the BlackFilterList method.");
      }
      
      protected function getClazzName(param1:Object) : String
      {
         var _loc2_:String = getQualifiedClassName(param1);
         var _loc3_:uint = _loc2_.lastIndexOf(":") + 1;
         return _loc2_.substring(_loc3_);
      }
      
      protected function getTimeStamp() : String
      {
         var _loc1_:Date = new Date();
         return _loc1_.valueOf().toString();
      }
      
      protected function getMS() : String
      {
         var _loc1_:Date = new Date();
         return (_loc1_.valueOf() - START_TMPSTMP).toString();
      }
      
      protected function getParams(param1:Object) : String
      {
         var _loc5_:XML = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc2_:String = "";
         var _loc3_:XML = describeType(param1);
         var _loc4_:XMLList = _loc3_.variable;
         for each(_loc5_ in _loc4_)
         {
            _loc6_ = _loc5_.@type;
            _loc7_ = "handle_" + _loc6_;
            if(this.hasOwnProperty(_loc7_))
            {
               _loc2_ += this[_loc7_](param1,_loc5_);
               _loc2_ += ",";
            }
         }
         if(_loc2_.length >= 2)
         {
            _loc2_ = _loc2_.substring(0,_loc2_.length - 1);
         }
         return _loc2_;
      }
      
      public function handle_int(param1:Object, param2:XML) : String
      {
         var _loc3_:String = param2.@name;
         var _loc4_:int = param1[_loc3_] as int;
         return _loc3_ + "=" + _loc4_;
      }
      
      public function handle_Boolean(param1:Object, param2:XML) : String
      {
         var _loc3_:String = param2.@name;
         var _loc4_:Boolean = param1[_loc3_] as Boolean;
         return _loc3_ + "=" + _loc4_;
      }
      
      public function handle_String(param1:Object, param2:XML) : String
      {
         var _loc3_:String = param2.@name;
         var _loc4_:String = param1[_loc3_] as String;
         return _loc3_ + "=\"" + _loc4_ + "\"";
      }
   }
}

