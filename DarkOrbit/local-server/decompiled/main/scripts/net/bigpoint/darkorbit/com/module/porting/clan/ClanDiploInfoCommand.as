package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ClanDiploInfoCommand implements IModule
   {
      
      private static var _instance:ClanDiploInfoCommand;
      
      public var fromClanId:int = 0;
      
      public var clanName:String = "";
      
      public var desc:String = "";
      
      public var daysLeft:int = 0;
      
      public var insertDate:String = "";
      
      public var cdiId:int = 0;
      
      public var diploType:int = 0;
      
      public function ClanDiploInfoCommand(param1:int = 0, param2:String = "", param3:int = 0, param4:String = "", param5:String = "", param6:int = 0, param7:int = 0)
      {
         super();
         this.fromClanId = param3;
         this.clanName = param2;
         this.desc = param4;
         this.daysLeft = param7;
         this.insertDate = param5;
         this.cdiId = param1;
         this.diploType = param6;
      }
      
      public static function get instance() : ClanDiploInfoCommand
      {
         return _instance || (_instance = new ClanDiploInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 7652;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 22;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.fromClanId = param1.readInt();
         this.fromClanId = this.fromClanId >>> 1 % 32 | this.fromClanId << 32 - 1 % 32;
         this.clanName = param1.readUTF();
         this.desc = param1.readUTF();
         this.daysLeft = param1.readInt();
         this.daysLeft = this.daysLeft << 12 % 32 | this.daysLeft >>> 32 - 12 % 32;
         this.insertDate = param1.readUTF();
         this.cdiId = param1.readInt();
         this.cdiId = this.cdiId >>> 2 % 32 | this.cdiId << 32 - 2 % 32;
         this.diploType = param1.readInt();
         this.diploType = this.diploType << 2 % 32 | this.diploType >>> 32 - 2 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(7652);
         param1.writeInt(this.fromClanId << 1 % 32 | this.fromClanId >>> 32 - 1 % 32);
         param1.writeUTF(this.clanName);
         param1.writeUTF(this.desc);
         param1.writeInt(this.daysLeft >>> 12 % 32 | this.daysLeft << 32 - 12 % 32);
         param1.writeUTF(this.insertDate);
         param1.writeInt(this.cdiId << 2 % 32 | this.cdiId >>> 32 - 2 % 32);
         param1.writeInt(this.diploType >>> 2 % 32 | this.diploType << 32 - 2 % 32);
      }
   }
}

