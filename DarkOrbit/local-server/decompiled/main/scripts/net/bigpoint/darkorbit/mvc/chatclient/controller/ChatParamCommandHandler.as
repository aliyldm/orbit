package net.bigpoint.darkorbit.mvc.chatclient.controller
{
   import flash.system.Security;
   import net.bigpoint.darkorbit.com.module.porting.TupleTwoModule;
   import net.bigpoint.darkorbit.com.module.porting.chat.ChatParamCommand;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatProxy;
   import net.bigpoint.darkorbit.mvc.chatclient.model.backend.ChatSettings;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class ChatParamCommandHandler extends BaseHandler
   {
      
      public function ChatParamCommandHandler()
      {
         super();
      }
      
      public static function run(param1:ChatParamCommand) : void
      {
         var _loc4_:TupleTwoModule = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.moduleList.length)
         {
            _loc4_ = param1.moduleList[_loc2_];
            if(_loc4_.param0 == "chat_ip")
            {
               ChatSettings.server = _loc4_.param1;
            }
            else if(_loc4_.param0 == "chat_cross_ip")
            {
               ChatSettings.chat_cross_ip = _loc4_.param1;
            }
            _loc2_++;
         }
         if(!ChatSettings.isNew)
         {
            ChatSettings.chat_cross_ip = ChatSettings.addressNoPort;
         }
         if(ChatSettings.chat_cross_ip != "")
         {
            Security.loadPolicyFile(ChatSettings.chat_cross_ip);
         }
         var _loc3_:DOChatProxy = GameFacade.getInstance().retrieveProxy(DOChatProxy.NAME) as DOChatProxy;
         if(_loc3_)
         {
            _loc3_.reconnect();
         }
      }
   }
}

