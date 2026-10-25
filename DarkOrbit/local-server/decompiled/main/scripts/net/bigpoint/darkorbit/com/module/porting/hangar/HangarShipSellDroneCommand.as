package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.*;
   
   public class HangarShipSellDroneCommand implements IModule
   {
      
      private static var _instance:HangarShipSellDroneCommand;
      
      public var resultId:int = 0;
      
      public var errorMessage:BaseStackCommand;
      
      public var drones:Vector.<HangarShipDroneView>;
      
      public function HangarShipSellDroneCommand(param1:int = 0, param2:BaseStackCommand = null, param3:Vector.<HangarShipDroneView> = null)
      {
         super();
         this.resultId = param1;
         if(param2 == null)
         {
            this.errorMessage = new BaseStackCommand();
         }
         else
         {
            this.errorMessage = param2;
         }
         if(param3 == null)
         {
            this.drones = new Vector.<HangarShipDroneView>();
         }
         else
         {
            this.drones = param3;
         }
      }
      
      public static function get instance() : HangarShipSellDroneCommand
      {
         return _instance || (_instance = new HangarShipSellDroneCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -31025;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:HangarShipDroneView = null;
         this.resultId = param1.readInt();
         this.resultId = this.resultId >>> 16 % 32 | this.resultId << 32 - 16 % 32;
         this.errorMessage = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.errorMessage)
         {
            this.errorMessage.read(param1);
         }
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.drones.length > 0)
         {
            this.drones.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = HangarShipDroneView(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.drones.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:HangarShipDroneView = null;
         param1.writeShort(-31025);
         param1.writeInt(this.resultId << 16 % 32 | this.resultId >>> 32 - 16 % 32);
         if(null != this.errorMessage)
         {
            this.errorMessage.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeByte(this.drones.length);
         for each(_loc2_ in this.drones)
         {
            _loc2_.write(param1);
         }
      }
   }
}

