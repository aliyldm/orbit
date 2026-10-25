package net.bigpoint.darkorbit.mvc.gui.windows.roguelite.view.components
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ExtendedTabView;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   
   public class RogueLiteSelectionRootView
   {
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      private var _tabView:ExtendedTabView;
      
      private var _uiContainer:Sprite;
      
      private var _window:SimpleWindow;
      
      private var _shipSelectionView:RogueLiteShipSelectionView;
      
      private var _modifierSelectionView:RogueLiteModifierSelectionView;
      
      public function RogueLiteSelectionRootView(param1:SimpleWindow)
      {
         super();
         this._uiContainer = param1.getUIContainer();
         this._window = param1;
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
         this._tabView = new ExtendedTabView(this._uiContainer);
         this._tabView.tabItems = new <ITabItem>[this._shipSelectionView = new RogueLiteShipSelectionView(this._uiContainer),this._modifierSelectionView = new RogueLiteModifierSelectionView(this._uiContainer)];
         this._window.x = ScreenManager.getHalfScreenWidth() - this._window.width / 2;
         this._window.y = ScreenManager.getHalfScreenHeight() - this._window.height / 2;
      }
      
      public function get shipSelectionView() : RogueLiteShipSelectionView
      {
         return this._shipSelectionView;
      }
      
      public function get modifierSelectionView() : *
      {
         return this._modifierSelectionView;
      }
   }
}

