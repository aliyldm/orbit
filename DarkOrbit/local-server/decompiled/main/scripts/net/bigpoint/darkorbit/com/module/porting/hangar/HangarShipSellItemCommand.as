package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class HangarShipSellItemCommand implements IModule
   {
      
      private static var _instance:HangarShipSellItemCommand;
      
      public var errorMessage:BaseStackCommand;
      
      public var resultId:int = 0;
      
      public function HangarShipSellItemCommand(param1:int = 0, param2:BaseStackCommand = null)
      {
         super();
         if(param2 == null)
         {
            this.errorMessage = new BaseStackCommand();
         }
         else
         {
            this.errorMessage = param2;
         }
         this.resultId = param1;
      }
      
      public static function get instance() : HangarShipSellItemCommand
      {
         return _instance || (_instance = new HangarShipSellItemCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 17938;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.errorMessage = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.errorMessage)
         {
            this.errorMessage.read(param1);
         }
         this.resultId = param1.readInt();
         this.resultId = this.resultId << 12 % 32 | this.resultId >>> 32 - 12 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(17938);
         if(null != this.errorMessage)
         {
            this.errorMessage.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.resultId >>> 12 % 32 | this.resultId << 32 - 12 % 32);
      }
   }
}

