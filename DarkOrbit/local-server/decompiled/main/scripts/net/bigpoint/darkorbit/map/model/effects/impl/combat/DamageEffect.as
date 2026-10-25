package net.bigpoint.darkorbit.map.model.effects.impl.combat
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class DamageEffect extends MapObjectEffect
   {
      
      private var _damageType:String;
      
      public function DamageEffect(param1:MapEntity, param2:String)
      {
         super(EffectIDList.DAMAGE,param1,NOT_PERSISTANT);
         this._damageType = param2;
      }
      
      public function get damageType() : String
      {
         return this._damageType;
      }
      
      override public function get ignoresCloak() : Boolean
      {
         return true;
      }
   }
}

