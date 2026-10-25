package net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.dropdownbox.DropDownBox;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   
   public class TrinityTrialsSelectView
   {
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      private var _uiContainer:Sprite;
      
      public function TrinityTrialsSelectView(param1:SimpleWindow)
      {
         super();
         this._uiContainer = param1.getUIContainer();
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
      }
      
      public function get gateSelection() : DropDownBox
      {
         return this._fuiCache.selectComponent("root.body.dropdownbox_container1.dropdownbox_gate") as DropDownBox;
      }
      
      public function get difficultySelection() : DropDownBox
      {
         return this._fuiCache.selectComponent("root.body.dropdownbox_container2.dropdownbox_select") as DropDownBox;
      }
      
      public function get mapIcon() : Coreponent
      {
         return this._fuiCache.selectComponent("root.body.map_icon") as Coreponent;
      }
      
      public function get goBtn() : Button
      {
         return this._fuiCache.selectComponent("root.body.button_go") as Button;
      }
      
      public function get itemIcon() : Coreponent
      {
         return this._fuiCache.selectComponent("root.body.cost_container.icon") as Coreponent;
      }
      
      public function get itemNumLabel() : Label
      {
         return this._fuiCache.selectComponent("root.body.cost_container.cost_num_label") as Label;
      }
      
      public function get infoLabel() : Label
      {
         return this._fuiCache.selectComponent("root.body.info_label") as Label;
      }
      
      public function get costContainer() : Coreponent
      {
         return this._fuiCache.selectComponent("root.body.cost_container") as Coreponent;
      }
   }
}

