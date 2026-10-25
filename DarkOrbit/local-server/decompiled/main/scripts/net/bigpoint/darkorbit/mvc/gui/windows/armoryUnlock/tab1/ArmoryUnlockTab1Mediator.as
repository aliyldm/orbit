package net.bigpoint.darkorbit.mvc.gui.windows.armoryUnlock.tab1
{
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.com.module.porting.armoryunlock.ArmoryUnlockDrawRequest;
   import net.bigpoint.darkorbit.com.module.porting.events.LootProbabilityModule;
   import net.bigpoint.darkorbit.delete_in_eic.IconVOLoader;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.armoryUnlock.ArmoryUnlockTab;
   import net.bigpoint.darkorbit.mvc.gui.windows.armoryUnlock.handler.ArmoryUnlockInfoData;
   import net.bigpoint.darkorbit.utils.math.FastMath;
   
   public class ArmoryUnlockTab1Mediator extends ArmoryUnlockTab
   {
      
      protected var tips:String = "";
      
      private var tab1:ArmoryUnlockTab1View;
      
      private var icon001:Coreponent;
      
      private var icon003:Coreponent;
      
      private var icon004:Coreponent;
      
      private var label001:Label;
      
      private var explore01Btn:Coreponent;
      
      private var explore10Btn:Coreponent;
      
      private var infoBtn001:Button;
      
      private var infoBtn002:Button;
      
      public function ArmoryUnlockTab1Mediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
      }
      
      public function setView(param1:ArmoryUnlockTab1View) : void
      {
         this.tab1 = param1;
         this.tab1.body.visible = false;
         this.cardsContainer = this.tab1.cardsContainer;
         this.icon001 = this.tab1.icon001;
         this.icon003 = this.tab1.icon003;
         this.icon004 = this.tab1.icon004;
         this.label001 = this.tab1.label001;
         this.explore01Btn = this.tab1.explore01Btn;
         this.explore10Btn = this.tab1.explore10Btn;
         this.explore01Btn.enabled = false;
         this.explore10Btn.enabled = false;
         this.infoBtn001 = this.tab1.infoBtn001;
         this.infoBtn002 = this.tab1.infoBtn002;
      }
      
      public function updateData(param1:ArmoryUnlockInfoData) : void
      {
         var _loc2_:ItemVO = null;
         var _loc4_:LootProbabilityModule = null;
         super.updateData0(param1.normal);
         this.tab1.body.visible = true;
         _loc2_ = ItemDataProviderHelper.getItem(param1.normal.resourceLootId);
         this.infoBtn001.tooltipData = "" + _loc2_.fullname + "\n" + _loc2_.sourceName;
         IconVOLoader.getInstance().loadIcon(this.icon001,_loc2_,"100x100",AssetsProxy.ITEMS);
         IconVOLoader.getInstance().loadIcon(this.icon003,_loc2_,"100x100",AssetsProxy.ITEMS);
         IconVOLoader.getInstance().loadIcon(this.icon004,_loc2_,"100x100",AssetsProxy.ITEMS);
         this.label001.text = " " + param1.normal.resourceAmount;
         this.explore01Btn.addEventListener(MouseEvent.MOUSE_DOWN,this.onExplore01BtnClick);
         this.explore10Btn.addEventListener(MouseEvent.MOUSE_DOWN,this.onExplore10BtnClick);
         this.explore01Btn.enabled = true;
         this.explore10Btn.enabled = true;
         this.tips = "";
         var _loc3_:int = 0;
         while(_loc3_ < param1.normal.probabilityModuleList.length)
         {
            _loc4_ = param1.normal.probabilityModuleList[_loc3_];
            _loc2_ = ItemDataProviderHelper.getItem(_loc4_.lootId);
            if(_loc4_.minLootAmount == _loc4_.maxLootAmount)
            {
               this.tips += _loc2_.fullname + " x" + _loc4_.minLootAmount + " " + FastMath.smartFormat(_loc4_.probabilityPercentage) + "%\n";
            }
            else
            {
               this.tips += _loc2_.fullname + " x " + _loc4_.minLootAmount + "-" + _loc4_.maxLootAmount + " " + FastMath.smartFormat(_loc4_.probabilityPercentage) + "%\n";
            }
            _loc3_++;
         }
         this.infoBtn002.tooltipData = this.tips;
      }
      
      private function removeAllListeners() : void
      {
         this.explore01Btn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onExplore01BtnClick);
         this.explore10Btn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onExplore10BtnClick);
         this.explore01Btn.enabled = false;
         this.explore10Btn.enabled = false;
      }
      
      private function onExplore01BtnClick(param1:MouseEvent) : void
      {
         this.removeAllListeners();
         var _loc2_:ArmoryUnlockDrawRequest = new ArmoryUnlockDrawRequest();
         _loc2_.type = 1;
         _loc2_.count = 1;
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc2_);
      }
      
      private function onExplore10BtnClick(param1:MouseEvent) : void
      {
         this.removeAllListeners();
         var _loc2_:ArmoryUnlockDrawRequest = new ArmoryUnlockDrawRequest();
         _loc2_.type = 1;
         _loc2_.count = 10;
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc2_);
      }
   }
}

