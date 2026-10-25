package net.bigpoint.darkorbit.mvc.gui.windows.armoryUnlock
{
   import net.bigpoint.darkorbit.com.module.porting.armoryunlock.ArmoryUnlockLootShowCommand;
   import net.bigpoint.darkorbit.com.module.porting.armoryunlock.ArmoryUnlockLootShowListCommand;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.map.model.ship.patterns.ShipPattern;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   
   public class ArmoryUnlockTab extends SimpleWindowMediator
   {
      
      protected var cardsContainer:Coreponent;
      
      private var allCards:Vector.<ArmoryUnlockCard> = new Vector.<ArmoryUnlockCard>();
      
      public function ArmoryUnlockTab(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
      }
      
      private function clearAllCards() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.allCards.length)
         {
            this.cardsContainer.removeChild(this.allCards[_loc1_]);
            this.allCards[_loc1_].recover();
            _loc1_++;
         }
         this.allCards.length = 0;
      }
      
      public function updateData0(param1:ArmoryUnlockLootShowListCommand) : void
      {
         var _loc2_:ShipPattern = null;
         var _loc10_:ArmoryUnlockLootShowCommand = null;
         var _loc11_:Array = null;
         var _loc12_:int = 0;
         var _loc13_:ArmoryUnlockLootShowCommand = null;
         var _loc14_:ItemVO = null;
         var _loc15_:ArmoryUnlockCard = null;
         this.clearAllCards();
         if(Boolean(param1.shipLootId) && param1.shipLootId.length > 0)
         {
            _loc2_ = PatternManager.shipPatterns[param1.shipLootId] as ShipPattern;
         }
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         var _loc5_:Array = [];
         var _loc6_:Array = [_loc3_,_loc4_,_loc5_];
         var _loc7_:* = param1.showLootCommandList;
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_.length)
         {
            _loc10_ = _loc7_[_loc8_];
            _loc6_[_loc10_.line - 1].push(_loc10_);
            _loc8_++;
         }
         var _loc9_:int = 0;
         while(_loc9_ < 3)
         {
            _loc11_ = _loc6_[_loc9_];
            _loc12_ = (ArmoryUnlockCard.ww * 6 - _loc11_.length * ArmoryUnlockCard.ww) / 2;
            _loc8_ = 0;
            while(_loc8_ < _loc11_.length)
            {
               _loc13_ = _loc11_[_loc8_] as ArmoryUnlockLootShowCommand;
               _loc14_ = ItemDataProviderHelper.getItem(_loc13_.lootId);
               _loc15_ = ArmoryUnlockCard.GetCard(_loc13_.bg);
               this.cardsContainer.addChild(_loc15_);
               _loc15_.x = _loc12_ + _loc8_ * ArmoryUnlockCard.ww;
               _loc15_.y = _loc9_ * ArmoryUnlockCard.hh;
               this.allCards.push(_loc15_);
               _loc15_.setData(_loc14_,_loc13_.lootAmount,_loc13_.showShipIcon ? _loc2_ : null);
               _loc8_++;
            }
            _loc9_++;
         }
      }
   }
}

