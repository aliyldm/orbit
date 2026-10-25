package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ClanMessageInfoCommand implements IModule
   {
      
      private static var _instance:ClanMessageInfoCommand;
      
      public var insertDate:String = "";
      
      public var subject:String = "";
      
      public var mailText:String = "";
      
      public var type:int = 0;
      
      public var sendUserId:int = 0;
      
      public var textIncName:String = "";
      
      public var subjectIncName:String = "";
      
      public var sendUserName:String = "";
      
      public var messageId:int = 0;
      
      public var textParams:String = "";
      
      public var subjectParams:String = "";
      
      public function ClanMessageInfoCommand(param1:int = 0, param2:String = "", param3:String = "", param4:String = "", param5:String = "", param6:int = 0, param7:int = 0, param8:String = "", param9:String = "", param10:String = "", param11:String = "")
      {
         super();
         this.insertDate = param5;
         this.subject = param3;
         this.mailText = param4;
         this.type = param7;
         this.sendUserId = param1;
         this.textIncName = param10;
         this.subjectIncName = param8;
         this.sendUserName = param2;
         this.messageId = param6;
         this.textParams = param11;
         this.subjectParams = param9;
      }
      
      public static function get instance() : ClanMessageInfoCommand
      {
         return _instance || (_instance = new ClanMessageInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -15960;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 28;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.insertDate = param1.readUTF();
         this.subject = param1.readUTF();
         this.mailText = param1.readUTF();
         this.type = param1.readInt();
         this.type = this.type << 14 % 32 | this.type >>> 32 - 14 % 32;
         this.sendUserId = param1.readInt();
         this.sendUserId = this.sendUserId >>> 2 % 32 | this.sendUserId << 32 - 2 % 32;
         this.textIncName = param1.readUTF();
         this.subjectIncName = param1.readUTF();
         this.sendUserName = param1.readUTF();
         this.messageId = param1.readInt();
         this.messageId = this.messageId >>> 11 % 32 | this.messageId << 32 - 11 % 32;
         this.textParams = param1.readUTF();
         this.subjectParams = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-15960);
         param1.writeUTF(this.insertDate);
         param1.writeUTF(this.subject);
         param1.writeUTF(this.mailText);
         param1.writeInt(this.type >>> 14 % 32 | this.type << 32 - 14 % 32);
         param1.writeInt(this.sendUserId << 2 % 32 | this.sendUserId >>> 32 - 2 % 32);
         param1.writeUTF(this.textIncName);
         param1.writeUTF(this.subjectIncName);
         param1.writeUTF(this.sendUserName);
         param1.writeInt(this.messageId << 11 % 32 | this.messageId >>> 32 - 11 % 32);
         param1.writeUTF(this.textParams);
         param1.writeUTF(this.subjectParams);
      }
   }
}

