package net.bigpoint.darkorbit.mvc.gui.windows.pvpSummer.view.components
{
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   
   public class PvpSummerOverViewView
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      public function PvpSummerOverViewView(param1:DisplayObjectContainer)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
      }
      
      public function get tabRoot() : Coreponent
      {
         return this._cache.selectComponent("root.overview") as Coreponent;
      }
      
      public function get countdown() : Label
      {
         return this._cache.selectComponent("root.overview.top.right.countdown") as Label;
      }
      
      public function get reputation() : Label
      {
         return this._cache.selectComponent("root.overview.top.right.rep") as Label;
      }
      
      public function get repPerKill() : Label
      {
         return this._cache.selectComponent("root.overview.top.right.rep_per_kill") as Label;
      }
      
      public function get nextRepMilestone() : Label
      {
         return this._cache.selectComponent("root.overview.top.right.next_rep_milestone") as Label;
      }
      
      public function get nextRepMilestoneBtn() : Button
      {
         return this._cache.selectComponent("root.overview.top.right.milestone_btn") as Button;
      }
   }
}

