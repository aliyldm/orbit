package net.bigpoint.darkorbit.fui.components.core.skins
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import net.bigpoint.darkorbit.fui.components.core.skins.layers.ISkinLayer;
   
   public class AbstractSkin extends Sprite implements ISkin
   {
      
      protected var _width:Number = 0;
      
      protected var _height:Number = 0;
      
      protected var _layers:Dictionary = new Dictionary();
      
      protected var _resizablelayers:Vector.<String> = new Vector.<String>(0);
      
      protected var _currentState:String;
      
      protected var _initialized:Boolean = false;
      
      private var _registerdName:String;
      
      public function AbstractSkin()
      {
         super();
         this.preinitialize();
      }
      
      protected function preinitialize() : void
      {
      }
      
      public function init() : void
      {
         if(this._initialized)
         {
            return;
         }
         this._initialized = true;
      }
      
      override public function set width(param1:Number) : void
      {
         var _loc4_:String = null;
         var _loc5_:DisplayObject = null;
         var _loc2_:uint = this._resizablelayers.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._resizablelayers[_loc3_];
            _loc5_ = this._layers[_loc4_];
            if(_loc5_)
            {
               _loc5_.width = param1;
            }
            _loc3_++;
         }
         this._width = param1;
      }
      
      override public function get width() : Number
      {
         return this._width;
      }
      
      override public function set height(param1:Number) : void
      {
         var _loc4_:String = null;
         var _loc5_:DisplayObject = null;
         var _loc2_:uint = this._resizablelayers.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._resizablelayers[_loc3_];
            _loc5_ = this._layers[_loc4_];
            if(_loc5_)
            {
               _loc5_.height = param1;
            }
            _loc3_++;
         }
         this._height = param1;
      }
      
      override public function get height() : Number
      {
         return this._height;
      }
      
      public function get measureRawSkinSize() : Rectangle
      {
         var _loc4_:DisplayObject = null;
         var _loc1_:Rectangle = new Rectangle();
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         for each(_loc4_ in this._layers)
         {
            _loc2_ = _loc2_ < _loc4_.width ? uint(_loc4_.width) : _loc2_;
            _loc3_ = _loc3_ < _loc4_.height ? uint(_loc4_.height) : _loc3_;
         }
         _loc1_.width = _loc2_;
         _loc1_.height = _loc3_;
         return _loc1_;
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         var _loc5_:String = null;
         var _loc6_:DisplayObject = null;
         var _loc3_:uint = this._resizablelayers.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this._resizablelayers[_loc4_];
            _loc6_ = this._layers[_loc5_];
            if(_loc6_)
            {
               _loc6_.width = param1;
               _loc6_.height = param2;
            }
            _loc4_++;
         }
         this._width = param1;
         this._height = param2;
      }
      
      public function setSkinLayer(param1:String, param2:DisplayObject) : void
      {
         this._layers[param1] = param2;
      }
      
      public function getSkinLayer(param1:String) : DisplayObject
      {
         return this._layers[param1];
      }
      
      public function set state(param1:String) : void
      {
         if(this._layers[param1] != null)
         {
            this.setCurrentSkinState(param1);
         }
      }
      
      protected function setCurrentSkinState(param1:String) : void
      {
         this._currentState = param1;
      }
      
      public function getCurrentState() : String
      {
         return this._currentState;
      }
      
      public function showState(param1:String) : void
      {
         var _loc2_:DisplayObject = this._layers[param1] as DisplayObject;
         if(_loc2_)
         {
            _loc2_.visible = true;
         }
      }
      
      public function hideState(param1:String) : void
      {
         var _loc2_:DisplayObject = this._layers[param1] as DisplayObject;
         if(_loc2_)
         {
            _loc2_.visible = false;
         }
      }
      
      public function clone() : ISkin
      {
         var _loc1_:Class = getDefinitionByName(getQualifiedClassName(this)) as Class;
         var _loc2_:ISkin = new _loc1_() as ISkin;
         this._clone_(_loc2_,this.getSkinLayerDefintions());
         return _loc2_;
      }
      
      protected function _clone_(param1:ISkin, param2:Dictionary) : void
      {
         var _loc3_:String = null;
         var _loc4_:ISkinLayer = null;
         var _loc5_:DisplayObject = null;
         for(_loc3_ in param2)
         {
            _loc4_ = this.getSkinLayer(_loc3_) as ISkinLayer;
            if(_loc4_)
            {
               _loc5_ = _loc4_.clone();
               param1.setSkinLayer(_loc3_,_loc5_);
            }
         }
         param1.registerdName = this.registerdName;
      }
      
      public function dispose() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:ISkinLayer = null;
         for each(_loc1_ in this._layers)
         {
            _loc2_ = _loc1_ as ISkinLayer;
            if(_loc2_)
            {
               _loc2_.dispose();
            }
            _loc1_ = null;
         }
      }
      
      public function getMask() : DisplayObject
      {
         throw new Error("You must override this method [ getMask() ].");
      }
      
      public function getSkinLayerDefintions() : Dictionary
      {
         throw new Error("You must override this method [ getSkinLayerDefintions() ].");
      }
      
      public function get registerdName() : String
      {
         return this._registerdName;
      }
      
      public function set registerdName(param1:String) : void
      {
         this._registerdName = param1;
      }
   }
}

