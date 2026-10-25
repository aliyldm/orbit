package net.bigpoint.darkorbit.mvc.gui.windows.anniv19.view
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.dropdownbox.DropDownBox;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   
   public class DifficultySelectionView
   {
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      private var _uiContainer:Sprite;
      
      public function DifficultySelectionView(param1:SimpleWindow)
      {
         super();
         this._uiContainer = param1.getUIContainer();
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
         this.rewardItemList.itemDataAssigner = DifficultySelectionItemAssigner;
      }
      
      public function get infoLabel1() : Label
      {
         return this._fuiCache.selectComponent("root.body.info_label1") as Label;
      }
      
      public function get infoLabel2() : Label
      {
         return this._fuiCache.selectComponent("root.body.info_label2") as Label;
      }
      
      public function get filterDropBox() : DropDownBox
      {
         return this._fuiCache.selectComponent("root.body.filter_container.filter_box") as DropDownBox;
      }
      
      public function get chanceLabel() : Label
      {
         return this._fuiCache.selectComponent("root.body.reward_background.chance_label") as Label;
      }
      
      public function get chanceBtn() : Button
      {
         return this._fuiCache.selectComponent("root.body.reward_background.chance_buttton") as Button;
      }
      
      public function get costNameLabel() : Label
      {
         return this._fuiCache.selectComponent("root.body.cost_container.cost_name_label") as Label;
      }
      
      public function get costHelpBtn() : Button
      {
         return this._fuiCache.selectComponent("root.body.cost_container.cost_item_infoBtn") as Button;
      }
      
      public function get costNumLabel() : Label
      {
         return this._fuiCache.selectComponent("root.body.cost_container.cost_num_label") as Label;
      }
      
      public function get costIcon() : Coreponent
      {
         return this._fuiCache.selectComponent("root.body.cost_container.icon") as Coreponent;
      }
      
      public function get goBtn() : Button
      {
         return this._fuiCache.selectComponent("root.body.button_go") as Button;
      }
      
      public function get rewardItemList() : ItemList
      {
         return this._fuiCache.selectComponent("root.body.reward_background.reward_container.list") as ItemList;
      }
      
      public function set rewardList(param1:Vector.<ItemVO>) : void
      {
         this.rewardItemList.list = new VectorCollection(param1);
      }
   }
}

