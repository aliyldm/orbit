package net.bigpoint.darkorbit.fui.components.core.layout
{
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.ICoreponent;
   
   public class Alignment
   {
      
      public static const TOP:String = "TOP";
      
      public static const CENTER_Y:String = "CENTER";
      
      public static const BOTTOM:String = "BOTTOM";
      
      public static const LEFT:String = "LEFT";
      
      public static const CENTER_X:String = "CENTER";
      
      public static const RIGHT:String = "RIGHT";
      
      public static const ACIVATE_VERTICAL:uint = 1;
      
      public static const ACIVATE_HORIZONTAL:uint = 2;
      
      public static const ACIVATE_HORIZONTAL_AND_VERTICAL:uint = ACIVATE_VERTICAL | ACIVATE_HORIZONTAL;
      
      protected var _autoSizeMode:uint = LayoutAutoSizeMode.PARENT;
      
      private var _alignmentX:String = "LEFT";
      
      private var _alignmentY:String = "TOP";
      
      protected var _marginLeft:Number = 0;
      
      protected var _marginRight:Number = 0;
      
      protected var _marginTop:Number = 0;
      
      protected var _marginBottom:Number = 0;
      
      protected var verticalAlignmentActivated:Boolean = true;
      
      protected var horizontalAlignmentActivated:Boolean = true;
      
      protected var _host:Coreponent;
      
      public function Alignment(param1:Coreponent)
      {
         super();
         this._host = param1;
      }
      
      public function dispose() : void
      {
      }
      
      public function get alignmentX() : String
      {
         return this._alignmentX;
      }
      
      public function set alignmentX(param1:String) : void
      {
         if(param1)
         {
            this._alignmentX = param1.toUpperCase();
         }
      }
      
      public function get alignmentY() : String
      {
         return this._alignmentY;
      }
      
      public function set alignmentY(param1:String) : void
      {
         if(param1)
         {
            this._alignmentY = param1.toUpperCase();
         }
      }
      
      public function set marginX(param1:Number) : void
      {
         this._marginLeft = param1;
         this._marginRight = param1;
      }
      
      public function get marginX() : Number
      {
         return this._marginLeft;
      }
      
      public function set marginLeft(param1:Number) : void
      {
         this._marginLeft = param1;
      }
      
      public function get marginLeft() : Number
      {
         return this._marginLeft;
      }
      
      public function set marginRight(param1:Number) : void
      {
         this._marginRight = param1;
      }
      
      public function get marginRight() : Number
      {
         return this._marginRight;
      }
      
      public function set marginY(param1:Number) : void
      {
         this._marginTop = param1;
         this._marginBottom = param1;
      }
      
      public function get marginY() : Number
      {
         return this._marginTop;
      }
      
      public function set marginTop(param1:Number) : void
      {
         this._marginTop = param1;
      }
      
      public function get marginTop() : Number
      {
         return this._marginTop;
      }
      
      public function set marginBottom(param1:Number) : void
      {
         this._marginBottom = param1;
      }
      
      public function get marginBottom() : Number
      {
         return this._marginBottom;
      }
      
      public function calculateX() : Number
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this._host.autoSizeWidth && this._host.isAutoSizeMode(LayoutAutoSizeMode.PARENT_WIDTH))
         {
            return this._marginLeft;
         }
         if(!this.horizontalAlignmentActivated)
         {
            return this._host.x + this._marginLeft;
         }
         switch(this._alignmentX)
         {
            case LEFT:
               _loc1_ = this._host.x + this._marginLeft;
               break;
            case CENTER_X:
               _loc1_ = (this.getHostComponentParentWidth() >> 1) - (this.getHostComponentWidth() >> 1) + this._host.x;
               break;
            case RIGHT:
               _loc2_ = this.getHostComponentParentWidth();
               _loc3_ = this.getHostComponentWidth();
               _loc1_ = _loc2_ - _loc3_ - this._marginRight + this._host.x;
               break;
            default:
               _loc1_ = this._host.x;
         }
         return _loc1_;
      }
      
      public function calculateY() : Number
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this._host.autoSizeHeight && this._host.isAutoSizeMode(LayoutAutoSizeMode.PARENT_HEIGHT))
         {
            return this._marginTop;
         }
         if(!this.verticalAlignmentActivated)
         {
            return this._host.y + this._marginTop;
         }
         switch(this._alignmentY)
         {
            case TOP:
               _loc1_ = this._host.y + this._marginTop;
               break;
            case CENTER_Y:
               _loc1_ = (this.getHostComponentParentHeight() >> 1) - (this.getHostComponentHeight() >> 1) + this._host.y;
               break;
            case BOTTOM:
               _loc2_ = this.getHostComponentParentHeight();
               _loc3_ = this.getHostComponentHeight();
               _loc1_ = _loc2_ - _loc3_ - this._marginBottom + this._host.y;
               break;
            default:
               _loc1_ = this._host.y;
         }
         return _loc1_;
      }
      
      protected function getHostComponentWidth() : Number
      {
         return this._host.width;
      }
      
      protected function getHostComponentParentWidth() : Number
      {
         if(this._host.parent)
         {
            return this._host.parent.width;
         }
         return 0;
      }
      
      protected function getHostComponentHeight() : Number
      {
         return this._host.height;
      }
      
      protected function getHostComponentParentHeight() : Number
      {
         if(this._host.parent)
         {
            return this._host.parent.height;
         }
         return 0;
      }
      
      public function calculatePercentageWidth() : Number
      {
         var _loc2_:Number = NaN;
         var _loc3_:Vector.<ICoreponent> = null;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         var _loc6_:ICoreponent = null;
         var _loc7_:Number = NaN;
         var _loc1_:Number = 0;
         if(this.isAutoSizeMode(LayoutAutoSizeMode.PARENT_WIDTH))
         {
            _loc2_ = this._marginLeft + this._marginRight;
            _loc1_ = this.getHostComponentParentWidth() - _loc2_;
         }
         else if(this.isAutoSizeMode(LayoutAutoSizeMode.CHILDREN_WIDTH))
         {
            _loc3_ = this._host.getAllCoreponentChildren();
            _loc4_ = _loc3_.length;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc6_ = _loc3_[_loc5_];
               _loc7_ = _loc6_.getCalculatedWidth() + _loc6_.marginLeft + _loc6_.marginRight;
               _loc1_ = _loc7_ > _loc1_ ? _loc7_ : _loc1_;
               _loc5_++;
            }
         }
         return _loc1_;
      }
      
      public function calculatePercentageHeight() : Number
      {
         var _loc2_:Number = NaN;
         var _loc3_:Vector.<ICoreponent> = null;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         var _loc6_:ICoreponent = null;
         var _loc7_:Number = NaN;
         var _loc1_:Number = 0;
         if(this.isAutoSizeMode(LayoutAutoSizeMode.PARENT_HEIGHT))
         {
            _loc2_ = this._marginTop + this._marginBottom;
            _loc1_ = this.getHostComponentParentHeight() - _loc2_;
         }
         else if(this.isAutoSizeMode(LayoutAutoSizeMode.CHILDREN_HEIGHT))
         {
            _loc3_ = this._host.getAllCoreponentChildren();
            _loc4_ = _loc3_.length;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc6_ = _loc3_[_loc5_];
               _loc7_ = _loc6_.y + _loc6_.height + _loc6_.marginTop + _loc6_.marginBottom;
               _loc1_ = _loc7_ > _loc1_ ? _loc7_ : _loc1_;
               _loc5_++;
            }
         }
         return _loc1_;
      }
      
      public function setAlignmentActivation(param1:uint, param2:Boolean) : void
      {
         switch(param1)
         {
            case ACIVATE_VERTICAL:
               this.verticalAlignmentActivated = param2;
               break;
            case ACIVATE_HORIZONTAL:
               this.horizontalAlignmentActivated = param2;
               break;
            case ACIVATE_HORIZONTAL_AND_VERTICAL:
               this.verticalAlignmentActivated = param2;
               this.horizontalAlignmentActivated = param2;
         }
      }
      
      public function clearAutoSizeMode() : void
      {
         this._autoSizeMode = 0;
      }
      
      public function set autoSizeMode(param1:uint) : void
      {
         var _loc2_:uint = uint(param1 & 0x0F);
         var _loc3_:uint = uint(param1 & 0xF0);
         if(_loc2_ > 0)
         {
            this._autoSizeMode |= _loc2_;
         }
         if(_loc3_ > 0)
         {
            this._autoSizeMode &= 15;
            this._autoSizeMode |= _loc3_;
         }
      }
      
      public function get autoSizeMode() : uint
      {
         return this._autoSizeMode;
      }
      
      public function isAutoSizeMode(param1:uint) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:uint = uint(this._autoSizeMode & 0x0F);
         if(_loc3_ == param1)
         {
            _loc2_ = true;
         }
         var _loc4_:uint = uint(this._autoSizeMode & 0xF0);
         if(_loc4_ == param1)
         {
            _loc2_ = true;
         }
         if(param1 == LayoutAutoSizeMode.CHILDREN || param1 == LayoutAutoSizeMode.PARENT)
         {
            _loc2_ = true;
         }
         return _loc2_;
      }
   }
}

