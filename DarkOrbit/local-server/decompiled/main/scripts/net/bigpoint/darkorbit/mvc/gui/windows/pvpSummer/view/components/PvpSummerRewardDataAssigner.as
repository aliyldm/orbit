package net.bigpoint.darkorbit.mvc.gui.windows.pvpSummer.view.components
{
   import com.bealearts.collection.VectorCollection;
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.RewardsToolTipAssigner;
   import net.bigpoint.darkorbit.mvc.gui.windows.pvpSummer.model.vo.PvpSummerPlaceVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.pvpSummer.view.components.event.PvpSummerEvent;
   
   public class PvpSummerRewardDataAssigner extends DefaultItemDataAssigner
   {
      
      private var _leftBG:Coreponent;
      
      private var _rightBG:Coreponent;
      
      private var _repPerKillLabel:Label;
      
      private var _repLabel:Label;
      
      private var _repPerKillBtn:Button;
      
      private var _repBtn:Button;
      
      public function PvpSummerRewardDataAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._leftBG = FuiComponentSelectorUtil.selectComponent("left.bg",this) as Coreponent;
         this._rightBG = FuiComponentSelectorUtil.selectComponent("right.bg",this) as Coreponent;
         this._repPerKillLabel = FuiComponentSelectorUtil.selectComponent("right.place",this) as Label;
         this._repLabel = FuiComponentSelectorUtil.selectComponent("left.place",this) as Label;
         this._repPerKillBtn = FuiComponentSelectorUtil.selectComponent("right.btn",this) as Button;
         this._repBtn = FuiComponentSelectorUtil.selectComponent("left.btn",this) as Button;
         this._repPerKillBtn.tooltipTemplateID = this._repBtn.tooltipTemplateID = "pvpsummerRewardToolTip";
         this._repPerKillBtn.addEventListener(MouseEvent.MOUSE_OVER,this.handleRepPerKillOver);
         this._repBtn.addEventListener(MouseEvent.MOUSE_OVER,this.handleRepOver);
         this._repPerKillBtn.tooltipDataAssigner = new RewardsToolTipAssigner();
         this._repBtn.tooltipDataAssigner = new RewardsToolTipAssigner();
      }
      
      private function handleRepOver(param1:MouseEvent) : void
      {
         var _loc2_:PvpSummerPlaceVO = data as PvpSummerPlaceVO;
         if(Boolean(_loc2_) && Boolean(_loc2_.repRewards) && _loc2_.repRewards.length == 0)
         {
            dispatchEvent(new PvpSummerEvent(PvpSummerEvent.REQUEST_REP_DATA,_loc2_));
         }
      }
      
      private function handleRepPerKillOver(param1:MouseEvent) : void
      {
         var _loc2_:PvpSummerPlaceVO = data as PvpSummerPlaceVO;
         if(Boolean(_loc2_) && Boolean(_loc2_.repPerKillRewards) && _loc2_.repPerKillRewards.length == 0)
         {
            dispatchEvent(new PvpSummerEvent(PvpSummerEvent.REQUEST_REP_PER_KILL_DATA,_loc2_));
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
         var _loc1_:PvpSummerPlaceVO = data as PvpSummerPlaceVO;
         if(_loc1_)
         {
            _loc1_.changed.add(this.update);
         }
      }
      
      private function removeListeners() : void
      {
         var _loc1_:PvpSummerPlaceVO = data as PvpSummerPlaceVO;
         if(_loc1_)
         {
            _loc1_.changed.remove(this.update);
         }
      }
      
      private function update() : void
      {
         var _loc2_:String = null;
         var _loc1_:PvpSummerPlaceVO = data as PvpSummerPlaceVO;
         if(_loc1_)
         {
            this.updateTooltipData(_loc1_);
            if(_loc1_.repMin == _loc1_.repMax)
            {
               _loc2_ = _loc1_.repMin.toString();
            }
            else
            {
               _loc2_ = _loc1_.repMin + " - " + _loc1_.repMax;
            }
            this._repLabel.text = _loc1_.repRewards ? _loc2_ : "";
            if(_loc1_.repPerKillMin == _loc1_.repPerKillMax)
            {
               _loc2_ = _loc1_.repPerKillMin.toString();
            }
            else
            {
               _loc2_ = _loc1_.repPerKillMin + " - " + _loc1_.repPerKillMax;
            }
            this._repPerKillLabel.text = _loc1_.repPerKillRewards ? _loc2_ : "";
         }
      }
      
      private function updateTooltipData(param1:PvpSummerPlaceVO) : void
      {
         if(Boolean(param1.repRewards) && param1.repRewards.length > 0)
         {
            this._repBtn.tooltipData = new VectorCollection(param1.repRewards);
         }
         this._repBtn.visible = param1.repRewards != null;
         if(Boolean(param1.repPerKillRewards) && param1.repPerKillRewards.length > 0)
         {
            this._repPerKillBtn.tooltipData = new VectorCollection(param1.repPerKillRewards);
         }
         this._repPerKillBtn.visible = param1.repPerKillRewards != null;
      }
      
      override public function set index(param1:int) : void
      {
         super.index = param1;
         this._leftBG.visible = this._rightBG.visible = param1 % 2 != 0;
      }
   }
}

