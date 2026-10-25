package net.bigpoint.darkorbit.mvc.gui.windows.payloadEscort.view.components
{
   import com.bealearts.collection.VectorCollection;
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.RewardsToolTipAssigner;
   import net.bigpoint.darkorbit.mvc.gui.windows.payloadEscort.model.vo.PayloadEscortPlaceVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.payloadEscort.view.components.event.PayloadEscortEvent;
   
   public class PayloadEscortRewardDataAssigner extends DefaultItemDataAssigner
   {
      
      private var _leftBG:Coreponent;
      
      private var _label:Label;
      
      private var _rewardBTN:Button;
      
      public function PayloadEscortRewardDataAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._leftBG = FuiComponentSelectorUtil.selectComponent("left.bg",this) as Coreponent;
         this._label = FuiComponentSelectorUtil.selectComponent("left.place",this) as Label;
         this._rewardBTN = FuiComponentSelectorUtil.selectComponent("left.btn",this) as Button;
         this._rewardBTN.tooltipTemplateID = "payloadEscortRewardToolTip";
         this._rewardBTN.addEventListener(MouseEvent.MOUSE_OVER,this.handlePlayerOver);
         this._rewardBTN.tooltipDataAssigner = new RewardsToolTipAssigner();
      }
      
      private function handlePlayerOver(param1:MouseEvent) : void
      {
         var _loc2_:PayloadEscortPlaceVO = data as PayloadEscortPlaceVO;
         if(Boolean(_loc2_) && Boolean(_loc2_.permanentPointsRewards) && _loc2_.permanentPointsRewards.length == 0)
         {
            dispatchEvent(new PayloadEscortEvent(PayloadEscortEvent.REQUEST_PLAYER_DATA,_loc2_));
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
         var _loc1_:PayloadEscortPlaceVO = data as PayloadEscortPlaceVO;
         if(_loc1_)
         {
            _loc1_.changed.add(this.update);
         }
      }
      
      private function removeListeners() : void
      {
         var _loc1_:PayloadEscortPlaceVO = data as PayloadEscortPlaceVO;
         if(_loc1_)
         {
            _loc1_.changed.remove(this.update);
         }
      }
      
      private function update() : void
      {
         var _loc2_:String = null;
         var _loc1_:PayloadEscortPlaceVO = data as PayloadEscortPlaceVO;
         if(_loc1_)
         {
            this.updateTooltipData(_loc1_);
            if(_loc1_.permanentPointsMin == _loc1_.permanentPointsMax)
            {
               _loc2_ = _loc1_.permanentPointsMin.toString();
            }
            else
            {
               _loc2_ = _loc1_.permanentPointsMin + " - " + _loc1_.permanentPointsMax;
            }
            this._label.text = _loc1_.permanentPointsRewards ? _loc2_ : "";
         }
      }
      
      private function updateTooltipData(param1:PayloadEscortPlaceVO) : void
      {
         if(Boolean(param1.permanentPointsRewards) && param1.permanentPointsRewards.length > 0)
         {
            this._rewardBTN.tooltipData = new VectorCollection(param1.permanentPointsRewards);
         }
         this._rewardBTN.visible = param1.permanentPointsRewards != null;
      }
      
      override public function set index(param1:int) : void
      {
         super.index = param1;
         this._leftBG.visible = param1 % 2 != 0;
      }
   }
}

