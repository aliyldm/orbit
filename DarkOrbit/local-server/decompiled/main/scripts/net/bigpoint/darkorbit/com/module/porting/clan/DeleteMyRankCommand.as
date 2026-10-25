package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class DeleteMyRankCommand implements IModule
   {
      
      private static var _instance:DeleteMyRankCommand;
      
      public var command:ClanMemberInfoCommand;
      
      public var errorMsg:BaseStackCommand;
      
      public var success:Boolean = false;
      
      public function DeleteMyRankCommand(param1:Boolean = false, param2:BaseStackCommand = null, param3:ClanMemberInfoCommand = null)
      {
         super();
         if(param3 == null)
         {
            this.command = new ClanMemberInfoCommand();
         }
         else
         {
            this.command = param3;
         }
         if(param2 == null)
         {
            this.errorMsg = new BaseStackCommand();
         }
         else
         {
            this.errorMsg = param2;
         }
         this.success = param1;
      }
      
      public static function get instance() : DeleteMyRankCommand
      {
         return _instance || (_instance = new DeleteMyRankCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 23103;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.command = ClanMemberInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.command)
         {
            this.command.read(param1);
         }
         this.errorMsg = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.errorMsg)
         {
            this.errorMsg.read(param1);
         }
         this.success = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(23103);
         if(null != this.command)
         {
            this.command.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
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

