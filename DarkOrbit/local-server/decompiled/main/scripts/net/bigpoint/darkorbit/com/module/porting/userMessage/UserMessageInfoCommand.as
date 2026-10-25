package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.darkorbit.com.module.*;
   
   public class UserMessageInfoCommand extends AbsUserMessageInfoCommand
   {
      
      private static var _instance:UserMessageInfoCommand;
      
      public var bodyParams:String = "";
      
      public var recipientIds:Vector.<int>;
      
      public var title:String = "";
      
      public var bodyInc:String = "";
      
      public var recipients:Vector.<String>;
      
      public var parentMessage:UserMessageParentInfoCommand;
      
      public var senderAvatar:String = "";
      
      public var versionType:int = 0;
      
      public var subjectInc:String = "";
      
      public var subjectParams:String = "";
      
      public var senderName:String = "";
      
      public function UserMessageInfoCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:String = "", param5:String = "", param6:Boolean = false, param7:String = "", param8:Number = 0, param9:int = 0, param10:Vector.<LootModule> = null, param11:int = 0, param12:String = "", param13:String = "", param14:String = "", param15:String = "", param16:Vector.<String> = null, param17:Vector.<int> = null, param18:UserMessageParentInfoCommand = null, param19:String = "", param20:String = "", param21:String = "", param22:String = "", param23:int = 0)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12);
         this.bodyParams = param21;
         if(param17 == null)
         {
            this.recipientIds = new Vector.<int>();
         }
         else
         {
            this.recipientIds = param17;
         }
         this.title = param13;
         this.bodyInc = param19;
         if(param16 == null)
         {
            this.recipients = new Vector.<String>();
         }
         else
         {
            this.recipients = param16;
         }
         if(param18 == null)
         {
            this.parentMessage = new UserMessageParentInfoCommand();
         }
         else
         {
            this.parentMessage = param18;
         }
         this.senderAvatar = param15;
         this.versionType = param23;
         this.subjectInc = param20;
         this.subjectParams = param22;
         this.senderName = param14;
      }
      
      public static function get instance() : UserMessageInfoCommand
      {
         return _instance || (_instance = new UserMessageInfoCommand());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -14070;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 26;
      }
      
      override public function read(param1:IDataInput) : void
      {
         var _loc4_:int = 0;
         param1.readShort();
         super.read(param1);
         this.bodyParams = param1.readUTF();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.recipientIds.length > 0)
         {
            this.recipientIds.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ >>> 3 % 32 | _loc4_ << 32 - 3 % 32;
            this.recipientIds.push(_loc4_);
            _loc2_++;
         }
         this.title = param1.readUTF();
         this.bodyInc = param1.readUTF();
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
         this.parentMessage = UserMessageParentInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.parentMessage)
         {
            this.parentMessage.read(param1);
         }
         this.senderAvatar = param1.readUTF();
         this.versionType = param1.readInt();
         this.versionType = this.versionType >>> 9 % 32 | this.versionType << 32 - 9 % 32;
         this.subjectInc = param1.readUTF();
         this.subjectParams = param1.readUTF();
         this.senderName = param1.readUTF();
      }
      
      override public function write(param1:IDataOutput) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         param1.writeShort(-14070);
         super.write(param1);
         param1.writeUTF(this.bodyParams);
         param1.writeByte(this.recipientIds.length);
         for each(_loc2_ in this.recipientIds)
         {
            param1.writeInt(_loc2_ << 3 % 32 | _loc2_ >>> 32 - 3 % 32);
         }
         param1.writeUTF(this.title);
         param1.writeUTF(this.bodyInc);
         param1.writeByte(this.recipients.length);
         for each(_loc3_ in this.recipients)
         {
            param1.writeUTF(_loc3_);
         }
         if(null != this.parentMessage)
         {
            this.parentMessage.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeUTF(this.senderAvatar);
         param1.writeInt(this.versionType << 9 % 32 | this.versionType >>> 32 - 9 % 32);
         param1.writeUTF(this.subjectInc);
         param1.writeUTF(this.subjectParams);
         param1.writeUTF(this.senderName);
      }
   }
}

