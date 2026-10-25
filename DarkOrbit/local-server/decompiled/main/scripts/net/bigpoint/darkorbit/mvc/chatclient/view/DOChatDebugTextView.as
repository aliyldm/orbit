package net.bigpoint.darkorbit.mvc.chatclient.view
{
   import fl.controls.TextArea;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.KeyboardEvent;
   import flash.events.TextEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.ui.Keyboard;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatMessageVO;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatModelVO;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatProposalVO;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatRoomVO;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatUserVO;
   import net.bigpoint.darkorbit.utils.HtmlTextUtils;
   
   public class DOChatDebugTextView extends EventDispatcher implements IDOChatView
   {
      
      private static const COLORSTRING_USER:String = "AACCFF";
      
      private static const COLORSTRING_WHISPER:String = "FFFF00";
      
      private static const COLORSTRING_MOD:String = "FFAA00";
      
      private static const COLORSTRING_PROPOSAL:String = "FF00AA";
      
      private static const COLORSTRING_SYSTEM:String = "FFFF00";
      
      private var _myData:DOChatModelVO;
      
      private var _inputField:TextField;
      
      private var _outputField:TextArea;
      
      private var history:Vector.<String> = new Vector.<String>();
      
      private var proposalVOs:Vector.<DOChatProposalVO> = new Vector.<DOChatProposalVO>();
      
      private var currentHistoryIndex:int = 0;
      
      private var _root:DisplayObjectContainer;
      
      public function DOChatDebugTextView()
      {
         super();
         this._root = new Sprite();
         this._outputField = new TextArea();
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.color = 16777215;
         _loc1_.font = "_sans";
         _loc1_.size = 11;
         this._outputField.setStyle("textFormat",_loc1_);
         this._outputField.setStyle("defaultTextFormat",_loc1_);
         this._outputField.editable = false;
         this._outputField.width = 400;
         this._outputField.height = 300;
         this._outputField.x = 20;
         this._outputField.y = 30;
         this._inputField = new TextField();
         this._inputField.selectable = true;
         this._inputField.type = TextFieldType.INPUT;
         this._inputField.x = 20;
         this._inputField.y = 330;
         this._inputField.textColor = 16777215;
         this._inputField.border = true;
         this._inputField.borderColor = 11184810;
         this._inputField.width = 400;
         this._inputField.height = 20;
         this._inputField.addEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyDownEvent);
         this._root.addChild(this._outputField);
         this._root.addChild(this._inputField);
         if(this._root.stage)
         {
            this.handleAddedToStage(null);
         }
         else
         {
            this._root.addEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage);
         }
      }
      
      public function get root() : DisplayObjectContainer
      {
         return this._root;
      }
      
      public function updateSizes() : void
      {
         this._outputField.width = this._root.parent.parent.width - 40;
         this._outputField.height = this._root.parent.parent.height - 70;
         this._inputField.y = this._outputField.y + this._outputField.height;
         this._inputField.width = this._outputField.width;
      }
      
      public function setData(param1:DOChatModelVO) : void
      {
         var _loc2_:DOChatRoomVO = null;
         if(this._myData)
         {
            this.removeListeners();
         }
         this._myData = param1;
         for each(_loc2_ in param1.getRoomsAsVector())
         {
            _loc2_.messagesChanged.add(this.handleMessagesChanged);
         }
         this._myData.roomsChanged.add(this.handleRoomsChanged);
         this.handleMessagesChanged();
      }
      
      public function openReportView() : void
      {
      }
      
      private function usePreviousHistoryEntry() : void
      {
         --this.currentHistoryIndex;
         this._inputField.text = this.history[this.currentHistoryIndex];
      }
      
      private function useNextHistoryEntry() : void
      {
         if(this.currentHistoryIndex < this.history.length - 1)
         {
            ++this.currentHistoryIndex;
            this._inputField.text = this.history[this.currentHistoryIndex];
         }
         else
         {
            this._inputField.text = "";
         }
      }
      
      private function sendOrWhisperMessage() : void
      {
         var _loc1_:String = this._inputField.text;
         if(_loc1_.substr(0,2) == "/w")
         {
            dispatchEvent(new DOChatEvent(DOChatEvent.WHISPER_MESSAGE,_loc1_));
         }
         else
         {
            dispatchEvent(new DOChatEvent(DOChatEvent.SEND_MESSAGE,_loc1_));
         }
         this.history.push(this._inputField.text);
         if(this.history.length > 10)
         {
            this.history.shift();
         }
         this.currentHistoryIndex = this.history.length - 1;
         this._inputField.text = "";
      }
      
      private function handleRoomsChanged() : void
      {
         this.setData(this._myData);
      }
      
      private function removeListeners() : void
      {
         var _loc1_:DOChatRoomVO = null;
         this._myData.roomsChanged.remove(this.handleRoomsChanged);
         for each(_loc1_ in this._myData.getRoomsAsVector())
         {
            _loc1_.messagesChanged.remove(this.handleMessagesChanged);
         }
      }
      
      private function handleMessagesChanged() : void
      {
         var _loc2_:DOChatRoomVO = null;
         var _loc3_:String = null;
         var _loc4_:DOChatMessageVO = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc1_:String = "";
         for each(_loc2_ in this._myData.getRoomsAsVector())
         {
            _loc3_ = "============== Room " + _loc2_.path + ": " + _loc2_.name + " ==============<br>";
            if(_loc2_ == this._myData.activeRoom)
            {
               _loc3_ = HtmlTextUtils.coloriseText(16755200,_loc3_);
            }
            _loc1_ += _loc3_;
            for each(_loc4_ in _loc2_.messages)
            {
               _loc5_ = _loc4_.user.username;
               _loc6_ = COLORSTRING_USER;
               _loc7_ = "";
               _loc8_ = "%USER:";
               if(_loc4_.whisperType == DOChatMessageVO.WHISPER_TYPE_THEY)
               {
                  _loc6_ = COLORSTRING_WHISPER;
                  _loc8_ = BPLocale.getItemInCategory("chat","dochat.chat.userWhispers");
               }
               else if(_loc4_.whisperType == DOChatMessageVO.WHISPER_TYPE_YOU)
               {
                  _loc6_ = COLORSTRING_WHISPER;
                  _loc8_ = BPLocale.getItemInCategory("chat","dochat.chat.youWhisper");
               }
               else if(Boolean(_loc4_.whisperType == DOChatMessageVO.WHISPER_TYPE_NONE) && Boolean(_loc4_.user.clanTag) && _loc4_.user.clanTag != "")
               {
                  _loc7_ = "[" + _loc4_.user.clanTag + "]";
               }
               if(_loc4_.user.usertype == DOChatUserVO.TYPE_CHAT_MOD || _loc4_.user.usertype == DOChatUserVO.TYPE_ADMIN || _loc4_.user.usertype == DOChatUserVO.TYPE_SUPPORT_LEAD)
               {
                  _loc6_ = COLORSTRING_MOD;
               }
               if(_loc4_.user.usertype == DOChatUserVO.TYPE_SYSTEM)
               {
                  _loc6_ = COLORSTRING_SYSTEM;
               }
               _loc9_ = "<b> <font color=\'#" + _loc6_ + "\'>" + _loc7_ + _loc8_.replace("%USER",_loc5_) + "</font></b> " + _loc4_.message + "<br>";
               if(_loc4_ is DOChatProposalVO)
               {
                  _loc6_ = COLORSTRING_PROPOSAL;
                  this.proposalVOs.push(_loc4_);
                  _loc9_ = "<b><u><font color=\'#" + _loc6_ + "\'>" + "<a href=\"event:" + (this.proposalVOs.length - 1) + "\">" + _loc4_.message + "</a></font></u></b><br>";
               }
               _loc1_ += _loc9_;
            }
         }
         this._outputField.htmlText = _loc1_;
         this._outputField.addEventListener(TextEvent.LINK,this.handleProposalClicked);
      }
      
      private function handleAddedToStage(param1:Event) : void
      {
         if(Boolean(this._root.parent) && Boolean(this._root.parent.parent))
         {
            this._root.parent.parent.addEventListener(SimpleWindowEvent.ON_RESIZE,this.handleWindowResize);
         }
      }
      
      private function handleWindowResize(param1:SimpleWindowEvent) : void
      {
         this.updateSizes();
      }
      
      private function handleKeyDownEvent(param1:KeyboardEvent) : void
      {
         var _loc2_:DOChatRoomVO = null;
         if(param1.keyCode == Keyboard.ENTER)
         {
            if(this._inputField.text.indexOf("/switch ") == 0)
            {
               for each(_loc2_ in this._myData.getRoomsAsVector())
               {
                  if(_loc2_.name == this._inputField.text.substring("/switch ".length))
                  {
                     dispatchEvent(new DOChatEvent(DOChatEvent.ACTIVE_ROOM_SELECTION_CHANGED,_loc2_.path));
                     this._inputField.text = "";
                     break;
                  }
               }
            }
            else
            {
               this.sendOrWhisperMessage();
            }
         }
         if(param1.keyCode == Keyboard.UP && this.currentHistoryIndex > 0)
         {
            this.usePreviousHistoryEntry();
         }
         if(param1.keyCode == Keyboard.DOWN && this.currentHistoryIndex < this.history.length)
         {
            this.useNextHistoryEntry();
         }
      }
      
      private function handleProposalClicked(param1:TextEvent) : void
      {
         var _loc2_:DOChatProposalVO = this.proposalVOs[int(param1.text)];
      }
   }
}

