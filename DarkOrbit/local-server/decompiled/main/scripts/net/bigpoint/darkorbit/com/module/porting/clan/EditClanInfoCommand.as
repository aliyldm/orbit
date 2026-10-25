package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class EditClanInfoCommand implements IModule
   {
      
      private static var _instance:EditClanInfoCommand;
      
      public var success:Boolean = false;
      
      public var clanId:int = 0;
      
      public var clanInfoCommand:ClanInfoCommand;
      
      public var errorMsg:BaseStackCommand;
      
      public function EditClanInfoCommand(param1:int = 0, param2:Boolean = false, param3:BaseStackCommand = null, param4:ClanInfoCommand = null)
      {
         super();
         this.success = param2;
         this.clanId = param1;
         if(param4 == null)
         {
            this.clanInfoCommand = new ClanInfoCommand();
         }
         else
         {
            this.clanInfoCommand = param4;
         }
         if(param3 == null)
         {
            this.errorMsg = new BaseStackCommand();
         }
         else
         {
            this.errorMsg = param3;
         }
      }
      
      public static function get instance() : EditClanInfoCommand
      {
         return _instance || (_instance = new EditClanInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -23449;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.success = param1.readBoolean();
         this.clanId = param1.readInt();
         this.clanId = this.clanId >>> 1 % 32 | this.clanId << 32 - 1 % 32;
         this.clanInfoCommand = ClanInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.clanInfoCommand)
         {
            this.clanInfoCommand.read(param1);
         }
         this.errorMsg = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.errorMsg)
         {
            this.errorMsg.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-23449);
         param1.writeBoolean(this.success);
         param1.writeInt(this.clanId << 1 % 32 | this.clanId >>> 32 - 1 % 32);
         if(null != this.clanInfoCommand)
         {
            this.clanInfoCommand.write(param1);
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
      }
   }
}

