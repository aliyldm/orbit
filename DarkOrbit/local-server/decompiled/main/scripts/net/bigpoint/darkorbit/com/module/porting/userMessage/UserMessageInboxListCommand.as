package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class UserMessageInboxListCommand implements IModule
   {
      
      private static var _instance:UserMessageInboxListCommand;
      
      public var userMessageInfoCommandList:Vector.<AbsUserMessageInfoCommand>;
      
      public var startIndex:int = 0;
      
      public function UserMessageInboxListCommand(param1:int = 0, param2:Vector.<AbsUserMessageInfoCommand> = null)
      {
         super();
         if(param2 == null)
         {
            this.userMessageInfoCommandList = new Vector.<AbsUserMessageInfoCommand>();
         }
         else
         {
            this.userMessageInfoCommandList = param2;
         }
         this.startIndex = param1;
      }
      
      public static function get instance() : UserMessageInboxListCommand
      {
         return _instance || (_instance = new UserMessageInboxListCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 18130;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:AbsUserMessageInfoCommand = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.userMessageInfoCommandList.length > 0)
         {
            this.userMessageInfoCommandList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = AbsUserMessageInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.userMessageInfoCommandList.push(_loc4_);
            _loc2_++;
         }
         this.startIndex = param1.readInt();
         this.startIndex = this.startIndex >>> 9 % 32 | this.startIndex << 32 - 9 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:AbsUserMessageInfoCommand = null;
         param1.writeShort(18130);
         param1.writeByte(this.userMessageInfoCommandList.length);
         for each(_loc2_ in this.userMessageInfoCommandList)
         {
            _loc2_.write(param1);
         }
         param1.writeInt(this.startIndex << 9 % 32 | this.startIndex >>> 32 - 9 % 32);
      }
   }
}

