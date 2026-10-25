package net.bigpoint.darkorbit.mvc.influenceWindow.model
{
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.model.DOAbstractProxy;
   import net.bigpoint.darkorbit.mvc.influenceWindow.InfluenceWindowNotifications;
   
   public class InfluenceWindowProxy extends DOAbstractProxy
   {
      
      public static const NAME:String = "InfluenceWindowProxy";
      
      public function InfluenceWindowProxy(param1:Object = null)
      {
         super(NAME,param1);
      }
      
      private function get influenceModel() : InfluenceModel
      {
         return data as InfluenceModel;
      }
      
      public function updatePlayerInfluence(param1:Number) : void
      {
         this.influenceModel.playerScore = param1;
         sendNotification(InfluenceWindowNotifications.UPDATE_PLAYER_INFLUENCE,param1);
      }
      
      public function updateView() : void
      {
         sendNotification(InfluenceWindowNotifications.UPDATE_ALL,this.influenceModel);
      }
      
      public function updateFactionInfluence(param1:Number, param2:Number, param3:Number) : void
      {
         this.influenceModel.mmoScore = param1;
         this.influenceModel.eicScore = param2;
         this.influenceModel.vruScore = param3;
         this.sortList();
         this.updateView();
      }
      
      private function sortList() : void
      {
         this.influenceModel.list.sort(this.sortinfluenceModel);
      }
      
      private function sortinfluenceModel(param1:InfluenceBarVo, param2:InfluenceBarVo) : int
      {
         var _loc3_:String = InGameCatalog.instance.factions_resKeys[Hero.factionID.value];
         if(param1.faction == _loc3_)
         {
            return -1;
         }
         if(param2.faction == _loc3_)
         {
            return 1;
         }
         return param2.score - param1.score;
      }
   }
}

