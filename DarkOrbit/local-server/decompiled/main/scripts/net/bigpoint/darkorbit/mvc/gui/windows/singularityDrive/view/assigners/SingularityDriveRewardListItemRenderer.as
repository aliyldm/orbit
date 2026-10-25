package net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.view.assigners
{
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.com.module.porting.passevent.PassItemModule;
   import net.bigpoint.darkorbit.delete_in_eic.IconVOLoader;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.items.item.Item;
   import net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.model.SingularityDrivePassProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.model.PassItemVo;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class SingularityDriveRewardListItemRenderer extends DefaultItemDataAssigner
   {
      
      protected var _index_label:Label;
      
      protected var _up_bg:Coreponent;
      
      protected var _up_pic:Coreponent;
      
      protected var _up_checkmark:Coreponent;
      
      private var _up_amount:Label;
      
      protected var _down_bg:Coreponent;
      
      protected var _down_pic:Coreponent;
      
      protected var _down_checkmark:Coreponent;
      
      protected var _down_amount:Label;
      
      protected var _item_highlight:Coreponent;
      
      protected var _vipItem:Coreponent;
      
      protected var _normalItem:Coreponent;
      
      protected var _vip_lock:Coreponent;
      
      protected var _item_mask:Coreponent;
      
      private var _proxy:SingularityDrivePassProxy;
      
      protected var itemData:PassItemVo;
      
      public function SingularityDriveRewardListItemRenderer()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         this._index_label = FuiComponentSelectorUtil.selectComponent("index_label",this) as Label;
         this._vipItem = FuiComponentSelectorUtil.selectComponent("up_item",this) as Coreponent;
         this._normalItem = FuiComponentSelectorUtil.selectComponent("down_item",this) as Coreponent;
         this._up_bg = FuiComponentSelectorUtil.selectComponent("up_item.bg",this) as Coreponent;
         this._up_pic = FuiComponentSelectorUtil.selectComponent("up_item.pic",this) as Coreponent;
         this._up_checkmark = FuiComponentSelectorUtil.selectComponent("up_item.checkmark",this) as Coreponent;
         this._up_amount = FuiComponentSelectorUtil.selectComponent("up_item.amount",this) as Label;
         this._down_bg = FuiComponentSelectorUtil.selectComponent("down_item.bg",this) as Coreponent;
         this._down_pic = FuiComponentSelectorUtil.selectComponent("down_item.pic",this) as Coreponent;
         this._down_checkmark = FuiComponentSelectorUtil.selectComponent("down_item.checkmark",this) as Coreponent;
         this._down_amount = FuiComponentSelectorUtil.selectComponent("down_item.amount",this) as Label;
         this._item_highlight = FuiComponentSelectorUtil.selectComponent("item_highlight",this) as Coreponent;
         this._item_mask = FuiComponentSelectorUtil.selectComponent("item_mask",this) as Coreponent;
         this._vip_lock = FuiComponentSelectorUtil.selectComponent("up_item.vip_lock",this) as Coreponent;
         this._up_checkmark.visible = false;
         this._down_checkmark.visible = false;
         this._item_highlight.visible = false;
         this._item_mask.visible = false;
         this.initProxy();
         this._vipItem.addEventListener(MouseEvent.CLICK,this.onClickVipItem);
         this._normalItem.addEventListener(MouseEvent.CLICK,this.onClickNormalItem);
      }
      
      protected function initProxy() : void
      {
         this._proxy = SingularityDrivePassProxy.getProxy();
      }
      
      override public function dispose() : void
      {
         this._vipItem.removeEventListener(MouseEvent.CLICK,this.onClickVipItem);
         this._normalItem.removeEventListener(MouseEvent.CLICK,this.onClickNormalItem);
      }
      
      override public function set data(param1:Object) : void
      {
         if(!param1)
         {
            this.visible = false;
            return;
         }
         this.visible = true;
         this.itemData = param1 as PassItemVo;
         this._index_label.text = this.itemData.index + "";
         this._vip_lock.visible = !this._proxy.viewData.rewardData.isVip;
         this._up_checkmark.visible = this.itemData.vipItem.statusType == PassItemModule.PASSITEMSTATUSTYPE_CLAIMED;
         this._down_checkmark.visible = this.itemData.normalItem.statusType == PassItemModule.PASSITEMSTATUSTYPE_CLAIMED;
         this._item_highlight.visible = this.itemData.vipItem.statusType == PassItemModule.PASSITEMSTATUSTYPE_CLAIMABLE || this.itemData.normalItem.statusType == PassItemModule.PASSITEMSTATUSTYPE_CLAIMABLE;
         this._item_mask.visible = this.itemData.index > this._proxy.viewData.rewardData.currentLevel;
         this._up_amount.text = this.itemData.vipItem.amount + "";
         this._down_amount.text = this.itemData.normalItem.amount + "";
         this.setPic();
      }
      
      private function setPic() : void
      {
         var _loc1_:ItemVO = this.getItemVO(this.itemData.vipItem.lootId);
         if(_loc1_)
         {
            this._vipItem.tooltipData = _loc1_.fullname + "\n" + _loc1_.descriptionName;
            IconVOLoader.getInstance().loadIcon(this._up_pic,_loc1_,"30x30");
         }
         else
         {
            MovieClipUtils.cleanupDisplayObjectContainer(this._up_pic);
         }
         var _loc2_:ItemVO = this.getItemVO(this.itemData.normalItem.lootId);
         if(_loc2_)
         {
            this._normalItem.tooltipData = _loc2_.fullname + "\n" + _loc2_.descriptionName;
            IconVOLoader.getInstance().loadIcon(this._down_pic,_loc2_,"30x30");
         }
         else
         {
            MovieClipUtils.cleanupDisplayObjectContainer(this._down_pic);
         }
      }
      
      private function getItemVO(param1:String) : ItemVO
      {
         return param1.match("package") ? this.parseLootPackage(param1) : ItemDataProviderHelper.getItem(param1);
      }
      
      private function parseLootPackage(param1:String) : ItemVO
      {
         var _loc2_:ItemVO = new ItemVO();
         _loc2_.item = new Item(null,null);
         _loc2_.lootID = param1;
         return _loc2_;
      }
      
      protected function onClickNormalItem(param1:MouseEvent) : void
      {
         if(Boolean(this.itemData) && Boolean(!this._down_checkmark.visible) && this.itemData.normalItem.statusType == PassItemModule.PASSITEMSTATUSTYPE_CLAIMABLE)
         {
            this._proxy.sendPassCliamRequest(0,false);
         }
      }
      
      protected function onClickVipItem(param1:MouseEvent) : void
      {
         if(Boolean(this.itemData) && Boolean(!this._up_checkmark.visible) && this.itemData.vipItem.statusType == PassItemModule.PASSITEMSTATUSTYPE_CLAIMABLE)
         {
            this._proxy.sendPassCliamRequest(0,true);
         }
      }
   }
}

