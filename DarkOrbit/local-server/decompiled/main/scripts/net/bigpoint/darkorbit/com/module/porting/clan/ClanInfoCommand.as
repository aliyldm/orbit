package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ClanInfoCommand implements IModule
   {
      
      private static var _instance:ClanInfoCommand;
      
      public var recruitionInfo:int = 0;
      
      public var taxRate:int = 0;
      
      public var clanId:int = 0;
      
      public var recruitionStatus:int = 0;
      
      public var clanCredits:Number = 0;
      
      public var teamspeakAdd:String = "";
      
      public var clanLeaderName:String = "";
      
      public var clanName:String = "";
      
      public var clanRank:int = 0;
      
      public var clanIcon:String = "";
      
      public var clanLeaderId:int = 0;
      
      public var memberCount:int = 0;
      
      public var clanTag:String = "";
      
      public var clanDesc:String = "";
      
      public var company:int = 0;
      
      public var insertDate:String = "";
      
      public var ranking:int = 0;
      
      public function ClanInfoCommand(param1:int = 0, param2:String = "", param3:String = "", param4:String = "", param5:String = "", param6:String = "", param7:int = 0, param8:int = 0, param9:int = 0, param10:int = 0, param11:String = "", param12:int = 0, param13:int = 0, param14:String = "", param15:int = 0, param16:Number = 0, param17:int = 0)
      {
         super();
         this.recruitionInfo = param13;
         this.taxRate = param10;
         this.clanId = param1;
         this.recruitionStatus = param12;
         this.clanCredits = param16;
         this.teamspeakAdd = param11;
         this.clanLeaderName = param6;
         this.clanName = param2;
         this.clanRank = param8;
         this.clanIcon = param4;
         this.clanLeaderId = param15;
         this.memberCount = param7;
         this.clanTag = param3;
         this.clanDesc = param14;
         this.company = param9;
         this.insertDate = param5;
         this.ranking = param17;
      }
      
      public static function get instance() : ClanInfoCommand
      {
         return _instance || (_instance = new ClanInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -11820;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 58;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.recruitionInfo = param1.readInt();
         this.recruitionInfo = this.recruitionInfo << 4 % 32 | this.recruitionInfo >>> 32 - 4 % 32;
         this.taxRate = param1.readInt();
         this.taxRate = this.taxRate >>> 14 % 32 | this.taxRate << 32 - 14 % 32;
         this.clanId = param1.readInt();
         this.clanId = this.clanId >>> 3 % 32 | this.clanId << 32 - 3 % 32;
         this.recruitionStatus = param1.readInt();
         this.recruitionStatus = this.recruitionStatus >>> 13 % 32 | this.recruitionStatus << 32 - 13 % 32;
         this.clanCredits = param1.readDouble();
         this.teamspeakAdd = param1.readUTF();
         this.clanLeaderName = param1.readUTF();
         this.clanName = param1.readUTF();
         this.clanRank = param1.readInt();
         this.clanRank = this.clanRank << 16 % 32 | this.clanRank >>> 32 - 16 % 32;
         this.clanIcon = param1.readUTF();
         this.clanLeaderId = param1.readInt();
         this.clanLeaderId = this.clanLeaderId << 15 % 32 | this.clanLeaderId >>> 32 - 15 % 32;
         this.memberCount = param1.readInt();
         this.memberCount = this.memberCount >>> 16 % 32 | this.memberCount << 32 - 16 % 32;
         this.clanTag = param1.readUTF();
         this.clanDesc = param1.readUTF();
         this.company = param1.readInt();
         this.company = this.company << 15 % 32 | this.company >>> 32 - 15 % 32;
         this.insertDate = param1.readUTF();
         this.ranking = param1.readInt();
         this.ranking = this.ranking >>> 11 % 32 | this.ranking << 32 - 11 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-11820);
         param1.writeInt(this.recruitionInfo >>> 4 % 32 | this.recruitionInfo << 32 - 4 % 32);
         param1.writeInt(this.taxRate << 14 % 32 | this.taxRate >>> 32 - 14 % 32);
         param1.writeInt(this.clanId << 3 % 32 | this.clanId >>> 32 - 3 % 32);
         param1.writeInt(this.recruitionStatus << 13 % 32 | this.recruitionStatus >>> 32 - 13 % 32);
         param1.writeDouble(this.clanCredits);
         param1.writeUTF(this.teamspeakAdd);
         param1.writeUTF(this.clanLeaderName);
         param1.writeUTF(this.clanName);
         param1.writeInt(this.clanRank >>> 16 % 32 | this.clanRank << 32 - 16 % 32);
         param1.writeUTF(this.clanIcon);
         param1.writeInt(this.clanLeaderId >>> 15 % 32 | this.clanLeaderId << 32 - 15 % 32);
         param1.writeInt(this.memberCount << 16 % 32 | this.memberCount >>> 32 - 16 % 32);
         param1.writeUTF(this.clanTag);
         param1.writeUTF(this.clanDesc);
         param1.writeInt(this.company >>> 15 % 32 | this.company << 32 - 15 % 32);
         param1.writeUTF(this.insertDate);
         param1.writeInt(this.ranking << 11 % 32 | this.ranking >>> 32 - 11 % 32);
      }
   }
}

