package net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.main.view
{
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.fui.components.bars.ProgressBar;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ExtendedTabView;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.missions.view.SeasonPassUIMissionsView;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.rewards.view.SeasonPassUIRewardsView;
   
   public class SeasonPassUIView
   {
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      private var _tabView:ExtendedTabView;
      
      private var _uiContainer:Sprite;
      
      private var _simpleWindow:SimpleWindow;
      
      private var _rewardsView:SeasonPassUIRewardsView;
      
      private var _missionsView:SeasonPassUIMissionsView;
      
      private var _title:String;
      
      public function SeasonPassUIView(param1:SimpleWindow, param2:Vector.<ITabItem> = null)
      {
         super();
         this._uiContainer = param1.getUIContainer();
         this._simpleWindow = param1;
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
         this._tabView = new ExtendedTabView(this._uiContainer,SeasonPassUITabBarAssigner);
         this._rewardsView = new SeasonPassUIRewardsView(this.root);
         this._missionsView = new SeasonPassUIMissionsView(this.root);
         this._tabView.tabItems = new <ITabItem>[this._rewardsView,this._missionsView];
         this._tabView.tabChanged.add(this.onTabChanged);
         this.onTabChanged(this._rewardsView);
      }
      
      public function get title() : String
      {
         return this._title;
      }
      
      public function set subTitle(param1:String) : void
      {
         this._title = BPLocale.getItem("window_main_sp_highlight_title-seasonpassmar2023");
         if(param1 != null && param1.length > 0)
         {
            this._title += " : " + BPLocale.getItem(param1);
         }
         this._simpleWindow.setTitle(this._title,false);
      }
      
      private function get activeContainer() : Coreponent
      {
         return this._fuiCache.selectComponent("root.main.active") as Coreponent;
      }
      
      private function get inactiveContainer() : Coreponent
      {
         return this._fuiCache.selectComponent("root.main.inactive") as Coreponent;
      }
      
      public function set showContainer(param1:Boolean) : void
      {
         this.activeContainer.visible = param1;
         this.inactiveContainer.visible = !param1;
         this.tabView.visible = param1;
         if(!param1)
         {
            this.subTitle = "";
         }
      }
      
      public function get isShowingContainer() : Boolean
      {
         return this.activeContainer.visible;
      }
      
      public function get root() : Coreponent
      {
         return this._fuiCache.selectComponent("root") as Coreponent;
      }
      
      public function get tabView() : ExtendedTabView
      {
         return this._tabView;
      }
      
      private function onTabChanged(param1:ITabItem) : void
      {
         this._simpleWindow.setSize(param1.view.width,param1.view.height);
      }
      
      public function get rewards() : SeasonPassUIRewardsView
      {
         return this._rewardsView;
      }
      
      public function get missions() : SeasonPassUIMissionsView
      {
         return this._missionsView;
      }
      
      public function get banner() : Coreponent
      {
         return this._fuiCache.selectComponent("root.main.active.top.banner") as Coreponent;
      }
      
      public function get btnPurchase() : Button
      {
         return this._fuiCache.selectComponent("root.main.active.top.progress.btn_purchase") as Button;
      }
      
      public function get labelPtsIncrease() : Label
      {
         return this._fuiCache.selectComponent("root.main.active.top.progress.label_pts_increase") as Label;
      }
      
      public function get progressBar() : ProgressBar
      {
         return this._fuiCache.selectComponent("root.main.active.top.progress.progress_bar.bar") as ProgressBar;
      }
      
      public function get labelPtsCurrent() : Label
      {
         return this._fuiCache.selectComponent("root.main.active.top.progress.progress_bar.label_current") as Label;
      }
      
      public function get labelLevel() : Label
      {
         return this._fuiCache.selectComponent("root.main.active.top.progress.level.label_next") as Label;
      }
      
      public function get labelCountdown() : Label
      {
         return this._fuiCache.selectComponent("root.main.active.bottom.countdown_timer") as Label;
      }
   }
}

