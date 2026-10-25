package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class VisitQuestGiverCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      private var _questGiverId:int;
      
      public function VisitQuestGiverCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         super.parseMatches(param1);
         this._questGiverId = parseInt(param1[0]);
         _description = BPLocale.getItem("q2_condition_" + _definition.TRANS_BASE_KEY);
         var _loc2_:int = 0;
         if(this._questGiverId == 1)
         {
            _loc2_ = Hero.factionID.value;
         }
         var _loc3_:String = this.inGameCatalog.questgiver_names[_loc2_] || this.inGameCatalog.questgiver_names[0];
         _description = _description.replace(/%QUESTGIVER_NAME%/,_loc3_);
         if(this._questGiverId > 0)
         {
            _helpIconData = getBitmapDataByKey("homestation_questgiver");
         }
      }
      
      private function get inGameCatalog() : InGameCatalog
      {
         return InGameCatalog.getInstance();
      }
   }
}

