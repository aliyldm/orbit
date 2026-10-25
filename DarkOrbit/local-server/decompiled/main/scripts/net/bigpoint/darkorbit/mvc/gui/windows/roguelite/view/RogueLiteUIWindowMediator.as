package net.bigpoint.darkorbit.mvc.gui.windows.roguelite.view
{
   import com.bigpoint.utils.TextFormatter;
   import flash.events.MouseEvent;
   import flash.globalization.DateTimeFormatter;
   import flash.globalization.LocaleID;
   import net.bigpoint.darkorbit.com.module.RankRewardRequest;
   import net.bigpoint.darkorbit.com.module.RogueLiteChangeEquipmentRequest;
   import net.bigpoint.darkorbit.com.module.RogueLiteSelectRewardRequest;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.crafting.reroll.view.RerollWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.ItemLoader;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.roguelite.model.RogueLiteUIData;
   import net.bigpoint.darkorbit.mvc.gui.windows.roguelite.model.vo.RogueLiteInventoryItemVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.roguelite.view.components.RogueLiteRankRewardEvent;
   import net.bigpoint.darkorbit.mvc.gui.windows.roguelite.view.components.RogueLiteRootView;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class RogueLiteUIWindowMediator extends SimpleWindowMediator
   {
      
      public static const FORBIDDEN_MAP:Array = [466,467,468];
      
      private static const OTHER_WINDOWS:Array = [GuiConstants.ASSEMBLY_WINDOW,GuiConstants.REROLL_POPUP,GuiConstants.RETURNEE_LOGIN,GuiConstants.MONTHLY_DELUXE,GuiConstants.MINICLIENT_REWARD,GuiConstants.BATTLE_PASS,GuiConstants.VIP_MERCHANT_EXCHANGE_POPUP,GuiConstants.VIP_MERCHANT_EXCHANGE,GuiConstants.SEASON_PASS,GuiConstants.SEASON_PASS_POPUP_PURCHASE_LEVELS,GuiConstants.SEASON_PASS_POPUP_ERROR,GuiConstants.SEASON_PASS_POPUP_BUY_GOLD_PASS,GuiConstants.SEASON_PASS_POPUP_SEASON_END,GuiConstants.SEASON_PASS_POPUP_CONFIRM_REFRESH,GuiConstants.DISPATCH,GuiConstants.DISPATCH_POPUP_REWARD_LIST,GuiConstants.PUBLIC_WORLD_BOSS,GuiConstants.GG_BUILDER_WINDOW,GuiConstants.STRIKE_AND_EXIT];
      
      private const _generatorType:String = "net.bigpoint.darkorbit.asset.generator";
      
      private var _data:RogueLiteUIData;
      
      private var _view:RogueLiteRootView;
      
      private var _filteredList:Object;
      
      public function RogueLiteUIWindowMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
         ScreenManager.getInstance().mapChanged.add(this.minimizeOtherWindows);
      }
      
      override public function onRemove() : void
      {
         this._view.rankReward.placementList.removeEventListener(RogueLiteRankRewardEvent.REQUEST_RANK_REWARD_INFO,this.onHoverRankRewardInfoBtn);
         super.onRemove();
         this.data = null;
      }
      
      public function set data(param1:RogueLiteUIData) : void
      {
         if(this._data)
         {
            this._data.changed.remove(this.update);
            this._data.lastRoomCount.changed.remove(this.updateLastRoom);
            this._data.scoreCount.changed.remove(this.updateScore);
            this._data.keyCount.changed.remove(this.updateKey);
            this._data.showCpu.changed.remove(this.updateCpuDisplay);
            this._data.rewardCashoutChanged.remove(this.updateRewardCashout);
            this._data.roomRewardChanged.remove(this.onRoomRewardChanged);
            this._data.inventoryChanged.remove(this.onInventoryChanged);
            this._data.canEquip.changed.remove(this.onEquipStatusChanged);
            this._data.rankRewardChanged.remove(this.updateRankReward);
            this._data.rankingChanged.remove(this.updateRanking);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.changed.add(this.update);
            this._data.lastRoomCount.changed.add(this.updateLastRoom);
            this._data.scoreCount.changed.add(this.updateScore);
            this._data.keyCount.changed.add(this.updateKey);
            this._data.showCpu.changed.add(this.updateCpuDisplay);
            this._data.rewardCashoutChanged.add(this.updateRewardCashout);
            this._data.roomRewardChanged.add(this.onRoomRewardChanged);
            this._data.inventoryChanged.add(this.onInventoryChanged);
            this._data.canEquip.changed.add(this.onEquipStatusChanged);
            this._data.rankRewardChanged.add(this.updateRankReward);
            this._data.rankingChanged.add(this.updateRanking);
            this.update();
         }
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._view = new RogueLiteRootView(simpleWindow);
         this.data = retrieveWindowProxy().getData() as RogueLiteUIData;
         this.addListeners();
         this.loadKeyImage();
         this.initInventoryTabList();
      }
      
      private function addListeners() : void
      {
         this._view.reward.rewardSelected.add(this.onRewardSelected);
         this._view.inventory.tabSelected.add(this.onTabSelected);
         this._view.inventory.resetBtn.addEventListener(MouseEvent.CLICK,this.onInventoryResetClicked);
         this._view.inventory.saveBtn.addEventListener(MouseEvent.CLICK,this.onInventorySaveClicked);
         this._view.rankReward.placementList.addEventListener(RogueLiteRankRewardEvent.REQUEST_RANK_REWARD_INFO,this.onHoverRankRewardInfoBtn);
      }
      
      public function update() : void
      {
         if(this._data == null || !isUIReady())
         {
            return;
         }
         this.updateLastRoom();
         this.updateScore();
         this.updateKey();
         this.updateRewardCashout();
         this.updateRewardList();
         this.updateCpuDisplay();
         this.updateRankReward();
         this.updateRanking();
         this.minimizeOtherWindows();
      }
      
      private function updateLastRoom() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            this._view.overview.lastRoomCount.text = TextFormatter.roundInteger(this._data.lastRoomCount.value);
         }
      }
      
      private function updateScore() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            this._view.overview.scoreCount.text = TextFormatter.roundInteger(this._data.scoreCount.value);
            this._view.overview.highScoreCount.text = TextFormatter.roundInteger(this._data.highScoreCount);
         }
      }
      
      private function updateKey() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            this._view.overview.keyCount.text = TextFormatter.roundInteger(this._data.keyCount.value);
         }
      }
      
      private function updateCpuDisplay() : void
      {
         if(!this._data || !this._view)
         {
            return;
         }
         this._view.overview.keyContainer.visible = this._data.showCpu.value;
      }
      
      private function loadKeyImage() : void
      {
         var _loc1_:Coreponent = this._view.overview.keyImage;
         var _loc2_:ItemLoader = new ItemLoader("ammunition_ggportal_astral-cpu");
         MovieClipUtils.cleanupDisplayObjectContainer(_loc1_);
         _loc1_.addChild(_loc2_);
      }
      
      private function updateRewardCashout() : void
      {
         if(!this._data || !this._view)
         {
            return;
         }
         this._view.rewardCashout.guaranteedList = this._data.guaranteedList;
         this._view.rewardCashout.chanceList = this._data.chanceList;
         this._view.rewardCashout.showContainer = this._data.guaranteedList.length > 0 || this._data.chanceList.length > 0;
      }
      
      private function updateRewardList() : void
      {
         this._view.reward.list = this._data.rewardList;
         this._view.reward.showContainer = this._data.rewardList.length > 0;
         if(this._data.rewardList.length == 1)
         {
            this._view.reward.selectPackageReward();
         }
      }
      
      private function onRoomRewardChanged() : void
      {
         if(!this._data || !this._view)
         {
            return;
         }
         this.updateRewardList();
         if(this._data.rewardList.length > 0)
         {
            this._view.changeTab(this._view.reward.title);
            window.maximize();
         }
      }
      
      private function onRewardSelected(param1:String) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new RogueLiteSelectRewardRequest(param1));
      }
      
      private function initInventoryTabList() : void
      {
         if(!this._data || !this._view)
         {
            return;
         }
         this._view.inventory.tabSelection = this._data.inventoryTabList;
         this._view.inventory.tabList.selectedIndex = 0;
      }
      
      private function get selectedTab() : ItemVO
      {
         return this._view.inventory.tabList.selectedItemData as ItemVO;
      }
      
      private function getFilteredList(param1:String) : Vector.<RogueLiteInventoryItemVO>
      {
         if(param1.indexOf("generator") >= 0)
         {
            param1 = this._generatorType;
         }
         return this._filteredList[param1];
      }
      
      private function onInventoryChanged() : void
      {
         var _loc1_:ItemVO = null;
         var _loc2_:RogueLiteInventoryItemVO = null;
         var _loc3_:String = null;
         var _loc4_:Vector.<RogueLiteInventoryItemVO> = null;
         if(!this._data || !this._view)
         {
            return;
         }
         this._filteredList = {};
         for each(_loc1_ in this._data.inventoryTabList)
         {
            _loc3_ = _loc1_.getItemType();
            if(_loc3_.indexOf("generator") >= 0)
            {
               _loc3_ = this._generatorType;
            }
            this._filteredList[_loc3_] = new Vector.<RogueLiteInventoryItemVO>(0);
         }
         for each(_loc2_ in this._data.inventoryItemList)
         {
            _loc4_ = this.getFilteredList(_loc2_.itemVO.getItemType());
            if(_loc4_)
            {
               _loc4_.push(_loc2_);
            }
         }
         this._view.inventory.filteredInventory = this.getFilteredList(this.selectedTab.getItemType());
         this._view.inventory.showContainer(true,true);
      }
      
      private function onEquipStatusChanged() : void
      {
         this._view.inventory.showContainer(false);
      }
      
      private function onTabSelected() : void
      {
         if(!this._data || !this._view || !this.selectedTab)
         {
            return;
         }
         if(this._filteredList == null)
         {
            this._view.inventory.resetInventory();
            return;
         }
         this._view.inventory.filteredInventory = this.getFilteredList(this.selectedTab.getItemType());
      }
      
      private function onInventoryResetClicked(param1:MouseEvent) : void
      {
         if(!this._data || !this._view)
         {
            return;
         }
         this._view.inventory.resetInventory();
      }
      
      private function onInventorySaveClicked(param1:MouseEvent) : void
      {
         var _loc3_:RogueLiteInventoryItemVO = null;
         if(!this._data || !this._view || !this._filteredList || !this.selectedTab)
         {
            return;
         }
         var _loc2_:RogueLiteChangeEquipmentRequest = new RogueLiteChangeEquipmentRequest();
         for each(_loc3_ in this.getFilteredList(this.selectedTab.getItemType()))
         {
            if(_loc3_.stateChanged)
            {
               _loc2_.modifiedItemIds.push(_loc3_.itemVO.id);
               _loc3_.update();
            }
         }
         if(_loc2_.modifiedItemIds.length > 0)
         {
            sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc2_);
         }
         this._view.inventory.resetInventory();
      }
      
      private function updateRankReward() : void
      {
         if(!this._data || !this._view || !this._data.rankRewards)
         {
            return;
         }
         this._view.rankReward.showActiveContainer = this._data.eventEnabled;
         this._view.rankReward.list = this._data.rankRewards;
      }
      
      private function onHoverRankRewardInfoBtn(param1:RogueLiteRankRewardEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new RankRewardRequest(param1.VO.min,RankRewardRequest.RANKTYPE_ROGUE_LITE));
      }
      
      private function updateRanking() : void
      {
         var _loc1_:Date = null;
         var _loc2_:DateTimeFormatter = null;
         if(!this._data || !this._view)
         {
            return;
         }
         this._view.rank.showActiveContainer = this._data.eventEnabled;
         this._view.rank.rankingList.list = new VectorCollection(this._data.topRankers);
         this._view.rank.myName.text = this._data.myRank.name;
         if(this._data.myRank.rank != 0)
         {
            this._view.rank.myRank.text = TextFormatter.roundInteger(this._data.myRank.rank);
            _loc1_ = new Date(this._data.myRank.lastUpdateTime);
            _loc2_ = new DateTimeFormatter(flash.globalization.LocaleID.DEFAULT);
            _loc2_.setDateTimePattern("dd/MM HH:mm");
            this._view.rank.myTime.text = _loc2_.format(_loc1_);
            this._view.rank.myScore.text = TextFormatter.roundInteger(this._data.myRank.points);
         }
         else
         {
            this._view.rank.myRank.text = "-";
            this._view.rank.myTime.text = "-";
            this._view.rank.myScore.text = "-";
         }
      }
      
      private function minimizeOtherWindows() : void
      {
         var _loc2_:String = null;
         var _loc3_:SimpleWindow = null;
         if(!this._data || !this._view)
         {
            return;
         }
         var _loc1_:Map = ScreenManager.getInstance().map;
         if(FORBIDDEN_MAP.indexOf(_loc1_.mapID) < 0)
         {
            return;
         }
         for each(_loc2_ in OTHER_WINDOWS)
         {
            _loc3_ = guiManager.getWindow(_loc2_);
            if(!_loc3_)
            {
               continue;
            }
            _loc3_.minimize(false,true);
            switch(_loc2_)
            {
               case GuiConstants.REROLL_POPUP:
                  sendNotification(RerollWindowMediator.CLOSE_REROLL_POPUP_COMMAND);
                  break;
               case GuiConstants.DISPATCH_POPUP_REWARD_LIST:
                  _loc3_.cleanup();
                  break;
               case GuiConstants.VIP_MERCHANT_EXCHANGE_POPUP:
               case GuiConstants.SEASON_PASS_POPUP_PURCHASE_LEVELS:
               case GuiConstants.SEASON_PASS_POPUP_ERROR:
               case GuiConstants.SEASON_PASS_POPUP_BUY_GOLD_PASS:
               case GuiConstants.SEASON_PASS_POPUP_SEASON_END:
                  _loc3_.activateModalLayer(false);
            }
         }
      }
   }
}

