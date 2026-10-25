package Infinicast.Runtime
{
   import Infinicast.Runtime.Network.IConnectionEventHandler;
   import Infinicast.Runtime.Network.Protocol.ByteData;
   import Infinicast.Runtime.Network.Protocol.LowLevelIntroductionMessage;
   import Infinicast.Runtime.Network.Protocol.LowLevelPongMessage;
   import Infinicast.Runtime.Network.Protocol.MessageReader;
   import Infinicast.Runtime.Network.Protocol.MessageWriter;
   import Infinicast.Runtime.Network.Protocol.ProtocolDecoder;
   import Infinicast.Runtime.Network.Protocol.ProtocolEncoder;
   import Infinicast.Runtime.Network.TcpConnectorClient;
   import flash.utils.ByteArray;
   
   public class TcpEndpoint2ServerNetLayer implements IEndpoint2ServerNetLayer, IConnectionEventHandler
   {
      
      private var connection:TcpConnectorClient;
      
      private var settings:Endpoint2ServerNetSettings;
      
      private var encoder:ProtocolEncoder;
      
      private var decoder:ProtocolDecoder;
      
      private var oldData:ByteArray = null;
      
      public function TcpEndpoint2ServerNetLayer()
      {
         super();
      }
      
      public function Open(param1:Endpoint2ServerNetSettings) : String
      {
         this.encoder = new ProtocolEncoder();
         this.decoder = new ProtocolDecoder();
         this.settings = param1;
         this.connection = new TcpConnectorClient();
         this.connection.setHandler(this);
         this.connection.connect(param1.ServerAddress.Address);
         return null;
      }
      
      public function Close() : void
      {
         this.connection.disconnect();
      }
      
      public function SendToServer(param1:APlayStringMessage) : void
      {
         var _loc2_:MessageWriter = new MessageWriter();
         this.encoder.Encode(param1,_loc2_);
         this.connection.send(ByteData.FromWriter(_loc2_));
      }
      
      public function onConnect() : void
      {
         var _loc1_:MessageWriter = new MessageWriter();
         _loc1_.write_int8(42);
         _loc1_.write_int8(1);
         this.connection.send(ByteData.FromWriter(_loc1_));
      }
      
      public function onConnectError(param1:String) : void
      {
         this.settings.Handler.onDisconnect();
      }
      
      public function onDisconnect() : void
      {
         this.settings.Handler.onDisconnect();
      }
      
      public function onReceive(param1:ByteArray) : void
      {
         var _loc3_:ByteArray = null;
         var _loc4_:Object = null;
         var _loc5_:MessageWriter = null;
         if(this.oldData != null)
         {
            _loc3_ = new ByteArray();
            _loc3_.length = param1.length + this.oldData.length;
            _loc3_.writeBytes(this.oldData);
            _loc3_.writeBytes(param1);
            _loc3_.position = 0;
            param1 = _loc3_;
            this.oldData = null;
         }
         var _loc2_:MessageReader = new MessageReader(param1);
         while(param1.bytesAvailable > 0)
         {
            _loc4_ = this.decoder.DoDecode(_loc2_);
            if(_loc4_ == null)
            {
               this.oldData = new ByteArray();
               this.oldData.length = param1.length - param1.position;
               this.oldData.writeBytes(param1,param1.position,param1.length - param1.position);
               this.oldData.position = 0;
               break;
            }
            if(_loc4_ is LowLevelIntroductionMessage)
            {
               this.settings.Handler.onConnect();
            }
            else if(_loc4_ is LowLevelPongMessage)
            {
               _loc5_ = new MessageWriter();
               this.encoder.Encode(_loc4_,_loc5_);
               this.connection.send(ByteData.FromWriter(_loc5_));
            }
            else if(_loc4_ is APlayStringMessage)
            {
               this.settings.Handler.onReceiveFromServer(_loc4_ as APlayStringMessage);
            }
         }
      }
   }
}

