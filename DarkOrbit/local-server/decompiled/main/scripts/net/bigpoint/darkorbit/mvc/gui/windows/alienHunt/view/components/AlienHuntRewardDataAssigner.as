package net.bigpoint.darkorbit.mvc.gui.windows.alienHunt.view.components
{
   import com.bealearts.collection.VectorCollection;
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.gui.windows.alienHunt.model.AlienHuntPlaceVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.alienHunt.view.components.event.AlienHuntEvent;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.RewardsToolTipAssigner;
   
   public class AlienHuntRewardDataAssigner extends DefaultItemDataAssigner
   {
      
      private var _leftBG:Coreponent;
      
      private var _rightBG:Coreponent;
      
      private var _clanLabel:Label;
      
      private var _label:Label;
      
      private var _clanBTN:Button;
      
      private var _playerBTN:Button;
      
      public function AlienHuntRewardDataAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._leftBG = FuiComponentSelectorUtil.selectComponent("left.bg",this) as Coreponent;
         this._rightBG = FuiComponentSelectorUtil.selectComponent("right.bg",this) as Coreponent;
         this._clanLabel = FuiComponentSelectorUtil.selectComponent("right.place",this) as Label;
         this._label = FuiComponentSelectorUtil.selectComponent("left.place",this) as Label;
         this._clanBTN = FuiComponentSelectorUtil.selectComponent("right.btn",this) as Button;
         this._playerBTN = FuiComponentSelectorUtil.selectComponent("left.btn",this) as Button;
         this._clanBTN.tooltipTemplateID = this._playerBTN.tooltipTemplateID = "alienhuntRewardToolTip";
         this._clanBTN.addEventListener(MouseEvent.MOUSE_OVER,this.handleClanOver);
         this._playerBTN.addEventListener(MouseEvent.MOUSE_OVER,this.handlePlayerOver);
         this._clanBTN.tooltipDataAssigner = new RewardsToolTipAssigner();
         this._playerBTN.tooltipDataAssigner = new RewardsToolTipAssigner();
      }
      
      private function handlePlayerOver(param1:MouseEvent) : void
      {
         var _loc2_:AlienHuntPlaceVO = data as AlienHuntPlaceVO;
         if(Boolean(_loc2_) && Boolean(_loc2_.playerRewards) && _loc2_.playerRewards.length == 0)
         {
            dispatchEvent(new AlienHuntEvent(AlienHuntEvent.REQUEST_PLAYER_DATA,_loc2_));
         }
      }
      
      private function handleClanOver(param1:MouseEvent) : void
      {
         var _loc2_:AlienHuntPlaceVO = data as AlienHuntPlaceVO;
         if(Boolean(_loc2_) && Boolean(_loc2_.clanRewards) && _loc2_.clanRewards.length == 0)
         {
            dispatchEvent(new AlienHuntEvent(AlienHuntEvent.REQUEST_CLAN_DATA,_loc2_));
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
         var _loc1_:AlienHuntPlaceVO = data as AlienHuntPlaceVO;
         if(_loc1_)
         {
            _loc1_.changed.add(this.update);
         }
      }
      
      private function removeListeners() : void
      {
         var _loc1_:AlienHuntPlaceVO = data as AlienHuntPlaceVO;
         if(_loc1_)
         {
            _loc1_.changed.remove(this.update);
         }
      }
      
      private function update() : void
      {
         var _loc2_:String = null;
         var _loc1_:AlienHuntPlaceVO = data as AlienHuntPlaceVO;
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
            this._clanLabel.text = _loc1_.clanRewards ? _loc2_ : "";
            this._label.text = _loc1_.playerRewards ? _loc2_ : "";
         }
      }
      
      private function updateTooltipData(param1:AlienHuntPlaceVO) : void
      {
         if(Boolean(param1.playerRewards) && param1.playerRewards.length > 0)
         {
            this._playerBTN.tooltipData = new VectorCollection(param1.playerRewards);
         }
         this._playerBTN.visible = param1.playerRewards != null;
         if(Boolean(param1.clanRewards) && param1.clanRewards.length > 0)
         {
            this._clanBTN.tooltipData = new VectorCollection(param1.clanRewards);
         }
         this._clanBTN.visible = param1.clanRewards != null;
      }
      
      override public function set index(param1:int) : void
      {
         super.index = param1;
         this._leftBG.visible = this._rightBG.visible = param1 % 2 != 0;
      }
   }
}

