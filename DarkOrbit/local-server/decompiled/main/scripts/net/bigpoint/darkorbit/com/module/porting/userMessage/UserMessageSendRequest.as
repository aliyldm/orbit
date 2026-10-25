package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UserMessageSendRequest implements IModule
   {
      
      private static var _instance:UserMessageSendRequest;
      
      public var recipientType:String = "";
      
      public var recipients:Vector.<String>;
      
      public var parentType:int = 0;
      
      public var parentId:int = 0;
      
      public var body:String = "";
      
      public var hCaptchaToken:String = "";
      
      public var subject:String = "";
      
      public function UserMessageSendRequest(param1:int = 0, param2:int = 0, param3:String = "", param4:Vector.<String> = null, param5:String = "", param6:String = "", param7:String = "")
      {
         super();
         this.recipientType = param3;
         if(param4 == null)
         {
            this.recipients = new Vector.<String>();
         }
         else
         {
            this.recipients = param4;
         }
         this.parentType = param1;
         this.parentId = param2;
         this.body = param6;
         this.hCaptchaToken = param7;
         this.subject = param5;
      }
      
      public static function get instance() : UserMessageSendRequest
      {
         return _instance || (_instance = new UserMessageSendRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -17587;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 20;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.recipientType = param1.readUTF();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.recipients.length > 0)
         {
            this.recipients.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            this.recipients.push(param1.readUTF());
            _loc2_++;
         }
         this.parentType = param1.readInt();
         this.parentType = this.parentType << 9 % 32 | this.parentType >>> 32 - 9 % 32;
         this.parentId = param1.readInt();
         this.parentId = this.parentId << 13 % 32 | this.parentId >>> 32 - 13 % 32;
         this.body = param1.readUTF();
         this.hCaptchaToken = param1.readUTF();
         this.subject = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:String = null;
         param1.writeShort(-17587);
         param1.writeUTF(this.recipientType);
         param1.writeByte(this.recipients.length);
         for each(_loc2_ in this.recipients)
         {
            param1.writeUTF(_loc2_);
         }
         param1.writeInt(this.parentType >>> 9 % 32 | this.parentType << 32 - 9 % 32);
         param1.writeInt(this.parentId >>> 13 % 32 | this.parentId << 32 - 13 % 32);
         param1.writeUTF(this.body);
         param1.writeUTF(this.hCaptchaToken);
         param1.writeUTF(this.subject);
      }
   }
}

