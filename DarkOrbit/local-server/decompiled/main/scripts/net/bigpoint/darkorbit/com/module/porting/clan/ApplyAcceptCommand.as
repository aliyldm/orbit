package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class ApplyAcceptCommand implements IModule
   {
      
      private static var _instance:ApplyAcceptCommand;
      
      public var errorMsg:BaseStackCommand;
      
      public var command:ClanMemberListCommand;
      
      public var success:Boolean = false;
      
      public var applyId:int = 0;
      
      public function ApplyAcceptCommand(param1:int = 0, param2:Boolean = false, param3:BaseStackCommand = null, param4:ClanMemberListCommand = null)
      {
         super();
         if(param3 == null)
         {
            this.errorMsg = new BaseStackCommand();
         }
         else
         {
            this.errorMsg = param3;
         }
         if(param4 == null)
         {
            this.command = new ClanMemberListCommand();
         }
         else
         {
            this.command = param4;
         }
         this.success = param2;
         this.applyId = param1;
      }
      
      public static function get instance() : ApplyAcceptCommand
      {
         return _instance || (_instance = new ApplyAcceptCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -20714;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.errorMsg = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.errorMsg)
         {
            this.errorMsg.read(param1);
         }
         this.command = ClanMemberListCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.command)
         {
            this.command.read(param1);
         }
         this.success = param1.readBoolean();
         this.applyId = param1.readInt();
         this.applyId = this.applyId << 15 % 32 | this.applyId >>> 32 - 15 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-20714);
         if(null != this.errorMsg)
         {
            this.errorMsg.write(param1);
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
         param1.writeBoolean(this.success);
         param1.writeInt(this.applyId >>> 15 % 32 | this.applyId << 32 - 15 % 32);
      }
   }
}

