package net.bigpoint.darkorbit.com.module.porting.pilotsheet
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class InternalPilotBioUpdateRequest implements IModule
   {
      
      private static var _instance:InternalPilotBioUpdateRequest;
      
      public var age:int = 0;
      
      public var interest:String = "";
      
      public var privacySettingsSkilltree:int = 0;
      
      public var privacySettingsUserInfo:int = 0;
      
      public var month:int = 0;
      
      public var city:String = "";
      
      public var privacySettingsMessages:int = 0;
      
      public var day:int = 0;
      
      public var country:String = "";
      
      public var userId:Number = 0;
      
      public var privacySettingsClan:int = 0;
      
      public var sex:String = "";
      
      public var privacySettingsEquipment:int = 0;
      
      public var year:int = 0;
      
      public var contact:String = "";
      
      public function InternalPilotBioUpdateRequest(param1:Number = 0, param2:String = "", param3:String = "", param4:int = 0, param5:int = 0, param6:int = 0, param7:int = 0, param8:String = "", param9:String = "", param10:String = "", param11:int = 0, param12:int = 0, param13:int = 0, param14:int = 0, param15:int = 0)
      {
         super();
         this.age = param7;
         this.interest = param9;
         this.privacySettingsSkilltree = param13;
         this.privacySettingsUserInfo = param11;
         this.month = param5;
         this.city = param3;
         this.privacySettingsMessages = param15;
         this.day = param4;
         this.country = param2;
         this.userId = param1;
         this.privacySettingsClan = param14;
         this.sex = param8;
         this.privacySettingsEquipment = param12;
         this.year = param6;
         this.contact = param10;
      }
      
      public static function get instance() : InternalPilotBioUpdateRequest
      {
         return _instance || (_instance = new InternalPilotBioUpdateRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 26511;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 34;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.age = param1.readInt();
         this.age = this.age >>> 10 % 32 | this.age << 32 - 10 % 32;
         this.interest = param1.readUTF();
         this.privacySettingsSkilltree = param1.readShort();
         this.privacySettingsUserInfo = param1.readShort();
         this.month = param1.readInt();
         this.month = this.month << 14 % 32 | this.month >>> 32 - 14 % 32;
         this.city = param1.readUTF();
         this.privacySettingsMessages = param1.readShort();
         this.day = param1.readInt();
         this.day = this.day >>> 15 % 32 | this.day << 32 - 15 % 32;
         this.country = param1.readUTF();
         this.userId = param1.readDouble();
         this.privacySettingsClan = param1.readShort();
         this.sex = param1.readUTF();
         this.privacySettingsEquipment = param1.readShort();
         this.year = param1.readInt();
         this.year = this.year >>> 7 % 32 | this.year << 32 - 7 % 32;
         this.contact = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(26511);
         param1.writeInt(this.age << 10 % 32 | this.age >>> 32 - 10 % 32);
         param1.writeUTF(this.interest);
         param1.writeShort(this.privacySettingsSkilltree);
         param1.writeShort(this.privacySettingsUserInfo);
         param1.writeInt(this.month >>> 14 % 32 | this.month << 32 - 14 % 32);
         param1.writeUTF(this.city);
         param1.writeShort(this.privacySettingsMessages);
         param1.writeInt(this.day << 15 % 32 | this.day >>> 32 - 15 % 32);
         param1.writeUTF(this.country);
         param1.writeDouble(this.userId);
         param1.writeShort(this.privacySettingsClan);
         param1.writeUTF(this.sex);
         param1.writeShort(this.privacySettingsEquipment);
         param1.writeInt(this.year << 7 % 32 | this.year >>> 32 - 7 % 32);
         param1.writeUTF(this.contact);
      }
   }
}

