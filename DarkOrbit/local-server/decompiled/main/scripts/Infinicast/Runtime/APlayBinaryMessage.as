package Infinicast.Runtime
{
   import Infinicast.Runtime.Network.Protocol.MessageReader;
   import Infinicast.Runtime.Network.Protocol.MessageWriter;
   import flash.utils.ByteArray;
   import flash.utils.getQualifiedClassName;
   
   public class APlayBinaryMessage
   {
      
      private var NULL_VALUE:int = -2147483648;
      
      private var writer:MessageWriter = null;
      
      private var reader:MessageReader = null;
      
      public function APlayBinaryMessage()
      {
         super();
      }
      
      private static function getObjectSize(param1:Object) : int
      {
         var _loc3_:String = null;
         var _loc2_:int = 0;
         for(_loc3_ in param1)
         {
            _loc2_++;
         }
         return _loc2_;
      }
      
      public function startWriting() : void
      {
         this.writer = new MessageWriter();
      }
      
      public function startReading(param1:ByteArray) : void
      {
         this.reader = new MessageReader(param1);
      }
      
      public function binarySize() : int
      {
         return this.getBinaryBytes().position;
      }
      
      public function getBinaryBytes() : ByteArray
      {
         if(this.writer != null)
         {
            return this.writer.asBytes();
         }
         return this.reader.asBytes();
      }
      
      public function readString() : String
      {
         var _loc1_:uint = uint(this.reader.read_int32());
         return this.reader.asBytes().readUTFBytes(_loc1_);
      }
      
      public function readJson() : Object
      {
         var _loc4_:String = null;
         var _loc1_:int = this.readInt();
         if(_loc1_ < 0)
         {
            return null;
         }
         var _loc2_:Object = {};
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc4_ = this.readString();
            _loc2_[_loc4_] = this.readTypeDecoded();
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function readTypeDecoded() : *
      {
         var _loc1_:APlayBinaryMessage = this;
         var _loc2_:int = _loc1_.readByte();
         var _loc3_:* = null;
         switch(_loc2_)
         {
            case 0:
               _loc3_ = null;
               break;
            case 1:
               _loc3_ = _loc1_.readBoolean();
               break;
            case 2:
               _loc3_ = _loc1_.readJArray();
               break;
            case 3:
               _loc3_ = _loc1_.readInt();
               break;
            case 4:
               _loc3_ = _loc1_.readJson();
               break;
            case 5:
               _loc3_ = _loc1_.readString();
               break;
            case 6:
               _loc3_ = _loc1_.readByte();
               break;
            case 7:
               _loc3_ = _loc1_.readLong();
               break;
            case 8:
               _loc3_ = _loc1_.readFloat();
               break;
            case 9:
               _loc3_ = _loc1_.readDouble();
         }
         return _loc3_;
      }
      
      public function writeTypeEncoded(param1:*) : void
      {
         var _loc2_:APlayBinaryMessage = this;
         if(param1 == null)
         {
            _loc2_.writeByte(0);
            return;
         }
         if(param1 is Boolean)
         {
            _loc2_.writeByte(1);
            _loc2_.writeBoolean(param1);
         }
         else if(param1 is Array || param1 is Vector || param1 is Object && getQualifiedClassName(param1).indexOf("vec::Vector.") != -1)
         {
            _loc2_.writeByte(2);
            _loc2_.writeJArray(param1);
         }
         else if(param1 is int || param1 is Number && getQualifiedClassName(param1) == "int")
         {
            _loc2_.writeByte(3);
            _loc2_.writeInt(param1);
         }
         else if(param1 is String)
         {
            _loc2_.writeByte(5);
            _loc2_.writeString(param1);
         }
         else if(param1 is Number)
         {
            _loc2_.writeByte(8);
            _loc2_.writeFloat(param1);
         }
         else
         {
            if(!(param1 is Object))
            {
               throw "unknown value .. " + param1 + " " + typeof param1;
            }
            _loc2_.writeByte(4);
            _loc2_.writeJson(param1);
         }
      }
      
      public function readByte() : int
      {
         return this.reader.read_int8();
      }
      
      public function readInt() : *
      {
         var _loc1_:* = this.reader.read_int32();
         if(_loc1_ == this.NULL_VALUE)
         {
            return null;
         }
         return _loc1_;
      }
      
      public function readLong() : *
      {
         var _loc1_:* = this.reader.read_int64();
         if(_loc1_ == this.NULL_VALUE)
         {
            return null;
         }
         return _loc1_;
      }
      
      public function readFloat() : *
      {
         var _loc1_:Number = this.reader.read_float32();
         if(_loc1_ == this.NULL_VALUE)
         {
            return null;
         }
         return _loc1_;
      }
      
      public function readDouble() : *
      {
         var _loc1_:Number = this.reader.read_float64();
         if(_loc1_ == this.NULL_VALUE)
         {
            return null;
         }
         return _loc1_;
      }
      
      public function readBoolean() : *
      {
         var _loc1_:int = this.reader.read_int8();
         if(_loc1_ == 0)
         {
            return null;
         }
         return _loc1_ == 2;
      }
      
      public function readJArray() : *
      {
         var _loc1_:int = this.readInt();
         if(_loc1_ < 0)
         {
            return null;
         }
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_.push(this.readTypeDecoded());
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function writeString(param1:String) : void
      {
         var _loc2_:ByteArray = null;
         if(param1 == null)
         {
            this.writer.write_int32(0);
         }
         else
         {
            _loc2_ = new ByteArray();
            _loc2_.writeUTFBytes(param1);
            _loc2_.position = 0;
            this.writer.write_int32(_loc2_.length);
            this.writer.asBytes().writeBytes(_loc2_,0,_loc2_.length);
         }
      }
      
      public function writeJson(param1:Object) : void
      {
         var _loc2_:String = null;
         if(param1 == null)
         {
            this.writeInt(-1);
         }
         else
         {
            this.writeInt(getObjectSize(param1));
            for(_loc2_ in param1)
            {
               this.writeString(_loc2_);
               this.writeTypeEncoded(param1[_loc2_]);
            }
         }
      }
      
      public function writeByte(param1:int) : void
      {
         this.writer.write_int8(param1);
      }
      
      public function writeInt(param1:*) : void
      {
         if(param1 == null)
         {
            this.writer.write_int32(this.NULL_VALUE);
         }
         else
         {
            this.writer.write_int32(param1);
         }
      }
      
      public function writeLong(param1:*) : void
      {
         if(param1 == null)
         {
            this.writer.write_int64(this.NULL_VALUE);
         }
         else
         {
            this.writer.write_int64(param1);
         }
      }
      
      public function writeFloat(param1:*) : void
      {
         if(param1 == null || param1 == undefined)
         {
            this.writer.write_float32(this.NULL_VALUE);
         }
         else
         {
            this.writer.write_float32(param1);
         }
      }
      
      public function writeBoolean(param1:*) : void
      {
         if(param1 == null || param1 == undefined)
         {
            this.writer.write_int8(0);
         }
         else
         {
            this.writer.write_int8(param1 ? 2 : 1);
         }
      }
      
      public function writeJArray(param1:*) : void
      {
         var _loc2_:int = 0;
         if(param1 == null)
         {
            this.writeInt(-1);
         }
         else
         {
            this.writeInt(param1.length);
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               this.writeTypeEncoded(param1[_loc2_]);
               _loc2_++;
            }
         }
      }
      
      public function readOptional() : Boolean
      {
         return this.readBoolean();
      }
      
      public function writeOptional(param1:*) : Boolean
      {
         var _loc2_:Boolean = param1 != null;
         this.writeBoolean(_loc2_);
         return _loc2_;
      }
   }
}

