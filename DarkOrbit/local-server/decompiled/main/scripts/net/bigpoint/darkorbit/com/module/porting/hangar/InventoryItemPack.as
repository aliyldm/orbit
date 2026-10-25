package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class InventoryItemPack implements IModule
   {
      
      private static var _instance:InventoryItemPack;
      
      public var items:Vector.<HangarShipEquipmentInventoryItem>;
      
      public function InventoryItemPack(param1:Vector.<HangarShipEquipmentInventoryItem> = null)
      {
         super();
         if(param1 == null)
         {
            this.items = new Vector.<HangarShipEquipmentInventoryItem>();
         }
         else
         {
            this.items = param1;
         }
      }
      
      public static function get instance() : InventoryItemPack
      {
         return _instance || (_instance = new InventoryItemPack());
      }
      
      public function getLibcomModuleId() : int
      {
         return 18388;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:HangarShipEquipmentInventoryItem = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.items.length > 0)
         {
            this.items.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = HangarShipEquipmentInventoryItem(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.items.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:HangarShipEquipmentInventoryItem = null;
         param1.writeShort(18388);
         param1.writeByte(this.items.length);
         for each(_loc2_ in this.items)
         {
            _loc2_.write(param1);
         }
      }
   }
}

