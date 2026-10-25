package net.bigpoint.darkorbit.mvc.chatclient.view
{
   import flash.events.IEventDispatcher;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatModelVO;
   
   public interface IDOChatView extends IEventDispatcher
   {
      
      function setData(param1:DOChatModelVO) : void;
      
      function openReportView() : void;
   }
}

