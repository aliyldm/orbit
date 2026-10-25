package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class PayoutClanCommand implements IModule
   {
      
      private static var _instance:PayoutClanCommand;
      
      public var success:Boolean = false;
      
      public var errorMsg:BaseStackCommand;
      
      public var clanTaxLogCommand:ClanTaxLogCommand;
      
      public var clanInfoCommand:ClanInfoCommand;
      
      public function PayoutClanCommand(param1:Boolean = false, param2:BaseStackCommand = null, param3:ClanTaxLogCommand = null, param4:ClanInfoCommand = null)
      {
         super();
         this.success = param1;
         if(param2 == null)
         {
            this.errorMsg = new BaseStackCommand();
         }
         else
         {
            this.errorMsg = param2;
         }
         if(param3 == null)
         {
            this.clanTaxLogCommand = new ClanTaxLogCommand();
         }
         else
         {
            this.clanTaxLogCommand = param3;
         }
         if(param4 == null)
         {
            this.clanInfoCommand = new ClanInfoCommand();
         }
         else
         {
            this.clanInfoCommand = param4;
         }
      }
      
      public static function get instance() : PayoutClanCommand
      {
         return _instance || (_instance = new PayoutClanCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -16859;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.success = param1.readBoolean();
         this.errorMsg = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.errorMsg)
         {
            this.errorMsg.read(param1);
         }
         this.clanTaxLogCommand = ClanTaxLogCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.clanTaxLogCommand)
         {
            this.clanTaxLogCommand.read(param1);
         }
         this.clanInfoCommand = ClanInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.clanInfoCommand)
         {
            this.clanInfoCommand.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-16859);
         param1.writeBoolean(this.success);
         if(null != this.errorMsg)
         {
            this.errorMsg.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.clanTaxLogCommand)
         {
            this.clanTaxLogCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.clanInfoCommand)
         {
            this.clanInfoCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

