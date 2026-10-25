package net.bigpoint.darkorbit.gui.windows.simpleWindow
{
   import com.bigpoint.utils.PointLite;
   import flash.display.DisplayObjectContainer;
   import flash.utils.Dictionary;
   
   public class SimpleWindowCreationVO
   {
      
      private var _windowID:String;
      
      private var _windowClass:Class;
      
      private var _uiResourceKey:String;
      
      private var _mediatorClass:Class;
      
      private var _proxyClass:Class;
      
      private var _commandMapping:Dictionary;
      
      private var _windowLayer:DisplayObjectContainer;
      
      private var _openStrategy:int;
      
      private var _dynamicWindowPosition:PointLite;
      
      public function SimpleWindowCreationVO(param1:String, param2:DisplayObjectContainer = null, param3:int = 1, param4:PointLite = null)
      {
         super();
         this._windowID = param1;
         this._windowLayer = param2;
         this._openStrategy = param3;
         this._dynamicWindowPosition = param4;
      }
      
      public function setWindowID(param1:String) : SimpleWindowCreationVO
      {
         this._windowID = param1;
         return this;
      }
      
      public function get windowID() : String
      {
         return this._windowID;
      }
      
      public function setUIResoureKey(param1:String) : SimpleWindowCreationVO
      {
         this._uiResourceKey = param1;
         return this;
      }
      
      public function setMediatorClass(param1:Class) : SimpleWindowCreationVO
      {
         this._mediatorClass = param1;
         return this;
      }
      
      public function setProxyClass(param1:Class) : SimpleWindowCreationVO
      {
         this._proxyClass = param1;
         return this;
      }
      
      public function setWindowClass(param1:Class) : SimpleWindowCreationVO
      {
         this._windowClass = param1;
         return this;
      }
      
      public function registerCommand(param1:String, param2:Class) : SimpleWindowCreationVO
      {
         if(this._commandMapping == null)
         {
            this._commandMapping = new Dictionary();
         }
         if(!this._commandMapping[param1])
         {
            this._commandMapping[param1] = param2;
         }
         return this;
      }
      
      public function get uiResoureKey() : String
      {
         return this._uiResourceKey;
      }
      
      public function get mediatorClass() : Class
      {
         return this._mediatorClass;
      }
      
      public function get proxyClass() : Class
      {
         return this._proxyClass;
      }
      
      public function get commandMap() : Dictionary
      {
         return this._commandMapping;
      }
      
      public function get windowClass() : Class
      {
         return this._windowClass;
      }
      
      public function setWindowLayer(param1:DisplayObjectContainer) : SimpleWindowCreationVO
      {
         this._windowLayer = param1;
         return this;
      }
      
      public function get windowLayer() : DisplayObjectContainer
      {
         return this._windowLayer;
      }
      
      public function setOpenStrategy(param1:uint) : SimpleWindowCreationVO
      {
         this._openStrategy = param1;
         return this;
      }
      
      public function get openStrategy() : int
      {
         return this._openStrategy;
      }
      
      public function get dynamicWindowPosition() : PointLite
      {
         return this._dynamicWindowPosition;
      }
      
      public function toString() : String
      {
         var _loc1_:String = "{";
         _loc1_ += " windowLayer   " + this._windowLayer;
         _loc1_ += " _openStrategy " + this._openStrategy;
         _loc1_ += " _dynamicWindowPosition " + this._dynamicWindowPosition;
         return _loc1_ + " }";
      }
   }
}

