package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class HangarShipSellItemRequest implements IModule
   {
      
      private static var _instance:HangarShipSellItemRequest;
      
      public var itemList:Vector.<InventoryItemSellPack>;
      
      public function HangarShipSellItemRequest(param1:Vector.<InventoryItemSellPack> = null)
      {
         super();
         if(param1 == null)
         {
            this.itemList = new Vector.<InventoryItemSellPack>();
         }
         else
         {
            this.itemList = param1;
         }
      }
      
      public static function get instance() : HangarShipSellItemRequest
      {
         return _instance || (_instance = new HangarShipSellItemRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 21806;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:InventoryItemSellPack = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.itemList.length > 0)
         {
            this.itemList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = InventoryItemSellPack(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.itemList.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:InventoryItemSellPack = null;
         param1.writeShort(21806);
         param1.writeByte(this.itemList.length);
         for each(_loc2_ in this.itemList)
         {
            _loc2_.write(param1);
         }
      }
   }
}

