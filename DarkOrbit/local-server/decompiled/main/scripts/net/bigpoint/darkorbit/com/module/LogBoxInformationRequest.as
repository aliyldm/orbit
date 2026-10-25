package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LogBoxInformationRequest implements IModule
   {
      
      private static var _instance:LogBoxInformationRequest;
      
      public var length:int = 0;
      
      public var clipSize:String = "";
      
      public var quality:int = 0;
      
      public var endian:String = "";
      
      public var classId:int = 0;
      
      public var pixelColor:int = 0;
      
      public var adler32Checksum:int = 0;
      
      public var crc32Checksum:int = 0;
      
      public var typeId:int = 0;
      
      public function LogBoxInformationRequest(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0, param5:int = 0, param6:String = "", param7:int = 0, param8:String = "", param9:int = 0)
      {
         super();
         this.length = param9;
         this.clipSize = param6;
         this.quality = param7;
         this.endian = param8;
         this.classId = param1;
         this.pixelColor = param5;
         this.adler32Checksum = param4;
         this.crc32Checksum = param3;
         this.typeId = param2;
      }
      
      public static function get instance() : LogBoxInformationRequest
      {
         return _instance || (_instance = new LogBoxInformationRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 32545;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 32;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.length = param1.readInt();
         this.length = this.length << 8 % 32 | this.length >>> 32 - 8 % 32;
         this.clipSize = param1.readUTF();
         this.quality = param1.readInt();
         this.quality = this.quality << 15 % 32 | this.quality >>> 32 - 15 % 32;
         this.endian = param1.readUTF();
         this.classId = param1.readInt();
         this.classId = this.classId >>> 9 % 32 | this.classId << 32 - 9 % 32;
         this.pixelColor = param1.readInt();
         this.pixelColor = this.pixelColor >>> 10 % 32 | this.pixelColor << 32 - 10 % 32;
         this.adler32Checksum = param1.readInt();
         this.adler32Checksum = this.adler32Checksum >>> 15 % 32 | this.adler32Checksum << 32 - 15 % 32;
         this.crc32Checksum = param1.readInt();
         this.crc32Checksum = this.crc32Checksum << 16 % 32 | this.crc32Checksum >>> 32 - 16 % 32;
         this.typeId = param1.readInt();
         this.typeId = this.typeId >>> 5 % 32 | this.typeId << 32 - 5 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(32545);
         param1.writeInt(this.length >>> 8 % 32 | this.length << 32 - 8 % 32);
         param1.writeUTF(this.clipSize);
         param1.writeInt(this.quality >>> 15 % 32 | this.quality << 32 - 15 % 32);
         param1.writeUTF(this.endian);
         param1.writeInt(this.classId << 9 % 32 | this.classId >>> 32 - 9 % 32);
         param1.writeInt(this.pixelColor << 10 % 32 | this.pixelColor >>> 32 - 10 % 32);
         param1.writeInt(this.adler32Checksum << 15 % 32 | this.adler32Checksum >>> 32 - 15 % 32);
         param1.writeInt(this.crc32Checksum >>> 16 % 32 | this.crc32Checksum << 32 - 16 % 32);
         param1.writeInt(this.typeId << 5 % 32 | this.typeId >>> 32 - 5 % 32);
      }
   }
}

