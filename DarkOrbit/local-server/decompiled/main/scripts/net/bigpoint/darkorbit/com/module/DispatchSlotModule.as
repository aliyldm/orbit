package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DispatchSlotModule implements IModule
   {
      
      private static var _instance:DispatchSlotModule;
      
      public var costList:Vector.<LootModule>;
      
      public var slotId:int = 0;
      
      public function DispatchSlotModule(param1:int = 0, param2:Vector.<LootModule> = null)
      {
         super();
         if(param2 == null)
         {
            this.costList = new Vector.<LootModule>();
         }
         else
         {
            this.costList = param2;
         }
         this.slotId = param1;
      }
      
      public static function get instance() : DispatchSlotModule
      {
         return _instance || (_instance = new DispatchSlotModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -13691;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:LootModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.costList.length > 0)
         {
            this.costList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = LootModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.costList.push(_loc4_);
            _loc2_++;
         }
         this.slotId = param1.readInt();
         this.slotId = this.slotId >>> 12 % 32 | this.slotId << 32 - 12 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:LootModule = null;
         param1.writeShort(-13691);
         param1.writeByte(this.costList.length);
         for each(_loc2_ in this.costList)
         {
            _loc2_.write(param1);
         }
         param1.writeInt(this.slotId << 12 % 32 | this.slotId >>> 32 - 12 % 32);
      }
   }
}

