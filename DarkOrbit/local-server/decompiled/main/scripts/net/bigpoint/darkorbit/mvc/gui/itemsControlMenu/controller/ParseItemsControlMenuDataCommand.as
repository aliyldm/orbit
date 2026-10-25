package net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.controller
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.com.module.MenuCategoryInitializationCommand;
   import net.bigpoint.darkorbit.com.module.MenuInitializationCommand;
   import net.bigpoint.darkorbit.com.module.MenuItemInitializationCommand;
   import net.bigpoint.darkorbit.com.module.MenuItemStatusCommand;
   import net.bigpoint.darkorbit.com.module.SlotBarInitializationCommand;
   import net.bigpoint.darkorbit.com.module.SlotInfoCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.common.utils.ParserUtility;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.model.vo.AbstractMenuBarVO;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.ItemsControlMenuConstants;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.ItemsControlMenuNotifications;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.model.ItemsControlMenuProxy;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.model.vo.ItemTimerVO;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.model.vo.ItemVO;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.model.vo.categoryBar.CategoryBarVO;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.model.vo.categoryBar.CategoryVO;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.model.vo.slotBar.SlotBarVO;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.model.vo.slotBar.SlotVO;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ParseItemsControlMenuDataCommand extends DOAbstractSimpleCommand
   {
      
      private static const SLOTBAR_SLOTS_NUM:int = 10;
      
      public function ParseItemsControlMenuDataCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         this.parseData(param1.getBody() as MenuInitializationCommand);
      }
      
      private function parseData(param1:MenuInitializationCommand) : void
      {
         this.menuProxy.menuBars = new Vector.<AbstractMenuBarVO>();
         this.menuProxy.standartSlotBar = this.menuProxy.premiumSlotBar = this.menuProxy.proActionSlotBar = null;
         this.parseCategories(param1);
         this.parseSlotBars(param1.slotBars);
         sendNotification(ItemsControlMenuNotifications.DATA_READY);
      }
      
      private function parseCategories(param1:MenuInitializationCommand) : void
      {
         var _loc2_:Vector.<CategoryVO> = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:PointLite = null;
         var _loc6_:MenuCategoryInitializationCommand = null;
         var _loc7_:CategoryVO = null;
         if(param1.categories.length)
         {
            _loc2_ = new Vector.<CategoryVO>();
            _loc3_ = int(param1.categories.length);
            _loc4_ = 0;
            while(_loc4_ != _loc3_)
            {
               _loc6_ = param1.categories[_loc4_];
               _loc7_ = new CategoryVO(_loc6_.categoryId,this.createCategoryItem(_loc6_));
               _loc2_.push(_loc7_);
               _loc4_++;
            }
            _loc5_ = ParserUtility.parseStringCords(param1.itemBarPosition)[0];
            this.menuProxy.initCategoryBar(new CategoryBarVO(ItemsControlMenuConstants.CATEGORY_BAR,_loc5_,_loc2_));
         }
         else if(this.menuProxy.categoryBar)
         {
            this.menuProxy.menuBars.push(this.menuProxy.categoryBar);
         }
      }
      
      private function parseSlotBars(param1:Vector.<SlotBarInitializationCommand>) : void
      {
         var _loc4_:SlotBarInitializationCommand = null;
         var _loc5_:Vector.<SlotVO> = null;
         var _loc6_:int = 0;
         var _loc7_:Vector.<PointLite> = null;
         var _loc8_:SlotBarVO = null;
         var _loc9_:SlotInfoCommand = null;
         var _loc10_:ItemVO = null;
         var _loc2_:int = int(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ != _loc2_)
         {
            _loc4_ = param1[_loc3_];
            _loc5_ = new Vector.<SlotVO>();
            _loc6_ = 1;
            while(_loc6_ <= SLOTBAR_SLOTS_NUM)
            {
               _loc9_ = this.getSlotInfoCmdBySlotId(_loc4_.slots,_loc6_);
               _loc10_ = null;
               if(_loc9_)
               {
                  _loc10_ = this.menuProxy.getItemVOByItemId(_loc9_.menuItemId);
               }
               _loc5_.push(new SlotVO(_loc6_,_loc10_,_loc4_.slotBarId));
               _loc6_++;
            }
            _loc7_ = ParserUtility.parseStringCords(_loc4_.slotBarPosition);
            _loc8_ = new SlotBarVO(_loc4_.slotBarId,GuiConstants.LAYOUTS_MAP[int(_loc4_.slotBarOrder)],_loc7_,_loc5_,_loc4_.visible);
            switch(_loc4_.slotBarId)
            {
               case ItemsControlMenuConstants.STANDARD_SLOT_BAR:
                  this.menuProxy.initStandartSlotBar(_loc8_);
                  break;
               case ItemsControlMenuConstants.PREMIUM_SLOT_BAR:
                  this.menuProxy.initPremiumSlotBar(_loc8_);
                  break;
               case ItemsControlMenuConstants.PRO_ACTION_BAR:
                  this.menuProxy.initProActionSlotBar(_loc8_);
            }
            _loc3_++;
         }
      }
      
      private function getSlotInfoCmdBySlotId(param1:Vector.<SlotInfoCommand>, param2:int) : SlotInfoCommand
      {
         var _loc5_:SlotInfoCommand = null;
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ != _loc3_)
         {
            _loc5_ = param1[_loc4_];
            if(_loc5_.slotId == param2)
            {
               return _loc5_;
            }
            _loc4_++;
         }
         return null;
      }
      
      private function createCategoryItem(param1:MenuCategoryInitializationCommand) : Vector.<ItemVO>
      {
         var _loc5_:MenuItemInitializationCommand = null;
         var _loc6_:MenuItemStatusCommand = null;
         var _loc7_:ItemVO = null;
         var _loc2_:int = int(param1.menuItems.length);
         var _loc3_:Vector.<ItemVO> = new Vector.<ItemVO>();
         var _loc4_:int = 0;
         while(_loc4_ != _loc2_)
         {
            _loc5_ = param1.menuItems[_loc4_];
            _loc6_ = _loc5_.status;
            _loc7_ = ItemVO.parse(_loc6_,ItemsControlMenuConstants.COUNTER_TYPES_MAP[_loc5_.counterType],ItemsControlMenuConstants.ACTION_STYLES_MAP[_loc5_.actionStyle],_loc5_.showTooltipCooldownTimer,ItemTimerVO.parseTimer(_loc5_.timer),_loc5_.cooldownGroup.typeValue);
            _loc3_.push(_loc7_);
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function get menuProxy() : ItemsControlMenuProxy
      {
         return facade.retrieveProxy(ItemsControlMenuProxy.NAME) as ItemsControlMenuProxy;
      }
   }
}

