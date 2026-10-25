package net.bigpoint.darkorbit.mvc.gui.windows.chrominEvent.view
{
   import com.bigpoint.utils.TextFormatter;
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.mvc.gui.windows.chrominEvent.model.ChrominUIData;
   import net.bigpoint.darkorbit.mvc.gui.windows.chrominEvent.view.components.ChrominRootView;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.net.JavascriptProxy;
   
   public class ChrominEventWindowMediator extends SimpleWindowMediator
   {
      
      private var _data:ChrominUIData;
      
      private var _view:ChrominRootView;
      
      public function ChrominEventWindowMediator(param1:String, param2:IWindow)
      {
         super(param1,param2);
         param2.setSize(212,95);
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._view = new ChrominRootView(simpleWindow.getUIContainer());
         this.data = retrieveWindowProxy().getData() as ChrominUIData;
         this.addListeners();
      }
      
      public function set data(param1:ChrominUIData) : void
      {
         if(this._data)
         {
            this._data.changed.remove(this.update);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.changed.add(this.update);
            this.update();
         }
      }
      
      override public function onRemove() : void
      {
         this.removeListeners();
         super.onRemove();
         this.data = null;
      }
      
      private function addListeners() : void
      {
         this._view.purchaseBtn.addEventListener(MouseEvent.CLICK,this.handlePurchaseBtnClick);
      }
      
      private function removeListeners() : void
      {
         this._view.purchaseBtn.removeEventListener(MouseEvent.CLICK,this.handlePurchaseBtnClick);
      }
      
      public function update() : void
      {
         if(Boolean(this._data) && isUIReady())
         {
            this.updateCurrentValue();
            this.updateProgressBar();
            this.updateButtonVisibility();
            this.updateImagMaxVisibility();
         }
      }
      
      private function updateCurrentValue() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            this._view.chrominValue.text = TextFormatter.roundInteger(this._data.currentAmt) + "/" + TextFormatter.roundInteger(this._data.maxAmt);
         }
      }
      
      private function updateProgressBar() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            this._view.progressBar.currentValue = this._data.currentAmt / this._data.maxAmt;
         }
      }
      
      private function updateButtonVisibility() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            if(this._data.currentAmt >= this._data.maxAmt)
            {
               this._view.purchaseBtn.enabled = false;
            }
            else
            {
               this._view.purchaseBtn.enabled = true;
            }
         }
      }
      
      private function updateImagMaxVisibility() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            if(this._data.currentAmt >= this._data.maxAmt)
            {
               this._view.imgMax.visible = true;
            }
            else
            {
               this._view.imgMax.visible = false;
            }
         }
      }
      
      private function handlePurchaseBtnClick(param1:MouseEvent) : void
      {
         JavascriptProxy.call(JavascriptProxy.FUNCTION_OPEN_PAYMENT_POPUP,["chromin"]);
      }
   }
}

