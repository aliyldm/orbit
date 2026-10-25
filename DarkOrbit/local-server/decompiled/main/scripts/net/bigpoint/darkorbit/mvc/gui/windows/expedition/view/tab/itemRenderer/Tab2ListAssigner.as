package net.bigpoint.darkorbit.mvc.gui.windows.expedition.view.tab.itemRenderer
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.model.vo.BoxesVo;
   
   public class Tab2ListAssigner extends DefaultItemDataAssigner
   {
      
      private var _nameLabel:Label;
      
      public function Tab2ListAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._nameLabel = FuiComponentSelectorUtil.selectComponent("reward_name_label",this) as Label;
         this.rewardItem.itemDataAssigner = Tab2ItemAssigner;
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:BoxesVo = param1 as BoxesVo;
         switch(_loc2_.rateId)
         {
            case "1":
               this._nameLabel.text = "" + BPLocale.getItem("window_dse_boxes_low_rate");
               break;
            case "2":
               this._nameLabel.text = "" + BPLocale.getItem("window_dse_boxes_medium_rate");
               break;
            case "3":
               this._nameLabel.text = "" + BPLocale.getItem("window_dse_boxes_high_rate");
         }
         this.itemReward = _loc2_.itemList;
      }
      
      public function get rewardItem() : ItemList
      {
         return FuiComponentSelectorUtil.selectComponent("item_list",this) as ItemList;
      }
      
      public function set itemReward(param1:Vector.<String>) : void
      {
         this.rewardItem.list = new VectorCollection(param1);
      }
   }
}

