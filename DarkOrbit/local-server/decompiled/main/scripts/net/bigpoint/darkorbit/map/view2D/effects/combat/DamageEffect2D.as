package net.bigpoint.darkorbit.map.view2D.effects.combat
{
   import com.greensock.TweenLite;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.DamageEffect;
   import net.bigpoint.darkorbit.map.model.traits.MouseHitAreaTrait;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.net.netty.handlers.combat.AttackTypeMap;
   import net.bigpoint.darkorbit.pattern.ExplosionPattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   import net.bigpoint.darkorbit.utils.math.FastMath;
   
   public class DamageEffect2D
   {
      
      private static var shipDamageLookUp:Dictionary = new Dictionary();
      
      private static const STD_RADIUS:int = 50;
      
      private var _effect:DamageEffect;
      
      private var pyroPattern:ExplosionPattern;
      
      private var laserDamageTypeID:int;
      
      private var _mapView:MapView2D;
      
      public function DamageEffect2D(param1:MapView2D, param2:DamageEffect)
      {
         super();
         if(Settings.qualityExplosion.value > Settings.QUALITY_LOW)
         {
            this._mapView = param1;
            this._effect = param2;
            if(int(shipDamageLookUp[this._effect.source]) < 5)
            {
               this.initEffectVisuals();
            }
         }
      }
      
      protected function initEffectVisuals() : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:MovieClip = null;
         var _loc5_:MouseHitAreaTrait = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         var _loc9_:Point = null;
         switch(this._effect.damageType)
         {
            case AttackTypeMap.LASER:
            case AttackTypeMap.ECI:
            case AttackTypeMap.SINGULARITY:
               this.laserDamageTypeID = FastMath.getRandomCount(0,2);
               this.pyroPattern = PatternManager.getPyroPattern(ExplosionPattern.TYPE_LASER_DAMAGE,this.laserDamageTypeID);
               break;
            case AttackTypeMap.ROCKET:
               this.pyroPattern = PatternManager.getPyroPattern(ExplosionPattern.TYPE_ROCKET_DAMAGE,0);
               break;
            case "I":
               this.laserDamageTypeID = FastMath.getRandomCount(0,2);
               this.pyroPattern = PatternManager.getPyroPattern(ExplosionPattern.TYPE_LASER_DAMAGE,this.laserDamageTypeID);
               break;
            case AttackTypeMap.MINE:
               this.pyroPattern = PatternManager.getPyroPattern(ExplosionPattern.TYPE_ROCKET_DAMAGE,1);
               break;
            case AttackTypeMap.PLASMA:
               this.pyroPattern = PatternManager.getPyroPattern(ExplosionPattern.TYPE_ROCKET_DAMAGE,2);
               break;
            case "H":
         }
         if(this.pyroPattern != null)
         {
            _loc2_ = this.pyroPattern.getSoundID();
            if(_loc2_ != -1)
            {
               AudioManager.playSoundEffect(_loc2_,false,false,this._effect.source.position.x,this._effect.source.position.y);
            }
            _loc3_ = this.pyroPattern.getResKey();
            if(!ResourceManager.isLoaded(_loc3_))
            {
               ResourceManager.loadAndCall(_loc3_,this.initEffectVisuals,arguments,1000);
               return;
            }
            _loc4_ = ResourceManager.getMovieClip(_loc3_,"mc");
            _loc5_ = this._effect.source.getFirstTrait(MouseHitAreaTrait) as MouseHitAreaTrait;
            _loc6_ = _loc5_ ? _loc5_.clickRadius : STD_RADIUS;
            _loc7_ = FastMath.getRandomCount(0,360);
            if(this._effect.damageType == "I")
            {
               ScreenManager.getInstance().shakeScreen();
               AudioManager.playSoundEffect(7);
            }
            _loc8_ = Math.random();
            _loc9_ = Point.polar(_loc6_ * _loc8_ * 0.5,_loc8_ * 10);
            _loc4_.rotation = _loc7_;
            _loc4_.x = _loc9_.x + this._effect.source.position.x;
            _loc4_.y = _loc9_.y + this._effect.source.position.y;
            this._mapView.fxLayer.addChild(_loc4_);
            shipDamageLookUp[this._effect.source] = int(shipDamageLookUp[this._effect.source]) + 1;
            TweenLite.to(_loc4_,0.5,{
               "frame":_loc4_.framesLoaded,
               "onComplete":this.onAnimationFinish,
               "onCompleteParams":[_loc4_]
            });
         }
      }
      
      private function onAnimationFinish(param1:DisplayObject = null) : void
      {
         MovieClipUtils.removeDisplayObject(param1);
         if(shipDamageLookUp[this._effect.source] != null)
         {
            shipDamageLookUp[this._effect.source] = shipDamageLookUp[this._effect.source] - 1;
         }
      }
   }
}

