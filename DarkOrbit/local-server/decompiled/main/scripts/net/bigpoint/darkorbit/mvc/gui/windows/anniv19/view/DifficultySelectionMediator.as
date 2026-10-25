package net.bigpoint.darkorbit.mvc.gui.windows.anniv19.view
{
   import com.bigpoint.utils.TextFormatter;
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.com.module.porting.birthday2025.Birthday2025GateEnterRequest;
   import net.bigpoint.darkorbit.com.module.porting.birthday2025.Birthday2025GateWindowCommand;
   import net.bigpoint.darkorbit.com.module.porting.events.EventLootShowCommand;
   import net.bigpoint.darkorbit.delete_in_eic.IconVOLoader;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.dropdownbox.DropDownBox;
   import net.bigpoint.darkorbit.fui.components.list.dropdownbox.DropDownBoxEvent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.anniv19.DifficultySelectionNotification;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.net.JavascriptProxy;
   import net.bigpoint.darkorbit.utils.HtmlTextUtils;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class DifficultySelectionMediator extends SimpleWindowMediator
   {
      
      public static const NAME:String = "DifficultySelectionMediator";
      
      private var _view:DifficultySelectionView;
      
      private var _dropDownBox:DropDownBox;
      
      private var _costNumLabel:Label;
      
      private var _goBtn:Button;
      
      private var _command:Birthday2025GateWindowCommand;
      
      private var _costIcon:Coreponent;
      
      private var _costNameLabel:Label;
      
      private var _costBtn:Button;
      
      public function DifficultySelectionMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         window.addEventListener(SimpleWindowEvent.ON_MAXIMIZED,this.onShowHandler);
         window.addEventListener(SimpleWindowEvent.ON_MINIMIZE,this.onCloseHandler);
      }
      
      private function onShowHandler(param1:SimpleWindowEvent) : void
      {
         if(_uiReady)
         {
            this.updateView();
         }
      }
      
      private function onCloseHandler(param1:SimpleWindowEvent) : void
      {
         this._dropDownBox.forceCollapse();
      }
      
      override public function listNotificationInterests() : Array
      {
         return [DifficultySelectionNotification.UPDATE,DifficultySelectionNotification.CLOSE_WINDOW];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:String = param1.getName();
         switch(_loc2_)
         {
            case DifficultySelectionNotification.UPDATE:
               this._command = param1.getBody() as Birthday2025GateWindowCommand;
               if(_uiReady)
               {
                  this.updateView();
               }
               break;
            case DifficultySelectionNotification.CLOSE_WINDOW:
               guiManager.getWindow(GuiConstants.DIFFICULTY_SELECTION).minimize();
         }
      }
      
      private function getIndexByDifficulty(param1:int) : int
      {
         var _loc2_:Number = Math.log(param1) / Math.LN2;
         return int(_loc2_);
      }
      
      private function updateView() : void
      {
         var _loc1_:int = this.getIndexByDifficulty(this._command.curLevel);
         this._dropDownBox.currentEntry = _loc1_;
         this.updateRewardAndCost();
      }
      
      private function onEventSelected(param1:DropDownBoxEvent) : void
      {
         this.updateRewardAndCost();
         this._goBtn.enabled = 1 << this._dropDownBox.currentEntry <= this._command.curLevel;
      }
      
      private function updateRewardAndCost() : void
      {
         var _loc2_:String = null;
         var _loc7_:ItemVO = null;
         var _loc1_:Boolean = this._command.curLootAmount < this._command.commandList[this._dropDownBox.currentEntry].costAmount;
         if(_loc1_)
         {
            _loc2_ = HtmlTextUtils.coloriseText(16711680,TextFormatter.roundInteger(this._command.curLootAmount));
         }
         else
         {
            _loc2_ = HtmlTextUtils.coloriseText(65280,TextFormatter.roundInteger(this._command.curLootAmount));
         }
         _loc2_ += " /" + this._command.commandList[this._dropDownBox.currentEntry].costAmount;
         this._costNumLabel.useHTML = true;
         this._costNumLabel.text = "" + _loc2_;
         var _loc3_:Vector.<EventLootShowCommand> = this._command.commandList[this._dropDownBox.currentEntry].lootShowCommandList;
         var _loc4_:Vector.<ItemVO> = new Vector.<ItemVO>();
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc7_ = ItemDataProviderHelper.getItem(_loc3_[_loc5_].lootId);
            _loc7_.amount = _loc3_[_loc5_].lootAmount;
            _loc4_.push(_loc7_);
            _loc5_++;
         }
         this._view.rewardList = _loc4_;
         var _loc6_:ItemVO = ItemDataProviderHelper.getItem(this._command.commandList[this._dropDownBox.currentEntry].costLootId);
         if(_loc6_)
         {
            IconVOLoader.getInstance().loadIcon(this._costIcon,_loc6_,"100x100",AssetsProxy.ITEMS);
            this._costNameLabel.text = "" + _loc6_.fullname;
            this._costBtn.tooltipData = "" + _loc6_.sourceName;
         }
      }
      
      private function initViewComponent() : void
      {
         this._view = new DifficultySelectionView(simpleWindow);
         this._dropDownBox = this._view.filterDropBox;
         this._dropDownBox.updateAvailableEntries(new <String>["bday2025_entry_difficulty_1","bday2025_entry_difficulty_2","bday2025_entry_difficulty_4","bday2025_entry_difficulty_8","bday2025_entry_difficulty_16"]);
         this._dropDownBox.addEventListener(DropDownBoxEvent.SELECTED_ENTRY_CHANGED,this.onEventSelected);
         this._costNumLabel = this._view.costNumLabel;
         var _loc1_:Button = this._view.chanceBtn;
         _loc1_.visible = false;
         this._costIcon = this._view.costIcon;
         this._costNameLabel = this._view.costNameLabel;
         this._costBtn = this._view.costHelpBtn;
         this._goBtn = this._view.goBtn;
         this._goBtn.addEventListener(MouseEvent.CLICK,this.onClickHandler);
         this._goBtn.buttonMode = true;
         simpleWindow.removeInprogressOverLay();
         _uiReady = true;
      }
      
      private function onClickHandler(param1:MouseEvent) : void
      {
         if(this._command.curLootAmount < this._command.commandList[this._dropDownBox.currentEntry].costAmount)
         {
            this.goHtmlShop();
         }
         else
         {
            sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new Birthday2025GateEnterRequest(1 << this._dropDownBox.currentEntry));
            guiManager.getWindow(GuiConstants.DIFFICULTY_SELECTION).minimize();
         }
      }
      
      protected function goHtmlShop() : void
      {
         JavascriptProxy.referToURL("internalDock&tpl=internalDockSpecials&shopItem=package_event-deal-galaxy-coupon-s",null);
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this.initViewComponent();
         this.updateView();
      }
   }
}

