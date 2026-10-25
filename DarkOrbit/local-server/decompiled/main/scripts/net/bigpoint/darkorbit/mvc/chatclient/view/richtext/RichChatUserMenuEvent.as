package net.bigpoint.darkorbit.mvc.chatclient.view.richtext
{
   import flash.events.Event;
   import flash.geom.Point;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatUserVO;
   
   public class RichChatUserMenuEvent extends Event
   {
      
      public static const OPEN:String = "richChatUserMenuOpen";
      
      public static const ACTION:String = "richChatUserMenuAction";
      
      private var _user:DOChatUserVO;
      
      private var _action:String;
      
      private var _anchor:Point;
      
      public function RichChatUserMenuEvent(param1:String, param2:DOChatUserVO, param3:String = null, param4:Point = null, param5:Boolean = false)
      {
         super(param1,param5);
         this._user = param2;
         this._action = param3;
         this._anchor = param4;
      }
      
      public function get user() : DOChatUserVO
      {
         return this._user;
      }
      
      public function get action() : String
      {
         return this._action;
      }
      
      public function get anchor() : Point
      {
         return this._anchor;
      }
      
      override public function clone() : Event
      {
         return new RichChatUserMenuEvent(type,this.user,this.action,this.anchor,bubbles);
      }
   }
}

