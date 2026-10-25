package net.bigpoint.darkorbit.mvc.tdm.statusWindow.view.decorator
{
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.tdm.statusWindow.TDMStatusWindowConstants;
   
   public class TDMStatusUiDecorator
   {
      
      private var _playersFactionDecorator:TDMStatusFactionContainerDecorator;
      
      private var _opponentFactionDecorator:TDMStatusFactionContainerDecorator;
      
      private var _eventScoreDecorator:TDMStatusScoreContainerDecorator;
      
      private var _playersInfoDecorator:TDMStatusInfoContainerDecorator;
      
      private var _window:SimpleWindow;
      
      public function TDMStatusUiDecorator(param1:SimpleWindow)
      {
         super();
         this._window = param1;
         this.decorate(param1);
      }
      
      private function decorate(param1:SimpleWindow) : void
      {
         this.prepareWindow(param1);
      }
      
      private function prepareWindow(param1:SimpleWindow) : void
      {
         var _loc10_:SimpleContainer = null;
         var _loc2_:SimpleContainer = param1.getContainer(0);
         var _loc3_:SimpleContainer = param1.getContainer(1);
         var _loc4_:SimpleContainer = param1.getContainer(2);
         var _loc5_:SimpleContainer = param1.getContainer(3);
         this._playersFactionDecorator = new TDMStatusFactionContainerDecorator(_loc2_);
         this._opponentFactionDecorator = new TDMStatusFactionContainerDecorator(_loc3_);
         this._playersInfoDecorator = new TDMStatusInfoContainerDecorator(_loc4_);
         this._eventScoreDecorator = new TDMStatusScoreContainerDecorator(_loc5_);
         var _loc6_:Vector.<SimpleContainer> = new Vector.<SimpleContainer>();
         _loc6_.unshift(_loc2_,_loc3_,_loc4_,_loc5_);
         var _loc7_:int = int(_loc6_.length);
         var _loc8_:int = TDMStatusWindowConstants.START_POINT.x;
         var _loc9_:int = TDMStatusWindowConstants.START_POINT.y;
         var _loc11_:int = 0;
         while(_loc11_ < _loc7_)
         {
            _loc10_ = _loc6_[_loc11_];
            _loc10_.x = _loc8_;
            _loc10_.y = _loc9_;
            _loc9_ += _loc10_.height;
            _loc11_++;
         }
      }
      
      public function get playersFactionDecorator() : TDMStatusFactionContainerDecorator
      {
         return this._playersFactionDecorator;
      }
      
      public function get opponentFactionDecorator() : TDMStatusFactionContainerDecorator
      {
         return this._opponentFactionDecorator;
      }
      
      public function get eventScoreDecorator() : TDMStatusScoreContainerDecorator
      {
         return this._eventScoreDecorator;
      }
      
      public function get playersInfoDecorator() : TDMStatusInfoContainerDecorator
      {
         return this._playersInfoDecorator;
      }
      
      public function get window() : SimpleWindow
      {
         return this._window;
      }
   }
}

