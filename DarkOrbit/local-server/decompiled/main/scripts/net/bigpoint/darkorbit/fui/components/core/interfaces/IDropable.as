package net.bigpoint.darkorbit.fui.components.core.interfaces
{
   import net.bigpoint.darkorbit.fui.components.core.ICoreponent;
   import net.bigpoint.darkorbit.fui.system.manager.dragNdrop.IDragProxy;
   
   public interface IDropable
   {
      
      function handleDragStart(param1:Vector.<ICoreponent>, param2:ICoreponent = null, param3:IDragProxy = null) : void;
      
      function handleDragStop(param1:Vector.<ICoreponent>, param2:ICoreponent = null, param3:IDragProxy = null) : void;
      
      function handleDragZoneEnter(param1:Vector.<ICoreponent>, param2:ICoreponent = null, param3:IDragProxy = null) : void;
      
      function handleDragZoneLeave(param1:Vector.<ICoreponent>, param2:ICoreponent = null, param3:IDragProxy = null) : void;
      
      function handleDrop(param1:Vector.<ICoreponent>, param2:ICoreponent = null, param3:IDragProxy = null) : void;
      
      function set dropenabled(param1:Boolean) : void;
      
      function set acceptedDropTypes(param1:Array) : void;
      
      function get acceptedDropTypes() : Array;
      
      function acceptType(param1:Object) : Boolean;
      
      function set receiveDropablesAllowed(param1:Boolean) : void;
      
      function canReceiveDropables() : Boolean;
   }
}

