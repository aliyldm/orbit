package Infinicast.Runtime.Network.Protocol
{
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   
   public class MessageReader
   {
      
      private var bytes_:ByteArray;
      
      public function MessageReader(param1:ByteArray)
      {
         super();
         this.bytes_ = param1;
         this.bytes_.endian = Endian.BIG_ENDIAN;
      }
      
      public function getPosition() : uint
      {
         return this.bytes_.position;
      }
      
      public function setPosition(param1:uint) : void
      {
         this.bytes_.position = param1;
      }
      
      public function readMessageType() : uint
      {
         return this.read_uint8();
      }
      
      public function readMessageType2() : uint
      {
         return this.read_uint16();
      }
      
      public function readOptional() : Boolean
      {
         return this.read_boolean();
      }
      
      public function readListLength() : uint
      {
         return this.read_uint16();
      }
      
      public function readBigListLength() : int
      {
         return this.read_int32();
      }
      
      public function readProtocolVersion() : uint
      {
         return this.read_uint16();
      }
      
      public function read_boolean() : Boolean
      {
         return this.bytes_.readBoolean();
      }
      
      public function read_uint8() : uint
      {
         var _loc1_:int = this.bytes_.readByte();
         return _loc1_ & 0xFF;
      }
      
      public function read_uint16() : uint
      {
         var _loc1_:int = this.bytes_.readShort();
         return _loc1_ & 0xFFFF;
      }
      
      public function read_uint32() : uint
      {
         return this.bytes_.readUnsignedInt();
      }
      
      public function read_uint64() : Number
      {
         return this.read_float64();
      }
      
      public function read_int8() : int
      {
         return this.bytes_.readByte();
      }
      
      public function read_int16() : int
      {
         return this.bytes_.readShort();
      }
      
      public function read_int32() : int
      {
         return this.bytes_.readInt();
      }
      
      public function read_int64() : Number
      {
         var _loc1_:Number = this.bytes_.readInt();
         var _loc2_:Number = this.bytes_.readUnsignedInt();
         return _loc1_ * 4294967296 + _loc2_;
      }
      
      public function read_float32() : Number
      {
         return this.bytes_.readFloat();
      }
      
      public function read_float64() : Number
      {
         return this.bytes_.readDouble();
      }
      
      public function read_Enum() : uint
      {
         return this.read_int16();
      }
      
      public function read_SimpleDate() : Date
      {
         var _loc1_:Number = this.read_uint8();
         var _loc2_:Number = this.read_uint8() - 1;
         var _loc3_:Number = this.read_uint16();
         return new Date(Date.UTC(_loc3_,_loc2_,_loc1_));
      }
      
      public function read_Date() : Date
      {
         var _loc1_:Number = this.read_uint8();
         var _loc2_:Number = this.read_uint8() - 1;
         var _loc3_:Number = this.read_uint16();
         return new Date(Date.UTC(_loc3_,_loc2_,_loc1_,this.read_uint8(),this.read_uint8(),this.read_uint8(),this.read_uint16()));
      }
      
      public function read_String() : String
      {
         var _loc1_:uint = uint(this.readBigListLength());
         return this.bytes_.readUTFBytes(_loc1_);
      }
      
      public function getBytesAvailable() : Number
      {
         return this.bytes_.bytesAvailable;
      }
      
      public function asBytes() : ByteArray
      {
         return this.bytes_;
      }
      
      public function PrefixedDataAvailable() : Boolean
      {
         var _loc1_:uint = this.getPosition();
         var _loc2_:int = this.read_int32();
         this.setPosition(_loc1_);
         return _loc2_ <= this.bytes_.bytesAvailable;
      }
      
      public function read_RawData() : RawData
      {
         var _loc1_:int = this.read_int32();
         var _loc2_:RawData = new RawData();
         if(_loc1_ > 0)
         {
            this.bytes_.readBytes(_loc2_.getData(),0,_loc1_);
         }
         return _loc2_;
      }
      
      public function read_ByteArray() : ByteArray
      {
         var _loc2_:ByteArray = null;
         var _loc1_:int = this.read_int32();
         if(_loc1_ > 0)
         {
            _loc2_ = new ByteArray();
            this.bytes_.readBytes(_loc2_,0,_loc1_);
            return _loc2_;
         }
         return null;
      }
      
      public function asRawData() : Object
      {
         var _loc1_:RawData = new RawData();
         _loc1_.copy(this.bytes_);
         return _loc1_;
      }
   }
}

