package net.bigpoint.darkorbit.map.model.env.collectable
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.map.model.traits.MouseHitAreaTrait;
   import net.bigpoint.darkorbit.pattern.OrePattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class Ore extends Collectable
   {
      
      public static var loot_ore_keys:Array = ["ore_prometium","ore_endurium","ore_terbium","ore_xenomit","ore_prometid","ore_duranium","ore_promerium","ore_seprom","ore_palladium","ore_osmium"];
      
      private var _typeID:int;
      
      public function Ore(param1:int, param2:String, param3:int, param4:int)
      {
         this._typeID = param1;
         super("ore_" + param1,param2,param3,param4,false,Settings.displayResources);
         MouseHitAreaTrait(getFirstTrait(MouseHitAreaTrait)).toolTip = BPLocale.getItem(PatternManager.orePatterns[param1].languageKey);
      }
      
      public static function getOres(param1:Array) : Array
      {
         var _loc4_:int = 0;
         var _loc5_:OrePattern = null;
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = int(param1[_loc3_]);
            _loc5_ = PatternManager.orePatterns[_loc4_];
            _loc2_.push(_loc5_);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function get typeID() : int
      {
         return this._typeID;
      }
   }
}

