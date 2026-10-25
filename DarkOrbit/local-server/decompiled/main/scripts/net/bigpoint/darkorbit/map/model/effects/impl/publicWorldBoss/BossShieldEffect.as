package net.bigpoint.darkorbit.map.model.effects.impl.publicWorldBoss
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   
   public class BossShieldEffect extends MapObjectEffect
   {
      
      private var _level:int;
      
      public function BossShieldEffect(param1:MapEntity, param2:int)
      {
         this._level = param2;
         super(EffectIDList.BOSS_SHIELD,param1,PERSISTANT,new EffectPattern(EffectIDList.BOSS_SHIELD,"boss_shield"));
      }
      
      public function get level() : int
      {
         return this._level;
      }
      
      public function set level(param1:int) : void
      {
         this._level = param1;
      }
      
      public function get resKey() : String
      {
         return PatternManager.bossShieldPatterns[this.level].resKey;
      }
      
      public function get particleFilename() : String
      {
         return PatternManager.bossShieldPatterns[this.level].particleFilename;
      }
   }
}

