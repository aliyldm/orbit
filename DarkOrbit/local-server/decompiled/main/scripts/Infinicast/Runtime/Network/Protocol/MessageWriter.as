package Infinicast.Runtime.Network.Protocol
{
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   
   public class MessageWriter
   {
      
      public var EventId:*;
      
      public var FromServerId:Number;
      
      private var bytes_:ByteArray;
      
      public function MessageWriter()
      {
         super();
         this.reset();
      }
      
      public function writeMessageType(param1:uint) : void
      {
         this.write_uint8(param1);
      }
      
      public function writeMessageType2(param1:uint) : void
      {
         this.write_uint16(param1);
      }
      
      public function writeOptional(param1:Boolean) : void
      {
         this.write_boolean(param1);
      }
      
      public function writeListLength(param1:uint) : void
      {
         this.write_uint16(param1);
      }
      
      public function writeBigListLength(param1:int) : void
      {
         this.write_int32(param1);
      }
      
      public function writeProtocolVersion(param1:uint) : void
      {
         this.write_uint16(param1);
      }
      
      public function reset() : void
      {
         this.bytes_ = new ByteArray();
         this.bytes_.endian = Endian.BIG_ENDIAN;
      }
      
      public function write_boolean(param1:Boolean) : void
      {
         this.bytes_.writeBoolean(param1);
      }
      
      public function write_uint8(param1:uint) : void
      {
         this.bytes_.writeByte(param1 & 0xFF);
      }
      
      public function write_uint16(param1:uint) : void
      {
         this.bytes_.writeShort(param1 & 0xFFFF);
      }
      
      public function write_uint32(param1:uint) : void
      {
         this.bytes_.writeUnsignedInt(param1);
      }
      
      public function write_uint64(param1:Number) : void
      {
         this.write_float64(param1);
      }
      
      public function write_int8(param1:int) : void
      {
         this.bytes_.writeByte(param1);
      }
      
      public function write_int16(param1:int) : void
      {
         this.bytes_.writeShort(param1);
      }
      
      public function write_int32(param1:int) : void
      {
         this.bytes_.writeInt(param1);
      }
      
      public function write_int64(param1:Number) : void
      {
         var _loc2_:Number = Math.floor(param1 / 4294967296);
         var _loc3_:Number = param1 - _loc2_ * 4294967296;
         this.write_int32(int(_loc2_));
         this.write_uint32(uint(_loc3_));
      }
      
      public function write_float32(param1:Number) : void
      {
         this.bytes_.writeFloat(param1);
      }
      
      public function write_float64(param1:Number) : void
      {
         this.bytes_.writeDouble(param1);
      }
      
      public function write_Enum(param1:int) : void
      {
         this.write_int16(param1);
      }
      
      public function write_Stream(param1:MessageWriter) : void
      {
         this.bytes_.writeBytes(param1.asBytes(),0,param1.asBytes().length);
      }
      
      public function write_bytes(param1:ByteArray) : void
      {
         this.bytes_.writeBytes(param1,0,param1.length);
      }
      
      public function write_String(param1:String) : void
      {
         var _loc2_:ByteArray = null;
         if(param1 == "")
         {
            this.writeBigListLength(0);
         }
         else
         {
            _loc2_ = new ByteArray();
            _loc2_.writeUTFBytes(param1);
            _loc2_.position = 0;
            this.writeBigListLength(_loc2_.length);
            this.bytes_.writeBytes(_loc2_,0,_loc2_.length);
         }
      }
      
      public function write_WString(param1:String) : void
      {
         this.write_String(param1);
      }
      
      public function write_RawData(param1:RawData) : void
      {
         this.write_int32(param1.getSize());
         if(param1.getSize() > 0)
         {
            this.bytes_.writeBytes(param1.getData(),0,param1.getSize());
         }
      }
      
      public function asRawData() : RawData
      {
         var _loc1_:RawData = new RawData();
         this.bytes_.position = 0;
         _loc1_.copy(this.bytes_);
         return _loc1_;
      }
      
      public function asBytes() : ByteArray
      {
         return this.bytes_;
      }
      
      public function asReader() : MessageReader
      {
         this.bytes_.position = 0;
         return new MessageReader(this.bytes_);
      }
   }
}

