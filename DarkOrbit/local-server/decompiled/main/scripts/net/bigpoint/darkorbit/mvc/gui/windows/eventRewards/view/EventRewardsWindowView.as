package net.bigpoint.darkorbit.mvc.gui.windows.eventRewards.view
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.com.module.RewardContentModule;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   
   public class EventRewardsWindowView
   {
      
      private var _view:Sprite;
      
      private var _data:Vector.<RewardContentModule>;
      
      public function EventRewardsWindowView(param1:Sprite)
      {
         super();
         this._view = param1;
         this.list.itemDataAssigner = EventRewardsDataAssigner;
         this.list.itemGap = 1.8;
         this.list.list = new VectorCollection(null);
      }
      
      private function get list() : ItemList
      {
         return FuiComponentSelectorUtil.selectComponent("root.contentContainer.infoContainer.rewards_container.eventRewardsList",this._view) as ItemList;
      }
      
      private function update() : void
      {
         if(this._data)
         {
            this.list.list = new VectorCollection(this._data);
         }
         else
         {
            this.list.list = new VectorCollection(null);
         }
      }
      
      public function set data(param1:Vector.<RewardContentModule>) : void
      {
         if(!this._data)
         {
         }
         this._data = param1;
         this.update();
      }
   }
}

