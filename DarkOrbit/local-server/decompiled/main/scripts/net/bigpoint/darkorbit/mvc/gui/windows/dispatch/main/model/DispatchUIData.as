package net.bigpoint.darkorbit.mvc.gui.windows.dispatch.main.model
{
   import flash.events.EventDispatcher;
   import net.bigpoint.darkorbit.com.module.DispatchActiveEventCommand;
   import net.bigpoint.darkorbit.com.module.DispatchLootMessageCommand;
   import net.bigpoint.darkorbit.com.module.DispatchMessageCommand;
   import net.bigpoint.darkorbit.com.module.LootModule;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class DispatchUIData extends EventDispatcher
   {
      
      public const messagePopup:ISignal = new Signal();
      
      public const lootMessagePopup:ISignal = new Signal();
      
      public const updateActiveEvent:ISignal = new Signal();
      
      private var _popupMessageType:int;
      
      private var _popupMessageKey:String;
      
      private var _popupMessageLootType:int;
      
      private var _popupMessageLoots:Vector.<LootModule>;
      
      private var _activeEvent:int = 0;
      
      public function DispatchUIData()
      {
         super();
      }
      
      public function showMessagePopup(param1:DispatchMessageCommand) : void
      {
         this._popupMessageType = param1.messageType;
         this._popupMessageKey = this.getMessageKey(param1.messageType);
         this.messagePopup.dispatch();
      }
      
      public function get popupMessageType() : int
      {
         return this._popupMessageType;
      }
      
      public function get popupMessageKey() : String
      {
         return this._popupMessageKey;
      }
      
      public function showLootMessagePopup(param1:DispatchLootMessageCommand) : void
      {
         this._popupMessageLootType = param1.messageType;
         this._popupMessageLoots = param1.loots;
         this.lootMessagePopup.dispatch();
      }
      
      public function get popupMessageLootType() : int
      {
         return this._popupMessageLootType;
      }
      
      public function get popupMessageLoots() : Vector.<LootModule>
      {
         return this._popupMessageLoots;
      }
      
      public function setActiveEvent(param1:DispatchActiveEventCommand) : void
      {
         this._activeEvent = param1.activeEvent;
         this.updateActiveEvent.dispatch();
      }
      
      public function get activeEvent() : int
      {
         return this._activeEvent;
      }
      
      public function getMessageKey(param1:int) : String
      {
         switch(param1)
         {
            case DispatchMessageCommand.MESSAGETYPE_DISPATCH_SUCCESS_SEND_RETRIEVER:
               return "dispatch_success-sent-retrieve";
            case DispatchMessageCommand.MESSAGETYPE_DISPATCH_SUCCESS_SEND_GATE:
               return "dispatch_success-sent-gate";
            case DispatchMessageCommand.MESSAGETYPE_DISPATCH_SUCCESS_ADD_SLOT:
               return "dispatch_success-purchased-slot";
            case DispatchMessageCommand.MESSAGETYPE_DISPATCH_ERROR_NO_GATE:
               return "dispatch_error-no-gate";
            case DispatchMessageCommand.MESSAGETYPE_DISPATCH_ERROR_NO_SLOT:
               return "dispatch_error-noslot";
            case DispatchMessageCommand.MESSAGETYPE_DISPATCH_ERROR_NO_RESOURCE:
               return "dispatch_error-noresource";
            case DispatchMessageCommand.MESSAGETYPE_DISPATCH_ERROR_NOT_READY:
               return "dispatch_error-notready";
            case DispatchMessageCommand.MESSAGETYPE_DISPATCH_ERROR_COLLECT:
               return "dispatch_error-collection";
            case DispatchMessageCommand.MESSAGETYPE_DISPATCH_ERROR_SEND_RETRIEVER:
               return "dispatch_error-send-retrieve";
            case DispatchMessageCommand.MESSAGETYPE_DISPATCH_ERROR_SEND_GATE:
               return "dispatch_error-send-gate";
            case DispatchMessageCommand.MESSAGETYPE_DISPATCH_ERROR_INCOMPLETE_GATE:
               return "dispatch_error-incomplete-gate";
            case DispatchMessageCommand.MESSAGETYPE_DISPATCH_ERROR_MAX_SLOT:
               return "dispatch_error-maxslot";
            default:
               return "";
         }
      }
   }
}

