package net.bigpoint.darkorbit.mvc.gui.windows.synthesis.model.vo
{
   public class FilterButtonVo
   {
      
      private var _type_name:String;
      
      private var _startLevel:int = 0;
      
      private var _parentType:String;
      
      private var _isSecondary:Boolean = false;
      
      private var _hasStartLevel:Boolean = false;
      
      private var _active:Boolean = false;
      
      private var _animateIn:Boolean = false;
      
      public function FilterButtonVo(param1:String, param2:int = -1, param3:String = null, param4:Boolean = false)
      {
         super();
         this._type_name = param1;
         this._startLevel = param2 < 0 ? 0 : param2;
         this._parentType = param3 ? param3 : param1;
         this._isSecondary = param4;
         this._hasStartLevel = param4 || param2 >= 0;
      }
      
      public function get type_name() : String
      {
         return this._type_name;
      }
      
      public function get startLevel() : int
      {
         return this._startLevel;
      }
      
      public function get parentType() : String
      {
         return this._parentType;
      }
      
      public function get isSecondary() : Boolean
      {
         return this._isSecondary;
      }
      
      public function get hasStartLevel() : Boolean
      {
         return this._hasStartLevel;
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
      
      public function set active(param1:Boolean) : void
      {
         this._active = param1;
      }
      
      public function get animateIn() : Boolean
      {
         return this._animateIn;
      }
      
      public function set animateIn(param1:Boolean) : void
      {
         this._animateIn = param1;
      }
   }
}

