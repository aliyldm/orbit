package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UserMessageParentInfoCommand implements IModule
   {
      
      private static var _instance:UserMessageParentInfoCommand;
      
      public var senderName:String = "";
      
      public var senderId:int = 0;
      
      public var subjectInc:String = "";
      
      public var subjectParams:String = "";
      
      public var subject:String = "";
      
      public var body:String = "";
      
      public var bodyInc:String = "";
      
      public var versionType:int = 0;
      
      public var bodyParams:String = "";
      
      public function UserMessageParentInfoCommand(param1:int = 0, param2:String = "", param3:String = "", param4:String = "", param5:String = "", param6:String = "", param7:String = "", param8:String = "", param9:int = 0)
      {
         super();
         this.senderName = param2;
         this.senderId = param1;
         this.subjectInc = param6;
         this.subjectParams = param8;
         this.subject = param3;
         this.body = param4;
         this.bodyInc = param5;
         this.versionType = param9;
         this.bodyParams = param7;
      }
      
      public static function get instance() : UserMessageParentInfoCommand
      {
         return _instance || (_instance = new UserMessageParentInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 21619;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 22;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.senderName = param1.readUTF();
         this.senderId = param1.readInt();
         this.senderId = this.senderId >>> 12 % 32 | this.senderId << 32 - 12 % 32;
         this.subjectInc = param1.readUTF();
         this.subjectParams = param1.readUTF();
         this.subject = param1.readUTF();
         this.body = param1.readUTF();
         this.bodyInc = param1.readUTF();
         this.versionType = param1.readInt();
         this.versionType = this.versionType << 6 % 32 | this.versionType >>> 32 - 6 % 32;
         this.bodyParams = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(21619);
         param1.writeUTF(this.senderName);
         param1.writeInt(this.senderId << 12 % 32 | this.senderId >>> 32 - 12 % 32);
         param1.writeUTF(this.subjectInc);
         param1.writeUTF(this.subjectParams);
         param1.writeUTF(this.subject);
         param1.writeUTF(this.body);
         param1.writeUTF(this.bodyInc);
         param1.writeInt(this.versionType >>> 6 % 32 | this.versionType << 32 - 6 % 32);
         param1.writeUTF(this.bodyParams);
      }
   }
}

