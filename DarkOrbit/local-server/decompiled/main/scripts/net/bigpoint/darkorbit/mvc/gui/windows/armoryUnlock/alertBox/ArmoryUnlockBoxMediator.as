package net.bigpoint.darkorbit.mvc.gui.windows.armoryUnlock.alertBox
{
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.com.module.RewardModule;
   import net.bigpoint.darkorbit.delete_in_eic.IconVOLoader;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   
   public class ArmoryUnlockBoxMediator extends SimpleWindowMediator
   {
      
      protected var proxy:ArmoryUnlockBoxProxy;
      
      private var _view:ArmoryUnlockBoxView;
      
      private var _window:SimpleWindow;
      
      private var ok_btn:Button;
      
      public function ArmoryUnlockBoxMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
         this._window = param2;
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this.proxy = new ArmoryUnlockBoxProxy(GuiConstants.ARMORY_UNLOCK_ALERT);
         this.facade.registerProxy(this.proxy);
         this.proxy.viewData.changed.add(this.onViewDataChanged);
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._view = new ArmoryUnlockBoxView(simpleWindow);
         this.ok_btn = this._view.ok_btn;
         this.ok_btn.addEventListener(MouseEvent.MOUSE_DOWN,this.onOkClick);
         this.onViewDataChanged();
      }
      
      private function onViewDataChanged() : void
      {
         var _loc2_:int = 0;
         var _loc3_:RewardModule = null;
         var _loc4_:ItemVO = null;
         var _loc5_:Coreponent = null;
         var _loc6_:Label = null;
         if(!this._view)
         {
            return;
         }
         this._view.hiddenAllItems();
         var _loc1_:* = this.proxy.viewData.rewardModuleList;
         _loc2_ = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_];
            _loc4_ = ItemDataProviderHelper.getItem(_loc3_.lootId);
            _loc5_ = this._view._items[_loc2_];
            _loc5_.visible = true;
            _loc5_.mouseEnabled = true;
            IconVOLoader.getInstance().loadIcon(_loc5_,_loc4_,"100x100",AssetsProxy.ITEMS);
            _loc5_.tooltipData = "" + _loc4_.fullname;
            _loc6_ = this._view._labels[_loc2_];
            _loc6_.visible = true;
            _loc6_.text = "x" + _loc3_.amount;
            _loc2_++;
         }
      }
      
      private function onOkClick(param1:MouseEvent) : void
      {
         this._window.minimize();
         this._window.activateModalLayer(false);
         this._view.hiddenAllItems();
      }
   }
}

