package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ClanSendMessageRequest implements IModule
   {
      
      private static var _instance:ClanSendMessageRequest;
      
      public var toUserId:int = 0;
      
      public var subject:String = "";
      
      public var msgText:String = "";
      
      public function ClanSendMessageRequest(param1:int = 0, param2:String = "", param3:String = "")
      {
         super();
         this.toUserId = param1;
         this.subject = param2;
         this.msgText = param3;
      }
      
      public static function get instance() : ClanSendMessageRequest
      {
         return _instance || (_instance = new ClanSendMessageRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 29570;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.toUserId = param1.readInt();
         this.toUserId = this.toUserId << 7 % 32 | this.toUserId >>> 32 - 7 % 32;
         this.subject = param1.readUTF();
         this.msgText = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(29570);
         param1.writeInt(this.toUserId >>> 7 % 32 | this.toUserId << 32 - 7 % 32);
         param1.writeUTF(this.subject);
         param1.writeUTF(this.msgText);
      }
   }
}

