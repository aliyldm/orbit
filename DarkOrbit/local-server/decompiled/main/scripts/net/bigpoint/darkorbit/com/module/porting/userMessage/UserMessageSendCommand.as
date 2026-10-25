package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class UserMessageSendCommand implements IModule
   {
      
      private static var _instance:UserMessageSendCommand;
      
      public static const CAPTCHASTATUS_NONE:int = 0;
      
      public static const CAPTCHASTATUS_REQUIRED:int = 1;
      
      public static const CAPTCHASTATUS_INVALID_OR_EXPIRED:int = 2;
      
      public static const CAPTCHASTATUS_UNAVAILABLE:int = 3;
      
      public static const CAPTCHASTATUS__MAX:int = 4;
      
      public var textCommand:BaseStackCommand;
      
      public var success:Boolean = false;
      
      public var messageInfoCommand:AbsUserMessageInfoCommand;
      
      public var titleCommand:BaseStackCommand;
      
      public var captchaStatus:int = 0;
      
      public function UserMessageSendCommand(param1:Boolean = false, param2:BaseStackCommand = null, param3:BaseStackCommand = null, param4:AbsUserMessageInfoCommand = null, param5:int = 0)
      {
         super();
         if(param3 == null)
         {
            this.textCommand = new BaseStackCommand();
         }
         else
         {
            this.textCommand = param3;
         }
         this.success = param1;
         if(param4 == null)
         {
            this.messageInfoCommand = new AbsUserMessageInfoCommand();
         }
         else
         {
            this.messageInfoCommand = param4;
         }
         if(param2 == null)
         {
            this.titleCommand = new BaseStackCommand();
         }
         else
         {
            this.titleCommand = param2;
         }
         this.captchaStatus = param5;
      }
      
      public static function get instance() : UserMessageSendCommand
      {
         return _instance || (_instance = new UserMessageSendCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 25051;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.textCommand = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.textCommand)
         {
            this.textCommand.read(param1);
         }
         this.success = param1.readBoolean();
         this.messageInfoCommand = AbsUserMessageInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.messageInfoCommand)
         {
            this.messageInfoCommand.read(param1);
         }
         this.titleCommand = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.titleCommand)
         {
            this.titleCommand.read(param1);
         }
         this.captchaStatus = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(25051);
         if(null != this.textCommand)
         {
            this.textCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeBoolean(this.success);
         if(null != this.messageInfoCommand)
         {
            this.messageInfoCommand.write(param1);
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
         param1.writeShort(this.captchaStatus);
      }
   }
}

