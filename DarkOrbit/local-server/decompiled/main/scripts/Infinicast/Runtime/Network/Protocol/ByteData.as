package Infinicast.Runtime.Network.Protocol
{
   import flash.utils.ByteArray;
   
   public class ByteData
   {
      
      private var data:ByteArray;
      
      private var stringData:String;
      
      public function ByteData(param1:ByteArray)
      {
         super();
         this.data = param1;
         if(param1 != null)
         {
            param1.position = 0;
         }
      }
      
      public static function FromString(param1:String) : ByteData
      {
         var _loc2_:ByteData = new ByteData(null);
         _loc2_.stringData = param1;
         return _loc2_;
      }
      
      public static function FromWriter(param1:MessageWriter) : ByteData
      {
         return new ByteData(param1.asBytes());
      }
      
      public function getIndex() : int
      {
         if(this.data == null)
         {
            return 0;
         }
         return this.data.position;
      }
      
      public function getData() : ByteArray
      {
         return this.data;
      }
      
      public function getSize() : int
      {
         if(this.data == null)
         {
            return this.stringData.length;
         }
         return this.data.length;
      }
      
      public function setIndex(param1:int) : void
      {
         this.data.position = param1;
      }
      
      public function ToUtf8String() : String
      {
         if(this.stringData != null)
         {
            return this.stringData;
         }
         return this.data.toString();
      }
   }
}

