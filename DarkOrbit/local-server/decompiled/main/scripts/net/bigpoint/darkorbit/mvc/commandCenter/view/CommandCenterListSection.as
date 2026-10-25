package net.bigpoint.darkorbit.mvc.commandCenter.view
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.commandCenter.model.CommandCenterCategory;
   
   public class CommandCenterListSection
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      public function CommandCenterListSection(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this.list.itemDataAssigner = CommandCenterCategoryListDataAssigner;
      }
      
      public function get list() : ItemList
      {
         return this._cache.selectComponent("contentContainer.categoriesList") as ItemList;
      }
      
      public function updateNews(param1:Vector.<CommandCenterCategory>) : void
      {
         var _loc3_:int = 0;
         var _loc5_:CommandCenterCategory = null;
         this.list.list = new VectorCollection(param1);
         var _loc2_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = param1[_loc4_];
            if(_loc5_.isSpecial)
            {
               _loc3_ = _loc4_;
               break;
            }
            _loc4_++;
         }
         this.list.selectedIndex = _loc3_;
      }
   }
}

