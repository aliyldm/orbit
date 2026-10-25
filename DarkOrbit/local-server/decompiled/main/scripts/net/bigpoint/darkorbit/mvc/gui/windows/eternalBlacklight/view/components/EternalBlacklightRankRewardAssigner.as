package net.bigpoint.darkorbit.mvc.gui.windows.eternalBlacklight.view.components
{
   import com.bealearts.collection.VectorCollection;
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.RewardsToolTipAssigner;
   import net.bigpoint.darkorbit.mvc.gui.windows.eternalBlacklight.model.vo.EternalBlacklightPlaceVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.eternalBlacklight.view.components.event.EternalBlacklightEvent;
   
   public class EternalBlacklightRankRewardAssigner extends DefaultItemDataAssigner
   {
      
      private var _leftBG:Coreponent;
      
      private var _label:Label;
      
      private var _rewardBTN:Button;
      
      public function EternalBlacklightRankRewardAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._leftBG = FuiComponentSelectorUtil.selectComponent("left.bg",this) as Coreponent;
         this._label = FuiComponentSelectorUtil.selectComponent("left.place",this) as Label;
         this._rewardBTN = FuiComponentSelectorUtil.selectComponent("left.btn",this) as Button;
         this._rewardBTN.tooltipTemplateID = "eternalBlacklightRewardToolTip";
         this._rewardBTN.addEventListener(MouseEvent.MOUSE_OVER,this.handlePlayerOver);
         this._rewardBTN.tooltipDataAssigner = new RewardsToolTipAssigner();
      }
      
      private function handlePlayerOver(param1:MouseEvent) : void
      {
         var _loc2_:EternalBlacklightPlaceVO = data as EternalBlacklightPlaceVO;
         if(Boolean(_loc2_) && Boolean(_loc2_.playerRewards) && _loc2_.playerRewards.length == 0)
         {
            dispatchEvent(new EternalBlacklightEvent(EternalBlacklightEvent.REQUEST_PLAYER_DATA,_loc2_));
         }
      }
      
      override public function set data(param1:Object) : void
      {
         if(param1 == data)
         {
            super.data = param1;
         }
         else
         {
            this.removeListeners();
            super.data = param1;
            this.addListeners();
            this.update();
         }
      }
      
      private function addListeners() : void
      {
         var _loc1_:EternalBlacklightPlaceVO = data as EternalBlacklightPlaceVO;
         if(_loc1_)
         {
            _loc1_.changed.add(this.update);
         }
      }
      
      private function removeListeners() : void
      {
         var _loc1_:EternalBlacklightPlaceVO = data as EternalBlacklightPlaceVO;
         if(_loc1_)
         {
            _loc1_.changed.remove(this.update);
         }
      }
      
      private function update() : void
      {
         var _loc2_:String = null;
         var _loc1_:EternalBlacklightPlaceVO = data as EternalBlacklightPlaceVO;
         if(_loc1_)
         {
            this.updateTooltipData(_loc1_);
            if(_loc1_.min == _loc1_.max)
            {
               _loc2_ = _loc1_.min.toString();
            }
            else
            {
               _loc2_ = _loc1_.min + " - " + _loc1_.max;
            }
            this._label.text = _loc1_.playerRewards ? _loc2_ : "";
         }
      }
      
      private function updateTooltipData(param1:EternalBlacklightPlaceVO) : void
      {
         if(Boolean(param1.playerRewards) && param1.playerRewards.length > 0)
         {
            this._rewardBTN.tooltipData = new VectorCollection(param1.playerRewards);
         }
         this._rewardBTN.visible = param1.playerRewards != null;
      }
      
      override public function set index(param1:int) : void
      {
         super.index = param1;
         this._leftBG.visible = param1 % 2 != 0;
      }
   }
}

