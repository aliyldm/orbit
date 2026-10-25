package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class JumpGateTypeModule implements IModule
   {
      
      private static var _instance:JumpGateTypeModule;
      
      public static const JUMPGATETYPE_NORMAL:int = 0;
      
      public static const JUMPGATETYPE_HOME_GATE:int = 1;
      
      public static const JUMPGATETYPE_RANDOM_GATE:int = 2;
      
      public static const JUMPGATETYPE_GALAXY_GATE:int = 3;
      
      public static const JUMPGATETYPE_GALAXY_GATE_1:int = 4;
      
      public static const JUMPGATETYPE_GALAXY_GATE_2:int = 5;
      
      public static const JUMPGATETYPE_GALAXY_GATE_3:int = 6;
      
      public static const JUMPGATETYPE_GALAXY_GATE_4:int = 7;
      
      public static const JUMPGATETYPE_GALAXY_GATE_5:int = 8;
      
      public static const JUMPGATETYPE_GROUP_GATE:int = 9;
      
      public static const JUMPGATETYPE_TEAM_DEATHMATCH:int = 10;
      
      public static const JUMPGATETYPE_TEAM_DEATHMATCH_1:int = 11;
      
      public static const JUMPGATETYPE_TEAM_DEATHMATCH_2:int = 12;
      
      public static const JUMPGATETYPE_INVASIONMAP_GATE:int = 13;
      
      public static const JUMPGATETYPE_INVASIONMAP_GATE_1:int = 14;
      
      public static const JUMPGATETYPE_INVASIONMAP_GATE_2:int = 15;
      
      public static const JUMPGATETYPE_INVASIONMAP_GATE_3:int = 16;
      
      public static const JUMPGATETYPE_INVASIONMAP_LVL_GATE:int = 17;
      
      public static const JUMPGATETYPE_INVISIBLE:int = 18;
      
      public static const JUMPGATETYPE_NC_GATE:int = 19;
      
      public static const JUMPGATETYPE_ORBSTER_GATE:int = 20;
      
      public static const JUMPGATETYPE_BDAY_IV_GATE:int = 21;
      
      public static const JUMPGATETYPE_BREACH_GATE:int = 22;
      
      public static const JUMPGATETYPE__MAX:int = 23;
      
      public var typeValue:int = 0;
      
      public function JumpGateTypeModule(param1:int = 0)
      {
         super();
         this.typeValue = param1;
      }
      
      public static function get instance() : JumpGateTypeModule
      {
         return _instance || (_instance = new JumpGateTypeModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 141;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.typeValue = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(141);
         param1.writeShort(this.typeValue);
      }
   }
}

