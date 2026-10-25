package net.bigpoint.darkorbit.mvc.gui.windows.warpControls.ui
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.scroll.Scrollbar;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.ui.subView.centerView.WarpControlsCenterView;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.ui.subView.centerView.WarpControlsCenterView_Tab2;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.ui.subView.leftView.WarpControlsLeftView;
   
   public class WarpControlsView
   {
      
      private var _uiContainer:Sprite;
      
      private var _simpleWindow:SimpleWindow;
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      private var _centerView:WarpControlsCenterView;
      
      private var _right_list:ItemList;
      
      private var _right_list_bg:ItemList;
      
      private var _shipView:WarpControlsLeftView;
      
      private var _right_title_label:Label;
      
      private var _centerView_tab2:WarpControlsCenterView_Tab2;
      
      private var _btn1:Button;
      
      private var _btn1_select:Button;
      
      private var _btn1_label:Label;
      
      private var _btn2:Button;
      
      private var _btn2_select:Button;
      
      private var _btn2_label:Label;
      
      public function WarpControlsView(param1:SimpleWindow)
      {
         super();
         this._uiContainer = param1.getUIContainer();
         this._simpleWindow = param1;
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
         this._shipView = new WarpControlsLeftView(this.body);
         this._centerView = new WarpControlsCenterView(this._fuiCache.selectComponent("root.body.center_view") as Coreponent);
         this._centerView_tab2 = new WarpControlsCenterView_Tab2(this._fuiCache.selectComponent("root.body.center_view_engine") as Coreponent);
         this._right_list = this._fuiCache.selectComponent("root.body.right_view.right_view_list") as ItemList;
         this._right_list_bg = this._fuiCache.selectComponent("root.body.right_view.right_view_list_bg") as ItemList;
         this._right_title_label = this._fuiCache.selectComponent("root.body.right_view.right_view_up_label") as Label;
         this.initCenterPageBtn();
      }
      
      private function initCenterPageBtn() : void
      {
         this._btn1 = this._fuiCache.selectComponent("root.body.center_page_btn.btn_1.tab") as Button;
         this._btn1_select = this._fuiCache.selectComponent("root.body.center_page_btn.btn_1.tab_selected") as Button;
         this._btn1_label = this._fuiCache.selectComponent("root.body.center_page_btn.btn_1.tabLabel") as Label;
         this._btn2 = this._fuiCache.selectComponent("root.body.center_page_btn.btn_2.tab") as Button;
         this._btn2_select = this._fuiCache.selectComponent("root.body.center_page_btn.btn_2.tab_selected") as Button;
         this._btn2_label = this._fuiCache.selectComponent("root.body.center_page_btn.btn_2.tabLabel") as Label;
         this._btn1_label.text = "1";
         this._btn2_label.text = "2";
         this.initBtnVisible();
      }
      
      public function get right_title_label() : Label
      {
         return this._right_title_label;
      }
      
      public function get centerViewContent() : Coreponent
      {
         return this._fuiCache.selectComponent("root.body.center_view") as Coreponent;
      }
      
      public function get right_list_scroll() : Scrollbar
      {
         return this._fuiCache.selectComponent("root.body.right_view.scroll_bar") as Scrollbar;
      }
      
      public function get right_list() : ItemList
      {
         return this._right_list;
      }
      
      public function get right_list_bg() : ItemList
      {
         return this._right_list_bg;
      }
      
      public function get centerView() : WarpControlsCenterView
      {
         return this._centerView;
      }
      
      public function get centerView_tab2() : WarpControlsCenterView_Tab2
      {
         return this._centerView_tab2;
      }
      
      public function get body() : Coreponent
      {
         return this._fuiCache.selectComponent("root.body") as Coreponent;
      }
      
      public function get shipView() : WarpControlsLeftView
      {
         return this._shipView;
      }
      
      private function initBtnVisible() : void
      {
         this._btn1.visible = true;
         this._btn1_select.visible = false;
         this._btn2.visible = true;
         this._btn1_select.visible = false;
         this.updateBtnVisible(1);
      }
      
      public function updateBtnVisible(param1:Number) : void
      {
         if(param1 == 1)
         {
            this._btn1_label.registeredTextStyleName = "commonui_tabbarbutton.selected";
            this._btn2_label.registeredTextStyleName = "commonui_tabbarbutton";
            this._btn2.enabled = true;
            this._btn1.enabled = false;
            this._btn1_label.registeredTextStyleName = "center_tab_btn_label_select";
            this._btn2_label.registeredTextStyleName = "center_tab_btn_label";
         }
         if(param1 == 2)
         {
            this._btn1_label.registeredTextStyleName = "commonui_tabbarbutton";
            this._btn2_label.registeredTextStyleName = "commonui_tabbarbutton.selected";
            this._btn2.enabled = false;
            this._btn1.enabled = true;
            this._btn1_label.registeredTextStyleName = "center_tab_btn_label";
            this._btn2_label.registeredTextStyleName = "center_tab_btn_label_select";
         }
      }
      
      public function get centerPageBtn1() : Button
      {
         return this._btn1;
      }
      
      public function get centerPageBtn2() : Button
      {
         return this._btn2;
      }
   }
}

