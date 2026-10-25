package net.bigpoint.darkorbit.mvc.chatclient.view.richtext
{
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatUserVO;
   
   public class RichChatWhisperTabDataAssigner extends DefaultItemDataAssigner
   {
      
      private static const STYLE_TAB_DEFAULT:String = "chat_window_default_tab_center_modern_textstyle";
      
      private static const STYLE_TAB_SELECTED:String = "chat_window_active_tab_center_modern_textstyle";
      
      private static const ACTIVE_TAB_TEXT_GLOW_FILTER:Array = [new GlowFilter(16755200,0.75,2,2,1.5)];
      
      private var _tab:Coreponent;
      
      private var _text:Label;
      
      private var _closeButton:Button;
      
      public function RichChatWhisperTabDataAssigner()
      {
         super();
         initialize();
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         this.updateText();
         this.updateSelectedState();
      }
      
      private function get user() : DOChatUserVO
      {
         return data as DOChatUserVO;
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._tab = getChildByName("tab") as Coreponent;
         this._text = getChildByName("tabLabel") as Label;
         this._closeButton = getChildByName("closeTabButton") as Button;
         if(this._tab)
         {
            this._tab.useHandCursor = true;
            this._tab.buttonMode = true;
            this._tab.mouseEnabled = true;
         }
         if(this._closeButton)
         {
            this._closeButton.addEventListener(MouseEvent.CLICK,this.handleCloseClicked);
         }
         this.updateText();
         this.updateSelectedState();
      }
      
      override public function select() : void
      {
         super.select();
         this.updateSelectedState();
      }
      
      override public function unselect() : void
      {
         super.unselect();
         this.updateSelectedState();
      }
      
      override public function dispose() : void
      {
         if(this._closeButton)
         {
            this._closeButton.removeEventListener(MouseEvent.CLICK,this.handleCloseClicked);
         }
         this._closeButton = null;
         super.dispose();
      }
      
      private function updateText() : void
      {
         if(!this._text || !this.user)
         {
            return;
         }
         tooltipData = this._text.text = this.user.username;
         this._text.forceRedraw(InvalidationType.TEXT);
         this.positionCloseButton();
      }
      
      private function positionCloseButton() : void
      {
         if(!this._text || !this._closeButton)
         {
            return;
         }
         this._closeButton.x = Math.max(3,width - this._closeButton.width - 3);
         this._text.x = 3;
         this._text.width = Math.max(10,this._closeButton.x - this._text.x - 3);
      }
      
      private function updateSelectedState() : void
      {
         if(!this._tab || !this._text)
         {
            return;
         }
         this._text.registeredTextStyleName = _selected ? STYLE_TAB_SELECTED : STYLE_TAB_DEFAULT;
         this._text.filters = _selected ? ACTIVE_TAB_TEXT_GLOW_FILTER : [];
         this._text.invalidate(InvalidationType.TEXT);
         this._tab.setSkinState(_selected ? "clicked" : "normal");
      }
      
      override protected function handleButtonRollover(param1:MouseEvent) : void
      {
         super.handleButtonRollover(param1);
         if(!_selected && Boolean(this._tab))
         {
            this._tab.setSkinState("over");
         }
      }
      
      override protected function handleButtonRollout(param1:MouseEvent) : void
      {
         super.handleButtonRollout(param1);
         this.updateSelectedState();
      }
      
      private function handleCloseClicked(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         if(this.user)
         {
            dispatchEvent(new RichChatWhisperTabEvent(RichChatWhisperTabEvent.CLOSE,this.user));
         }
      }
   }
}

