package net.bigpoint.darkorbit.net.netty
{
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   
   public final class DownstreamCompression
   {
      
      public static const CAPABILITY:String = "do-lz4-block-v3";
      
      public static const LEGACY_CAPABILITY_V1:String = "do-lz4-down-v1";
      
      public static const LEGACY_CAPABILITY_V2:String = "do-lz4-down-v2";
      
      public static const MAX_RAW_BYTES:int = 3 * 1024 * 1024;
      
      private static const HEADER_BYTES:int = 14;
      
      private static const LEGACY_MAGIC:uint = 1146047540;
      
      private static const BLOCK_MAGIC:uint = 1146044979;
      
      private static const CRC_TABLE:Vector.<uint> = buildCrcTable();
      
      public function DownstreamCompression()
      {
         super();
      }
      
      public static function isCompressionCapability(param1:String) : Boolean
      {
         return param1 == CAPABILITY || param1 == LEGACY_CAPABILITY_V1 || param1 == LEGACY_CAPABILITY_V2;
      }
      
      public static function decodeCursor(param1:ByteArray, param2:Boolean) : DownstreamFrameCursor
      {
         var _loc7_:ByteArray = null;
         var _loc8_:int = 0;
         if(param1.length < 2)
         {
            throw invalid();
         }
         if(param1[0] != 255 || param1[1] != 255)
         {
            return new DownstreamFrameCursor(param1,new <int>[0,param1.length]);
         }
         if(param1.length < 6)
         {
            throw invalid();
         }
         var _loc3_:uint = readUInt(param1,2);
         if(_loc3_ == LEGACY_MAGIC)
         {
            if(!param2)
            {
               throw invalid();
            }
            _loc7_ = decodeEnvelope(param1,2);
            return new DownstreamFrameCursor(_loc7_,new <int>[0,_loc7_.length]);
         }
         if(_loc3_ != BLOCK_MAGIC || !param2)
         {
            throw invalid();
         }
         var _loc4_:ByteArray = decodeEnvelope(param1,5);
         var _loc5_:Vector.<int> = new Vector.<int>();
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_.length)
         {
            if(_loc4_.length - _loc6_ < 3)
            {
               throw invalid();
            }
            _loc8_ = int(_loc4_[_loc6_]) << 16 | int(_loc4_[_loc6_ + 1]) << 8 | int(_loc4_[_loc6_ + 2]);
            _loc6_ += 3;
            if(_loc8_ < 2 || _loc8_ > _loc4_.length - _loc6_)
            {
               throw invalid();
            }
            if(_loc4_[_loc6_] == 255 && _loc4_[_loc6_ + 1] == 255)
            {
               throw invalid();
            }
            _loc5_.push(_loc6_,_loc8_);
            _loc6_ += _loc8_;
         }
         if(_loc5_.length == 0)
         {
            throw invalid();
         }
         return new DownstreamFrameCursor(_loc4_,_loc5_);
      }
      
      private static function decodeEnvelope(param1:ByteArray, param2:int) : ByteArray
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         if(param1.length <= HEADER_BYTES)
         {
            throw invalid();
         }
         var _loc3_:uint = readUInt(param1,6);
         if(_loc3_ < param2 || _loc3_ > MAX_RAW_BYTES || _loc3_ > (param1.length - HEADER_BYTES) * 64)
         {
            throw invalid();
         }
         var _loc4_:ByteArray = new ByteArray();
         _loc4_.length = _loc3_;
         param1.position = HEADER_BYTES;
         var _loc5_:int = 0;
         while(param1.bytesAvailable > 0)
         {
            _loc6_ = int(param1.readUnsignedByte());
            _loc7_ = readLength(param1,_loc6_ >> 4);
            if(_loc7_ > param1.bytesAvailable || _loc7_ > _loc3_ - _loc5_)
            {
               throw invalid();
            }
            if(_loc7_ > 0)
            {
               param1.readBytes(_loc4_,_loc5_,_loc7_);
            }
            _loc5_ += _loc7_;
            if(param1.bytesAvailable == 0)
            {
               if((_loc6_ & 0x0F) != 0)
               {
                  throw invalid();
               }
               break;
            }
            if(param1.bytesAvailable < 2)
            {
               throw invalid();
            }
            _loc8_ = param1.readUnsignedByte() | param1.readUnsignedByte() << 8;
            if(_loc8_ == 0 || _loc8_ > _loc5_)
            {
               throw invalid();
            }
            _loc9_ = readLength(param1,_loc6_ & 0x0F) + 4;
            if(_loc9_ > _loc3_ - _loc5_)
            {
               throw invalid();
            }
            if(_loc9_ < 32)
            {
               _loc10_ = 0;
               while(_loc10_ < _loc9_)
               {
                  _loc4_[_loc5_] = _loc4_[_loc5_ - _loc8_];
                  _loc10_++;
                  _loc5_++;
               }
            }
            else
            {
               _loc11_ = _loc5_ - _loc8_;
               while(_loc9_ > 0)
               {
                  _loc12_ = Math.min(_loc9_,_loc5_ - _loc11_);
                  _loc4_.position = _loc5_;
                  _loc4_.writeBytes(_loc4_,_loc11_,_loc12_);
                  _loc5_ += _loc12_;
                  _loc9_ -= _loc12_;
               }
            }
         }
         if(_loc5_ != _loc3_ || checksum(_loc4_) != readUInt(param1,10))
         {
            throw invalid();
         }
         _loc4_.position = 0;
         return _loc4_;
      }
      
      private static function readLength(param1:ByteArray, param2:int) : int
      {
         var _loc3_:int = 0;
         if(param2 != 15)
         {
            return param2;
         }
         while(param1.bytesAvailable != 0)
         {
            _loc3_ = int(param1.readUnsignedByte());
            param2 += _loc3_;
            if(param2 > MAX_RAW_BYTES)
            {
               throw invalid();
            }
            if(_loc3_ != 255)
            {
               return param2;
            }
         }
         throw invalid();
      }
      
      private static function readUInt(param1:ByteArray, param2:int) : uint
      {
         return uint(param1[param2]) << 24 | uint(param1[param2 + 1]) << 16 | uint(param1[param2 + 2]) << 8 | uint(param1[param2 + 3]);
      }
      
      private static function checksum(param1:ByteArray) : uint
      {
         var bytes:ByteArray = param1;
         var crc:uint = 4294967295;
         var position:uint = bytes.position;
         var endian:String = bytes.endian;
         bytes.position = 0;
         bytes.endian = Endian.LITTLE_ENDIAN;
         try
         {
            while(bytes.bytesAvailable >= 4)
            {
               crc ^= bytes.readUnsignedInt();
               crc = uint(CRC_TABLE[768 + (crc & 0xFF)] ^ CRC_TABLE[512 + (crc >>> 8 & 0xFF)] ^ CRC_TABLE[256 + (crc >>> 16 & 0xFF)] ^ CRC_TABLE[crc >>> 24]);
            }
            while(bytes.bytesAvailable > 0)
            {
               crc = uint(crc >>> 8 ^ CRC_TABLE[(crc ^ bytes.readUnsignedByte()) & 0xFF]);
            }
         }
         finally
         {
            bytes.position = position;
            bytes.endian = endian;
         }
         return crc ^ 0xFFFFFFFF;
      }
      
      private static function buildCrcTable() : Vector.<uint>
      {
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         var _loc1_:Vector.<uint> = new Vector.<uint>(1024,true);
         var _loc2_:int = 0;
         while(_loc2_ < 256)
         {
            _loc4_ = uint(_loc2_);
            _loc5_ = 0;
            while(_loc5_ < 8)
            {
               _loc4_ = uint(_loc4_ >>> 1 ^ ((_loc4_ & 1) != 0 ? 3988292384 : 0));
               _loc5_++;
            }
            _loc1_[_loc2_] = _loc4_;
            _loc2_++;
         }
         var _loc3_:int = 1;
         while(_loc3_ < 4)
         {
            _loc2_ = 0;
            while(_loc2_ < 256)
            {
               _loc4_ = _loc1_[(_loc3_ - 1) * 256 + _loc2_];
               _loc1_[_loc3_ * 256 + _loc2_] = _loc4_ >>> 8 ^ _loc1_[_loc4_ & 0xFF];
               _loc2_++;
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      private static function invalid() : Error
      {
         return new Error("Invalid downstream compression envelope");
      }
   }
}

