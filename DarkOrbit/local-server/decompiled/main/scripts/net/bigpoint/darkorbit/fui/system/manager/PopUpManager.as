package net.bigpoint.darkorbit.fui.system.manager
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Stage;
   import flash.display.StageDisplayState;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.ICoreponent;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.core.data.IDataReceptible;
   
   public class PopUpManager implements IPopUpManager
   {
      
      private static const RESIZE_DELAY:int = 250;
      
      private var _resizeTimeout:int;
      
      private var _popupLayer:DisplayObjectContainer;
      
      protected var _updatePositionsTimer:Timer;
      
      protected var _positionUpdateReference:Object;
      
      protected var _updateTarget:DisplayObject;
      
      public function PopUpManager(param1:DisplayObjectContainer)
      {
         super();
         this._popupLayer = param1;
         UISystem.getInstance().stage.addEventListener(Event.RESIZE,this.handleStageResizeEvent);
         this._updatePositionsTimer = new Timer(30);
         this._updatePositionsTimer.addEventListener(TimerEvent.TIMER,this.handleTimerEvent);
      }
      
      public function removeAll() : void
      {
         while(this._popupLayer.numChildren > 0)
         {
            this._popupLayer.removeChildAt(0);
         }
         this._updatePositionsTimer.stop();
      }
      
      public function add(param1:DisplayObject, param2:DisplayObject = null, param3:Point = null) : void
      {
         this.removeAll();
         this._popupLayer.addChild(param1);
         if(param2)
         {
            this._updateTarget = param1;
            this._positionUpdateReference = {
               "reference":param2,
               "offset":param3
            };
            this.updateTargetPosition();
            this._updatePositionsTimer.start();
         }
      }
      
      public function remove(param1:DisplayObject) : void
      {
         if(this._popupLayer.contains(param1))
         {
            this._popupLayer.removeChild(param1);
         }
         this._updateTarget = null;
         this._updatePositionsTimer.stop();
      }
      
      public function isPopupOpen(param1:DisplayObject) : Boolean
      {
         if(param1)
         {
            return this._popupLayer.contains(param1);
         }
         return false;
      }
      
      public function getCurrentPopup() : DisplayObject
      {
         var _loc1_:DisplayObject = null;
         if(this._popupLayer.numChildren > 0)
         {
            _loc1_ = this._popupLayer.getChildAt(0);
         }
         return _loc1_;
      }
      
      protected function handleTimerEvent(param1:TimerEvent) : void
      {
         this.updateTargetPosition();
      }
      
      protected function updateTargetPosition() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:Coreponent = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Point = null;
         if(this._positionUpdateReference)
         {
            _loc1_ = this.getCurrentPopup();
            if(_loc1_)
            {
               _loc2_ = this._positionUpdateReference.reference as Coreponent;
               if(_loc2_)
               {
                  _loc3_ = _loc2_.globalPosition.x;
                  _loc4_ = _loc2_.globalPosition.y;
                  _loc5_ = this._positionUpdateReference.offset as Point;
                  if(_loc5_)
                  {
                     _loc3_ += _loc5_.x;
                     _loc4_ += _loc5_.y;
                  }
                  _loc1_.x = _loc3_;
                  _loc1_.y = _loc4_;
               }
            }
         }
      }
      
      protected function handleStageResizeEvent(param1:Event) : void
      {
         clearTimeout(this._resizeTimeout);
         this._resizeTimeout = setTimeout(this.handleStageResized,RESIZE_DELAY);
      }
      
      protected function handleStageResized() : void
      {
         var _loc6_:IDataReceptible = null;
         var _loc7_:ICoreponent = null;
         var _loc8_:Point = null;
         clearTimeout(this._resizeTimeout);
         this._resizeTimeout = 0;
         var _loc1_:Stage = UISystem.getInstance().stage;
         var _loc2_:Boolean = _loc1_.displayState != StageDisplayState.NORMAL;
         var _loc3_:Number = _loc2_ ? _loc1_.fullScreenWidth : _loc1_.stageWidth;
         var _loc4_:Number = _loc2_ ? _loc1_.fullScreenHeight : _loc1_.stageHeight;
         var _loc5_:ICoreponent = this.getCurrentPopup() as ICoreponent;
         if(_loc5_)
         {
            _loc6_ = _loc5_ as IDataReceptible;
            if(_loc6_)
            {
               _loc7_ = _loc6_.data as ICoreponent;
               if(_loc7_)
               {
                  _loc8_ = _loc7_.globalPosition;
                  _loc5_.x = _loc8_.x;
                  _loc5_.y = _loc8_.y;
                  _loc5_.forceRedraw(InvalidationType.POSITION);
               }
            }
         }
      }
   }
}

