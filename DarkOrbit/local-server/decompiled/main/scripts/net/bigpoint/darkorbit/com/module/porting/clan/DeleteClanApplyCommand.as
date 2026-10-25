package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class DeleteClanApplyCommand implements IModule
   {
      
      private static var _instance:DeleteClanApplyCommand;
      
      public var success:Boolean = false;
      
      public var applyId:int = 0;
      
      public var errorMsg:BaseStackCommand;
      
      public function DeleteClanApplyCommand(param1:int = 0, param2:Boolean = false, param3:BaseStackCommand = null)
      {
         super();
         this.success = param2;
         this.applyId = param1;
         if(param3 == null)
         {
            this.errorMsg = new BaseStackCommand();
         }
         else
         {
            this.errorMsg = param3;
         }
      }
      
      public static function get instance() : DeleteClanApplyCommand
      {
         return _instance || (_instance = new DeleteClanApplyCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -24125;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.success = param1.readBoolean();
         this.applyId = param1.readInt();
         this.applyId = this.applyId << 3 % 32 | this.applyId >>> 32 - 3 % 32;
         this.errorMsg = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.errorMsg)
         {
            this.errorMsg.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-24125);
         param1.writeBoolean(this.success);
         param1.writeInt(this.applyId >>> 3 % 32 | this.applyId << 32 - 3 % 32);
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

