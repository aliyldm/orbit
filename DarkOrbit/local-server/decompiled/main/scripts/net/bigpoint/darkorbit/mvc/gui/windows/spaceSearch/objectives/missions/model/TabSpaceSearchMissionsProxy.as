package net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.objectives.missions.model
{
   import com.bigpoint.utils.TimeFormatter;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.QuestDefinitionModule;
   import net.bigpoint.darkorbit.com.module.porting.SpaceSearch.SpaceSearchMissionListCommand;
   import net.bigpoint.darkorbit.com.module.porting.activityevent.EventQuestDefinitionModule;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   import net.bigpoint.darkorbit.questfm.Quest;
   import net.bigpoint.darkorbit.questfm.QuestParser;
   import net.bigpoint.darkorbit.questfm.conditions.Condition;
   import org.puremvc.as3.multicore.interfaces.IFacade;
   
   public class TabSpaceSearchMissionsProxy extends SimpleWindowProxy
   {
      
      public function TabSpaceSearchMissionsProxy(param1:String)
      {
         super(param1,new TabSpaceSearchMissionsData());
      }
      
      public static function getOrCreateProxy(param1:IFacade) : TabSpaceSearchMissionsProxy
      {
         var _loc2_:TabSpaceSearchMissionsProxy = param1.retrieveProxy(GuiConstants.SPACE_SEARCH_OBJECTIVES_MISSIONS) as TabSpaceSearchMissionsProxy;
         if(!_loc2_)
         {
            _loc2_ = new TabSpaceSearchMissionsProxy(GuiConstants.SPACE_SEARCH_OBJECTIVES_MISSIONS);
            param1.registerProxy(_loc2_);
         }
         return _loc2_;
      }
      
      public function get viewData() : TabSpaceSearchMissionsData
      {
         return this.data as TabSpaceSearchMissionsData;
      }
      
      public function updateQuestConditionCurrStr(param1:Quest, param2:int, param3:int, param4:Boolean) : String
      {
         var _loc7_:net.bigpoint.darkorbit.questfm.conditions.Condition = null;
         var _loc8_:String = null;
         var _loc9_:int = 0;
         var _loc10_:net.bigpoint.darkorbit.questfm.conditions.Condition = null;
         var _loc11_:String = null;
         var _loc12_:RegExp = null;
         var _loc5_:String = "";
         var _loc6_:int = 0;
         while(_loc6_ < param1.getCase().conditions.length)
         {
            _loc7_ = net.bigpoint.darkorbit.questfm.conditions.Condition(param1.getCase().conditions[_loc6_]);
            _loc8_ = _loc7_.description;
            _loc5_ += _loc8_ + "\n";
            if(_loc7_.conditions)
            {
               _loc9_ = 0;
               while(_loc9_ < _loc7_.conditions.length)
               {
                  _loc10_ = _loc7_.conditions[_loc9_];
                  _loc8_ = _loc10_.description;
                  _loc5_ += "  - " + _loc8_ + "\n";
                  _loc9_++;
               }
            }
            if(!param4)
            {
               _loc11_ = (_loc7_.id == param2 ? param3 : _loc7_.currentVerbose) + _loc7_.targetVerbose;
               _loc12_ = /^[0-9]+$/;
               if(Boolean(_loc11_) && Boolean(_loc11_.length > 0) && _loc12_.test(_loc11_))
               {
                  _loc5_ += TimeFormatter.getSmartFormatedTime(int(int(_loc11_) / 1000));
               }
               else
               {
                  _loc5_ += "(" + _loc11_ + ")\n";
               }
            }
            _loc6_++;
         }
         if(param4)
         {
            _loc5_ += BPLocale.getItem("q2_condition_CASE_parallel");
         }
         return _loc5_;
      }
      
      public function questConditionStr(param1:Quest, param2:Boolean, param3:Boolean = false) : String
      {
         var _loc6_:net.bigpoint.darkorbit.questfm.conditions.Condition = null;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:net.bigpoint.darkorbit.questfm.conditions.Condition = null;
         var _loc4_:String = "";
         var _loc5_:int = 0;
         while(_loc5_ < param1.getCase().conditions.length)
         {
            _loc6_ = net.bigpoint.darkorbit.questfm.conditions.Condition(param1.getCase().conditions[_loc5_]);
            _loc7_ = _loc6_.description;
            _loc4_ += (param3 ? "• " : "") + _loc7_ + "\n";
            if(_loc6_.conditions)
            {
               _loc8_ = 0;
               while(_loc8_ < _loc6_.conditions.length)
               {
                  _loc9_ = _loc6_.conditions[_loc8_];
                  _loc7_ = _loc9_.description;
                  _loc4_ += "  - " + _loc7_ + "\n";
                  _loc8_++;
               }
            }
            if(!param2)
            {
               _loc4_ += "(" + _loc6_.currentVerbose + _loc6_.targetVerbose + ")\n";
            }
            _loc5_++;
         }
         if(param2)
         {
            _loc4_ += BPLocale.getItem("q2_condition_CASE_parallel");
         }
         return _loc4_;
      }
      
      public function updateDataByConditionId(param1:int, param2:int, param3:Boolean) : void
      {
         var _loc5_:TabSpaceSearchMissionsListVO = null;
         var _loc4_:* = 0;
         while(_loc4_ < this.viewData._list.length)
         {
            _loc5_ = this.viewData._list[_loc4_];
            if(_loc5_.quest.flatConditions[param1] != null)
            {
               _loc5_.description = this.updateQuestConditionCurrStr(_loc5_.quest,param1,param2,param3);
               _loc5_.completed = param3;
               this.viewData.changed.dispatch();
               break;
            }
            _loc4_++;
         }
      }
      
      public function completedQuest(param1:int) : void
      {
         var _loc3_:TabSpaceSearchMissionsListVO = null;
         var _loc2_:* = 0;
         while(_loc2_ < this.viewData._list.length)
         {
            _loc3_ = this.viewData._list[_loc2_];
            if(_loc3_.quest.id == param1)
            {
               _loc3_.description = this.updateQuestConditionCurrStr(_loc3_.quest,0,0,true);
               _loc3_.completed = true;
               this.viewData.changed.dispatch();
               break;
            }
            _loc2_++;
         }
      }
      
      public function updateData(param1:SpaceSearchMissionListCommand) : void
      {
         var _loc5_:EventQuestDefinitionModule = null;
         var _loc6_:QuestDefinitionModule = null;
         var _loc7_:Quest = null;
         var _loc8_:TabSpaceSearchMissionsListVO = null;
         var _loc2_:QuestParser = QuestParser.instance;
         var _loc3_:Vector.<TabSpaceSearchMissionsListVO> = new Vector.<TabSpaceSearchMissionsListVO>();
         var _loc4_:* = 0;
         while(_loc4_ < param1.missions.length)
         {
            _loc5_ = param1.missions[_loc4_];
            _loc6_ = _loc5_.module;
            _loc7_ = _loc2_.parseDefinition(_loc6_);
            _loc8_ = new TabSpaceSearchMissionsListVO();
            _loc8_.description = this.questConditionStr(_loc7_,_loc5_.completed);
            _loc8_.completed = _loc5_.completed;
            _loc8_.quest = _loc7_;
            _loc3_.push(_loc8_);
            _loc4_++;
         }
         this.viewData.updateData(_loc3_);
      }
   }
}

