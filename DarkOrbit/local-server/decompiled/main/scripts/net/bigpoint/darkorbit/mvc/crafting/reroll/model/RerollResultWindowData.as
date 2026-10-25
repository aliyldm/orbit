package net.bigpoint.darkorbit.mvc.crafting.reroll.model
{
   import net.bigpoint.darkorbit.com.module.LootModule;
   import net.bigpoint.darkorbit.com.module.UnstableAttributeModule;
   import net.bigpoint.darkorbit.com.module.UnstableModuleModule;
   import net.bigpoint.darkorbit.com.module.UnstableModuleRestabilizeResultCommand;
   import net.bigpoint.darkorbit.delete_in_eic.InventoryModel;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemSelectMode;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyLootCount;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class RerollResultWindowData
   {
      
      public const retainResourceChanged:ISignal = new Signal();
      
      public const resultChanged:ISignal = new Signal();
      
      public var oldModule:UnstableModuleModule;
      
      public var newModule:UnstableModuleModule;
      
      public var retainCostData:Vector.<AssemblyLootCount>;
      
      public var _itemId:int;
      
      private var _canSalvage:Boolean;
      
      public function RerollResultWindowData()
      {
         super();
      }
      
      public function setDummyData(param1:InventoryModel) : *
      {
         this.dummyData(param1);
      }
      
      public function get canSalvage() : Boolean
      {
         return this._canSalvage;
      }
      
      public function updateResult(param1:UnstableModuleRestabilizeResultCommand, param2:InventoryModel) : void
      {
         this.oldModule = param1.oldModule;
         this.newModule = param1.newModule;
         this._itemId = param1.oldModule.itemId;
         this.setRetainData(param2);
         this.resultChanged.dispatch();
      }
      
      private function dummyData(param1:InventoryModel) : void
      {
         var _loc2_:Vector.<UnstableAttributeModule> = null;
         var _loc3_:Vector.<UnstableAttributeModule> = null;
         _loc2_ = new Vector.<UnstableAttributeModule>(0);
         _loc3_ = new Vector.<UnstableAttributeModule>(0);
         this.newModule = new UnstableModuleModule();
         this._itemId = 92309091;
         this.newModule.itemId = 92309091;
         this.newModule.lootId = "equipment_shipupgrade_dmg-xt10";
         this.newModule.recycleReturns = 30;
         var _loc4_:UnstableAttributeModule = new UnstableAttributeModule();
         _loc4_.attribute = "DAMAGE";
         _loc4_.boostValue = 12;
         _loc2_.push(_loc4_);
         _loc4_ = new UnstableAttributeModule();
         _loc4_.attribute = "DMG_LASER";
         _loc4_.boostValue = 7;
         _loc2_.push(_loc4_);
         this.newModule.attributes = _loc2_;
         this.oldModule = new UnstableModuleModule();
         this.oldModule.itemId = 92309091;
         this.oldModule.lootId = "equipment_shipupgrade_dmg-xt10";
         this.oldModule.recycleReturns = 30;
         this.oldModule.retainCost = new Vector.<LootModule>(0);
         var _loc5_:LootModule = new LootModule();
         _loc5_.lootId = "resource_collectable_salvage-core";
         _loc5_.amount = 180;
         this.oldModule.retainCost.push(_loc5_);
         _loc5_ = new LootModule();
         _loc5_.lootId = "resource_collectable_axion-beam-regulator";
         _loc5_.amount = 80;
         this.oldModule.retainCost.push(_loc5_);
         _loc5_ = new LootModule();
         _loc5_.lootId = "resource_collectable_indoctrineoil";
         _loc5_.amount = 20;
         this.oldModule.retainCost.push(_loc5_);
         _loc4_ = new UnstableAttributeModule();
         _loc4_.attribute = "SHIELD_PENETRATION";
         _loc4_.boostValue = 11;
         _loc3_.push(_loc4_);
         _loc4_ = new UnstableAttributeModule();
         _loc4_.attribute = "HITCHANCE_LASER";
         _loc4_.boostValue = 16;
         _loc3_.push(_loc4_);
         this.oldModule.attributes = _loc3_;
         this.setRetainData(param1);
      }
      
      private function setRetainData(param1:InventoryModel) : *
      {
         var _loc4_:ItemVO = null;
         var _loc5_:int = 0;
         var _loc6_:AssemblyLootCount = null;
         var _loc7_:int = 0;
         this.retainCostData = new Vector.<AssemblyLootCount>(0);
         this._canSalvage = true;
         var _loc2_:int = int(this.oldModule.retainCost.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = ItemDataProviderHelper.getItem(this.oldModule.retainCost[_loc3_].lootId);
            if(_loc4_ != null)
            {
               _loc5_ = this.oldModule.retainCost[_loc3_].amount;
               _loc6_ = new AssemblyLootCount(_loc4_,_loc5_,_loc5_);
               _loc7_ = ItemDataProviderHelper.getAmountOfItems(param1.getById(_loc4_.lootID),ItemSelectMode.NOT_EQUIPPED);
               _loc6_.setCount(_loc7_);
               if(_loc7_ < _loc5_)
               {
                  this._canSalvage = false;
               }
               this.retainCostData.push(_loc6_);
            }
            _loc3_++;
         }
      }
   }
}

