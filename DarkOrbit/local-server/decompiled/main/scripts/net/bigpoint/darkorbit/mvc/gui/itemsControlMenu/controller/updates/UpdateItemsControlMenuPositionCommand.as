package net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.controller.updates
{
   import com.bigpoint.utils.PointLite;
   import com.bigpoint.utils.ui.lists.layoutedList.ListLayoutFactory;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.abstract.view.components.DOAbstractLayoutedListBar;
   import net.bigpoint.darkorbit.mvc.common.utils.ScreenScaleUtils;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.controller.MenuPositionsAbstractCommand;
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.model.AbstractMenuProxy;
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.view.AbstractMenuMediator;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.ItemsControlMenuConstants;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.model.ItemsControlMenuProxy;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.model.vo.slotBar.SlotBarVO;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.MenuBarsMediator;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components.ItemsControlMenu;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components.elements.slotAndItemElement.SlotAndItemBarElement;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components.menuBar.MenuBar;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class UpdateItemsControlMenuPositionCommand extends MenuPositionsAbstractCommand
   {
      
      public function UpdateItemsControlMenuPositionCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:String = null;
         if(this.menuProxy.menuBars)
         {
            _loc2_ = String(param1.getBody());
            switch(_loc2_)
            {
               case GuiConstants.SET_MENUS_INIT_POSITION:
                  setInitBarPosition(this.itemControlMenu.categoryBar);
                  this.setInitSlotBarPosition(this.itemControlMenu.standardSlotBar);
                  this.setInitSlotBarPosition(this.itemControlMenu.proActionBar);
                  this.setInitSlotBarPosition(this.itemControlMenu.premiumSlotBar);
                  break;
               case GuiConstants.CONFIG_RESET_AND_EXIT:
                  this.resetAllBarsPositions();
                  break;
               default:
                  this.updateMenuPosistions();
            }
         }
      }
      
      private function setInitSlotBarPosition(param1:MenuBar) : void
      {
         var _loc2_:SlotBarVO = this.menuMediator.menuBarsMap[param1] as SlotBarVO;
         if(_loc2_)
         {
            if(Boolean(_loc2_.stickOffset.x) || Boolean(_loc2_.stickOffset.y))
            {
               setBarPositionAndLayout(param1,this.itemControlMenu.categoryBar.x + _loc2_.stickOffset.x,this.itemControlMenu.categoryBar.y + _loc2_.stickOffset.y,ListLayoutFactory.getLayout(_loc2_.layoutId));
            }
            else
            {
               setInitBarPosition(param1);
            }
         }
      }
      
      private function updateMenuPosistions() : void
      {
         var _loc1_:MenuBar = this.itemControlMenu.categoryBar;
         var _loc2_:PointLite = new PointLite(_loc1_.boundsWidth,_loc1_.boundsHeight);
         var _loc3_:PointLite = new PointLite(_loc1_.x,_loc1_.y);
         updateBarPosition(_loc1_);
         var _loc4_:PointLite = new PointLite(_loc1_.x,_loc1_.y);
         this.updateSlotBarPosition(this.itemControlMenu.standardSlotBar,_loc2_,_loc3_,_loc4_);
         this.updateSlotBarPosition(this.itemControlMenu.proActionBar,_loc2_,_loc3_,_loc4_);
         this.updateSlotBarPosition(this.itemControlMenu.premiumSlotBar,_loc2_,_loc3_,_loc4_);
      }
      
      private function updateSlotBarPosition(param1:MenuBar, param2:PointLite, param3:PointLite, param4:PointLite) : void
      {
         var _loc5_:PointLite = new PointLite(param1.boundsWidth,param1.boundsHeight);
         var _loc6_:PointLite = ScreenScaleUtils.getStickedBarOffset(new PointLite(param1.x,param1.y),_loc5_,param3,param2);
         if(_loc6_)
         {
            updateBarStickOffset(param1,_loc6_);
            param1.x = param4.x + _loc6_.x;
            param1.y = param4.y + _loc6_.y;
         }
         else
         {
            updateBarStickOffset(param1,new PointLite());
            updateBarPosition(param1);
         }
      }
      
      private function resetAllBarsPositions() : void
      {
         var _loc5_:DOAbstractLayoutedListBar = null;
         var _loc1_:Number = (screenManager.stageHeight - ScreenManager.MIN_SCREEN_HEIGHT) / screenManager.stageHeight;
         var _loc2_:Number = ItemsControlMenuConstants.MENU_BOTTOM_MARGIN * _loc1_;
         var _loc3_:int = stageWidth - MenuBar.DEFAULT_BAR_WIDTH >> 1;
         var _loc4_:int = stageHeight - _loc2_;
         for each(_loc5_ in this.menuMediator.menuBars)
         {
            _loc4_ -= SlotAndItemBarElement.DEFAULT_SIZE;
            resetBarPosition(_loc5_,new PointLite(_loc3_,_loc4_));
         }
      }
      
      override protected function get menuProxy() : AbstractMenuProxy
      {
         return retrieveProxy(ItemsControlMenuProxy.NAME) as AbstractMenuProxy;
      }
      
      protected function get itemControlMenu() : ItemsControlMenu
      {
         return (this.menuMediator as MenuBarsMediator).view;
      }
      
      override protected function get menuMediator() : AbstractMenuMediator
      {
         return retrieveMediator(MenuBarsMediator.NAME) as AbstractMenuMediator;
      }
   }
}

