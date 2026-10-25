package net.bigpoint.darkorbit.mvc.gui.windows.preBlackFridaySales.view
{
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.preBlackFridaySales.model.PreBlackFridaySalesUIData;
   
   public class PreBlackFridaySalesUIMediator extends SimpleWindowMediator
   {
      
      private var _data:PreBlackFridaySalesUIData;
      
      private var _view:PreBlackFridaySalesUIView;
      
      public function PreBlackFridaySalesUIMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
      }
      
      override public function onRemove() : void
      {
         super.onRemove();
         this.data = null;
      }
      
      public function set data(param1:PreBlackFridaySalesUIData) : void
      {
         if(this._data)
         {
            this._data.boughtCount.changed.remove(this.onBoughtCountUpdate);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.boughtCount.changed.add(this.onBoughtCountUpdate);
            this.update();
         }
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._view = new PreBlackFridaySalesUIView(simpleWindow.getUIContainer());
         this.data = retrieveWindowProxy().getData() as PreBlackFridaySalesUIData;
      }
      
      public function update() : void
      {
         if(this._data == null || !isUIReady())
         {
            return;
         }
         this.setLocale();
         this.onBoughtCountUpdate();
      }
      
      private function onBoughtCountUpdate() : void
      {
         if(!this._data || !this._view)
         {
            return;
         }
         this._view.resetLabel();
         this._view.setLabelBought(this._data.boughtCount.value);
      }
      
      private function setLocale() : void
      {
         if(!this._data || !this._view)
         {
            return;
         }
         this._view.description.localizedText = this._data.description;
         var _loc1_:int = 0;
         while(_loc1_ < this._view.packs.length)
         {
            this._view.packs[_loc1_].text = this._data.packs[_loc1_];
            _loc1_++;
         }
         this._view.header.localizedText = this._data.header;
         _loc1_ = 0;
         while(_loc1_ < this._view.counts.length)
         {
            this._view.counts[_loc1_].localizedText = this._data.counts[_loc1_];
            this._view.percents[_loc1_].localizedText = this._data.percents[_loc1_];
            _loc1_++;
         }
      }
   }
}

