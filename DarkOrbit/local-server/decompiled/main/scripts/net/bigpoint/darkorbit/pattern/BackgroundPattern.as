package net.bigpoint.darkorbit.pattern
{
   public class BackgroundPattern extends ResourcePattern
   {
      
      private var _isTiled:Boolean;
      
      private var _isReloadable:Boolean;
      
      private var _width:int;
      
      private var _height:int;
      
      private var _tileWidth:int;
      
      private var _tileHeight:int;
      
      private var _order:String;
      
      private var _showInStarlingMode:Boolean;
      
      private var _useOutOfMapBorder:Boolean;
      
      private var _poi3dVO:Poi3dVO;
      
      public var offsetX:int = 0;
      
      public var offsetY:int = 0;
      
      public function BackgroundPattern(param1:int, param2:String, param3:String, param4:Boolean, param5:String, param6:Boolean, param7:int, param8:int, param9:String, param10:int, param11:int, param12:Boolean = true, param13:Boolean = false, param14:Poi3dVO = null)
      {
         super(param1,param2,param3,param5);
         this._isTiled = param4;
         this._isReloadable = param6;
         this._tileWidth = param7;
         this._tileHeight = param8;
         if(param9 != "")
         {
            this._order = param9;
         }
         this._width = param10;
         this._height = param11;
         this._showInStarlingMode = param12;
         this._useOutOfMapBorder = param13;
         this._poi3dVO = param14;
      }
      
      public function toString() : String
      {
         return "BackgroundPattern, resKey: " + resKey + " resKeyStarling: " + resKeyStarling;
      }
      
      public function get isTiled() : Boolean
      {
         return this._isTiled;
      }
      
      public function get width() : int
      {
         return this._width;
      }
      
      public function get height() : int
      {
         return this._height;
      }
      
      public function get tileWidth() : int
      {
         return this._tileWidth;
      }
      
      public function get tileHeight() : int
      {
         return this._tileHeight;
      }
      
      public function get order() : String
      {
         return this._order;
      }
      
      public function get isReloadable() : Boolean
      {
         return this._isReloadable;
      }
      
      public function get showInStarlingMode() : Boolean
      {
         return this._showInStarlingMode;
      }
      
      public function get poi3dVO() : Poi3dVO
      {
         return this._poi3dVO;
      }
      
      public function get useOutOfMapBorder() : Boolean
      {
         return this._useOutOfMapBorder;
      }
   }
}

