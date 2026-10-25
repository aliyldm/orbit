package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class DeleteClanMemberCommand implements IModule
   {
      
      private static var _instance:DeleteClanMemberCommand;
      
      public var removeUserID:int = 0;
      
      public var success:Boolean = false;
      
      public var errorMsg:BaseStackCommand;
      
      public function DeleteClanMemberCommand(param1:int = 0, param2:Boolean = false, param3:BaseStackCommand = null)
      {
         super();
         this.removeUserID = param1;
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
      
      public static function get instance() : DeleteClanMemberCommand
      {
         return _instance || (_instance = new DeleteClanMemberCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 26262;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.removeUserID = param1.readInt();
         this.removeUserID = this.removeUserID << 3 % 32 | this.removeUserID >>> 32 - 3 % 32;
         this.success = param1.readBoolean();
         this.errorMsg = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.errorMsg)
         {
            this.errorMsg.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(26262);
         param1.writeInt(this.removeUserID >>> 3 % 32 | this.removeUserID << 32 - 3 % 32);
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

