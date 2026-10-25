package net.bigpoint.darkorbit.mvc.chatclient.view.report
{
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatMessageVO;
   
   public class ReportDataAssigner extends DefaultItemDataAssigner
   {
      
      private static const FALLBACK_CONTENT_X:Number = 40;
      
      private static const FALLBACK_CONTENT_WIDTH:Number = 380;
      
      private static const FALLBACK_CONTENT_HEIGHT:Number = 50;
      
      private static var _channelName:String = "";
      
      private static var _channelType:String = "";
      
      private var _msgLable:Label;
      
      private var _messageContainer:Container;
      
      private var _messageContent:ReportMessageContent;
      
      private var _overlay:Coreponent;
      
      private var _checkbox:Button;
      
      public function ReportDataAssigner()
      {
         super();
      }
      
      public static function configureChannel(param1:String, param2:String) : void
      {
         _channelName = param1 || "";
         _channelType = param2 || "";
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         super.data = param1;
         this.removeMessageContent();
         var _loc2_:DOChatMessageVO = param1 as DOChatMessageVO;
         if(_loc2_)
         {
            _loc3_ = Boolean(this._messageContainer) && this._messageContainer.width > 0 ? this._messageContainer.width : FALLBACK_CONTENT_WIDTH;
            _loc4_ = Boolean(this._messageContainer) && this._messageContainer.height > 0 ? this._messageContainer.height : FALLBACK_CONTENT_HEIGHT;
            this._messageContent = new ReportMessageContent(_loc2_,_loc3_,_loc4_,_channelName,_channelType);
            this._messageContent.x = Boolean(this._messageContainer) && this._messageContainer.x > 0 ? this._messageContainer.x : FALLBACK_CONTENT_X;
            this._messageContent.y = this._messageContainer ? this._messageContainer.y : 0;
            addChild(this._messageContent);
         }
         forceRedraws([InvalidationType.SIZE,InvalidationType.POSITION],true);
      }
      
      override public function set index(param1:int) : void
      {
         super.index = param1;
         skin.state = param1 % 2 == 0 ? "normal" : "dark";
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._messageContainer = FuiComponentSelectorUtil.selectComponent("labelContainer",this) as Container;
         this._msgLable = FuiComponentSelectorUtil.selectComponent("labelContainer.msg",this) as Label;
         this._overlay = FuiComponentSelectorUtil.selectComponent("overlay",this) as Coreponent;
         this._checkbox = FuiComponentSelectorUtil.selectComponent("checkbox",this) as Button;
         this._msgLable.autoSizeTextHeight = true;
         this._msgLable.visible = false;
      }
      
      override public function dispose() : void
      {
         this.removeMessageContent();
         this._messageContainer = null;
         this._msgLable = null;
         this._overlay = null;
         this._checkbox = null;
         super.dispose();
      }
      
      override protected function drawSelection() : void
      {
         super.drawSelection();
         this._checkbox.enabled = !_selected;
      }
      
      private function removeMessageContent() : void
      {
         if(Boolean(this._messageContent) && Boolean(this._messageContent.parent))
         {
            this._messageContent.parent.removeChild(this._messageContent);
         }
         this._messageContent = null;
      }
   }
}

