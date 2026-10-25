package net.bigpoint.darkorbit.mvc.gui.windows.dispatch.rewardlist.view
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.dispatch.retriever.model.DispatchRetrieverData;
   import net.bigpoint.darkorbit.mvc.gui.windows.dispatch.retriever.model.DispatchRetrieverProxy;
   
   public class DispatchRewardListMediator extends SimpleWindowMediator
   {
      
      private var _data:DispatchRetrieverData;
      
      private var _view:DispatchRewardListView;
      
      public function DispatchRewardListMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
      }
      
      override public function onRemove() : void
      {
         this.removeListeners();
         super.onRemove();
         this.data = null;
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._view = new DispatchRewardListView(simpleWindow);
         var _loc2_:DispatchRetrieverProxy = retrieveProxy(GuiConstants.DISPATCH_RETRIEVER) as DispatchRetrieverProxy;
         this.data = _loc2_.viewData;
         this.addListeners();
      }
      
      public function set data(param1:DispatchRetrieverData) : void
      {
         if(this._data)
         {
            this._data.rewardListPopup.remove(this.update);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.rewardListPopup.add(this.update);
            window.setTitle(BPLocale.getItemInCategory("base","dispatch_tooltip_header_dropChance"),false);
            this.update();
         }
      }
      
      public function update() : void
      {
         if(this._data == null || !isUIReady())
         {
            return;
         }
         this._view.labelTitle.text = this._data.rewardListName;
         this._view.list.list = new VectorCollection(this._data.rewardsList);
      }
      
      private function addListeners() : void
      {
         simpleWindow.addEventListener(SimpleWindowEvent.ON_CLOSE,this.onWindowClosed);
      }
      
      private function removeListeners() : void
      {
         simpleWindow.removeEventListener(SimpleWindowEvent.ON_CLOSE,this.onWindowClosed);
      }
      
      private function onWindowClosed(param1:SimpleWindowEvent) : void
      {
         facade.removeMediator(this.getMediatorName());
      }
   }
}

