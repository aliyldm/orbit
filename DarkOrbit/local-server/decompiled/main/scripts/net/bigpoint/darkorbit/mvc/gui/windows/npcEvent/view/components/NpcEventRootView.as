package net.bigpoint.darkorbit.mvc.gui.windows.npcEvent.view.components
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   
   public class NpcEventRootView
   {
      
      private var _uiContainer:Sprite;
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      public function NpcEventRootView(param1:Sprite)
      {
         super();
         this._uiContainer = param1;
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
      }
      
      public function get topDescription() : Label
      {
         return this._fuiCache.selectComponent("root.main.top.npcevent_status_msg.npcevent_status_message") as Label;
      }
      
      public function get timer() : Label
      {
         return this._fuiCache.selectComponent("root.main.top.npcevent_status_msg.npcevent_timer") as Label;
      }
      
      public function get middle() : Container
      {
         return this._fuiCache.selectComponent("root.main.top.middle") as Container;
      }
      
      public function get npcKillCountdown() : Label
      {
         return this._fuiCache.selectComponent("root.main.top.middle.left.npcevent_countdown") as Label;
      }
      
      public function get npcEventCountdownProgress() : Label
      {
         return this._fuiCache.selectComponent("root.main.top.middle.right.npcevent_progress") as Label;
      }
      
      public function get bottom() : Container
      {
         return this._fuiCache.selectComponent("root.main.bottom") as Container;
      }
      
      public function get eventDescription() : Label
      {
         return this._fuiCache.selectComponent("root.main.bottom.event_description") as Label;
      }
   }
}

