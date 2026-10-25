package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import flash.geom.Point;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.DamageEffect;
   import net.bigpoint.darkorbit.map.model.traits.MouseHitAreaTrait;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.settings.Settings3D;
   import net.bigpoint.darkorbit.net.netty.handlers.combat.AttackTypeMap;
   import net.bigpoint.darkorbit.pattern.ExplosionPattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.utils.math.FastMath;
   
   public class DamageEffect3D extends StandaloneParticle3D
   {
      
      private var _effect:DamageEffect;
      
      private var pyroPattern:ExplosionPattern;
      
      private var laserDamageTypeID:int;
      
      public function DamageEffect3D(param1:MapView3D, param2:DamageEffect)
      {
         this._effect = param2;
         var _loc3_:String = null;
         if(Settings3D.effects.high.value)
         {
            switch(this._effect.damageType)
            {
               case AttackTypeMap.LASER:
               case AttackTypeMap.ECI:
               case AttackTypeMap.SINGULARITY:
                  _loc3_ = "impact_hull_laser.zip";
                  this.laserDamageTypeID = FastMath.getRandomCount(0,2);
                  this.pyroPattern = PatternManager.getPyroPattern(ExplosionPattern.TYPE_LASER_DAMAGE,this.laserDamageTypeID);
                  break;
               case AttackTypeMap.ROCKET:
                  _loc3_ = "impact_hull_rocket.zip";
                  this.pyroPattern = PatternManager.getPyroPattern(ExplosionPattern.TYPE_ROCKET_DAMAGE,0);
                  break;
               case "I":
                  this.laserDamageTypeID = FastMath.getRandomCount(0,2);
                  this.pyroPattern = PatternManager.getPyroPattern(ExplosionPattern.TYPE_LASER_DAMAGE,this.laserDamageTypeID);
                  break;
               case AttackTypeMap.MINE:
                  _loc3_ = "impact_hull_rocket.zip";
                  this.pyroPattern = PatternManager.getPyroPattern(ExplosionPattern.TYPE_ROCKET_DAMAGE,1);
                  break;
               case AttackTypeMap.PLASMA:
                  _loc3_ = "impact_hull_plasma.zip";
                  this.pyroPattern = PatternManager.getPyroPattern(ExplosionPattern.TYPE_ROCKET_DAMAGE,2);
                  break;
               case "H":
            }
         }
         super(param2,_loc3_ ? _loc3_ : null,param2.source.position,param2.source,true);
         var _loc4_:MouseHitAreaTrait = this._effect.source.getFirstTrait(MouseHitAreaTrait) as MouseHitAreaTrait;
         var _loc5_:int = _loc4_ ? _loc4_.clickRadius : 50;
         var _loc6_:Number = Math.random();
         var _loc7_:Point = Point.polar(_loc5_ * _loc6_ * 0.5,_loc6_ * 10);
         offset3D.setTo(_loc7_.x,0,Math.abs(_loc7_.y));
      }
      
      override protected function initAndPlay() : void
      {
         var _loc2_:int = 0;
         super.initAndPlay();
         var _loc1_:int = FastMath.getRandomCount(0,360);
         view.rotationY = _loc1_;
         if(this.pyroPattern != null)
         {
            _loc2_ = this.pyroPattern.getSoundID();
            if(_loc2_ != -1)
            {
               AudioManager.playSoundEffect(_loc2_,false,false,this._effect.source.position.x,this._effect.source.position.y);
            }
            if(this._effect.damageType == "I")
            {
               ScreenManager.getInstance().shakeScreen();
               AudioManager.playSoundEffect(7);
            }
         }
      }
   }
}

