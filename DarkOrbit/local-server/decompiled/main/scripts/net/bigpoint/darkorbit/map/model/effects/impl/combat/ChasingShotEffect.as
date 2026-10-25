package net.bigpoint.darkorbit.map.model.effects.impl.combat
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   
   public class ChasingShotEffect extends Effect
   {
      
      private var _attacker:MapEntity;
      
      private var _target:MapEntity;
      
      private var _assetname:String;
      
      public function ChasingShotEffect(param1:MapEntity, param2:MapEntity, param3:String)
      {
         super(EffectIDList.CHASING_SHOT,NOT_PERSISTANT);
         this._attacker = param1;
         this._target = param2;
         this._assetname = param3;
      }
      
      public function get attacker() : MapEntity
      {
         return this._attacker;
      }
      
      public function get target() : MapEntity
      {
         return this._target;
      }
      
      public function get assetname() : String
      {
         return this._assetname;
      }
      
      override public function isValid() : Boolean
      {
         return Boolean(super.isValid()) && this._attacker != null && this._target != null;
      }
   }
}

