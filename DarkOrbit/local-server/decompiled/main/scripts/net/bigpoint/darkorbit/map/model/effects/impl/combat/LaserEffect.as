package net.bigpoint.darkorbit.map.model.effects.impl.combat
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.traits.AttackerTrait;
   
   public class LaserEffect extends Effect
   {
      
      public var attacker:MapEntity = null;
      
      public var target:MapEntity = null;
      
      public var laserTypeID:int = 0;
      
      public var showShieldDamage:Boolean = false;
      
      public var skilledLaser:Boolean = false;
      
      public var shieldVisualType:int = 0;
      
      public var debug:Boolean = false;
      
      public var laserClass:int;
      
      public function LaserEffect(param1:MapEntity = null, param2:MapEntity = null, param3:int = 0, param4:Boolean = false, param5:Boolean = false, param6:int = 0, param7:int = -1)
      {
         super(EffectIDList.LASER,NOT_PERSISTANT);
         this.attacker = param1;
         this.target = param2;
         this.laserTypeID = param3;
         this.showShieldDamage = param4;
         this.skilledLaser = param5;
         this.shieldVisualType = param6;
         this.laserClass = param7;
      }
      
      override public function isValid() : Boolean
      {
         return Boolean(super.isValid()) && this.attacker != null && this.target != null && this.attacker.getFirstTrait(AttackerTrait) != null;
      }
      
      override public function activate() : Boolean
      {
         var _loc1_:AttackerTrait = this.attacker.getFirstTrait(AttackerTrait) as AttackerTrait;
         if(_loc1_)
         {
            _loc1_.laser.fire.dispatch();
         }
         return super.activate();
      }
   }
}

