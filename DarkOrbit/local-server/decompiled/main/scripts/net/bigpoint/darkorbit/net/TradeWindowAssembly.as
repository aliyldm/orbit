package net.bigpoint.darkorbit.net
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   
   public class TradeWindowAssembly
   {
      
      private var _window:SimpleWindow;
      
      private var _connectionManager:ConnectionManager;
      
      public function TradeWindowAssembly(param1:ConnectionManager, param2:SimpleWindow)
      {
         super();
         this._connectionManager = param1;
         this._window = param2;
      }
      
      public function activate() : void
      {
         this._window.addEventListener(SimpleWindowEvent.ON_MINIMIZED,this.handleTradeWindowMinimized);
         this._window.unlockWindow();
         this._window.maximize();
         this._window.setIconTooltipText("title_trade");
         GuiManager.instance.updateTradeWindow();
      }
      
      private function handleTradeWindowMinimized(param1:Event) : void
      {
         this._window.removeEventListener(SimpleWindowEvent.ON_MINIMIZED,this.handleTradeWindowMinimized);
         if(!Hero.inTradeArea)
         {
            this._window.lockWindow();
            this._window.setIconTooltipText("ttip_trade_inactive");
         }
      }
   }
}

