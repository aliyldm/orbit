package com.coolorus.panel.core.utils.color
{
   import flash.utils.getQualifiedClassName;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class ColorBase
   {
      
      private var _raw:uint;
      
      private var _changed:ISignal;
      
      private var _componentChanged:Boolean = true;
      
      private var _isUndefined:Boolean;
      
      private var _alpha:Number = 1;
      
      private var _id:String;
      
      public function ColorBase()
      {
         super();
         this._changed = new Signal();
      }
      
      public function get rawColor() : uint
      {
         if(this._componentChanged)
         {
            this._raw = this.calculateRawColor();
            this._componentChanged = false;
         }
         return this._raw & 0xFFFFFF;
      }
      
      public function set rawColor(param1:uint) : void
      {
         if(this._raw != param1)
         {
            this._raw = param1;
            this._componentChanged = false;
            this.updateComponents();
            this._changed.dispatch();
         }
      }
      
      public function get changed() : ISignal
      {
         return this._changed;
      }
      
      public function equals(param1:IColor) : Boolean
      {
         return param1.rawColor == this.rawColor;
      }
      
      public function setUndefined() : void
      {
         if(!this._isUndefined)
         {
            this._isUndefined = true;
            this._changed.dispatch();
         }
      }
      
      public function isUndefined() : Boolean
      {
         return this._isUndefined;
      }
      
      public function copyFrom(param1:IColor, param2:Boolean = true) : void
      {
         if(param1)
         {
            if(param2)
            {
               this.alpha = param1.alpha;
            }
            this.rawColor = param1.rawColor;
         }
      }
      
      protected function calculateRawColor() : uint
      {
         return 0;
      }
      
      protected function componentChanged() : void
      {
         this._componentChanged = true;
         this._isUndefined = false;
         this._changed.dispatch();
      }
      
      protected function updateComponents() : void
      {
      }
      
      public function set id(param1:String) : void
      {
         this._id = param1;
      }
      
      final public function get hex() : String
      {
         var _loc1_:String = (this.rawColor & 0xFFFFFF).toString(16);
         while(_loc1_.length < 6)
         {
            _loc1_ = "0" + _loc1_;
         }
         return _loc1_;
      }
      
      public function toString() : String
      {
         return this.colorClassName() + "[" + this._id + ", " + this.hex + "]";
      }
      
      protected function colorClassName() : String
      {
         var _loc1_:String = getQualifiedClassName(this);
         return _loc1_.slice(_loc1_.indexOf("::") + 2);
      }
      
      public function get alpha() : Number
      {
         return this._alpha;
      }
      
      public function set alpha(param1:Number) : void
      {
         if(this._alpha != param1)
         {
            this._alpha = Math.max(0,Math.min(param1,1));
            this._changed.dispatch();
         }
      }
   }
}

