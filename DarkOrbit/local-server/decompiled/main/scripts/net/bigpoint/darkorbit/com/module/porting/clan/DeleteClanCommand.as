package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class DeleteClanCommand implements IModule
   {
      
      private static var _instance:DeleteClanCommand;
      
      public var success:Boolean = false;
      
      public var errorMsg:BaseStackCommand;
      
      public function DeleteClanCommand(param1:Boolean = false, param2:BaseStackCommand = null)
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
      }
      
      public static function get instance() : DeleteClanCommand
      {
         return _instance || (_instance = new DeleteClanCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -24041;
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
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-24041);
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

