package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class ClanDeleteRankCommand implements IModule
   {
      
      private static var _instance:ClanDeleteRankCommand;
      
      public var clanRankListCommand:ClanRankListCommand;
      
      public var success:Boolean = false;
      
      public var errorMsg:BaseStackCommand;
      
      public function ClanDeleteRankCommand(param1:ClanRankListCommand = null, param2:Boolean = false, param3:BaseStackCommand = null)
      {
         super();
         if(param1 == null)
         {
            this.clanRankListCommand = new ClanRankListCommand();
         }
         else
         {
            this.clanRankListCommand = param1;
         }
         this.success = param2;
         if(param3 == null)
         {
            this.errorMsg = new BaseStackCommand();
         }
         else
         {
            this.errorMsg = param3;
         }
      }
      
      public static function get instance() : ClanDeleteRankCommand
      {
         return _instance || (_instance = new ClanDeleteRankCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 29911;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.clanRankListCommand = ClanRankListCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.clanRankListCommand)
         {
            this.clanRankListCommand.read(param1);
         }
         this.success = param1.readBoolean();
         this.errorMsg = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.errorMsg)
         {
            this.errorMsg.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(29911);
         if(null != this.clanRankListCommand)
         {
            this.clanRankListCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeBoolean(this.success);
         if(null != this.errorMsg)
         {
            this.errorMsg.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

