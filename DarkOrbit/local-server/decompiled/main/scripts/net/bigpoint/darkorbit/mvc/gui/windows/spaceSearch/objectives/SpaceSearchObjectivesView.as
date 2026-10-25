package net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.objectives
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.objectives.missions.TabSpaceSearchMissionsView;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.objectives.rewards.TabSpaceSearchRewardsView;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.ui.model.SpaceSearchRedDotData;
   
   public class SpaceSearchObjectivesView
   {
      
      private var _tabView:SpaceSearchObjectivesTabView;
      
      private var _uiContainer:Sprite;
      
      private var _simpleWindow:SimpleWindow;
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      private var _missionsView:TabSpaceSearchMissionsView;
      
      private var _rewardsView:TabSpaceSearchRewardsView;
      
      private var redDot:Sprite = new Sprite();
      
      public function SpaceSearchObjectivesView(param1:SimpleWindow)
      {
         super();
         SpaceSearchRedDotData.drawDot(this.redDot);
         this._uiContainer = param1.getUIContainer();
         this._simpleWindow = param1;
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
         this._tabView = new SpaceSearchObjectivesTabView(this._uiContainer,TabSpaceSearchAssigner);
         this._missionsView = new TabSpaceSearchMissionsView(this.root);
         this._rewardsView = new TabSpaceSearchRewardsView(this.root);
         this._tabView.tabItems = new <ITabItem>[this._missionsView,this._rewardsView];
         this._tabView.tabChanged.add(this.onTabChanged);
         this.onTabChanged(this._missionsView);
      }
      
      public function get missionsView() : TabSpaceSearchMissionsView
      {
         return this._missionsView;
      }
      
      public function get rewardsView() : TabSpaceSearchRewardsView
      {
         return this._rewardsView;
      }
      
      private function onTabChanged(param1:ITabItem) : void
      {
         this._simpleWindow.setSize(param1.view.width,param1.view.height);
      }
      
      public function get tab() : SpaceSearchObjectivesTabView
      {
         return this._tabView;
      }
      
      public function get root() : Coreponent
      {
         return this._fuiCache.selectComponent("root") as Coreponent;
      }
      
      public function get clearButton() : Button
      {
         return this._fuiCache.selectComponent("root.tabbarContainer.clearButton") as Button;
      }
   }
}

