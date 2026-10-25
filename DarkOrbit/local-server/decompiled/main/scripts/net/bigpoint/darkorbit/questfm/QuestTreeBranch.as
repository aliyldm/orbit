package net.bigpoint.darkorbit.questfm
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class QuestTreeBranch
   {
      
      private var _questBaseObject:IQuestBaseObject;
      
      private var _uiClip:IQuestTreeUIClip;
      
      private var _descriptionClip:MovieClip;
      
      private var _descriptionLabel:TextField;
      
      private var _iconsClip:DisplayObject;
      
      private var _valuesClip:MovieClip;
      
      private var _valuesLabel:TextField;
      
      private var _branches:Array = [];
      
      private var _type:int;
      
      private var _visible:Boolean;
      
      private var _expanded:Boolean;
      
      private var _runstate:Boolean;
      
      private var _completed:Boolean;
      
      public function QuestTreeBranch(param1:int)
      {
         super();
         if(param1 == QuestTreeBranchType.CASE)
         {
            this._type = QuestTreeBranchType.CASE;
         }
         else
         {
            this._type = QuestTreeBranchType.CONDITION;
         }
      }
      
      public function addBranch(param1:QuestTreeBranch) : void
      {
         this._branches.push(param1);
      }
      
      public function setUi(param1:MovieClip, param2:IQuestTreeUIClip, param3:MovieClip = null, param4:DisplayObject = null) : void
      {
         var _loc5_:TextFormat = null;
         this._descriptionClip = param1;
         this._descriptionLabel = TextField(this._descriptionClip.getChildByName("txtLabel"));
         this._uiClip = param2;
         this._valuesClip = param3;
         this._iconsClip = param4;
         if(this._valuesClip != null)
         {
            this._valuesLabel = TextField(this._valuesClip.getChildByName("txtLabel"));
            this._valuesLabel.multiline = this._valuesLabel.wordWrap = true;
            _loc5_ = this._valuesLabel.defaultTextFormat;
            _loc5_.align = TextFormatAlign.LEFT;
            this._valuesLabel.defaultTextFormat = _loc5_;
            this._valuesClip.x = 100;
         }
         this._visible = true;
         this._expanded = true;
      }
      
      public function set questBaseObject(param1:IQuestBaseObject) : void
      {
         this._questBaseObject = param1;
      }
      
      public function get uiClip() : IQuestTreeUIClip
      {
         return this._uiClip;
      }
      
      public function get descriptionClip() : MovieClip
      {
         return this._descriptionClip;
      }
      
      public function get valuesClip() : MovieClip
      {
         return this._valuesClip;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function get questBaseObject() : IQuestBaseObject
      {
         return this._questBaseObject;
      }
      
      public function get descriptionLabel() : TextField
      {
         return this._descriptionLabel;
      }
      
      public function get valuesLabel() : TextField
      {
         return this._valuesLabel;
      }
      
      public function get visible() : Boolean
      {
         return this._visible;
      }
      
      public function set visible(param1:Boolean) : void
      {
         this._visible = param1;
         if(this._descriptionClip != null)
         {
            this._descriptionClip.visible = this._visible;
         }
         if(this._uiClip != null)
         {
            this._uiClip.visible = this._visible;
         }
         if(this._valuesClip != null)
         {
            this._valuesClip.visible = this._visible;
         }
         if(this._iconsClip != null)
         {
            this._iconsClip.visible = this._visible;
         }
      }
      
      public function get expanded() : Boolean
      {
         return this._expanded;
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
      
      public function set expanded(param1:Boolean) : void
      {
         this._expanded = param1;
      }
      
      public function get completed() : Boolean
      {
         return this._completed;
      }
      
      public function set completed(param1:Boolean) : void
      {
         this._completed = param1;
      }
      
      public function get iconsClip() : DisplayObject
      {
         return this._iconsClip;
      }
      
      public function updateLayout() : void
      {
         if(this._iconsClip)
         {
            this._iconsClip.x = QuestTreeComponent.HELPICON_X - QuestTreeComponent.ICON_GAP;
            this.descriptionLabel.width = this._iconsClip.x - this.descriptionClip.x - QuestTreeComponent.DESCRIPTION_LABLE_GAP;
         }
         else
         {
            this.descriptionLabel.width = this.valuesClip.x - this.valuesLabel.width - this.descriptionClip.x - this.descriptionLabel.x - QuestTreeComponent.DESCRIPTION_LABLE_GAP;
         }
      }
   }
}

