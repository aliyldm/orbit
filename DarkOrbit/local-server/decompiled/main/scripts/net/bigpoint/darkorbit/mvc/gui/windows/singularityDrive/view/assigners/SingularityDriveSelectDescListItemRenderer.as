package net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.view.assigners
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.components.tooltip.DefaultTooltipDataAssigner;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.model.SingularityDrivePassProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.model.SingularityDriveSelectDescItemData;
   
   public class SingularityDriveSelectDescListItemRenderer extends DefaultItemDataAssigner
   {
      
      private var _star_0:Coreponent;
      
      private var _star_1:Coreponent;
      
      private var _star_2:Coreponent;
      
      private var _info_label:Label;
      
      private var _indo_tip_btn:Button;
      
      private var _proxy:SingularityDrivePassProxy;
      
      private var itemData:SingularityDriveSelectDescItemData;
      
      public function SingularityDriveSelectDescListItemRenderer()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         this._star_0 = FuiComponentSelectorUtil.selectComponent("star_group.star_0",this) as Coreponent;
         this._star_1 = FuiComponentSelectorUtil.selectComponent("star_group.star_1",this) as Coreponent;
         this._star_2 = FuiComponentSelectorUtil.selectComponent("star_group.star_2",this) as Coreponent;
         this._info_label = FuiComponentSelectorUtil.selectComponent("info_label_group.info_label",this) as Label;
         this._indo_tip_btn = FuiComponentSelectorUtil.selectComponent("info_label_group.infog_tip_btn",this) as Button;
         this._proxy = SingularityDrivePassProxy.getProxy();
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc3_:Coreponent = null;
         if(!param1)
         {
            return;
         }
         (this._indo_tip_btn.tooltipDataAssigner as DefaultTooltipDataAssigner).maxWidth = 250;
         this.itemData = param1 as SingularityDriveSelectDescItemData;
         var _loc2_:int = 0;
         while(_loc2_ <= 2)
         {
            _loc3_ = this["_star_" + _loc2_] as Coreponent;
            if(this.itemData.index >= _loc2_)
            {
               _loc3_.registeredSkinName = "singularitydrive_selec_star_1";
            }
            else
            {
               _loc3_.registeredSkinName = "singularitydrive_selec_star_0";
            }
            _loc2_++;
         }
         this._info_label.text = BPLocale.getItem("voyagersascentrial_difficulty_start" + (this.itemData.index + 1));
         this._indo_tip_btn.tooltipData = this._proxy.viewData.getGateRewardTipDataByIndex(this.itemData.index);
      }
   }
}

