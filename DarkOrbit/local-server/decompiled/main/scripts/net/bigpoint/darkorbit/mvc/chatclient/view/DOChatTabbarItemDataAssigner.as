package net.bigpoint.darkorbit.mvc.chatclient.view
{
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatRoomVO;
   import net.bigpoint.darkorbit.mvc.common.view.components.NotificationCountBadge;
   
   public class DOChatTabbarItemDataAssigner extends DefaultItemDataAssigner
   {
      
      private static const BADGE_MARGIN:Number = 2;
      
      private static const STYLE_TAB_DEFAULT:String = "chat_window_default_tab_center_modern_textstyle";
      
      private static const STYLE_TAB_HOVER:String = "chat_window_default_tab_center_modern_textstyle";
      
      private static const STYLE_TAB_SELECTED:String = "chat_window_active_tab_center_modern_textstyle";
      
      private static const ACTIVE_TAB_TEXT_GLOW_FILTER:Array = [new GlowFilter(16755200,0.75,2,2,1.5)];
      
      private var _tab:Coreponent;
      
      private var _text:Label;
      
      private var _notificationBadge:NotificationCountBadge;
      
      public function DOChatTabbarItemDataAssigner()
      {
         super();
         initialize();
      }
      
      override public function set data(param1:Object) : void
      {
         if(this.room)
         {
            this.room.messagesChanged.remove(this.handleMessagesChanged);
            this.room.unreadChanged.remove(this.handleMessagesChanged);
         }
         super.data = param1;
         if(this.room)
         {
            if(this._text)
            {
               tooltipData = this._text.text = this.room.translatedName;
               this._text.forceRedraw(InvalidationType.SKIN);
            }
            this.room.messagesChanged.add(this.handleMessagesChanged);
            this.room.unreadChanged.add(this.handleMessagesChanged);
            this.handleRoomActiveChanged();
            this.handleMessagesChanged();
         }
      }
      
      private function get room() : DOChatRoomVO
      {
         return data as DOChatRoomVO;
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._tab = getChildByName("tab") as Coreponent;
         this._text = getChildByName("tabLabel") as Label;
         if(!this._notificationBadge)
         {
            this._notificationBadge = new NotificationCountBadge();
            this._notificationBadge.mouseEnabled = false;
            this._notificationBadge.mouseChildren = false;
         }
         this._notificationBadge.showCount = false;
         if(this._notificationBadge.parent != this._tab)
         {
            this._tab.addChild(this._notificationBadge);
         }
         if(this.room)
         {
            this._text.text = this.room.translatedName;
         }
         this._tab.useHandCursor = true;
         this._tab.buttonMode = true;
         this._tab.mouseEnabled = true;
      }
      
      override public function select() : void
      {
         super.select();
         this.handleRoomActiveChanged();
      }
      
      override public function unselect() : void
      {
         super.unselect();
         this.handleRoomActiveChanged();
      }
      
      private function handleRoomActiveChanged() : void
      {
         if(_selected)
         {
            this.changeTextStyleTo(STYLE_TAB_SELECTED);
            this._tab.setSkinState("clicked");
            this._text.filters = ACTIVE_TAB_TEXT_GLOW_FILTER;
         }
         if(!_selected)
         {
            this.changeTextStyleTo(STYLE_TAB_DEFAULT);
            this._tab.setSkinState("normal");
            this._text.filters = [];
         }
      }
      
      private function handleMessagesChanged() : void
      {
         var _loc1_:Number = NaN;
         if(this._notificationBadge)
         {
            this._notificationBadge.count = Boolean(!_selected && this.room) && Boolean(this.room.type != DOChatRoomVO.TYPE_NORMAL) && this.room.hasUnreadMessages ? 1 : 0;
            _loc1_ = this._tab.width > 0 ? this._tab.width : 100;
            this._notificationBadge.x = _loc1_ - this._notificationBadge.width - BADGE_MARGIN;
            this._notificationBadge.y = BADGE_MARGIN;
         }
      }
      
      private function changeTextStyleTo(param1:String) : void
      {
         this._text.registeredTextStyleName = param1;
         this._text.invalidate(InvalidationType.TEXT);
      }
      
      override protected function handleButtonRollover(param1:MouseEvent) : void
      {
         super.handleButtonRollover(param1);
         if(!_selected)
         {
            this.changeTextStyleTo(STYLE_TAB_HOVER);
            this._tab.setSkinState("over");
         }
      }
      
      override protected function handleButtonRollout(param1:MouseEvent) : void
      {
         super.handleButtonRollout(param1);
         this.handleRoomActiveChanged();
      }
   }
}

