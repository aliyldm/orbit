package net.bigpoint.darkorbit.mvc.chatclient.view
{
   import flash.events.IEventDispatcher;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatMessageVO;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatRoomVO;
   
   public interface IDOChatMessagesView extends IEventDispatcher
   {
      
      function get x() : Number;
      
      function set x(param1:Number) : void;
      
      function get y() : Number;
      
      function set y(param1:Number) : void;
      
      function get alpha() : Number;
      
      function set alpha(param1:Number) : void;
      
      function get scaleX() : Number;
      
      function set scaleX(param1:Number) : void;
      
      function get scaleY() : Number;
      
      function set scaleY(param1:Number) : void;
      
      function get width() : Number;
      
      function set width(param1:Number) : void;
      
      function get height() : Number;
      
      function set height(param1:Number) : void;
      
      function setData(param1:DOChatRoomVO) : void;
      
      function clearMessages() : void;
      
      function setScrollPositionFraction(param1:Number) : void;
      
      function getScrollPositionFraction() : Number;
      
      function scrollbarNeeded() : Boolean;
      
      function writeText(param1:DOChatMessageVO) : void;
   }
}

