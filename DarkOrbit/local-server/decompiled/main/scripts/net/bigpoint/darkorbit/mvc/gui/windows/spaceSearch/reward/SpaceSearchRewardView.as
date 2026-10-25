package net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.reward
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.scroll.ScrollContainer;
   import net.bigpoint.darkorbit.fui.components.scroll.Scrollbar;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   
   public class SpaceSearchRewardView
   {
      
      private var _uiContainer:Sprite;
      
      private var _simpleWindow:SimpleWindow;
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      public function SpaceSearchRewardView(param1:SimpleWindow)
      {
         super();
         this._uiContainer = param1.getUIContainer();
         this._simpleWindow = param1;
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
      }
      
      public function get characterContainer() : Coreponent
      {
         return this._fuiCache.selectComponent("root.body.contentContainer.messageContainer.characterContainer") as Coreponent;
      }
      
      public function get characterBackground() : Coreponent
      {
         return this._fuiCache.selectComponent("root.body.contentContainer.messageContainer.characterBackground") as Coreponent;
      }
      
      public function get rewardInfoBg() : Coreponent
      {
         return this._fuiCache.selectComponent("root.body.reward_info.bg") as Coreponent;
      }
      
      public function get messageContainer() : Label
      {
         return this._fuiCache.selectComponent("root.body.contentContainer.messageContainer.textBoxContainer.message_box.message_container") as Label;
      }
      
      public function get availableExchangeItemList() : ItemList
      {
         return this._fuiCache.selectComponent("root.body.reward_info.reward_box.list") as ItemList;
      }
      
      public function get contentText() : Label
      {
         return this._fuiCache.selectComponent("root.body.contentContainer.messageContainer.description_body.scrollContainerText.content") as Label;
      }
      
      public function get scrollbar() : Scrollbar
      {
         return this._fuiCache.selectComponent("root.body.contentContainer.messageContainer.description_body.scrollbarText") as Scrollbar;
      }
      
      public function get scrollbarContainer() : ScrollContainer
      {
         return this._fuiCache.selectComponent("root.body.contentContainer.messageContainer.description_body.scrollContainerText") as ScrollContainer;
      }
      
      public function get message1_0() : Label
      {
         return this._fuiCache.selectComponent("root.body.reward_info.message1_0") as Label;
      }
      
      public function get message1_1() : Label
      {
         return this._fuiCache.selectComponent("root.body.reward_info.message1_1") as Label;
      }
      
      public function get message2_0() : Label
      {
         return this._fuiCache.selectComponent("root.body.reward_info.message2_0") as Label;
      }
      
      public function get message2_1() : Label
      {
         return this._fuiCache.selectComponent("root.body.reward_info.message2_1") as Label;
      }
      
      public function get message3_0() : Label
      {
         return this._fuiCache.selectComponent("root.body.reward_info.message3_0") as Label;
      }
      
      public function get message3_1() : Label
      {
         return this._fuiCache.selectComponent("root.body.reward_info.message3_1") as Label;
      }
      
      public function get okBtn() : Button
      {
         return this._fuiCache.selectComponent("root.body.ok_btn") as Button;
      }
   }
}

