package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ClanDiploReqInfoCommand implements IModule
   {
      
      private static var _instance:ClanDiploReqInfoCommand;
      
      public var clanName:String = "";
      
      public var insertDate:String = "";
      
      public var fromClanId:int = 0;
      
      public var toClanId:int = 0;
      
      public var desc:String = "";
      
      public var diploType:int = 0;
      
      public var cdrId:int = 0;
      
      public function ClanDiploReqInfoCommand(param1:int = 0, param2:String = "", param3:int = 0, param4:int = 0, param5:String = "", param6:String = "", param7:int = 0)
      {
         super();
         this.clanName = param2;
         this.insertDate = param6;
         this.fromClanId = param3;
         this.toClanId = param4;
         this.desc = param5;
         this.diploType = param7;
         this.cdrId = param1;
      }
      
      public static function get instance() : ClanDiploReqInfoCommand
      {
         return _instance || (_instance = new ClanDiploReqInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -22526;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 22;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.clanName = param1.readUTF();
         this.insertDate = param1.readUTF();
         this.fromClanId = param1.readInt();
         this.fromClanId = this.fromClanId >>> 13 % 32 | this.fromClanId << 32 - 13 % 32;
         this.toClanId = param1.readInt();
         this.toClanId = this.toClanId >>> 12 % 32 | this.toClanId << 32 - 12 % 32;
         this.desc = param1.readUTF();
         this.diploType = param1.readInt();
         this.diploType = this.diploType >>> 11 % 32 | this.diploType << 32 - 11 % 32;
         this.cdrId = param1.readInt();
         this.cdrId = this.cdrId >>> 4 % 32 | this.cdrId << 32 - 4 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-22526);
         param1.writeUTF(this.clanName);
         param1.writeUTF(this.insertDate);
         param1.writeInt(this.fromClanId << 13 % 32 | this.fromClanId >>> 32 - 13 % 32);
         param1.writeInt(this.toClanId << 12 % 32 | this.toClanId >>> 32 - 12 % 32);
         param1.writeUTF(this.desc);
         param1.writeInt(this.diploType << 11 % 32 | this.diploType >>> 32 - 11 % 32);
         param1.writeInt(this.cdrId << 4 % 32 | this.cdrId >>> 32 - 4 % 32);
      }
   }
}

