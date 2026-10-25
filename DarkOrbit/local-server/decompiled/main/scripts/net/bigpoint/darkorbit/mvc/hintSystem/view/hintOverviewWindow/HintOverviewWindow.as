package net.bigpoint.darkorbit.mvc.hintSystem.view.hintOverviewWindow
{
   import com.greensock.TweenLite;
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.scroll.ScrollContainer;
   import net.bigpoint.darkorbit.fui.components.scroll.ScrollEvent;
   import net.bigpoint.darkorbit.fui.components.scroll.Scrollbar;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.IHintSystemContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.view.hintOverviewWindow.components.HintSystemOverlistItemRenderer;
   import net.bigpoint.darkorbit.mvc.hintSystem.view.hintOverviewWindow.components.HintSystemOverlistItemRendererEvent;
   import net.bigpoint.darkorbit.mvc.hintSystem.view.hintOverviewWindow.components.HintSystemOverlistItemRendererSkin;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class HintOverviewWindow extends EventDispatcher
   {
      
      private static const ITEMLIST_CLICK_DELAY_IN_SEC:Number = 0.3;
      
      private var _content:Sprite;
      
      private var overviewContainer:Container;
      
      private var scrollContainer:ScrollContainer;
      
      private var scrollContent:Coreponent;
      
      private var scrollbar:Scrollbar;
      
      public function HintOverviewWindow()
      {
         super();
      }
      
      public function build(param1:Sprite, param2:Object = null) : void
      {
         var _loc3_:Container = null;
         if(this._content == null)
         {
            this._content = param1;
            UISystem.getInstance().build(param2,this._content);
            this.overviewContainer = this._content.getChildByName("hintOverviewContainer") as Container;
            this.overviewContainer.mouseEnabled = false;
            _loc3_ = this.overviewContainer.getChildByName("overviewListContainer") as Container;
            this.scrollContainer = _loc3_.getChildByName("scrollContainer") as ScrollContainer;
            this.scrollContainer.addEventListener(MouseEvent.MOUSE_WHEEL,this.handleScrollContainerMouseWheelEvent);
            this.scrollContainer.addEventListener(ScrollEvent.SCROLLCONTAINER_VERTICAL_SIZE_CHANGED,this.handleScrollContainerVerticalScrollDeltaChangeEvent);
            this.scrollContent = this.scrollContainer.content as Coreponent;
            this.scrollbar = _loc3_.getChildByName("scrollbar") as Scrollbar;
            this.scrollbar.addEventListener(ScrollEvent.SCROLL_POSITION_CHANGED,this.handleScrollbarPositionChangeEvent);
         }
      }
      
      private function handleScrollbarPositionChangeEvent(param1:ScrollEvent) : void
      {
         this.updateScrollContainerScrollPosition();
      }
      
      private function updateScrollContainerScrollPosition() : void
      {
         var _loc1_:Number = this.scrollbar.getScrollPositionInPercent();
         this.scrollContainer.setScrollPositionInPercent(_loc1_);
      }
      
      private function handleScrollContainerMouseWheelEvent(param1:MouseEvent) : void
      {
         this.scrollbar.updateScrollPositionByScrollDelta(param1.delta);
      }
      
      private function handleScrollContainerVerticalScrollDeltaChangeEvent(param1:ScrollEvent) : void
      {
         param1.contentSize = this.scrollContent.getExplicitHeight();
         this.scrollbar.updateBySizes(param1.viewSize,param1.contentSize);
      }
      
      protected function handleListItemClicked(param1:MouseEvent) : void
      {
         var _loc2_:Coreponent = param1.target as Coreponent;
         var _loc3_:uint = _loc2_.data as uint;
         TweenLite.killDelayedCallsTo(this.listItemClickAction);
         TweenLite.delayedCall(ITEMLIST_CLICK_DELAY_IN_SEC,this.listItemClickAction,[_loc3_]);
      }
      
      protected function listItemClickAction(param1:uint) : void
      {
         dispatchEvent(new HintSystemOverlistItemRendererEvent(HintSystemOverlistItemRendererEvent.ITEM_CLICKED,param1));
      }
      
      public function set list(param1:Vector.<IHintSystemContentDescription>) : void
      {
         this.removeAllChildren(this.scrollContent);
         this.createListItems(param1,this.scrollContent);
         this.scrollContainer.invalidate(InvalidationType.SIZE);
      }
      
      protected function removeAllChildren(param1:Sprite) : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:Coreponent = null;
         while(param1.numChildren > 0)
         {
            _loc2_ = param1.getChildAt(0) as Sprite;
            _loc3_ = _loc2_ as Coreponent;
            if(_loc3_)
            {
               _loc3_.dispose();
            }
            else
            {
               MovieClipUtils.removeDisplayObject(_loc2_);
            }
         }
      }
      
      protected function createListItems(param1:Vector.<IHintSystemContentDescription>, param2:Sprite) : void
      {
         var _loc5_:IHintSystemContentDescription = null;
         var _loc6_:Sprite = null;
         var _loc3_:uint = param1.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1[_loc4_];
            _loc6_ = this.createItem(_loc5_) as Sprite;
            _loc6_.y = _loc4_ * 18;
            param2.addChild(_loc6_);
            _loc4_++;
         }
      }
      
      protected function createItem(param1:IHintSystemContentDescription) : Sprite
      {
         var _loc2_:HintSystemOverlistItemRendererSkin = new HintSystemOverlistItemRendererSkin();
         var _loc3_:HintSystemOverlistItemRenderer = new HintSystemOverlistItemRenderer();
         _loc3_.registeredTextStyleName = "hintsystem_overview_itemlist";
         _loc3_.skin = _loc2_;
         _loc3_.text = param1.content.title;
         _loc3_.autoSizeWidth = true;
         _loc3_.height = 18;
         _loc3_.data = param1.id;
         _loc3_.addEventListener(MouseEvent.CLICK,this.handleListItemClicked);
         return _loc3_;
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         this.overviewContainer.setSize(param1,param2);
      }
      
      public function activate() : void
      {
         this._content.mouseChildren = true;
         this._content.alpha = 1;
      }
      
      public function deactivate() : void
      {
         this._content.mouseChildren = false;
         this._content.alpha = 0.4;
      }
   }
}

