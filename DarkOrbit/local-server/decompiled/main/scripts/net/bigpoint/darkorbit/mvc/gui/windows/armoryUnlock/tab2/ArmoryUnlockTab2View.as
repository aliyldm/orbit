package net.bigpoint.darkorbit.mvc.gui.windows.armoryUnlock.tab2
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.components.video.VideoPlayer;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   
   public class ArmoryUnlockTab2View implements ITabItem
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      public var _view:Coreponent;
      
      public var _body:Coreponent;
      
      public function ArmoryUnlockTab2View(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._view = this._cache.selectComponent("tab2") as Coreponent;
         this._body = this._view.selectChild("body") as Coreponent;
      }
      
      public function get view() : Coreponent
      {
         return this._view;
      }
      
      public function get body() : Coreponent
      {
         return this._body;
      }
      
      public function get cardsContainer() : Coreponent
      {
         return this._cache.selectComponent("tab2.body.cardsContainer") as Coreponent;
      }
      
      public function get description() : Label
      {
         return this._cache.selectComponent("tab2.body.info.description") as Label;
      }
      
      public function get icon001() : Coreponent
      {
         return this._cache.selectComponent("tab2.body.info001.icon") as Coreponent;
      }
      
      public function get label001() : Label
      {
         return this._cache.selectComponent("tab2.body.info001.infoText") as Label;
      }
      
      public function get infoBtn001() : Button
      {
         return this._cache.selectComponent("tab2.body.info001.infoBtn") as Button;
      }
      
      public function get infoBtn002() : Button
      {
         return this._cache.selectComponent("tab2.body.info002.infoBtn") as Button;
      }
      
      public function get icon003() : Coreponent
      {
         return this._cache.selectComponent("tab2.body.info003.icon") as Coreponent;
      }
      
      public function get drawOnceCost() : Coreponent
      {
         return this._cache.selectComponent("tab2.body.info003") as Coreponent;
      }
      
      public function get icon004() : Coreponent
      {
         return this._cache.selectComponent("tab2.body.info004.icon") as Coreponent;
      }
      
      public function get drawTenCost() : Coreponent
      {
         return this._cache.selectComponent("tab2.body.info004") as Coreponent;
      }
      
      public function get explore01Btn() : Button
      {
         return this._cache.selectComponent("tab2.body.explore01_btn") as Button;
      }
      
      public function get explore10Btn() : Button
      {
         return this._cache.selectComponent("tab2.body.explore10_btn") as Button;
      }
      
      public function get lockBtn() : Button
      {
         return this._cache.selectComponent("tab2.body.lock_btn") as Button;
      }
      
      public function get title() : String
      {
         return "armoryunlock_tab_mega_draw";
      }
      
      public function get visible() : Boolean
      {
         return this._view.visible;
      }
      
      public function set visible(param1:Boolean) : void
      {
         this._view.visible = param1;
      }
      
      public function get active() : Boolean
      {
         return true;
      }
      
      public function set active(param1:Boolean) : void
      {
      }
      
      public function getShipContainer(param1:int) : Coreponent
      {
         return this._cache.selectComponent("tab2.body.shipSelection.shipContainer" + (param1 + 1)) as Coreponent;
      }
      
      public function getShipIcon(param1:int) : Coreponent
      {
         return this._cache.selectComponent("tab2.body.shipSelection.shipContainer" + (param1 + 1) + ".shipIcon") as Coreponent;
      }
      
      public function getShipName(param1:int) : Label
      {
         return this._cache.selectComponent("tab2.body.shipSelection.shipContainer" + (param1 + 1) + ".shipName") as Label;
      }
      
      public function getShipSelectButton(param1:int) : Button
      {
         return this._cache.selectComponent("tab2.body.shipSelection.shipContainer" + (param1 + 1) + ".selectBtn") as Button;
      }
      
      public function getShipSelectedOverlay(param1:int) : Coreponent
      {
         return this._cache.selectComponent("tab2.body.shipSelection.shipContainer" + (param1 + 1) + ".selectedOverlay") as Coreponent;
      }
      
      public function getShipLockedOverlay(param1:int) : Coreponent
      {
         return this._cache.selectComponent("tab2.body.shipSelection.shipContainer" + (param1 + 1) + ".lockedOverlay") as Coreponent;
      }
      
      public function getShipLockIcon(param1:int) : Coreponent
      {
         return this._cache.selectComponent("tab2.body.shipSelection.shipContainer" + (param1 + 1) + ".lockedOverlay.lockIcon") as Coreponent;
      }
      
      public function getVideoPlayer(param1:int) : VideoPlayer
      {
         return this._cache.selectComponent("tab2.body.shipSelection.shipContainer" + (param1 + 1) + ".vid") as VideoPlayer;
      }
   }
}

