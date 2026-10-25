package Infinicast.Client.Api
{
   import Infinicast.Client.Api.Paths.AtomicChange;
   import Infinicast.Client.Api.Paths.GetDataOptions;
   import Infinicast.Client.Api.Paths.IChildrenQuery;
   import Infinicast.Client.Api.Paths.IListenerQuery;
   import Infinicast.Client.Api.Paths.IPathByListenersQuery;
   import Infinicast.Client.Api.Paths.ReminderSchedulingOptions;
   import flash.utils.Dictionary;
   
   public interface IPath
   {
      
      function get parentPathAddress() : String;
      
      function get id() : String;
      
      function get children() : IChildrenQuery;
      
      function get pathByListeners() : IPathByListenersQuery;
      
      function get listeners() : IListenerQuery;
      
      function sendMessage(param1:*, param2:Function = null) : void;
      
      function sendMessageWithRequiredListener(param1:*, param2:Function = null) : void;
      
      function setData(param1:*, param2:Function = null) : void;
      
      function getData(param1:Function, param2:GetDataOptions = null) : void;
      
      function deleteData(param1:Function = null) : void;
      
      function deleteDataAndListeners(param1:Function = null) : void;
      
      function deleteListeners(param1:Function = null) : void;
      
      function addReminder(param1:ReminderSchedulingOptions, param2:*, param3:Function = null) : void;
      
      function addOrReplaceReminder(param1:*, param2:ReminderSchedulingOptions, param3:*, param4:Function = null) : void;
      
      function deleteReminder(param1:*, param2:Function = null) : void;
      
      function sendRequest(param1:*, param2:Function) : void;
      
      function path(param1:String) : IPath;
      
      function onDataChange(param1:Function, param2:Function = null) : void;
      
      function onValidateDataChange(param1:Function, param2:Function = null) : void;
      
      function onMessage(param1:Function, param2:Function = null, param3:Function = null) : void;
      
      function onValidateMessage(param1:Function, param2:Function = null) : void;
      
      function onRequest(param1:Function, param2:Function = null) : void;
      
      function onReminder(param1:Function, param2:Function = null) : void;
      
      function onIntroduce(param1:Function, param2:Function = null) : void;
      
      function parentPath() : IPath;
      
      function extractPathParams(param1:String) : Dictionary;
      
      function pathAddressElement(param1:int) : String;
      
      function addDebugPingInfo(param1:int) : void;
      
      function addDebugMessage(param1:*, param2:*) : void;
      
      function withAdvancedOptions(param1:*) : IPath;
      
      function toString() : String;
      
      function modifyDataAtomicAndGetResult(param1:AtomicChange, param2:Function = null) : void;
      
      function modifyDataAtomic(param1:AtomicChange, param2:Function = null) : void;
      
      function modifyDataSetValue(param1:*, param2:*, param3:*) : void;
      
      function modifyDataSetValueIfEmpty(param1:*, param2:*, param3:*) : void;
      
      function modifyDataIncValue(param1:*, param2:*, param3:*) : void;
      
      function modifyDataDecValue(param1:*, param2:*, param3:*) : void;
      
      function modifyDataAddToSet(param1:*, param2:*, param3:*) : void;
      
      function modifyDataRemoveFromSet(param1:*, param2:*, param3:*) : void;
      
      function modifyDataAddToArray(param1:*, param2:*, param3:*) : void;
      
      function modifyDataRemoveFromArray(param1:*, param2:*, param3:*) : void;
      
      function modifyDataSetValueAndGetResult(param1:*, param2:*, param3:*) : void;
      
      function modifyDataSetValueIfEmptyAndGetResult(param1:*, param2:*, param3:*) : void;
      
      function modifyDataIncValueAndGetResult(param1:*, param2:*, param3:*) : void;
      
      function modifyDataDecValueAndGetResult(param1:*, param2:*, param3:*) : void;
      
      function modifyDataAddToSetAndGetResult(param1:*, param2:*, param3:*) : void;
      
      function modifyDataRemoveFromSetAndGetResult(param1:*, param2:*, param3:*) : void;
      
      function modifyDataAddToArrayAndGetResult(param1:*, param2:*, param3:*) : void;
      
      function modifyDataRemoveFromArrayAndGetResult(param1:*, param2:*, param3:*) : void;
   }
}

