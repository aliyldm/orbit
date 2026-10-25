package net.bigpoint.darkorbit.mvc.jackpotBattle.statusWin.view.decorator
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class JackpotStatusUiDecorator implements IEventDispatcher
   {
      
      private static const CENTER_GAP:int = 10;
      
      private static const FOOTER_GAP:int = 10;
      
      public static const WAINTING:int = 0;
      
      public static const SCHEDULED:int = 1;
      
      public static const FIGHTING:int = 2;
      
      public static const WILDCARD:int = 3;
      
      private var _window:SimpleWindow;
      
      private var _footerDecorator:JackpotStatusFooterDecorator;
      
      private var _centerDecorator:JackpotStatusCenterDecorator;
      
      private var _headerDecorator:JackpotStatusHeaderDecorator;
      
      public function JackpotStatusUiDecorator(param1:SimpleWindow)
      {
         super();
         this.decorate(param1);
      }
      
      private function decorate(param1:SimpleWindow) : void
      {
         this._window = param1;
         this.prepareWindow();
      }
      
      public function flash() : void
      {
         if(!this._window.maximized && !this._window.isTweening())
         {
            this._window.flashWindowIcon(5);
         }
      }
      
      public function minimize() : void
      {
         if(this._window.maximized)
         {
            this._window.minimize();
         }
      }
      
      private function centerMyContainer(param1:SimpleContainer) : void
      {
         var _loc2_:int = this._window.width * 0.5;
         this.centerX(param1);
         param1.x += _loc2_;
      }
      
      private function centerX(param1:DisplayObject) : void
      {
         param1.x = -param1.width * 0.5;
      }
      
      private function prepareWindow() : void
      {
         this._window.removeAllElements();
         var _loc1_:SimpleContainer = this._window.getContainer(0);
         var _loc2_:SimpleContainer = this._window.getContainer(1);
         var _loc3_:SimpleContainer = this._window.getContainer(2);
         MovieClipUtils.cleanupDisplayObjectContainer(_loc3_);
         MovieClipUtils.cleanupDisplayObjectContainer(_loc2_);
         MovieClipUtils.cleanupDisplayObjectContainer(_loc1_);
         this._headerDecorator = new JackpotStatusHeaderDecorator(_loc1_,this._window.width,this._window.height);
         this._centerDecorator = new JackpotStatusCenterDecorator(_loc2_,this._window.width,this._window.height);
         _loc2_.y = _loc1_.y + _loc1_.height + CENTER_GAP;
         this._footerDecorator = new JackpotStatusFooterDecorator(_loc3_,this._window.width,this._window.height);
         _loc3_.y = _loc2_.y + _loc2_.height + FOOTER_GAP;
         this.centerMyContainer(_loc1_);
         this.centerMyContainer(_loc2_);
         this.centerMyContainer(_loc3_);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._window.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._window.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._window.hasEventListener(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._window.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._window.willTrigger(param1);
      }
      
      public function get footerDecorator() : JackpotStatusFooterDecorator
      {
         return this._footerDecorator;
      }
      
      public function get centerDecorator() : JackpotStatusCenterDecorator
      {
         return this._centerDecorator;
      }
      
      public function get headerDecorator() : JackpotStatusHeaderDecorator
      {
         return this._headerDecorator;
      }
   }
}

