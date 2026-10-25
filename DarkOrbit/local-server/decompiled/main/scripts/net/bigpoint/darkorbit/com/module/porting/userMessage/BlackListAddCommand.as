package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.*;
   
   public class BlackListAddCommand implements IModule
   {
      
      private static var _instance:BlackListAddCommand;
      
      public var textCommand:BaseStackCommand;
      
      public var titleCommand:BaseStackCommand;
      
      public var success:Boolean = false;
      
      public var blackList:Vector.<int>;
      
      public var blackNameList:Vector.<String>;
      
      public var blackUserId:int = 0;
      
      public function BlackListAddCommand(param1:int = 0, param2:Boolean = false, param3:BaseStackCommand = null, param4:BaseStackCommand = null, param5:Vector.<int> = null, param6:Vector.<String> = null)
      {
         super();
         if(param4 == null)
         {
            this.textCommand = new BaseStackCommand();
         }
         else
         {
            this.textCommand = param4;
         }
         if(param3 == null)
         {
            this.titleCommand = new BaseStackCommand();
         }
         else
         {
            this.titleCommand = param3;
         }
         this.success = param2;
         if(param5 == null)
         {
            this.blackList = new Vector.<int>();
         }
         else
         {
            this.blackList = param5;
         }
         if(param6 == null)
         {
            this.blackNameList = new Vector.<String>();
         }
         else
         {
            this.blackNameList = param6;
         }
         this.blackUserId = param1;
      }
      
      public static function get instance() : BlackListAddCommand
      {
         return _instance || (_instance = new BlackListAddCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 5457;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 13;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:int = 0;
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
         this.success = param1.readBoolean();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.blackList.length > 0)
         {
            this.blackList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ << 6 % 32 | _loc4_ >>> 32 - 6 % 32;
            this.blackList.push(_loc4_);
            _loc2_++;
         }
         while(this.blackNameList.length > 0)
         {
            this.blackNameList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            this.blackNameList.push(param1.readUTF());
            _loc2_++;
         }
         this.blackUserId = param1.readInt();
         this.blackUserId = this.blackUserId << 5 % 32 | this.blackUserId >>> 32 - 5 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         param1.writeShort(5457);
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
         param1.writeBoolean(this.success);
         param1.writeByte(this.blackList.length);
         for each(_loc2_ in this.blackList)
         {
            param1.writeInt(_loc2_ >>> 6 % 32 | _loc2_ << 32 - 6 % 32);
         }
         param1.writeByte(this.blackNameList.length);
         for each(_loc3_ in this.blackNameList)
         {
            param1.writeUTF(_loc3_);
         }
         param1.writeInt(this.blackUserId >>> 5 % 32 | this.blackUserId << 32 - 5 % 32);
      }
   }
}

