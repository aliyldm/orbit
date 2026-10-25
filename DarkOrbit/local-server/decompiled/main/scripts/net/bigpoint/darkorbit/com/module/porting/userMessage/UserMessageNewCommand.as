package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class UserMessageNewCommand implements IModule
   {
      
      private static var _instance:UserMessageNewCommand;
      
      public var userMessageInfoCommand:AbsUserMessageInfoCommand;
      
      public var unreadCount:int = 0;
      
      public function UserMessageNewCommand(param1:int = 0, param2:AbsUserMessageInfoCommand = null)
      {
         super();
         if(param2 == null)
         {
            this.userMessageInfoCommand = new AbsUserMessageInfoCommand();
         }
         else
         {
            this.userMessageInfoCommand = param2;
         }
         this.unreadCount = param1;
      }
      
      public static function get instance() : UserMessageNewCommand
      {
         return _instance || (_instance = new UserMessageNewCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 30664;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.userMessageInfoCommand = AbsUserMessageInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.userMessageInfoCommand)
         {
            this.userMessageInfoCommand.read(param1);
         }
         this.unreadCount = param1.readInt();
         this.unreadCount = this.unreadCount << 7 % 32 | this.unreadCount >>> 32 - 7 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(30664);
         if(null != this.userMessageInfoCommand)
         {
            this.userMessageInfoCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.unreadCount >>> 7 % 32 | this.unreadCount << 32 - 7 % 32);
      }
   }
}

