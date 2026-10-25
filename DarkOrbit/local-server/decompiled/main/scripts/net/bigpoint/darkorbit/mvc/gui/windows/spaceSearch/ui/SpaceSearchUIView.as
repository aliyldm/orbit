package net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.ui
{
   import com.bigpoint.utils.ui.buttons.StatesButtonDecorator;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.dropdownbox.DropDownBox;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   
   public class SpaceSearchUIView
   {
      
      private var _uiContainer:Sprite;
      
      private var _simpleWindow:SimpleWindow;
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      private var _helpBtn:StatesButtonDecorator;
      
      public function SpaceSearchUIView(param1:SimpleWindow)
      {
         super();
         this._uiContainer = param1.getUIContainer();
         this._simpleWindow = param1;
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
         if(param1.helpBtn)
         {
            param1.removeHelpBtnClick();
            this._helpBtn = param1.helpBtn;
         }
      }
      
      public function get helpBtn() : StatesButtonDecorator
      {
         return this._helpBtn;
      }
      
      public function get root() : Coreponent
      {
         return this._fuiCache.selectComponent("root") as Coreponent;
      }
      
      public function get refreshButton() : Button
      {
         return this._fuiCache.selectComponent("root.body.clearButton") as Button;
      }
      
      public function get topBg() : Coreponent
      {
         return this._fuiCache.selectComponent("root.body.top.top_bg") as Coreponent;
      }
      
      public function get bg() : Coreponent
      {
         return this._fuiCache.selectComponent("root.body.top.bg") as Coreponent;
      }
      
      public function get markBg() : Coreponent
      {
         return this._fuiCache.selectComponent("root.body.top.mark_bg") as Coreponent;
      }
      
      public function get missionInfo() : Coreponent
      {
         return this._fuiCache.selectComponent("root.body.mid.mission_info") as Coreponent;
      }
      
      public function get mission_info_bg() : Coreponent
      {
         return this._fuiCache.selectComponent("root.body.mid.mission_info_bg") as Coreponent;
      }
      
      public function get icon() : Coreponent
      {
         return this._fuiCache.selectComponent("root.body.mid.loot_info.icon") as Coreponent;
      }
      
      public function get lootName() : Label
      {
         return this._fuiCache.selectComponent("root.body.mid.loot_info.loot_name") as Label;
      }
      
      public function get infoBtn() : Button
      {
         return this._fuiCache.selectComponent("root.body.mid.loot_info.infoBtn") as Button;
      }
      
      public function get lootAmount() : Label
      {
         return this._fuiCache.selectComponent("root.body.mid.loot_info.loot_amount") as Label;
      }
      
      public function get filterBox() : DropDownBox
      {
         var _loc1_:DropDownBox = this._fuiCache.selectComponent("root.body.mid.loot_info.filter_box") as DropDownBox;
         var _loc2_:DropDownBox = this._fuiCache.selectComponent("root.body.mid.loot_info.share.filter_box") as DropDownBox;
         return _loc1_ == null ? _loc2_ : _loc1_;
      }
      
      public function get explore_btn() : Button
      {
         return this._fuiCache.selectComponent("root.body.mid.explore_btn") as Button;
      }
   }
}

