package net.bigpoint.darkorbit.com.module.porting.pilotsheet
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class InternalPilotBioUserProfileCommand implements IModule
   {
      
      private static var _instance:InternalPilotBioUserProfileCommand;
      
      public var statusMessage:String = "";
      
      public var result:Boolean = false;
      
      public var year:int = 0;
      
      public var clanMemberCount:int = 0;
      
      public var playTime:int = 0;
      
      public var interest:String = "";
      
      public var EntryDate:String = "";
      
      public var uniqueProfileUrl:String = "";
      
      public var rank:int = 0;
      
      public var profilePicBlock:int = 0;
      
      public var age:int = 0;
      
      public var day:int = 0;
      
      public var registrationDate:String = "";
      
      public var userId:int = 0;
      
      public var sex:String = "";
      
      public var privacySettingsEquipment:int = 0;
      
      public var profilePic:String = "";
      
      public var profilePicDate:String = "";
      
      public var privacySettingsClan:int = 0;
      
      public var city:String = "";
      
      public var contact:String = "";
      
      public var country:String = "";
      
      public var privacySettingsSkilltree:int = 0;
      
      public var ranking:int = 0;
      
      public var month:int = 0;
      
      public var privacySettingsMessages:int = 0;
      
      public var clanRank:int = 0;
      
      public var privacySettingsUserInfo:int = 0;
      
      public var userProfileId:int = 0;
      
      public var profileLikes:Vector.<int>;
      
      public var userName:String = "";
      
      public var clanName:String = "";
      
      public function InternalPilotBioUserProfileCommand(param1:Boolean = false, param2:int = 0, param3:int = 0, param4:String = "", param5:String = "", param6:String = "", param7:int = 0, param8:int = 0, param9:int = 0, param10:int = 0, param11:String = "", param12:String = "", param13:String = "", param14:String = "", param15:String = "", param16:String = "", param17:int = 0, param18:int = 0, param19:int = 0, param20:int = 0, param21:int = 0, param22:int = 0, param23:String = "", param24:Vector.<int> = null, param25:String = "", param26:String = "", param27:int = 0, param28:int = 0, param29:String = "", param30:int = 0, param31:int = 0, param32:int = 0)
      {
         super();
         this.statusMessage = param15;
         this.result = param1;
         this.year = param9;
         this.clanMemberCount = param27;
         this.playTime = param32;
         this.interest = param14;
         this.EntryDate = param29;
         this.uniqueProfileUrl = param23;
         this.rank = param30;
         this.profilePicBlock = param17;
         this.age = param10;
         this.day = param7;
         this.registrationDate = param25;
         this.userId = param3;
         this.sex = param11;
         this.privacySettingsEquipment = param19;
         this.profilePic = param12;
         this.profilePicDate = param13;
         this.privacySettingsClan = param21;
         this.city = param6;
         this.contact = param16;
         this.country = param5;
         this.privacySettingsSkilltree = param20;
         this.ranking = param31;
         this.month = param8;
         this.privacySettingsMessages = param22;
         this.clanRank = param28;
         this.privacySettingsUserInfo = param18;
         this.userProfileId = param2;
         if(param24 == null)
         {
            this.profileLikes = new Vector.<int>();
         }
         else
         {
            this.profileLikes = param24;
         }
         this.userName = param4;
         this.clanName = param26;
      }
      
      public static function get instance() : InternalPilotBioUserProfileCommand
      {
         return _instance || (_instance = new InternalPilotBioUserProfileCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 27237;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 79;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:int = 0;
         this.statusMessage = param1.readUTF();
         this.result = param1.readBoolean();
         this.year = param1.readInt();
         this.year = this.year >>> 9 % 32 | this.year << 32 - 9 % 32;
         this.clanMemberCount = param1.readInt();
         this.clanMemberCount = this.clanMemberCount >>> 5 % 32 | this.clanMemberCount << 32 - 5 % 32;
         this.playTime = param1.readInt();
         this.playTime = this.playTime << 11 % 32 | this.playTime >>> 32 - 11 % 32;
         this.interest = param1.readUTF();
         this.EntryDate = param1.readUTF();
         this.uniqueProfileUrl = param1.readUTF();
         this.rank = param1.readInt();
         this.rank = this.rank >>> 13 % 32 | this.rank << 32 - 13 % 32;
         this.profilePicBlock = param1.readInt();
         this.profilePicBlock = this.profilePicBlock << 11 % 32 | this.profilePicBlock >>> 32 - 11 % 32;
         this.age = param1.readInt();
         this.age = this.age << 11 % 32 | this.age >>> 32 - 11 % 32;
         this.day = param1.readInt();
         this.day = this.day << 7 % 32 | this.day >>> 32 - 7 % 32;
         this.registrationDate = param1.readUTF();
         this.userId = param1.readInt();
         this.userId = this.userId >>> 4 % 32 | this.userId << 32 - 4 % 32;
         this.sex = param1.readUTF();
         this.privacySettingsEquipment = param1.readShort();
         this.profilePic = param1.readUTF();
         this.profilePicDate = param1.readUTF();
         this.privacySettingsClan = param1.readShort();
         this.city = param1.readUTF();
         this.contact = param1.readUTF();
         this.country = param1.readUTF();
         this.privacySettingsSkilltree = param1.readShort();
         this.ranking = param1.readInt();
         this.ranking = this.ranking >>> 1 % 32 | this.ranking << 32 - 1 % 32;
         this.month = param1.readInt();
         this.month = this.month >>> 16 % 32 | this.month << 32 - 16 % 32;
         this.privacySettingsMessages = param1.readShort();
         this.clanRank = param1.readInt();
         this.clanRank = this.clanRank >>> 5 % 32 | this.clanRank << 32 - 5 % 32;
         this.privacySettingsUserInfo = param1.readShort();
         this.userProfileId = param1.readInt();
         this.userProfileId = this.userProfileId << 6 % 32 | this.userProfileId >>> 32 - 6 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.profileLikes.length > 0)
         {
            this.profileLikes.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ >>> 14 % 32 | _loc4_ << 32 - 14 % 32;
            this.profileLikes.push(_loc4_);
            _loc2_++;
         }
         this.userName = param1.readUTF();
         this.clanName = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:int = 0;
         param1.writeShort(27237);
         param1.writeUTF(this.statusMessage);
         param1.writeBoolean(this.result);
         param1.writeInt(this.year << 9 % 32 | this.year >>> 32 - 9 % 32);
         param1.writeInt(this.clanMemberCount << 5 % 32 | this.clanMemberCount >>> 32 - 5 % 32);
         param1.writeInt(this.playTime >>> 11 % 32 | this.playTime << 32 - 11 % 32);
         param1.writeUTF(this.interest);
         param1.writeUTF(this.EntryDate);
         param1.writeUTF(this.uniqueProfileUrl);
         param1.writeInt(this.rank << 13 % 32 | this.rank >>> 32 - 13 % 32);
         param1.writeInt(this.profilePicBlock >>> 11 % 32 | this.profilePicBlock << 32 - 11 % 32);
         param1.writeInt(this.age >>> 11 % 32 | this.age << 32 - 11 % 32);
         param1.writeInt(this.day >>> 7 % 32 | this.day << 32 - 7 % 32);
         param1.writeUTF(this.registrationDate);
         param1.writeInt(this.userId << 4 % 32 | this.userId >>> 32 - 4 % 32);
         param1.writeUTF(this.sex);
         param1.writeShort(this.privacySettingsEquipment);
         param1.writeUTF(this.profilePic);
         param1.writeUTF(this.profilePicDate);
         param1.writeShort(this.privacySettingsClan);
         param1.writeUTF(this.city);
         param1.writeUTF(this.contact);
         param1.writeUTF(this.country);
         param1.writeShort(this.privacySettingsSkilltree);
         param1.writeInt(this.ranking << 1 % 32 | this.ranking >>> 32 - 1 % 32);
         param1.writeInt(this.month << 16 % 32 | this.month >>> 32 - 16 % 32);
         param1.writeShort(this.privacySettingsMessages);
         param1.writeInt(this.clanRank << 5 % 32 | this.clanRank >>> 32 - 5 % 32);
         param1.writeShort(this.privacySettingsUserInfo);
         param1.writeInt(this.userProfileId >>> 6 % 32 | this.userProfileId << 32 - 6 % 32);
         param1.writeByte(this.profileLikes.length);
         for each(_loc2_ in this.profileLikes)
         {
            param1.writeInt(_loc2_ << 14 % 32 | _loc2_ >>> 32 - 14 % 32);
         }
         param1.writeUTF(this.userName);
         param1.writeUTF(this.clanName);
      }
   }
}

