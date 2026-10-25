package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.*;
   
   public class UserMessageDeleteCommand implements IModule
   {
      
      private static var _instance:UserMessageDeleteCommand;
      
      public var inbox:Boolean = false;
      
      public var count:int = 0;
      
      public var textCommand:BaseStackCommand;
      
      public var titleCommand:BaseStackCommand;
      
      public var deleteIds:Vector.<Number>;
      
      public var unreadCount:int = 0;
      
      public var messageInfoCommands:Vector.<AbsUserMessageInfoCommand>;
      
      public var success:Boolean = false;
      
      public function UserMessageDeleteCommand(param1:Boolean = false, param2:BaseStackCommand = null, param3:BaseStackCommand = null, param4:int = 0, param5:int = 0, param6:Vector.<Number> = null, param7:Boolean = false, param8:Vector.<AbsUserMessageInfoCommand> = null)
      {
         super();
         this.inbox = param7;
         this.count = param4;
         if(param3 == null)
         {
            this.textCommand = new BaseStackCommand();
         }
         else
         {
            this.textCommand = param3;
         }
         if(param2 == null)
         {
            this.titleCommand = new BaseStackCommand();
         }
         else
         {
            this.titleCommand = param2;
         }
         if(param6 == null)
         {
            this.deleteIds = new Vector.<Number>();
         }
         else
         {
            this.deleteIds = param6;
         }
         this.unreadCount = param5;
         if(param8 == null)
         {
            this.messageInfoCommands = new Vector.<AbsUserMessageInfoCommand>();
         }
         else
         {
            this.messageInfoCommands = param8;
         }
         this.success = param1;
      }
      
      public static function get instance() : UserMessageDeleteCommand
      {
         return _instance || (_instance = new UserMessageDeleteCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 17926;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 18;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:AbsUserMessageInfoCommand = null;
         this.inbox = param1.readBoolean();
         this.count = param1.readInt();
         this.count = this.count << 2 % 32 | this.count >>> 32 - 2 % 32;
         this.textCommand = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.textCommand)
         {
            this.textCommand.read(param1);
         }
         this.titleCommand = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.titleCommand)
         {
            this.titleCommand.read(param1);
         }
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.deleteIds.length > 0)
         {
            this.deleteIds.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            this.deleteIds.push(param1.readDouble());
            _loc2_++;
         }
         this.unreadCount = param1.readInt();
         this.unreadCount = this.unreadCount << 4 % 32 | this.unreadCount >>> 32 - 4 % 32;
         while(this.messageInfoCommands.length > 0)
         {
            this.messageInfoCommands.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = AbsUserMessageInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.messageInfoCommands.push(_loc4_);
            _loc2_++;
         }
         this.success = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:AbsUserMessageInfoCommand = null;
         param1.writeShort(17926);
         param1.writeBoolean(this.inbox);
         param1.writeInt(this.count >>> 2 % 32 | this.count << 32 - 2 % 32);
         if(null != this.textCommand)
         {
            this.textCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.titleCommand)
         {
            this.titleCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeByte(this.deleteIds.length);
         for each(_loc2_ in this.deleteIds)
         {
            param1.writeDouble(_loc2_);
         }
         param1.writeInt(this.unreadCount >>> 4 % 32 | this.unreadCount << 32 - 4 % 32);
         param1.writeByte(this.messageInfoCommands.length);
         for each(_loc3_ in this.messageInfoCommands)
         {
            _loc3_.write(param1);
         }
         param1.writeBoolean(this.success);
      }
   }
}

