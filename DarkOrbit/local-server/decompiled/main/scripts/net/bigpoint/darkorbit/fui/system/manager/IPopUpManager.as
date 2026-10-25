package net.bigpoint.darkorbit.fui.system.manager
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   
   public interface IPopUpManager
   {
      
      function add(param1:DisplayObject, param2:DisplayObject = null, param3:Point = null) : void;
      
      function remove(param1:DisplayObject) : void;
      
      function removeAll() : void;
      
      function isPopupOpen(param1:DisplayObject) : Boolean;
      
      function getCurrentPopup() : DisplayObject;
   }
}

