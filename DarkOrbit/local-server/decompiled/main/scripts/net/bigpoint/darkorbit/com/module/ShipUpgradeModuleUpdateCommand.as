package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ShipUpgradeModuleUpdateCommand implements IModule
   {
      
      private static var _instance:ShipUpgradeModuleUpdateCommand;
      
      public var max:int = 0;
      
      public var moduleTypeIds:Vector.<int>;
      
      public var uid:int = 0;
      
      public function ShipUpgradeModuleUpdateCommand(param1:int = 0, param2:Vector.<int> = null, param3:int = 0)
      {
         super();
         this.max = param3;
         if(param2 == null)
         {
            this.moduleTypeIds = new Vector.<int>();
         }
         else
         {
            this.moduleTypeIds = param2;
         }
         this.uid = param1;
      }
      
      public static function get instance() : ShipUpgradeModuleUpdateCommand
      {
         return _instance || (_instance = new ShipUpgradeModuleUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -27026;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:int = 0;
         this.max = param1.readInt();
         this.max = this.max >>> 13 % 32 | this.max << 32 - 13 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.moduleTypeIds.length > 0)
         {
            this.moduleTypeIds.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ >>> 1 % 32 | _loc4_ << 32 - 1 % 32;
            this.moduleTypeIds.push(_loc4_);
            _loc2_++;
         }
         this.uid = param1.readInt();
         this.uid = this.uid >>> 3 % 32 | this.uid << 32 - 3 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:int = 0;
         param1.writeShort(-27026);
         param1.writeInt(this.max << 13 % 32 | this.max >>> 32 - 13 % 32);
         param1.writeByte(this.moduleTypeIds.length);
         for each(_loc2_ in this.moduleTypeIds)
         {
            param1.writeInt(_loc2_ << 1 % 32 | _loc2_ >>> 32 - 1 % 32);
         }
         param1.writeInt(this.uid << 3 % 32 | this.uid >>> 32 - 3 % 32);
      }
   }
}

