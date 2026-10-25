package net.bigpoint.darkorbit
{
   import com.bigpoint.utils.bindables.BindableBoolean;
   import com.bigpoint.utils.bindables.BindableInt;
   import com.bigpoint.utils.bindables.BindableString;
   import flash.sampler.getSampleCount;
   import net.bigpoint.darkorbit.com.module.OreTradeInfoCommand;
   import net.bigpoint.darkorbit.data.RankedHuntingEventData;
   import net.bigpoint.darkorbit.data.vo.HighScoreStatsVO;
   import net.bigpoint.darkorbit.map.model.env.collectable.Collectable;
   import net.bigpoint.darkorbit.pattern.RepairInfo;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class Hero
   {
      
      public static var userID:int;
      
      public static var shipType:String;
      
      public static var debugShipType:String;
      
      public static var sessionID:String;
      
      public static var rankedHuntingEventData:RankedHuntingEventData;
      
      public static var highScoreGateStatsData:HighScoreStatsVO;
      
      public static var creditsAmount:Number;
      
      public static var uridiumAmount:Number;
      
      public static var jackpotAmount:Number;
      
      public static var experiencePoints:Number;
      
      public static var level:int;
      
      public static var honorPoints:Number;
      
      public static var shownSpeed:int;
      
      public static var admin:Boolean;
      
      public static var inTradeArea:Boolean;
      
      public static var repairInfo:RepairInfo;
      
      public static var isKilled:Boolean;
      
      public static var jumpVouchersAmount:int;
      
      public static var bootyKeysAmount:uint;
      
      public static var bootyKeysBlueAmount:uint;
      
      public static var bootyKeysRedAmount:uint;
      
      public static var bootyKeysSilverAmount:uint;
      
      public static var bootyKeysMasqueAmount:uint;
      
      public static var bootyKeysPrometheusAmount:uint;
      
      public static var bootyKeysBlackAmount:uint;
      
      public static var bootyKeysBlacklightCipherAmount:uint;
      
      public static var bootyKeysBlacklightDecoderAmount:uint;
      
      public static var bootyKeysProsperousAmount:uint;
      
      public static var bootyKeysAstralAmount:uint;
      
      public static var bootyKeysAstralPrimeAmount:uint;
      
      public static var bootyKeysEmpyrianAmount:uint;
      
      public static var bootyKeysLucentAmount:uint;
      
      public static var bootyKeysPerseusAmount:uint;
      
      public static var bootyKeysLaurelAmount:uint;
      
      public static var bootyKeysEchoBlueAmount:uint;
      
      public static var bootyKeysEchoGreenAmount:uint;
      
      public static var bootyKeysEchoPurpleAmount:uint;
      
      public static var bootyKeysEchoRedAmount:uint;
      
      public static var scoreFestStatsData:HighScoreStatsVO;
      
      public static var lastCollectedItem:Collectable;
      
      public static var clanID:int;
      
      public static var raidGateStatus:uint;
      
      private static var _addendum:String;
      
      public static var username:String = "";
      
      private static var _clanTag:String = NO_CLAN;
      
      public static var factionID:BindableInt = new BindableInt();
      
      public static var advancedJumpCPUEquipped:BindableBoolean = new BindableBoolean(false);
      
      public static var radarCPUEquipped:BindableBoolean = new BindableBoolean(false);
      
      public static var calculateGearScore:Boolean = true;
      
      public static var premium:BindableBoolean = new BindableBoolean(false);
      
      public static var tradeAreaType:uint = OreTradeInfoCommand.TRADETYPE_INACTIVE;
      
      public static var captainEnergy:BindableInt = new BindableInt(0);
      
      public static var maxCaptainEnergy:BindableInt = new BindableInt(0);
      
      public static var captainEnergyDrain:BindableInt = new BindableInt(0);
      
      public static var captainPerkInfo:BindableString = new BindableString("");
      
      public static var ownsPet:Boolean = false;
      
      public static var isPetDestroyed:Boolean = false;
      
      public static const cargo:BindableInt = new BindableInt(0);
      
      public static const maxCargo:BindableInt = new BindableInt(0);
      
      public static const isSolvingCaptcha:Boolean = false;
      
      public static const NO_CLAN:String = "noclan";
      
      public static var NO_CLAN_LOCA:String = "noclan";
      
      public static var clanChanged:ISignal = new Signal();
      
      public static var factionChanged:ISignal = new Signal();
      
      public function Hero()
      {
         super();
      }
      
      public static function get factionName() : String
      {
         return InGameCatalog.getInstance().factions_names_by_FactionModule[factionID.value].toLowerCase();
      }
      
      public static function setTradeAreaType(param1:uint) : void
      {
         tradeAreaType = param1;
      }
      
      public static function get isInClan() : Boolean
      {
         return clanTag != NO_CLAN_LOCA && clanTag != null && clanTag != "";
      }
      
      public static function toString() : String
      {
         var _loc1_:String = "";
         _loc1_ += " Hero.username  " + Hero.username + "\n";
         _loc1_ += " Hero.userID    " + Hero.userID + "\n";
         _loc1_ += " Hero.sessionID " + Hero.sessionID + "\n";
         _loc1_ += " Hero.clanTag   " + Hero.clanTag + "\n";
         return _loc1_ + (" Hero.factionID " + Hero.factionID.value + "\n");
      }
      
      public static function get channelNameAddendum() : String
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:String = null;
         var _loc1_:String = "";
         if(_addendum == null)
         {
            _loc2_ = (Math.random() * 100000 >> 1).toString();
            _loc3_ = new Date().valueOf().toString();
            _loc4_ = uint(int(_loc2_));
            _loc5_ = uint(int(_loc3_));
            _loc6_ = (_loc4_ ^ _loc5_).toString();
            _addendum = _loc2_ + _loc3_ + _loc3_ + _loc6_;
         }
         return _loc1_ + (Hero.sessionID + _addendum);
      }
      
      public static function clearChannelNameAddendum() : void
      {
         _addendum = null;
      }
      
      public static function getHeroInfo() : *
      {
         var _loc1_:String = userID.toString(16) + "|" + sessionID;
         if(calculateGearScore)
         {
            _loc1_ += "|" + getSampleCount();
         }
         return _loc1_;
      }
      
      public static function get clanTag() : String
      {
         return _clanTag;
      }
      
      public static function set clanTag(param1:String) : void
      {
         if(param1 != _clanTag)
         {
            _clanTag = param1;
            clanChanged.dispatch();
         }
      }
      
      public static function set faction(param1:int) : void
      {
         if(param1 != Hero.factionID.value)
         {
            Hero.factionID.value = param1;
            factionChanged.dispatch();
         }
      }
   }
}

