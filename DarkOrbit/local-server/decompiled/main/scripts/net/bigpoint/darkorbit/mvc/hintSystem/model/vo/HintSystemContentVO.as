package net.bigpoint.darkorbit.mvc.hintSystem.model.vo
{
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.mvc.hintSystem.HintSystemConstants;
   import net.bigpoint.darkorbit.mvc.hintSystem.controller.hintWindow.HintSystemCloseWindowCommand;
   
   public class HintSystemContentVO
   {
      
      private var _displayTime:uint = 0;
      
      private var _title:String;
      
      private var _message:String;
      
      private var _confirmationText:String = "";
      
      private var _playlistVO:HintSystemPlaylistVO;
      
      private var _viewState:uint;
      
      private var _addToOverviewList:Boolean;
      
      private var _onOpenTriggerCommand:Class;
      
      private var _onCloseTriggerCommand:Class;
      
      private var _buttonDescriptionVOs:Dictionary;
      
      private var _paymentLink:String;
      
      public function HintSystemContentVO()
      {
         super();
         this._confirmationText = BPLocale.getItem("gameentry_hintwindow_button_confirmation");
         this._buttonDescriptionVOs = new Dictionary();
         this.registerButtonDescription(HintSystemConstants.CONFIRMATION_BUTTON_01,new HintSystemButtonActionDescriptionVO(HintSystemCloseWindowCommand));
      }
      
      public function registerButtonDescription(param1:String, param2:HintSystemButtonActionDescriptionVO) : void
      {
         if(this._buttonDescriptionVOs[param1])
         {
            this._buttonDescriptionVOs[param1] = null;
            delete this._buttonDescriptionVOs[param1];
         }
         this._buttonDescriptionVOs[param1] = param2;
      }
      
      public function getButtonDescription(param1:String) : HintSystemButtonActionDescriptionVO
      {
         return this._buttonDescriptionVOs[param1];
      }
      
      public function get title() : String
      {
         return this._title;
      }
      
      public function get message() : String
      {
         return this._message;
      }
      
      public function set title(param1:String) : void
      {
         this._title = param1;
      }
      
      public function set message(param1:String) : void
      {
         this._message = param1;
      }
      
      public function set playlistVO(param1:HintSystemPlaylistVO) : void
      {
         this._playlistVO = param1;
      }
      
      public function get playlistVO() : HintSystemPlaylistVO
      {
         return this._playlistVO;
      }
      
      public function get displayTime() : uint
      {
         return this._displayTime;
      }
      
      public function set displayTime(param1:uint) : void
      {
         this._displayTime = param1;
      }
      
      public function get viewState() : uint
      {
         return this._viewState;
      }
      
      public function set viewState(param1:uint) : void
      {
         this._viewState = param1;
      }
      
      public function get addToOverviewList() : Boolean
      {
         return this._addToOverviewList;
      }
      
      public function set addToOverviewList(param1:Boolean) : void
      {
         this._addToOverviewList = param1;
      }
      
      public function get confirmationText() : String
      {
         return this._confirmationText;
      }
      
      public function set confirmationText(param1:String) : void
      {
         this._confirmationText = param1;
      }
      
      public function get onOpenTriggeredMVCCommand() : Class
      {
         return this._onOpenTriggerCommand;
      }
      
      public function set onOpenTriggeredMVCCommand(param1:Class) : void
      {
         this._onOpenTriggerCommand = param1;
      }
      
      public function get onClosedTriggeredMVCCommand() : Class
      {
         return this._onCloseTriggerCommand;
      }
      
      public function set onClosedTriggeredMVCCommand(param1:Class) : void
      {
         this._onCloseTriggerCommand = param1;
      }
      
      public function get paymentLink() : String
      {
         return this._paymentLink;
      }
      
      public function set paymentLink(param1:String) : void
      {
         this._paymentLink = param1;
      }
   }
}

