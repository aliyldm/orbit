package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class HangarShipImportConfigCommand implements IModule
   {
      
      private static var _instance:HangarShipImportConfigCommand;
      
      public var shipId:Number = 0;
      
      public var errorMessage:BaseStackCommand;
      
      public var resultId:int = 0;
      
      public function HangarShipImportConfigCommand(param1:int = 0, param2:Number = 0, param3:BaseStackCommand = null)
      {
         super();
         this.shipId = param2;
         if(param3 == null)
         {
            this.errorMessage = new BaseStackCommand();
         }
         else
         {
            this.errorMessage = param3;
         }
         this.resultId = param1;
      }
      
      public static function get instance() : HangarShipImportConfigCommand
      {
         return _instance || (_instance = new HangarShipImportConfigCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -23432;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.shipId = param1.readDouble();
         this.errorMessage = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.errorMessage)
         {
            this.errorMessage.read(param1);
         }
         this.resultId = param1.readInt();
         this.resultId = this.resultId << 14 % 32 | this.resultId >>> 32 - 14 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-23432);
         param1.writeDouble(this.shipId);
         if(null != this.errorMessage)
         {
            this.errorMessage.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.resultId >>> 14 % 32 | this.resultId << 32 - 14 % 32);
      }
   }
}

