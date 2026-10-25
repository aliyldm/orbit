package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class ProximityCondition extends Condition
   {
      
      private var _avatar_id:int;
      
      private var _npc_id:int;
      
      private var _radius:int;
      
      public function ProximityCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         super.parseMatches(param1);
         var _loc2_:Vector.<String> = param1;
         this._avatar_id = parseInt(_loc2_.shift());
         this._npc_id = parseInt(_loc2_.shift());
         this._radius = parseInt(_loc2_.shift());
         _description = _description.replace(/%opponent%/,InGameCatalog.instance.getNpcName(this._npc_id));
         _helpIconData = getBitmapDataByKey(InGameCatalog.instance.getNpcIcon(this._npc_id) + "_icon.png");
      }
   }
}

