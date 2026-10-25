package net.bigpoint.darkorbit.mvc.gui.windows.battlePass.view.components
{
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.scroll.Scrollbar;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.components.video.VideoPlayer;
   import net.bigpoint.darkorbit.fui.system.utils.BindingsUtils;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   
   public class BattlePassObjectiveView
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      public function BattlePassObjectiveView(param1:DisplayObjectContainer)
      {
         var original:ItemList = null;
         var scrollbar:Scrollbar = null;
         var template:XML = null;
         var listXML:XML = null;
         var parent:DisplayObjectContainer = null;
         var index:int = 0;
         var replacement:BattlePassObjectiveList = null;
         var view:DisplayObjectContainer = param1;
         super();
         this._cache = new FuiComponentSelectorCache(view);
         original = this.list;
         scrollbar = this._cache.selectComponent("root.objective_parent.body.battlepass_objectiveslist_scrollBar") as Scrollbar;
         template = UISystem.getInstance().getTemplate("BATTLEPASS_OVERVIEW") as XML;
         listXML = template.descendants("itemlist").(@name == "battlepass_objectiveslist")[0];
         BindingsUtils.unbindScrollComponentsByBindingID(original.bindingID);
         parent = original.parent;
         index = parent.getChildIndex(original);
         parent.removeChild(original);
         original.dispose();
         replacement = BattlePassObjectiveList.createFromXML(listXML);
         parent.addChildAt(replacement,index);
         replacement.assignChildren();
         this._cache = new FuiComponentSelectorCache(view);
         BindingsUtils.bindScrollComponents(replacement,scrollbar);
         this.list.itemDataAssigner = BattlePassDataAssigner;
      }
      
      public function get tab() : Coreponent
      {
         return this._cache.selectComponent("root.objective_parent") as Coreponent;
      }
      
      public function get list() : ItemList
      {
         return this._cache.selectComponent("root.objective_parent.body.battlepass_objectiveslist") as ItemList;
      }
      
      public function get overallProgress() : Label
      {
         return this._cache.selectComponent("root.objective_parent.top.overall_progress") as Label;
      }
      
      public function get video() : VideoPlayer
      {
         return this._cache.selectComponent("root.objective_parent.bottom.vid") as VideoPlayer;
      }
      
      public function get descriptionTitle() : Label
      {
         return this._cache.selectComponent("root.objective_parent.bottom.description_title") as Label;
      }
      
      public function get descriptionBody() : Label
      {
         return this._cache.selectComponent("root.objective_parent.bottom.description_body.scrollContainerText.content") as Label;
      }
      
      public function get purchaseButton() : Button
      {
         return this._cache.selectComponent("root.objective_parent.bottom.purchase_btn") as Button;
      }
      
      public function get collectButton() : Button
      {
         return this._cache.selectComponent("root.objective_parent.bottom.collect_btn") as Button;
      }
   }
}

