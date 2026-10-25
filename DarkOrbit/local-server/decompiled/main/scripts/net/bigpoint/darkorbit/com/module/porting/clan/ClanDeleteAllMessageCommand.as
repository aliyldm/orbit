package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class ClanDeleteAllMessageCommand implements IModule
   {
      
      private static var _instance:ClanDeleteAllMessageCommand;
      
      public var errorMsg:BaseStackCommand;
      
      public var success:Boolean = false;
      
      public function ClanDeleteAllMessageCommand(param1:Boolean = false, param2:BaseStackCommand = null)
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
      }
      
      public static function get instance() : ClanDeleteAllMessageCommand
      {
         return _instance || (_instance = new ClanDeleteAllMessageCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 4861;
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
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(4861);
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

