package net.bigpoint.darkorbit.mvc.gui.windows.roguelite.view.components
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemgrid.Grid;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   
   public class RogueLiteRewardCashoutView implements ITabItem
   {
      
      private const _borderSize:int = 2;
      
      private const _activeName:String = "root.rewards_cashout.active";
      
      private var _cache:FuiComponentSelectorCache;
      
      private var _view:Coreponent;
      
      public function RogueLiteRewardCashoutView(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._view = this._cache.selectComponent("root.rewards_cashout") as Coreponent;
         this.guaranteedGrid.itemDataAssigner = RogueLiteRewardCashoutAssigner;
         this.chanceGrid.itemDataAssigner = RogueLiteRewardCashoutAssigner;
      }
      
      public function get title() : String
      {
         return "astral_ascension_tab_rewards";
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
      
      private function get activeContainer() : Coreponent
      {
         return this._cache.selectComponent(this._activeName) as Coreponent;
      }
      
      private function get inactiveContainer() : Coreponent
      {
         return this._cache.selectComponent("root.rewards_cashout.inactive") as Coreponent;
      }
      
      public function set showContainer(param1:Boolean) : void
      {
         this.activeContainer.visible = param1;
         this.inactiveContainer.visible = !param1;
         if(!param1)
         {
            this.guaranteedGrid.clearList();
            this.chanceGrid.clearList();
         }
      }
      
      public function get guaranteedGrid() : Grid
      {
         return this._cache.selectComponent(this._activeName + ".top.guaranteed.list") as Grid;
      }
      
      public function set guaranteedList(param1:Object) : void
      {
         this.guaranteedGrid.list = new VectorCollection(param1);
         this.guaranteedGrid.itemAlignX = "left";
      }
      
      public function get chanceGrid() : Grid
      {
         return this._cache.selectComponent(this._activeName + ".top.chance.list") as Grid;
      }
      
      public function set chanceList(param1:Object) : void
      {
         this.chanceGrid.list = new VectorCollection(param1);
         this.chanceGrid.itemAlignX = "left";
      }
   }
}

