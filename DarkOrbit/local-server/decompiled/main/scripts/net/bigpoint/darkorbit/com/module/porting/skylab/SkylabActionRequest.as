package net.bigpoint.darkorbit.com.module.porting.skylab
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SkylabActionRequest implements IModule
   {
      
      private static var _instance:SkylabActionRequest;
      
      public var countEndurium:int = 0;
      
      public var countPromerium:int = 0;
      
      public var countDuranium:int = 0;
      
      public var countSeprom:int = 0;
      
      public var construction:String = "";
      
      public var countTerbium:int = 0;
      
      public var countXenomit:int = 0;
      
      public var transportMode:String = "";
      
      public var subaction:String = "";
      
      public var countPrometid:int = 0;
      
      public var countPrometium:int = 0;
      
      public function SkylabActionRequest(param1:String = "", param2:String = "", param3:String = "", param4:int = 0, param5:int = 0, param6:int = 0, param7:int = 0, param8:int = 0, param9:int = 0, param10:int = 0, param11:int = 0)
      {
         super();
         this.countEndurium = param5;
         this.countPromerium = param10;
         this.countDuranium = param8;
         this.countSeprom = param11;
         this.construction = param2;
         this.countTerbium = param6;
         this.countXenomit = param9;
         this.transportMode = param3;
         this.subaction = param1;
         this.countPrometid = param7;
         this.countPrometium = param4;
      }
      
      public static function get instance() : SkylabActionRequest
      {
         return _instance || (_instance = new SkylabActionRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 26206;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 38;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.countEndurium = param1.readInt();
         this.countEndurium = this.countEndurium << 9 % 32 | this.countEndurium >>> 32 - 9 % 32;
         this.countPromerium = param1.readInt();
         this.countPromerium = this.countPromerium >>> 7 % 32 | this.countPromerium << 32 - 7 % 32;
         this.countDuranium = param1.readInt();
         this.countDuranium = this.countDuranium >>> 14 % 32 | this.countDuranium << 32 - 14 % 32;
         this.countSeprom = param1.readInt();
         this.countSeprom = this.countSeprom << 5 % 32 | this.countSeprom >>> 32 - 5 % 32;
         this.construction = param1.readUTF();
         this.countTerbium = param1.readInt();
         this.countTerbium = this.countTerbium >>> 11 % 32 | this.countTerbium << 32 - 11 % 32;
         this.countXenomit = param1.readInt();
         this.countXenomit = this.countXenomit >>> 6 % 32 | this.countXenomit << 32 - 6 % 32;
         this.transportMode = param1.readUTF();
         this.subaction = param1.readUTF();
         this.countPrometid = param1.readInt();
         this.countPrometid = this.countPrometid << 2 % 32 | this.countPrometid >>> 32 - 2 % 32;
         this.countPrometium = param1.readInt();
         this.countPrometium = this.countPrometium << 13 % 32 | this.countPrometium >>> 32 - 13 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(26206);
         param1.writeInt(this.countEndurium >>> 9 % 32 | this.countEndurium << 32 - 9 % 32);
         param1.writeInt(this.countPromerium << 7 % 32 | this.countPromerium >>> 32 - 7 % 32);
         param1.writeInt(this.countDuranium << 14 % 32 | this.countDuranium >>> 32 - 14 % 32);
         param1.writeInt(this.countSeprom >>> 5 % 32 | this.countSeprom << 32 - 5 % 32);
         param1.writeUTF(this.construction);
         param1.writeInt(this.countTerbium << 11 % 32 | this.countTerbium >>> 32 - 11 % 32);
         param1.writeInt(this.countXenomit << 6 % 32 | this.countXenomit >>> 32 - 6 % 32);
         param1.writeUTF(this.transportMode);
         param1.writeUTF(this.subaction);
         param1.writeInt(this.countPrometid >>> 2 % 32 | this.countPrometid << 32 - 2 % 32);
         param1.writeInt(this.countPrometium >>> 13 % 32 | this.countPrometium << 32 - 13 % 32);
      }
   }
}

