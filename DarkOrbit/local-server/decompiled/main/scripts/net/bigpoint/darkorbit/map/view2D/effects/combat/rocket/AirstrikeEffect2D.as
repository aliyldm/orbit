package net.bigpoint.darkorbit.map.view2D.effects.combat.rocket
{
   import com.greensock.TweenMax;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.DamageReceivedEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.AirstrikeEffect;
   import net.bigpoint.darkorbit.map.model.traits.AttackTargetTrait;
   import net.bigpoint.darkorbit.map.model.traits.AttackerTrait;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.pattern.RocketPattern;
   import net.bigpoint.darkorbit.pattern.RocketSmokePattern;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class AirstrikeEffect2D
   {
      
      private var _effect:AirstrikeEffect;
      
      public function AirstrikeEffect2D(param1:MapView2D, param2:AirstrikeEffect)
      {
         var _loc3_:int = 0;
         var _loc4_:RocketPattern = null;
         var _loc5_:RocketSmokePattern = null;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:Rocket2D = null;
         super();
         this._effect = param2;
         if(this._effect.attacker != null && this._effect.target != null)
         {
            _loc3_ = AttackerTrait(this._effect.attacker.getFirstTrait(AttackerTrait)).rocketLauncher.rocketClassId;
            _loc4_ = PatternManager.getRocketPattern(_loc3_,this._effect.rocketType) || PatternManager.getRocketPattern(0,1);
            AudioManager.playSoundEffect(_loc4_.getSoundID(),false,false,this._effect.attacker.position.x,this._effect.attacker.position.y);
            AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_AIRSTRIKE,false,false,this._effect.attacker.position.x,this._effect.attacker.position.y);
            _loc5_ = PatternManager.rocketSmokePatterns[param2.smokeType];
            _loc6_ = 0;
            _loc7_ = 0;
            while(_loc7_ < this._effect.maxRockets)
            {
               _loc8_ = new Rocket2D(this._effect.attacker.getFirstTrait(AttackerTrait) as AttackerTrait,this._effect.target.getFirstTrait(AttackTargetTrait) as AttackTargetTrait,true,_loc4_,_loc5_,false,true,0.5 * _loc7_ / param2.maxRockets);
               param1.projectileLayer.addChild(_loc8_);
               _loc6_ = Math.max(_loc6_,_loc8_.duration);
               _loc7_++;
            }
            if(this._effect.miss)
            {
               TweenMax.delayedCall(_loc6_,this.handleAirStrikeMissedDisplay);
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

