package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.*;
   
   public class AbsUserMessageInfoCommand implements IModule
   {
      
      private static var _instance:AbsUserMessageInfoCommand;
      
      public var senderId:int = 0;
      
      public var replacements:String = "";
      
      public var insertDate:String = "";
      
      public var boxId:Number = 0;
      
      public var parent:Boolean = false;
      
      public var isReceived:int = 0;
      
      public var messageId:int = 0;
      
      public var type:int = 0;
      
      public var subject:String = "";
      
      public var attachments:Vector.<LootModule>;
      
      public var body:String = "";
      
      public var status:int = 0;
      
      public function AbsUserMessageInfoCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:String = "", param5:String = "", param6:Boolean = false, param7:String = "", param8:Number = 0, param9:int = 0, param10:Vector.<LootModule> = null, param11:int = 0, param12:String = "")
      {
         super();
         this.senderId = param9;
         this.replacements = param12;
         this.insertDate = param7;
         this.boxId = param8;
         this.parent = param6;
         this.isReceived = param11;
         this.messageId = param1;
         this.type = param2;
         this.subject = param4;
         if(param10 == null)
         {
            this.attachments = new Vector.<LootModule>();
         }
         else
         {
            this.attachments = param10;
         }
         this.body = param5;
         this.status = param3;
      }
      
      public static function get instance() : AbsUserMessageInfoCommand
      {
         return _instance || (_instance = new AbsUserMessageInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -9878;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 41;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:LootModule = null;
         this.senderId = param1.readInt();
         this.senderId = this.senderId >>> 6 % 32 | this.senderId << 32 - 6 % 32;
         this.replacements = param1.readUTF();
         this.insertDate = param1.readUTF();
         this.boxId = param1.readDouble();
         this.parent = param1.readBoolean();
         this.isReceived = param1.readInt();
         this.isReceived = this.isReceived << 2 % 32 | this.isReceived >>> 32 - 2 % 32;
         this.messageId = param1.readInt();
         this.messageId = this.messageId >>> 1 % 32 | this.messageId << 32 - 1 % 32;
         this.type = param1.readInt();
         this.type = this.type << 3 % 32 | this.type >>> 32 - 3 % 32;
         this.subject = param1.readUTF();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.attachments.length > 0)
         {
            this.attachments.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = LootModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.attachments.push(_loc4_);
            _loc2_++;
         }
         this.body = param1.readUTF();
         this.status = param1.readInt();
         this.status = this.status >>> 11 % 32 | this.status << 32 - 11 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:LootModule = null;
         param1.writeShort(-9878);
         param1.writeInt(this.senderId << 6 % 32 | this.senderId >>> 32 - 6 % 32);
         param1.writeUTF(this.replacements);
         param1.writeUTF(this.insertDate);
         param1.writeDouble(this.boxId);
         param1.writeBoolean(this.parent);
         param1.writeInt(this.isReceived >>> 2 % 32 | this.isReceived << 32 - 2 % 32);
         param1.writeInt(this.messageId << 1 % 32 | this.messageId >>> 32 - 1 % 32);
         param1.writeInt(this.type >>> 3 % 32 | this.type << 32 - 3 % 32);
         param1.writeUTF(this.subject);
         param1.writeByte(this.attachments.length);
         for each(_loc2_ in this.attachments)
         {
            _loc2_.write(param1);
         }
         param1.writeUTF(this.body);
         param1.writeInt(this.status << 11 % 32 | this.status >>> 32 - 11 % 32);
      }
   }
}

