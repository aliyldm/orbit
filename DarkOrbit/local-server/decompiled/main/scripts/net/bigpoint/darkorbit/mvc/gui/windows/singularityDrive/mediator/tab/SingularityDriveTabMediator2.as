package net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.mediator.tab
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.com.module.UnstableAttributeModule;
   import net.bigpoint.darkorbit.com.module.porting.lockattributeitem.LockAttributeItemModule;
   import net.bigpoint.darkorbit.com.module.porting.lockattributeitem.LockAttributeItemRerollRequest;
   import net.bigpoint.darkorbit.delete_in_eic.InventoryProxy;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyLootCount;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.TargetItemRecipeModel;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.model.UpgradeRecipeItemPair;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.model.SingularityDriveProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.model.SingularityDriveStats;
   import net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.view.tab.SingularityDriveTab2;
   
   public class SingularityDriveTabMediator2 extends SimpleWindowMediator
   {
      
      private var _view:SingularityDriveTab2;
      
      private var _currentModel:LockAttributeItemModule;
      
      public function SingularityDriveTabMediator2(param1:String, param2:IWindow)
      {
         super(param1,param2);
      }
      
      public function setView(param1:SingularityDriveTab2) : void
      {
         this._view = param1;
         this._view.statsContainer.addEventListener(Event.CHANGE,this.onLockChangeHandler);
         this._view.button.addEventListener(MouseEvent.CLICK,this.onRerollHandler);
      }
      
      public function update() : void
      {
      }
      
      private function onRerollHandler(param1:MouseEvent) : void
      {
         var _loc2_:Vector.<int> = SingularityDriveProxy.getProxy().getLockDataByItemID(this._currentModel.itemId);
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new LockAttributeItemRerollRequest(this._currentModel.itemId,_loc2_));
      }
      
      public function setModule(param1:UpgradeRecipeItemPair, param2:TargetItemRecipeModel) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:SingularityDriveStats = null;
         this._currentModel = SingularityDriveProxy.getProxy().getVIewData().getModuleByItemId(param1.item.id);
         if(!this._currentModel)
         {
            return;
         }
         if(this._currentModel.lockAttributeLevels.length - this._currentModel.attributes.length > 0)
         {
            _loc5_ = this._currentModel.lockAttributeLevels.length - this._currentModel.attributes.length;
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               this._currentModel.attributes.push(new UnstableAttributeModule());
               _loc4_++;
            }
         }
         var _loc3_:Vector.<SingularityDriveStats> = new Vector.<SingularityDriveStats>();
         _loc4_ = 0;
         while(_loc4_ < this._currentModel.lockAttributeLevels.length)
         {
            _loc6_ = new SingularityDriveStats();
            _loc6_.index = _loc4_;
            _loc6_.itemID = this._currentModel.itemId;
            _loc6_.attribute = this._currentModel.attributes[_loc4_].attribute;
            _loc6_.boostValue = this._currentModel.attributes[_loc4_].boostValue;
            _loc6_.unlockLevel = this._currentModel.lockAttributeLevels[_loc4_];
            _loc3_.push(_loc6_);
            _loc4_++;
         }
         this._view.statsList.list = new VectorCollection(_loc3_);
         this.updateCost();
      }
      
      private function onLockChangeHandler(param1:Event) : void
      {
         this.updateCost();
      }
      
      private function updateCost() : void
      {
         var _loc7_:AssemblyLootCount = null;
         var _loc8_:ItemVO = null;
         var _loc10_:Vector.<ItemVO> = null;
         var _loc11_:UnstableAttributeModule = null;
         var _loc12_:Number = NaN;
         var _loc13_:int = 0;
         var _loc1_:Vector.<AssemblyLootCount> = new Vector.<AssemblyLootCount>();
         var _loc2_:Boolean = true;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         while(_loc5_ < this._currentModel.attributes.length)
         {
            _loc11_ = this._currentModel.attributes[_loc5_];
            if(_loc11_.attribute != "")
            {
               _loc3_++;
            }
            _loc5_++;
         }
         var _loc6_:Vector.<int> = SingularityDriveProxy.getProxy().getLockDataByItemID(this._currentModel.itemId);
         _loc4_ = int(_loc6_.length);
         var _loc9_:InventoryProxy = retrieveProxy(InventoryProxy.NAME) as InventoryProxy;
         if(_loc3_ != 0)
         {
            _loc8_ = ItemDataProviderHelper.getItem(this._currentModel.restabilizeCostLoot);
            _loc7_ = new AssemblyLootCount(_loc8_,this._currentModel.restabilizeCostLootAmounts[_loc3_ - 1],this._currentModel.restabilizeCostLootAmounts[_loc3_ - 1]);
            _loc10_ = _loc9_.inventory.getById(this._currentModel.restabilizeCostLoot);
            if((Boolean(_loc10_)) && _loc10_.length > 0)
            {
               _loc7_.setCount(_loc10_[0].amount);
            }
            else
            {
               _loc7_.setCount(0);
            }
            _loc12_ = _loc7_.count.value;
            _loc13_ = _loc7_.total;
            _loc2_ = _loc12_ < _loc13_;
            _loc1_.push(_loc7_);
         }
         if(_loc4_ > 0)
         {
            _loc8_ = ItemDataProviderHelper.getItem(this._currentModel.lockCostLoot);
            _loc7_ = new AssemblyLootCount(_loc8_,this._currentModel.lockCostLootAmounts[_loc4_ - 1],this._currentModel.lockCostLootAmounts[_loc4_ - 1]);
            _loc10_ = _loc9_.inventory.getById(this._currentModel.lockCostLoot);
            if((Boolean(_loc10_)) && _loc10_.length > 0)
            {
               _loc7_.setCount(_loc10_[0].amount);
            }
            else
            {
               _loc7_.setCount(0);
            }
            _loc12_ = _loc7_.count.value;
            _loc13_ = _loc7_.total;
            _loc2_ = _loc12_ < _loc13_;
            _loc1_.push(_loc7_);
         }
         this._view.button.enabled = !_loc2_;
         this._view.costsList.list = new VectorCollection(_loc1_);
      }
   }
}

