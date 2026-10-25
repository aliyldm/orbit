package net.bigpoint.darkorbit.mvc.gui.windows.roguelite.view
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.com.module.RogueLiteSelectShipRequest;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.roguelite.model.RogueLiteSelectionUIData;
   import net.bigpoint.darkorbit.mvc.gui.windows.roguelite.view.components.RogueLiteSelectionRootView;
   
   public class RogueLiteSelectionUIWindowMediator extends SimpleWindowMediator
   {
      
      private var _data:RogueLiteSelectionUIData;
      
      private var _view:RogueLiteSelectionRootView;
      
      public function RogueLiteSelectionUIWindowMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
      }
      
      public function set data(param1:RogueLiteSelectionUIData) : void
      {
         if(this._data)
         {
            param1.loadoutChoiceChanged.remove(this.onLoadoutChoiceChanged);
         }
         this._data = param1;
         if(this._data)
         {
            param1.loadoutChoiceChanged.add(this.onLoadoutChoiceChanged);
         }
         this.update();
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._view = new RogueLiteSelectionRootView(simpleWindow);
         this.data = retrieveWindowProxy().getData() as RogueLiteSelectionUIData;
         this.addListeners();
      }
      
      public function update() : void
      {
         if(this._data == null || !isUIReady())
         {
            return;
         }
         this._view.shipSelectionView.shipChoices = this._data.shipSelectionData;
      }
      
      private function selectLoadout(param1:String) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new RogueLiteSelectShipRequest(param1));
      }
      
      private function onSelectLoadout(param1:Event) : void
      {
         this.selectLoadout(this._view.shipSelectionView.selectedLoadoutId);
         simpleWindow.minimize(false);
      }
      
      private function addListeners() : void
      {
         this._view.shipSelectionView.selectLoadoutButton.addEventListener(MouseEvent.CLICK,this.onSelectLoadout);
      }
      
      private function onLoadoutChoiceChanged() : void
      {
         if(!this._data || !this._view)
         {
            return;
         }
         this._view.shipSelectionView.shipChoices = this._data.shipSelectionData;
      }
   }
}

