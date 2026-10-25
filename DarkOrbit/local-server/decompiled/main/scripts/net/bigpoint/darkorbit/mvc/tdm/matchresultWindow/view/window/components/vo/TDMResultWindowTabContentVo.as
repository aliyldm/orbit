package net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.components.vo
{
   import com.bigpoint.utils.StringPair;
   import net.bigpoint.darkorbit.Hero;
   
   public class TDMResultWindowTabContentVo
   {
      
      private var _palyerNameLable:StringPair;
      
      private var _killLDeathable:StringPair;
      
      private var _pointsDeltaLable:StringPair;
      
      private var _damageGivenLable:StringPair;
      
      private var _damageTakenLable:StringPair;
      
      private var _peakDamageLable:StringPair;
      
      private var _winnigStreakLable:StringPair;
      
      public function TDMResultWindowTabContentVo(param1:StringPair, param2:StringPair, param3:StringPair, param4:StringPair, param5:StringPair, param6:StringPair, param7:StringPair)
      {
         super();
         this._palyerNameLable = param1;
         this._killLDeathable = param2;
         this._pointsDeltaLable = param3;
         this._damageGivenLable = param4;
         this._damageTakenLable = param5;
         this._peakDamageLable = param6;
         this._winnigStreakLable = param7;
      }
      
      public function get palyerNameLable() : StringPair
      {
         return this._palyerNameLable;
      }
      
      public function get pointsDeltaLable() : StringPair
      {
         return this._pointsDeltaLable;
      }
      
      public function get damageGivenLable() : StringPair
      {
         return this._damageGivenLable;
      }
      
      public function get damageTakenLable() : StringPair
      {
         return this._damageTakenLable;
      }
      
      public function get peakDamageLable() : StringPair
      {
         return this._peakDamageLable;
      }
      
      public function get winnigStreakLable() : StringPair
      {
         return this._winnigStreakLable;
      }
      
      public function get killLDeathable() : StringPair
      {
         return this._killLDeathable;
      }
      
      public function get isHero() : Boolean
      {
         return this._palyerNameLable.left == Hero.username;
      }
   }
}

