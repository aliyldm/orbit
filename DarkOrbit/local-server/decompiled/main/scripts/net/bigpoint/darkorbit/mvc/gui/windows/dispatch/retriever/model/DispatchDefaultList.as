package net.bigpoint.darkorbit.mvc.gui.windows.dispatch.retriever.model
{
   import net.bigpoint.darkorbit.com.module.DispatchGetRetrieverListCommand;
   import net.bigpoint.darkorbit.com.module.DispatchModule;
   import net.bigpoint.darkorbit.com.module.DispatchSlotCostCommand;
   import net.bigpoint.darkorbit.com.module.DispatchSlotModule;
   import net.bigpoint.darkorbit.com.module.LootModule;
   
   public class DispatchDefaultList
   {
      
      public function DispatchDefaultList()
      {
         super();
      }
      
      public static function getRetrieverList() : DispatchGetRetrieverListCommand
      {
         var _loc2_:DispatchModule = null;
         var _loc1_:DispatchGetRetrieverListCommand = new DispatchGetRetrieverListCommand();
         _loc1_.statusType = DispatchGetRetrieverListCommand.STATUSTYPE_AVAILABLE;
         _loc2_ = new DispatchModule(1,10800,0);
         _loc1_.retrieverList.push(_loc2_);
         _loc2_ = new DispatchModule(2,21600,0);
         _loc1_.retrieverList.push(_loc2_);
         _loc2_ = new DispatchModule(3,21600,0);
         _loc1_.retrieverList.push(_loc2_);
         _loc2_ = new DispatchModule(4,32400,0);
         _loc1_.retrieverList.push(_loc2_);
         _loc2_ = new DispatchModule(5,43200,0);
         _loc1_.retrieverList.push(_loc2_);
         _loc2_ = new DispatchModule(6,43200,0);
         _loc1_.retrieverList.push(_loc2_);
         _loc2_ = new DispatchModule(7,10800,0);
         _loc1_.retrieverList.push(_loc2_);
         _loc2_ = new DispatchModule(8,21600,0);
         _loc1_.retrieverList.push(_loc2_);
         _loc2_ = new DispatchModule(9,21600,0);
         _loc1_.retrieverList.push(_loc2_);
         _loc2_ = new DispatchModule(10,32400,0);
         _loc1_.retrieverList.push(_loc2_);
         _loc2_ = new DispatchModule(11,43200,0);
         _loc1_.retrieverList.push(_loc2_);
         _loc2_ = new DispatchModule(12,43200,0);
         _loc1_.retrieverList.push(_loc2_);
         _loc2_ = new DispatchModule(19,18000,0);
         _loc1_.retrieverList.push(_loc2_);
         _loc2_ = new DispatchModule(20,25200,0);
         _loc1_.retrieverList.push(_loc2_);
         _loc2_ = new DispatchModule(21,32400,0);
         _loc1_.retrieverList.push(_loc2_);
         _loc2_ = new DispatchModule(13,10800,0);
         _loc1_.retrieverList.push(_loc2_);
         _loc2_ = new DispatchModule(14,21600,0);
         _loc1_.retrieverList.push(_loc2_);
         _loc2_ = new DispatchModule(15,21600,0);
         _loc1_.retrieverList.push(_loc2_);
         _loc2_ = new DispatchModule(16,32400,0);
         _loc1_.retrieverList.push(_loc2_);
         _loc2_ = new DispatchModule(17,43200,0);
         _loc1_.retrieverList.push(_loc2_);
         _loc2_ = new DispatchModule(18,43200,0);
         _loc1_.retrieverList.push(_loc2_);
         return _loc1_;
      }
      
      public static function getSlotCost() : DispatchSlotCostCommand
      {
         var _loc2_:DispatchSlotModule = null;
         var _loc1_:DispatchSlotCostCommand = new DispatchSlotCostCommand();
         _loc2_ = new DispatchSlotModule();
         _loc2_.slotId = 1;
         _loc2_.costList.push(new LootModule("currency_uridium",0));
         _loc1_.slotCosts.push(_loc2_);
         _loc2_ = new DispatchSlotModule();
         _loc2_.slotId = 2;
         _loc2_.costList.push(new LootModule("currency_uridium",0));
         _loc1_.slotCosts.push(_loc2_);
         _loc2_ = new DispatchSlotModule();
         _loc2_.slotId = 3;
         _loc2_.costList.push(new LootModule("currency_uridium",50000));
         _loc1_.slotCosts.push(_loc2_);
         _loc2_ = new DispatchSlotModule();
         _loc2_.slotId = 4;
         _loc2_.costList.push(new LootModule("currency_uridium",100000));
         _loc1_.slotCosts.push(_loc2_);
         _loc2_ = new DispatchSlotModule();
         _loc2_.slotId = 5;
         _loc2_.costList.push(new LootModule("currency_uridium",100000));
         _loc1_.slotCosts.push(_loc2_);
         return _loc1_;
      }
   }
}

