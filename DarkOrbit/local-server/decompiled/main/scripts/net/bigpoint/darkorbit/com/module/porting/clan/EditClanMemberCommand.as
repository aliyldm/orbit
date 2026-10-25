package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class EditClanMemberCommand implements IModule
   {
      
      private static var _instance:EditClanMemberCommand;
      
      public var clanId:int = 0;
      
      public var success:Boolean = false;
      
      public var errorMsg:BaseStackCommand;
      
      public var command:ClanMemberInfoCommand;
      
      public function EditClanMemberCommand(param1:int = 0, param2:Boolean = false, param3:BaseStackCommand = null, param4:ClanMemberInfoCommand = null)
      {
         super();
         this.clanId = param1;
         this.success = param2;
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
            this.command = new ClanMemberInfoCommand();
         }
         else
         {
            this.command = param4;
         }
      }
      
      public static function get instance() : EditClanMemberCommand
      {
         return _instance || (_instance = new EditClanMemberCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 13970;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.clanId = param1.readInt();
         this.clanId = this.clanId << 15 % 32 | this.clanId >>> 32 - 15 % 32;
         this.success = param1.readBoolean();
         this.errorMsg = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.errorMsg)
         {
            this.errorMsg.read(param1);
         }
         this.command = ClanMemberInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.command)
         {
            this.command.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(13970);
         param1.writeInt(this.clanId >>> 15 % 32 | this.clanId << 32 - 15 % 32);
         param1.writeBoolean(this.success);
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
      }
   }
}

