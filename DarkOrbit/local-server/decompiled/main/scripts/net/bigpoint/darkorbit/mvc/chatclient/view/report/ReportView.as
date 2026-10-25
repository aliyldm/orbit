package net.bigpoint.darkorbit.mvc.chatclient.view.report
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListEvent;
   import net.bigpoint.darkorbit.fui.components.scroll.ScrollContainer;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.fui.system.utils.FuiPopUpUtils;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatMessageVO;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatReportVO;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatRoomVO;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatUserVO;
   import net.bigpoint.darkorbit.mvc.chatclient.model.backend.ChatSettings;
   import net.bigpoint.darkorbit.mvc.chatclient.view.DOChatEvent;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   
   public class ReportView
   {
      
      private var _data:DOChatRoomVO;
      
      private var _ready:Boolean;
      
      private var _window:SimpleWindow;
      
      private var _originalMessages:Vector.<DOChatMessageVO>;
      
      private var _targetUsername:String;
      
      private var _view:Sprite;
      
      public function ReportView()
      {
         super();
      }
      
      public function get view() : Sprite
      {
         return this._view;
      }
      
      private function get messageList() : ItemList
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.msgContainer.messages",this._view) as ItemList;
      }
      
      private function get reasonList() : ItemList
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.reasonContainer.reasons",this._view) as ItemList;
      }
      
      private function get reasonDetails() : Label
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.reasonContainer.chat_report_reason_desc_container.content",this._view) as Label;
      }
      
      private function get reasonContainer() : ScrollContainer
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.reasonContainer.chat_report_reason_desc_container",this._view) as ScrollContainer;
      }
      
      private function get helpIcon() : Coreponent
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.reasonContainer.chat_report_reason_help",this._view) as Coreponent;
      }
      
      private function get confirmBTN() : Button
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.report_button_container.report",this._view) as Button;
      }
      
      private function get cancelBTN() : Button
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.report_button_container.cancel",this._view) as Button;
      }
      
      public function showReportView(param1:DOChatRoomVO, param2:String = null) : void
      {
         this._data = param1;
         this._targetUsername = param2;
         this.createOriginalData();
         if(!this._view)
         {
            this._view = new Sprite();
            UISystem.getInstance().loadAndBuildWithResKey("chatReportUI",this._view,this.handleReportComplete);
         }
         if(!this._window)
         {
            this._window = GuiManager.instance.createWindow(GuiConstants.CHAT_REPORT) as SimpleWindow;
            this._window.getContainer(0).addChild(this._view);
         }
         this._window.maximize(false);
         this.update();
      }
      
      public function hide(... rest) : void
      {
         this._view.visible = true;
         this.messageList.deselectAll();
         if(this._window)
         {
            this._window.minimize(false);
         }
      }
      
      private function createOriginalData() : void
      {
         var _loc3_:DOChatMessageVO = null;
         this._originalMessages = this._data.messages.concat();
         var _loc1_:int = int(this._originalMessages.length);
         var _loc2_:* = int(_loc1_ - 1);
         while(_loc2_ >= 0)
         {
            _loc3_ = this._originalMessages[_loc2_];
            if(_loc3_.user.usertype == DOChatUserVO.TYPE_SYSTEM)
            {
               this._originalMessages.splice(_loc2_,1);
            }
            _loc2_--;
         }
      }
      
      private function update() : void
      {
         var _loc4_:DOChatMessageVO = null;
         if(!this._ready || !this._data)
         {
            return;
         }
         this.messageList.deselectAll();
         this.reasonList.deselectAll();
         ReportDataAssigner.configureChannel(this._data.translatedName,this._data.type);
         var _loc1_:Vector.<DOChatMessageVO> = this._data.messages.concat().reverse();
         var _loc2_:int = int(_loc1_.length);
         var _loc3_:* = int(_loc2_ - 1);
         while(_loc3_ >= 0)
         {
            _loc4_ = _loc1_[_loc3_];
            if(_loc4_.user.usertype == DOChatUserVO.TYPE_SYSTEM || _loc4_.user.usertype == DOChatUserVO.TYPE_CMD || _loc4_.whisperType == DOChatMessageVO.WHISPER_TYPE_YOU || ChatSettings.userName == _loc4_.user.username)
            {
               _loc1_.splice(_loc3_,1);
            }
            _loc3_--;
         }
         this.messageList.list = new VectorCollection(_loc1_);
         this.selectTargetMessage(_loc1_);
         this.updateConfirmBTN();
         this.handleReasonSelectionChanged();
      }
      
      private function selectTargetMessage(param1:Vector.<DOChatMessageVO>) : void
      {
         if(!this._targetUsername)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            if(param1[_loc2_].user.username == this._targetUsername)
            {
               this.messageList.selectedIndex = _loc2_;
               return;
            }
            _loc2_++;
         }
      }
      
      private function handleReportComplete() : void
      {
         this.messageList.itemDataAssigner = ReportDataAssigner;
         this.messageList.addEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.updateConfirmBTN);
         this.reasonList.itemDataAssigner = ReasonDataAssigner;
         this.reasonList.list = new VectorCollection(new <ReasonVO>[new ReasonVO("reason_spam"),new ReasonVO("reason_bad_name"),new ReasonVO("reason_abusive_chat")]);
         this.reasonList.addEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.handleReasonSelectionChanged);
         this.confirmBTN.addEventListener(MouseEvent.CLICK,this.handleReportClicked);
         this.cancelBTN.addEventListener(MouseEvent.CLICK,this.handleCancelClicked);
         this._ready = true;
         this.update();
      }
      
      private function report(... rest) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:* = 0;
         var _loc9_:DOChatMessageVO = null;
         this._view.visible = true;
         var _loc2_:DOChatMessageVO = this.messageList.selectedItem ? this.messageList.selectedItem.data as DOChatMessageVO : null;
         var _loc3_:ReasonVO = this.reasonList.selectedItemData as ReasonVO;
         if(Boolean(_loc2_) && Boolean(_loc3_))
         {
            _loc4_ = this._originalMessages.indexOf(_loc2_);
            if(_loc4_ != -1)
            {
               _loc5_ = new Array();
               _loc6_ = Math.max(_loc4_,0);
               _loc7_ = Math.max(Math.min(this._originalMessages.length,_loc6_ - 10),0);
               _loc8_ = _loc6_;
               while(_loc8_ >= _loc7_)
               {
                  _loc9_ = this._originalMessages[_loc8_] as DOChatMessageVO;
                  if(_loc8_ == _loc6_)
                  {
                     _loc5_.push("<< [" + _loc9_.user.username + "] " + _loc9_.message + ">>");
                  }
                  else
                  {
                     _loc5_.push("[" + _loc9_.user.username + "] " + _loc9_.message);
                  }
                  _loc8_--;
               }
               this.view.dispatchEvent(new DOChatEvent(DOChatEvent.REPORT,new DOChatReportVO(_loc2_.user,_loc5_,this._data.path,_loc3_.toString(),_loc3_.key)));
            }
         }
         this.hide();
         FuiPopUpUtils.createPopupOk(null,null,BPLocale.getItemInCategory("chat","chat_confirm_statement"));
      }
      
      private function updateConfirmBTN(param1:ItemListEvent = null) : void
      {
         this.confirmBTN.enabled = Boolean(this.messageList.selectedItemData) && Boolean(this.reasonList.selectedItemData);
      }
      
      private function handleReasonSelectionChanged(param1:ItemListEvent = null) : void
      {
         var _loc2_:ReasonVO = this.reasonList.selectedItemData ? this.reasonList.selectedItemData as ReasonVO : null;
         if(_loc2_)
         {
            this.helpIcon.visible = true;
            this.reasonDetails.text = BPLocale.getItemInCategory("chat",_loc2_.key + "_details");
         }
         else
         {
            this.reasonDetails.text = "";
            this.helpIcon.visible = false;
         }
         this.reasonContainer.invalidate(InvalidationType.SIZE);
         this.updateConfirmBTN();
      }
      
      private function handleCancelClicked(param1:MouseEvent) : void
      {
         this.hide();
      }
      
      private function handleReportClicked(param1:MouseEvent) : void
      {
         var _loc4_:String = null;
         var _loc2_:DOChatMessageVO = this.messageList.selectedItem ? this.messageList.selectedItem.data as DOChatMessageVO : null;
         var _loc3_:ReasonVO = this.reasonList.selectedItemData as ReasonVO;
         if(Boolean(_loc2_) && Boolean(_loc3_))
         {
            this._view.visible = false;
            _loc4_ = BPLocale.getItemInCategory("chat","chat_confirm_report").replace("%USERNAME%",_loc2_.user.username).replace("%REASON%",_loc3_.toString());
            FuiPopUpUtils.createPopupOkCancel(this.report,this.hide,_loc4_);
         }
         else
         {
            this.hide();
         }
      }
   }
}

