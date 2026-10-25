package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class ShowClanInfoCommand implements IModule
   {
      
      private static var _instance:ShowClanInfoCommand;
      
      public var success:Boolean = false;
      
      public var errorMsg:BaseStackCommand;
      
      public var clanInfoCommand:ClanInfoCommand;
      
      public function ShowClanInfoCommand(param1:Boolean = false, param2:BaseStackCommand = null, param3:ClanInfoCommand = null)
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
            this.clanInfoCommand = new ClanInfoCommand();
         }
         else
         {
            this.clanInfoCommand = param3;
         }
      }
      
      public static function get instance() : ShowClanInfoCommand
      {
         return _instance || (_instance = new ShowClanInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -2909;
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
         this.clanInfoCommand = ClanInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.clanInfoCommand)
         {
            this.clanInfoCommand.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-2909);
         param1.writeBoolean(this.success);
         if(null != this.errorMsg)
         {
            this.errorMsg.write(param1);
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

