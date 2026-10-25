package net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.shop.model
{
   import net.bigpoint.darkorbit.com.module.InventoryItemModule;
   import net.bigpoint.darkorbit.com.module.porting.shop.exchange.ExchangesShopItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class StrikeAndExitShopProxy extends SimpleWindowProxy
   {
      
      public function StrikeAndExitShopProxy(param1:String)
      {
         super(param1,new StrikeAndExitShopData());
      }
      
      public function get viewData() : StrikeAndExitShopData
      {
         return data as StrikeAndExitShopData;
      }
      
      public function updateShop(param1:String, param2:String, param3:Vector.<InventoryItemModule>, param4:Vector.<ExchangesShopItem>, param5:Boolean = false, param6:Boolean = false, param7:int = 0) : void
      {
         this.viewData.updateShop(param1,param2,param3,param4,param5,param6,param7);
      }
   }
}

