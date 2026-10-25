package Infinicast.Runtime.Network
{
   import Infinicast.Runtime.Network.Protocol.ByteData;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.Socket;
   import flash.utils.ByteArray;
   
   public class TcpConnector implements IConnection
   {
      
      private var socket:Socket;
      
      private var connected_:Boolean;
      
      private var handler:IConnectionEventHandler;
      
      public function TcpConnector()
      {
         super();
         this.socket = null;
         this.connected_ = false;
         this.socket = new Socket();
         this.socket.addEventListener(Event.CONNECT,this.onConnect);
         this.socket.addEventListener(Event.CLOSE,this.onClose);
         this.socket.addEventListener(IOErrorEvent.IO_ERROR,this.onError);
         this.socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
         this.socket.addEventListener(ProgressEvent.SOCKET_DATA,this.socketDataHandler);
      }
      
      public function connect(param1:String) : void
      {
         this.connected_ = false;
         var _loc2_:String = param1;
         if(_loc2_.indexOf("//") != -1)
         {
            _loc2_ = _loc2_.substring(param1.indexOf("//") + 2,_loc2_.length);
         }
         var _loc3_:String = _loc2_.substring(_loc2_.indexOf(":") + 1,_loc2_.length);
         _loc2_ = _loc2_.substring(0,_loc2_.indexOf(":"));
         this.socket.connect(_loc2_,int(_loc3_));
      }
      
      public function send(param1:ByteData) : Boolean
      {
         if(this.connected_)
         {
            this.socket.writeBytes(param1.getData());
            this.socket.flush();
         }
         return false;
      }
      
      public function disconnect() : void
      {
         this.connected_ = false;
         if(this.socket != null)
         {
            this.socket.close();
         }
      }
      
      public function getRemoteAddress() : String
      {
         return null;
      }
      
      public function initConnection() : void
      {
      }
      
      public function setHandler(param1:IConnectionEventHandler) : void
      {
         this.handler = param1;
      }
      
      private function onConnect(param1:Event) : void
      {
         this.connected_ = true;
         this.handler.onConnect();
      }
      
      private function onClose(param1:Event) : void
      {
         this.handler.onDisconnect();
         this.connected_ = false;
      }
      
      private function onError(param1:IOErrorEvent) : void
      {
         this.handler.onConnectError(param1.toString());
         this.connected_ = false;
      }
      
      internal function onSecurityError(param1:SecurityErrorEvent) : void
      {
         this.handler.onConnectError("Connection Security Error " + param1.toString());
         this.connected_ = false;
      }
      
      public function socketDataHandler(param1:ProgressEvent) : void
      {
         var _loc2_:Socket = param1.target as Socket;
         var _loc3_:ByteArray = new ByteArray();
         _loc2_.readBytes(_loc3_,0,_loc2_.bytesAvailable);
         this.handler.onReceive(_loc3_);
      }
   }
}

