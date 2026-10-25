package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class ChangeClanLeaderCommand implements IModule
   {
      
      private static var _instance:ChangeClanLeaderCommand;
      
      public var success:Boolean = false;
      
      public var stack:BaseStackCommand;
      
      public var command:ClanInfoCommand;
      
      public var newLeaderId:int = 0;
      
      public function ChangeClanLeaderCommand(param1:int = 0, param2:Boolean = false, param3:BaseStackCommand = null, param4:ClanInfoCommand = null)
      {
         super();
         this.success = param2;
         if(param3 == null)
         {
            this.stack = new BaseStackCommand();
         }
         else
         {
            this.stack = param3;
         }
         if(param4 == null)
         {
            this.command = new ClanInfoCommand();
         }
         else
         {
            this.command = param4;
         }
         this.newLeaderId = param1;
      }
      
      public static function get instance() : ChangeClanLeaderCommand
      {
         return _instance || (_instance = new ChangeClanLeaderCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 24773;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.success = param1.readBoolean();
         this.stack = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.stack)
         {
            this.stack.read(param1);
         }
         this.command = ClanInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.command)
         {
            this.command.read(param1);
         }
         this.newLeaderId = param1.readInt();
         this.newLeaderId = this.newLeaderId >>> 11 % 32 | this.newLeaderId << 32 - 11 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(24773);
         param1.writeBoolean(this.success);
         if(null != this.stack)
         {
            this.stack.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.command)
         {
            this.command.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.newLeaderId << 11 % 32 | this.newLeaderId >>> 32 - 11 % 32);
      }
   }
}

