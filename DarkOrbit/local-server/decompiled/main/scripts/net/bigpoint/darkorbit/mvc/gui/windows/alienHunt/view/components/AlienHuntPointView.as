package net.bigpoint.darkorbit.mvc.gui.windows.alienHunt.view.components
{
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   
   public class AlienHuntPointView
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      public function AlienHuntPointView(param1:DisplayObjectContainer)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this.npcList.itemDataAssigner = AlienHuntNPCDataAssigner;
      }
      
      public function get npcList() : ItemList
      {
         return this._cache.selectComponent("root.points.body.npcList") as ItemList;
      }
      
      public function get tabRoot() : Coreponent
      {
         return this._cache.selectComponent("root.points") as Coreponent;
      }
   }
}

