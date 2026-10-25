package net.bigpoint.darkorbit.mvc.crafting.reroll.view
{
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.com.module.UnstableModuleModule;
   import net.bigpoint.darkorbit.com.module.UnstableModuleRestabiliseRequest;
   import net.bigpoint.darkorbit.com.module.porting.cannon.CannonUnstableModuleModule;
   import net.bigpoint.darkorbit.fui.components.buttons.checkbox.CheckBoxEvent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.crafting.reroll.model.RerollResultWindowData;
   import net.bigpoint.darkorbit.mvc.crafting.reroll.view.components.RerollResultRootView;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   
   public class RerollResultWindowMediator extends SimpleWindowMediator
   {
      
      private var _data:RerollResultWindowData;
      
      private var _view:RerollResultRootView;
      
      private var _salvageUM:Boolean;
      
      public function RerollResultWindowMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
         this._salvageUM = false;
      }
      
      public function set data(param1:RerollResultWindowData) : void
      {
         if(this._data)
         {
            this._data.resultChanged.remove(this.onRerollResultChanged);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.resultChanged.add(this.onRerollResultChanged);
         }
         this.update();
      }
      
      private function confirm() : void
      {
         var _loc1_:UnstableModuleRestabiliseRequest = new UnstableModuleRestabiliseRequest();
         _loc1_.isSalvage = this._salvageUM;
         _loc1_.itemId = this._data._itemId;
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc1_);
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._view = new RerollResultRootView(simpleWindow);
         this.data = retrieveWindowProxy().getData() as RerollResultWindowData;
         this.addListeners();
      }
      
      private function addListeners() : void
      {
         this._view.confirmButton.addEventListener(MouseEvent.CLICK,this.onConfirm);
         this._view.oldCheckBox.addEventListener(CheckBoxEvent.EVENT_SELECTION_CHANGED,this.oldCheckBoxSelected);
         this._view.newCheckBox.addEventListener(CheckBoxEvent.EVENT_SELECTION_CHANGED,this.newCheckBoxSelected);
         this._view.oldFrame.addEventListener(CheckBoxEvent.EVENT_SELECTION_CHANGED,this.oldFrameSelected);
         this._view.newFrame.addEventListener(CheckBoxEvent.EVENT_SELECTION_CHANGED,this.newFrameSelected);
      }
      
      private function newFrameSelected(param1:CheckBoxEvent) : void
      {
         if(this._view.newCheckBox.isSelected() != param1.selected)
         {
            this._view.newCheckBox.selection = param1.selected;
         }
      }
      
      private function oldFrameSelected(param1:CheckBoxEvent) : void
      {
         if(this._view.oldCheckBox.isSelected() != param1.selected)
         {
            this._view.oldCheckBox.selection = param1.selected;
         }
      }
      
      private function onConfirm(param1:MouseEvent) : void
      {
         this.confirm();
         simpleWindow.minimize(false,true);
      }
      
      private function newCheckBoxSelected(param1:CheckBoxEvent) : void
      {
         if(this._view.newFrame.isSelected() != param1.selected)
         {
            this._view.newFrame.selection = param1.selected;
         }
         this.newUISelected(param1.selected);
      }
      
      private function newUISelected(param1:Boolean) : void
      {
         if(param1)
         {
            this._salvageUM = false;
            this._view.oldCheckBox.selection = false;
            this._view.confirmButton.enabled = true;
         }
         else
         {
            this._view.confirmButton.enabled = false;
         }
      }
      
      private function oldCheckBoxSelected(param1:CheckBoxEvent) : void
      {
         if(this._view.oldFrame.isSelected() != param1.selected)
         {
            this._view.oldFrame.selection = param1.selected;
         }
         this.oldUISelected(param1.selected);
      }
      
      private function oldUISelected(param1:Boolean) : void
      {
         if(param1)
         {
            this._view.newCheckBox.selection = false;
            if(this._data.canSalvage)
            {
               this._salvageUM = true;
               this._view.confirmButton.enabled = true;
            }
            else
            {
               this._view.confirmButton.enabled = false;
            }
         }
         else
         {
            this._view.confirmButton.enabled = false;
         }
      }
      
      public function update() : void
      {
         if(this._data == null || !isUIReady())
         {
            return;
         }
         this.displayModuleComparison();
      }
      
      private function displayModuleComparison() : void
      {
         var _loc1_:VectorCollection = new VectorCollection(this._data.newModule.attributes);
         this._view.newStatsList.list = _loc1_;
         _loc1_ = new VectorCollection(this._data.oldModule.attributes);
         this._view.oldStatsList.list = _loc1_;
         var _loc2_:Vector.<UnstableModuleModule> = new Vector.<UnstableModuleModule>(0);
         _loc2_.push(this._data.oldModule);
         this._view.moduleList.list = new VectorCollection(_loc2_);
         this._view.moduleList.selectedIndex = 0;
         this._view.retainCostList.list = new VectorCollection(this._data.retainCostData);
         this._view.confirmButton.enabled = false;
         this._view.oldFrame.selection = this._view.newFrame.selection = false;
         if(this._data.newModule as CannonUnstableModuleModule)
         {
            this._view.oldStatsRetainCostLabel.text = "";
         }
      }
      
      private function onRerollResultChanged() : void
      {
         if(!this._data || !this._view)
         {
            return;
         }
         this.displayModuleComparison();
      }
   }
}

