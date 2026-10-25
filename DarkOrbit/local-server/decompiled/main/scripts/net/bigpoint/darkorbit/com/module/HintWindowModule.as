package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HintWindowModule implements IModule
   {
      
      private static var _instance:HintWindowModule;
      
      public static const HINTTYPE_SHIP_REPAIR:int = 0;
      
      public static const HINTTYPE_SKYLAB:int = 1;
      
      public static const HINTTYPE_PVP_WARNING:int = 2;
      
      public static const HINTTYPE_THE_SHOP:int = 3;
      
      public static const HINTTYPE_CHANGING_SHIPS:int = 4;
      
      public static const HINTTYPE_INSTALLING_NEW_EQUIPMENT:int = 5;
      
      public static const HINTTYPE_JUMP_GATES:int = 6;
      
      public static const HINTTYPE_PREPARE_BATTLE:int = 7;
      
      public static const HINTTYPE_GET_MORE_AMMO:int = 8;
      
      public static const HINTTYPE_BOOST_YOUR_EQUIP:int = 9;
      
      public static const HINTTYPE_SELL_RESOURCE:int = 10;
      
      public static const HINTTYPE_WEALTHY_FAMOUS:int = 11;
      
      public static const HINTTYPE_WELCOME:int = 12;
      
      public static const HINTTYPE_HOW_TO_FLY:int = 13;
      
      public static const HINTTYPE_REQUEST_MISSION:int = 14;
      
      public static const HINTTYPE_CONFIG_SWITCH:int = 15;
      
      public static const HINTTYPE_POLICY_CHANGES:int = 16;
      
      public static const HINTTYPE_EQUIP_YOUR_ROCKETS:int = 17;
      
      public static const HINTTYPE_UNKOWN_DANGERS:int = 18;
      
      public static const HINTTYPE_ATTACK:int = 19;
      
      public static const HINTTYPE_JUMP_DEVICE:int = 20;
      
      public static const HINTTYPE_FULL_CARGO:int = 21;
      
      public static const HINTTYPE_SECOND_CONFIGURATION:int = 22;
      
      public static const HINTTYPE_ITEM_UPGRADE:int = 23;
      
      public static const HINTTYPE_GALAXY_GATE:int = 24;
      
      public static const HINTTYPE_SKILL_TREE:int = 25;
      
      public static const HINTTYPE_TECH_FACTORY:int = 26;
      
      public static const HINTTYPE_CLAN_BATTLE_STATION:int = 27;
      
      public static const HINTTYPE_PALLADIUM:int = 28;
      
      public static const HINTTYPE_AUCTION_HOUSE:int = 29;
      
      public static const HINTTYPE_ROCKET_LAUNCHER:int = 30;
      
      public static const HINTTYPE_EXTRA_CPU:int = 31;
      
      public static const HINTTYPE_SHIP_DESIGN:int = 32;
      
      public static const HINTTYPE_LOOKING_FOR_GROUPS:int = 33;
      
      public static const HINTTYPE_CONTACT_LIST:int = 34;
      
      public static const HINTTYPE_ORE_TRANSFER:int = 35;
      
      public static const HINTTYPE_TRAINING_GROUNDS:int = 36;
      
      public static const HINTTYPE_PRO_ACTION_BAR_INFO:int = 37;
      
      public static const HINTTYPE_MOTIVATIONAL_SURVEY:int = 38;
      
      public static const HINTTYPE_ASSEMBLY:int = 39;
      
      public static const HINTTYPE__MAX:int = 40;
      
      public var content:int = 0;
      
      public function HintWindowModule(param1:int = 0)
      {
         super();
         this.content = param1;
      }
      
      public static function get instance() : HintWindowModule
      {
         return _instance || (_instance = new HintWindowModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 23930;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.content = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(23930);
         param1.writeShort(this.content);
      }
   }
}

