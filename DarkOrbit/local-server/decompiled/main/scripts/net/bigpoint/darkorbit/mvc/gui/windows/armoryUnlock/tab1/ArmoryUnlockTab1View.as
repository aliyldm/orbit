package net.bigpoint.darkorbit.mvc.gui.windows.armoryUnlock.tab1
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   
   public class ArmoryUnlockTab1View implements ITabItem
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      public var _view:Coreponent;
      
      public var _body:Coreponent;
      
      public function ArmoryUnlockTab1View(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._view = this._cache.selectComponent("tab1") as Coreponent;
         this._body = this._view.selectChild("body") as Coreponent;
      }
      
      public function get cardsContainer() : Coreponent
      {
         return this._cache.selectComponent("tab1.body.cardsContainer") as Coreponent;
      }
      
      public function get body() : Coreponent
      {
         return this._body;
      }
      
      public function get title() : String
      {
         return "armoryunlock_tab_lucky_draw";
      }
      
      public function get view() : Coreponent
      {
         return this._view;
      }
      
      public function set visible(param1:Boolean) : void
      {
         this._view.visible = param1;
      }
      
      public function get visible() : Boolean
      {
         return this._view.visible;
      }
      
      public function set active(param1:Boolean) : void
      {
      }
      
      public function get active() : Boolean
      {
         return true;
      }
      
      public function get icon001() : Coreponent
      {
         return this._cache.selectComponent("tab1.body.info001.icon") as Coreponent;
      }
      
      public function get label001() : Label
      {
         return this._cache.selectComponent("tab1.body.info001.infoText") as Label;
      }
      
      public function get infoBtn001() : Button
      {
         return this._cache.selectComponent("tab1.body.info001.infoBtn") as Button;
      }
      
      public function get infoBtn002() : Button
      {
         return this._cache.selectComponent("tab1.body.info002.infoBtn") as Button;
      }
      
      public function get icon003() : Coreponent
      {
         return this._cache.selectComponent("tab1.body.info003.icon") as Coreponent;
      }
      
      public function get icon004() : Coreponent
      {
         return this._cache.selectComponent("tab1.body.info004.icon") as Coreponent;
      }
      
      public function get explore01Btn() : Coreponent
      {
         return this._cache.selectComponent("tab1.body.explore01_btn") as Coreponent;
      }
      
      public function get explore10Btn() : Coreponent
      {
         return this._cache.selectComponent("tab1.body.explore10_btn") as Coreponent;
      }
   }
}

