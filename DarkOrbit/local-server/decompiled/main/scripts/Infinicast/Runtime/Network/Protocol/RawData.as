package Infinicast.Runtime.Network.Protocol
{
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   
   public class RawData
   {
      
      public var EventId:*;
      
      public var FromServerId:Number;
      
      private var bytes_:ByteArray;
      
      public function RawData()
      {
         super();
         this.bytes_ = new ByteArray();
         this.bytes_.endian = Endian.LITTLE_ENDIAN;
      }
      
      public function copy(param1:ByteArray) : void
      {
         this.bytes_ = param1;
      }
      
      public function getSize() : uint
      {
         return this.bytes_.length;
      }
      
      public function getData() : ByteArray
      {
         return this.bytes_;
      }
   }
}

