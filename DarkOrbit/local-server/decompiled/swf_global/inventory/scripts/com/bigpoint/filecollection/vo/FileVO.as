package com.bigpoint.filecollection.vo
{
   public class FileVO
   {
      
      public var id:String;
      
      public var location:LocationVO;
      
      public var name:String;
      
      public var type:String;
      
      public var params:Object = {};
      
      public var numTries:int = 0;
      
      public var cdnHash:String;
      
      public var size:uint;
      
      public function FileVO(param1:String, param2:LocationVO, param3:String, param4:String, param5:String, param6:XML)
      {
         var _loc7_:XML = null;
         super();
         this.id = param1;
         this.location = param2;
         this.name = param3;
         this.type = param4;
         for each(_loc7_ in param6.param)
         {
            this.params[String(_loc7_.@name)] = String(_loc7_.@value);
         }
      }
      
      public function getFileName(param1:Boolean = false) : String
      {
         var _loc2_:String = this.location.path + this.name + "." + this.type;
         if(param1 && this.cdnHash != null)
         {
            _loc2_ += "?__cv=" + this.cdnHash;
         }
         return _loc2_;
      }
   }
}

