package net.bigpoint.darkorbit.questfm
{
   import net.bigpoint.darkorbit.com.module.LootModule;
   import net.bigpoint.darkorbit.com.module.QuestCaseModule;
   import net.bigpoint.darkorbit.com.module.QuestConditionModule;
   import net.bigpoint.darkorbit.com.module.QuestDefinitionModule;
   import net.bigpoint.darkorbit.com.module.QuestElementModule;
   import net.bigpoint.darkorbit.mvc.questWindow.model.vo.RewardVO;
   
   public class QuestParser
   {
      
      private static const _instance:QuestParser = new QuestParser();
      
      private var element_count:int;
      
      private var condition_count:int;
      
      private var case_count:int;
      
      private var conditionFactory:ConditionFactory;
      
      private var flat_conditions:Array;
      
      public function QuestParser()
      {
         super();
         if(_instance)
         {
            throw new Error("QuestParser is a singleton");
         }
         this.conditionFactory = new ConditionFactory();
      }
      
      public static function get instance() : QuestParser
      {
         return _instance;
      }
      
      public function parseDefinition(param1:QuestDefinitionModule) : Quest
      {
         var _loc5_:LootModule = null;
         var _loc6_:Quest = null;
         this.initCounts();
         var _loc2_:QuestCaseModule = param1.rootCase;
         var _loc3_:Case = this.parseCaseNetty(_loc2_);
         var _loc4_:Array = [];
         for each(_loc5_ in param1.rewards)
         {
            _loc4_.push(new RewardVO(_loc5_));
         }
         _loc6_ = new Quest(param1.id,_loc3_,_loc4_,false,param1.portraitId,param1.textKeyFoundation);
         _loc6_.types = param1.types;
         _loc6_.flatConditions = this.flat_conditions;
         return _loc6_;
      }
      
      private function initCounts() : void
      {
         this.element_count = 0;
         this.case_count = 0;
         this.condition_count = 0;
         this.flat_conditions = [];
      }
      
      private function parseCaseNetty(param1:QuestCaseModule) : Case
      {
         var _loc3_:QuestElementModule = null;
         var _loc4_:Case = null;
         var _loc5_:ICondition = null;
         var _loc2_:Case = new Case();
         ++this.case_count;
         ++this.element_count;
         _loc2_.id = param1.id;
         _loc2_.active = param1.active;
         _loc2_.mandatory = param1.mandatory;
         _loc2_.ordered = param1.ordered;
         _loc2_.mandatory_count = param1.mandatoryCount;
         var _loc6_:int = 0;
         while(_loc6_ < param1.modifier.length)
         {
            _loc3_ = param1.modifier[_loc6_];
            if(_loc3_.questCase.id > 0)
            {
               _loc4_ = Case(this.parseCaseNetty(_loc3_.questCase));
               _loc2_.addCase(_loc4_);
            }
            else if(_loc3_.condition.id > 0)
            {
               _loc5_ = this.parseConditionNetty(_loc3_.condition);
               _loc2_.addCondition(_loc5_);
            }
            _loc6_++;
         }
         return _loc2_;
      }
      
      private function parseConditionNetty(param1:QuestConditionModule) : ICondition
      {
         var _loc11_:ICondition = null;
         ++this.condition_count;
         ++this.element_count;
         var _loc2_:int = param1.id;
         var _loc3_:int = param1.displayType;
         var _loc4_:Vector.<String> = param1.matches;
         var _loc5_:Number = param1.state.currentValue;
         var _loc6_:Number = param1.targetValue;
         var _loc7_:Boolean = param1.state.active;
         var _loc8_:Boolean = param1.mandatory;
         var _loc9_:Boolean = param1.state.completed;
         var _loc10_:ICondition = this.conditionFactory.createCondition(_loc3_,_loc2_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc4_);
         this.flat_conditions[_loc2_] = _loc10_;
         var _loc12_:int = 0;
         while(_loc12_ < param1.subConditions.length)
         {
            _loc11_ = this.parseConditionNetty(param1.subConditions[_loc12_]);
            _loc11_.runstate = _loc7_;
            _loc11_.completed = _loc9_;
            _loc10_.addCondition(_loc11_);
            _loc11_.markAsSubCondition();
            _loc12_++;
         }
         return _loc10_;
      }
   }
}

