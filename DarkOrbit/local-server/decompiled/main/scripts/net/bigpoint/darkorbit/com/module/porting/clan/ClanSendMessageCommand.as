package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class ClanSendMessageCommand implements IModule
   {
      
      private static var _instance:ClanSendMessageCommand;
      
      public var errorMsg:BaseStackCommand;
      
      public var success:Boolean = false;
      
      public var clanMessageInfoCommand:ClanMessageInfoCommand;
      
      public function ClanSendMessageCommand(param1:Boolean = false, param2:BaseStackCommand = null, param3:ClanMessageInfoCommand = null)
      {
         super();
         if(param2 == null)
         {
            this.errorMsg = new BaseStackCommand();
         }
         else
         {
            this.errorMsg = param2;
         }
         this.success = param1;
         if(param3 == null)
         {
            this.clanMessageInfoCommand = new ClanMessageInfoCommand();
         }
         else
         {
            this.clanMessageInfoCommand = param3;
         }
      }
      
      public static function get instance() : ClanSendMessageCommand
      {
         return _instance || (_instance = new ClanSendMessageCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -22362;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.errorMsg = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.errorMsg)
         {
            this.errorMsg.read(param1);
         }
         this.success = param1.readBoolean();
         this.clanMessageInfoCommand = ClanMessageInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.clanMessageInfoCommand)
         {
            this.clanMessageInfoCommand.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-22362);
         if(null != this.errorMsg)
         {
            this.errorMsg.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeBoolean(this.success);
         if(null != this.clanMessageInfoCommand)
         {
            this.clanMessageInfoCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

