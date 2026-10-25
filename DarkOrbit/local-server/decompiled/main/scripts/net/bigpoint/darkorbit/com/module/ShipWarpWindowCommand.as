package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ShipWarpWindowCommand implements IModule
   {
      
      private static var _instance:ShipWarpWindowCommand;
      
      public var jumpVoucherCount:int = 0;
      
      public var uridium:Number = 0;
      
      public var isNearSpacestation:Boolean = false;
      
      public var ships:Vector.<ShipWarpModule>;
      
      public function ShipWarpWindowCommand(param1:int = 0, param2:Number = 0, param3:Boolean = false, param4:Vector.<ShipWarpModule> = null)
      {
         super();
         this.jumpVoucherCount = param1;
         this.uridium = param2;
         this.isNearSpacestation = param3;
         if(param4 == null)
         {
            this.ships = new Vector.<ShipWarpModule>();
         }
         else
         {
            this.ships = param4;
         }
      }
      
      public static function get instance() : ShipWarpWindowCommand
      {
         return _instance || (_instance = new ShipWarpWindowCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 291;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 17;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:ShipWarpModule = null;
         this.jumpVoucherCount = param1.readInt();
         this.jumpVoucherCount = this.jumpVoucherCount << 14 % 32 | this.jumpVoucherCount >>> 32 - 14 % 32;
         this.uridium = param1.readDouble();
         this.isNearSpacestation = param1.readBoolean();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.ships.length > 0)
         {
            this.ships.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = ShipWarpModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.ships.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:ShipWarpModule = null;
         param1.writeShort(291);
         param1.writeInt(this.jumpVoucherCount >>> 14 % 32 | this.jumpVoucherCount << 32 - 14 % 32);
         param1.writeDouble(this.uridium);
         param1.writeBoolean(this.isNearSpacestation);
         param1.writeByte(this.ships.length);
         for each(_loc2_ in this.ships)
         {
            _loc2_.write(param1);
         }
      }
   }
}

