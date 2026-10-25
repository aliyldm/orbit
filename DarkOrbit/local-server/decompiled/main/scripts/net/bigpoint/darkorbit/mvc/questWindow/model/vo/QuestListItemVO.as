package net.bigpoint.darkorbit.mvc.questWindow.model.vo
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayList;
   import mx.events.PropertyChangeEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.QuestIconModule;
   import net.bigpoint.darkorbit.com.module.QuestTypeModule;
   import net.bigpoint.darkorbit.questfm.QuestLocale;
   import net.bigpoint.darkorbit.questfm.QuestType;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class QuestListItemVO implements IEventDispatcher
   {
      
      public const changed:ISignal = new Signal();
      
      private var _questPrio:int;
      
      private var _questID:int;
      
      private var _minLevel:int;
      
      private var _types:Vector.<QuestTypeModule>;
      
      private var _type:QuestType = new QuestType();
      
      private var _questTitle:String;
      
      private var _questListHTMLtitle:String;
      
      private var _questListHTMLaddon:String;
      
      private var _rootCaseID:int;
      
      private var _questMainTypeIcon:String;
      
      private var _questSubTypeList:Vector.<QuestIconModule>;
      
      private var _extraInfo:String;
      
      private var _questActive:Boolean = false;
      
      private var _selected:Boolean = false;
      
      private var _completed:Boolean = false;
      
      private var _acceptable:Boolean = false;
      
      private var _notAcceptableReasons:String = "";
      
      private var _ratings:ArrayList = null;
      
      private var _textKeyBase:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function QuestListItemVO(param1:String = null)
      {
         super();
         this._textKeyBase = param1;
      }
      
      public function get questMainTypeIcon() : String
      {
         return this._questMainTypeIcon;
      }
      
      private function set _777641390questMainTypeIcon(param1:String) : void
      {
         this._questMainTypeIcon = param1;
      }
      
      public function get questTitle() : String
      {
         if(this._questTitle == null)
         {
            this._questTitle = QuestLocale.getTitleEx(this.questID,this._textKeyBase,this.type);
         }
         return this._questTitle;
      }
      
      public function get questListHTMLtitle() : String
      {
         if(this._questListHTMLtitle == null)
         {
            this._questListHTMLtitle = QuestLocale.getTitleEx(this.questID,this._textKeyBase,this.type);
         }
         return this._questListHTMLtitle;
      }
      
      public function get questListHTMLaddon() : String
      {
         return this._questListHTMLaddon;
      }
      
      private function set _453127381questListHTMLaddon(param1:String) : void
      {
         this._questListHTMLaddon = param1;
      }
      
      public function get questSubTypeList() : Vector.<QuestIconModule>
      {
         return this._questSubTypeList;
      }
      
      private function set _369756394questSubTypeList(param1:Vector.<QuestIconModule>) : void
      {
         this._questSubTypeList = param1;
      }
      
      public function get rootCaseID() : int
      {
         return this._rootCaseID;
      }
      
      private function set _1925762099rootCaseID(param1:int) : void
      {
         this._rootCaseID = param1;
      }
      
      public function get questID() : int
      {
         return this._questID;
      }
      
      private function set _655126909questID(param1:int) : void
      {
         this._questID = param1;
      }
      
      public function get minLevel() : int
      {
         return this._minLevel;
      }
      
      private function set _1386076078minLevel(param1:int) : void
      {
         this._minLevel = param1;
      }
      
      public function get extraInfo() : String
      {
         return this._extraInfo;
      }
      
      private function set _253631266extraInfo(param1:String) : void
      {
         this._extraInfo = param1;
      }
      
      public function getQuestActive() : Boolean
      {
         return this._questActive;
      }
      
      public function setQuestActive(param1:Boolean) : void
      {
         var _loc2_:Boolean = false;
         if(param1)
         {
            this.questListHTMLaddon = "<font size=\"10\" color=\"#cccc99\">" + BPLocale.getItem("label_mission_in_progress") + "</font>";
         }
         else
         {
            this._questListHTMLtitle = this.questTitle;
            if(this.completed)
            {
               if(!this.type.hasQuestType(QuestTypeModule.QUESTTYPE_CHALLENGE))
               {
                  _loc2_ = true;
               }
               this.questListHTMLaddon = "<font size=\"10\">" + BPLocale.getItem("label_quest_completed") + "</font>";
            }
            else if(this.minLevel > Math.max(0,Hero.level) && !this.acceptable)
            {
               _loc2_ = true;
               this.questListHTMLaddon = "<font color=\"#a10000\" size=\"10\">" + BPLocale.getItem("label_quest_level_restriction").replace("%COUNT%",this.minLevel) + "</font>";
            }
            else if(!this.acceptable)
            {
               _loc2_ = true;
            }
            else
            {
               this.questListHTMLaddon = "";
            }
         }
         if(this.getSelected())
         {
            this._questListHTMLtitle = "<font color=\"#ffcc00\">" + this.questTitle + "</font>";
         }
         else if(_loc2_)
         {
            this._questListHTMLtitle = "<font color=\"#9b9b9b\">" + this.questTitle + "</font>";
         }
         else
         {
            this._questListHTMLtitle = "<font color=\"#ffffff\">" + this.questTitle + "</font>";
         }
         this._questActive = param1;
         this.changed.dispatch();
      }
      
      public function set types(param1:Vector.<QuestTypeModule>) : void
      {
         var _loc2_:QuestTypeModule = null;
         var _loc3_:Array = null;
         this._types = new Vector.<QuestTypeModule>();
         for each(_loc2_ in param1)
         {
            this._types.push(_loc2_);
         }
         this._type.init(this._types);
         _loc3_ = [10000,10001,10002];
         if(_loc3_.indexOf(this._questID) != -1)
         {
            this._type.setType(QuestType.CLIENT_QUEST_HONOUR);
         }
      }
      
      public function get type() : QuestType
      {
         return this._type;
      }
      
      public function getSelected() : Boolean
      {
         return this._selected;
      }
      
      public function setSelected(param1:Boolean) : void
      {
         this._selected = param1;
         this.setQuestActive(this.getQuestActive());
      }
      
      private function set _1402931637completed(param1:Boolean) : void
      {
         this._completed = param1;
         this.setQuestActive(this.getQuestActive());
      }
      
      public function get completed() : Boolean
      {
         return this._completed;
      }
      
      public function get acceptable() : Boolean
      {
         return this._acceptable;
      }
      
      private function set _1226602910acceptable(param1:Boolean) : void
      {
         this._acceptable = param1;
      }
      
      public function get notAcceptableReasons() : String
      {
         return this._notAcceptableReasons;
      }
      
      private function set _1247505242notAcceptableReasons(param1:String) : void
      {
         this._notAcceptableReasons = param1;
      }
      
      public function clone() : QuestListItemVO
      {
         var _loc2_:QuestIconModule = null;
         var _loc3_:Vector.<QuestTypeModule> = null;
         var _loc4_:QuestTypeModule = null;
         var _loc5_:HighscoreVO = null;
         var _loc1_:QuestListItemVO = new QuestListItemVO();
         _loc1_.acceptable = this.acceptable;
         _loc1_.completed = this.completed;
         _loc1_.extraInfo = this.extraInfo;
         _loc1_.minLevel = this.minLevel;
         _loc1_.notAcceptableReasons = this.notAcceptableReasons;
         _loc1_.setQuestActive(this.getQuestActive());
         _loc1_.questID = this.questID;
         _loc1_.questMainTypeIcon = this.questMainTypeIcon;
         _loc1_.questSubTypeList = new Vector.<QuestIconModule>();
         for each(_loc2_ in this.questSubTypeList)
         {
            _loc1_.questSubTypeList.push(_loc2_);
         }
         _loc1_.questListHTMLaddon = this.questListHTMLaddon;
         _loc1_.rootCaseID = this.rootCaseID;
         _loc1_.setSelected(this.getSelected());
         _loc3_ = new Vector.<QuestTypeModule>();
         for each(_loc4_ in this._types)
         {
            _loc3_.push(_loc4_);
         }
         _loc1_.types = _loc3_;
         _loc1_.ratings = new ArrayList();
         for each(_loc5_ in this.ratings.source)
         {
            _loc1_.ratings.addItem(_loc5_);
         }
         _loc1_.questPrio = this._questPrio;
         return _loc1_;
      }
      
      public function get ratings() : ArrayList
      {
         return this._ratings;
      }
      
      private function set _983597686ratings(param1:ArrayList) : void
      {
         this._ratings = param1;
      }
      
      public function get questPrio() : int
      {
         return this._questPrio;
      }
      
      private function set _1782976854questPrio(param1:int) : void
      {
         this._questPrio = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function set acceptable(param1:Boolean) : void
      {
         var _loc2_:Object = this.acceptable;
         if(_loc2_ !== param1)
         {
            this._1226602910acceptable = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"acceptable",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set notAcceptableReasons(param1:String) : void
      {
         var _loc2_:Object = this.notAcceptableReasons;
         if(_loc2_ !== param1)
         {
            this._1247505242notAcceptableReasons = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"notAcceptableReasons",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set questSubTypeList(param1:Vector.<QuestIconModule>) : void
      {
         var _loc2_:Object = this.questSubTypeList;
         if(_loc2_ !== param1)
         {
            this._369756394questSubTypeList = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"questSubTypeList",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set completed(param1:Boolean) : void
      {
         var _loc2_:Object = this.completed;
         if(_loc2_ !== param1)
         {
            this._1402931637completed = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"completed",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set minLevel(param1:int) : void
      {
         var _loc2_:Object = this.minLevel;
         if(_loc2_ !== param1)
         {
            this._1386076078minLevel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"minLevel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set questID(param1:int) : void
      {
         var _loc2_:Object = this.questID;
         if(_loc2_ !== param1)
         {
            this._655126909questID = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"questID",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set questPrio(param1:int) : void
      {
         var _loc2_:Object = this.questPrio;
         if(_loc2_ !== param1)
         {
            this._1782976854questPrio = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"questPrio",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set ratings(param1:ArrayList) : void
      {
         var _loc2_:Object = this.ratings;
         if(_loc2_ !== param1)
         {
            this._983597686ratings = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ratings",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set questMainTypeIcon(param1:String) : void
      {
         var _loc2_:Object = this.questMainTypeIcon;
         if(_loc2_ !== param1)
         {
            this._777641390questMainTypeIcon = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"questMainTypeIcon",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set questListHTMLaddon(param1:String) : void
      {
         var _loc2_:Object = this.questListHTMLaddon;
         if(_loc2_ !== param1)
         {
            this._453127381questListHTMLaddon = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"questListHTMLaddon",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set rootCaseID(param1:int) : void
      {
         var _loc2_:Object = this.rootCaseID;
         if(_loc2_ !== param1)
         {
            this._1925762099rootCaseID = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rootCaseID",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set extraInfo(param1:String) : void
      {
         var _loc2_:Object = this.extraInfo;
         if(_loc2_ !== param1)
         {
            this._253631266extraInfo = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"extraInfo",_loc2_,param1));
            }
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
   }
}

