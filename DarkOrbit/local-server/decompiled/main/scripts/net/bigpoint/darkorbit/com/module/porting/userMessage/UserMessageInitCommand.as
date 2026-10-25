package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UserMessageInitCommand implements IModule
   {
      
      private static var _instance:UserMessageInitCommand;
      
      public var unreadCount:int = 0;
      
      public var outboxCount:int = 0;
      
      public var inboxCount:int = 0;
      
      public var noteLimit:int = 0;
      
      public function UserMessageInitCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0)
      {
         super();
         this.unreadCount = param1;
         this.outboxCount = param3;
         this.inboxCount = param2;
         this.noteLimit = param4;
      }
      
      public static function get instance() : UserMessageInitCommand
      {
         return _instance || (_instance = new UserMessageInitCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -25226;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 16;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.unreadCount = param1.readInt();
         this.unreadCount = this.unreadCount >>> 15 % 32 | this.unreadCount << 32 - 15 % 32;
         this.outboxCount = param1.readInt();
         this.outboxCount = this.outboxCount >>> 1 % 32 | this.outboxCount << 32 - 1 % 32;
         this.inboxCount = param1.readInt();
         this.inboxCount = this.inboxCount << 8 % 32 | this.inboxCount >>> 32 - 8 % 32;
         this.noteLimit = param1.readInt();
         this.noteLimit = this.noteLimit << 7 % 32 | this.noteLimit >>> 32 - 7 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-25226);
         param1.writeInt(this.unreadCount << 15 % 32 | this.unreadCount >>> 32 - 15 % 32);
         param1.writeInt(this.outboxCount << 1 % 32 | this.outboxCount >>> 32 - 1 % 32);
         param1.writeInt(this.inboxCount >>> 8 % 32 | this.inboxCount << 32 - 8 % 32);
         param1.writeInt(this.noteLimit >>> 7 % 32 | this.noteLimit << 32 - 7 % 32);
      }
   }
}

