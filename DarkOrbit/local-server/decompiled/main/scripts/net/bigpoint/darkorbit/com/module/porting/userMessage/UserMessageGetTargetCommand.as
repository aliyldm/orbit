package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class UserMessageGetTargetCommand implements IModule
   {
      
      private static var _instance:UserMessageGetTargetCommand;
      
      public var commandList:Vector.<UserMessageTargetInfoCommand>;
      
      public function UserMessageGetTargetCommand(param1:Vector.<UserMessageTargetInfoCommand> = null)
      {
         super();
         if(param1 == null)
         {
            this.commandList = new Vector.<UserMessageTargetInfoCommand>();
         }
         else
         {
            this.commandList = param1;
         }
      }
      
      public static function get instance() : UserMessageGetTargetCommand
      {
         return _instance || (_instance = new UserMessageGetTargetCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -32332;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:UserMessageTargetInfoCommand = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.commandList.length > 0)
         {
            this.commandList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = UserMessageTargetInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.commandList.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:UserMessageTargetInfoCommand = null;
         param1.writeShort(-32332);
         param1.writeByte(this.commandList.length);
         for each(_loc2_ in this.commandList)
         {
            _loc2_.write(param1);
         }
      }
   }
}

