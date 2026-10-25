package net.bigpoint.darkorbit.mvc.crafting.assembly.model
{
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeContentModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeRemoveCommand;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeStatusUpdateCommand;
   import net.bigpoint.darkorbit.delete_in_eic.InventoryModel;
   import net.bigpoint.darkorbit.delete_in_eic.InventoryProxy;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.AssemblyNotifications;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.view.AssemblyWindowMediator;
   import net.bigpoint.darkorbit.mvc.discount.model.DiscountProxy;
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.model.DOAbstractProxy;
   
   public class AssemblyProxy extends DOAbstractProxy
   {
      
      public static const NAME:String = "AssemblyProxy";
      
      private var _pointer:uint;
      
      private var _buildWaringPointer:uint;
      
      private var _inventory:InventoryModel;
      
      private var _sortOnNextUpdate:Boolean;
      
      private const _inventoryIndex:AssemblyInventoryIndex = new AssemblyInventoryIndex();
      
      private var _indexedRevision:Number = -1;
      
      public function AssemblyProxy()
      {
         super(NAME,new AssemblyModel());
      }
      
      public function get recipes() : AssemblyModel
      {
         return data as AssemblyModel;
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         if(this._inventory != null)
         {
            this._inventory.itemChanged.remove(this.handleItemsChanged);
         }
         this._inventoryIndex.reset();
         this._indexedRevision = -1;
         this._inventory = (retrieveProxy(InventoryProxy.NAME) as InventoryProxy).inventory;
         this._inventory.itemChanged.add(this.handleItemsChanged);
         this.recipes.buildWarning.add(this.triggerBuildWarning);
         var _loc1_:DiscountProxy = retrieveProxy(DiscountProxy.NAME) as DiscountProxy;
         _loc1_.discountRepository.discountChanged.add(this.updateDiscounts);
      }
      
      private function updateDiscounts() : void
      {
         var _loc4_:AssemblyRecipeModel = null;
         var _loc5_:Vector.<AssemblyLootCount> = null;
         var _loc6_:int = 0;
         var _loc7_:AssemblyLootCount = null;
         var _loc8_:int = 0;
         var _loc1_:Vector.<AssemblyRecipeModel> = this.recipes.currentRecipes;
         var _loc2_:int = int(_loc1_.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = _loc1_[_loc3_];
            _loc5_ = _loc4_.ingredients;
            _loc6_ = int(_loc5_.length);
            _loc8_ = 0;
            while(_loc8_ < _loc6_)
            {
               _loc7_ = _loc5_[_loc8_];
               _loc7_.total = ItemDataProviderHelper.getAmountWithDiscount(_loc7_.lootId,_loc7_.originalValue,_loc4_.source);
               _loc8_++;
            }
            _loc3_++;
         }
      }
      
      public function updateFromServer(param1:AssemblyRecipeContentModule) : void
      {
         var _loc5_:AssemblyRecipeModule = null;
         var _loc2_:Vector.<AssemblyRecipeModule> = param1.recipes;
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            this.recipes.update(_loc5_);
            _loc4_++;
         }
         this.refreshRecipes();
      }
      
      public function removeFromServer(param1:AssemblyRecipeRemoveCommand) : void
      {
         this.recipes.removeRecipes(param1.recipes);
         this.refreshRecipes();
      }
      
      public function filterRecipes() : void
      {
         var _loc2_:RecipeUserSettingsFilterProxy = null;
         this.recipes.sortModel();
         this._inventoryIndex.updateRecipeStates(this.recipes.currentRecipes,this._inventory.assemblyChangedItemIds);
         this.handleItemsChanged();
         var _loc1_:Vector.<AssemblyRecipeModel> = this.recipes.currentRecipes.concat();
         if(_loc1_.length <= 0)
         {
            sendNotification(AssemblyNotifications.CHANGE_VIEW,AssemblyWindowMediator.NO_ITEMS_IN_MODEL_VIEW);
         }
         else
         {
            _loc2_ = facade.retrieveProxy(RecipeUserSettingsFilterProxy.NAME) as RecipeUserSettingsFilterProxy;
            _loc1_ = _loc2_.filter(_loc1_);
            sendNotification(AssemblyNotifications.CHANGE_VIEW,_loc1_.length == 0 ? AssemblyWindowMediator.NO_ITEMS_IN_FILTER_VIEW : AssemblyWindowMediator.STANDARD_VIEW);
         }
         sendNotification(AssemblyNotifications.UPDATE_RECIPE_LIST,_loc1_);
      }
      
      public function updateSingleItem(param1:AssemblyRecipeStatusUpdateCommand) : void
      {
         this.recipes.updateStatus(param1);
         this._inventoryIndex.updateRecipeStates(this.recipes.currentRecipes,this._inventory.assemblyChangedItemIds);
         this.handleItemsChanged();
         this.scheduleUpdate();
      }
      
      public function cleanup() : void
      {
         clearTimeout(this._pointer);
         clearTimeout(this._buildWaringPointer);
         this.recipes.cleanup();
         this._inventoryIndex.reset();
         this._indexedRevision = -1;
      }
      
      private function triggerBuildWarning() : void
      {
         clearTimeout(this._buildWaringPointer);
         this._buildWaringPointer = setTimeout(this.sendBuildWarning,10);
      }
      
      private function sendBuildWarning() : void
      {
         sendNotification(AssemblyNotifications.WARNING);
      }
      
      private function refreshRecipes() : void
      {
         this._inventoryIndex.rebuildRecipes(this.recipes.currentRecipes);
         this._inventoryIndex.updateRecipeStates(this.recipes.currentRecipes,this._inventory.assemblyChangedItemIds);
         this.handleItemsChanged();
         this.scheduleUpdate();
      }
      
      private function handleItemsChanged() : void
      {
         var _loc1_:ItemVO = null;
         var _loc2_:Object = null;
         if(this._indexedRevision != this._inventory.assemblyInventoryRevision)
         {
            this._inventoryIndex.reset();
            this._inventoryIndex.rebuildRecipes(this.recipes.currentRecipes);
            this._inventoryIndex.updateRecipeStates(this.recipes.currentRecipes,this._inventory.assemblyChangedItemIds);
            for each(_loc1_ in this._inventory.getAll())
            {
               this._inventoryIndex.updateItem(_loc1_.id,_loc1_);
            }
            this._indexedRevision = this._inventory.assemblyInventoryRevision;
         }
         else
         {
            for(_loc2_ in this._inventory.assemblyChangedItemIds)
            {
               this._inventoryIndex.updateItem(Number(_loc2_),this._inventory.getByItemId(Number(_loc2_)));
            }
         }
         this._inventory.clearAssemblyChanges();
         if(this._inventoryIndex.flush())
         {
            this.scheduleUpdate(1,true);
         }
      }
      
      private function scheduleUpdate(param1:uint = 1, param2:Boolean = false) : void
      {
         clearTimeout(this._pointer);
         this._sortOnNextUpdate = this._sortOnNextUpdate || param2;
         this._pointer = setTimeout(this.filterRecipes,param1);
      }
   }
}

