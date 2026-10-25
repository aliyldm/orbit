package net.bigpoint.darkorbit.gui.container
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.geom.Point;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   
   public class SimpleContainer extends Sprite
   {
      
      public static var CLASS_MINIMAP:int = 2;
      
      public static var CLASS_DARKORBIT_LOGO:int = 3;
      
      public static var CONTAINER_CLASS_HERO_INFO_0:int = 5;
      
      public static var CONTAINER_CLASS_HERO_INFO_1:int = 14;
      
      public static var CONTAINER_CLASS_HERO_INFO_2:int = 1;
      
      public static var CONTAINER_CLASS_HERO_INFO_3:int = 4;
      
      public static var CONTAINER_CLASS_OPPONENT_INFO:int = 0;
      
      public static const CLASS_BUTTONS:int = 6;
      
      public static const CLASS_LOG:int = 8;
      
      public static const CLASS_LOGOUT_WINDOW:int = 9;
      
      public static const CLASS_TRADE_ORE:int = 10;
      
      public static const CLASS_TRADE_WEBLINKS1:int = 11;
      
      public static const CLASS_TRADE_WEBLINKS2:int = 12;
      
      public static const CLASS_MINIMAP_LABEL:int = 13;
      
      public static const CLASS_QUEST_TREE:int = 15;
      
      public static const CLASS_QUEST_PAGE_DOTS:int = 16;
      
      public static const CLASS_CONNECTION_LOST:int = 17;
      
      public static const CLASS_SPACEMAP:int = 18;
      
      public static const CLASS_HERO_DESTROYED:int = 19;
      
      public static const CLASS_CONNECTION:int = 20;
      
      public static const CLASS_BETA:int = 21;
      
      public static const CLASS_BOOSTER:int = 22;
      
      public static const CLASS_SPACEBALL:int = 23;
      
      public static const CLASS_INVASION:int = 24;
      
      public static const CLASS_CTB:int = 25;
      
      public static const CLASS_TDM:int = 26;
      
      public static const CLASS_CHAT:int = 27;
      
      public static const CLASS_PROMPT:int = 28;
      
      public static const CLASS_COMMAND_LINE_INTERFACE:int = 29;
      
      public static const CLASS_GROUP_SYSTEM:int = 30;
      
      public static const CLASS_REFINEMENT_UPDATE_SOURCE:int = 31;
      
      public static const CLASS_REFINEMENT_UPDATE_TARGET:int = 32;
      
      public static const CLASS_REFINEMENT_QUERY:int = 33;
      
      public static const CLASS_REFINEMENT_BUTTONS:int = 36;
      
      public static const CLASS_REFINEMENT_UPDATE_STATIC:int = 37;
      
      public static const CLASS_REFINEMENT_REFINEMENT_STATIC:int = 38;
      
      public static const CLASS_REFINEMENT_REFINEMENT_SOURCE:int = 39;
      
      public static const CLASS_REFINEMENT_REFINEMENT_BUTTONS:int = 40;
      
      public static const CLASS_REFINEMENT_REFINEMENT_TREE:int = 41;
      
      public static const CLASS_DEFAULT:int = 35;
      
      public static const CLASS_SETTING_TABS:int = 42;
      
      public static const CLASS_SETTING_BUTTONS:int = 43;
      
      public static const CLASS_SETTING_TABPAGE_GAMEPLAY:int = 44;
      
      public static const CLASS_SETTING_TABPAGE_DISPLAY:int = 45;
      
      public static const CLASS_SETTING_TABPAGE_SOUND:int = 46;
      
      public static const CLASS_SETTING_TABPAGE_KEYBOARD:int = 76;
      
      public static const CLASS_AUTOSTART_WARNING:int = 47;
      
      public static const CLASS_REPAIR_SHIP:int = 48;
      
      public static const CLASS_SCROLLABLE:int = 49;
      
      public static const CLASS_TECHS:int = 50;
      
      public static const CLASS_RANKED_HUNT_EVENT:int = 51;
      
      public static const CLASS_RANKED_HUNT_EVENT_COL_2:int = 52;
      
      public static const CLASS_SPACEMAP_ADVANCED:int = 53;
      
      public static const CLASS_PET_WINDOW_CONTENT:int = 54;
      
      public static const CLASS_PET_WINDOW_BANNER:int = 55;
      
      public static const CLASS_SETTING_TABPAGE_INTERFACE:int = 56;
      
      public static const CLASS_HIGH_SCORE_GATE_COL_1:int = 57;
      
      public static const CLASS_HIGH_SCORE_GATE_COL_2:int = 58;
      
      public static const CLASS_HIGH_SCORE_GATE_COL_3:int = 59;
      
      public static const CLASS_CAPTCHA_DISPLAY_AREA:int = 60;
      
      public static const CLASS_CAPTCHA_REFRESH_BUTTON:int = 61;
      
      public static const CLASS_CAPTCHA_SUBMIT_BUTTON:int = 62;
      
      public static const CLASS_CAPTCHA_INPUT_TEXTFIELD:int = 63;
      
      public static const CLASS_CAPTCHA_RESPONSE_FEEDBACK:int = 64;
      
      public static const CLASS_CAPTCHA_INFO_FIELD:int = 65;
      
      public static const CLASS_SCORE_FEST_LIVES:int = 66;
      
      public static const CLASS_SCORE_FEST_COMBO:int = 67;
      
      public static const CLASS_SCORE_FEST_SCORE:int = 68;
      
      public static const CLASS_SCORE_FEST_COMBO_TIMER:int = 69;
      
      public static const CLASS_INFILTRATION_GAME:int = 70;
      
      public static const CLASS_QUEST_BUTTONS:int = 71;
      
      public static const CLASS_QUEST_TABS:int = 72;
      
      public static const CLASS_QUEST_TABPAGE_OVERVIEW:int = 73;
      
      public static const CLASS_QUEST_TABPAGE_REWARD:int = 74;
      
      public static const CLASS_QUEST_TABPAGE_INFO:int = 77;
      
      public static const CLASS_QUEST_REWARDS:int = 75;
      
      public static const CLASS_QUEST_INFO:int = 78;
      
      public static const CLASS_SECTOR_CONTROL:int = 76;
      
      public static const NO_ALIGN:int = 0;
      
      public static const ALIGN_VERTICAL:int = 1;
      
      public static const ALIGN_HORIZONTAL:int = 2;
      
      public static const ALIGN_VERTICAL_CENTER:int = 3;
      
      public static const ALIGN_HORIZONTAL_CENTER:int = 4;
      
      private var positions:Array = [];
      
      protected var elements:Array = [];
      
      protected var guiManager:GuiManager;
      
      private var displayDigits:Boolean;
      
      protected var classID:int;
      
      public function SimpleContainer(param1:GuiManager, param2:int)
      {
         super();
         this.guiManager = param1;
         this.classID = param2;
         this.cacheAsBitmap = true;
      }
      
      public function getClassID() : int
      {
         return this.classID;
      }
      
      public function removeElement(param1:DisplayObject) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.elements.length)
         {
            _loc3_ = this.elements[_loc2_];
            if(_loc3_ == param1)
            {
               this.elements.splice(_loc2_,1);
               this.removeChild(param1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function addElement(param1:DisplayObject, param2:int = 0, param3:int = 5) : void
      {
         var _loc4_:DisplayObject = null;
         if(this.numChildren > 0)
         {
            _loc4_ = this.getChildAt(this.numChildren - 1);
            if(param2 == ALIGN_VERTICAL)
            {
               param1.x = _loc4_.x;
               param1.y = _loc4_.y + _loc4_.height + param3;
            }
            else if(param2 == ALIGN_HORIZONTAL)
            {
               param1.y = _loc4_.y;
               param1.x = _loc4_.x + _loc4_.width + param3;
            }
            else if(param2 == ALIGN_VERTICAL_CENTER)
            {
               param1.x = this.width / 2 - param1.width / 2;
               param1.y = _loc4_.y + _loc4_.height + param3;
            }
            else if(param2 == ALIGN_HORIZONTAL_CENTER)
            {
               param1.x = _loc4_.x + _loc4_.width + param3;
               param1.y = this.height / 2 - param1.height / 2;
            }
         }
         this.elements.push(param1);
         this.addChild(param1);
      }
      
      public function getAllElements() : Array
      {
         return this.elements;
      }
      
      public function removeAllElements() : void
      {
         var _loc2_:DisplayObject = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.elements.length)
         {
            _loc2_ = this.elements[_loc1_];
            if(_loc2_ != null && this.contains(_loc2_))
            {
               this.removeChild(_loc2_);
            }
            _loc1_++;
         }
         this.elements = [];
      }
      
      public function getElement(param1:int) : SimpleElement
      {
         var _loc3_:SimpleElement = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.elements.length)
         {
            _loc3_ = this.elements[_loc2_];
            if(_loc3_.getID() == param1)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getContainer(param1:int) : SimpleContainer
      {
         var _loc3_:SimpleContainer = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.elements.length)
         {
            _loc3_ = this.elements[_loc2_];
            if(_loc3_.getClassID() == param1)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getElementAt(param1:int) : SimpleElement
      {
         return this.elements[param1];
      }
      
      public function getElements(param1:int) : Array
      {
         var _loc4_:SimpleElement = null;
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < this.elements.length)
         {
            _loc4_ = this.elements[_loc3_];
            if(_loc4_.getID() == param1)
            {
               _loc2_.push(_loc4_);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      override public function get width() : Number
      {
         var _loc3_:Object = null;
         var _loc4_:Number = NaN;
         var _loc1_:Number = super.width;
         var _loc2_:int = 0;
         while(_loc2_ < this.elements.length)
         {
            _loc3_ = this.elements[_loc2_];
            _loc4_ = this.recurseChildWidth(_loc3_);
            if(_loc4_ > _loc1_)
            {
               _loc1_ = _loc4_;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function recurseChildWidth(param1:Object) : Number
      {
         var _loc3_:DisplayObjectContainer = null;
         var _loc4_:int = 0;
         var _loc5_:DisplayObject = null;
         var _loc6_:Number = NaN;
         var _loc2_:int = 0;
         if(param1 is DisplayObjectContainer)
         {
            _loc3_ = param1 as DisplayObjectContainer;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.numChildren)
            {
               _loc5_ = _loc3_.getChildAt(_loc4_);
               if(_loc5_ is Sprite)
               {
                  if(_loc5_.width > _loc2_)
                  {
                     _loc2_ = _loc5_.width;
                  }
                  _loc6_ = this.recurseChildWidth(_loc5_);
                  if(_loc6_ > _loc2_)
                  {
                     _loc2_ = _loc6_;
                  }
               }
               _loc4_++;
            }
         }
         return _loc2_;
      }
      
      override public function get height() : Number
      {
         var _loc3_:Object = null;
         var _loc4_:Number = NaN;
         var _loc1_:Number = super.height;
         var _loc2_:int = 0;
         while(_loc2_ < this.elements.length)
         {
            _loc3_ = this.elements[_loc2_];
            _loc4_ = this.recurseChildHeight(_loc3_);
            if(_loc4_ > _loc1_)
            {
               _loc1_ = _loc4_;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function recurseChildHeight(param1:Object) : Number
      {
         var _loc3_:DisplayObjectContainer = null;
         var _loc4_:int = 0;
         var _loc5_:DisplayObject = null;
         var _loc6_:Number = NaN;
         var _loc2_:int = 0;
         if(param1 is DisplayObjectContainer)
         {
            _loc3_ = param1 as DisplayObjectContainer;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.numChildren)
            {
               _loc5_ = _loc3_.getChildAt(_loc4_);
               if(_loc5_ is Sprite)
               {
                  if(_loc5_.height > _loc2_)
                  {
                     _loc2_ = _loc5_.height;
                  }
                  _loc6_ = this.recurseChildHeight(_loc5_);
                  if(_loc6_ > _loc2_)
                  {
                     _loc2_ = _loc6_;
                  }
               }
               _loc4_++;
            }
         }
         return _loc2_;
      }
      
      public function getParent() : DisplayObject
      {
         return this.parent;
      }
      
      public function setPredefinedPosition() : void
      {
         var _loc1_:Point = this.positions[0];
         if(this.isDisplayDigits())
         {
            if(this.positions[1] != null)
            {
               _loc1_ = this.positions[1];
            }
         }
         if(_loc1_ == null)
         {
            this.addPredefinedPosition(new Point(10,25));
            _loc1_ = this.positions[0];
         }
         this.x = _loc1_.x;
         this.y = _loc1_.y;
      }
      
      public function addPredefinedPosition(param1:Point) : void
      {
         this.positions.push(param1);
      }
      
      public function isDisplayDigits() : Boolean
      {
         return this.displayDigits;
      }
      
      public function setDisplayDigits(param1:Boolean) : void
      {
         this.displayDigits = param1;
      }
      
      public function removeElementById(param1:int) : void
      {
         this.removeElement(this.getElement(param1));
      }
      
      public function get containerView() : DisplayObject
      {
         return this;
      }
   }
}

