package net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.controller.updates
{
   import net.bigpoint.darkorbit.com.module.MenuItemCooldownGroupTimerCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.model.ItemsControlMenuProxy;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.model.vo.ItemTimerVO;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.model.vo.ItemVO;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.model.vo.categoryBar.CategoryVO;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.ItemsControlMenuMediator;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components.elements.slotAndItemElement.SlotAndItemBarElement;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class UpdateMenuItemCooldownGroupTimerCommand extends DOAbstractSimpleCommand
   {
      
      public function UpdateMenuItemCooldownGroupTimerCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:MenuItemCooldownGroupTimerCommand = param1.getBody() as MenuItemCooldownGroupTimerCommand;
         if(this.menuProxy)
         {
            this.updateModel(_loc2_);
            this.updateView(_loc2_);
         }
      }
      
      public function updateModel(param1:MenuItemCooldownGroupTimerCommand) : void
      {
         var _loc4_:CategoryVO = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:ItemVO = null;
         var _loc8_:ItemTimerVO = null;
         if(this.menuProxy.categoryBar == null)
         {
            return;
         }
         var _loc2_:int = int(this.menuProxy.categoryBar.categories.length);
         var _loc3_:int = 0;
         while(_loc3_ != _loc2_)
         {
            _loc4_ = this.menuProxy.categoryBar.categories[_loc3_];
            _loc5_ = int(_loc4_.items.length);
            _loc6_ = 0;
            while(_loc6_ != _loc5_)
            {
               _loc7_ = _loc4_.items[_loc6_];
               if(_loc7_.cooldownGroupType == param1.cooldownType.typeValue)
               {
                  _loc8_ = ItemTimerVO.parseCooldownGroupTimer(param1);
                  _loc4_.items[_loc6_].timerVO = _loc8_;
               }
               _loc6_++;
            }
            _loc3_++;
         }
      }
      
      private function updateView(param1:MenuItemCooldownGroupTimerCommand) : void
      {
         var _loc9_:SlotAndItemBarElement = null;
         var _loc10_:SlotAndItemBarElement = null;
         var _loc2_:int = param1.cooldownType.typeValue;
         var _loc3_:Vector.<SlotAndItemBarElement> = this.menuMediator.getItemBarElementsByCooldownType(_loc2_);
         var _loc4_:int = int(_loc3_.length);
         var _loc5_:int = 0;
         while(_loc5_ != _loc4_)
         {
            _loc9_ = _loc3_[_loc5_];
            _loc9_.updateTimerAndActivatable();
            _loc5_++;
         }
         var _loc6_:Vector.<SlotAndItemBarElement> = this.menuMediator.getSlotBarsItemElementsByCooldownType(_loc2_);
         var _loc7_:int = int(_loc6_.length);
         var _loc8_:int = 0;
         while(_loc8_ != _loc7_)
         {
            _loc10_ = _loc6_[_loc8_];
            _loc10_.updateTimerAndActivatable();
            _loc8_++;
         }
      }
      
      private function get menuMediator() : ItemsControlMenuMediator
      {
         return facade.retrieveMediator(ItemsControlMenuMediator.NAME) as ItemsControlMenuMediator;
      }
      
      protected function get menuProxy() : ItemsControlMenuProxy
      {
         return facade.retrieveProxy(ItemsControlMenuProxy.NAME) as ItemsControlMenuProxy;
      }
   }
}

