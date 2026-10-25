package net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.refreshMissions
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   
   public class SeasonPassRefreshConfirmView
   {
      
      private var _uiContainer:Sprite;
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      private var _confirmContainer:Sprite;
      
      private var _upgradeLabel:Label;
      
      private var _upgradeBtn:Button;
      
      private var _costNameLabel:Label;
      
      private var _constValueLabel:Label;
      
      public function SeasonPassRefreshConfirmView(param1:Sprite)
      {
         super();
         this._uiContainer = param1;
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
      }
      
      public function get labelMain() : Label
      {
         return this._fuiCache.selectComponent("root.content.message.main_message") as Label;
      }
      
      public function get confirmBtn() : Button
      {
         return this._fuiCache.selectComponent("root.content.confirm_buttons.btnConfirm") as Button;
      }
      
      public function get btnCancel() : Button
      {
         return this._fuiCache.selectComponent("root.content.confirm_buttons.btnCancel") as Button;
      }
      
      public function get btnUpgrade() : Button
      {
         return this._fuiCache.selectComponent("root.content.gold_pass.btnGoldPass") as Button;
      }
      
      public function get upgradeOpenHintLabel() : Label
      {
         return this._fuiCache.selectComponent("root.content.gold_pass.upgrade_open_hint") as Label;
      }
      
      public function get confirmButtonsContainer() : Container
      {
         return this._fuiCache.selectComponent("root.content.confirm_buttons") as Container;
      }
      
      public function get messageContainer() : Container
      {
         return this._fuiCache.selectComponent("root.content.message") as Container;
      }
      
      public function get goldPassContainer() : DisplayObjectContainer
      {
         return this._fuiCache.selectComponent("root.content.gold_pass") as DisplayObjectContainer;
      }
   }
}

