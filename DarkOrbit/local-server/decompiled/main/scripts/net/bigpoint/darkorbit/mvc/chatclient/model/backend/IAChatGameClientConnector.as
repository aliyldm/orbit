package net.bigpoint.darkorbit.mvc.chatclient.model.backend
{
   import Infinicast.Client.Api.IInfinicastClient;
   
   public interface IAChatGameClientConnector
   {
      
      function connect(param1:String, param2:String, param3:String) : void;
      
      function disconnect() : void;
      
      function setOnEndpointIdChange(param1:Function) : void;
      
      function setWhisperId(param1:String) : void;
      
      function setOnConnectionStatusChange(param1:Function) : void;
      
      function setOnBanFunc(param1:Function) : void;
      
      function setOnSystemDefinedRoomChange(param1:Function) : void;
      
      function setOnServerStatusInfo(param1:Function) : void;
      
      function setOnChatMessage(param1:Function, param2:Function = null) : void;
      
      function setOnRoomListeningRemovedByServer(param1:Function) : void;
      
      function setOnWhisper(param1:Function) : void;
      
      function sendChatMessageToRoomPath(param1:String, param2:String, param3:Function) : void;
      
      function sendChatMessageToRoomType(param1:String, param2:String, param3:Function) : void;
      
      function sendWhisper(param1:String, param2:String, param3:Function) : void;
      
      function getUserListByRoomType(param1:String, param2:Function) : void;
      
      function getUserListByRoomPath(param1:String, param2:Function) : void;
      
      function getRoomPath(param1:String, param2:String) : String;
      
      function setOnReceiveUserRoomInvite(param1:Function) : void;
      
      function acceptUserRoomInvite(param1:String, param2:Function) : void;
      
      function createUserRoom(param1:String, param2:Function) : void;
      
      function inviteChatterToUserRoom(param1:String, param2:String, param3:Function) : void;
      
      function removeChatterFromUserRoom(param1:String, param2:String, param3:Function) : void;
      
      function closeUserRoom(param1:String, param2:Function) : void;
      
      function setUnhandeledErrorFunc(param1:Function) : void;
      
      function getInfinicast() : IInfinicastClient;
   }
}

