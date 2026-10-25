package net.bigpoint.darkorbit.mvc.gui.windows.battlePass.model
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.XMLFinisher;
   import net.bigpoint.darkorbit.com.module.BattlePassInfoCommand;
   import net.bigpoint.darkorbit.com.module.BattlePassKeyExchangeInfoCommand;
   import net.bigpoint.darkorbit.com.module.BattlePassKeyExchangeUpdateCommand;
   import net.bigpoint.darkorbit.com.module.BattlePassUpdateStatusCommand;
   import net.bigpoint.darkorbit.mvc.common.AssetNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.battlePass.model.vo.BattlePassObjectiveVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.battlePass.model.vo.BattlePassRewardVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class BattlePassWindowProxy extends SimpleWindowProxy
   {
      
      private var _infoData:BattlePassInfoCommand;
      
      public function BattlePassWindowProxy(param1:String)
      {
         super(param1,new BattlePassUIData());
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
      }
      
      private function loadXMLData(param1:String = "pass_galacticStrife.xml") : void
      {
         sendNotification(AssetNotifications.LOAD_ASSET,[param1.replace(".xml",""),this.handleXMLLoaded,this.onError]);
      }
      
      private function onError(... rest) : void
      {
      }
      
      private function handleXMLLoaded(param1:XMLFinisher) : void
      {
         var _loc5_:XML = null;
         var _loc6_:BattlePassObjectiveVO = null;
         this.viewData.objectiveItems.length = 0;
         var _loc2_:XML = param1.getXML();
         var _loc3_:XMLList = _loc2_.child("objectiveList").child("objective");
         var _loc4_:* = 0;
         for each(_loc5_ in _loc3_)
         {
            _loc6_ = new BattlePassObjectiveVO();
            _loc6_.questId = int(_loc5_.attribute("questId"));
            _loc6_.objectiveTitle = BPLocale.getItemInCategory("quests","quest_title_" + _loc6_.questId);
            _loc6_.sortOrder = _loc4_++;
            if(_loc5_.@questReward)
            {
               _loc6_.questReward = new BattlePassRewardVO();
               _loc6_.questReward.lootID = _loc5_.child("questReward").@lootid;
               _loc6_.questReward.packageID = _loc5_.child("questReward").@packageid;
               _loc6_.questReward.setPackageItemIDs(_loc5_.child("questReward").@packageItemIds);
               _loc6_.questReward.tooltipkey = _loc5_.child("questReward").@tooltipkey;
               _loc6_.questReward.amount = _loc5_.child("questReward").@amount;
               _loc6_.questReward.itemShowTimeInSec = _loc5_.child("questReward").@itemShowTimeInSec;
            }
            if(_loc5_.@bpReward)
            {
               _loc6_.bpReward = new BattlePassRewardVO();
               _loc6_.bpReward.lootID = _loc5_.child("bpReward").@lootid;
               _loc6_.bpReward.packageID = _loc5_.child("bpReward").@packageid;
               _loc6_.bpReward.setPackageItemIDs(_loc5_.child("bpReward").@packageItemIds);
               _loc6_.bpReward.tooltipkey = _loc5_.child("bpReward").@tooltipkey;
               _loc6_.bpReward.amount = _loc5_.child("bpReward").@amount;
               _loc6_.bpReward.itemShowTimeInSec = _loc5_.child("bpReward").@itemShowTimeInSec;
            }
            this.viewData.objectiveItems.push(_loc6_);
         }
         this.viewData.videoLootID = _loc2_.child("flvDisplayLootId")[0].toString();
         this.viewData.titleKeyBeforePurchase = _loc2_.child("titleKeyBeforePurchase")[0].toString();
         this.viewData.descriptionKeyBeforePurchase = _loc2_.child("descriptionKeyBeforePurchase")[0].toString();
         this.viewData.descriptionKeyCollect = _loc2_.child("descriptionKeyCollect")[0].toString();
         this.viewData.titleKeyAfterPurchase = _loc2_.child("titleKeyAfterPurchase")[0].toString();
         this.viewData.descriptionKeyAfterPurchase = _loc2_.child("descriptionKeyAfterPurchase")[0].toString();
         this.viewData.updateInfo(this._infoData);
         this.updateBattlePassStatus(this._infoData.statusCommand);
         this.viewData.changed.dispatch();
      }
      
      public function get viewData() : BattlePassUIData
      {
         return data as BattlePassUIData;
      }
      
      public function updateInfo(param1:BattlePassInfoCommand) : void
      {
         this._infoData = param1;
         this.loadXMLData(param1.filename);
      }
      
      public function updateObjectiveCondition(param1:int, param2:Number, param3:Boolean, param4:Boolean) : void
      {
         var _loc5_:Boolean = this.viewData.updateObjectiveCondition(param1,param2,param3,param4);
      }
      
      public function completeObjectiveCondition(param1:int) : void
      {
         this.viewData.completeObjective(param1);
         this.viewData.changed.dispatch();
      }
      
      public function updateBattlePassStatus(param1:BattlePassUpdateStatusCommand) : void
      {
         this.viewData.updateBattlePassStatus(param1.purchased,param1.questsToCollectReward);
         this.viewData.changed.dispatch();
      }
      
      public function updateFilter(param1:Vector.<String>) : void
      {
         this.viewData.itemFilter = param1;
      }
      
      public function createExchangeList(param1:BattlePassKeyExchangeInfoCommand) : void
      {
         this.viewData.createExchangeList(param1);
      }
      
      public function updateExchangeList(param1:BattlePassKeyExchangeUpdateCommand) : void
      {
         this.viewData.updateExchangeList(param1);
      }
   }
}

