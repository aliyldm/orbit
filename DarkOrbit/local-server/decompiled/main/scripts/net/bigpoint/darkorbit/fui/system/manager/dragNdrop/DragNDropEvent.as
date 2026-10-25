package net.bigpoint.darkorbit.fui.system.manager.dragNdrop
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.fui.components.core.ICoreponent;
   
   public class DragNDropEvent extends Event
   {
      
      public static const DRAG_START_EVENT:String = "drag.StartEvent";
      
      public static const DRAG_STOP_EVENT:String = "drag.EndEvent";
      
      public static const DRAG_LEAVE_EVENT:String = "drag.LeaveEvent";
      
      public static const DRAG_ENTER_EVENT:String = "drag.EnterEvent";
      
      public static const DROP_EVENT:String = "drop.Event";
      
      private var _dropables:Vector.<ICoreponent>;
      
      private var _dropableTarget:ICoreponent;
      
      private var _parentDraggableCoreponent:ICoreponent;
      
      private var _dragProxy:IDragProxy;
      
      public function DragNDropEvent(param1:String, param2:Vector.<ICoreponent> = null, param3:ICoreponent = null, param4:IDragProxy = null)
      {
         super(param1);
         this._dragProxy = param4;
         this._dropables = param2;
         this._parentDraggableCoreponent = param3;
      }
      
      public function get parentDraggableCoreponent() : ICoreponent
      {
         return this._parentDraggableCoreponent;
      }
      
      public function get dragProxy() : IDragProxy
      {
         return this._dragProxy;
      }
      
      public function get dropables() : Vector.<ICoreponent>
      {
         return this._dropables;
      }
      
      public function get dropableTarget() : ICoreponent
      {
         return this._dropableTarget;
      }
      
      public function set dropableTarget(param1:ICoreponent) : void
      {
         this._dropableTarget = param1;
      }
   }
}

