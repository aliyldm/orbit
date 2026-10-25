package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class ClanDeleteMessageCommand implements IModule
   {
      
      private static var _instance:ClanDeleteMessageCommand;
      
      public var messageId:int = 0;
      
      public var errorMsg:BaseStackCommand;
      
      public var success:Boolean = false;
      
      public function ClanDeleteMessageCommand(param1:int = 0, param2:Boolean = false, param3:BaseStackCommand = null)
      {
         super();
         this.messageId = param1;
         if(param3 == null)
         {
            this.errorMsg = new BaseStackCommand();
         }
         else
         {
            this.errorMsg = param3;
         }
         this.success = param2;
      }
      
      public static function get instance() : ClanDeleteMessageCommand
      {
         return _instance || (_instance = new ClanDeleteMessageCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -1964;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.messageId = param1.readInt();
         this.messageId = this.messageId << 12 % 32 | this.messageId >>> 32 - 12 % 32;
         this.errorMsg = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.errorMsg)
         {
            this.errorMsg.read(param1);
         }
         this.success = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-1964);
         param1.writeInt(this.messageId >>> 12 % 32 | this.messageId << 32 - 12 % 32);
         if(null != this.errorMsg)
         {
            this.errorMsg.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeBoolean(this.success);
      }
   }
}

