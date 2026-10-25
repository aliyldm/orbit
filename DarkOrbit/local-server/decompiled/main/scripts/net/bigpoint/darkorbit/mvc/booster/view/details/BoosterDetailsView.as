package net.bigpoint.darkorbit.mvc.booster.view.details
{
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.ICollection;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.booster.model.BoosterCategory;
   
   public class BoosterDetailsView
   {
      
      private var _view:Coreponent;
      
      private var _data:BoosterCategory;
      
      private var _filterActive:Boolean;
      
      public function BoosterDetailsView(param1:Coreponent)
      {
         super();
         this._view = param1;
         this.list.itemDataAssigner = BoosterDetailDataAssigner;
         this.root.visible = false;
      }
      
      private function update() : void
      {
         var _loc1_:ICollection = null;
         if(this._data)
         {
            this.header.text = this._data.translation;
            BoosterDetailDataAssigner.currentData = this._data;
            this.root.visible = true;
            _loc1_ = this._data.getAsBoosterList(this._filterActive);
            this.list.list = _loc1_;
         }
         else
         {
            BoosterDetailDataAssigner.currentData = null;
            this.root.visible = false;
            this.list.list = new VectorCollection(null);
         }
      }
      
      public function set data(param1:BoosterCategory) : void
      {
         if(this._data)
         {
            this._data.changed.remove(this.update);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.changed.add(this.update);
         }
         this.update();
      }
      
      private function get list() : ItemList
      {
         return FuiComponentSelectorUtil.selectComponent("detailContainer.boosterDetailList",this._view) as ItemList;
      }
      
      private function get header() : Label
      {
         return FuiComponentSelectorUtil.selectComponent("detailContainer.category",this._view) as Label;
      }
      
      private function get root() : Container
      {
         return FuiComponentSelectorUtil.selectComponent("detailContainer",this._view) as Container;
      }
      
      public function set filterActive(param1:Boolean) : void
      {
         this._filterActive = param1;
         this.update();
      }
   }
}

