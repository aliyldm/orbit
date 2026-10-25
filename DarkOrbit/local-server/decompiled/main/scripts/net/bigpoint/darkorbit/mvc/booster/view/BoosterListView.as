package net.bigpoint.darkorbit.mvc.booster.view
{
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.buttons.checkbox.CheckBox;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListDecorator;
   import net.bigpoint.darkorbit.fui.components.scroll.ScrollEvent;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   
   public class BoosterListView
   {
      
      private var _viewComponent:Container;
      
      public function BoosterListView(param1:Container)
      {
         super();
         this._viewComponent = param1;
         this.list.itemDataAssigner = BoosterListDataAssigner;
         new ItemListDecorator(this.list);
         this.up.addEventListener(MouseEvent.CLICK,this.handleUpClicked);
         this.down.addEventListener(MouseEvent.CLICK,this.handleDownClicked);
         this.top.addEventListener(MouseEvent.CLICK,this.handleTopClicked);
         this.bottom.addEventListener(MouseEvent.CLICK,this.handleBottomClicked);
         this.list.addEventListener(ScrollEvent.SCROLL_POSITION_CHANGED,this.handleScrollPosChanged);
         this.updateScrollButtons();
      }
      
      private function handleScrollPosChanged(param1:ScrollEvent) : void
      {
         this.updateScrollButtons();
      }
      
      public function updateScrollButtons() : void
      {
         this.up.enabled = this.top.enabled = this.list.getScrollPositionInPercent() != 0 && !this.list.allItemsDisplayed();
         this.down.enabled = this.bottom.enabled = this.list.getScrollPositionInPercent() != 1 && !this.list.allItemsDisplayed();
      }
      
      public function updateHeight(param1:Number) : void
      {
         this._viewComponent.height = param1;
         this._viewComponent.forceRedraws([InvalidationType.SIZE,InvalidationType.LAYOUT],true);
         this.updateScrollButtons();
      }
      
      private function handleBottomClicked(param1:MouseEvent) : void
      {
         this.list.setScrollPositionInPercent(1);
      }
      
      private function handleTopClicked(param1:MouseEvent) : void
      {
         this.list.setScrollPositionInPercent(0);
      }
      
      private function handleDownClicked(param1:MouseEvent) : void
      {
         var _loc2_:Number = this.list.getScrollOneItemAmount();
         this.list.setScrollPositionInPercent(this.list.getScrollPositionInPercent() + _loc2_);
      }
      
      private function handleUpClicked(param1:MouseEvent) : void
      {
         var _loc2_:Number = this.list.getScrollOneItemAmount();
         this.list.setScrollPositionInPercent(this.list.getScrollPositionInPercent() - _loc2_);
      }
      
      public function get list() : ItemList
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.boosterList",this._viewComponent) as ItemList;
      }
      
      public function get up() : Button
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.upButtons.up",this._viewComponent) as Button;
      }
      
      public function get top() : Button
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.upButtons.top",this._viewComponent) as Button;
      }
      
      public function get down() : Button
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.downButtons.down",this._viewComponent) as Button;
      }
      
      public function get bottom() : Button
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.downButtons.bottom",this._viewComponent) as Button;
      }
      
      public function get root() : Coreponent
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer",this._viewComponent) as Coreponent;
      }
      
      public function get filter() : CheckBox
      {
         return FuiComponentSelectorUtil.selectComponent("filter",this._viewComponent) as CheckBox;
      }
   }
}

