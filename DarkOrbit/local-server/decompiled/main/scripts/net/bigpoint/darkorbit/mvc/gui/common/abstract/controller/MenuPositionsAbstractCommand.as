package net.bigpoint.darkorbit.mvc.gui.common.abstract.controller
{
   import com.bigpoint.utils.PointLite;
   import com.bigpoint.utils.ui.lists.layoutedList.IListLayout;
   import com.bigpoint.utils.ui.lists.layoutedList.ListLayoutFactory;
   import com.bigpoint.utils.ui.lists.layoutedList.layouts.HorizontalGridLayout;
   import com.bigpoint.utils.ui.lists.layoutedList.layouts.HorizontalListLayout;
   import com.bigpoint.utils.ui.lists.layoutedList.layouts.VerticalGridLayout;
   import com.bigpoint.utils.ui.lists.layoutedList.layouts.VerticallListLayout;
   import com.greensock.TweenMax;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.abstract.view.components.DOAbstractLayoutedListBar;
   import net.bigpoint.darkorbit.mvc.common.utils.ScreenScaleUtils;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.model.AbstractMenuProxy;
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.model.vo.AbstractMenuBarVO;
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.view.AbstractMenuMediator;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.model.vo.slotBar.SlotBarVO;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components.elements.slotAndItemElement.SlotAndItemBarElement;
   
   public class MenuPositionsAbstractCommand extends DOAbstractSimpleCommand
   {
      
      public function MenuPositionsAbstractCommand()
      {
         super();
      }
      
      protected function get stageWidth() : int
      {
         return screenManager.stageWidth;
      }
      
      protected function get stageHeight() : int
      {
         return screenManager.stageHeight;
      }
      
      protected function get stageRectangle() : Rectangle
      {
         return new Rectangle(0,0,this.stageWidth,this.stageHeight);
      }
      
      protected function setInitBarPosition(param1:DOAbstractLayoutedListBar) : void
      {
         var _loc3_:IListLayout = null;
         var _loc4_:PointLite = null;
         var _loc2_:AbstractMenuBarVO = this.menuMediator.menuBarsMap[param1] as AbstractMenuBarVO;
         if(_loc2_)
         {
            _loc3_ = ListLayoutFactory.getLayout(_loc2_.layoutId);
            param1.layoutedList.setLayout(_loc3_);
            _loc4_ = ScreenScaleUtils.getRealPosFromPercentagePos(screenManager.stageSize,new PointLite(param1.realWidth,param1.realHeight),_loc2_.position);
            this.setBarPositionAndLayout(param1,_loc4_.x,_loc4_.y,_loc3_);
         }
      }
      
      protected function updateBarPosition(param1:DOAbstractLayoutedListBar) : void
      {
         var _loc3_:PointLite = null;
         var _loc2_:AbstractMenuBarVO = this.menuMediator.menuBarsMap[param1] as AbstractMenuBarVO;
         if(_loc2_)
         {
            _loc3_ = ScreenScaleUtils.getRealPosFromPercentagePos(screenManager.stageSize,new PointLite(param1.realWidth,param1.realHeight),_loc2_.position);
            param1.x = int(_loc3_.x);
            param1.y = int(_loc3_.y);
         }
      }
      
      protected function resetBarPosition(param1:DOAbstractLayoutedListBar, param2:PointLite) : void
      {
         this.setBarPositionAndLayout(param1,param2.x,param2.y,ListLayoutFactory.getLayout(HorizontalListLayout.ID));
         var _loc3_:PointLite = ScreenScaleUtils.getPercentagePosFromRealPos(screenManager.stageSize,param2,new PointLite(param1.realWidth,param1.realHeight));
         this.updateBarPosAndLayout(param1,_loc3_,HorizontalListLayout.ID);
      }
      
      protected function updateBarPosAndLayout(param1:DOAbstractLayoutedListBar, param2:PointLite = null, param3:String = null) : void
      {
         var _loc4_:AbstractMenuBarVO = this.menuMediator.menuBarsMap[param1] as AbstractMenuBarVO;
         if(_loc4_)
         {
            this.menuMediator.menuBarsMap[param1] = this.menuProxy.updateBarPosAndLayout(_loc4_.id,param2.x,param2.y,param3);
         }
      }
      
      protected function updateBarStickOffset(param1:DOAbstractLayoutedListBar, param2:PointLite) : void
      {
         var _loc3_:SlotBarVO = this.menuMediator.menuBarsMap[param1] as SlotBarVO;
         if(_loc3_)
         {
            this.menuMediator.menuBarsMap[param1] = this.menuProxy.updateStickyOffset(_loc3_.id,param2.x,param2.y);
         }
      }
      
      protected function setBarPositionAndLayout(param1:DOAbstractLayoutedListBar, param2:int, param3:int, param4:IListLayout) : void
      {
         param1.x = param2;
         param1.y = param3;
         if(param4.id == VerticalGridLayout.ID)
         {
            param4.yOffset = 2;
         }
         param1.layoutedList.setLayout(param4,false,false,InGameCatalog.SOUND_ID_UI_SLOT_MOVE);
         var _loc5_:Point = param4.getItemPosition(SlotAndItemBarElement.DEFAULT_SIZE,param1.layoutedList.items.length);
         if(param4 is HorizontalListLayout || param4 is HorizontalGridLayout)
         {
            if(_loc5_.x > param1.layoutedList.listContainer.width)
            {
               _loc5_.x = param1.layoutedList.listContainer.width;
            }
         }
         if(param4 is VerticallListLayout)
         {
            _loc5_.x = param1.layoutedList.listContainer.width;
            _loc5_.y = 0;
         }
         param1.updateOnListLayoutChange(_loc5_,false);
      }
      
      protected function checkBoundsAndSavePositions() : void
      {
         var _loc2_:DOAbstractLayoutedListBar = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:Boolean = true;
         for each(_loc2_ in this.menuMediator.menuBars)
         {
            if(!this.stageRectangle.containsRect(_loc2_.realBounds))
            {
               _loc3_ = Math.max(_loc2_.leftOffset,Math.min(_loc2_.x,this.stageWidth - _loc2_.realBounds.width + _loc2_.leftOffset));
               _loc4_ = Math.max(_loc2_.topOffset,Math.min(_loc2_.y,this.stageHeight - _loc2_.realBounds.height + _loc2_.topOffset));
               _loc1_ = false;
               TweenMax.to(_loc2_,0.3,{
                  "x":_loc3_,
                  "y":_loc4_,
                  "onComplete":this.savePosition,
                  "onCompleteParams":[_loc2_,true]
               });
            }
            this.savePosition(_loc2_);
         }
         sendNotification(GuiNotifications.SAVE_BARS_SETTINGS,_loc1_);
      }
      
      protected function savePosition(param1:DOAbstractLayoutedListBar, param2:Boolean = false) : void
      {
         var _loc4_:String = null;
         var _loc5_:PointLite = null;
         var _loc3_:AbstractMenuBarVO = this.menuMediator.menuBarsMap[param1] as AbstractMenuBarVO;
         if(_loc3_)
         {
            _loc4_ = _loc3_.id;
            _loc5_ = ScreenScaleUtils.getPercentagePosFromRealPos(screenManager.stageSize,new PointLite(param1.x,param1.y),new PointLite(param1.realWidth,param1.realHeight));
            this.menuMediator.menuBarsMap[param1] = this.menuProxy.updateBarPosAndLayout(_loc4_,_loc5_.x,_loc5_.y,param1.layoutedList.layout.id);
            if(param2)
            {
               sendNotification(GuiNotifications.SAVE_BARS_SETTINGS);
            }
         }
      }
      
      protected function get menuProxy() : AbstractMenuProxy
      {
         throw new Error("incorrect access to menuProxy in MenuPositionsAbstractCommand");
      }
      
      protected function get menuMediator() : AbstractMenuMediator
      {
         throw new Error("incorrect access to menuMediator in MenuPositionsAbstractCommand");
      }
   }
}

