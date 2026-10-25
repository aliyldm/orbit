package net.bigpoint.darkorbit.mvc.gui.windows.armoryUnlock.tab3
{
   import net.bigpoint.darkorbit.com.module.porting.armoryunlock.ArmoryUnlockClaimInfoCommand;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.map.model.ship.patterns.ShipPattern;
   import net.bigpoint.darkorbit.mvc.gui.windows.armoryUnlock.handler.ArmoryUnlockInfoData;
   import net.bigpoint.darkorbit.mvc.gui.windows.armoryUnlock.handler.ArmoryUnlockShipData;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   
   public class ArmoryUnlockTab3Mediator extends SimpleWindowMediator
   {
      
      private var _view:ArmoryUnlockTab3View;
      
      private var availableExchangeItemList:ItemList;
      
      private var shipName:Label;
      
      public function ArmoryUnlockTab3Mediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
      }
      
      public function setView(param1:ArmoryUnlockTab3View) : void
      {
         this._view = param1;
         this.availableExchangeItemList = param1.availableExchangeItemList;
         this.availableExchangeItemList.itemDataAssigner = ArmoryUnlockTab3DataAssigner;
         this.shipName = param1.shipName;
      }
      
      public function updateData(param1:ArmoryUnlockInfoData) : void
      {
         var _loc2_:Vector.<ArmoryUnlockClaimInfoCommand> = null;
         var _loc3_:ArmoryUnlockShipData = null;
         var _loc4_:int = 0;
         if(!param1)
         {
            return;
         }
         if(Boolean(param1.shipList) && param1.shipList.length > 0)
         {
            _loc4_ = param1.selectionLocked && param1.lockedShipIndex >= 0 ? param1.lockedShipIndex : param1.selectedShipIndex;
            if(_loc4_ < 0 || _loc4_ >= param1.shipList.length)
            {
               _loc4_ = 0;
            }
            _loc3_ = param1.shipList[_loc4_];
            if(_loc3_)
            {
               _loc2_ = _loc3_.itemList;
               if((!_loc2_ || _loc2_.length == 0) && _loc3_.group == param1.selectedGroup)
               {
                  _loc2_ = param1.selectedClaimInfoGroupCommand;
               }
            }
         }
         if(!_loc2_)
         {
            _loc2_ = param1.selectedClaimInfoGroupCommand;
         }
         if(!_loc2_)
         {
            _loc2_ = param1.claimInfoCommandList;
         }
         this.shipName.text = _loc3_ ? this.getShipName(_loc3_.shipLootId) : "Selected ship rewards";
         this.availableExchangeItemList.list = new VectorCollection(_loc2_ ? _loc2_ : new Vector.<ArmoryUnlockClaimInfoCommand>());
      }
      
      private function getShipName(param1:String) : String
      {
         if(!param1 || param1.length == 0)
         {
            return "Selected ship rewards";
         }
         var _loc2_:ShipPattern = PatternManager.shipPatterns[param1] as ShipPattern;
         if(Boolean(_loc2_) && Boolean(_loc2_.name))
         {
            return _loc2_.name;
         }
         var _loc3_:ItemVO = ItemDataProviderHelper.getItem(param1);
         return Boolean(_loc3_) && Boolean(_loc3_.fullname) ? _loc3_.fullname : param1;
      }
   }
}

