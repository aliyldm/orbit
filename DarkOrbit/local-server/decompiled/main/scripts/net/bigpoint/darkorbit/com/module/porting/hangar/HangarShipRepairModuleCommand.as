package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class HangarShipRepairModuleCommand implements IModule
   {
      
      private static var _instance:HangarShipRepairModuleCommand;
      
      public var errorMessage:BaseStackCommand;
      
      public var itemId:Number = 0;
      
      public var currentHitPoints:int = 0;
      
      public var maxHitPoints:int = 0;
      
      public var resultId:int = 0;
      
      public function HangarShipRepairModuleCommand(param1:int = 0, param2:Number = 0, param3:int = 0, param4:int = 0, param5:BaseStackCommand = null)
      {
         super();
         if(param5 == null)
         {
            this.errorMessage = new BaseStackCommand();
         }
         else
         {
            this.errorMessage = param5;
         }
         this.itemId = param2;
         this.currentHitPoints = param4;
         this.maxHitPoints = param3;
         this.resultId = param1;
      }
      
      public static function get instance() : HangarShipRepairModuleCommand
      {
         return _instance || (_instance = new HangarShipRepairModuleCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 15963;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 20;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.errorMessage = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.errorMessage)
         {
            this.errorMessage.read(param1);
         }
         this.itemId = param1.readDouble();
         this.currentHitPoints = param1.readInt();
         this.currentHitPoints = this.currentHitPoints >>> 3 % 32 | this.currentHitPoints << 32 - 3 % 32;
         this.maxHitPoints = param1.readInt();
         this.maxHitPoints = this.maxHitPoints >>> 10 % 32 | this.maxHitPoints << 32 - 10 % 32;
         this.resultId = param1.readInt();
         this.resultId = this.resultId << 6 % 32 | this.resultId >>> 32 - 6 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(15963);
         if(null != this.errorMessage)
         {
            this.errorMessage.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeDouble(this.itemId);
         param1.writeInt(this.currentHitPoints << 3 % 32 | this.currentHitPoints >>> 32 - 3 % 32);
         param1.writeInt(this.maxHitPoints << 10 % 32 | this.maxHitPoints >>> 32 - 10 % 32);
         param1.writeInt(this.resultId >>> 6 % 32 | this.resultId << 32 - 6 % 32);
      }
   }
}

