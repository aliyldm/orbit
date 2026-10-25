package net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.rewards.view.component
{
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.items.item.attributes.BoosterAttributes;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.rewards.model.vo.SeasonPassLevelItemVO;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class SeasonPassLevelItemAssigner extends DefaultItemDataAssigner
   {
      
      protected var _bg_mid:Coreponent;
      
      protected var _bg_end:Coreponent;
      
      protected var _freettipLayer:Coreponent;
      
      protected var _freebg:Coreponent;
      
      protected var _freeItemIcon:Coreponent;
      
      protected var _freeItemAmount:Label;
      
      protected var _freeIconClaimed:Coreponent;
      
      protected var _goldttipLayer:Coreponent;
      
      protected var _goldbg:Coreponent;
      
      protected var _goldItemIcon:Coreponent;
      
      protected var _goldItemAmount:Label;
      
      protected var _goldIconClaimed:Coreponent;
      
      protected var _extGoldttipLayer:Coreponent;
      
      protected var _extGoldbg:Coreponent;
      
      protected var _extGoldItemIcon:Coreponent;
      
      protected var _extGoldItemAmount:Label;
      
      protected var _extGoldIconClaimed:Coreponent;
      
      protected var _goldLock:Coreponent;
      
      protected var _extGoldLock:Coreponent;
      
      public function SeasonPassLevelItemAssigner()
      {
         super();
      }
      
      private static function getItemDescription(param1:ItemVO) : String
      {
         if(param1.typeValue == "BOOSTER")
         {
            return BPLocale.getItem("sp_booster-reward-ttip") + " " + translateBoosterDescription(param1);
         }
         return param1.descriptionName;
      }
      
      private static function translateBoosterDescription(param1:ItemVO) : String
      {
         var _loc2_:BoosterAttributes = param1.item.attributes as BoosterAttributes;
         return param1.rawDescription.replace("%BOOSTERVALUE%",_loc2_.boostList[0].factor).replace("%HOURS%",1).replace("%AREABOOSTERVALUE%",_loc2_.boostList[0].areaFactor);
      }
      
      override public function set data(param1:Object) : void
      {
         if(this.vo)
         {
            this.vo.freeItemClaimedBindable.changed.removeAll();
            this.vo.goldItemClaimedBindable.changed.removeAll();
            this.vo.levelClaimableBindable.changed.removeAll();
            this.vo.extGoldItemClaimedBindable.changed.removeAll();
         }
         super.data = param1;
         if(this.vo)
         {
            this.update();
            this.vo.freeItemClaimedBindable.changed.add(this.updateFreeClaimStatus);
            this.vo.goldItemClaimedBindable.changed.add(this.updateGoldClaimStatus);
            this.vo.levelClaimableBindable.changed.add(this.updateClaimableStatus);
            this.vo.extGoldItemClaimedBindable.changed.add(this.updateExtGoldClaimStatus);
         }
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._bg_mid = FuiComponentSelectorUtil.selectComponent("bg_mid",this) as Coreponent;
         this._bg_end = FuiComponentSelectorUtil.selectComponent("bg_end",this) as Coreponent;
         this._freettipLayer = FuiComponentSelectorUtil.selectComponent("free_ttiplayer",this) as Coreponent;
         this._freebg = FuiComponentSelectorUtil.selectComponent("free_bg",this) as Button;
         this._freeItemIcon = FuiComponentSelectorUtil.selectComponent("free_item",this) as Coreponent;
         this._freeItemAmount = FuiComponentSelectorUtil.selectComponent("free_amount",this) as Label;
         this._freeIconClaimed = FuiComponentSelectorUtil.selectComponent("free_claimed",this) as Coreponent;
         this._goldttipLayer = FuiComponentSelectorUtil.selectComponent("gold_ttiplayer",this) as Coreponent;
         this._goldbg = FuiComponentSelectorUtil.selectComponent("gold_bg",this) as Button;
         this._goldItemIcon = FuiComponentSelectorUtil.selectComponent("gold_item",this) as Coreponent;
         this._goldItemAmount = FuiComponentSelectorUtil.selectComponent("gold_amount",this) as Label;
         this._goldIconClaimed = FuiComponentSelectorUtil.selectComponent("gold_claimed",this) as Coreponent;
         this._extGoldttipLayer = FuiComponentSelectorUtil.selectComponent("ext_gold_ttiplayer",this) as Coreponent;
         this._extGoldbg = FuiComponentSelectorUtil.selectComponent("ext_gold_bg",this) as Button;
         this._extGoldItemIcon = FuiComponentSelectorUtil.selectComponent("ext_gold_item",this) as Coreponent;
         this._extGoldItemAmount = FuiComponentSelectorUtil.selectComponent("ext_gold_amount",this) as Label;
         this._extGoldIconClaimed = FuiComponentSelectorUtil.selectComponent("ext_gold_claimed",this) as Coreponent;
         this._goldLock = FuiComponentSelectorUtil.selectComponent("gold_lock",this) as Coreponent;
         this._extGoldLock = FuiComponentSelectorUtil.selectComponent("ext_gold_lock",this) as Coreponent;
         this._freebg.addEventListener(MouseEvent.CLICK,this.handleFreeItemClickEvent);
         this._goldbg.addEventListener(MouseEvent.CLICK,this.handleGoldItemClickEvent);
         this._extGoldbg.addEventListener(MouseEvent.CLICK,this.handleExtGoldItemClickEvent);
         this._freebg.addEventListener(MouseEvent.MOUSE_OVER,this.handleHoverFreeItemEvent);
         this._goldbg.addEventListener(MouseEvent.MOUSE_OVER,this.handleHoverGoldItemEvent);
         this._extGoldbg.addEventListener(MouseEvent.MOUSE_OVER,this.handleHoverExtGoldItemEvent);
         this._freettipLayer.addEventListener(MouseEvent.MOUSE_OVER,this.handleHoverFreeItemEvent);
         this._goldttipLayer.addEventListener(MouseEvent.MOUSE_OVER,this.handleHoverGoldItemEvent);
         this._extGoldttipLayer.addEventListener(MouseEvent.MOUSE_OVER,this.handleHoverExtGoldItemEvent);
      }
      
      override public function set index(param1:int) : void
      {
         super.index = param1;
         label.text = param1 + 1 + "";
         if(param1 % 10 == 9)
         {
            this._bg_mid.visible = false;
            this._bg_end.visible = true;
         }
         else
         {
            this._bg_mid.visible = true;
            this._bg_end.visible = false;
         }
      }
      
      protected function get vo() : SeasonPassLevelItemVO
      {
         return this.data as SeasonPassLevelItemVO;
      }
      
      protected function update() : void
      {
         var _loc1_:SeasonPassLevelItemVO = this.vo;
         if(_loc1_ == null)
         {
            return;
         }
         this.updateFreeItem(_loc1_.freeItemVO);
         this.updateGoldItem(_loc1_.goldItemVO,_loc1_.isGoldLocked);
         this.updateExtGoldItem(_loc1_.extGoldItemVO,_loc1_.isExtGoldLocked);
      }
      
      private function updateFreeItem(param1:ItemVO) : void
      {
         this._freeItemIcon.removeAllCoreponents();
         if(param1 == null)
         {
            this._freebg.visible = false;
            this._freeItemIcon.visible = false;
            this._freeItemAmount.visible = false;
            this._freeIconClaimed.visible = false;
         }
         else
         {
            this._freebg.visible = true;
            this._freeItemIcon.visible = true;
            this._freeItemAmount.visible = true;
            loadResource(param1.getLoot100x100(Hero.factionName),this.handleFreeItemLoadComplete,this.handleFreeItemLoadFail,AssetsProxy.ITEMS);
            this._freeItemAmount.text = param1.amount + "x";
            this.updateFreeClaimStatus();
         }
      }
      
      private function updateGoldItem(param1:ItemVO, param2:Boolean) : void
      {
         this._goldItemIcon.removeAllCoreponents();
         if(param1 == null)
         {
            this._goldbg.visible = false;
            this._goldItemIcon.visible = false;
            this._goldItemAmount.visible = false;
            this._goldIconClaimed.visible = false;
            this._goldLock.visible = false;
         }
         else
         {
            this._goldbg.visible = true;
            this._goldItemIcon.visible = true;
            this._goldItemAmount.visible = true;
            loadResource(param1.getLoot100x100(Hero.factionName),this.handleGoldItemLoadComplete,this.handleGoldItemLoadFail,AssetsProxy.ITEMS);
            this._goldItemAmount.text = param1.amount + "x";
            this._goldLock.visible = param2;
            this.updateGoldClaimStatus();
         }
      }
      
      private function updateExtGoldItem(param1:ItemVO, param2:Boolean) : void
      {
         this._extGoldItemIcon.removeAllCoreponents();
         if(param1 == null)
         {
            this._extGoldbg.visible = false;
            this._extGoldItemIcon.visible = false;
            this._extGoldItemAmount.visible = false;
            this._extGoldIconClaimed.visible = false;
            this._extGoldLock.visible = false;
         }
         else
         {
            this._extGoldbg.visible = true;
            this._extGoldItemIcon.visible = true;
            this._extGoldItemAmount.visible = true;
            loadResource(param1.getLoot100x100(Hero.factionName),this.handleExtGoldItemLoadComplete,this.handleExtGoldItemLoadFail,AssetsProxy.ITEMS);
            this._extGoldItemAmount.text = param1.amount + "x";
            this._extGoldLock.visible = param2;
            this.updateExtGoldClaimStatus();
            if(!this.vo.isExtGoldLocked && this.vo.isGoldLocked)
            {
               this.updateExtGoldClaimableStatus(false);
            }
         }
      }
      
      protected function handleGoldItemLoadFail(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._goldItemIcon);
      }
      
      protected function handleFreeItemLoadFail(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._freeItemIcon);
      }
      
      protected function handleExtGoldItemLoadFail(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._extGoldItemIcon);
      }
      
      protected function handleGoldItemLoadComplete(param1:ImageFinisher) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._goldItemIcon);
         var _loc2_:Bitmap = new Bitmap(param1.getBitmap().bitmapData);
         _loc2_.width = 30;
         _loc2_.height = 30;
         this._goldItemIcon.addChild(_loc2_);
      }
      
      protected function handleFreeItemLoadComplete(param1:ImageFinisher) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._freeItemIcon);
         var _loc2_:Bitmap = new Bitmap(param1.getBitmap().bitmapData);
         _loc2_.width = 30;
         _loc2_.height = 30;
         this._freeItemIcon.addChild(_loc2_);
      }
      
      protected function handleExtGoldItemLoadComplete(param1:ImageFinisher) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._extGoldItemIcon);
         var _loc2_:Bitmap = new Bitmap(param1.getBitmap().bitmapData);
         _loc2_.width = 30;
         _loc2_.height = 30;
         this._extGoldItemIcon.addChild(_loc2_);
      }
      
      protected function handleFreeItemClickEvent(param1:Event) : void
      {
         if(this.vo.isFreeItemClaimed)
         {
            return;
         }
         this.vo.onClaimItem.dispatch(this.index,false,false);
      }
      
      protected function handleGoldItemClickEvent(param1:Event) : void
      {
         if(this.vo.isGoldLocked)
         {
            return;
         }
         if(this.vo.isGoldItemClaimed)
         {
            return;
         }
         this.vo.onClaimItem.dispatch(this.index,true,false);
      }
      
      protected function handleExtGoldItemClickEvent(param1:Event) : void
      {
         if(this.vo.isExtGoldLocked)
         {
            return;
         }
         if(this.vo.isExtGoldItemClaimed)
         {
            return;
         }
         if(!this.vo.isExtGoldLocked && this.vo.isGoldLocked)
         {
            return;
         }
         this.vo.onClaimItem.dispatch(this.index,false,true);
      }
      
      protected function handleHoverFreeItemEvent(param1:Event) : void
      {
         if(this.vo.freeItemVO == null)
         {
            tooltipData = "";
         }
         else
         {
            tooltipData = this.vo.freeItemVO.fullname + "\n\n" + getItemDescription(this.vo.freeItemVO);
         }
      }
      
      protected function handleHoverGoldItemEvent(param1:Event) : void
      {
         var _loc2_:String = null;
         if(this.vo.goldItemVO == null)
         {
            tooltipData = "";
         }
         else
         {
            _loc2_ = this.vo.goldItemVO.fullname + "\n\n" + getItemDescription(this.vo.goldItemVO);
            if(this.vo.isGoldLocked)
            {
               _loc2_ = BPLocale.getItem("ttip_sp_error_hover-gp-item") + "\n\n" + _loc2_;
            }
            tooltipData = _loc2_;
         }
      }
      
      protected function handleHoverExtGoldItemEvent(param1:Event) : void
      {
         var _loc2_:String = null;
         if(this.vo.extGoldItemVO == null)
         {
            tooltipData = "";
         }
         else
         {
            _loc2_ = this.vo.extGoldItemVO.fullname + "\n\n" + getItemDescription(this.vo.extGoldItemVO);
            if(this.vo.isExtGoldLocked)
            {
               _loc2_ = BPLocale.getItem("ttip_sp_error_hover-ext-gp-item") + "\n\n" + _loc2_;
            }
            tooltipData = _loc2_;
         }
      }
      
      private function updateFreeClaimStatus() : void
      {
         var _loc1_:Boolean = this.vo.isFreeItemClaimed;
         this._freeIconClaimed.visible = _loc1_;
         this.updateFreeClaimableStatus(this.vo.isFreeItemClaimable);
      }
      
      private function updateGoldClaimStatus() : void
      {
         var _loc1_:Boolean = this.vo.isGoldItemClaimed;
         this._goldIconClaimed.visible = _loc1_;
         this.updateGoldClaimableStatus(this.vo.isGoldItemClaimable);
      }
      
      private function updateExtGoldClaimStatus() : void
      {
         var _loc1_:Boolean = this.vo.isExtGoldItemClaimed;
         this._extGoldIconClaimed.visible = _loc1_;
         this.updateExtGoldClaimableStatus(this.vo.isExtGoldItemClaimable);
      }
      
      private function updateClaimableStatus() : void
      {
         this.updateFreeClaimableStatus(this.vo.isFreeItemClaimable);
         this.updateGoldClaimableStatus(this.vo.isGoldItemClaimable);
         this.updateExtGoldClaimableStatus(this.vo.isExtGoldItemClaimed);
      }
      
      private function updateFreeClaimableStatus(param1:Boolean) : void
      {
         this._freebg.enabled = param1;
         this._freettipLayer.visible = !param1;
         if(param1)
         {
            this._freeItemAmount.alpha = 1;
            this._freeItemIcon.alpha = 1;
         }
         else
         {
            this._freeItemAmount.alpha = 0.5;
            this._freeItemIcon.alpha = 0.4;
         }
      }
      
      private function updateGoldClaimableStatus(param1:Boolean) : void
      {
         this._goldbg.enabled = param1;
         this._goldttipLayer.visible = !param1;
         if(param1)
         {
            this._goldItemAmount.alpha = 1;
            this._goldItemIcon.alpha = 1;
         }
         else
         {
            this._goldItemAmount.alpha = 0.5;
            this._goldItemIcon.alpha = 0.4;
         }
      }
      
      private function updateExtGoldClaimableStatus(param1:Boolean) : void
      {
         this._extGoldbg.enabled = param1;
         this._extGoldttipLayer.visible = !param1;
         if(param1)
         {
            this._extGoldItemAmount.alpha = 1;
            this._extGoldItemIcon.alpha = 1;
         }
         else
         {
            this._extGoldItemAmount.alpha = 0.5;
            this._extGoldItemIcon.alpha = 0.4;
         }
      }
   }
}

