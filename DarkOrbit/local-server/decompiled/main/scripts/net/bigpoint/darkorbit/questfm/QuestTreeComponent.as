package net.bigpoint.darkorbit.questfm
{
   import com.bigpoint.utils.TextFormatter;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   
   public class QuestTreeComponent extends Sprite
   {
      
      public static const ICON_GAP:int = 15;
      
      public static const HELPICON_X:int = 250;
      
      public static const DESCRIPTION_LABLE_GAP:int = 15;
      
      public static const SIZE_CHANGED:String = "sizeChanged";
      
      private static const MAX_TARGET_CHARS:int = 9;
      
      public var quest:Quest;
      
      private var headlineLabel:TextField;
      
      private var contentRoot:MovieClip;
      
      private var runningBranchColor:uint;
      
      private var accomplishedBranchColor:uint;
      
      private var upcomingBranchColor:uint;
      
      private var branchOffset:int;
      
      private var elementDepthOffset:int;
      
      private var conditionBranches:Array = [];
      
      private var caseBranches:Array = [];
      
      private var allBranches:Array = [];
      
      private var branchesValues:Array = [];
      
      private var branchOffsetStart:Number;
      
      private var defaultInfoClip:MovieClip;
      
      private var defaultInfoClickArea:Sprite;
      
      private var questAssetsLib:SWFFinisher;
      
      private var iconsLib:SWFFinisher;
      
      public function QuestTreeComponent()
      {
         super();
         this.initFormat();
         this.initDefault();
         this.questAssetsLib = SWFFinisher(ResourceManager.fileCollection.getFinisher("questSystem"));
         this.iconsLib = SWFFinisher(ResourceManager.fileCollection.getFinisher("icons"));
      }
      
      private function initDefault() : void
      {
         var _loc1_:TextFormat = null;
         var _loc2_:TextField = null;
         var _loc3_:TextField = null;
         this.defaultInfoClip = new MovieClip();
         _loc1_ = new TextFormat(Styles.strongStdFmt.font,Styles.strongStdFmt.size,15327936);
         _loc2_ = new TextField();
         _loc2_.defaultTextFormat = _loc1_;
         _loc2_.embedFonts = Styles.strongStdEmbed;
         _loc2_.antiAliasType = AntiAliasType.ADVANCED;
         _loc2_.mouseEnabled = true;
         _loc2_.selectable = false;
         _loc2_.multiline = true;
         _loc2_.wordWrap = true;
         _loc2_.autoSize = TextFieldAutoSize.LEFT;
         _loc2_.width = 164;
         _loc2_.x = 8;
         _loc2_.y = 8;
         _loc2_.text = BPLocale.getItem("msg_no_quest_running");
         this.defaultInfoClip.addChild(_loc2_);
         _loc3_ = new TextField();
         _loc3_.defaultTextFormat = _loc1_;
         _loc3_.embedFonts = Styles.strongStdEmbed;
         _loc3_.antiAliasType = AntiAliasType.ADVANCED;
         _loc3_.mouseEnabled = false;
         _loc3_.selectable = false;
         _loc3_.multiline = true;
         _loc3_.wordWrap = true;
         _loc3_.autoSize = TextFieldAutoSize.LEFT;
         _loc3_.width = _loc2_.width;
         _loc3_.x = _loc2_.x;
         _loc3_.y = _loc2_.y + _loc2_.height + 8;
         _loc3_.text = BPLocale.getItem("msg_maybe_quest_at_nyx");
         this.defaultInfoClip.addChild(_loc3_);
      }
      
      public function set isDefaultVisible(param1:Boolean) : void
      {
         if(param1 && !contains(this.defaultInfoClip))
         {
            addChild(this.defaultInfoClip);
            dispatchEvent(new Event(SIZE_CHANGED,true));
         }
         else if(!param1 && contains(this.defaultInfoClip))
         {
            removeChild(this.defaultInfoClip);
         }
      }
      
      public function get isDefaultVisible() : Boolean
      {
         return contains(this.defaultInfoClip);
      }
      
      public function get isHonourQuestVisible() : Boolean
      {
         return this.quest.type.hasQuestType(QuestType.CLIENT_QUEST_HONOUR);
      }
      
      public function showDefaultText(param1:String) : void
      {
         this.initHeadLine();
         this.headlineLabel.text = param1;
      }
      
      public function updateQuestTitle() : void
      {
         var _loc1_:Boolean = false;
         if(this.contentRoot.contains(this.headlineLabel))
         {
            _loc1_ = TextFormatter.distillAndWrite(this.quest.title,this.headlineLabel);
            if(_loc1_)
            {
               TooltipControl.getInstance().addToolTip(this.headlineLabel,this.quest.title);
            }
         }
      }
      
      public function clearContent() : void
      {
         if(this.contentRoot != null)
         {
            if(contains(this.contentRoot))
            {
               removeChild(this.contentRoot);
            }
         }
         this.conditionBranches = [];
         this.caseBranches = [];
         this.allBranches = [];
         this.branchOffsetStart = 4;
         this.elementDepthOffset = 4;
         this.contentRoot = new MovieClip();
         addChild(this.contentRoot);
      }
      
      public function updateCondition(param1:int, param2:Boolean) : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc6_:ICondition = null;
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         var _loc9_:ICondition = null;
         var _loc5_:QuestTreeBranch = QuestTreeBranch(this.conditionBranches[param1]);
         if(_loc5_)
         {
            _loc6_ = ICondition(_loc5_.questBaseObject);
            _loc3_ = _loc6_.currentVerbose + _loc6_.targetVerbose;
            _loc4_ = _loc3_.length;
            if(_loc4_ > MAX_TARGET_CHARS)
            {
               _loc7_ = true;
               _loc3_ = _loc3_.replace("/","/\n");
            }
            _loc5_.valuesLabel.text = _loc3_;
            _loc5_.updateLayout();
            if(_loc6_.runstate != _loc5_.runstate || _loc6_.completed != _loc5_.completed || param2)
            {
               _loc7_ = true;
               if(_loc6_.runstate)
               {
                  _loc5_.uiClip.state = QuestTreeUIClip.RUNNING;
                  _loc5_.descriptionLabel.textColor = this.runningBranchColor;
               }
               else
               {
                  if(_loc6_.completed)
                  {
                     _loc5_.uiClip.state = QuestTreeUIClip.COMPLETED;
                     _loc5_.descriptionLabel.textColor = this.accomplishedBranchColor;
                  }
                  else
                  {
                     _loc5_.uiClip.state = QuestTreeUIClip.UPCOMING;
                     _loc5_.descriptionLabel.textColor = this.upcomingBranchColor;
                  }
                  _loc5_.completed = _loc6_.completed;
               }
               _loc5_.valuesLabel.textColor = _loc5_.descriptionLabel.textColor;
               _loc3_ = _loc6_.currentVerbose + _loc6_.targetVerbose;
               _loc4_ = _loc3_.length;
               if(_loc4_ > MAX_TARGET_CHARS)
               {
                  _loc7_ = true;
                  _loc3_ = _loc3_.replace("/","/\n");
               }
               _loc5_.valuesLabel.text = _loc3_;
               _loc5_.descriptionLabel.text = _loc6_.description;
               if(_loc6_.children.length > 0)
               {
                  _loc8_ = 0;
                  while(_loc8_ < _loc6_.children.length)
                  {
                     _loc9_ = ICondition(_loc6_.children[_loc8_]);
                     this.updateCondition(_loc9_.id,param2);
                     _loc8_++;
                  }
               }
            }
         }
         if(_loc7_)
         {
            this.updateBranches();
         }
      }
      
      public function setSize(param1:int, param2:int) : void
      {
      }
      
      private function initFormat() : void
      {
         this.runningBranchColor = 15327936;
         this.accomplishedBranchColor = 8969608;
         this.upcomingBranchColor = 12169872;
      }
      
      public function update(param1:Boolean = true) : void
      {
         this.clearContent();
         if(param1)
         {
            this.initHeadLine();
         }
         this.branchOffsetStart += this.headlineLabel ? this.headlineLabel.height : 0 + 3;
         this.branchOffset = this.branchOffsetStart;
         this.createQuestBranchFromCase(this.quest.getCase(),0,true);
         this.isDefaultVisible = false;
      }
      
      private function initHeadLine() : void
      {
         var _loc1_:TextFormat = new TextFormat(Styles.strongStdFmt.font,Styles.strongStdFmt.size,15327936);
         this.headlineLabel = new TextField();
         this.headlineLabel.defaultTextFormat = _loc1_;
         this.headlineLabel.embedFonts = Styles.strongStdEmbed;
         this.headlineLabel.antiAliasType = AntiAliasType.ADVANCED;
         this.headlineLabel.mouseEnabled = true;
         this.headlineLabel.selectable = false;
         this.headlineLabel.width = 200;
         this.contentRoot.addChild(this.headlineLabel);
         if(this.quest.title == "")
         {
            this.headlineLabel.text = "";
         }
         else
         {
            this.updateQuestTitle();
         }
         this.headlineLabel.height = 18;
         this.headlineLabel.y = this.branchOffsetStart;
      }
      
      private function createQuestBranchFromCase(param1:Case, param2:int, param3:Boolean = false, param4:Boolean = false) : QuestTreeBranch
      {
         var _loc8_:MovieClip = null;
         var _loc9_:IQuestTreeUIClip = null;
         var _loc10_:DisplayObject = null;
         var _loc11_:TextField = null;
         var _loc12_:int = 0;
         var _loc13_:QuestTreeBranch = null;
         var _loc5_:QuestTreeBranch = new QuestTreeBranch(QuestTreeBranchType.CASE);
         _loc5_.completed = param1.completed;
         _loc5_.runstate = param1.active;
         var _loc6_:int = 0;
         var _loc7_:String = "";
         if(param1.ordered)
         {
            _loc6_ = 4;
            _loc8_ = this.getQuestUiTextFieldElement();
            _loc9_ = this.getQuestTreeToggleButton(QuestTreeBranchType.CASE);
            _loc9_.id = param1.id;
            _loc5_.setUi(_loc8_,_loc9_);
            _loc5_.questBaseObject = param1;
            _loc5_.expanded = param1.showLong;
            this.contentRoot.addChild(_loc8_);
            _loc10_ = _loc9_ as DisplayObject;
            _loc8_.x = param2;
            _loc8_.y = this.branchOffset;
            if(_loc10_)
            {
               this.contentRoot.addChild(_loc10_);
               _loc10_.x = _loc8_.x;
               _loc10_.y = _loc8_.y + 4;
            }
            _loc9_.selected = !param1.showLong;
            _loc11_ = TextField(_loc8_.getChildByName("txtLabel"));
            _loc11_.x = 11;
            _loc11_.autoSize = TextFieldAutoSize.LEFT;
            _loc11_.multiline = true;
            _loc11_.width = 128;
            _loc11_.antiAliasType = AntiAliasType.ADVANCED;
            _loc11_.mouseEnabled = false;
            _loc11_.selectable = false;
            if(param1.active)
            {
               _loc9_.state = QuestTreeUIClip.RUNNING;
               _loc11_.textColor = this.runningBranchColor;
            }
            else
            {
               _loc9_.state = QuestTreeUIClip.UPCOMING;
               if(param1.completed)
               {
                  _loc9_.state = QuestTreeUIClip.COMPLETED;
                  _loc11_.textColor = this.accomplishedBranchColor;
               }
               else
               {
                  _loc9_.state = QuestTreeUIClip.UPCOMING;
                  _loc11_.textColor = this.upcomingBranchColor;
               }
            }
            _loc11_.text = BPLocale.getItem("q2_condition_CASE_sequence");
            this.branchOffset += _loc8_.height;
            this.caseBranches[param1.id] = _loc5_;
            this.allBranches.push(_loc5_);
         }
         else if(!(!param4 && param1.mandatory_child_count == param1.mandatory_count))
         {
            _loc6_ = 4;
            _loc8_ = this.getQuestUiTextFieldElement();
            _loc9_ = this.getQuestTreeToggleButton(QuestTreeBranchType.CASE);
            _loc9_.id = param1.id;
            _loc5_.setUi(_loc8_,_loc9_);
            _loc5_.questBaseObject = param1;
            _loc5_.expanded = param1.showLong;
            this.caseBranches[param1.id] = _loc5_;
            this.allBranches.push(_loc5_);
            this.contentRoot.addChild(_loc8_);
            _loc8_.x = param2;
            _loc8_.y = this.branchOffset;
            _loc10_ = _loc9_ as DisplayObject;
            if(_loc10_)
            {
               this.contentRoot.addChild(_loc10_);
               _loc10_.x = _loc8_.x;
               _loc10_.y = _loc8_.y + 4;
            }
            _loc9_.selected = !param1.showLong;
            _loc11_ = TextField(_loc8_.getChildByName("txtLabel"));
            _loc11_.x = 11;
            _loc11_.autoSize = TextFieldAutoSize.LEFT;
            _loc11_.multiline = true;
            _loc11_.width = 128;
            _loc11_.antiAliasType = AntiAliasType.ADVANCED;
            _loc11_.mouseEnabled = false;
            _loc11_.selectable = false;
            if(param1.active)
            {
               _loc9_.state = QuestTreeUIClip.RUNNING;
               _loc11_.textColor = this.runningBranchColor;
            }
            else
            {
               _loc9_.state = QuestTreeUIClip.UPCOMING;
               if(param1.completed)
               {
                  _loc9_.state = QuestTreeUIClip.COMPLETED;
                  _loc11_.textColor = this.accomplishedBranchColor;
               }
               else
               {
                  _loc9_.state = QuestTreeUIClip.UPCOMING;
                  _loc11_.textColor = this.upcomingBranchColor;
               }
            }
            _loc7_ = BPLocale.getItem("q2_condition_CASE_mandatory");
            _loc7_ = _loc7_.replace(/%count%/,param1.mandatory_count);
            _loc11_.text = _loc7_;
            this.branchOffset += _loc8_.height;
         }
         _loc5_.visible = param3;
         if(param3 && !param1.showLong)
         {
            param3 = false;
         }
         if(param1.children.length > 0)
         {
            _loc12_ = 0;
            while(_loc12_ < param1.children.length)
            {
               if(param1.children[_loc12_] is ICase)
               {
                  _loc13_ = this.createQuestBranchFromCase(param1.children[_loc12_],param2 + _loc6_,param3,param1.mandatory_child_count != param1.mandatory_count);
               }
               else
               {
                  _loc13_ = this.createQuestBranchFromCondition(param1.children[_loc12_],param2 + _loc6_,_loc12_ + 1);
                  this.displayCondition(_loc13_,param3);
               }
               if(!param1.showLong || !param3)
               {
                  this.branchOffset -= _loc13_.descriptionClip.height;
               }
               _loc12_++;
            }
            if(_loc10_)
            {
               _loc10_.addEventListener(MouseEvent.CLICK,this.toggleCaseBranch);
            }
         }
         return _loc5_;
      }
      
      private function getEmptyQuestTreeToggleButton() : IQuestTreeUIClip
      {
         return new EmptyQuestTreeToggleButton();
      }
      
      private function createQuestBranchFromCondition(param1:ICondition, param2:int, param3:int) : QuestTreeBranch
      {
         var _loc5_:IQuestTreeUIClip = null;
         var _loc13_:int = 0;
         var _loc14_:QuestTreeBranch = null;
         var _loc4_:MovieClip = this.getQuestUiTextFieldElement();
         if(param1.children.length > 0)
         {
            _loc5_ = this.getQuestTreeToggleButton(QuestTreeBranchType.CONDITION);
            _loc5_.id = param1.id;
            _loc5_.selected = !param1.showLong;
         }
         else
         {
            _loc5_ = this.getConditionIcon(param1);
            _loc5_.number = param3;
         }
         var _loc6_:MovieClip = this.getQuestUiTextFieldElement();
         var _loc7_:DisplayObject = param1.helpIconsClipCopy;
         var _loc8_:QuestTreeBranch = new QuestTreeBranch(QuestTreeBranchType.CONDITION);
         _loc8_.setUi(_loc4_,_loc5_,_loc6_,_loc7_);
         _loc8_.questBaseObject = param1;
         _loc8_.expanded = param1.showLong;
         _loc8_.completed = param1.completed;
         _loc8_.runstate = param1.runstate;
         this.conditionBranches[param1.id] = _loc8_;
         this.allBranches.push(_loc8_);
         this.contentRoot.addChild(_loc4_);
         if(_loc5_ is DisplayObject)
         {
            this.contentRoot.addChild(_loc5_ as DisplayObject);
         }
         this.branchesValues[param1.id] = _loc6_;
         this.contentRoot.addChild(_loc6_);
         _loc4_.x = param2;
         _loc4_.y = this.branchOffset;
         DisplayObject(_loc5_).x = _loc4_.x;
         DisplayObject(_loc5_).y = _loc4_.y + 4;
         _loc6_.x = 380;
         _loc6_.y = _loc4_.y;
         var _loc9_:TextField = TextField(_loc4_.getChildByName("txtLabel"));
         _loc9_.x = 11;
         _loc9_.wordWrap = true;
         _loc9_.multiline = true;
         _loc9_.autoSize = TextFieldAutoSize.LEFT;
         _loc9_.antiAliasType = AntiAliasType.ADVANCED;
         _loc9_.mouseEnabled = false;
         _loc9_.selectable = false;
         _loc9_.text = param1.description;
         var _loc10_:TextField = TextField(_loc6_.getChildByName("txtLabel"));
         _loc10_.x = -100;
         _loc10_.autoSize = TextFieldAutoSize.RIGHT;
         _loc10_.antiAliasType = AntiAliasType.ADVANCED;
         _loc10_.mouseEnabled = false;
         _loc10_.wordWrap = _loc10_.multiline = true;
         _loc10_.selectable = false;
         var _loc11_:String = param1.currentVerbose + param1.targetVerbose;
         var _loc12_:int = _loc11_.length;
         if(_loc12_ > MAX_TARGET_CHARS)
         {
            _loc11_ = _loc11_.replace("/","/\n");
         }
         _loc10_.text = _loc11_;
         if(_loc7_)
         {
            _loc7_.x = QuestTreeComponent.HELPICON_X - ICON_GAP;
            _loc7_.y = _loc9_.y - _loc7_.height * 0.5 + _loc9_.height * 0.5;
            _loc9_.width = Math.min(250,_loc7_.x - _loc4_.x) - DESCRIPTION_LABLE_GAP;
            this.contentRoot.addChild(_loc7_);
         }
         else
         {
            _loc9_.width = Math.min(250,_loc6_.x - _loc10_.width - _loc4_.x - _loc9_.x) - DESCRIPTION_LABLE_GAP;
         }
         if(param1.runstate)
         {
            _loc5_.state = QuestTreeUIClip.RUNNING;
            _loc9_.textColor = this.runningBranchColor;
         }
         else if(param1.completed)
         {
            _loc5_.state = QuestTreeUIClip.COMPLETED;
            _loc9_.textColor = this.accomplishedBranchColor;
         }
         else
         {
            _loc5_.state = QuestTreeUIClip.UPCOMING;
            _loc9_.textColor = this.upcomingBranchColor;
         }
         _loc10_.textColor = _loc9_.textColor;
         this.branchOffset += _loc4_.height;
         if(param1.children.length > 0)
         {
            _loc13_ = 0;
            while(_loc13_ < param1.children.length)
            {
               if(param1.children[_loc13_] != null)
               {
                  _loc14_ = this.createQuestBranchFromCondition(param1.children[_loc13_],param2 + 4,_loc13_ + 1);
                  this.displayCondition(_loc14_,param1.showLong);
                  if(!param1.showLong)
                  {
                     this.branchOffset -= _loc14_.descriptionClip.height;
                  }
               }
               _loc13_++;
            }
            (_loc5_ as IEventDispatcher).addEventListener(MouseEvent.CLICK,this.toggleConditionBranch);
         }
         return _loc8_;
      }
      
      private function toggleConditionBranch(param1:MouseEvent) : void
      {
         var _loc2_:IQuestTreeUIClip = IQuestTreeUIClip(param1.target);
         var _loc3_:QuestTreeBranch = QuestTreeBranch(this.conditionBranches[_loc2_.id]);
         _loc3_.uiClip.selected = _loc3_.expanded;
         _loc3_.expanded = !_loc3_.expanded;
         _loc3_.questBaseObject.showLong = _loc3_.expanded;
         var _loc4_:ICondition = ICondition(_loc3_.questBaseObject);
         this.displayChildren(_loc4_.children,_loc3_.expanded && Boolean(_loc4_.showLong));
         this.updateBranches();
      }
      
      private function displayCondition(param1:QuestTreeBranch, param2:Boolean) : void
      {
         param1.visible = param2;
      }
      
      private function displayChildren(param1:Array, param2:Boolean) : void
      {
         var _loc3_:ICondition = null;
         var _loc4_:Case = null;
         var _loc5_:QuestTreeBranch = null;
         var _loc6_:String = null;
         for(_loc6_ in param1)
         {
            if(param1[_loc6_] is ICondition)
            {
               _loc3_ = param1[_loc6_];
               _loc4_ = null;
            }
            else if(param1[_loc6_] is ICase)
            {
               _loc3_ = null;
               _loc4_ = param1[_loc6_];
            }
            if(_loc3_ != null && this.conditionBranches[_loc3_.id] != null)
            {
               _loc5_ = this.conditionBranches[_loc3_.id];
               this.displayCondition(_loc5_,param2);
            }
            if(_loc4_ != null && this.caseBranches[_loc4_.id] != null)
            {
               _loc5_ = QuestTreeBranch(this.caseBranches[_loc4_.id]);
               _loc5_.visible = param2;
               this.displayChildren(_loc4_.children,param2 && _loc5_.expanded);
            }
         }
      }
      
      private function toggleCaseBranch(param1:MouseEvent) : void
      {
         var _loc6_:String = null;
         var _loc7_:Case = null;
         var _loc8_:ICondition = null;
         var _loc2_:IQuestTreeUIClip = IQuestTreeUIClip(param1.target);
         var _loc3_:QuestTreeBranch = QuestTreeBranch(this.caseBranches[_loc2_.id]);
         var _loc4_:Case = Case(_loc3_.questBaseObject);
         _loc3_.uiClip.selected = _loc3_.expanded;
         _loc3_.expanded = !_loc3_.expanded;
         _loc3_.questBaseObject.showLong = _loc3_.expanded;
         var _loc5_:Array = _loc4_.children;
         for(_loc6_ in _loc5_)
         {
            if(_loc5_[_loc6_] is ICase)
            {
               _loc7_ = Case(_loc5_[_loc6_]);
               if(this.caseBranches[_loc7_.id] is QuestTreeBranch)
               {
                  QuestTreeBranch(this.caseBranches[_loc7_.id]).visible = _loc3_.expanded;
               }
               this.displayChildren(_loc7_.children,_loc3_.expanded && _loc7_.showLong);
            }
            else
            {
               _loc8_ = ICondition(_loc5_[_loc6_]);
               if(this.conditionBranches[_loc8_.id] is QuestTreeBranch)
               {
                  QuestTreeBranch(this.conditionBranches[_loc8_.id]).visible = _loc3_.expanded;
               }
               this.displayChildren(_loc8_.children,_loc3_.expanded && Boolean(_loc8_.showLong));
            }
         }
         this.updateBranches();
      }
      
      public function updateBranches() : void
      {
         var _loc2_:QuestTreeBranch = null;
         var _loc3_:DisplayObject = null;
         this.branchOffset = this.branchOffsetStart;
         var _loc1_:int = 0;
         while(_loc1_ < this.allBranches.length)
         {
            _loc2_ = this.allBranches[_loc1_] as QuestTreeBranch;
            if(_loc2_.visible)
            {
               if(_loc2_.iconsClip != null)
               {
                  _loc2_.iconsClip.y = this.branchOffset;
                  _loc2_.descriptionClip.y = this.branchOffset;
               }
               else
               {
                  _loc2_.descriptionClip.y = this.branchOffset;
               }
               _loc3_ = _loc2_.uiClip as DisplayObject;
               if(_loc3_)
               {
                  _loc3_.y = _loc2_.descriptionClip.y;
               }
               if(_loc2_.valuesClip != null)
               {
                  _loc2_.valuesClip.y = _loc2_.descriptionClip.y;
               }
               this.branchOffset += Math.max(_loc2_.valuesClip ? _loc2_.valuesClip.height : 0,_loc2_.descriptionClip.height,_loc2_.iconsClip ? _loc2_.iconsClip.height : 0);
            }
            _loc1_++;
         }
         dispatchEvent(new Event(SIZE_CHANGED,true));
      }
      
      private function getConditionIcon(param1:ICondition) : QuestTreeUIClip
      {
         var _loc2_:String = null;
         if(!param1.validatable)
         {
            _loc2_ = "failable_subcon";
         }
         else if(param1.children.length > 0)
         {
            _loc2_ = "casecon_open";
         }
         else if(param1.isSubcondition())
         {
            _loc2_ = "subcondition";
         }
         else
         {
            _loc2_ = "condition";
         }
         return this.getQuestTreeElement(_loc2_);
      }
      
      private function getQuestUiTextFieldElement() : MovieClip
      {
         var _loc1_:MovieClip = new MovieClip();
         var _loc2_:TextField = new TextField();
         _loc2_.name = "txtLabel";
         var _loc3_:TextFormat = Styles.plainStdFmt;
         _loc3_.align = TextFormatAlign.LEFT;
         _loc2_.defaultTextFormat = _loc3_;
         _loc2_.embedFonts = Styles.plainStdEmbed;
         _loc1_.addChild(_loc2_);
         return _loc1_;
      }
      
      private function getQuestTreeToggleButton(param1:int = 1) : QuestTreeUIToggleButton
      {
         var _loc5_:BitmapData = null;
         var _loc6_:BitmapData = null;
         var _loc7_:BitmapData = null;
         var _loc2_:String = "casecon_open";
         var _loc3_:String = "casecon_closed";
         var _loc4_:String = _loc2_;
         _loc5_ = this.questAssetsLib.getEmbeddedBitmapData(_loc4_ + "_running.gif");
         _loc6_ = this.questAssetsLib.getEmbeddedBitmapData(_loc4_ + "_upcoming.gif");
         _loc7_ = this.questAssetsLib.getEmbeddedBitmapData(_loc4_ + "_completed.gif");
         var _loc8_:QuestTreeUIToggleButton = new QuestTreeUIToggleButton();
         _loc8_.init(_loc5_,_loc6_,_loc7_);
         _loc4_ = _loc3_;
         _loc5_ = this.questAssetsLib.getEmbeddedBitmapData(_loc4_ + "_running.gif");
         _loc6_ = this.questAssetsLib.getEmbeddedBitmapData(_loc4_ + "_upcoming.gif");
         _loc7_ = this.questAssetsLib.getEmbeddedBitmapData(_loc4_ + "_completed.gif");
         _loc8_.setToggleClips(_loc5_,_loc6_,_loc7_);
         return _loc8_;
      }
      
      private function getQuestTreeElement(param1:String) : QuestTreeUIClip
      {
         var _loc2_:BitmapData = this.questAssetsLib.getEmbeddedBitmapData(param1 + "_running.gif");
         var _loc3_:BitmapData = this.questAssetsLib.getEmbeddedBitmapData(param1 + "_upcoming.gif");
         var _loc4_:BitmapData = this.questAssetsLib.getEmbeddedBitmapData(param1 + "_completed.gif");
         var _loc5_:QuestTreeUIClip = new QuestTreeUIClip();
         _loc5_.init(_loc2_,_loc3_,_loc4_);
         _loc5_.state = QuestTreeUIClip.RUNNING;
         return _loc5_;
      }
      
      public function get visibleHeight() : int
      {
         return this.branchOffset;
      }
   }
}

