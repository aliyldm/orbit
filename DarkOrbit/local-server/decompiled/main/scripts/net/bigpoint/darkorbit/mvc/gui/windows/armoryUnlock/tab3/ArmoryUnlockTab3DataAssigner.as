package net.bigpoint.darkorbit.mvc.gui.windows.armoryUnlock.tab3
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.porting.armoryunlock.ArmoryUnlockClaimInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.armoryunlock.ArmoryUnlockClaimRequest;
   import net.bigpoint.darkorbit.delete_in_eic.IconVO;
   import net.bigpoint.darkorbit.delete_in_eic.IconVOLoader;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class ArmoryUnlockTab3DataAssigner extends DefaultItemDataAssigner
   {
      
      public const requestExchange:ISignal = new Signal(int);
      
      private var nameLabel:Label;
      
      private var _verticalDivider1:Coreponent;
      
      private var _verticalDivider2:Coreponent;
      
      private var _itemEndDivider:Coreponent;
      
      private var _bg:Coreponent;
      
      private var _bg_special:Coreponent;
      
      private var _icon_bg:Coreponent;
      
      private var _icon_bg_special:Coreponent;
      
      private var _icon_icon:Coreponent;
      
      private var _icon_btn:Button;
      
      private var _icon_amount:Label;
      
      private var _item_bg:Coreponent;
      
      private var _item_bg_special:Coreponent;
      
      private var _item_name:Label;
      
      private var _item_description:Label;
      
      private var _cost_exchange_btn:Button;
      
      private var _cost_claimedLabel:Label;
      
      private var iconLoader:IconVO;
      
      public function ArmoryUnlockTab3DataAssigner()
      {
         super();
      }
      
      override public function set data(param1:Object) : void
      {
         this.removeListeners();
         super.data = param1;
         this.addListeners();
         this.update();
      }
      
      public function update() : void
      {
         var _loc1_:ArmoryUnlockClaimInfoCommand = null;
         var _loc2_:ItemVO = null;
         _loc1_ = this.data as ArmoryUnlockClaimInfoCommand;
         if(!_loc1_)
         {
            return;
         }
         if(this.iconLoader)
         {
            this.iconLoader.stop();
            this.iconLoader = null;
         }
         _loc2_ = ItemDataProviderHelper.getItem(_loc1_.lootId);
         this.nameLabel.text = _loc2_.fullname;
         this.iconLoader = IconVOLoader.getInstance().loadIcon(this._icon_icon,_loc2_,"100x100",AssetsProxy.ITEMS);
         this._item_name.text = BPLocale.getItem("armoryunlock_reward_conditions").replace("%VALUE%",_loc1_.progressQuantity);
         this._item_description.text = "( " + _loc1_.currentProgress + "/" + _loc1_.progressQuantity + " )";
         this._icon_amount.text = "" + _loc1_.lootAmount;
         this._cost_exchange_btn.enabled = _loc1_.canClaim;
         this._cost_exchange_btn.visible = !_loc1_.claimed;
         this._cost_claimedLabel.visible = _loc1_.claimed;
         _loc1_.index;
         this._icon_btn.tooltipData = _loc2_.fullname;
         this.setBG(_loc1_.special);
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this.nameLabel = FuiComponentSelectorUtil.selectComponent("name",this) as Label;
         this._verticalDivider1 = FuiComponentSelectorUtil.selectComponent("vertical_divider_1",this) as Coreponent;
         this._verticalDivider2 = FuiComponentSelectorUtil.selectComponent("vertical_divider_2",this) as Coreponent;
         this._itemEndDivider = FuiComponentSelectorUtil.selectComponent("item_end_divider",this) as Coreponent;
         this._bg = FuiComponentSelectorUtil.selectComponent("bg",this) as Coreponent;
         this._bg_special = FuiComponentSelectorUtil.selectComponent("bg_special",this) as Coreponent;
         this._icon_bg = FuiComponentSelectorUtil.selectComponent("icon.bg",this) as Coreponent;
         this._icon_bg_special = FuiComponentSelectorUtil.selectComponent("icon.bg_special",this) as Coreponent;
         this._icon_icon = FuiComponentSelectorUtil.selectComponent("icon.icon",this) as Coreponent;
         this._icon_btn = FuiComponentSelectorUtil.selectComponent("icon.btn",this) as Button;
         this._icon_amount = FuiComponentSelectorUtil.selectComponent("icon.amount",this) as Label;
         this._item_bg = FuiComponentSelectorUtil.selectComponent("item.bg",this) as Coreponent;
         this._item_bg_special = FuiComponentSelectorUtil.selectComponent("item.bg_special",this) as Coreponent;
         this._item_name = FuiComponentSelectorUtil.selectComponent("item.name",this) as Label;
         this._item_description = FuiComponentSelectorUtil.selectComponent("item.description",this) as Label;
         this._cost_exchange_btn = FuiComponentSelectorUtil.selectComponent("cost.exchange_btn",this) as Button;
         this._cost_claimedLabel = FuiComponentSelectorUtil.selectComponent("cost.claimedLabel",this) as Label;
      }
      
      private function setBG(param1:Boolean) : void
      {
         this._bg.visible = !param1;
         this._bg_special.visible = param1;
         this._item_bg.visible = !param1;
         this._item_bg_special.visible = param1;
         this._icon_bg.visible = !param1;
         this._icon_bg_special.visible = param1;
         this.drawDivider(param1);
      }
      
      private function drawDivider(param1:Boolean) : *
      {
         var _loc2_:Sprite = null;
         if(this._verticalDivider1 != null)
         {
            if(this._verticalDivider1.numChildren > 0)
            {
               this._verticalDivider1.removeChildAt(0);
            }
            _loc2_ = new Sprite();
            _loc2_.graphics.lineStyle(1,param1 ? 16776960 : 3631231);
            _loc2_.graphics.lineTo(0,this._verticalDivider1.height);
            this._verticalDivider1.addChild(_loc2_);
         }
         if(this._verticalDivider2 != null)
         {
            if(this._verticalDivider2.numChildren > 0)
            {
               this._verticalDivider2.removeChildAt(0);
            }
            _loc2_ = new Sprite();
            _loc2_.graphics.lineStyle(1,param1 ? 16776960 : 3631231);
            _loc2_.graphics.lineTo(0,this._verticalDivider2.height);
            this._verticalDivider2.addChild(_loc2_);
         }
         if(this._itemEndDivider != null)
         {
            if(this._itemEndDivider.numChildren > 0)
            {
               this._itemEndDivider.removeChildAt(0);
            }
            _loc2_ = new Sprite();
            _loc2_.graphics.lineStyle(1,3631231);
            _loc2_.graphics.lineTo(this._itemEndDivider.width,0);
            this._itemEndDivider.addChild(_loc2_);
         }
      }
      
      private function sendExchangeRequest(param1:MouseEvent) : void
      {
         var _loc3_:ArmoryUnlockClaimRequest = null;
         var _loc2_:ArmoryUnlockClaimInfoCommand = this.data as ArmoryUnlockClaimInfoCommand;
         if(_loc2_)
         {
            if(_loc2_.canClaim && !_loc2_.claimed)
            {
               this.requestExchange.dispatch(_loc2_.index);
               this._cost_exchange_btn.enabled = false;
               this._cost_exchange_btn.visible = false;
               this._cost_claimedLabel.visible = true;
               this.removeListeners();
               _loc3_ = new ArmoryUnlockClaimRequest();
               _loc3_.index = _loc2_.index;
               GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc3_);
            }
         }
      }
      
      private function addListeners() : void
      {
         var _loc1_:ArmoryUnlockClaimInfoCommand = this.data as ArmoryUnlockClaimInfoCommand;
         if(_loc1_)
         {
            if(_loc1_.canClaim && !_loc1_.claimed)
            {
               if(this._cost_exchange_btn)
               {
                  this._cost_exchange_btn.addEventListener(MouseEvent.CLICK,this.sendExchangeRequest);
               }
            }
         }
      }
      
      private function removeListeners() : void
      {
         if(this._cost_exchange_btn)
         {
            this._cost_exchange_btn.removeEventListener(MouseEvent.CLICK,this.sendExchangeRequest);
         }
      }
   }
}

