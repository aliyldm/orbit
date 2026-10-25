package net.bigpoint.darkorbit.net.netty.handlers.combat
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.com.module.AttackTypeModule;
   
   public class AttackTypeMap
   {
      
      public static const ROCKET:String = "ROCKET";
      
      public static const LASER:String = "LASER";
      
      public static const MINE:String = "MINE";
      
      public static const RADIATION:String = "RADIATION";
      
      public static const PLASMA:String = "PLASMA";
      
      public static const ECI:String = "ECI";
      
      public static const SL:String = "SL";
      
      public static const CID:String = "CID";
      
      public static const SINGULARITY:String = "SINGULARITY";
      
      public static const KAMIKAZE:String = "KAMIKAZE";
      
      public static const REPAIR:String = "REPAIR";
      
      public static const DECELERATION:String = "DECELERATION";
      
      public static const SHIELD_ABSORBER_ROCKET_CREDITS:String = "SAR01";
      
      public static const SHIELD_ABSORBER_ROCKET_URIDIUM:String = "SAR02";
      
      public static const INCINERATE:String = "INCINERATE";
      
      public static const SPREAD:String = "SPREAD";
      
      private static var _attackTypeMap:Dictionary = initialize();
      
      public function AttackTypeMap()
      {
         super();
      }
      
      public static function getAttackType(param1:uint) : String
      {
         return _attackTypeMap[param1];
      }
      
      private static function initialize() : Dictionary
      {
         var _loc1_:Dictionary = new Dictionary();
         _loc1_[AttackTypeModule.ATTACKTYPE_ROCKET] = ROCKET;
         _loc1_[AttackTypeModule.ATTACKTYPE_LASER] = LASER;
         _loc1_[AttackTypeModule.ATTACKTYPE_MINE] = MINE;
         _loc1_[AttackTypeModule.ATTACKTYPE_RADIATION] = RADIATION;
         _loc1_[AttackTypeModule.ATTACKTYPE_PLASMA] = PLASMA;
         _loc1_[AttackTypeModule.ATTACKTYPE_ECI] = ECI;
         _loc1_[AttackTypeModule.ATTACKTYPE_SL] = SL;
         _loc1_[AttackTypeModule.ATTACKTYPE_CID] = CID;
         _loc1_[AttackTypeModule.ATTACKTYPE_SINGULARITY] = SINGULARITY;
         _loc1_[AttackTypeModule.ATTACKTYPE_KAMIKAZE] = KAMIKAZE;
         _loc1_[AttackTypeModule.ATTACKTYPE_REPAIR] = REPAIR;
         _loc1_[AttackTypeModule.ATTACKTYPE_DECELERATION] = DECELERATION;
         _loc1_[AttackTypeModule.ATTACKTYPE_SHIELD_ABSORBER_ROCKET_CREDITS] = SHIELD_ABSORBER_ROCKET_CREDITS;
         _loc1_[AttackTypeModule.ATTACKTYPE_SHIELD_ABSORBER_ROCKET_URIDIUM] = SHIELD_ABSORBER_ROCKET_URIDIUM;
         _loc1_[AttackTypeModule.ATTACKTYPE_INCINERATE] = INCINERATE;
         _loc1_[AttackTypeModule.ATTACKTYPE_SPREAD] = SPREAD;
         _loc1_[AttackTypeModule.ATTACKTYPE_MULTIPLE_ROCKET] = ROCKET;
         return _loc1_;
      }
   }
}

