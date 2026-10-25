package net.bigpoint.darkorbit.mvc.chatclient.controller.init
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractAsyncCommand;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatModelVO;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatProxy;
   import net.bigpoint.darkorbit.mvc.chatclient.view.DOChatDebugTextView;
   import net.bigpoint.darkorbit.mvc.chatclient.view.DOChatFUIView;
   import net.bigpoint.darkorbit.mvc.chatclient.view.DOChatMediator;
   import net.bigpoint.darkorbit.mvc.chatclient.view.IDOChatView;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class DOChatInitViewAsyncCommand extends DOAbstractAsyncCommand
   {
      
      public function DOChatInitViewAsyncCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:IDOChatView = null;
         var _loc3_:DOChatModelVO = null;
         var _loc4_:DOChatMediator = null;
         super.execute(param1);
         if(!facade.hasMediator(DOChatMediator.NAME))
         {
            _loc2_ = this.generateAndAddFUIView();
            _loc3_ = (facade.retrieveProxy(DOChatProxy.NAME) as DOChatProxy).chatModel;
            _loc4_ = new DOChatMediator(_loc2_,_loc3_);
            facade.registerMediator(_loc4_);
         }
         commandComplete();
      }
      
      private function generateAndAddDebugView() : IDOChatView
      {
         return new DOChatDebugTextView();
      }
      
      private function generateAndAddFUIView() : IDOChatView
      {
         return new DOChatFUIView();
      }
   }
}

