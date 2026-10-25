package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.darkorbit.map.model.Map;
   
   public class VisitMapCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      private var _map_id:int;
      
      public function VisitMapCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         super.parseMatches(param1);
         this._map_id = parseInt(param1[0]);
         _description = _description.replace(/%map%/,Map.getMissionMapName(this._map_id));
      }
   }
}

