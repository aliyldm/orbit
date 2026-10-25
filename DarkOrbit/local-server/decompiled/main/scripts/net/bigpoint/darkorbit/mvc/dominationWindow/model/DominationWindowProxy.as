package net.bigpoint.darkorbit.mvc.dominationWindow.model
{
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.mvc.dominationWindow.DominationNotificationNames;
   import net.bigpoint.darkorbit.mvc.dominationWindow.model.vo.DominationBarVO;
   import net.bigpoint.darkorbit.mvc.dominationWindow.model.vo.DominationWindowModel;
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.model.DOAbstractProxy;
   
   public class DominationWindowProxy extends DOAbstractProxy
   {
      
      public static const NAME:String = "";
      
      public function DominationWindowProxy()
      {
         super(NAME,new DominationWindowModel());
      }
      
      private function get model() : DominationWindowModel
      {
         return this.data as DominationWindowModel;
      }
      
      public function updateDominationPoints(param1:Number, param2:Number, param3:Number, param4:int, param5:int, param6:int) : void
      {
         this.model.mmoScore = param1;
         this.model.eicScore = param2;
         this.model.vruScore = param3;
         this.model.dominationPoints.mmo = param4;
         this.model.dominationPoints.eic = param5;
         this.model.dominationPoints.vru = param6;
         this.sortList();
         this.updateView();
      }
      
      private function sortList() : void
      {
         this.model.list.sort(this.sortDominationModel);
      }
      
      private function sortDominationModel(param1:DominationBarVO, param2:DominationBarVO) : int
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
      
      public function updateView() : void
      {
         sendNotification(DominationNotificationNames.UPDATE_VIEW,this.model);
      }
   }
}

