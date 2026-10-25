package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.*;
   
   public class UserMessageUpdateStatusCommand implements IModule
   {
      
      private static var _instance:UserMessageUpdateStatusCommand;
      
      public var unreadCount:int = 0;
      
      public var textCommand:BaseStackCommand;
      
      public var status:int = 0;
      
      public var ids:Vector.<Number>;
      
      public var inbox:Boolean = false;
      
      public var success:Boolean = false;
      
      public var titleCommand:BaseStackCommand;
      
      public var count:int = 0;
      
      public function UserMessageUpdateStatusCommand(param1:Boolean = false, param2:BaseStackCommand = null, param3:BaseStackCommand = null, param4:Vector.<Number> = null, param5:Boolean = false, param6:int = 0, param7:int = 0, param8:int = 0)
      {
         super();
         this.unreadCount = param7;
         if(param3 == null)
         {
            this.textCommand = new BaseStackCommand();
         }
         else
         {
            this.textCommand = param3;
         }
         this.status = param6;
         if(param4 == null)
         {
            this.ids = new Vector.<Number>();
         }
         else
         {
            this.ids = param4;
         }
         this.inbox = param5;
         this.success = param1;
         if(param2 == null)
         {
            this.titleCommand = new BaseStackCommand();
         }
         else
         {
            this.titleCommand = param2;
         }
         this.count = param8;
      }
      
      public static function get instance() : UserMessageUpdateStatusCommand
      {
         return _instance || (_instance = new UserMessageUpdateStatusCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 8850;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 18;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.unreadCount = param1.readInt();
         this.unreadCount = this.unreadCount << 8 % 32 | this.unreadCount >>> 32 - 8 % 32;
         this.textCommand = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.textCommand)
         {
            this.textCommand.read(param1);
         }
         this.status = param1.readInt();
         this.status = this.status << 10 % 32 | this.status >>> 32 - 10 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.ids.length > 0)
         {
            this.ids.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            this.ids.push(param1.readDouble());
            _loc2_++;
         }
         this.inbox = param1.readBoolean();
         this.success = param1.readBoolean();
         this.titleCommand = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.titleCommand)
         {
            this.titleCommand.read(param1);
         }
         this.count = param1.readInt();
         this.count = this.count >>> 4 % 32 | this.count << 32 - 4 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:Number = NaN;
         param1.writeShort(8850);
         param1.writeInt(this.unreadCount >>> 8 % 32 | this.unreadCount << 32 - 8 % 32);
         if(null != this.textCommand)
         {
            this.textCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.status >>> 10 % 32 | this.status << 32 - 10 % 32);
         param1.writeByte(this.ids.length);
         for each(_loc2_ in this.ids)
         {
            param1.writeDouble(_loc2_);
         }
         param1.writeBoolean(this.inbox);
         param1.writeBoolean(this.success);
         if(null != this.titleCommand)
         {
            this.titleCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.count << 4 % 32 | this.count >>> 32 - 4 % 32);
      }
   }
}

