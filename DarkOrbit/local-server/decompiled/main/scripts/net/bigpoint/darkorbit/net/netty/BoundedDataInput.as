package net.bigpoint.darkorbit.net.netty
{
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   internal final class BoundedDataInput implements IDataInput
   {
      
      private var _bytes:ByteArray;
      
      private var _end:uint;
      
      public function BoundedDataInput()
      {
         super();
      }
      
      private static function rangeError() : RangeError
      {
         return new RangeError("Logical downstream frame boundary exceeded");
      }
      
      internal function reset(param1:ByteArray, param2:uint, param3:uint) : void
      {
         this._bytes = param1;
         this._end = param3;
         this._bytes.position = param2;
      }
      
      public function get bytesAvailable() : uint
      {
         return this._end - this._bytes.position;
      }
      
      public function get endian() : String
      {
         return this._bytes.endian;
      }
      
      public function set endian(param1:String) : void
      {
         this._bytes.endian = param1;
      }
      
      public function get objectEncoding() : uint
      {
         return this._bytes.objectEncoding;
      }
      
      public function set objectEncoding(param1:uint) : void
      {
         this._bytes.objectEncoding = param1;
      }
      
      public function readBoolean() : Boolean
      {
         this.require(1);
         return this._bytes.readBoolean();
      }
      
      public function readByte() : int
      {
         this.require(1);
         return this._bytes.readByte();
      }
      
      public function readUnsignedByte() : uint
      {
         this.require(1);
         return this._bytes.readUnsignedByte();
      }
      
      public function readShort() : int
      {
         this.require(2);
         return this._bytes.readShort();
      }
      
      public function readUnsignedShort() : uint
      {
         this.require(2);
         return this._bytes.readUnsignedShort();
      }
      
      public function readInt() : int
      {
         this.require(4);
         return this._bytes.readInt();
      }
      
      public function readUnsignedInt() : uint
      {
         this.require(4);
         return this._bytes.readUnsignedInt();
      }
      
      public function readFloat() : Number
      {
         this.require(4);
         return this._bytes.readFloat();
      }
      
      public function readDouble() : Number
      {
         this.require(8);
         return this._bytes.readDouble();
      }
      
      public function readBytes(param1:ByteArray, param2:uint = 0, param3:uint = 0) : void
      {
         if(param3 == 0)
         {
            param3 = this.bytesAvailable;
         }
         this.require(param3);
         if(param3 == 0)
         {
            return;
         }
         this._bytes.readBytes(param1,param2,param3);
      }
      
      public function readMultiByte(param1:uint, param2:String) : String
      {
         this.require(param1);
         return this._bytes.readMultiByte(param1,param2);
      }
      
      public function readUTFBytes(param1:uint) : String
      {
         this.require(param1);
         return this._bytes.readUTFBytes(param1);
      }
      
      public function readUTF() : String
      {
         this.require(2);
         var _loc1_:uint = this._bytes.position;
         var _loc2_:uint = this._bytes.readUnsignedShort();
         this._bytes.position = _loc1_;
         this.require(2 + _loc2_);
         return this._bytes.readUTF();
      }
      
      public function readObject() : *
      {
         var _loc1_:* = this._bytes.readObject();
         if(this._bytes.position > this._end)
         {
            throw rangeError();
         }
         return _loc1_;
      }
      
      private function require(param1:uint) : void
      {
         if(param1 > this.bytesAvailable)
         {
            throw rangeError();
         }
      }
   }
}

