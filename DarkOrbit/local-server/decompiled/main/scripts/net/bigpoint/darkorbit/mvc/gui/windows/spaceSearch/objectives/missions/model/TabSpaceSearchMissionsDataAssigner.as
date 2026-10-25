package net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.objectives.missions.model
{
   import net.bigpoint.darkorbit.delete_in_eic.IconVOLoader;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.questWindow.model.vo.RewardVO;
   
   public class TabSpaceSearchMissionsDataAssigner extends DefaultItemDataAssigner
   {
      
      private var nameLable:Label;
      
      private var descriptionLabel:Label;
      
      private var amountLabel:Label;
      
      private var icon:Coreponent;
      
      private var icon2:Coreponent;
      
      private var currentVO:TabSpaceSearchMissionsListVO;
      
      public function TabSpaceSearchMissionsDataAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this.nameLable = FuiComponentSelectorUtil.selectComponent("titleLabel",this) as Label;
         this.descriptionLabel = FuiComponentSelectorUtil.selectComponent("descriptionLabel",this) as Label;
         this.amountLabel = FuiComponentSelectorUtil.selectComponent("amountLabel",this) as Label;
         this.icon = FuiComponentSelectorUtil.selectComponent("icon",this) as Coreponent;
         this.icon2 = FuiComponentSelectorUtil.selectComponent("icon2",this) as Coreponent;
      }
      
      private function get vo() : TabSpaceSearchMissionsListVO
      {
         return data as TabSpaceSearchMissionsListVO;
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         this.update();
      }
      
      public function update() : void
      {
         if(!this.vo)
         {
            return;
         }
         this.nameLable.text = "";
         this.descriptionLabel.text = this.vo.description;
         var _loc1_:RewardVO = this.vo.quest.rewards[0] as RewardVO;
         var _loc2_:ItemVO = ItemDataProviderHelper.getItem(_loc1_.lootId);
         IconVOLoader.getInstance().loadIcon(this.icon,_loc2_,"100x100",AssetsProxy.ITEMS);
         this.amountLabel.text = _loc1_.amount + "";
         this.icon2.visible = this.vo.completed;
         IconVOLoader.getInstance().loadIcon(this.icon2,null,"ss_get_icon",AssetsProxy.EVENTS);
         this.currentVO = this.vo;
      }
   }
}

