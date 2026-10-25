package net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.reward
{
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.delete_in_eic.BitmapVOLoader;
   import net.bigpoint.darkorbit.delete_in_eic.IconVOLoader;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.scroll.ScrollEvent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.reward.model.SSEvent;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.reward.model.SSPlanet;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.reward.model.SSReward;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.reward.model.SpaceSearchListVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.reward.model.SpaceSearchMsgAssigner;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.reward.model.SpaceSearchRewardData;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.reward.model.SpaceSearchRewardProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.ui.SpaceSearchXML;
   
   public class SpaceSearchRewardMediator extends SimpleWindowMediator
   {
      
      private var _characterBackroundBitmap:Bitmap;
      
      private var _characterBitmap:Bitmap;
      
      private var _view:SpaceSearchRewardView;
      
      private var loader:BitmapVOLoader = new BitmapVOLoader();
      
      private var list:ItemList;
      
      private var contentText:Label;
      
      private var labelList:Vector.<Label> = new Vector.<Label>();
      
      private var data:SpaceSearchRewardData;
      
      public function SpaceSearchRewardMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         var _loc1_:SpaceSearchRewardProxy = SpaceSearchRewardProxy.getOrCreateProxy(this.facade);
         this.data = _loc1_.viewData;
         this.data.changed.add(this.onDataChanged);
      }
      
      protected function handleScrollbarPositionChangeEvent(param1:ScrollEvent) : void
      {
         var _loc2_:Number = this._view.scrollbar.getScrollPositionInPercent();
         this._view.scrollbarContainer.setScrollPositionInPercent(_loc2_);
      }
      
      private function onDataChanged() : void
      {
         var _loc2_:Dictionary = null;
         var _loc6_:int = 0;
         var _loc9_:SSEvent = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc13_:SSReward = null;
         var _loc14_:SSPlanet = null;
         if(this.data.events.length <= 0)
         {
            return;
         }
         if(!this._view)
         {
            return;
         }
         var _loc1_:XML = SpaceSearchXML.xmls["events_space_search"];
         _loc2_ = SpaceSearchXML.createPlanetIdToResKeyMap(_loc1_);
         var _loc3_:Dictionary = SpaceSearchXML.createEventIdToResKeyMap(_loc1_);
         var _loc4_:Dictionary = SpaceSearchXML.createEventIdToDegreeMap(_loc1_);
         var _loc5_:String = "";
         while(_loc6_ < this.data.events.length)
         {
            _loc9_ = this.data.events[_loc6_];
            _loc10_ = _loc3_[_loc9_.eventId];
            _loc11_ = _loc4_[_loc9_.eventId];
            _loc10_ = BPLocale.getItem(_loc10_);
            _loc11_ = BPLocale.getItem(_loc11_);
            _loc12_ = _loc2_[_loc9_.planetId];
            _loc12_ = BPLocale.getItem(_loc12_);
            _loc5_ += _loc12_ + "(" + _loc11_ + ") \n ";
            _loc5_ = _loc5_ + (_loc10_ + "\n\n");
            _loc6_++;
         }
         _loc5_ += "\n\n\n\n \n\n\n\n";
         this.contentText.text = _loc5_;
         this._view.scrollbarContainer.assignChildren();
         this._view.scrollbar.assignChildren();
         this._view.scrollbar.addEventListener(ScrollEvent.SCROLL_POSITION_CHANGED,this.handleScrollbarPositionChangeEvent);
         var _loc7_:SpaceSearchListVO = new SpaceSearchListVO();
         var _loc8_:Vector.<SpaceSearchListVO> = new Vector.<SpaceSearchListVO>();
         _loc8_.push(_loc7_);
         _loc6_ = 0;
         while(_loc6_ < this.data.rewards.length)
         {
            _loc13_ = this.data.rewards[_loc6_];
            if(_loc7_.rewards.length < 8)
            {
               _loc7_.rewards.push(_loc13_);
            }
            else
            {
               _loc7_ = new SpaceSearchListVO();
               _loc8_.push(_loc7_);
               _loc7_.rewards.push(_loc13_);
            }
            _loc6_++;
         }
         this.availableExchangeList = _loc8_;
         _loc6_ = 0;
         while(_loc6_ < this.labelList.length)
         {
            this.labelList[_loc6_].visible = false;
            _loc6_++;
         }
         _loc6_ = 0;
         while(_loc6_ < this.data.planets.length)
         {
            if(this.labelList[_loc6_])
            {
               this.labelList[_loc6_].visible = true;
               _loc14_ = this.data.planets[_loc6_];
               _loc12_ = _loc2_[_loc14_.planetId];
               _loc12_ = BPLocale.getItem(_loc12_);
               this.labelList[_loc6_].text = _loc12_ + " " + _loc14_.pPct + "%  " + "<font color=\'#00FF00\'>(+" + _loc14_.pIncrease + "%)</font>";
            }
            _loc6_++;
         }
      }
      
      public function set availableExchangeList(param1:Vector.<SpaceSearchListVO>) : void
      {
         if(this.list)
         {
            this.list.list = new VectorCollection(param1);
         }
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._view = new SpaceSearchRewardView(simpleWindow);
         this.labelList.push(this._view.message1_0);
         this.labelList.push(this._view.message2_0);
         this.labelList.push(this._view.message3_0);
         this.list = this._view.availableExchangeItemList;
         if(this.list != null)
         {
            this.list.itemDataAssigner = SpaceSearchMsgAssigner;
         }
         this.contentText = this._view.contentText;
         var _loc2_:String = Hero.factionName;
         var _loc3_:String = _loc2_ + "_bg";
         var _loc4_:String = _loc2_ + "_char";
         var _loc5_:AssetsProxy = facade.retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
         _loc5_.load(_loc3_,this.backgroundLoadCallback);
         _loc5_.load(_loc4_,this.characterLoadCallback);
         IconVOLoader.getInstance().loadIcon(this._view.rewardInfoBg,null,"frame_top_BIG",AssetsProxy.EVENTS);
         this.onDataChanged();
         this._view.okBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.okClick);
      }
      
      private function updateCharacterContainer() : void
      {
         if(!this._view)
         {
            return;
         }
         if(this._characterBackroundBitmap)
         {
            this._view.characterBackground.addChild(this._characterBackroundBitmap);
         }
         if(this._characterBitmap)
         {
            this._view.characterContainer.addChild(this._characterBitmap);
         }
      }
      
      public function backgroundLoadCallback(param1:ImageFinisher) : void
      {
         this._characterBackroundBitmap = param1.getBitmap();
         this.updateCharacterContainer();
      }
      
      public function characterLoadCallback(param1:ImageFinisher) : void
      {
         this._characterBitmap = param1.getBitmap();
         this.updateCharacterContainer();
      }
      
      private function okClick(param1:MouseEvent) : void
      {
         window.minimize();
      }
   }
}

