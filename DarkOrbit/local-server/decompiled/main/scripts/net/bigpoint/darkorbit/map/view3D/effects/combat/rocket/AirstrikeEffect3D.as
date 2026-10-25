package net.bigpoint.darkorbit.map.view3D.effects.combat.rocket
{
   import com.greensock.TweenMax;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.DamageReceivedEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.AirstrikeEffect;
   import net.bigpoint.darkorbit.map.model.traits.AttackTargetTrait;
   import net.bigpoint.darkorbit.map.model.traits.AttackerTrait;
   import net.bigpoint.darkorbit.map.model.traits.weapons.RocketLauncher;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.pattern.RocketPattern;
   import net.bigpoint.darkorbit.pattern.RocketSmokePattern;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class AirstrikeEffect3D
   {
      
      private var _effect:AirstrikeEffect;
      
      public function AirstrikeEffect3D(param1:MapView3D, param2:AirstrikeEffect)
      {
         var _loc3_:RocketLauncher = null;
         var _loc4_:int = 0;
         var _loc5_:RocketPattern = null;
         var _loc6_:RocketSmokePattern = null;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:Rocket3D = null;
         super();
         this._effect = param2;
         if(this._effect.attacker != null && this._effect.target != null)
         {
            _loc3_ = AttackerTrait(param2.attacker.getFirstTrait(AttackerTrait)).rocketLauncher;
            _loc4_ = _loc3_.rocketClassId;
            _loc5_ = PatternManager.getRocketPattern(_loc4_,this._effect.rocketType);
            if(_loc5_ == null)
            {
               _loc5_ = PatternManager.getRocketPattern(0,1);
            }
            AudioManager.playSoundEffect(_loc5_.getSoundID(),false,false,this._effect.attacker.position.x,this._effect.attacker.position.y);
            AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_AIRSTRIKE,false,false,this._effect.attacker.position.x,this._effect.attacker.position.y);
            _loc6_ = PatternManager.rocketSmokePatterns[param2.smokeType];
            _loc7_ = 0;
            _loc8_ = 0;
            while(_loc8_ < this._effect.maxRockets)
            {
               _loc9_ = new Rocket3D(AttackerTrait(param2.attacker.getFirstTrait(AttackerTrait)),this._effect.target.getFirstTrait(AttackTargetTrait) as AttackTargetTrait,true,_loc5_,_loc6_,false,true,0.5 * _loc8_ / param2.maxRockets,param2.showExplosion);
               param1.gameWorld.addChild(_loc9_);
               _loc7_ = Math.max(_loc7_,_loc9_.duration);
               _loc8_++;
            }
            if(this._effect.miss)
            {
               TweenMax.delayedCall(_loc7_,this.handleAirStrikeMissedDisplay);
            }
         }
      }
      
      public function handleAirStrikeMissedDisplay() : void
      {
         if(Settings.displayHitpointBubbles)
         {
            ScreenManager.getInstance().map.effects.addEffect(new DamageReceivedEffect(this._effect.target,0));
         }
      }
   }
}

