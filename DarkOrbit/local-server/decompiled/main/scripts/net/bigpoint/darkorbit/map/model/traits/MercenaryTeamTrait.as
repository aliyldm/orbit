package net.bigpoint.darkorbit.map.model.traits
{
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   
   public class MercenaryTeamTrait extends EntityTraitBase
   {
      
      private var _teamId:int = 0;
      
      public function MercenaryTeamTrait(param1:int)
      {
         super();
         this._teamId = param1;
      }
      
      public function get teamId() : int
      {
         return this._teamId;
      }
   }
}

