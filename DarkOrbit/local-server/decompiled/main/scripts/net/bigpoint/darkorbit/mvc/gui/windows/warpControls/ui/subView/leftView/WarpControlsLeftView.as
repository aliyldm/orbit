package net.bigpoint.darkorbit.mvc.gui.windows.warpControls.ui.subView.leftView
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.mode.vo.WarpShipData;
   
   public class WarpControlsLeftView extends Coreponent
   {
      
      private var _view:Coreponent;
      
      private var _cache:FuiComponentSelectorCache;
      
      private var _warp_mc:WarpImage;
      
      private var _btn1:Button;
      
      private var _btn1_select:Button;
      
      private var _btn1_label:Label;
      
      private var _btn2:Button;
      
      private var _btn2_select:Button;
      
      private var _btn2_label:Label;
      
      private var _title_label:Label;
      
      public function WarpControlsLeftView(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._view = this._cache.selectComponent("left_view.ship_view") as Coreponent;
         this._warp_mc = new WarpImage(this.warpIcon);
         this._btn1 = FuiComponentSelectorUtil.selectComponent("tab",this._cache.selectComponent("left_view.btnContainer.btn_1") as Coreponent) as Button;
         this._btn2 = FuiComponentSelectorUtil.selectComponent("tab",this._cache.selectComponent("left_view.btnContainer.btn_2") as Coreponent) as Button;
         this._btn1_select = FuiComponentSelectorUtil.selectComponent("tab_selected",this._cache.selectComponent("left_view.btnContainer.btn_1") as Coreponent) as Button;
         this._btn2_select = FuiComponentSelectorUtil.selectComponent("tab_selected",this._cache.selectComponent("left_view.btnContainer.btn_2") as Coreponent) as Button;
         this._btn1_label = FuiComponentSelectorUtil.selectComponent("tabLabel",this._cache.selectComponent("left_view.btnContainer.btn_1") as Coreponent) as Label;
         this._btn2_label = FuiComponentSelectorUtil.selectComponent("tabLabel",this._cache.selectComponent("left_view.btnContainer.btn_2") as Coreponent) as Label;
         this._btn1_label.text = "1";
         this._btn2_label.text = "2";
         this._title_label = this._cache.selectComponent("left_view.weapon_view_title") as Label;
         this.initBtnVisible();
      }
      
      public function get title_Label() : Label
      {
         return this._title_label;
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
            this._btn1_label.registeredTextStyleName = "tab_btn_label_select";
            this._btn2_label.registeredTextStyleName = "tab_btn_label";
         }
         if(param1 == 2)
         {
            this._btn1_label.registeredTextStyleName = "commonui_tabbarbutton";
            this._btn2_label.registeredTextStyleName = "commonui_tabbarbutton.selected";
            this._btn2.enabled = false;
            this._btn1.enabled = true;
            this._btn1_label.registeredTextStyleName = "tab_btn_label";
            this._btn2_label.registeredTextStyleName = "tab_btn_label_select";
         }
      }
      
      private function get warpIcon() : Coreponent
      {
         return this._cache.selectComponent("left_view.ship_view.warp_icon") as Coreponent;
      }
      
      public function set shipData(param1:WarpShipData) : void
      {
         this._warp_mc.data = param1.itemVo;
      }
      
      public function get btn1() : Button
      {
         return this._btn1;
      }
      
      public function get btn2() : Button
      {
         return this._btn2;
      }
      
      public function get btn1Select() : Button
      {
         return this._btn1_select;
      }
      
      public function get btn2Select() : Button
      {
         return this._btn2_select;
      }
      
      public function get view() : Coreponent
      {
         return this._view;
      }
   }
}

