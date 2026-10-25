package net.bigpoint.darkorbit.mvc.ccCommands.model
{
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.model.DOAbstractProxy;
   import net.bigpoint.darkorbit.net.netty.record.AbstractRecorder;
   import net.bigpoint.darkorbit.net.netty.record.RecordEvent;
   import net.bigpoint.darkorbit.net.netty.record.RequestRecorder;
   import net.bigpoint.darkorbit.net.netty.record.ServerCommandRecorder;
   
   public class CCClientServerCommunicationProxy extends DOAbstractProxy
   {
      
      public static const NAME:String = "CCClientServerCommunicationProxy";
      
      public static const NOFICATION_SERVERCOMMAND_ADDED:String = "NOFICATION_SERVERCOMMAND_ADDED";
      
      public static const NOFICATION_CLIENTREQUEST_ADDED:String = "NOFICATION_CLIENTREQUEST_ADDED";
      
      private var requestsModel:RequestRecorder;
      
      private var serverCommandsModel:ServerCommandRecorder;
      
      public function CCClientServerCommunicationProxy(param1:Object = null)
      {
         super(NAME,param1);
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this.requestsModel = RequestRecorder.INSTANCE;
         this.requestsModel.addEventListener(AbstractRecorder.RECORD_ADDED,this.handleRequestListChangedEvent);
         this.serverCommandsModel = ServerCommandRecorder.INSTANCE;
         this.serverCommandsModel.addEventListener(AbstractRecorder.RECORD_ADDED,this.handleServerCommandsListChangedEvent);
      }
      
      private function handleServerCommandsListChangedEvent(param1:RecordEvent) : void
      {
         sendNotification(NOFICATION_SERVERCOMMAND_ADDED,param1.getData());
      }
      
      private function handleRequestListChangedEvent(param1:RecordEvent) : void
      {
         sendNotification(NOFICATION_CLIENTREQUEST_ADDED,param1.getData());
      }
   }
}

