package net.bigpoint.darkorbit.equipment.view.components.tooltip.preparation
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInstanceVO;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemLocalisationKeys;
   import net.bigpoint.darkorbit.equipment.view.components.items.InventoryItemComponent;
   
   public class TooltipPreparerFactory
   {
      
      public function TooltipPreparerFactory()
      {
         super();
      }
      
      public static function create(param1:InventoryItemComponent) : ITooltipPreparer
      {
         var _loc2_:ITooltipPreparer = null;
         var _loc3_:ItemInstanceVO = param1.getItemInstanceData();
         if(param1.isModule())
         {
            _loc2_ = createModuleTooltipPreparer(param1);
         }
         else if(param1.multiSellItem)
         {
            _loc2_ = createMultiSellTooltipPreparer(param1);
         }
         else if(_loc3_ != null && _loc3_.isShipUpgrade())
         {
            _loc2_ = createShipUpgradeTooltipPreparer(param1);
         }
         else if(_loc3_ != null && param1.setBonus)
         {
            _loc2_ = createSetBonusTooltipPreparer(param1);
         }
         else
         {
            _loc2_ = createDefaultTooltipPreparer(param1);
         }
         return _loc2_;
      }
      
      private static function createDefaultTooltipPreparer(param1:InventoryItemComponent) : ITooltipPreparer
      {
         var _loc2_:ItemInstanceVO = param1.getItemInstanceData();
         var _loc3_:Dictionary = _loc2_.itemInfo.loka;
         return new DefaultTooltipPreparer(_loc3_[ItemLocalisationKeys.LOCA_FULLNAME],_loc3_[ItemLocalisationKeys.LOCA_SHORT_NAME],_loc2_.quantity,_loc2_.durability,_loc2_.levelText,_loc2_.charges,_loc2_.damageLevel,_loc2_.shieldLevel);
      }
      
      private static function createModuleTooltipPreparer(param1:InventoryItemComponent) : ITooltipPreparer
      {
         return new ModuleTooltipPreparer(param1);
      }
      
      private static function createMultiSellTooltipPreparer(param1:InventoryItemComponent) : ITooltipPreparer
      {
         return new MultiSellTooltipPreparer(param1);
      }
      
      private static function createShipUpgradeTooltipPreparer(param1:InventoryItemComponent) : ITooltipPreparer
      {
         return new ShipUpgradeTooltipPreparer(param1);
      }
      
      private static function createSetBonusTooltipPreparer(param1:InventoryItemComponent) : ITooltipPreparer
      {
         return new SetBonusTooltipPreparer(param1);
      }
   }
}

