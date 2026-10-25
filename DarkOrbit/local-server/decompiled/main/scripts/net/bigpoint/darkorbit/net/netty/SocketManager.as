package net.bigpoint.darkorbit.net.netty
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.Socket;
   import flash.utils.Endian;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.utils.math.FastMath;
   import net.bigpoint.eventstream.EventStreamClient;
   
   public class SocketManager extends EventDispatcher
   {
      
      private static var ID:int = 1;
      
      public static const CONNECTION_LOST:String = FastMath.getRandomBySeed(++ID).toString();
      
      public static const CONNECTION_ERROR:String = FastMath.getRandomBySeed(++ID).toString();
      
      public static const CONNECTION_SUCCESS:String = FastMath.getRandomBySeed(++ID).toString();
      
      public var socket:Socket;
      
      private var port:int;
      
      private var host:String;
      
      private var handler:CommandHandler;
      
      private var isConnecting:Boolean = false;
      
      private var _disabled:Boolean = false;
      
      public function SocketManager()
      {
         super();
         this.handler = new CommandHandler();
         this.handler.executeHandler = HandlerLookup.execute;
         HandlerLookup.init();
      }
      
      public function disable() : void
      {
         this._disabled = true;
      }
      
      public function sendMessage(param1:IModule) : void
      {
         if(this.isConnected())
         {
            this.handler.sendMessage(param1);
         }
      }
      
      public function connect(param1:String, param2:int) : void
      {
         if(this.isConnecting)
         {
            return;
         }
         this.isConnecting = true;
         this.host = param1;
         this.port = param2;
         EventStreamClient.track("flash_socket_connect",{
            "url":param1,
            "port":param2
         });
         this.initSocket(param1,param2,this.onInitSocket);
      }
      
      private function initSocket(param1:String, param2:int, param3:Function) : void
      {
         var host:String = param1;
         var port:int = param2;
         var callback:Function = param3;
         if(this.socket != null && this.socket.connected)
         {
            this.removeListeners();
            this.disconnect();
         }
         this.socket = null;
         try
         {
            this.socket = new Socket(host,port);
            this.socket.endian = Endian.BIG_ENDIAN;
         }
         catch(error:Error)
         {
            socket.close();
            throw new Error("initSocket create new socket " + error.message);
         }
         finally
         {
            this.initHandler();
            this.addListeners();
         }
      }
      
      private function onInitSocket() : void
      {
         this.socket.connect(this.host,this.port);
      }
      
      private function initHandler() : void
      {
         this.handler.setSocket(this.socket);
      }
      
      public function disconnect() : void
      {
         if(Boolean(this.socket) && this.socket.connected)
         {
            this.socket.close();
            this.removeListeners();
         }
      }
      
      public function isConnected() : Boolean
      {
         if(this.socket == null)
         {
            return false;
         }
         return this.socket.connected;
      }
      
      private function handleSocketData(param1:ProgressEvent) : void
      {
         if(!this._disabled)
         {
            this.handler.readData();
         }
      }
      
      private function handleConnectionLost(param1:Event = null) : void
      {
         EventStreamClient.track("flash_socket_connectionLost");
         dispatchEvent(new Event(CONNECTION_LOST));
      }
      
      private function handleIOError(param1:IOErrorEvent) : void
      {
         EventStreamClient.track("flash_socket_ioError");
         this.isConnecting = false;
         dispatchEvent(new Event(CONNECTION_ERROR));
      }
      
      private function handleSecurityError(param1:SecurityErrorEvent) : void
      {
         EventStreamClient.track("flash_socket_securityError");
         this.isConnecting = false;
         dispatchEvent(new Event(CONNECTION_ERROR));
      }
      
      private function handleConnect(param1:Event) : void
      {
         EventStreamClient.track("flash_socket_connected");
         this.isConnecting = false;
         this.socket.writeByte(0);
         dispatchEvent(new Event(CONNECTION_SUCCESS));
      }
      
      private function addListeners() : void
      {
         if(!this.socket.hasEventListener(Event.CONNECT))
         {
            this.socket.addEventListener(Event.CONNECT,this.handleConnect);
            this.socket.addEventListener(ProgressEvent.SOCKET_DATA,this.handleSocketData);
            this.socket.addEventListener(Event.CLOSE,this.handleConnectionLost);
            this.socket.addEventListener(IOErrorEvent.IO_ERROR,this.handleIOError);
            this.socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleSecurityError);
         }
      }
      
      private function removeListeners() : void
      {
         if(this.socket.hasEventListener(Event.CONNECT))
         {
            this.socket.removeEventListener(Event.CONNECT,this.handleConnect);
            this.socket.removeEventListener(ProgressEvent.SOCKET_DATA,this.handleSocketData);
            this.socket.removeEventListener(Event.CLOSE,this.handleConnectionLost);
            this.socket.removeEventListener(IOErrorEvent.IO_ERROR,this.handleIOError);
            this.socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleSecurityError);
         }
      }
      
      public function outputCommand(param1:IModule) : void
      {
      }
      
      public function get commandHandler() : CommandHandler
      {
         return this.handler;
      }
   }
}

