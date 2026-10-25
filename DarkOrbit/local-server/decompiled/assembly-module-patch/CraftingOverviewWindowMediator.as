package net.bigpoint.darkorbit.mvc.crafting.overview.view
{
   import com.greensock.TweenMax;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import net.bigpoint.darkorbit.delete_in_eic.InventoryProxy;
   import net.bigpoint.darkorbit.fui.components.core.ICoreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListEvent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.mvc.abstract.view.DOAbstractMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.roguelite.view.RogueLiteUIWindowMediator;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class CraftingOverviewWindowMediator extends DOAbstractMediator
   {
      
      public static const NAME:String = "CraftingOverviewWindowMediator";
      
      private static const TITLE_ASSEMBLY:String = "title_assembly";
      
      private static const TITLE_UPGRADE:String = "title_upgrade";
      
      private static const TITLE_DISASSEMBLY:String = "title_disassembly";
      
      private static const TITLE_REROLL:String = "title_reroll";
      
      private static const TITLE_HYPERFORGE:String = "window_forge_title";
      
      private static const TAB_ORDER:Vector.<String> = new <String>[TITLE_ASSEMBLY,TITLE_UPGRADE,TITLE_DISASSEMBLY,TITLE_REROLL,TITLE_HYPERFORGE];
      
      private var _window:SimpleWindow;
      
      private var TAB2CONTENT:Object = {};
      
      private var _craftingOverviewView:CraftingOverviewView;
      
      public function CraftingOverviewWindowMediator(param1:Sprite, param2:SimpleWindow)
      {
         super(NAME,param1);
         this._window = param2;
         this._window.showInProgressOverlay();
         this._craftingOverviewView = new CraftingOverviewView(param1);
         this._craftingOverviewView.tabBar.addEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.handleTabChanged);
         this._craftingOverviewView.tabBar.addEventListener(ItemListEvent.ITEMS_SELECTION_CHANGED,this.handleTabChanged);
         param1.visible = false;
         param1.alpha = 0;
      }
      
      public function set assemblyView(param1:Sprite) : void
      {
         this.TAB2CONTENT[TITLE_ASSEMBLY] = param1;
         this.invalidateTabList();
      }
      
      public function set upgradeView(param1:Sprite) : void
      {
         this.TAB2CONTENT[TITLE_UPGRADE] = param1;
         this.invalidateTabList();
      }
      
      public function set disassemblyView(param1:Sprite) : void
      {
         this.TAB2CONTENT[TITLE_DISASSEMBLY] = param1;
         this.invalidateTabList();
      }
      
      public function set rerollView(param1:Sprite) : void
      {
         this.TAB2CONTENT[TITLE_REROLL] = param1;
         this.invalidateTabList();
      }
      
      public function set hyperforgeView(param1:Sprite) : void
      {
         this.TAB2CONTENT[TITLE_HYPERFORGE] = param1;
         this.invalidateTabList();
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         var _loc1_:InventoryProxy = retrieveProxy(InventoryProxy.NAME) as InventoryProxy;
         _loc1_.inventory.isInitialized.changed.add(this.handleInventoryInitialization);
         this.handleInventoryInitialization();
      }
      
      private function handleInventoryInitialization() : void
      {
         var _loc1_:InventoryProxy = retrieveProxy(InventoryProxy.NAME) as InventoryProxy;
         if(_loc1_.inventory.isInitialized.value)
         {
            this._window.hideInProgressOverlay();
            TweenMax.to(this._craftingOverviewView.root,0.3,{"autoAlpha":1});
         }
         else
         {
            this._window.showInProgressOverlay();
            TweenMax.to(this._craftingOverviewView.root,0.3,{"autoAlpha":0});
         }
         var _loc2_:Map = ScreenManager.getInstance().map;
         if(RogueLiteUIWindowMediator.FORBIDDEN_MAP.indexOf(_loc2_.mapID) >= 0)
         {
            this._window.minimize();
         }
      }
      
      private function hideAllTabs() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:DisplayObject = null;
         for(_loc1_ in this.TAB2CONTENT)
         {
            _loc2_ = this.TAB2CONTENT[_loc1_] as DisplayObject;
            MovieClipUtils.removeDisplayObject(_loc2_ as DisplayObject);
         }
      }
      
      private function invalidateTabList() : void
      {
         var _loc2_:* = undefined;
         var _loc1_:Vector.<String> = new Vector.<String>(0);
         for(_loc2_ in this.TAB2CONTENT)
         {
            _loc1_.push(_loc2_);
         }
         _loc1_.sort(this.sortTabs);
         this._craftingOverviewView.tabBar.list = new VectorCollection(_loc1_);
         this._craftingOverviewView.tabBar.selectedIndex = 0;
      }
      
      private function sortTabs(param1:String, param2:String) : int
      {
         return TAB_ORDER.indexOf(param1) - TAB_ORDER.indexOf(param2);
      }
      
      private function handleTabChanged(param1:Event) : void
      {
         var _loc3_:Label = null;
         var _loc7_:ICoreponent = null;
         var selected:Vector.<Object> = this._craftingOverviewView.tabBar.getSelectedItemsData();
         if(selected == null || selected.length == 0)
         {
            return;
         }
         var _loc2_:String = String(selected[0]);
         if(!(this.TAB2CONTENT[_loc2_] is DisplayObject))
         {
            return;
         }
         this.hideAllTabs();
         var _loc4_:Vector.<ICoreponent> = this._craftingOverviewView.tabBar.itemsContainer.getAllCoreponentChildren();
         var _loc5_:int = int(_loc4_.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = _loc4_[_loc6_];
            _loc3_ = _loc7_.getChildByName("tabLabel") as Label;
            _loc3_.registeredTextStyleName = "commonui_tabbar_center";
            _loc6_++;
         }
         if(this._craftingOverviewView.tabBar.selectedItem != null)
         {
            _loc3_ = this._craftingOverviewView.tabBar.selectedItem.getChildByName("tabLabel") as Label;
            _loc3_.registeredTextStyleName = "commonui_tabbar_center_selected";
         }
         this._craftingOverviewView.content.addChild(this.TAB2CONTENT[_loc2_] as DisplayObject);
      }
   }
}

