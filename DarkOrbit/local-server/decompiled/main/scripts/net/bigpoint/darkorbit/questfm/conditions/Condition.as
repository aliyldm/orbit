package net.bigpoint.darkorbit.questfm.conditions
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.questfm.ICondition;
   
   public class Condition implements ICondition
   {
      
      protected var _id:uint;
      
      protected var _conditions:Array;
      
      protected var _runstate:Boolean;
      
      protected var _mandatory:Boolean;
      
      protected var _current:Number;
      
      protected var _target:Number = 0;
      
      protected var _target_plain:String = "";
      
      protected var _mandatory_count:uint;
      
      protected var _definition:ConditionTypeDefinition;
      
      protected var _visibility:int;
      
      protected var _completed:Boolean;
      
      protected var _description:String;
      
      protected var _children:Array = [];
      
      protected var _isSubCondition:Boolean;
      
      protected var _showLong:Boolean = true;
      
      protected var _helpIconData:BitmapData;
      
      protected var _validatable:Boolean;
      
      public function Condition()
      {
         super();
      }
      
      public function get validatable() : Boolean
      {
         return this._validatable;
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function set id(param1:uint) : void
      {
         this._id = param1;
      }
      
      public function get conditions() : Array
      {
         return this._conditions;
      }
      
      public function get runstate() : Boolean
      {
         return this._runstate;
      }
      
      public function set runstate(param1:Boolean) : void
      {
         if(this._runstate != param1)
         {
            this._runstate = param1;
         }
      }
      
      public function get mandatory() : Boolean
      {
         return this._mandatory;
      }
      
      public function set mandatory(param1:Boolean) : void
      {
         this._mandatory = param1;
      }
      
      public function set mandatory_count(param1:uint) : void
      {
         this._mandatory_count = param1;
      }
      
      public function get definition() : ConditionTypeDefinition
      {
         return this._definition;
      }
      
      public function set definition(param1:ConditionTypeDefinition) : void
      {
         this._definition = param1;
      }
      
      public function get description() : String
      {
         return this._description;
      }
      
      public function get targetVerbose() : String
      {
         return this._target_plain;
      }
      
      public function get currentVerbose() : String
      {
         return "";
      }
      
      public function get children() : Array
      {
         return this._children;
      }
      
      public function get completed() : Boolean
      {
         return this._completed;
      }
      
      public function set completed(param1:Boolean) : void
      {
         this._completed = param1;
      }
      
      public function get current() : Number
      {
         return this._current;
      }
      
      public function set current(param1:Number) : void
      {
         this._current = param1;
      }
      
      public function get showLong() : Boolean
      {
         return this._showLong;
      }
      
      public function set showLong(param1:Boolean) : void
      {
         this._showLong = param1;
      }
      
      public function get helpIconsClipCopy() : DisplayObject
      {
         return this._helpIconData ? new Bitmap(this._helpIconData) : null;
      }
      
      public function set target(param1:Number) : void
      {
         this._target = param1;
      }
      
      public function set questIsRunning(param1:Boolean) : void
      {
      }
      
      protected function get stdIconFinisher() : SWFFinisher
      {
         return ResourceManager.fileCollection.getFinisher("icons") as SWFFinisher;
      }
      
      public function init(param1:int, param2:Number, param3:Number, param4:Boolean, param5:Boolean, param6:Boolean, param7:Vector.<String>) : void
      {
         this.id = param1;
         this.current = param2;
         this.target = param3;
         this.runstate = param4;
         this.mandatory = param5;
         this.completed = param6;
         this._validatable = this.definition.VALIDATABLE;
         this._description = BPLocale.getItem("q2_condition_" + this._definition.TRANS_BASE_KEY);
         this.parseMatches(param7);
      }
      
      public function markAsSubCondition() : void
      {
         this._isSubCondition = true;
      }
      
      public function toString() : String
      {
         return this._definition.TRANS_BASE_KEY;
      }
      
      public function addConditionAt(param1:ICondition, param2:uint) : void
      {
         if(this._conditions == null)
         {
            this._conditions = [];
         }
         this._conditions[param2] = param1;
         this.addQuestChildElement(param1);
      }
      
      public function addCondition(param1:ICondition) : void
      {
         if(this._conditions == null)
         {
            this._conditions = [];
         }
         this.addConditionAt(param1,this._conditions.length);
      }
      
      public function updateCondtition(param1:int, param2:Number, param3:Boolean, param4:Boolean) : Boolean
      {
         var _loc5_:* = undefined;
         if(param1 == this._id)
         {
            this._current = param2;
            return true;
         }
         if(this._children.length > 0)
         {
            for(_loc5_ in this._children)
            {
               if(ICondition(_loc5_).updateCondtition(param1,param2,param3,param4))
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function toTextTree() : String
      {
         var _loc1_:String = this._description + "\n";
         var _loc2_:int = 0;
         while(_loc2_ < this._children.length)
         {
            if(this._children[_loc2_] != null)
            {
               _loc1_ += ICondition(this._children[_loc2_]).toTextTree();
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function isSubcondition() : Boolean
      {
         return this._isSubCondition;
      }
      
      protected function parseMatches(param1:Vector.<String>) : void
      {
      }
      
      protected function getBitmapDataByKey(param1:String) : BitmapData
      {
         if(this.stdIconFinisher.hasEmbeddedObject(param1))
         {
            return this.stdIconFinisher.getEmbeddedBitmapData(param1);
         }
         return null;
      }
      
      protected function addQuestChildElement(param1:ICondition) : void
      {
         this._children.push(param1);
      }
   }
}

