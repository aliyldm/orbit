package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class QuestConditionModule implements IModule
   {
      
      private static var _instance:QuestConditionModule;
      
      public static const CONDITIONTYPE_QUESTCASE:int = 0;
      
      public static const CONDITIONTYPE_TIMER:int = 1;
      
      public static const CONDITIONTYPE_HASTE:int = 2;
      
      public static const CONDITIONTYPE_ENDURANCE:int = 3;
      
      public static const CONDITIONTYPE_COUNTDOWN:int = 4;
      
      public static const CONDITIONTYPE_COLLECT:int = 5;
      
      public static const CONDITIONTYPE_KILL_NPC:int = 6;
      
      public static const CONDITIONTYPE_DAMAGE:int = 7;
      
      public static const CONDITIONTYPE_AVOID_DAMAGE:int = 8;
      
      public static const CONDITIONTYPE_TAKE_DAMAGE:int = 9;
      
      public static const CONDITIONTYPE_AVOID_DEATH:int = 10;
      
      public static const CONDITIONTYPE_COORDINATES:int = 11;
      
      public static const CONDITIONTYPE_DISTANCE:int = 12;
      
      public static const CONDITIONTYPE_TRAVEL:int = 13;
      
      public static const CONDITIONTYPE_FUEL_SHORTAGE:int = 14;
      
      public static const CONDITIONTYPE_PROXIMITY:int = 15;
      
      public static const CONDITIONTYPE_MAP:int = 16;
      
      public static const CONDITIONTYPE_MAP_DIVERSE:int = 17;
      
      public static const CONDITIONTYPE_EMPTY:int = 18;
      
      public static const CONDITIONTYPE_MISCELLANEOUS:int = 19;
      
      public static const CONDITIONTYPE_AMMUNITION:int = 20;
      
      public static const CONDITIONTYPE_SAVE_AMMUNITION:int = 21;
      
      public static const CONDITIONTYPE_SPEND_AMMUNITION:int = 22;
      
      public static const CONDITIONTYPE_SALVAGE:int = 23;
      
      public static const CONDITIONTYPE_STEAL:int = 24;
      
      public static const CONDITIONTYPE_KILL:int = 25;
      
      public static const CONDITIONTYPE_DEAL_DAMAGE:int = 26;
      
      public static const CONDITIONTYPE_KILL_NPCS:int = 27;
      
      public static const CONDITIONTYPE_KILL_PLAYERS:int = 28;
      
      public static const CONDITIONTYPE_DAMAGE_NPCS:int = 29;
      
      public static const CONDITIONTYPE_DAMAGE_PLAYERS:int = 30;
      
      public static const CONDITIONTYPE_DAMAGE_ENEMY_PLAYERS:int = 31;
      
      public static const CONDITIONTYPE_KILL_MAPASSETS:int = 32;
      
      public static const CONDITIONTYPE_DAMAGE_MAPASSETS:int = 33;
      
      public static const CONDITIONTYPE_VISIT_MAP:int = 34;
      
      public static const CONDITIONTYPE_DIE:int = 35;
      
      public static const CONDITIONTYPE_AVOID_KILL_NPC:int = 36;
      
      public static const CONDITIONTYPE_AVOID_KILL_NPCS:int = 37;
      
      public static const CONDITIONTYPE_AVOID_KILL_PLAYERS:int = 38;
      
      public static const CONDITIONTYPE_AVOID_DAMAGE_NPCS:int = 39;
      
      public static const CONDITIONTYPE_AVOID_DAMAGE_PLAYERS:int = 40;
      
      public static const CONDITIONTYPE_PREVENT:int = 41;
      
      public static const CONDITIONTYPE_JUMP:int = 42;
      
      public static const CONDITIONTYPE_AVOID_JUMP:int = 43;
      
      public static const CONDITIONTYPE_STEADINESS:int = 44;
      
      public static const CONDITIONTYPE_MULTIPLIER:int = 45;
      
      public static const CONDITIONTYPE_STAY_AWAY:int = 46;
      
      public static const CONDITIONTYPE_IN_GROUP:int = 47;
      
      public static const CONDITIONTYPE_KILL_ANY:int = 48;
      
      public static const CONDITIONTYPE_WEB:int = 49;
      
      public static const CONDITIONTYPE_CLIENT:int = 50;
      
      public static const CONDITIONTYPE_CARGO:int = 51;
      
      public static const CONDITIONTYPE_SELL_ORE:int = 52;
      
      public static const CONDITIONTYPE_LEVEL:int = 53;
      
      public static const CONDITIONTYPE_USER_DEFINED:int = 54;
      
      public static const CONDITIONTYPE_COLLECT_BONUS_BOX:int = 55;
      
      public static const CONDITIONTYPE_FINISH_QUEST:int = 56;
      
      public static const CONDITIONTYPE_QUICK_BUY:int = 57;
      
      public static const CONDITIONTYPE_ENTER_GROUP:int = 58;
      
      public static const CONDITIONTYPE_RESTRICT_AMMUNITION_KILL_NPC:int = 59;
      
      public static const CONDITIONTYPE_RESTRICT_AMMUNITION_KILL_PLAYER:int = 60;
      
      public static const CONDITIONTYPE_KILL_PLAYER:int = 61;
      
      public static const CONDITIONTYPE_VISIT_QUEST_GIVER:int = 62;
      
      public static const CONDITIONTYPE_REAL_TIME_HASTE:int = 63;
      
      public static const CONDITIONTYPE_BELOW_HONOUR:int = 64;
      
      public static const CONDITIONTYPE_SPECIAL_HONOUR:int = 65;
      
      public static const CONDITIONTYPE_IN_CLAN:int = 66;
      
      public static const CONDITIONTYPE_COLLECT_LOOT:int = 67;
      
      public static const CONDITIONTYPE_FINISH_STARTER_GATE:int = 68;
      
      public static const CONDITIONTYPE_REFINE_ORE:int = 69;
      
      public static const CONDITIONTYPE_PUT_ITEM_IN_SLOT_BAR:int = 70;
      
      public static const CONDITIONTYPE_VISIT_MAP_TYPE:int = 71;
      
      public static const CONDITIONTYPE_USE_ORE_UPDATE:int = 72;
      
      public static const CONDITIONTYPE_VISIT_JUMP_GATE_TO_MAP_TYPE:int = 73;
      
      public static const CONDITIONTYPE_ACTIVATE_MAP_ASSET_TYPE:int = 74;
      
      public static const CONDITIONTYPE_VISIT_MAP_ASSET:int = 75;
      
      public static const CONDITIONTYPE_UPDATE_SKYLAB_TO_LEVEL:int = 76;
      
      public static const CONDITIONTYPE_ON_MAP:int = 77;
      
      public static const CONDITIONTYPE_BEACON_TAKEOVER:int = 78;
      
      public static const CONDITIONTYPE_FINISH_GALAXY_GATE:int = 79;
      
      public static const CONDITIONTYPE_FINISH_GALAXY_GATES:int = 80;
      
      public static const CONDITIONTYPE_GAIN_INFLUENCE:int = 81;
      
      public static const CONDITIONTYPE_GENERIC_TEXT:int = 82;
      
      public static const CONDITIONTYPE_DISRUPTED:int = 83;
      
      public static const CONDITIONTYPE_REAL_TIME_DATE_HASTE:int = 84;
      
      public static const CONDITIONTYPE_COLLECT_BUILT_RECIPE:int = 85;
      
      public static const CONDITIONTYPE_COLLECT_BONUS_BOX_TYPE:int = 86;
      
      public static const CONDITIONTYPE_COMPLETED_OBJECTIVES:int = 87;
      
      public static const CONDITIONTYPE_ACTIVATE_CPU:int = 88;
      
      public static const CONDITIONTYPE_SPEND_ITEM:int = 89;
      
      public static const CONDITIONTYPE_CLEAR_GALAXY_GATE_WAVE:int = 90;
      
      public static const CONDITIONTYPE_SCORE_ROGUE_LITE:int = 91;
      
      public static const CONDITIONTYPE_COLLECT_BOOTY_BOX_TYPE:int = 92;
      
      public static const CONDITIONTYPE_SPEND_RECIPE_INGREDIENTS:int = 93;
      
      public static const CONDITIONTYPE_HAS_GOLD_PASS:int = 94;
      
      public static const CONDITIONTYPE_COMPLETE_SEASON_PASS_QUESTS:int = 95;
      
      public static const CONDITIONTYPE_LOGIN:int = 96;
      
      public static const CONDITIONTYPE_DURING_EVENT:int = 97;
      
      public static const CONDITIONTYPE_COLLECT_SHIP_LOOT:int = 98;
      
      public static const CONDITIONTYPE_COLLECT_SHIP_DESIGN_LOOT:int = 99;
      
      public static const CONDITIONTYPE_RECHARGE_AMOUNT:int = 100;
      
      public static const CONDITIONTYPE_BOOSTER_AMOUNT:int = 101;
      
      public static const CONDITIONTYPE__MAX:int = 102;
      
      public var id:int = 0;
      
      public var matches:Vector.<String>;
      
      public var type:int = 0;
      
      public var displayType:int = 0;
      
      public var targetValue:Number = 0;
      
      public var mandatory:Boolean = false;
      
      public var state:QuestConditionStateModule;
      
      public var subConditions:Vector.<QuestConditionModule>;
      
      public function QuestConditionModule(param1:int = 0, param2:Vector.<String> = null, param3:int = 0, param4:int = 0, param5:Number = 0, param6:Boolean = false, param7:QuestConditionStateModule = null, param8:Vector.<QuestConditionModule> = null)
      {
         super();
         this.id = param1;
         if(param2 == null)
         {
            this.matches = new Vector.<String>();
         }
         else
         {
            this.matches = param2;
         }
         this.type = param3;
         this.displayType = param4;
         this.targetValue = param5;
         this.mandatory = param6;
         if(param7 == null)
         {
            this.state = new QuestConditionStateModule();
         }
         else
         {
            this.state = param7;
         }
         if(param8 == null)
         {
            this.subConditions = new Vector.<QuestConditionModule>();
         }
         else
         {
            this.subConditions = param8;
         }
      }
      
      public static function get instance() : QuestConditionModule
      {
         return _instance || (_instance = new QuestConditionModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2002;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 21;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:QuestConditionModule = null;
         this.id = param1.readInt();
         this.id = this.id << 5 % 32 | this.id >>> 32 - 5 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.matches.length > 0)
         {
            this.matches.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            this.matches.push(param1.readUTF());
            _loc2_++;
         }
         this.type = param1.readShort();
         this.displayType = param1.readShort();
         this.targetValue = param1.readDouble();
         this.mandatory = param1.readBoolean();
         this.state = QuestConditionStateModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.state)
         {
            this.state.read(param1);
         }
         while(this.subConditions.length > 0)
         {
            this.subConditions.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = QuestConditionModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.subConditions.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:String = null;
         var _loc3_:QuestConditionModule = null;
         param1.writeShort(2002);
         param1.writeInt(this.id >>> 5 % 32 | this.id << 32 - 5 % 32);
         param1.writeByte(this.matches.length);
         for each(_loc2_ in this.matches)
         {
            param1.writeUTF(_loc2_);
         }
         param1.writeShort(this.type);
         param1.writeShort(this.displayType);
         param1.writeDouble(this.targetValue);
         param1.writeBoolean(this.mandatory);
         if(null != this.state)
         {
            this.state.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeByte(this.subConditions.length);
         for each(_loc3_ in this.subConditions)
         {
            _loc3_.write(param1);
         }
      }
   }
}

