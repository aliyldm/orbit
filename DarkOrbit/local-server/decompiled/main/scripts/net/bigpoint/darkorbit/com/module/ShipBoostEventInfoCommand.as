package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ShipBoostEventInfoCommand implements IModule
   {
      
      private static var _instance:ShipBoostEventInfoCommand;
      
      public var shipBoostSlots:Vector.<ShipBoostEventModule>;
      
      public var boostUpdateInfo:ShipBoostEventUpdateInfoCommand;
      
      public function ShipBoostEventInfoCommand(param1:Vector.<ShipBoostEventModule> = null, param2:ShipBoostEventUpdateInfoCommand = null)
      {
         super();
         if(param1 == null)
         {
            this.shipBoostSlots = new Vector.<ShipBoostEventModule>();
         }
         else
         {
            this.shipBoostSlots = param1;
         }
         if(param2 == null)
         {
            this.boostUpdateInfo = new ShipBoostEventUpdateInfoCommand();
         }
         else
         {
            this.boostUpdateInfo = param2;
         }
      }
      
      public static function get instance() : ShipBoostEventInfoCommand
      {
         return _instance || (_instance = new ShipBoostEventInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 12398;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:ShipBoostEventModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.shipBoostSlots.length > 0)
         {
            this.shipBoostSlots.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = ShipBoostEventModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.shipBoostSlots.push(_loc4_);
            _loc2_++;
         }
         this.boostUpdateInfo = ShipBoostEventUpdateInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.boostUpdateInfo)
         {
            this.boostUpdateInfo.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:ShipBoostEventModule = null;
         param1.writeShort(12398);
         param1.writeByte(this.shipBoostSlots.length);
         for each(_loc2_ in this.shipBoostSlots)
         {
            _loc2_.write(param1);
         }
         if(null != this.boostUpdateInfo)
         {
            this.boostUpdateInfo.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

