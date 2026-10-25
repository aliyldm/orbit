package net.bigpoint.darkorbit.mvc.gui.windows.birthdaygate2025.view
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.bars.ProgressBar;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.skins.layers.Scale9BitmapLayer;
   import net.bigpoint.darkorbit.fui.components.list.itemgrid.Grid;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.birthdaygate2025.model.BirthdayGate2025Constants;
   
   public class BirthdayGate2025View
   {
      
      public var listBgImage:Scale9BitmapLayer;
      
      private var _uiContainer:Sprite;
      
      private var _simpleWindow:SimpleWindow;
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      private var assetsProxy:AssetsProxy;
      
      private var redDot:Shape;
      
      private var titlelineBMP:Bitmap;
      
      public function BirthdayGate2025View(param1:SimpleWindow)
      {
         super();
         this._uiContainer = param1.getUIContainer();
         this._simpleWindow = param1;
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
         this.assetsProxy = GameFacade.getInstance().retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
      }
      
      public function claimRedDot(param1:Boolean) : void
      {
         this.redDot.visible = param1;
      }
      
      public function loadGatePicComplete() : void
      {
         this.init();
         var _loc1_:BitmapData = this.assetsProxy.getBitmapDataFromAtlas("gate",BirthdayGate2025Constants.UI_ATLASXML);
         var _loc2_:Bitmap = new Bitmap(_loc1_);
         this.effect_group.addChild(_loc2_);
         var _loc3_:BitmapData = this.assetsProxy.getBitmapDataFromAtlas("9_icon_points_birthday",BirthdayGate2025Constants.UI_ATLASXML);
         var _loc4_:Bitmap = new Bitmap(_loc3_);
         this.icon_pts.removeChildren();
         this.icon_pts.addChild(_loc4_);
      }
      
      private function init() : void
      {
         var _loc1_:Coreponent = this._fuiCache.selectComponent("root.main_view.right_view.content.list_bg") as Coreponent;
         var _loc2_:BitmapData = this.assetsProxy.getBitmapDataFromAtlas("backgroundBody_Normal2",BirthdayGate2025Constants.UI_ATLASXML);
         this.listBgImage = new Scale9BitmapLayer(_loc2_,12,9,22,20,_loc1_.width,_loc1_.height);
         this.listBgImage.alpha = 0.4;
         _loc1_.addChild(this.listBgImage);
         var _loc3_:Shape = new Shape();
         var _loc4_:Graphics = _loc3_.graphics;
         _loc4_.lineStyle(1,8421504);
         _loc4_.beginFill(8421504,0.6);
         _loc4_.moveTo(10,28);
         _loc4_.lineTo(_loc1_.width - 10,28);
         _loc4_.endFill();
         _loc1_.addChild(_loc3_);
         this.redDot = new Shape();
         var _loc5_:Graphics = this.redDot.graphics;
         _loc5_.lineStyle(1,16777215);
         _loc5_.beginFill(16711680,1);
         _loc5_.drawCircle(0,0,5);
         _loc5_.endFill();
         this.redDot.x = this.right_content.width - this.claimBtn.marginRight - 5;
         this.redDot.y = this.claimBtn.marginTop;
         this.redDot.visible = false;
         this.right_content.addChild(this.redDot);
         var _loc6_:BitmapData = this.assetsProxy.getBitmapDataFromAtlas("title_line",BirthdayGate2025Constants.UI_ATLASXML);
         this.titlelineBMP = new Bitmap(_loc6_);
         this.titlelineBMP.width = 400;
         this.titlelineBMP.height = 6;
         this.title_line.removeChildren();
         this.title_line.addChild(this.titlelineBMP);
         var _loc7_:Shape = new Shape();
         var _loc8_:Graphics = _loc7_.graphics;
         _loc8_.lineStyle(1,2310736);
         _loc8_.beginFill(2580341,0.05);
         _loc8_.drawRect(0,0,495,125);
         _loc8_.endFill();
         this.info_bg.addChild(_loc7_);
      }
      
      public function setTitleLineSize() : void
      {
         this.titlelineBMP.width = this.title_label.width * 0.4;
      }
      
      public function get title_line() : Coreponent
      {
         return this._fuiCache.selectComponent("root.main_view.right_view.title_label_line") as Coreponent;
      }
      
      public function get info_bg() : Coreponent
      {
         return this._fuiCache.selectComponent("root.main_view.right_view.info_label_bg") as Coreponent;
      }
      
      public function get icon_pts() : Coreponent
      {
         return this._fuiCache.selectComponent("root.main_view.right_view.content.progress.icon_pts") as Coreponent;
      }
      
      public function get effect_group() : Coreponent
      {
         return this._fuiCache.selectComponent("root.main_view.left_view.effect_group") as Coreponent;
      }
      
      public function get title_label() : Label
      {
         return this._fuiCache.selectComponent("root.main_view.right_view.title_label") as Label;
      }
      
      public function get info_label() : Label
      {
         return this._fuiCache.selectComponent("root.main_view.right_view.info_label") as Label;
      }
      
      public function get progress_bar() : ProgressBar
      {
         return this._fuiCache.selectComponent("root.main_view.right_view.content.progress.progress_bar.bar") as ProgressBar;
      }
      
      public function get progress_bar_label() : Label
      {
         return this._fuiCache.selectComponent("root.main_view.right_view.content.progress.progress_bar.label_current") as Label;
      }
      
      public function get next_label() : Label
      {
         return this._fuiCache.selectComponent("root.main_view.right_view.content.progress.index_group.label_next") as Label;
      }
      
      public function get rewardList() : Grid
      {
         return this._fuiCache.selectComponent("root.main_view.right_view.content.reward_list") as Grid;
      }
      
      public function get claimBtn() : Button
      {
         return this._fuiCache.selectComponent("root.main_view.right_view.content.claim_all") as Button;
      }
      
      public function get page_label() : Label
      {
         return this._fuiCache.selectComponent("root.main_view.right_view.content.page.page_label") as Label;
      }
      
      public function get first_page() : Button
      {
         return this._fuiCache.selectComponent("root.main_view.right_view.content.page.first_page") as Button;
      }
      
      public function get prev_page() : Button
      {
         return this._fuiCache.selectComponent("root.main_view.right_view.content.page.prev_page") as Button;
      }
      
      public function get next_page() : Button
      {
         return this._fuiCache.selectComponent("root.main_view.right_view.content.page.next_page") as Button;
      }
      
      public function get last_page() : Button
      {
         return this._fuiCache.selectComponent("root.main_view.right_view.content.page.last_page") as Button;
      }
      
      public function get right_content() : Coreponent
      {
         return this._fuiCache.selectComponent("root.main_view.right_view.content") as Coreponent;
      }
   }
}

