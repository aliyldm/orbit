package net.bigpoint.darkorbit.net
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.effects.EffectManager;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.net.models.skills.AbilityNames;
   
   public class SkillsAssembly extends BaseAssembly
   {
      
      private static var instance:SkillsAssembly;
      
      private var delegateDict:Dictionary;
      
      public function SkillsAssembly(param1:Function)
      {
         super();
         if(param1 !== hidden)
         {
            throw new Error("SkillsAssembly is a Singleton and can only be accessed through SkillsAssembly.getInstance()");
         }
         this.initDelegateDict();
      }
      
      public static function getInstance() : SkillsAssembly
      {
         if(instance == null)
         {
            instance = new SkillsAssembly(hidden);
         }
         return instance;
      }
      
      private static function hidden() : void
      {
      }
      
      private function initDelegateDict() : void
      {
         this.delegateDict = new Dictionary();
         this.delegateDict[ServerCommands.SKILLS_ACTIVATE] = this.assembleActivateCommand;
         this.delegateDict[ServerCommands.SKILLS_DEACTIVATE] = this.assembleDeactivateCommand;
         this.delegateDict[ServerCommands.REMOVE_SKILL_FX] = this.assembleRemoveCommand;
      }
      
      public function assembleSubCommand(param1:Array) : void
      {
         var _loc2_:String = param1[3];
         if(this.delegateDict[_loc2_] != null)
         {
            this.delegateDict[_loc2_](param1);
         }
      }
      
      public function assembleCommand(param1:Array) : void
      {
         var _loc2_:String = param1[2];
         if(this.delegateDict[_loc2_] != null)
         {
            this.delegateDict[_loc2_](param1);
         }
      }
      
      private function assembleRemoveCommand(param1:Array) : void
      {
         var _loc2_:int = int(param1[4]);
         var _loc3_:int = int(param1[3]);
         ScreenManager.getInstance().map.effects.removeEffectFromMapObject(_loc2_,AbilityNames.getEffectIDByCode(_loc3_));
      }
      
      private function assembleActivateCommand(param1:Array) : void
      {
         var _loc8_:Ship = null;
         var _loc9_:Array = null;
         var _loc10_:int = 0;
         var _loc2_:int = int(param1[4]);
         var _loc3_:int = int(param1[5]);
         var _loc4_:int = int(param1[6]);
         var _loc5_:Boolean = param1.length > 7;
         var _loc6_:Class = AbilityNames.getEffectClassByName(_loc2_);
         var _loc7_:Ship = ScreenManager.getInstance().map.getShipManager().getShip(_loc4_);
         if(_loc7_ != null)
         {
            ScreenManager.getInstance().map.effects.addMapObjectEffectOnce(new _loc6_(_loc7_,_loc3_));
         }
         if(_loc5_)
         {
            _loc9_ = param1.splice(7,param1.length);
            _loc10_ = 0;
            while(_loc10_ < _loc9_.length)
            {
               _loc8_ = ScreenManager.getInstance().map.getShipManager().getShip(int(_loc9_[_loc10_]));
               if(_loc8_ != null)
               {
                  ScreenManager.getInstance().map.effects.addMapObjectEffectOnce(new _loc6_(_loc8_,_loc3_));
               }
               _loc10_++;
            }
         }
      }
      
      private function assembleDeactivateCommand(param1:Array) : void
      {
         var _loc9_:Array = null;
         var _loc10_:int = 0;
         var _loc2_:int = int(param1[4]);
         var _loc3_:int = int(param1[5]);
         var _loc4_:Boolean = param1.length > 5;
         var _loc5_:Boolean = false;
         if(_loc3_ == Hero.userID)
         {
            _loc5_ = true;
         }
         var _loc6_:Ship = ScreenManager.getInstance().map.getShipManager().getShip(_loc3_);
         var _loc7_:int = AbilityNames.getEffectIDByCode(_loc2_);
         var _loc8_:EffectManager = ScreenManager.getInstance().map.effects;
         if(_loc6_ != null)
         {
            _loc8_.removeEffectFromMapObject(_loc3_,_loc7_);
         }
         if(_loc4_)
         {
            _loc9_ = param1.splice(6,param1.length);
            _loc10_ = 0;
            while(_loc10_ < _loc9_.length)
            {
               _loc8_.removeEffectFromMapObject(_loc9_[_loc10_],_loc7_);
               _loc10_++;
            }
         }
      }
   }
}

