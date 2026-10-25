package net.bigpoint.darkorbit.mvc.gui.windows.alienHunt.model
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.XMLFinisher;
   import net.bigpoint.darkorbit.com.module.HuntEventRankingPointsUpdateCommand;
   import net.bigpoint.darkorbit.com.module.HuntInfoCommand;
   import net.bigpoint.darkorbit.com.module.HuntRewardCommand;
   import net.bigpoint.darkorbit.mvc.common.AssetNotifications;
   import net.bigpoint.darkorbit.mvc.common.utils.ParserUtility;
   import net.bigpoint.darkorbit.mvc.gui.windows.alienHunt.model.vo.AlienHuntPointItemVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class AlienHuntUIWindowProxy extends SimpleWindowProxy
   {
      
      public function AlienHuntUIWindowProxy(param1:String)
      {
         super(param1,new AlienHuntUIData());
      }
      
      private function loadXMLData(param1:String = "event.piratehunt") : void
      {
         sendNotification(AssetNotifications.LOAD_ASSET,[param1.replace(".xml",""),this.handleXMLLoaded,this.onError]);
      }
      
      private function onError(... rest) : void
      {
      }
      
      private function handleXMLLoaded(param1:XMLFinisher) : void
      {
         var _loc4_:XML = null;
         var _loc5_:XML = null;
         var _loc6_:AlienHuntPointItemVO = null;
         this.viewData.pointItems.length = 0;
         var _loc2_:XML = param1.getXML();
         var _loc3_:XMLList = _loc2_.child("npcsToKill").child("npc");
         for each(_loc4_ in _loc3_)
         {
            _loc6_ = new AlienHuntPointItemVO();
            _loc6_.npcID = int(_loc4_.attribute("npcId"));
            _loc6_.points = int(_loc4_.attribute("foreignPoints"));
            this.viewData.pointItems.push(_loc6_);
         }
         this.viewData.pointItems.sort(AlienHuntPointItemVO.sort);
         _loc5_ = _loc2_.child("clientData")[0];
         this.viewData.internalHallofFameView = _loc5_.attribute("internalHallofFameView");
         this.viewData.windowTitle = _loc5_.attribute("windowTitle");
         this.viewData.hintButtonVisible = ParserUtility.parseBooleanFromXmlAtribute(_loc5_.attribute("hintButtonVisible"),false);
         this.viewData.hintButtonToolTip = BPLocale.getItem(_loc5_.attribute("hintButtonToolTip"));
         this.viewData.changed.dispatch();
      }
      
      public function get viewData() : AlienHuntUIData
      {
         return data as AlienHuntUIData;
      }
      
      public function updateRewards(param1:HuntRewardCommand) : void
      {
         if(param1.rewardType == HuntRewardCommand.REWARDTYPE_PLAYER)
         {
            this.viewData.updatePlayerReward(param1.rewardRange.from,param1.rewardRange.to,param1.huntReward);
         }
         else if(param1.rewardType == HuntRewardCommand.REWARDTYPE_CLAN)
         {
            this.viewData.updateClanReward(param1.rewardRange.from,param1.rewardRange.to,param1.huntReward);
         }
      }
      
      public function updateInfo(param1:HuntInfoCommand) : void
      {
         this.loadXMLData(param1.filename);
         this.viewData.updateInfo(param1);
      }
      
      public function updatePoints(param1:HuntEventRankingPointsUpdateCommand) : void
      {
         this.viewData.updatePoints(param1);
      }
   }
}

