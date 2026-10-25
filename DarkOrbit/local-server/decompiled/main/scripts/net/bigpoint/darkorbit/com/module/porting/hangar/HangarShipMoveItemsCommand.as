package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class HangarShipMoveItemsCommand implements IModule
   {
      
      private static var _instance:HangarShipMoveItemsCommand;
      
      public var result:int = 0;
      
      public var errorMessage:BaseStackCommand;
      
      public function HangarShipMoveItemsCommand(param1:int = 0, param2:BaseStackCommand = null)
      {
         super();
         this.result = param1;
         if(param2 == null)
         {
            this.errorMessage = new BaseStackCommand();
         }
         else
         {
            this.errorMessage = param2;
         }
      }
      
      public static function get instance() : HangarShipMoveItemsCommand
      {
         return _instance || (_instance = new HangarShipMoveItemsCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 712;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.result = param1.readInt();
         this.result = this.result >>> 3 % 32 | this.result << 32 - 3 % 32;
         this.errorMessage = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.errorMessage)
         {
            this.errorMessage.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(712);
         param1.writeInt(this.result << 3 % 32 | this.result >>> 32 - 3 % 32);
         if(null != this.errorMessage)
         {
            this.errorMessage.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

