package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class QuestRequirementModule implements IModule
   {
      
      private static var _instance:QuestRequirementModule;
      
      public static const QUESTREQUIREMENTTYPE_LEVEL:int = 0;
      
      public static const QUESTREQUIREMENTTYPE_NUMBER_OF_QUESTS_ACCEPTED:int = 1;
      
      public static const QUESTREQUIREMENTTYPE_DATE:int = 2;
      
      public static const QUESTREQUIREMENTTYPE_PRE_QUEST:int = 3;
      
      public static const QUESTREQUIREMENTTYPE_HOURS_AFTER_QUEST:int = 4;
      
      public static const QUESTREQUIREMENTTYPE_EVENT:int = 5;
      
      public static const QUESTREQUIREMENTTYPE_EXCLUSIVE_POOL_QUEST_RUNNING:int = 6;
      
      public static const QUESTREQUIREMENTTYPE__MAX:int = 7;
      
      public var requirementType:int = 0;
      
      public var minValue:Number = 0;
      
      public var maxValue:Number = 0;
      
      public var matches:Vector.<QuestLocalizationModule>;
      
      public var missingMatches:Vector.<QuestLocalizationModule>;
      
      public function QuestRequirementModule(param1:int = 0, param2:Number = 0, param3:Number = 0, param4:Vector.<QuestLocalizationModule> = null, param5:Vector.<QuestLocalizationModule> = null)
      {
         super();
         this.requirementType = param1;
         this.minValue = param2;
         this.maxValue = param3;
         if(param4 == null)
         {
            this.matches = new Vector.<QuestLocalizationModule>();
         }
         else
         {
            this.matches = param4;
         }
         if(param5 == null)
         {
            this.missingMatches = new Vector.<QuestLocalizationModule>();
         }
         else
         {
            this.missingMatches = param5;
         }
      }
      
      public static function get instance() : QuestRequirementModule
      {
         return _instance || (_instance = new QuestRequirementModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 3366;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 24;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:QuestLocalizationModule = null;
         var _loc5_:QuestLocalizationModule = null;
         this.requirementType = param1.readShort();
         this.minValue = param1.readDouble();
         this.maxValue = param1.readDouble();
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
            _loc4_ = QuestLocalizationModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.matches.push(_loc4_);
            _loc2_++;
         }
         while(this.missingMatches.length > 0)
         {
            this.missingMatches.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = QuestLocalizationModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.missingMatches.push(_loc5_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:QuestLocalizationModule = null;
         var _loc3_:QuestLocalizationModule = null;
         param1.writeShort(3366);
         param1.writeShort(this.requirementType);
         param1.writeDouble(this.minValue);
         param1.writeDouble(this.maxValue);
         param1.writeByte(this.matches.length);
         for each(_loc2_ in this.matches)
         {
            _loc2_.write(param1);
         }
         param1.writeByte(this.missingMatches.length);
         for each(_loc3_ in this.missingMatches)
         {
            _loc3_.write(param1);
         }
      }
   }
}

