package net.bigpoint.darkorbit.mvc.gui.windows.plutus.view.components
{
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   
   public class PlutusRecordView
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      public function PlutusRecordView(param1:DisplayObjectContainer)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this.list.itemDataAssigner = PlutusRecordDataAssigner;
      }
      
      public function get list() : ItemList
      {
         return this._cache.selectComponent("root.records.bottom.body.plutus_recordlist") as ItemList;
      }
      
      public function get tabRoot() : Coreponent
      {
         return this._cache.selectComponent("root.records") as Coreponent;
      }
   }
}

